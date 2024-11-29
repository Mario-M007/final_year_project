import 'dart:io';

import 'package:final_year_project/pages/notification_page.dart';
import 'package:final_year_project/services/auth/auth_gate.dart';
import 'package:final_year_project/firebase_options.dart';
import 'package:final_year_project/services/notification/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (Platform.isAndroid) await NotificationService().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MenuMate',
      theme: ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
      navigatorKey: navigatorKey,
      routes: {
        '/notification_page': (context) => const NotificationPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
