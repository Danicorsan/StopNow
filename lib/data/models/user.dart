class UserModel {
  final String nombreUsuario;
  final String fotoPerfil;
  final DateTime fechaDejarFumar;
  final int cigarrosAlDia;
  final int cigarrosPorPaquete;
  final double precioPaquete;

  UserModel({
    required this.nombreUsuario,
    required this.fotoPerfil,
    required this.fechaDejarFumar,
    required this.cigarrosAlDia,
    required this.cigarrosPorPaquete,
    required this.precioPaquete,
  });

  UserModel copyWith({
    String? nombreUsuario,
    String? fotoPerfil,
    DateTime? fechaDejarFumar,
    int? cigarrosAlDia,
    int? cigarrosPorPaquete,
    double? precioPaquete,
  }) {
    return UserModel(
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      fechaDejarFumar: fechaDejarFumar ?? this.fechaDejarFumar,
      cigarrosAlDia: cigarrosAlDia ?? this.cigarrosAlDia,
      cigarrosPorPaquete: cigarrosPorPaquete ?? this.cigarrosPorPaquete,
      precioPaquete: precioPaquete ?? this.precioPaquete,
    );
  }

  factory UserModel.fromSupabase(Map<String, dynamic> json) {
    return UserModel(
      nombreUsuario: json['nombre_usuario'] as String,
      fotoPerfil: json['foto_perfil'] as String,
      fechaDejarFumar: DateTime.parse(json['fecha_dejar_fumar'] as String),
      cigarrosAlDia: json['cigarros_al_dia'] as int,
      cigarrosPorPaquete: json['cigarros_por_paquete'] as int,
      precioPaquete: (json['precio_paquete'] as num).toDouble(),
    );
  }

}