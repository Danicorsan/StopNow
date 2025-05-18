class Achievement {
  final String title;
  final String description;
  final Duration duration; // Tiempo necesario para desbloquear

  Achievement(this.title, this.description, this.duration);
}

final List<Achievement> achievements = [
  Achievement(
      "20 minutos",
      "Disminuyen la presión arterial y el ritmo cardíaco. La circulación periférica mejora.",
      const Duration(minutes: 20)),
  Achievement(
      "8 horas",
      "Los niveles de oxígeno en sangre aumentan. El monóxido de carbono en sangre disminuye a la mitad.",
      const Duration(hours: 8)),
  Achievement(
      "12 horas",
      "El monóxido de carbono se elimina por completo de la sangre.",
      const Duration(hours: 12)),
  Achievement("1 día", "Disminuye el riesgo de sufrir un infarto.",
      const Duration(days: 1)),
  Achievement(
      "2 días",
      "Comienzan a regenerarse las terminaciones nerviosas. Mejoran el olfato y el gusto.",
      const Duration(days: 2)),
  Achievement(
      "3 días",
      "Los bronquios comienzan a relajarse, mejora la respiración, y aumenta la capacidad pulmonar.",
      const Duration(days: 3)),
  Achievement(
      "5 días",
      "La nicotina ha sido eliminada casi completamente del cuerpo.",
      const Duration(days: 5)),
  Achievement(
      "1 semana",
      "Se reduce la ansiedad por la abstinencia física. Empiezas a notar más energía.",
      const Duration(days: 7)),
  Achievement(
      "10 días",
      "Continúa mejorando la respiración y la limpieza pulmonar.",
      const Duration(days: 10)),
  Achievement(
      "2 semanas",
      "Mejora significativa de la circulación sanguínea y la función pulmonar.",
      const Duration(days: 14)),
  Achievement(
      "21 días",
      "Se reduce la dependencia psicológica. Mayor capacidad para manejar el estrés sin fumar.",
      const Duration(days: 21)),
  Achievement(
      "1 mes",
      "La piel mejora su aspecto. Disminuyen la tos y la fatiga. Se refuerza el sistema inmune.",
      const Duration(days: 30)),
  Achievement(
      "2 meses",
      "Mejora notable en el sistema respiratorio y la circulación. Más resistencia física.",
      const Duration(days: 60)),
  Achievement("3 meses", "Se recupera hasta un 30% de la función pulmonar.",
      const Duration(days: 90)),
  Achievement(
      "6 meses",
      "Disminuyen notablemente la tos, congestión, y dificultad respiratoria.",
      const Duration(days: 180)),
  Achievement(
      "1 año",
      "El riesgo de enfermedad cardíaca coronaria se reduce a la mitad.",
      const Duration(days: 365)),
  Achievement(
      "5 años",
      "El riesgo de accidente cerebrovascular se iguala al de un no fumador.",
      const Duration(days: 1825)),
  Achievement(
      "10 años",
      "El riesgo de cáncer de pulmón es aproximadamente la mitad que el de un fumador.",
      const Duration(days: 3650)),
  Achievement(
      "15 años",
      "El riesgo de enfermedad cardiovascular es igual al de una persona que nunca ha fumado.",
      const Duration(days: 5475)),
];
