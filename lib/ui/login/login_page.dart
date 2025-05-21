// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/ui/login/login_provider.dart';
import 'package:stopnow/ui/login/login_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  String? email = '';
  String? password = '';

  LoginPage({super.key, this.email, this.password});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email ?? '';
    _passwordController.text = widget.password ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Image.asset(
                'assets/logo-fondo-blanco.png',
                height: 250.h,
              ),
              Text(
                localizations.bienvenido,
                style: TextStyle(
                  fontSize: 35.sp,
                  fontWeight: FontWeight.w100,
                  color: const Color.fromARGB(255, 21, 56, 102),
                  shadows: [
                    Shadow(
                      color: const Color.fromARGB(69, 0, 0, 0),
                      offset: Offset(0, 6.h),
                      blurRadius: 7.r,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 21, 56, 102),
                    ),
                    labelText: localizations.correo,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
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
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color.fromARGB(255, 21, 56, 102),
                    ),
                    labelText: localizations.contrasenia,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  obscureText: isPasswordVisible,
                ),
              ),
              SizedBox(height: 30.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 21, 56, 102),
                  fixedSize: Size(250.w, 50.h),
                  shadowColor: Colors.black,
                  elevation: 5,
                ),
                onPressed: () async {
                  loginProvider.setCorreo(_emailController.text);
                  loginProvider.setPassword(_passwordController.text);

                  await loginProvider.login(context);

                  if (loginProvider.loginState == LoginState.success) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else if (loginProvider.loginState == LoginState.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          loginProvider.errorMessage == ""
                              ? localizations.errorDesconocido
                              : loginProvider.errorMessage,
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: const Color.fromARGB(255, 138, 0, 0),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    );
                  }
                },
                child: loginProvider.loginState == LoginState.loading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        localizations.iniciarSesion,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
              ),
              Divider(
                height: 100.h,
                thickness: 1,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 197, 197, 197),
                  fixedSize: Size(250.w, 50.h),
                  shadowColor: const Color.fromARGB(255, 21, 56, 102),
                  elevation: 5,
                ),
                onPressed: () {
                  // Futuro login con Google
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlutterLogo(size: 30.sp),
                    Text(
                      'Continuar con Google',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.noTienesCuenta,
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  TextButton(
                    onPressed: () => {
                      Navigator.pushReplacementNamed(context, '/register'),
                    },
                    child: Text(
                      localizations.pinchaAqui,
                      style: TextStyle(
                        fontSize: 15.sp,
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
