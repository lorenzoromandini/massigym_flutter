import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massigym_flutter/strings.dart';
import 'package:massigym_flutter/ui/common/searchWorkout.dart';
import 'package:massigym_flutter/ui/workout/workout_details.dart';

class Arms extends StatefulWidget {
  Arms({Key? key}) : super(key: key);

  @override
  _ArmsState createState() => _ArmsState();
}

class _ArmsState extends State<Arms> {
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
      body: searchWorkout('arms', name),
    );
  }
}
