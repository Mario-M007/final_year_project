import 'package:final_year_project/services/auth/login_or_register.dart';
import 'package:final_year_project/widgets/bottom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return CustomBottomAppBar();
          }

          //user is logged out
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
