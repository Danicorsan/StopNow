import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Acerca de StopNow"),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.asset(
                'assets/logo-fondo-azul.png',
                width: 120.w,
                height: 120.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "StopNow",
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "v0.9.0",
              style: TextStyle(
                color: colorScheme.secondary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24.h),
            Card(
              color: colorScheme.surface.withOpacity(0.95),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: EdgeInsets.all(18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "¿Qué es StopNow?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "StopNow es una aplicación diseñada para ayudarte a dejar de fumar y mejorar tu salud. Lleva un registro de tu progreso, ahorros, logros y te motiva cada día con frases y estadísticas personalizadas.",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Funcionalidades principales:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.secondary,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "• Seguimiento de días sin fumar\n"
                      "• Estadísticas de salud y dinero ahorrado\n"
                      "• Comunidad y chat\n"
                      "• Logros y motivación\n"
                      "• Lecturas y recursos útiles\n"
                      "• Modo claro y oscuro",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Text(
              "Desarrollado por Daniel Cortés Sánchez. - 2025",
              style: TextStyle(
                color: colorScheme.onBackground.withOpacity(0.6),
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
