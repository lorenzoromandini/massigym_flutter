import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:massigym_flutter/ui/workout/workout_timer.dart';
import 'package:massigym_flutter/ui/workout/workout_video.dart';

class WorkoutDetails extends StatelessWidget {
  DocumentSnapshot data;

  WorkoutDetails(this.data);
  User? user = FirebaseAuth.instance.currentUser;

  List userFavourite = [];

  bool check = false;

  checkFavourite() {
    int j = 0;
    for (String a in data["favourites"]) {
      if (data["favourites"][j] == user!.email) {
        check = true;
      }
      j++;
    }
    return check;
  }

  addFavourite() {
    check = true;
    userFavourite.length = 1;
    userFavourite[0] = user!.email;

    FirebaseFirestore.instance
        .collection(data["category"])
        .doc(data.id)
        .update({"favourites": FieldValue.arrayUnion(userFavourite)});
    return Fluttertoast.showToast(msg: "Aggiunto ai Preferiti");
  }

  removeFavourite() {
    check = false;
    userFavourite.length = 1;
    userFavourite[0] = user!.email;

    FirebaseFirestore.instance
        .collection(data["category"])
        .doc(data.id)
        .update({"favourites": FieldValue.arrayRemove(userFavourite)});
    return Fluttertoast.showToast(msg: "Rimosso dai Preferiti");
  }

  deleteWorkout() {
    FirebaseFirestore.instance
        .collection(data["category"])
        .doc(data.id)
        .delete();
    return Fluttertoast.showToast(msg: "Workout eliminato");
  }

  @override
  Widget build(BuildContext context) {
    final timerButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.deepPurple,
            padding: EdgeInsets.symmetric(horizontal: 38, vertical: 22)),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkoutTimer(data: data)));
        },
        child: Text(
          "Timer",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ));

    final deleteWorkoutButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12)),
      onPressed: () {
        deleteWorkout();
        Navigator.pop(context);
      },
      child: Text(
        "Elimina Workout",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(data["name"]),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (!checkFavourite()) {
                addFavourite();
              } else {
                removeFavourite();
              }
              Navigator.pop(context);
            },
            icon: (!checkFavourite())
                ? Icon(
                    FontAwesome.heart,
                    color: Colors.white,
                  )
                : Icon(
                    FontAwesome.heart,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 250,
                  width: 400,
                  child: (data["imageUrl"] != "")
                      ? Image.network(
                          data["imageUrl"],
                          fit: BoxFit.contain,
                        )
                      : Image.asset("assets/workout_image_empty.png",
                          fit: BoxFit.contain),
                ),
                SizedBox(
                  height: 40,
                ),
                Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(children: [
                      Padding(
                          padding: EdgeInsets.all(20).copyWith(bottom: 10),
                          child: Column(children: [
                            Text(
                              data["description"],
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                          ]))
                    ])),
                SizedBox(
                  height: 50,
                ),
                timerButton,
                SizedBox(height: 40),
                SizedBox(
                  height: 250,
                  width: 400,
                  child: (data["videoUrl"] != "")
                      ? Card(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WorkoutVideo(
                                              data: data,
                                            )));
                              },
                              child: Image.asset(
                                "assets/workout_video_exists.jpg",
                                fit: BoxFit.contain,
                              )))
                      : Image.asset("assets/workout_video_empty.png",
                          fit: BoxFit.contain),
                ),
                SizedBox(
                  height: 50,
                ),
                (user!.email == data["userMail"])
                    ? deleteWorkoutButton
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
