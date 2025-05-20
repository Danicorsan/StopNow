class Achievement {
  final String title;
  final String description;
  final Duration duration; // Tiempo necesario para desbloquear

  Achievement(this.title, this.description, this.duration);
}

final List<Achievement> achievements = [
  Achievement(
      "Primer Respiro",
      "Disminuyen la presión arterial y el ritmo cardíaco. La circulación periférica mejora.",
      const Duration(minutes: 20)),
  Achievement(
      "Pulmones Renovados",
      "Los niveles de oxígeno en sangre aumentan. El monóxido de carbono en sangre disminuye a la mitad.",
      const Duration(hours: 8)),
  Achievement(
      "Aire Limpio",
      "El monóxido de carbono se elimina por completo de la sangre.",
      const Duration(hours: 12)),
  Achievement("Latido Fuerte", "Disminuye el riesgo de sufrir un infarto.",
      const Duration(days: 1)),
  Achievement(
      "Sentidos Despiertos",
      "Comienzan a regenerarse las terminaciones nerviosas. Mejoran el olfato y el gusto.",
      const Duration(days: 2)),
  Achievement(
      "Respira Libre",
      "Los bronquios comienzan a relajarse, mejora la respiración, y aumenta la capacidad pulmonar.",
      const Duration(days: 3)),
  Achievement(
      "Cuerpo Limpio",
      "La nicotina ha sido eliminada casi completamente del cuerpo.",
      const Duration(days: 5)),
  Achievement(
      "Nueva Energía",
      "Se reduce la ansiedad por la abstinencia física. Empiezas a notar más energía.",
      const Duration(days: 7)),
  Achievement(
      "Aliento Renovado",
      "Continúa mejorando la respiración y la limpieza pulmonar.",
      const Duration(days: 10)),
  Achievement(
      "Fluye la Vida",
      "Mejora significativa de la circulación sanguínea y la función pulmonar.",
      const Duration(days: 14)),
  Achievement(
      "Fortaleza Interior",
      "Se reduce la dependencia psicológica. Mayor capacidad para manejar el estrés sin fumar.",
      const Duration(days: 21)),
  Achievement(
      "Renacer",
      "La piel mejora su aspecto. Disminuyen la tos y la fatiga. Se refuerza el sistema inmune.",
      const Duration(days: 30)),
  Achievement(
      "Más Vitalidad",
      "Mejora notable en el sistema respiratorio y la circulación. Más resistencia física.",
      const Duration(days: 60)),
  Achievement(
      "Pulmones Renovados",
      "Se recupera hasta un 30% de la función pulmonar.",
      const Duration(days: 90)),
  Achievement(
      "Adiós a la Tos",
      "Disminuyen notablemente la tos, congestión, y dificultad respiratoria.",
      const Duration(days: 180)),
  Achievement(
      "Corazón Fuerte",
      "El riesgo de enfermedad cardíaca coronaria se reduce a la mitad.",
      const Duration(days: 365)),
  Achievement(
      "Mente Clara",
      "El riesgo de accidente cerebrovascular se iguala al de un no fumador.",
      const Duration(days: 1825)),
  Achievement(
      "Media Meta",
      "El riesgo de cáncer de pulmón es aproximadamente la mitad que el de un fumador.",
      const Duration(days: 3650)),
  Achievement(
      "Victoria Total",
      "El riesgo de enfermedad cardiovascular es igual al de una persona que nunca ha fumado.",
      const Duration(days: 5475)),
];
