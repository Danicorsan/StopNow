// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/ui/home/home_page.dart';
import 'package:stopnow/ui/login/login_provider.dart';
import 'package:stopnow/ui/login/login_state.dart';

class LoginPage extends StatefulWidget {
  
  String? email = '';
  String? password = '';
  
  LoginPage({super.key, this.email, this.password});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los valores pasados
    setState(() {
      _emailController.text = widget.email ?? '';
      _passwordController.text = widget.password ?? '';
    });
  }

  //Controladores de texto para el correo y la contraseña
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isPasswordVisible = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

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
              //simulando el logo de la app
              Image.asset(
                'assets/logo-fondo-blanco.png',
                height: 250,
              ),
              const Text(
                'Bienvenido',
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
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 21, 56, 102),
                  fixedSize: const Size(250, 50),
                  shadowColor: const Color.fromARGB(255, 0, 0, 0),
                  elevation: 5,
                ),
                onPressed: () async {

                  loginProvider.setCorreo(_emailController.text);
                  loginProvider.setPassword(_passwordController.text);

                  await loginProvider.login();
    
                  if (loginProvider.loginState == LoginState.success) {
                    // Navegar a la página de inicio
                    Navigator.pushReplacementNamed(context, '/home');
                  } else if (loginProvider.loginState == LoginState.error) {
                    // Mostrar SnackBar con el error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(loginProvider.errorMessage == ""
                            ? 'Error desconocido'
                            : loginProvider.errorMessage),
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
                child: loginProvider.loginState == LoginState.loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      )
                    : const Text(
                        'Iniciar Sesión',
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 197, 197, 197),
                  fixedSize: const Size(250, 50),
                  shadowColor: const Color.fromARGB(255, 21, 56, 102),
                  elevation: 5,
                ),
                onPressed: () {
                  // Handle login action
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlutterLogo(
                      size: 30,
                    ),
                    Text(
                      'Continuar con Google',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No tienes cuenta?',
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
                      Navigator.pushReplacementNamed(context, '/register'),
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
