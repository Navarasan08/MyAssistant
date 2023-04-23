
import 'package:flutter/material.dart';
import 'package:my_assistant/widgets/responsive_widget.dart';

class CustomSubmitButton extends StatelessWidget {
  const CustomSubmitButton(
      {super.key, required this.title, this.onPressed, this.color});

  final String title;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: ResponsiveWidget.isWeb(context) ? 18 : 0)
      ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }
}
