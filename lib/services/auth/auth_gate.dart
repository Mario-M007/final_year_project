import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/pages/main_app_view.dart';
import 'package:final_year_project/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          // If logged in, navigate to MainAppView
          return const MainAppView();
        } else {
          // If not logged in, navigate to LoginOrRegister screen
          return const LoginOrRegister();
        }
      },
    );
  }
}
