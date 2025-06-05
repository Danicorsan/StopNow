import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stopnow/data/models/reading_model.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReadingsDetailsPage extends StatelessWidget {
  final ReadingModel articulo;

  const ReadingsDetailsPage({super.key, required this.articulo});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: baseAppBar(localizations.lecturas),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text(
              articulo.titulo,
              style: TextStyle(
                color: isDarkMode ? Colors.white : colorScheme.primary,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.porAutorEnFecha(
                  articulo.autor ?? "Desconocido",
                  articulo.fechaCreacion
                      .toLocal()
                      .toIso8601String()
                      .split("T")
                      .first),
              style: TextStyle(
                color: colorScheme.secondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 8.h),
            const Divider(),
            SizedBox(height: 16.h),
            Text(
              articulo.contenido,
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black87,
                fontSize: 17.sp,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
