import 'package:flutter/material.dart';

Future<bool> acceptAction(BuildContext context, String text,
    [String title = "Notice"]) async {
  bool response = false;

  await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  response = true;
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ));
  return response;
}
