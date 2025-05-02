import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildTextField({
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
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 9.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          errorMaxLines: 2,
          prefixIcon: Icon(icon, color: const Color(0xFF153866)),
          labelText: label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
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
      ),
    );
  }