import 'package:flutter/material.dart';

loadingAlertDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: const Text("Loading"),
            ),
          ],
        ),
      );
    },
  );
}
