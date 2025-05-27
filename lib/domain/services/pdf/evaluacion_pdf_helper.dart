import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart' show rootBundle;

class EvaluacionPdfHelper {
  static pw.ImageProvider? _cachedLogo;
  static Future<pw.Font> get _fontRegular async => pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSansSymbols-Regular.ttf'));

  static Future<pw.Font> get _fontEmoji async => pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoColorEmoji-Regular.ttf'));

  static Future<pw.Font> get _fontBold async =>
      pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Bold.ttf'));

  static Future<void> mostrarDialogoGenerandoPDF(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 120,
                child: Lottie.asset(
                  'assets/animations/loading_heart.json',
                  repeat: true,
                ),
              ),
              const SizedBox(height: 12),
              const Text("Espere un momento...",
                  style: TextStyle(fontSize: 16)),
              const Text("Procesando documento",
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> generarPdfEvaluaciones(
    BuildContext context,
    List<Map<String, dynamic>> historial, {
    required String nombreMaterna,
  }) async {
    final pdf = await _crearDocumento(historial, nombreMaterna: nombreMaterna);
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static Future<void> compartirPdfEvaluaciones(
    BuildContext context,
    List<Map<String, dynamic>> historial, {
    required String nombreMaterna,
  }) async {
    final pdf = await _crearDocumento(historial, nombreMaterna: nombreMaterna);
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/Evaluaciones_$nombreMaterna.pdf");
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Historial clínico de $nombreMaterna",
    );
  }

  static Future<pw.Document> _crearDocumento(
    List<Map<String, dynamic>> historial, {
    required String nombreMaterna,
  }) async {
    final fontRegular = await _fontRegular;
    final fontBold = await _fontBold;
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');

    final emojiFont = await _fontEmoji;

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: fontRegular,
        bold: fontBold,
        fontFallback: [emojiFont],
      ),
    );

    final logoImage = await _obtenerLogo();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (logoImage != null)
                  pw.Container(
                    width: 60,
                    height: 60,
                    margin: const pw.EdgeInsets.only(right: 16),
                    child: pw.Image(logoImage),
                  ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Evaluaciones clínicas de $nombreMaterna",
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text("Fecha de exportación: ${formatter.format(now)}"),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            ...historial.map((item) {
              final fecha = item['fecha'];
              final evaluaciones =
                  Map<String, String>.from(item['evaluaciones']);
              return pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 6),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("🗓 Fecha: $fecha",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    _filaPdf(
                        "Frecuencia cardíaca",
                        "${item['frecuenciaCardiaca']} bpm",
                        evaluaciones['frecuenciaCardiaca'] ?? ''),
                    _filaPdf("Oxigenación", "${item['oxigenacion']} %",
                        evaluaciones['oxigenacion'] ?? ''),
                    _filaPdf("Temperatura", "${item['temperatura']} °C",
                        evaluaciones['temperatura'] ?? ''),
                  ],
                ),
              );
            })
          ];
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _filaPdf(String label, String valor, String estado) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text("$label:",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.Text("$valor • $estado", style: const pw.TextStyle(fontSize: 12)),
      ],
    );
  }

  // Hacer que el logo cargue mucho más rápido
  static Future<pw.ImageProvider?> _obtenerLogo() async {
    if (_cachedLogo != null) return _cachedLogo;

    try {
      final logoBytes = await rootBundle.load('assets/images/logo.png');
      _cachedLogo = pw.MemoryImage(logoBytes.buffer.asUint8List());
      return _cachedLogo;
    } catch (_) {
      return null;
    }
  }
}
