class GoalModel {
  String id;
  String usuarioId;
  String nombre;
  String descripcion;
  double precio;

  GoalModel({
    this.id = '',
    required this.usuarioId,
    required this.nombre,
    required this.descripcion,
    required this.precio,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String? ?? '',
      usuarioId: json['usuario_id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      precio: (json['precio'] as num).toDouble(),
    );
  }
}
