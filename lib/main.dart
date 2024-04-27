import 'package:final_year_project/pages/account_page.dart';
import 'package:final_year_project/pages/home_page.dart';
import 'package:final_year_project/pages/orders_page.dart';
import 'package:final_year_project/pages/search_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
      home: HomePage(),
      initialRoute: '/',
      routes: {
        '/home': (context) => HomePage(),
        '/search': (context) => SearchPage(),
        '/orders': (context) => OrderPage(),
        '/account': (context) => AccountPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
