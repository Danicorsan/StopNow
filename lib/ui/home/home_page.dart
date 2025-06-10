import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:stopnow/ui/home/home_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeProvider homeProvider;
  final PageController _pageController = PageController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final user =
          Provider.of<UserProvider>(context, listen: false).currentUser;
      homeProvider = HomeProvider(user, AppLocalizations.of(context)!);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    homeProvider.disposeTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ChangeNotifierProvider<HomeProvider>.value(
      value: homeProvider,
      child: Scaffold(
        drawer: baseDrawer(context),
        appBar: baseAppBar(localizations.inicio),
        body: Consumer<HomeProvider>(
          builder: (context, homeProvider, _) {
            final user = homeProvider.user;
            final fechaDejarFumar = user?.fechaDejarFumar;
            final now = DateTime.now();

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Bienvenida y frase motivadora
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 150.h,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localizations.bienvenidoUsuario(
                              user?.nombreUsuario ?? localizations.usuario),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onBackground,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            '"${homeProvider.getFrase()}"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                              color: colorScheme.onBackground.withOpacity(0.8),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),

                // Si la fecha de dejar de fumar es en el futuro
                fechaDejarFumar!.isAfter(now)
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.w),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.secondary,
                                  colorScheme.primary
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(24.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.hourglass_top,
                                    size: 60.sp, color: colorScheme.onPrimary),
                                SizedBox(height: 20.h),
                                Text(
                                  localizations.dejarasDeFumarEn,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  _formatearTiempoRestante(
                                      fechaDejarFumar, context),
                                  style: TextStyle(
                                    fontSize: 36.sp,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "${localizations.fechaDeDejarFumar}: "
                                  "${DateFormat('dd/MM/yyyy HH:mm').format(fechaDejarFumar.toLocal())}",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color:
                                        colorScheme.onPrimary.withOpacity(0.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10.h),
                                /*
                        Text(
                          _formatearTiempoRestante(fechaDejarFumar, context),
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        */
                              ],
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 300.h,
                              child: PageView(
                                controller: _pageController,
                                children: [
                                  _buildTimerContainer(
                                      homeProvider, localizations, colorScheme),
                                  _buildStatisticCard(
                                    localizations.dineroAhorrado,
                                    "${homeProvider.getDineroAhorrado().toStringAsFixed(2)} €",
                                    Icons.attach_money,
                                    colorScheme,
                                  ),
                                  _buildStatisticCard(
                                    localizations.cigarrosEvitados,
                                    "${homeProvider.getCigarrosEvitados().floor()}",
                                    Icons.smoke_free,
                                    colorScheme,
                                  ),
                                  _buildStatisticCard(
                                    localizations.tiempoDeVidaGanado,
                                    "${homeProvider.getTiempoDeVidaGanado().floor()} ${localizations.min.toLowerCase()}",
                                    Icons.favorite,
                                    colorScheme,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: 4,
                              effect: WormEffect(
                                dotHeight: 10.h,
                                dotWidth: 10.w,
                                spacing: 10.w,
                                activeDotColor: colorScheme.primary,
                                dotColor:
                                    colorScheme.secondary.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ),

                SizedBox(height: 20.h),
                const Divider(),

                // Método de relajación
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        localizations.teEncuentrasConGanasDeFumar,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        localizations.pruebaConNuestroMetodoDeRelajacion,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50.w, vertical: 20.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.calma);
                          },
                          child: Text(
                            localizations.metodoDeRelajacion,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimerContainer(HomeProvider homeProvider,
      AppLocalizations localizations, ColorScheme colorScheme) {
    TextStyle labelStyle = TextStyle(
      fontSize: 12.sp,
      color: colorScheme.onPrimary.withOpacity(0.8),
      fontWeight: FontWeight.w500,
    );

    TextStyle valueStyle = TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.bold,
      color: colorScheme.onPrimary,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          gradient: LinearGradient(
            colors: [colorScheme.secondary, colorScheme.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              localizations.tiempoSinFumar,
              style: TextStyle(
                fontSize: 18.sp,
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white, thickness: 1),
            // Tiempo total (años, meses, días)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeBlock("${homeProvider.getAnios()}",
                    localizations.anios, valueStyle, labelStyle),
                _buildTimeBlock("${homeProvider.getMeses()}",
                    localizations.meses.toLowerCase(), valueStyle, labelStyle),
                _buildTimeBlock("${homeProvider.getDias()}",
                    localizations.dias.toLowerCase(), valueStyle, labelStyle),
              ],
            ),
            const Divider(color: Colors.white, thickness: 1),
            // Tiempo actual (horas, minutos, segundos)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeBlock(
                  homeProvider.getHoras().toString().padLeft(2, '0'),
                  localizations.horas.toLowerCase(),
                  valueStyle,
                  labelStyle,
                ),
                _buildTimeBlock(
                  homeProvider.getMinutos().toString().padLeft(2, '0'),
                  localizations.min.toLowerCase(),
                  valueStyle,
                  labelStyle,
                ),
                _buildTimeBlock(
                  homeProvider.getSegundos().toString().padLeft(2, '0'),
                  localizations.seg.toLowerCase(),
                  valueStyle,
                  labelStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBlock(
      String value, String label, TextStyle valueStyle, TextStyle labelStyle) {
    return Column(
      children: [
        Text(value, style: valueStyle),
        SizedBox(height: 4.h),
        Text(label, style: labelStyle),
      ],
    );
  }

  Widget _buildStatisticCard(
      String title, String value, IconData icon, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          gradient: LinearGradient(
            colors: [colorScheme.secondary, colorScheme.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.sp, color: colorScheme.onPrimary),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatearTiempoRestante(DateTime fecha, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final ahora = DateTime.now();
    final diff = fecha.difference(ahora);

    if (diff.inMinutes < 1) {
      return localizations.menosDeUnMinutoMinuscula;
    } else if (diff.inMinutes < 60) {
      if (diff.inMinutes == 1) {
        return "${diff.inMinutes} ${localizations.minutoMinusculaSingular}";
      }
      return "${diff.inMinutes} ${localizations.minutosMinusculaPlural}";
    } else if (diff.inHours < 24) {
      if (diff.inHours == 1) {
        return "1 ${localizations.horaMinusculaSingular}";
      } else {
        return "${diff.inHours} ${localizations.horasMinusculaPlural}";
      }
    } else {
      final dias = diff.inDays;
      if (dias == 1) {
        return "1 ${localizations.diaMinusculaSingular}";
      } else {
        return "$dias ${localizations.diasMinusculaPlural}";
      }
    }
  }
}
