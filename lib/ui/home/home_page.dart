import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
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
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Inicio',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 21, 56, 102),
          elevation: 0,
        ),
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
                      "Bienvenido a la pantalla principal @${user?.nombreUsuario ?? "Usuario"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 8.h),
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
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("${homeProvider.getAnios()}"),
                                Text("${homeProvider.getMeses()}"),
                                Text("${homeProvider.getDias()}"),
                              ],
                            ),
                            const Divider(color: Colors.black, thickness: 1),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Años"),
                                Text("Meses"),
                                Text("Días"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("${homeProvider.getHoras()}h"),
                                Text("${homeProvider.getMinutos()}m"),
                                Text("${homeProvider.getSegundos()}s"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
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
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                TextButton(
                  onPressed: () {
                    print(MediaQuery.of(context).size.width);
                    print(MediaQuery.of(context).size.height);
                  },
                  child: const Text("Botón de tranquilidad"),
                ),
                SizedBox(height: 20.h),
                TextButton(
                  onPressed: () {
                    Provider.of<UserProvider>(context, listen: false)
                        .clearUser();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text("Salir"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
