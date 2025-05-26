import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

Future<void> generarPdfEvaluaciones(
  BuildContext context,
  List<Map<String, dynamic>> historial, {
  String nombreMaterna = "Paciente",
}) async {
  final fontRegular =
      pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Regular.ttf'));
  final fontBold =
      pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Bold.ttf'));
      
  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
    ),
  );
  final now = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd');

  pw.ImageProvider? logoImage;

  try {
    final logoBytes = await rootBundle.load('assets/images/logo.png');
    logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
  } catch (_) {
    logoImage = null;
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (context) {
        return [
          // Encabezado con logo y datos
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
                    pw.Text("Historial Clínico de Signos Vitales",
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.SizedBox(height: 4),
                    pw.Text("Nombre: $nombreMaterna"),
                    pw.Text("Fecha de creación: ${formatter.format(now)}"),
                  ],
                ),
              ),
            ],
          ),
          pw.Divider(thickness: 1),
          pw.SizedBox(height: 10),
          ...historial.map((item) {
            final fecha = item['fecha'];
            final evaluaciones = Map<String, String>.from(item['evaluaciones']);

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
                  pw.SizedBox(height: 4),
                  _filaPdf(
                      "Frecuencia cardíaca",
                      "${item['frecuenciaCardiaca']} bpm",
                      evaluaciones['frecuenciaCardiaca'] ?? ""),
                  _filaPdf("Oxigenación", "${item['oxigenacion']} %",
                      evaluaciones['oxigenacion'] ?? ""),
                  _filaPdf("Temperatura", "${item['temperatura']} °C",
                      evaluaciones['temperatura'] ?? ""),
                ],
              ),
            );
          })
        ];
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

pw.Widget _filaPdf(String label, String valor, String estado) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text("$label:",
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
      pw.Text("$valor • $estado", style: const pw.TextStyle(fontSize: 12)),
    ],
  );
}
