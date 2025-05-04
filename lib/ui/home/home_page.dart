import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    homeProvider = HomeProvider(user);
  }

  @override
  void dispose() {
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
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 150.h,
                    alignment: Alignment.center,
                    child: Text(
                      "Bienvenido ${user?.nombreUsuario ?? "Usuario"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
                const Divider(),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40.w, vertical: 8.h),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: const Color(0xFF608AAE),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 5.r,
                                offset: Offset(0, 5.h),
                              ),
                            ],
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildTextHora("${homeProvider.getAnios()}"),
                                        _buildTextHora("${homeProvider.getMeses()}"),
                                        _buildTextHora("${homeProvider.getDias()}"),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("Años"),
                                        Text("Meses"),
                                        Text("Días"),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.white, thickness: 1),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildTextHora(
                                            homeProvider.getHoras().toString().padLeft(2, '0')),
                                        _buildTextHora(
                                            homeProvider.getMinutos().toString().padLeft(2, '0')),
                                        _buildTextHora(
                                            homeProvider.getSegundos().toString().padLeft(2, '0')),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("Horas"),
                                        Text("Minutos"),
                                        Text("Segundos"),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Text("****")
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                const Divider(),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        "¿Te encuentras con ganas de fumar?",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        "Prueba con nuestro método de relajación",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            foregroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50.w, vertical: 20.h),
                            textStyle: TextStyle(fontSize: 15.sp),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.calma);
                          },
                          child: const Text("Botón de tranquilidad"),
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

  _buildTextHora(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

}
