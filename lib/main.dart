import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/ui/login/login_page.dart';
import 'package:stopnow/ui/login/login_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://lobqmpwqesuhavuminux.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxvYnFtcHdxZXN1aGF2dW1pbnV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI5OTIwNDYsImV4cCI6MjA1ODU2ODA0Nn0.iVrfl4GJiePUd5OAOrA6R4ZWEMJFmczGjobBa-x9Nic',
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
