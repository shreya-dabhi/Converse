import 'package:flutter/material.dart';

class PersonalDetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String labelData;
  final void Function()? onPressedOnSuffixIcon;
  final IconData? suffixIcon;

  const PersonalDetailTile(
      {super.key,
      required this.icon,
      required this.label,
      required this.labelData,
      this.onPressedOnSuffixIcon,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                width: 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    labelData,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: onPressedOnSuffixIcon,
            icon: Icon(
              suffixIcon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
