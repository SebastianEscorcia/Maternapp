class EvaluadorSignosVitales {
  final bool esMaterna;

  EvaluadorSignosVitales({required this.esMaterna});

  String evaluarFrecuenciaCardiaca(double fc) {
    if (fc < 60) return "⚠️ Frecuencia cardíaca baja";
    if (esMaterna && fc > 110) return "⚠️ Frecuencia cardíaca alta para una materna";
    if (!esMaterna && fc > 100) return "⚠️ Frecuencia cardíaca alta";
    return "✅ Frecuencia cardíaca dentro del rango normal";
  }

  String evaluarOxigenacion(double ox) {
    if (ox < 95) return "🟥 Oxigenación baja";
    return "✅ Oxigenación normal";
  }

  String evaluarTemperatura(double temp) {
    if (temp < 36.1) return "⚠️ Temperatura baja";
    if (temp > 37.5) return "⚠️ Posible fiebre o infección";
    return "✅ Temperatura en rango normal";
  }
}
