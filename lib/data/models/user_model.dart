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

  factory UserModel.fromSupabase(Map<String, dynamic> json) {

    print(json['fecha_dejar_fumar'] != null
          ? DateTime.tryParse(json['fecha_dejar_fumar'] as String) ??
              DateTime.now():DateTime.now());

    return UserModel(
      nombreUsuario: json['nombre_usuario'] as String? ?? 'Usuario desconocido',
      fotoPerfil: json['foto_perfil'] as String? ?? '',
      fechaDejarFumar: json['fecha_dejar_fumar'] != null
          ? DateTime.tryParse(json['fecha_dejar_fumar'] as String)?.toLocal() ??
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

  @override
  String toString() {
    return 'UserModel(nombreUsuario: $nombreUsuario, fotoPerfil: $fotoPerfil, fechaDejarFumar: $fechaDejarFumar, cigarrosAlDia: $cigarrosAlDia, cigarrosPorPaquete: $cigarrosPorPaquete, precioPaquete: $precioPaquete)';
  }
}
