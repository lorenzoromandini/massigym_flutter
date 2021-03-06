import 'package:flutter/material.dart';
import 'package:massigym_flutter/ui/personal/personal_workout.dart';
import 'package:massigym_flutter/ui/personal/preferiti.dart';
import 'package:massigym_flutter/ui/personal/profilo.dart';

// schermata di passaggio per l'area personale, attraverso cui si può accedere alle schermate dei Workout caricati
// dall'utente, ai workout Preferiti dall'utente e al Profilo dell'utente
class PersonaleScreen extends StatefulWidget {
  const PersonaleScreen({Key? key}) : super(key: key);

  @override
  _PersonaleScreenState createState() => _PersonaleScreenState();
}

class _PersonaleScreenState extends State<PersonaleScreen> {
  @override
  Widget build(BuildContext context) {
    // bottone per accedere all'area degli allenamenti inseriti dall'utente
    final personalWorkoutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.purple,
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

    // bottone per accedere all'area degli allenamenti preferiti dall'utente
    final preferitiButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.red,
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

    // bottone per accedere all'area del profilo dell'utente
    final profiloButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.deepPurple,
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
                      personalWorkoutButton,
                      const SizedBox(height: 50),
                      preferitiButton,
                      const SizedBox(height: 50),
                      profiloButton,
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
