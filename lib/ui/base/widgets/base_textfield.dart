import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Campo de texto personalizado con icono, validación y estilo.
Widget baseTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
  bool obscureText = false,
  Widget? suffixIcon,
  void Function(String)? onChanged,
  void Function()? onTap,
  bool readOnly = false,
  List<TextInputFormatter>? inputFormatters,
  ColorScheme? colorScheme,
  required BuildContext context,
}) {
  colorScheme ??= Theme.of(context).colorScheme;
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 9.h),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        errorMaxLines: 2,
        prefixIcon: Icon(icon, color: colorScheme.primary),
        labelText: label,
        labelStyle: TextStyle(color: isDarkMode ? Colors.grey : colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      autocorrect: false,
      style: TextStyle(color: colorScheme.onBackground),
    ),
  );
}
