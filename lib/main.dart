import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/ui/login/login_page.dart';
import 'package:stopnow/ui/login/login_provider.dart';
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
        create: (context) => LoginProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StopNow',
      home: LoginPage(),
    );
  }
}
