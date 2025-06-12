import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Muestra un mensaje de error en la parte inferior de la pantalla
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildErrorMessage(
    String mensaje, BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensaje == "" ? localizations.errorDesconocido : mensaje,
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: const Color.fromARGB(255, 138, 0, 0),
      behavior: SnackBarBehavior.fixed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))
      ),
    ),
  );
}

/// Muestra un mensaje correcto en la parte inferior de la pantalla
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSuccesMessage(
    String mensaje, BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensaje == "" ? localizations.conExito : mensaje,
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: const Color.fromARGB(255, 5, 138, 0),
      behavior: SnackBarBehavior.fixed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))
      ),
    ),
  );
}
