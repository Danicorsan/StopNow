import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/user_model.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:stopnow/ui/base/widgets/user_avatar.dart';
import 'package:stopnow/ui/home/home_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    final homeProvider = HomeProvider(user);

    return Scaffold(
      appBar: baseAppBar("Perfil"),
      drawer: baseDrawer(context),
      body: Column(
        children: [
          // Sección de información básica del usuario
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                    child: UserAvatar()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "danics969",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Miembro desde: ${user?.fechaRegistro.year ?? ""}''", // Ejemplo
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          // Sección de estadísticas
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Center(
                    child: Text(
                      "Estadísticas",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          const Divider(),

          // Sección de logros
          const Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Logros 0/12",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
