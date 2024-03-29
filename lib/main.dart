import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_assistant/firebase_options.dart';
import 'package:my_assistant/service/firestore_service.dart';
import 'package:my_assistant/src/splash_screen.dart';
import 'package:uuid/uuid.dart';

import 'cubit/auth_navigation_cubit.dart';

var uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      print("web");
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      // for android & ios
      await Firebase.initializeApp();
    }

    // for web
  } catch (e) {}

  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthNavigationCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'My Assistant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 240, 238, 240),
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
          primarySwatch: Colors.deepPurple,
        ),
        home: MySplashScreen(),
      ),
    );
  }
}
