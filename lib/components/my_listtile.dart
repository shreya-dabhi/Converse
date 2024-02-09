import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData iconData;
  final String label;
  final void Function()? onTap;

  const MyListTile(
      {super.key,
      required this.iconData,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: ListTile(
        onTap: onTap,
        title: Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        leading: Icon(iconData),
      ),
    );
  }
}
