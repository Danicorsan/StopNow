import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Expanded(
                flex: 4,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: const Color.fromARGB(255, 219, 225, 225),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 50.r,
                          offset: Offset(0, 5.h),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(18.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: Image.asset(
                                'assets/logo-fondo-azul.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Text(
                            localizations.bienvenidoStopNow,
                            style: TextStyle(
                              fontSize: 27.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 21, 56, 102),
                              shadows: [
                                Shadow(
                                  color: const Color.fromARGB(69, 0, 0, 0),
                                  offset: Offset(0, 6.h),
                                  blurRadius: 7.r,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 21, 56, 102),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          textStyle: TextStyle(fontSize: 18.sp),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(localizations.iniciarSesion),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 21, 56, 102),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          textStyle: TextStyle(fontSize: 18.sp),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 21, 56, 102)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(localizations.crearCuenta),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
