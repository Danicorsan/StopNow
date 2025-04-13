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
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

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
              //simulando el logo de la app
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
                  await registerProvider.register();

                  if (registerProvider.registerState == RegisterState.success) {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.login, arguments: {
                      'email': _emailController.text,
                      'password': _passwordController.text,
                    });
                  } else if (registerProvider.registerState ==
                      RegisterState.error) {
                    // Mostrar SnackBar con el error
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
                    ? Container(
                        width: 20,
                        height: 20,
                        child: const CircularProgressIndicator(
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
                      Navigator.pushNamed(context, '/login'),
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
