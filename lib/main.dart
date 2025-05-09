// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/calm/calm_provider.dart';
import 'package:stopnow/ui/goals/add/add_goals.dart';
import 'package:stopnow/ui/login/login_provider.dart';
import 'package:stopnow/ui/register/register_provider.dart';
import 'package:stopnow/utils/constants/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: SupabaseCredential.url,
    anonKey: SupabaseCredential.anonKey,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => CalmProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => LoginProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => RegisterProvider(),
      ),
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392.72727272727275, 826.9090909090909),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp(
        //initialRoute: AppRoutes.profile,
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
        title: 'StopNow',
        home: AddGoalsPage(),
      ),
    );
  }
}
