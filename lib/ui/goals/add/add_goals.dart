// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:stopnow/ui/register/register_provider.dart';
import 'package:stopnow/ui/register/register_state.dart';
import 'package:stopnow/utils/validators/validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddGoalsPage extends StatefulWidget {
  const AddGoalsPage({super.key});

  @override
  State<AddGoalsPage> createState() => _AddGoalsPageState();
}

class _AddGoalsPageState extends State<AddGoalsPage> {
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

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);

    return Scaffold(
      appBar: baseAppBar("Añadir objetivo"),
      drawer: baseDrawer(context),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.black26,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.add),
                  )),
            ),
            _buildTextField(
              controller: _userNameController,
              label: 'Nombre',
              icon: Icons.workspaces_outlined,
              onChanged: registerProvider.setNombreUsuario,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce el nombre del objetivo';
                }
                if (value.length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _emailController,
              label: 'Descripción',
              icon: Icons.description,
              keyboardType: TextInputType.emailAddress,
              onChanged: registerProvider.setCorreo,
              validator: (value) {
                if (!Validator.isValidEmail(value ?? '')) {
                  return 'Introduce un correo válido';
                }

                return null;
              },
            ),
            _buildTextField(
              controller: _cigarrosAlDiaController,
              label: '¿Cuanto cuesta?',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  registerProvider.setCigarrosAlDia(int.tryParse(value) ?? 0),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce la cantidad';
                }
                if (int.tryParse(value) == null) {
                  return 'Introduce un número válido';
                }
                return null;
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(2),
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, revisa todos los campos'),
                  backgroundColor: Color(0xFF8A0000),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            await registerProvider.register();

            if (registerProvider.registerState == RegisterState.success) {
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
          }),
    );
  }
}
