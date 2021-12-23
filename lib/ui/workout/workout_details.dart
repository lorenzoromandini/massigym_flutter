import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkoutDetails extends StatelessWidget {
  final DocumentSnapshot data;

  WorkoutDetails(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data["name"]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo.png",
                height: 500,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  data["user"],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  data["description"],
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 22.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
