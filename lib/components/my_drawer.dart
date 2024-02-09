import 'package:flutter/material.dart';

import '../pages/profile_page.dart';
import '../pages/settings_page.dart';
import '../services/auth/auth_service.dart';
import 'my_listtile.dart';

class MyDrawer extends StatelessWidget {
  final Map<String, dynamic> userDetails;

  const MyDrawer({super.key, required this.userDetails});

  void logout() async {
    final authService = AuthService();
    await authService.signOut();
  }

  // alert before logout
  Widget logoutAlert(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      contentPadding: const EdgeInsets.only(
        top: 25,
        left: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: const Text(
        'Are you sure want to logout ?',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            'No',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(
            'Yes',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            // close the dialog
            Navigator.pop(context);

            // delete the task
            logout();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // pop the drawer
                  Navigator.pop(context);

                  // navigate to profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(userDetails: userDetails),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 30, bottom: 30, top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey,
                        backgroundImage: userDetails['imageURL'] != null
                            ? NetworkImage(userDetails['imageURL']!)
                            : null,
                        child: userDetails['imageURL'] == null
                            ? const Icon(
                                Icons.person,
                                size: 35,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        userDetails['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      const Text(
                        'View profile',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.primary,
                height: 2,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              children: [
                MyListTile(
                  label: 'SETTINGS',
                  iconData: Icons.settings,
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);

                    // navigate to settings page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
                MyListTile(
                  label: 'LOGOUT',
                  iconData: Icons.logout_rounded,
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);

                    // show alert before logout
                    showDialog(
                      context: context,
                      builder: (context) => logoutAlert(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
