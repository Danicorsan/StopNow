import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stopnow/data/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            flex: 1,
            child: Container(
              height: 150.h,
              alignment: Alignment.center,
              child: Text(
                "Bienvenido a la pantalla principal",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
          SizedBox(height: 20.h),
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
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                      )
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
              _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text("Salir"),
          ),
        ],
      ),
    );
  }
}
