import 'package:flutter/material.dart';
import 'package:my_assistant/widgets/custom_button.dart';

class DialogModel {
  static void showSimpleDialog(BuildContext context,
      {String? title, String? msg, VoidCallback? onTap}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title ?? ""),
              content: Text(msg ?? ""),
              actions: [
                CustomSubmitButton(
                    title: "Ok",
                    onPressed: () {
                      onTap?.call();
                      Navigator.pop(context);
                    })
              ],
            ));
  }

  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));
  }

  static void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(15),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               CircularProgressIndicator(),
               SizedBox(width: 8),
               Text("Loading"),
            ],
          ),
        );
      },
    );
  }

  static void hideLoader(BuildContext context) {
    Navigator.pop(context);
  }
}
