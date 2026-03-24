import 'package:flutter/material.dart';

class ButtonTime2Widget extends StatelessWidget {
  const ButtonTime2Widget({super.key, required this.text, this.update});

  final Function()? update;
  final String text;

  @override
  Widget build(BuildContext context) {
    final WidgetStatePropertyAll<Color>? backgroundColor = update != null
        ? WidgetStatePropertyAll<Color>(Colors.grey)
        : null;
    return TextButton(
      onPressed: update,
      style: ButtonStyle(
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.black),
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      child: Text(text),
    );
  }
}
