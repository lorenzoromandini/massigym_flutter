import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massigym_flutter/ui/workout/workout_details.dart';

class Cardio extends StatefulWidget {
  Cardio({Key? key}) : super(key: key);

  @override
  _CardioState createState() => _CardioState();
}

class _CardioState extends State<Cardio> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Card(
        child: TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: "Search..."),
          onChanged: (value) {
            setState(() {
              name = value;
            });
          },
        ),
      )),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? FirebaseFirestore.instance
                .collection("cardio")
                .where("searchKeywords", arrayContains: name)
                .snapshots()
            : FirebaseFirestore.instance.collection("cardio").snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    return Card(
                      child: ListTile(
                        title: Text(data["name"]),
                        subtitle: Text(data["user"]),
                        leading: Image.asset("assets/logo.png"),
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
        },
      ),
    );
  }
}
