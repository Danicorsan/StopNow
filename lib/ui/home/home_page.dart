import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:stopnow/ui/home/home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeProvider homeProvider;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    homeProvider = HomeProvider(user);
  }

  @override
  void dispose() {
    _pageController.dispose();
    homeProvider.disposeTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>.value(
      value: homeProvider,
      child: Scaffold(
        drawer: baseDrawer(context),
        appBar: baseAppBar("Inicio"),
        body: Consumer<HomeProvider>(
          builder: (context, homeProvider, _) {
            final user = homeProvider.user;

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
                          "Bienvenido, ${user?.nombreUsuario ?? "Usuario"}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
                              color: Colors.black.withOpacity(0.8),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),

                // Estadísticas en tarjetas deslizables
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 300.h,
                        child: PageView(
                          controller: _pageController,
                          children: [
                            _buildTimerContainer(homeProvider),
                            _buildStatisticCard(
                              "Dinero ahorrado",
                              "${homeProvider.getDineroAhorrado()} €",
                              Icons.attach_money,
                            ),
                            _buildStatisticCard(
                              "Cigarros evitados",
                              "${homeProvider.getCigarrosEvitados()}",
                              Icons.smoke_free,
                            ),
                            _buildStatisticCard(
                              "Tiempo de vida ganado",
                              "${homeProvider.getTiempoDeVidaGanado()} minutos",
                              Icons.favorite,
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
                          activeDotColor: Colors.blueAccent,
                          dotColor: Colors.grey.shade400,
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
                        "¿Te encuentras con ganas de fumar?",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        "Prueba con nuestro método de relajación",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF153866),
                            foregroundColor: Colors.white,
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
                            "Método de relajación",
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

  Widget _buildTimerContainer(HomeProvider homeProvider) {
    TextStyle labelStyle = TextStyle(
      fontSize: 12.sp,
      color: Colors.white.withOpacity(0.8),
      fontWeight: FontWeight.w500,
    );

    TextStyle valueStyle = TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF608AAE), Color(0xFF153866)],
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
              "Tiempo sin fumar",
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white, thickness: 1),
            // Tiempo total (años, meses, días)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeBlock("${homeProvider.getAnios()}", "Años",
                    valueStyle, labelStyle),
                _buildTimeBlock("${homeProvider.getMeses()}", "Meses",
                    valueStyle, labelStyle),
                _buildTimeBlock("${homeProvider.getDias()}", "Días", valueStyle,
                    labelStyle),
              ],
            ),
            const Divider(color: Colors.white, thickness: 1),
            // Tiempo actual (horas, minutos, segundos)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeBlock(
                  homeProvider.getHoras().toString().padLeft(2, '0'),
                  "Horas",
                  valueStyle,
                  labelStyle,
                ),
                _buildTimeBlock(
                  homeProvider.getMinutos().toString().padLeft(2, '0'),
                  "Min",
                  valueStyle,
                  labelStyle,
                ),
                _buildTimeBlock(
                  homeProvider.getSegundos().toString().padLeft(2, '0'),
                  "Seg",
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

  Widget _buildStatisticCard(String title, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF608AAE), Color(0xFF153866)],
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
            Icon(icon, size: 40.sp, color: Colors.white),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
