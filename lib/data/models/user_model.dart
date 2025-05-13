import 'package:flutter/material.dart';

class UserModel {
  final String nombreUsuario;
  final String fotoPerfil;
  final DateTime fechaDejarFumar;
  final int cigarrosAlDia;
  final int cigarrosPorPaquete;
  final double precioPaquete;
  final DateTime fechaRegistro;

  UserModel({
    required this.nombreUsuario,
    required this.fotoPerfil,
    required this.fechaDejarFumar,
    required this.cigarrosAlDia,
    required this.cigarrosPorPaquete,
    required this.precioPaquete,
    required this.fechaRegistro,
  });

  UserModel copyWith({
    String? nombreUsuario,
    String? fotoPerfil,
    DateTime? fechaDejarFumar,
    int? cigarrosAlDia,
    int? cigarrosPorPaquete,
    double? precioPaquete,
    DateTime? fechaRegistro,
  }) {
    return UserModel(
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      fechaDejarFumar: fechaDejarFumar ?? this.fechaDejarFumar,
      cigarrosAlDia: cigarrosAlDia ?? this.cigarrosAlDia,
      cigarrosPorPaquete: cigarrosPorPaquete ?? this.cigarrosPorPaquete,
      precioPaquete: precioPaquete ?? this.precioPaquete,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }

  factory UserModel.fromSupabase(Map<String, dynamic> json) {
    return UserModel(
      nombreUsuario: json['nombre_usuario'] as String? ?? 'Usuario desconocido',
      fotoPerfil: json['foto_perfil'] as String? ?? '',
      fechaDejarFumar: json['fecha_dejar_fumar'] != null
          ? DateTime.tryParse(json['fecha_dejar_fumar'] as String) ??
              DateTime.now()
          : DateTime.now(),
      cigarrosAlDia: json['cigarros_al_dia'] as int? ?? 0,
      cigarrosPorPaquete: json['cigarros_por_paquete'] as int? ?? 0,
      precioPaquete: (json['precio_paquete'] as num?)?.toDouble() ?? 0.0,
      fechaRegistro: json['fecha_registro'] != null
          ? DateTime.tryParse(json['fecha_registro'] as String) ??
              DateTime.now()
          : DateTime.now(),
    );
  }

  Widget getFotoPerfil() {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey,
      child: Icon(Icons.person, size: 50),
    );
  }

  @override
  String toString() {
    return 'UserModel(nombreUsuario: $nombreUsuario, fotoPerfil: $fotoPerfil, fechaDejarFumar: $fechaDejarFumar, cigarrosAlDia: $cigarrosAlDia, cigarrosPorPaquete: $cigarrosPorPaquete, precioPaquete: $precioPaquete)';
  }
}
