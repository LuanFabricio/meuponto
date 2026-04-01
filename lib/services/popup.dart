import 'package:flutter/material.dart';

Future<void> showPopup(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Set your default shift."),
        content: const SingleChildScrollView(
          child: ListBody(children: [
            Text("Teste"),
            Text("Teste1"),
          ]),
        )
      );
    },
  );
}
