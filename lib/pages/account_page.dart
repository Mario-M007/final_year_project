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
    if (displayName != null) {
      setState(() {
        _displayName = displayName;
      });
    }
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
                  onPressed: () {
                    showAboutDialog(
                        context: context,
                        applicationName: "MenuMate",
                        children: [
                          const Text(
                              "This is a final year project written in Flutter.\nFor any Assitance, please contact the author Mario Maarawi"),
                        ]);
                  },
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (builder) {
                      String newName =
                          _displayName; // Initialize newName with current display name
                      return AlertDialog(
                        title: const Text('Change Display Name'),
                        content: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Enter new display name',
                          ),
                          onChanged: (value) {
                            newName = value; // Update newName as the user types
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Close the dialog immediately
                              Navigator.pop(context);

                              // Update display name only if user clicks "Save"
                              setState(() {
                                _displayName = newName;
                              });

                              final authService = AuthService();
                              try {
                                await authService.updateDisplayName(newName);
                              } catch (error) {
                                log(error.toString());
                                // Handle error if needed
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
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
