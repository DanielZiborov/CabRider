import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const id = 'mainpage';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Page"),
        centerTitle: true,
      ),
      body: Center(
        child: MaterialButton(
          height: 50,
          minWidth: 300,
          color: Colors.green,
          onPressed: () {
            addInDataBase();
          },
          child: const Text("Test Connection"),
        ),
      ),
    );
  }
}

void addInDataBase() {
  DatabaseReference dbref = FirebaseDatabase.instance.ref().child('Test');
  dbref.set("Is Connected");
}
