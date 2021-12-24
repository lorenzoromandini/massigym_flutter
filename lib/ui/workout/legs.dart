import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massigym_flutter/ui/common/searchWorkout.dart';
import 'package:massigym_flutter/ui/workout/workout_details.dart';

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
      body: searchWorkout('legs', name),
    );
  }
}
