import 'dart:developer';
import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/screens/login_page.dart';
import 'package:cab_rider/widgets/taxi_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});

  static const id = 'register';

  final fullNameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();

  void registerUser() async {
    final user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ))
        .user;
    if (user != null) {
      log("ERROR");
    } else {
      log("Success");
    }
  }

  void showError(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const SizedBox(height: 70),
                Image.asset(
                  "images/logo.png",
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 40),
                const Text(
                  "Create a Rider's account",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Brand-Bold',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      //Name
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 10),

                      //email adress
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email address',
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 10),

                      //phone
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone number',
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 10),

                      //password
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 40),

                      //Register
                      TaxiButton(
                        title: 'REGISTER',
                        color: BrandColors.colorGreen,
                        onPressed: () {
                          if (fullNameController.text.length < 3) {
                            showError(context, "Invalid  Full Name");
                            return;
                          }
                          if (phoneController.text.length < 10) {
                            showError(context, "Invalid Phone Number");
                            return;
                          }
                          if (passwordController.text.length < 8) {
                            showError(
                              context,
                              "Password must be at least 8 characters long.",
                            );
                            return;
                          }
                          if (!emailController.text.contains('@')) {
                            showError(context, "Invalid email");
                            return;
                          }

                          try {
                            registerUser();
                          } catch (e) {
                            showError(context,"ERROR");
                          }
                        },
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginPage.id, (route) => false);
                  },
                  child: const Text("Already have a RIDER account? Log in"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
