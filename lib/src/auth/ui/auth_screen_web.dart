import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_assistant/cubit/auth_navigation_cubit.dart';
import 'package:my_assistant/src/auth/ui/login_screen.dart';
import 'package:my_assistant/src/auth/ui/signup_screen.dart';

class AuthScreenWeb extends StatefulWidget {
  const AuthScreenWeb({super.key});

  @override
  State<AuthScreenWeb> createState() => _AuthScreenWebState();
}

class _AuthScreenWebState extends State<AuthScreenWeb> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Image.network("https://images.news18.com/ibnlive/uploads/2021/12/spiderman-meme-16401651614x3.png")),
            SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: IndexedStack(
              index: context.watch<AuthNavigationCubit>().state,
              children: [
                LoginPage(),
                SignUpScreen(),
              ],
            )),
          ],
        ),
      )
    );
  }
}
