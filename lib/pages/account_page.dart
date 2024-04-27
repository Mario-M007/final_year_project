import 'package:final_year_project/services/auth/auth_service.dart';
import 'package:final_year_project/widgets/bottom_app_bar.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  void logOut() {
    final _authService = AuthService();
    _authService.signOut();
    print('signed out');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 15, end: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 18),
                child: TextButton(
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  onPressed: () {},
                  child: Text(
                    "John Doe",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
                child: TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Icon(Icons.help),
                      Text(
                        "Help",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    const Icon(Icons.settings),
                    Text(
                      "Settings",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
                child: TextButton(
                  onPressed: () {
                    logOut();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.logout),
                      Text(
                        "Log Out",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }
}
