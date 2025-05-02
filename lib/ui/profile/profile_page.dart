import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: baseAppBar("Perfil"),
      drawer: baseDrawer(context),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                    child: const CircleAvatar(
                      radius: 50,
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                  ),
                  const Text("danics969")
                ],
              )),
          const Divider(),
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Tiempo sin fumar"),
                  SizedBox(
                    height: 100.h,
                  ),
                  const FlutterLogo()
                ],
              )),
          const Divider(),
          const Expanded(flex: 1, child: Center(child: Text("Logros 0/12")))
        ],
      ),
    );
  }
}
