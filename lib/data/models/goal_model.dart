class GoalModel {
  String usuarioId;
  String nombre;
  String descripcion;
  double precio;

  GoalModel({
    required this.usuarioId,
    required this.nombre,
    required this.descripcion,
    required this.precio,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      usuarioId: json['usuario_id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      precio: (json['precio'] as num).toDouble(),
    );
  }
}
