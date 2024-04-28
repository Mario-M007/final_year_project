import 'dart:developer';

import 'package:final_year_project/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _displayName = '';

  @override
  void initState() {
    super.initState();
    _loadDisplayName();
  }

  Future<void> _loadDisplayName() async {
    final authService = AuthService();
    final displayName = await authService.getUserDisplayName();
    setState(() {
      _displayName = displayName!;
    });
  }

  void logOut(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signOut();
    } catch (error) {
      log(error.toString());
    }
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
                    _displayName,
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
                    logOut(context);
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
    );
  }
}
