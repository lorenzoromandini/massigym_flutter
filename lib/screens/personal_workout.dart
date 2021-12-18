import 'package:flutter/material.dart';
import 'package:massigym_flutter/screens/personale_screen.dart';

class PersonalWorkout extends StatefulWidget {
  PersonalWorkout({Key? key}) : super(key: key);

  @override
  _PersonalWorkoutState createState() => _PersonalWorkoutState();
}

class _PersonalWorkoutState extends State<PersonalWorkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}