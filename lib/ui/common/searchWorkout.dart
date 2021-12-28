import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:massigym_flutter/ui/workout/workout_details.dart';

Widget searchWorkout(String? category, String? name) {
  return StreamBuilder<QuerySnapshot>(
      stream: (name != "" && name != null)
          ? FirebaseFirestore.instance
              .collection("workouts")
              .where("category", isEqualTo: category)
              .where("searchKeywords", arrayContains: name)
              .snapshots()
          : FirebaseFirestore.instance
              .collection("workouts")
              .where("category", isEqualTo: category)
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
                        data["name"],
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      subtitle: Text(
                        "${data["duration"]} s",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      horizontalTitleGap: 0,
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
                          Text(
                            "${enumerateLikes(data)}",
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
}

enumerateLikes(data) {
  int likes = 0;
  for (String like in data["likes"]) {
    likes++;
  }
  return likes;
}
