import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:massigym_flutter/ui/workout/workout_details.dart';

class PersonalWorkout extends StatefulWidget {
  PersonalWorkout({Key? key}) : super(key: key);

  @override
  _PersonalWorkoutState createState() => _PersonalWorkoutState();
}

class _PersonalWorkoutState extends State<PersonalWorkout> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    Widget workoutList(String? category) {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(category!)
              .where('user', isEqualTo: user!.email)
              .snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot data = snapshot.data!.docs[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                              "${data["name"]}        ${data["duration"]}s"),
                          subtitle: Text(data["category"]),
                          leading: SizedBox(
                            width: 120,
                            height: 80,
                            child: (data["imageUrl"] != "")
                                ? Image.network(
                                    data["imageUrl"],
                                    fit: BoxFit.contain,
                                  )
                                : Image.asset("assets/workout_empty.png",
                                    fit: BoxFit.contain),
                          ),
                          trailing: Icon(Icons.arrow_forward_rounded),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        WorkoutDetails(data)));
                          },
                        ),
                      );
                    },
                  );
          });
    }

    final armsList = workoutList('arms');
    final cardioList = workoutList('cardio');
    final legsList = workoutList('legs');

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("I miei Workout"),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(children: <Widget>[
          Expanded(child: cardioList),
          Expanded(child: legsList),
          Expanded(child: armsList),
        ]));
  }
}
