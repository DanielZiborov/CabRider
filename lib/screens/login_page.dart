import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/screens/main_page.dart';
import 'package:cab_rider/screens/registration_page.dart';
import 'package:cab_rider/widgets/taxi_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const id = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void showError(String title) {
    ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void login() async {
    final user = (await _auth
            .signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
            .catchError((ex) {
      PlatformException thisEx = ex;
      showError(thisEx.message.toString());
      return ex;
    }))
        .user;

    if (user != null) {
      //veritify login
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users/${user.uid}');
      final snapshot = await userRef.get();

      if (snapshot.value != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, MainPage.id, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  "Sign In as a Rider",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Brand-Bold',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
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
                      TaxiButton(
                        title: 'LOGIN',
                        color: BrandColors.colorGreen,
                        onPressed: () async {
                          //check network

                          var connectivityResult =
                              await Connectivity().checkConnectivity();

                          if (!connectivityResult
                                  .contains(ConnectivityResult.mobile) &
                              !connectivityResult
                                  .contains(ConnectivityResult.wifi)) {
                            showError("no internet connectivity");
                            return;
                          }

                          if (!emailController.text.contains('@')) {
                            showError("Invalid email");
                            return;
                          }
                          if (passwordController.text.length < 8) {
                            showError(
                              "Password must be at least 8 characters long",
                            );
                            return;
                          }
                          login();
                        },
                      )
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationPage.id, (route) => false);
                  },
                  child: const Text("Don't have an account,sign up here"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
