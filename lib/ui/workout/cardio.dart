import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massigym_flutter/ui/workout/workout_details.dart';
import 'package:massigym_flutter/ui/common/searchWorkout.dart';

class Cardio extends StatefulWidget {
  Cardio({Key? key}) : super(key: key);

  @override
  _CardioState createState() => _CardioState();
}

class _CardioState extends State<Cardio> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Card(
        child: TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: "Search..."),
          onChanged: (value) {
            setState(() {
              name = value;
            });
          },
        ),
      )),
      body: searchWorkout('cardio', name),
    );
  }
}



