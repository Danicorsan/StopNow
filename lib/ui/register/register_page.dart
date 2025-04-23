// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/register/register_provider.dart';
import 'package:stopnow/ui/register/register_state.dart';
import 'package:stopnow/utils/validators/validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 9.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
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

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 50.h),
                Image.asset('assets/logo-fondo-blanco.png', height: 250.h),
                Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w100,
                    color: const Color(0xFF153866),
                    shadows: const [
                      Shadow(
                        color: Color.fromARGB(69, 0, 0, 0),
                        offset: Offset(0.0, 6.0),
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                _buildTextField(
                  controller: _userNameController,
                  label: 'Nombre de usuario',
                  icon: Icons.person,
                  onChanged: registerProvider.setNombreUsuario,
                ),
                _buildTextField(
                  controller: _emailController,
                  label: 'Correo',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: registerProvider.setCorreo,
                  validator: (value) => Validator.isValidEmail(value ?? '')
                      ? null
                      : 'Introduce un correo válido',
                ),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  icon: Icons.lock,
                  obscureText: isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF153866),
                    ),
                    onPressed: () =>
                        setState(() => isPasswordVisible = !isPasswordVisible),
                  ),
                  onChanged: registerProvider.setPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Introduce una contraseña';
                    if (!Validator.isValidPassword(value))
                      return 'Debe tener 8 caracteres, mayúscula, minúscula y número';
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar contraseña',
                  icon: Icons.lock,
                  obscureText: isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF153866),
                    ),
                    onPressed: () => setState(() =>
                        isConfirmPasswordVisible = !isConfirmPasswordVisible),
                  ),
                  onChanged: registerProvider.setConfirmPassword,
                  validator: (value) => value == _passwordController.text
                      ? null
                      : 'Las contraseñas no coinciden',
                ),
                _buildTextField(
                  controller: _cigarrosAlDiaController,
                  label: 'Cigarros al día',
                  icon: Icons.smoking_rooms,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => registerProvider
                      .setCigarrosAlDia(int.tryParse(value) ?? 0),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Introduce la cantidad';
                    if (int.tryParse(value) == null)
                      return 'Introduce un número válido';
                    return null;
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                _buildTextField(
                  controller: _fechaDejarDeFumarController,
                  label: 'Fecha dejar de fumar',
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
                      ? 'Introduce una fecha'
                      : null,
                ),
                _buildTextField(
                  controller: _cigarrosPaqueteController,
                  label: 'Cigarros por paquete',
                  icon: Icons.local_fire_department,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => registerProvider
                      .setCigarrosPorPaquete(int.tryParse(value) ?? 0),
                  validator: (value) =>
                      (value == null || int.tryParse(value) == null)
                          ? 'Introduce un número válido'
                          : null,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                _buildTextField(
                  controller: _precioPaqueteController,
                  label: 'Precio por paquete',
                  icon: Icons.euro,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => registerProvider
                      .setPrecioPaquete(double.tryParse(value) ?? 0),
                  validator: (value) =>
                      (value == null || double.tryParse(value) == null)
                          ? 'Introduce un número válido'
                          : null,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF153866),
                    fixedSize: Size(250.w, 50.h),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              const Text('Por favor, revisa todos los campos'),
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
                              ? 'Error desconocido'
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
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                ),
                Divider(height: 100.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿Ya tienes cuenta?',
                        style: TextStyle(fontSize: 15.sp)),
                    SizedBox(width: 10.w),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: Text('Pincha aquí',
                          style: TextStyle(fontSize: 15.sp)),
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
