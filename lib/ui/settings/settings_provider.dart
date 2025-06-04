// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';

class SettingsProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> actualizarPerfil({
    required String id,
    required String nombreUsuario,
    required String fotoPerfil,
    required DateTime fechaDejarFumar,
    required int cigarrosAlDia,
    required int cigarrosPorPaquete,
    required double precioPaquete,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();

    final result = await UserRepository.actualizarPerfilUsuario(
      id: id,
      nombreUsuario: nombreUsuario,
      fotoPerfil: fotoPerfil,
      fechaDejarFumar: fechaDejarFumar,
      cigarrosAlDia: cigarrosAlDia,
      cigarrosPorPaquete: cigarrosPorPaquete,
      precioPaquete: precioPaquete,
    );

    if (result is BaseResultSuccess) {
      final user = await UserRepository.usuarioActual();
      if (user != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(user);
      }
      errorMessage = null;
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      errorMessage = result is BaseResultError ? result.message : null;
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
