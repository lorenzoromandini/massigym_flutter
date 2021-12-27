import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:massigym_flutter/ui/workout/workout_timer.dart';

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
                Fluttertoast.showToast(msg: "Aggiunto ai Preferiti");
              } else {
                removeFavourite();
                Fluttertoast.showToast(msg: "Rimosso dai Preferiti");
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
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        padding:
                            EdgeInsets.symmetric(horizontal: 38, vertical: 22)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkoutTimer(data: data)));
                    },
                    child: Text(
                      "Avvia",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                SizedBox(height: 30),
                SizedBox(
                  height: 250,
                  width: 400,
                  child: (data["videoUrl"] != "")
                      ? Image.network(
                          data["videoUrl"],
                          fit: BoxFit.contain,
                        )
                      : Image.asset("assets/workout_video_empty.png",
                          fit: BoxFit.contain),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                    ),
                    onPressed: () {} // => uploadImage()
                    ,
                    child: Text("Download video")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
