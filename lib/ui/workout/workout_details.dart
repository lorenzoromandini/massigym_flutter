import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:massigym_flutter/strings.dart';
import 'package:massigym_flutter/ui/workout/workout_timer.dart';
import 'package:massigym_flutter/ui/workout/workout_video.dart';

// schermata contenenti i dettagli dell'allenamento
class WorkoutDetails extends StatelessWidget {
  DocumentSnapshot data;

  WorkoutDetails(this.data);
  User? user = FirebaseAuth.instance.currentUser;

  List userFavourite = [];

  List likes = [];

  bool checkFav = false;

  bool checkL = false;

  // verifica all'interno del db se l'utente ha inserito l'email tra i Preferiti
  checkFavourite() {
    for (String favourite in data["favourites"]) {
      if (favourite == user!.email) {
        checkFav = true;
      }
    }
    return checkFav;
  }

  // metodo che serve a inserire l'allenamento tra i Preferiti
  addFavourite() {
    checkFav = true;
    userFavourite.length = 1;
    userFavourite[0] = user!.email;

    // inserisce in coda all'array "favourites" l'email dell'utente
    FirebaseFirestore.instance
        .collection("workouts")
        .doc(data.id)
        .update({"favourites": FieldValue.arrayUnion(userFavourite)});

    return Fluttertoast.showToast(msg: Strings.addToFavourites);
  }

  // metodo che serve a rimuovere il workout dai preferiti dell'utente
  removeFavourite() {
    checkFav = false;
    userFavourite.length = 1;
    userFavourite[0] = user!.email;

    // rimuove dall'array "favourites" l'email dell'utente
    FirebaseFirestore.instance
        .collection("workouts")
        .doc(data.id)
        .update({"favourites": FieldValue.arrayRemove(userFavourite)});

    return Fluttertoast.showToast(msg: Strings.removeFromFavourites);
  }

  // verifica all'interno del db se l'utente ha messo Mi Piace
  checkLikes() {
    for (String like in data["likes"]) {
      if (like == user!.email) {
        checkL = true;
      }
    }
    return checkL;
  }

  // metodo che serve a inserire Mi Piace
  addLike() {
    checkL = true;
    likes.length = 1;
    likes[0] = user!.email;

    // inserisce in coda all'array "likes" l'email dell'utente
    FirebaseFirestore.instance
        .collection("workouts")
        .doc(data.id)
        .update({"likes": FieldValue.arrayUnion(likes)});

        FirebaseFirestore.instance
        .collection("workouts")
        .doc(data.id)
        .update({"totalLikes": FieldValue.increment(1)});

    FirebaseFirestore.instance
        .collection("statistics")
        .doc(data["category"])
        .update({"totalLikes": FieldValue.increment(1)});

    return Fluttertoast.showToast(msg: Strings.addLike);
  }

  // metodo che serve a rimuovere il Mi Piace precedentemente inserito dall'utente
  removeLike() {
    checkFav = false;
    likes.length = 1;
    likes[0] = user!.email;

    // rimuove dall'array "likes" l'email dell'utente
    FirebaseFirestore.instance
        .collection("workouts")
        .doc(data.id)
        .update({"likes": FieldValue.arrayRemove(likes)});

        FirebaseFirestore.instance
        .collection("workouts")
        .doc(data.id)
        .update({"totalLikes": FieldValue.increment(-1)});

    FirebaseFirestore.instance
        .collection("statistics")
        .doc(data["category"])
        .update({"totalLikes": FieldValue.increment(-1)});

    return Fluttertoast.showToast(msg: Strings.removeLike);
  }

  // metodo per eliminare l'allenamento
  deleteWorkout() {
    FirebaseFirestore.instance.collection("workouts").doc(data.id).delete();

    FirebaseFirestore.instance
        .collection("statistics")
        .doc(data["category"])
        .update({"totalWorkouts": FieldValue.increment(-1)});
    return Fluttertoast.showToast(msg: Strings.deleteWorkout);

    
  }

  @override
  Widget build(BuildContext context) {
    // bottone per accedere alla schermata del timer
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

    // bottone per mettere/togliere Mi Piace
    final likesButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 15,
            padding: EdgeInsets.symmetric(horizontal: 38, vertical: 22)),
        onPressed: () {
          if (!checkLikes()) {
            addLike();
          } else {
            removeLike();
          }
          Navigator.pop(context);
        },
        child: (!checkLikes())
            ? Icon(
                FontAwesome.thumbs_up,
                color: Colors.green,
              )
            : Icon(FontAwesome.thumbs_down, color: Colors.red));

    // bottoner per eliminare l'allenamento
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
          // bottone per inserire/togliere dai preferiti l'allenamento
          // è posizionato sulla parte destra dell'AppBar
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
                            SizedBox(height: 20),
                            Text(
                              "- ${data["userName"]}",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 8),
                          ]))
                    ])),
                SizedBox(
                  height: 50,
                ),
                timerButton,
                SizedBox(height: 40),
                likesButton,
                SizedBox(
                  height: 40,
                ),
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
                // il bottone per eliminare l'allenamento è mostrato solo all'utente che lo
                // ha creato e all'utente "admin"
                (user!.email == data["userMail"] ||
                        user!.email == "admin@gmail.com")
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
