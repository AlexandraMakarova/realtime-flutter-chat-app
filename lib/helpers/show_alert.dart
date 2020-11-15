import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

showAlert(BuildContext context, String title, String subtitle) {
  if (Platform.isAndroid) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(subtitle),
        actions: <Widget>[
          MaterialButton(
              child: Text('OK'),
              elevation: 5,
              textColor: Theme.of(context).buttonColor,
              onPressed: () => Navigator.pop(context))
        ],
      ),
    );
  }

  showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(subtitle),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('OK'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ),
  );
}
