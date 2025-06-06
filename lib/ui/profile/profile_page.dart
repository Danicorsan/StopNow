// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/achievement_model.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';
import 'package:stopnow/ui/base/widgets/user_avatar.dart';
import 'package:stopnow/ui/home/home_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'profile_provider.dart';

class ProfilePage extends StatefulWidget {
  final String? userId; // Si es null, muestra el usuario actual

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProfileProvider>(context, listen: false)
          .loadUser(context, userId: widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final userToShow = profileProvider.userToShow;
    final isLoading = profileProvider.isLoading;

    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading || userToShow == null) {
      return Scaffold(
        appBar: baseAppBar(localizations.perfil),
        backgroundColor: colorScheme.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final homeProvider = HomeProvider(userToShow);
    var achievements = AchievementModel.getLocalizedAchievements(localizations);

    final now = DateTime.now();
    final fechaDejarFumar = userToShow.fechaDejarFumar;
    final tiempoSinFumar = now.difference(fechaDejarFumar);
    final unlockedAchievements =
        achievements.where((a) => tiempoSinFumar >= a.duration).toList();

    return Scaffold(
      appBar: baseAppBar(localizations.perfil, actions: [
        if (widget.userId == null)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final conexion = await UserRepository.tienesConexion();
              if (!conexion) {
                buildErrorMessage(localizations.sinConexion, context);
                return;
              }

              Navigator.pushNamed(context, AppRoutes.settingsAcount)
                  .then((value) {
                // Recargar el perfil después de editar
                Provider.of<ProfileProvider>(context, listen: false)
                    .loadUser(context);
              });
            },
          ),
      ]),
      drawer: widget.userId == null ? baseDrawer(context) : null,
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              child: Row(
                children: [
                  UserAvatar(avatarUrl: userToShow.fotoPerfil),
                  SizedBox(width: 20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userToShow.nombreUsuario,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        localizations
                            .miembroDesde(userToShow.fechaRegistro.year),
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
                      if (fechaDejarFumar.isAfter(now))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              profileProvider.isCurrentUser
                                  ? localizations.cuandoDejesDeFumar
                                  : localizations.usuarioNoHaDejadoFumar,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: colorScheme.onSurface.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else ...[
                        _buildStatisticRow(
                          localizations.tiempoSinFumar,
                          formatTiempoSinFumar(homeProvider, localizations),
                          colorScheme,
                        ),
                        _buildStatisticRow(
                          localizations.cigarrosEvitadosEstadistica,
                          "${homeProvider.getCigarrosEvitados().floor()} ${localizations.cigarros}",
                          colorScheme,
                        ),
                        _buildStatisticRow(
                          localizations.dineroAhorradoEstadistica,
                          "${homeProvider.getDineroAhorrado().toStringAsFixed(2)} €",
                          colorScheme,
                        ),
                        _buildStatisticRow(
                          localizations.tiempoVidaGanadoEstadistica,
                          formatTiempoGanado(homeProvider, localizations),
                          colorScheme,
                        ),
                      ]
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
                                profileProvider.isCurrentUser
                                    ? localizations.sinLogros
                                    : localizations.usuarioSinLogros,
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
                                  return GestureDetector(
                                    onTap: () {
                                      _showAchievementDialog(
                                          context,
                                          achievement,
                                          localizations,
                                          colorScheme);
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        //TODO: cambiar color del fonodo
                                        color: colorScheme.secondary
                                            .withOpacity(0.08),
                                        borderRadius:
                                            BorderRadius.circular(18.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: colorScheme.shadow
                                                .withOpacity(0.07),
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
                                              backgroundColor:
                                                  colorScheme.secondary,
                                              radius: 28,
                                              child: Icon(Icons.emoji_events,
                                                  color:
                                                      colorScheme.onSecondary,
                                                  size: 32),
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

  String formatTiempoSinFumar(
      HomeProvider homeProvider, AppLocalizations localizations) {
    final dias = homeProvider.getDiasSinFumar();
    final horas = homeProvider.getHoras();
    final minutos = homeProvider.getMinutos();

    if (dias > 0) {
      return "$dias ${localizations.dias}";
    } else if (horas > 0) {
      return "$horas ${localizations.horas}";
    } else {
      return "$minutos ${localizations.min}";
    }
  }

  String formatTiempoGanado(
      HomeProvider homeProvider, AppLocalizations localizations) {
    final dias = homeProvider.getTiempoDeVidaGanado() ~/
        1440; // Convertir minutos a días
    final horas = (homeProvider.getTiempoDeVidaGanado() % 1440) ~/
        60; // Resto de minutos a horas
    final minutos =
        homeProvider.getTiempoDeVidaGanado() % 60; // Resto de minutos

    if (dias > 0) {
      return "${dias.floor()} ${localizations.dias}";
    } else if (horas > 0) {
      return "${horas.floor()} ${localizations.horas}";
    } else {
      return "${minutos.floor()} ${localizations.min}";
    }
  }

  Widget _buildStatisticRow(
      String title, String value, ColorScheme colorScheme) {
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

  void _showAchievementDialog(
      BuildContext context,
      AchievementModel achievement,
      AppLocalizations localizations,
      colorScheme) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: isDarkMode
              ? const Color.fromARGB(255, 55, 55, 55)
              : const Color.fromARGB(255, 230, 230, 230),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.secondary,
                  radius: 36,
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: colorScheme.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(localizations.cerrar),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
