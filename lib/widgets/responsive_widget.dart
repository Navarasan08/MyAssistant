import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget(
      {super.key, required this.mobile, required this.web, this.tab});

  final Widget mobile;
  final Widget web;
  final Widget? tab;

  static bool isWeb(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width > 1024;
  }

  static bool isTab(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width > 332;
  }

  static bool isMobile(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width <= 332;
  }

  @override
  Widget build(BuildContext context) {
    if (isWeb(context)) {
      return web;
    }

    if (isTab(context)) {
      return tab ?? mobile;
    }

    return mobile;
  }
}
