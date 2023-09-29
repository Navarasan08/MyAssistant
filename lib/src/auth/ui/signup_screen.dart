import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_assistant/cubit/auth_navigation_cubit.dart';
import 'package:my_assistant/dashboard/ui/dashbaord_screen.dart';
import 'package:my_assistant/service/firebase_service.dart';
import 'package:my_assistant/utils/dialog.dart';
import 'package:my_assistant/utils/validator.dart';
import 'package:my_assistant/widgets/custom_button.dart';
import 'package:my_assistant/widgets/responsive_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailC = TextEditingController();
  final _name = TextEditingController();
  final _passwordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  void setLoading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  void register() async {
    if (_formKey.currentState!.validate()) {
      setLoading(true);

      try {
        UserCredential credential = await FirebaseService.createUser(
            email: _emailC.text, password: _passwordC.text, name: _name.text);
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
    _name.dispose();
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
                "SIGNUP",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _name,
                validator: (value) =>
                    Validators.requiredValidation(value!, "Full Name"),
                decoration: InputDecoration(hintText: "Full Name"),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailC,
                validator: (value) => Validators.email(value!, "Email"),
                decoration: InputDecoration(hintText: "Email Id"),
              ),
              SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                controller: _passwordC,
                validator: (value) => Validators.email(value!, "Password"),
                decoration: InputDecoration(hintText: "Password"),
              ),
              SizedBox(height: 20),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
                CustomSubmitButton(title: "Register", onPressed: register),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (ResponsiveWidget.isWeb(context)) {
                    BlocProvider.of<AuthNavigationCubit>(context)
                        .navigate(AuthNavigationState.login);
                    return;
                  }

                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Existing User?"),
                    SizedBox(width: 5),
                    Text(
                      "Login",
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
