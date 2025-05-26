import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

Future<void> compartirPdfEvaluaciones(
  List<Map<String, dynamic>> historial, {
  String nombreMaterna = "Paciente",
}) async {
  final fontRegular = pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Regular.ttf'));
  final fontBold = pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Bold.ttf'));

  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
  );

  final now = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd');

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (context) {
        return [
          pw.Text("Evaluaciones de $nombreMaterna",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Text("Exportado: ${formatter.format(now)}"),
          pw.SizedBox(height: 12),
          ...historial.map((item) {
            final fecha = item['fecha'];
            final evaluaciones = Map<String, String>.from(item['evaluaciones']);
            return pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 4),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("🗓 Fecha: $fecha", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Frecuencia cardíaca: ${item['frecuenciaCardiaca']} bpm • ${evaluaciones['frecuenciaCardiaca']}"),
                  pw.Text("Oxigenación: ${item['oxigenacion']} % • ${evaluaciones['oxigenacion']}"),
                  pw.Text("Temperatura: ${item['temperatura']} °C • ${evaluaciones['temperatura']}"),
                ],
              ),
            );
          })
        ];
      },
    ),
  );

  // Guardar PDF a archivo temporal
  final bytes = await pdf.save();
  final tempDir = await getTemporaryDirectory();
  final file = File("${tempDir.path}/Evaluaciones_$nombreMaterna.pdf");
  await file.writeAsBytes(bytes);

  // Compartir el archivo
  await Share.shareXFiles([XFile(file.path)], text: "Historial clínico de $nombreMaterna");
}
