import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
    ),
  );
}

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
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
    ),
  );
}
