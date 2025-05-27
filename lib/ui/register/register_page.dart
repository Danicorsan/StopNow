// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/register/register_provider.dart';
import 'package:stopnow/ui/register/register_state.dart';
import 'package:stopnow/utils/validators/validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _cigarrosAlDiaController =
      TextEditingController();
  final TextEditingController _fechaDejarDeFumarController =
      TextEditingController();
  final TextEditingController _cigarrosPaqueteController =
      TextEditingController();
  final TextEditingController _precioPaqueteController =
      TextEditingController();

  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  File? _selectedImage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _userNameController.dispose();
    _cigarrosAlDiaController.dispose();
    _fechaDejarDeFumarController.dispose();
    _cigarrosPaqueteController.dispose();
    _precioPaqueteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    PermissionStatus status;
    if (sdkInt >= 33) {
      status = await Permission.photos.request();
    } else {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        Provider.of<RegisterProvider>(context, listen: false)
            .setProfileImage(_selectedImage!);
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso denegado')),
      );
    }
  }

  Widget _buildTextField({
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
  }) {
    colorScheme ??= Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 9.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          errorMaxLines: 2,
          prefixIcon: Icon(icon, color: colorScheme.primary),
          labelText: label,
          labelStyle: TextStyle(color: colorScheme.primary),
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

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 50.h),
                Text(
                  localizations.crearCuenta,
                  style: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w100,
                    color: colorScheme.primary,
                    shadows: [
                      Shadow(
                        color: colorScheme.shadow.withOpacity(0.27),
                        offset: const Offset(0.0, 6.0),
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 9.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localizations.fotoDePerfil,
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: colorScheme.onBackground)),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : null,
                          backgroundColor: colorScheme.surfaceVariant,
                          child: _selectedImage == null
                              ? Icon(Icons.add_a_photo,
                                  size: 30, color: colorScheme.primary)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                _buildTextField(
                  controller: _userNameController,
                  label: localizations.nombreUsuario,
                  icon: Icons.person,
                  onChanged: registerProvider.setNombreUsuario,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.introduceNombreUsuario;
                    }
                    if (value.length < 3) {
                      return localizations.nombreMinimoCaracteres;
                    }
                    return null;
                  },
                  colorScheme: colorScheme,
                ),
                _buildTextField(
                  controller: _emailController,
                  label: localizations.correo,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: registerProvider.setCorreo,
                  validator: (value) {
                    if (!Validator.isValidEmail(value ?? '')) {
                      return localizations.correoInvalido;
                    }
                    return null;
                  },
                  colorScheme: colorScheme,
                ),
                _buildTextField(
                  controller: _passwordController,
                  label: localizations.contrasenia,
                  icon: Icons.lock,
                  obscureText: isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: colorScheme.primary,
                    ),
                    onPressed: () =>
                        setState(() => isPasswordVisible = !isPasswordVisible),
                  ),
                  onChanged: registerProvider.setPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.introduceContrasenia;
                    }
                    if (!Validator.isValidPassword(value)) {
                      return localizations.requisitosContrasenia;
                    }
                    return null;
                  },
                  colorScheme: colorScheme,
                ),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: localizations.confirmarContrasenia,
                  icon: Icons.lock,
                  obscureText: isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: colorScheme.primary,
                    ),
                    onPressed: () => setState(() =>
                        isConfirmPasswordVisible = !isConfirmPasswordVisible),
                  ),
                  onChanged: registerProvider.setConfirmPassword,
                  validator: (value) => value == _passwordController.text
                      ? null
                      : localizations.contraseniasNoCoinciden,
                  colorScheme: colorScheme,
                ),
                _buildTextField(
                  controller: _cigarrosAlDiaController,
                  label: localizations.cigarrosPorDia,
                  icon: Icons.smoking_rooms,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => registerProvider
                      .setCigarrosAlDia(int.tryParse(value) ?? 0),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.introduceCantidad;
                    }
                    if (int.tryParse(value) == null) {
                      return localizations.introduceNumeroValido;
                    }
                    return null;
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  colorScheme: colorScheme,
                ),
                _buildTextField(
                  controller: _fechaDejarDeFumarController,
                  label: localizations.fechaDejarFumar,
                  icon: Icons.calendar_today,
                  readOnly: true,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      _fechaDejarDeFumarController.text =
                          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      registerProvider.setFechaDejarFumar(picked);
                    }
                  },
                  validator: (value) => (value == null || value.isEmpty)
                      ? localizations.introduceFecha
                      : null,
                  colorScheme: colorScheme,
                ),
                _buildTextField(
                  controller: _cigarrosPaqueteController,
                  label: localizations.cigarrosPorPaquete,
                  icon: Icons.local_fire_department,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => registerProvider
                      .setCigarrosPorPaquete(int.tryParse(value) ?? 0),
                  validator: (value) =>
                      (value == null || int.tryParse(value) == null)
                          ? localizations.introduceNumeroValido
                          : null,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  colorScheme: colorScheme,
                ),
                _buildTextField(
                  controller: _precioPaqueteController,
                  label: localizations.precioPorPaquete,
                  icon: Icons.euro,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => registerProvider
                      .setPrecioPaquete(double.tryParse(value) ?? 0),
                  validator: (value) =>
                      (value == null || double.tryParse(value) == null)
                          ? localizations.introduceNumeroValido
                          : null,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  colorScheme: colorScheme,
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    fixedSize: Size(250.w, 50.h),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.revisaCampos),
                          backgroundColor: const Color(0xFF8A0000),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    await registerProvider.register();

                    if (registerProvider.registerState ==
                        RegisterState.success) {
                      Navigator.pushReplacementNamed(context, AppRoutes.login,
                          arguments: {
                            'email': _emailController.text,
                            'password': _passwordController.text,
                          });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(registerProvider.errorMessage.isEmpty
                              ? localizations.errorDesconocido
                              : registerProvider.errorMessage),
                          backgroundColor: const Color(0xFF8A0000),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: registerProvider.registerState == RegisterState.loading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Text(
                          localizations.crearCuenta,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w300,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                ),
                Divider(
                  height: 100.h,
                  color: colorScheme.outline.withOpacity(0.2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(localizations.yaTienesCuenta,
                        style: TextStyle(
                            fontSize: 15.sp, color: colorScheme.onBackground)),
                    SizedBox(width: 10.w),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: Text(localizations.pinchaAqui,
                          style: TextStyle(
                              fontSize: 15.sp, color: colorScheme.primary)),
                    ),
                  ],
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
