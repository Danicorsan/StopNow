import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildErrorMessage(
    String mensaje, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensaje == "" ? 'Error desconocido' : mensaje,
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
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensaje == "" ? '¡Con exito!' : mensaje,
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
