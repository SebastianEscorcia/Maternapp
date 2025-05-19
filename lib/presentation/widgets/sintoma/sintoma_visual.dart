import 'package:flutter/material.dart';

class SintomaVisual {
  final String id; // ID del documento en Firestore
  final String nombre;
  final IconData icono;
  final Color color;
  final String categoria;

  SintomaVisual({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.color,
    required this.categoria,
  });

  factory SintomaVisual.fromFirestore(String id, Map<String, dynamic> data) {
    return SintomaVisual(
      id: id,
      nombre: data['nombre'] ?? '',
      categoria: data['categoria'] ?? 'Otros',
      icono: _iconoDesdeNombre(data['icono'] ?? 'help'),
      color: _colorDesdeHex(data['color'] ?? '#FFC0CB'), // fallback rosado
    );
  }

  // Convertir string a IconData
  static IconData _iconoDesdeNombre(String nombre) {
    final mapaIconos = {
      "sick": Icons.sick,
      "crisis_alert": Icons.crisis_alert,
      "headphones": Icons.headphones,
      "bedtime": Icons.bedtime,
      "nightlight_round": Icons.nightlight_round,
      "bed": Icons.bed,
      "favorite_border": Icons.favorite_border,
      "mood_bad": Icons.mood_bad,
      "sentiment_satisfied_alt": Icons.sentiment_satisfied_alt,
      "sentiment_dissatisfied": Icons.sentiment_dissatisfied,
      "warning_amber": Icons.warning_amber,
      "bolt": Icons.bolt,
      "cloud": Icons.cloud,
      "block": Icons.block,
      "water_drop": Icons.water_drop,
      "local_fire_department": Icons.local_fire_department,
      "sync_problem": Icons.sync_problem,
      "help": Icons.help,
    };
    return mapaIconos[nombre] ?? Icons.help;
  }

  // Convertir código hexadecimal (#FF0000) a Color
  static Color _colorDesdeHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
