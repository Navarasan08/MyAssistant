
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_assistant/firebase_options.dart';
import 'package:my_assistant/src/splash_screen.dart';
import 'package:uuid/uuid.dart';

import 'cubit/auth_navigation_cubit.dart';


var uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthNavigationCubit(),
        ),
      ],
      child: MaterialApp(
          title: 'My Assistant',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 6,
              ),
            ),
            appBarTheme: AppBarTheme(
                centerTitle: true,
                titleTextStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            primarySwatch: Colors.cyan,
          ),
          home: MySplashScreen(),
      ),
    );
  }
}
