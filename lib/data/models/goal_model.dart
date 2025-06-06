class GoalModel {
  final String id;
  final String usuarioId;
  final String nombre;
  final String descripcion;
  final double precio;
  final DateTime fechaCreacion;

  GoalModel({
    this.id = '',
    required this.usuarioId,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.fechaCreacion,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] ?? '',
      usuarioId: json['usuarioId'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      fechaCreacion: DateTime.parse(json['fecha_creado']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuarioId': usuarioId,
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'fecha_creado': fechaCreacion.toUtc().toIso8601String(),
      };
}
