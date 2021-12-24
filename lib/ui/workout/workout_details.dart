import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:massigym_flutter/models/workout.dart';

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

    return FirebaseFirestore.instance
        .collection(data["category"])
        .doc(data.id)
        .update({"favourites": FieldValue.arrayUnion(userFavourite)});
  }

  removeFavourite() {
    check = false;
    userFavourite.length = 1;
    userFavourite[0] = user!.email;

    return FirebaseFirestore.instance
        .collection(data["category"])
        .doc(data.id)
        .update({"favourites": FieldValue.arrayRemove(userFavourite)});
  }

  @override
  Widget build(BuildContext context) {
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
