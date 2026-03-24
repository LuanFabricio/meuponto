import 'package:flutter/material.dart';

class ButtonTime2Widget extends StatelessWidget {
  const ButtonTime2Widget({super.key, required this.update, required this.text});

  final VoidCallback update;
  final String text;

  @override
    Widget build(BuildContext context) {
      return TextButton(
        onPressed: update,
        style: ButtonStyle(
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.black)
            )
          )
        ),
        child: Text(text),
      );
    }
}
