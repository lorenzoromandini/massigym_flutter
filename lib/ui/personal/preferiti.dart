import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:massigym_flutter/ui/workout/workout_details.dart';

// schermata contenente la lista dei workout preferiti dall'utente
class Preferiti extends StatefulWidget {
  Preferiti({Key? key}) : super(key: key);

  @override
  _PreferitiState createState() => _PreferitiState();
}

class _PreferitiState extends State<Preferiti> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    Widget workoutList = StreamBuilder<QuerySnapshot>(
        // ottiene dal db tutti gli allenamenti preferiti dall'utente
        stream: FirebaseFirestore.instance
            .collection("workouts")
            .where('favourites', arrayContains: user!.email)
            .orderBy("totalLikes", descending: true)
            .orderBy("name")
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
                            "${data["name"]}        ${data["duration"]} s"),
                        subtitle: Text(
                            "${data["category"]}        ${data["userName"]}"),
                        leading: SizedBox(
                          width: 120,
                          height: 80,
                          child: (data["imageUrl"] != "")
                              ? Image.network(
                                  data["imageUrl"],
                                  fit: BoxFit.contain,
                                )
                              : Image.asset("assets/workout_image_empty.png",
                                  fit: BoxFit.contain),
                        ),
                        trailing: Column(
                          children: [
                            Icon(
                              FontAwesome.thumbs_up,
                              color: Colors.lightBlue,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            // mostra il numero totale di Mi Piace di quell'allenamento
                            Text(
                              "${data["totalLikes"]}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorkoutDetails(data)));
                        },
                      ),
                    );
                  },
                );
        });

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Preferiti"),
          elevation: 0,
        ),
        body: workoutList);
  }
}
