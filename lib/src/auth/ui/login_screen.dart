import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_assistant/cubit/auth_navigation_cubit.dart';
import 'package:my_assistant/service/firebase_service.dart';
import 'package:my_assistant/src/auth/ui/auth_screen_web.dart';
import 'package:my_assistant/src/auth/ui/signup_screen.dart';
import 'package:my_assistant/utils/dialog.dart';
import 'package:my_assistant/utils/validator.dart';
import 'package:my_assistant/dashboard/ui/dashbaord_screen.dart';
import 'package:my_assistant/widgets/custom_button.dart';
import 'package:my_assistant/widgets/responsive_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(mobile: LoginPage(), web: AuthScreenWeb());
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  void setLoading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      setLoading(true);

      try {
        UserCredential credential =
            await FirebaseService.signIn(_emailC.text, _passwordC.text);
        // setLoading(false);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashbaordScreen()));
      } catch (error) {
        setLoading(false);
        DialogModel.showSimpleDialog(context, title: "Failed", msg: "$error");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailC.dispose();
    _passwordC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "LOGIN",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailC,
                validator: (value) => Validators.email(value!, "Email"),
                decoration: InputDecoration(hintText: "Email Id"),
              ),
              SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                controller: _passwordC,
                validator: (value) => Validators.password(value!, "Password"),
                decoration: InputDecoration(hintText: "Password"),
              ),
              SizedBox(height: 20),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
                CustomSubmitButton(title: "Login", onPressed: login),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (ResponsiveWidget.isWeb(context)) {
                    BlocProvider.of<AuthNavigationCubit>(context)
                        .navigate(AuthNavigationState.signup);
                    return;
                  }
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New User?"),
                    SizedBox(width: 5),
                    Text(
                      "SignUp",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
