// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/data/providers/theme_provider.dart';
import 'package:stopnow/l10n/l10n.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/calm/calm_provider.dart';
import 'package:stopnow/ui/goals/goals_provider.dart';
import 'package:stopnow/ui/login/login_provider.dart';
import 'package:stopnow/ui/messages/message_provider.dart';
import 'package:stopnow/ui/readings/readings_page.dart';
import 'package:stopnow/ui/readings/readings_provider.dart';
import 'package:stopnow/ui/register/register_provider.dart';
import 'package:stopnow/utils/themes/theme.dart';
import 'package:stopnow/utils/constants/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: SupabaseCredential.url,
    anonKey: SupabaseCredential.anonKey,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => ChatProvider()),
      ChangeNotifierProvider(
        create: (context) => GoalsProvider(),
      ),
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
      ChangeNotifierProvider(create: (_) => ReadingsProvider()),
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
      builder: (_, __) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            initialRoute: AppRoutes.init,
            onGenerateRoute: AppRoutes.generateRoute,
            debugShowCheckedModeBanner: false,
            title: 'StopNow',
            supportedLocales: L10n.all,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            localeResolutionCallback: (locale, supportedLocales) {
              // Usa español si el idioma del dispositivo no es compatible
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return const Locale('es', 'ES');
            },
            //home: LecturaPage(),
          );
        },
      ),
    );
  }
}
