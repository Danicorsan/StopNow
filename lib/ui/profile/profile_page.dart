import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:stopnow/ui/base/widgets/user_avatar.dart';
import 'package:stopnow/ui/home/home_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    final homeProvider = HomeProvider(user);

    return Scaffold(
      appBar: baseAppBar("Perfil"),
      drawer: baseDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sección de información del usuario
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
                        user?.nombreUsuario ?? "Usuario",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Miembro desde: ${user?.fechaRegistro.year ?? ""}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black.withOpacity(0.5),
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
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Text(
                        "Estadísticas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF153866),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _buildStatisticRow(
                        "Tiempo sin fumar:",
                        "${homeProvider.getAnios()} años, ${homeProvider.getMeses()} meses, ${homeProvider.getDias()} días",
                      ),
                      _buildStatisticRow(
                        "Cigarros evitados:",
                        "${homeProvider.getCigarrosEvitados()}",
                      ),
                      _buildStatisticRow(
                        "Dinero ahorrado:",
                        "${homeProvider.getDineroAhorrado()} €",
                      ),
                      _buildStatisticRow(
                        "Tiempo de vida ganado:",
                        "${homeProvider.getTiempoDeVidaGanado()} m",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Sección de logros
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Logros",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF153866),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "0/12",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF608AAE),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "¡Sigue avanzando para desbloquear más logros!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
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

  Widget _buildStatisticRow(String title, String value) {
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
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF153866),
            ),
          ),
        ],
      ),
    );
  }
}
