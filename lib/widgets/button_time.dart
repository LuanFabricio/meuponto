import 'package:flutter/material.dart';

const Color baseBgColor = Color(0x00FFFFFF);
Color deactivateBgColor = Colors.grey.withValues(alpha: 0.25);

class ButtonTimeWidget extends StatelessWidget {
  const ButtonTimeWidget({
    super.key,
    required this.text,
    this.update,
    this.bgColor = baseBgColor
  });

  final Function()? update;
  final String text;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    WidgetStatePropertyAll<Color>? backgroundColor = WidgetStatePropertyAll(bgColor);
    // TODO: Map the uses and remove
    if (update == null) {
      backgroundColor =  WidgetStatePropertyAll(Colors.grey.withValues(alpha: 0.25));
    }

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
