import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:massigym_flutter/models/user_model.dart';
import 'package:massigym_flutter/screens/personal_workout.dart';
import 'package:massigym_flutter/screens/preferiti.dart';
import 'package:massigym_flutter/screens/profilo.dart';

class PersonaleScreen extends StatefulWidget {
  const PersonaleScreen({Key? key}) : super(key: key);

  @override
  _PersonaleScreenState createState() => _PersonaleScreenState();
}

class _PersonaleScreenState extends State<PersonaleScreen> {
  @override
  Widget build(BuildContext context) {
    final personalWorkoutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PersonalWorkout()),
          );
        },
        child: const Text(
          "I miei Workout",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final preferitiButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Preferiti()),
          );
        },
        child: const Text(
          "Preferiti",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final profiloButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profilo()),
          );
        },
        child: const Text(
          "Profilo",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Personale"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 45),
                      personalWorkoutButton,
                      const SizedBox(height: 45),
                      preferitiButton,
                      const SizedBox(height: 45),
                      profiloButton,
                      const SizedBox(height: 45),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
