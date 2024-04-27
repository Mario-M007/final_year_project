import 'package:final_year_project/services/auth/auth_gate.dart';
import 'package:final_year_project/firebase_options.dart';
import 'package:final_year_project/pages/account_page.dart';
import 'package:final_year_project/pages/home_page.dart';
import 'package:final_year_project/pages/orders_page.dart';
import 'package:final_year_project/pages/search_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, primary: Colors.black),
        useMaterial3: true,
      ),
      home: const AuthGate(),
      initialRoute: '/',
      routes: {
        '/home': (context) => const HomePage(),
        '/search': (context) => const SearchPage(),
        '/orders': (context) => const OrderPage(),
        '/account': (context) => const AccountPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
