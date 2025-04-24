import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/data/services/auth_service.dart';
import 'package:stopnow/ui/home/home_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Accede al userProvider y al usuario directamente desde el contexto
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;
    final homeProvider = HomeProvider(user);

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.white),
        centerTitle: true,
        title: Text(
          'Inicio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 21, 56, 102),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Mostrar mensaje de bienvenida
          Expanded(
            flex: 1,
            child: Container(
              height: 150.h,
              alignment: Alignment.center,
              child: Text(
                "Bienvenido a la pantalla principal @${user?.nombreUsuario ?? " Usuario"}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Mostrar el tiempo que ha pasado desde que el usuario dejó de fumar
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 8.h),
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
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Mostrar los días, meses y años
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("0"),
                          Text("12"),
                          Text("24"),
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Años"),
                          Text("Meses"),
                          Text("Días"),
                        ],
                      ),
                      // Mostrar los días y horas desde que dejó de fumar
                      Text(
                          "Han pasado: ${homeProvider.getDaysAndHours()} desde que dejaste de fumar."),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Mostrar sugerencia para dejar de fumar
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
          // Botón de tranquilidad
          TextButton(
            onPressed: () {
              print(MediaQuery.of(context).size.width);
              print(MediaQuery.of(context).size.height);
            },
            child: const Text("Botón de tranquilidad"),
          ),
          SizedBox(height: 20.h),
          // Botón de salir
          TextButton(
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false).clearUser();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text("Salir"),
          ),
        ],
      ),
    );
  }
}
