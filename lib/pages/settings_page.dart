import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // dark mode
            Text(
              'Dark Mode',
              style: TextStyle(fontSize: 16),
            ),

            // toggle
            CupertinoSwitch(
              value: false,
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Center(
                    child: Text(
                      'This feature is under construction.',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
