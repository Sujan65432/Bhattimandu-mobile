import 'package:bhattimandu/components/alert/validation.dart';
import 'package:bhattimandu/components/form/custom_bhatti_btn.dart';
import 'package:bhattimandu/components/form/custom_textfield.dart';
import 'package:bhattimandu/components/loader/bhatti_loader.dart';
import 'package:bhattimandu/database/authentication.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  bool isLoading = false;
  bool isRegistered = false;
  final AuthenticationService _auth = AuthenticationService();
  String? nameErr, passErr, emailErr, phoneErr;
  String phone = '';
  String email = '';
  String pass = '';
  bool _isPasswordVisible = false;
  String? userType = 'seller';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const BhattiLoader()
        : Scaffold(
            resizeToAvoidBottomInset:
                true, // Enable resizing to avoid keyboard overlap
            body: SafeArea(
              child: SingleChildScrollView(
                // Make the entire body scrollable
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 28,
                    bottom: 20,
                    right: 28,
                  ),
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.all(0),
                          child: const Image(
                            image: AssetImage('images/bhattimandu-logo.png'),
                            fit: BoxFit.cover,
                            width: 240,
                            height: 170,
                          ),
                        ),
                        const Text(
                          'Get Started',
                          style: TextStyle(
                            color: Color(0xffF5F5DC),
                            fontSize: 35,
                            fontFamily: 'lovelo',
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Name',
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                          helperText: isRegistered
                              ? Validators.validateUserName(name)
                              : null,
                          helperStyle: const TextStyle(
                              color: Colors.red,
                              fontFamily: 'poppins',
                              fontStyle: FontStyle.italic),
                          hintText: 'enter your name',
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Email Address',
                          hintText: 'enter email address',
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          helperText: isRegistered
                              ? Validators.validateUserEmail(email)
                              : null,
                          helperStyle: const TextStyle(
                              color: Colors.red,
                              fontFamily: 'poppins',
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Contact Number',
                          hintText: 'enter your number',
                          onChanged: (value) {
                            setState(() {
                              phone = value;
                            });
                          },
                          helperText: isRegistered
                              ? Validators.validateUserPhone(phone)
                              : null,
                          helperStyle: const TextStyle(
                              color: Colors.red,
                              fontFamily: 'poppins',
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Text(
                              "Select Role",
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 16,
                                color: Color(0xffF5F5DC),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'buyer',
                                  groupValue: userType,
                                  onChanged: (value) {
                                    setState(() {
                                      userType = value;
                                    });
                                  },
                                ),
                                const Text(
                                  'Buyer',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'seller',
                                  groupValue: userType,
                                  onChanged: (value) {
                                    setState(() {
                                      userType = value;
                                    });
                                  },
                                ),
                                const Text(
                                  'Seller',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        CustomTextField(
                          label: 'Password',
                          hintText: 'enter password',
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          isObscure: !_isPasswordVisible, // Toggle visibility
                          onChanged: (value) {
                            setState(() {
                              pass = value;
                            });
                          },
                          helperText: isRegistered
                              ? Validators.validateUserPassword(pass)
                              : null,
                          helperStyle: const TextStyle(
                              color: Colors.red,
                              fontFamily: 'poppins',
                              fontStyle: FontStyle.italic),
                          onIconPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 20),
                        CustomBhattiBtn(
                          text: 'Sign Up',
                          onPressed: () async {
                            print(
                                "minal Name: $name, Email: $email, Phone: $phone, Pass: $pass, Role: $userType");

                            setState(() {
                              isRegistered = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              dynamic result = await _auth.registration(context,
                                  email, pass, name, phone, userType!, '');
                              if (result) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pushReplacementNamed(
                                    context, '/sign_in');
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'poppins',
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/sign_in');
                              },
                              child: const Text(
                                "Sign In!!",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
