import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massigym_flutter/strings.dart';
import 'package:massigym_flutter/ui/common/searchWorkout.dart';
import 'package:massigym_flutter/ui/workout/workout_details.dart';

// schermata che mostra gli allenamenti della categoria "legs", invocando il file "searchWorkout.dart"
class Legs extends StatefulWidget {
  Legs({Key? key}) : super(key: key);

  @override
  _LegsState createState() => _LegsState();
}

class _LegsState extends State<Legs> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Card(
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: Strings.searchLabel),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
          )),
      body: searchWorkout('legs', name),
    );
  }
}
