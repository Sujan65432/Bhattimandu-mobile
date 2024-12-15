import 'package:bhattimandu/components/alert/validation.dart';
import 'package:bhattimandu/components/form/custom_bhatti_btn.dart';
import 'package:bhattimandu/components/form/custom_textfield.dart';
import 'package:bhattimandu/components/loader/bhatti_loader.dart';
import 'package:bhattimandu/database/authentication.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isPasswordVisible = false;
  String email='',password='';
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final AuthenticationService _auth = AuthenticationService();
  String? passErr, emailErr;
  bool isLogged=false;

  login () async {
    setState(() {
      isLogged = true;
    });
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      print(email);
      print(password);
      dynamic result = await _auth
          .logIn(
          context, email, password);
      if (result == null) {
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacementNamed(
            context, '/wrapper');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const BhattiLoader()
        :Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.only(top: 48, left: 28, bottom: 20, right: 28),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(0), // Add margin for spacing
                      child: const Image(
                        image: AssetImage('images/bhattimandu-logo.png'),
                        fit: BoxFit.cover,
                        width: 300,
                        height: 190,
                      ),
                    ),
                    const Text(
                      'Sign in',
                      style: TextStyle(
                          color: Color(0xffF5F5DC),
                          fontSize: 35,
                          fontFamily: 'lovelo'),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      helperText: isLogged? Validators.validateUserEmail(email) : null,
                      helperStyle: const TextStyle(
                          color: Colors.red,
                          fontFamily: 'poppins',
                          fontStyle: FontStyle.italic),
                      label: 'Email Address',
                      hintText: 'enter email address',
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Password',
                      hintText: 'enter password',
                      helperText: isLogged? Validators.validateUserPassword(password) : null,
                      helperStyle: const TextStyle(
                          color: Colors.red,
                          fontFamily: 'poppins',
                          fontStyle: FontStyle.italic),

                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      isObscure: !_isPasswordVisible, // Toggle visibility
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      onIconPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {}, child: const Text('Forget Password?')),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomBhattiBtn(text: 'Sign In', onPressed: login)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'poppins',
                        )),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/sign_up');
                      },
                      child: const Text(
                        "Create Account!!",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'poppins-semi',
                        )
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
