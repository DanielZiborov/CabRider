import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/screens/login_page.dart';
import 'package:cab_rider/screens/main_page.dart';
import 'package:cab_rider/widgets/taxi_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  static const id = 'register';

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final fullNameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  final user = null;

  void registerUser() async {
    final user = (await _auth
            .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
            .catchError((ex) {
      //check errors and display messages

      PlatformException thisEx = ex;
      showError(thisEx.message.toString());
      return ex;
    }))
        .user;

    if (user != null) {
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.ref().child('users/${user.uid}');
      Map userMap = {
        "fullName": fullNameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
      };
      newUserRef.set(userMap);
      transitionMainPage();
    }
  }

  void transitionMainPage() {
    Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
  }

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

                          //check my problems
                          if (fullNameController.text.length < 3) {
                            showError("Invalid Full Name");
                            return;
                          }
                          if (phoneController.text.length < 10) {
                            showError("Invalid Phone Number");
                            return;
                          }
                          if (passwordController.text.length < 8) {
                            showError(
                              "Password must be at least 8 characters long",
                            );
                            return;
                          }
                          if (!emailController.text.contains('@')) {
                            showError("Invalid email");
                            return;
                          }

                          //registration
                          registerUser();
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
