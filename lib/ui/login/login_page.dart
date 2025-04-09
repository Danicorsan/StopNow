// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/ui/home/home_page.dart';
import 'package:stopnow/ui/login/login_provider.dart';
import 'package:stopnow/data/services/auth_service.dart';
import 'package:stopnow/ui/login/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  bool isPasswordVisible = true;

  //Controladores de texto para el correo y la contraseña
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              SizedBox(
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
                  decoration: InputDecoration(
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
                        color: Color.fromARGB(255, 21, 56, 102),
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color.fromARGB(255, 21, 56, 102),
                    ),
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  obscureText: isPasswordVisible,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 21, 56, 102),
                  fixedSize: Size(250, 50),
                  shadowColor: Color.fromARGB(255, 0, 0, 0),
                  elevation: 5,
                ),
                onPressed: () async {
                  loginProvider.setCorreo(_emailController.text);
                  loginProvider.setPassword(_passwordController.text);
                  await loginProvider.login();
    
                  if (loginProvider.loginState == LoginState.success) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
                  } else if (loginProvider.loginState == LoginState.error) {
                    // Mostrar SnackBar con el error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(loginProvider.errorMessage == ""
                            ? 'Error desconocido'
                            : loginProvider.errorMessage),
                        duration: Duration(seconds: 2),
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
                    ? Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
              ),
              Divider(
                height: 100,
                thickness: 1,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 197, 197, 197),
                  fixedSize: Size(250, 50),
                  shadowColor: Color.fromARGB(255, 21, 56, 102),
                  elevation: 5,
                ),
                onPressed: () {
                  // Handle login action
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
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
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No tienes cuenta?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () => {},
                    child: Text(
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
