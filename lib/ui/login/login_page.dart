// ignore_for_file: use_build_context_synchronously, must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';
import 'package:stopnow/ui/base/widgets/base_textfield.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: baseAppBar(localizations.iniciarSesion),
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/logo-fondo-blanco.png',
                height: 250.h,
              ),
              Text(
                localizations.bienvenido,
                style: TextStyle(
                  fontSize: 35.sp,
                  fontWeight: FontWeight.w100,
                  color: colorScheme.primary,
                  shadows: [
                    Shadow(
                      color: colorScheme.shadow.withOpacity(0.27),
                      offset: Offset(0, 6.h),
                      blurRadius: 7.r,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              baseTextField(
                  controller: _emailController,
                  label: localizations.correo,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  context: context,
                  colorScheme: colorScheme,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ]),
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
                    onPressed: () =>
                        setState(() => isPasswordVisible = !isPasswordVisible),
                  ),
                  colorScheme: colorScheme,
                  context: context),
              SizedBox(height: 30.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  fixedSize: Size(250.w, 50.h),
                  shadowColor: colorScheme.shadow,
                  elevation: 5,
                ),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  final conexion = await UserRepository.tienesConexion();
                  if (!conexion) {
                    buildErrorMessage(localizations.sinConexion, context);
                    return;
                  }
                  if (loginProvider.loginState == LoginState.loading) {
                    return; // Evita múltiples pulsaciones mientras se carga
                  }

                  loginProvider.setCorreo(_emailController.text);
                  loginProvider.setPassword(_passwordController.text);

                  await loginProvider.login(context);

                  if (loginProvider.loginState == LoginState.success) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else if (loginProvider.loginState == LoginState.error) {
                    buildErrorMessage(loginProvider.errorMessage, context);
                  }
                },
                child: loginProvider.loginState == LoginState.loading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        localizations.iniciarSesion,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w300,
                          color: colorScheme.onPrimary,
                        ),
                      ),
              ),
              Divider(
                height: 100.h,
                thickness: 1,
                color: colorScheme.outline.withOpacity(0.2),
              ),
              /*
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.surfaceVariant,
                  fixedSize: Size(250.w, 50.h),
                  shadowColor: colorScheme.shadow,
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
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),*/
              //SizedBox(height: 25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.noTienesCuenta,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: colorScheme.onBackground,
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
                        color: colorScheme.primary,
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
