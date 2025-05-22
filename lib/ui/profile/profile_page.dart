import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/achievement_model.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:stopnow/ui/base/widgets/user_avatar.dart';
import 'package:stopnow/ui/home/home_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    final homeProvider = HomeProvider(user);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    var achievements = Achievement.getLocalizedAchievements(localizations);

    // Cálculo de logros desbloqueados
    final now = DateTime.now();
    final fechaDejarFumar = user?.fechaDejarFumar ?? now;
    final tiempoSinFumar = now.difference(fechaDejarFumar);
    final unlockedAchievements =
        achievements.where((a) => tiempoSinFumar >= a.duration).toList();

    return Scaffold(
      appBar: baseAppBar(localizations.perfil),
      drawer: baseDrawer(context),
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              child: Row(
                children: [
                  const UserAvatar(),
                  SizedBox(width: 20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.nombreUsuario ?? localizations.usuario,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        localizations.miembroDesde(user?.fechaRegistro.year ?? ""),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colorScheme.onBackground.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: colorScheme.outline.withOpacity(0.5),
              thickness: 2,
              height: 20.h,
            ),
            SizedBox(height: 20.h),

            // Sección de estadísticas
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                color: colorScheme.surface,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Text(
                        localizations.estadisticas,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _buildStatisticRow(
                        localizations.diasSinFumar,
                        "${homeProvider.getDiasSinFumar()} ${localizations.dias}",
                        colorScheme,
                      ),
                      _buildStatisticRow(
                        localizations.cigarrosEvitadosEstadistica,
                        "${homeProvider.getCigarrosEvitados()}",
                        colorScheme,
                      ),
                      _buildStatisticRow(
                        localizations.dineroAhorradoEstadistica,
                        "${homeProvider.getDineroAhorrado()} €",
                        colorScheme,
                      ),
                      _buildStatisticRow(
                        localizations.tiempoVidaGanadoEstadistica,
                        "${(homeProvider.getTiempoDeVidaGanado() / 60).floor()} ${localizations.horas}",
                        colorScheme,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Carrusel de logros conseguidos
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                color: colorScheme.surface,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        localizations.logrosConseguidos,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      unlockedAchievements.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Text(
                                localizations.sinLogros,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 180.h,
                              child: PageView.builder(
                                itemCount: unlockedAchievements.length,
                                controller:
                                    PageController(viewportFraction: 0.85),
                                itemBuilder: (context, index) {
                                  final achievement =
                                      unlockedAchievements[index];
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: colorScheme.secondary.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(18.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorScheme.shadow.withOpacity(0.07),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(18.w),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: colorScheme.secondary,
                                            radius: 28,
                                            child: Icon(Icons.emoji_events,
                                                color: colorScheme.onSecondary, size: 32),
                                          ),
                                          SizedBox(height: 12.h),
                                          Text(
                                            achievement.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.sp,
                                              color: colorScheme.secondary,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          /*
                                          Text(
                                            achievement.description,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: colorScheme.secondary.withOpacity(0.8),
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          */
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticRow(String title, String value, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}