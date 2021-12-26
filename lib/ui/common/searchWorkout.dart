import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massigym_flutter/ui/workout/workout_details.dart';

Widget searchWorkout(String? category, String? name) {
  return StreamBuilder<QuerySnapshot>(
      stream: (name != "" && name != null)
          ? FirebaseFirestore.instance
              .collection(category!)
              .where("searchKeywords", arrayContains: name)
              .snapshots()
          : FirebaseFirestore.instance.collection(category!).snapshots(),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot data = snapshot.data!.docs[index];
                  return Card(
                    child: ListTile(
                      title: Text("${data["name"]}        ${data["duration"]}s"),
                      subtitle: Text(data["userName"]),
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
                      trailing: Icon(Icons.arrow_forward_rounded),
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
}
