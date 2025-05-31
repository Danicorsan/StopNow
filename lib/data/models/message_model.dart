class MessageModel {
  final String id;
  final String usuarioId;
  final String nombreUsuario;
  final String mensaje;
  final DateTime fechaEnvio;
  final String? fotoPerfil;

  MessageModel({
    required this.id,
    required this.usuarioId,
    required this.nombreUsuario,
    required this.mensaje,
    required this.fechaEnvio,
    this.fotoPerfil,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      usuarioId: map['usuario_id'],
      nombreUsuario: map['nombre_usuario'],
      mensaje: map['mensaje'],
      fechaEnvio: DateTime.parse(map['fecha_envio']),
      fotoPerfil: map['foto_perfil'], // NUEVO
    );
  }
}