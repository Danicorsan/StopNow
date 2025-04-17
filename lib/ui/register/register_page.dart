// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/login/login_page.dart';
import 'package:stopnow/ui/register/register_provider.dart';
import 'package:stopnow/ui/register/register_state.dart';

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
  final TextEditingController _userNameController =
      TextEditingController();
  final TextEditingController _cigarrosAlDiaController = TextEditingController();
  final TextEditingController _fechaDejarDeFumarController = TextEditingController();
  final TextEditingController _cigarrosPaqueteController = TextEditingController();    
  final TextEditingController _precioPaqueteController = TextEditingController();
  
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


  @override
  Widget build(BuildContext context) {
    var registerProvider = Provider.of<RegisterProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
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
                child: TextField(
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
                child: TextField(
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
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: TextField(
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
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: TextField(
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
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
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
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: TextField(
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
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: TextField(
                  controller: _fechaDejarDeFumarController,
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
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: TextField(
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
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: TextField(
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
                  registerProvider.setCorreo(_emailController.text);
                  registerProvider.setPassword(_passwordController.text);
                  registerProvider.setConfirmPassword(
                      _confirmPasswordController.text);
                  registerProvider.setNombreUsuario(_userNameController.text);
                  registerProvider.setFechaDejarFumar(
                      DateTime.parse(_fechaDejarDeFumarController.text));
                  registerProvider.setCigarrosAlDia(int.parse(_cigarrosAlDiaController.text));
                  registerProvider.setCigarrosPorPaquete(int.parse(_cigarrosPaqueteController.text));
                  registerProvider.setPrecioPaquete(double.parse(_precioPaqueteController.text));
                  registerProvider.setFotoEmail(_emailController.text);
                  await registerProvider.register();

                  if (registerProvider.registerState == RegisterState.success) {
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
            ],
          ),
        ),
      ),
    );
  }
}
