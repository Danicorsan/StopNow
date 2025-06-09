// ignore_for_file: use_build_context_synchronously,

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';
import 'package:stopnow/ui/base/widgets/base_textfield.dart';
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
    final localizations = AppLocalizations.of(context)!;

    PermissionStatus status;
    if (sdkInt >= 33) {
      status = await Permission.photos.request();
    } else {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.permisoDenegado)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: baseAppBar(
        localizations.crearCuenta,
        volver: true,
        onTap: () async {
          FocusScope.of(context).unfocus();
          await Future.delayed(const Duration(milliseconds: 200));
          Navigator.pop(context);
        },
      ),
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 10.h),
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
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CircleAvatar(
                              radius: 50.r,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : null,
                              backgroundColor: Colors.grey[200],
                              child: _selectedImage == null
                                  ? Icon(Icons.add_a_photo,
                                      size: 30, color: colorScheme.primary)
                                  : null,
                            ),
                            if (_selectedImage != null)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                baseTextField(
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
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                          RegExp(r'\s')), // No permite espacios
                    ],
                    colorScheme: colorScheme,
                    context: context),
                baseTextField(
                    controller: _emailController,
                    label: localizations.correo,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      final lower = value.toLowerCase();
                      if (_emailController.text != lower) {
                        _emailController.value =
                            _emailController.value.copyWith(
                          text: lower,
                          selection:
                              TextSelection.collapsed(offset: lower.length),
                        );
                      }
                      registerProvider.setCorreo(lower);
                    },
                    validator: (value) {
                      if (!Validator.isValidEmail(value ?? '')) {
                        return localizations.correoInvalido;
                      }
                      return null;
                    },
                    colorScheme: colorScheme,
                    context: context),
                baseTextField(
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
                      onPressed: () => setState(
                          () => isPasswordVisible = !isPasswordVisible),
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
                    context: context),
                baseTextField(
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
                    context: context),
                baseTextField(
                    controller: _cigarrosAlDiaController,
                    label: localizations.cigarrosPorDia,
                    icon: Icons.smoking_rooms,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => registerProvider
                        .setCigarrosAlDia(int.tryParse(value) ?? 0),
                    validator: (value) {
                      if (value == null || value.isEmpty || int.tryParse(value) == 0) {
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
                    context: context),
                baseTextField(
                  controller: _fechaDejarDeFumarController,
                  label: localizations.fechaDejarFumar,
                  icon: Icons.calendar_today,
                  readOnly: true,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      DateTime finalDateTime = pickedDate;
                      if (pickedTime != null) {
                        finalDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      }
                      _fechaDejarDeFumarController.text =
                          "${finalDateTime.year}-${finalDateTime.month.toString().padLeft(2, '0')}-${finalDateTime.day.toString().padLeft(2, '0')} "
                          "${finalDateTime.hour.toString().padLeft(2, '0')}:${finalDateTime.minute.toString().padLeft(2, '0')}";
                      registerProvider.setFechaDejarFumar(finalDateTime);
                    }
                  },
                  validator: (value) => (value == null || value.isEmpty)
                      ? localizations.introduceFecha
                      : null,
                  colorScheme: colorScheme,
                  context: context,
                ),
                baseTextField(
                    controller: _cigarrosPaqueteController,
                    label: localizations.cigarrosPorPaquete,
                    icon: Icons.local_fire_department,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => registerProvider
                        .setCigarrosPorPaquete(int.tryParse(value) ?? 0),
                    validator: (value) =>
                        (value == null || int.tryParse(value) == null || int.tryParse(value) == 0)
                            ? localizations.introduceNumeroValido
                            : null,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    colorScheme: colorScheme,
                    context: context),
                baseTextField(
                    controller: _precioPaqueteController,
                    label: localizations.precioPorPaquete,
                    icon: Icons.euro,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => registerProvider
                        .setPrecioPaquete(double.tryParse(value) ?? 0),
                    validator: (value) =>
                        (value == null || double.tryParse(value) == null  || double.tryParse(value) == 0)
                            ? localizations.introduceNumeroValido
                            : null,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    colorScheme: colorScheme,
                    context: context),
                SizedBox(height: 30.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    fixedSize: Size(250.w, 50.h),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    final conexion = await UserRepository.tienesConexion();
                    if (!conexion) {
                      buildErrorMessage(localizations.sinConexion, context);
                      return;
                    }
                    if (registerProvider.registerState ==
                        RegisterState.loading) {
                      return; // Evita múltiples pulsaciones mientras se carga
                    }

                    if (!_formKey.currentState!.validate()) {
                      buildErrorMessage(localizations.revisaCampos, context);
                      return;
                    }

                    await Provider.of<RegisterProvider>(context, listen: false)
                        .setProfileImage(_selectedImage);

                    await registerProvider.register();

                    if (registerProvider.registerState ==
                        RegisterState.success) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.login, (route) => false,
                          arguments: {
                            'email': _emailController.text,
                            'password': _passwordController.text,
                          });
                    } else {
                      if (registerProvider.errorMessage
                          .contains("User already registered")) {
                        buildErrorMessage(localizations.emailEnUso, context);
                        //errorMessage = "El correo electrónico ya está en uso.";
                      } else if (registerProvider.errorMessage
                          .contains("duplicate key value")) {
                        buildErrorMessage(localizations.usuarioEnUso, context);
                        //errorMessage = "El nombre de usuario ya está en uso.";
                      } else if (registerProvider.errorMessage
                          .contains("No address associated with hostname")) {
                        buildErrorMessage(localizations.errorConexion, context);
                        //errorMessage = "Comprueba la conexión.";
                      } else {
                        buildErrorMessage(
                            registerProvider.errorMessage.isEmpty
                                ? localizations.errorDesconocido
                                : registerProvider.errorMessage,
                            context);
                      }
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
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
