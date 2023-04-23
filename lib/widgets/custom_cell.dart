import 'package:flutter/material.dart';

class CustomCell extends StatelessWidget {
  final DateTime date;

  final bool shouldHighlight;

  final Color backgroundColor;

  final Color highlightColor;

  final Color tileColor;

  final bool isInMonth;

  final VoidCallback onTileTap;

  final Widget? event;

  const CustomCell({
    Key? key,
    required this.date,
    this.isInMonth = false,
    this.shouldHighlight = false,
    this.backgroundColor = Colors.blue,
    this.highlightColor = Colors.blue,
    required this.onTileTap,
    this.tileColor = Colors.blue,
    this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTileTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: shouldHighlight
              ? Border.all(color: Theme.of(context).primaryColor)
              : null,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "${date.day}",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
            if (event != null)
              Expanded(
                child: event!,
              ),
          ],
        ),
      ),
    );
  }
}
