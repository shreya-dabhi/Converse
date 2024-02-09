import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final bool showSpinner;
  final void Function()? onTap;

  const MyButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.showSpinner = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadiusDirectional.circular(6),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              showSpinner
                  ? const SizedBox(
                      width: 20,
                    )
                  : Container(),
              showSpinner
                  ? const SizedBox(
                      height: 15.0,
                      width: 15.0,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
