// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/register/register_provider.dart';
import 'package:stopnow/ui/register/register_state.dart';
import 'package:stopnow/utils/validators/validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    var registerProvider = Provider.of<RegisterProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'assets/logo-fondo-blanco.png',
                  height: 250,
                ),
                const Text(
                  'Register',
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w100,
                      color: Color.fromARGB(255, 21, 56, 102),
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(69, 0, 0, 0),
                          offset: Offset(0.0, 6.0),
                          blurRadius: 7.0,
                        ),
                      ]),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: TextFormField(
                    onChanged: (value) =>
                        registerProvider.setNombreUsuario(value),
                    keyboardType: TextInputType.name,
                    controller: _userNameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 21, 56, 102),
                      ),
                      labelText: 'Nombre de usuario',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: TextFormField(
                    onChanged: (value) => registerProvider.setCorreo(value),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 21, 56, 102),
                      ),
                      labelText: 'Correo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    validator: (value) => Validator.isValidEmail(value!)
                        ? null
                        : 'Introduce un correo válido',
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: TextFormField(
                    onChanged: (value) => registerProvider.setPassword(value),
                    keyboardType: TextInputType.visiblePassword,
                    autocorrect: false,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromARGB(255, 21, 56, 102),
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color.fromARGB(255, 21, 56, 102),
                      ),
                      labelText: 'Contraseña',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    obscureText: isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce una contraseña';
                      } else if (!Validator.isValidPassword(value)) {
                        return 'La contraseña debe tener al menos 8 caracteres, una letra mayúscula, una letra minúscula y un número';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: TextFormField(
                    onChanged: (value) =>
                        registerProvider.setConfirmPassword(value),
                    keyboardType: TextInputType.visiblePassword,
                    autocorrect: false,
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromARGB(255, 21, 56, 102),
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color.fromARGB(255, 21, 56, 102),
                      ),
                      labelText: 'Confirmar contraseña',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    obscureText: isConfirmPasswordVisible,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: TextFormField(
                    onChanged: (value) => registerProvider
                        .setCigarrosAlDia(int.tryParse(value) ?? 0),
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    controller: _cigarrosAlDiaController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.numbers,
                        color: Color.fromARGB(255, 21, 56, 102),
                      ),
                      labelText: 'Cigarros al dia',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce la cantidad de cigarros al día';
                      } else if (int.tryParse(value) == null) {
                        return 'Por favor, introduce un número válido';
                      }
                      return null;
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.digitsOnly, // Solo números
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: TextFormField(
                    controller: _fechaDejarDeFumarController,
                    readOnly: true, // Para que no puedan escribir manualmente
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Color.fromARGB(255, 21, 56, 102),
                      ),
                      labelText: 'Fecha dejar de fumar',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(
                          FocusNode()); // Cierra el teclado si está abierto
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        _fechaDejarDeFumarController.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        registerProvider.setFechaDejarFumar(pickedDate);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce la fecha en la que dejarás de fumar';
                      } else if (DateTime.tryParse(value) == null) {
                        return 'Por favor, introduce una fecha válida';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: TextFormField(
                    onChanged: (value) => registerProvider
                        .setCigarrosPorPaquete(int.tryParse(value) ?? 0),
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    controller: _cigarrosPaqueteController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.numbers,
                        color: Color.fromARGB(255, 21, 56, 102),
                      ),
                      labelText: 'Cigarros por paquete',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce la cantidad de cigarros por paquete';
                      } else if (int.tryParse(value) == null) {
                        return 'Por favor, introduce un número válido';
                      }
                      return null;
                    },
                    // Permite solo 3 números
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: TextFormField(
                    onChanged: (value) => registerProvider
                        .setPrecioPaquete(double.tryParse(value) ?? 0),
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    inputFormatters: [
                      // Permite solo 2 decimales y 6 dígitos en total
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    controller: _precioPaqueteController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.euro,
                        color: Color.fromARGB(255, 21, 56, 102),
                      ),
                      labelText: 'Precio por paquete',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce el precio del paquete';
                      } else if (double.tryParse(value) == null) {
                        return 'Por favor, introduce un número válido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 21, 56, 102),
                    fixedSize: const Size(250, 50),
                    shadowColor: const Color.fromARGB(255, 0, 0, 0),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              const Text('Por favor, revisa todos los campos'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: const Color.fromARGB(255, 138, 0, 0),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                      return;
                    }

                    await registerProvider.register();

                    if (registerProvider.registerState ==
                        RegisterState.success) {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.login, arguments: {
                        'email': _emailController.text,
                        'password': _passwordController.text,
                      });
                    } else if (registerProvider.registerState ==
                        RegisterState.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(registerProvider.errorMessage == ""
                              ? 'Error desconocido'
                              : registerProvider.errorMessage),
                          duration: const Duration(seconds: 2),
                          backgroundColor: const Color.fromARGB(255, 138, 0, 0),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                  child: registerProvider.registerState == RegisterState.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        )
                      : const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                ),
                const Divider(
                  height: 100,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ya tienes cuenta?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () => {
                        Navigator.pushReplacementNamed(context, '/login'),
                      },
                      child: const Text(
                        'Pincha aqui',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
