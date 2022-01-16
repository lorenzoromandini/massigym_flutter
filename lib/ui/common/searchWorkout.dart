import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:massigym_flutter/ui/workout/workout_details.dart';

// widget che si occupa della barra di ricerca e delle informazioni da mostrare sull'etichetta di ogni workout
Widget searchWorkout(String? category, String? name) {
  return StreamBuilder<QuerySnapshot>(
      // caratteri inseriti all'interno della barra di ricerca
      stream: (name != "" && name != null)
          // se è inserito qualche carattere nella barra di ricerca si va a interrogare il db per vedere se sono presenti
          ? FirebaseFirestore.instance
              .collection("workouts")
              .where("category", isEqualTo: category)
              .where("searchKeywords", arrayContains: name)
              .orderBy("totalLikes", descending: true)
              .orderBy("name")
              .snapshots()
          // se non è inserito nulla mostra tutti i workout dell'apposita categoria
          : FirebaseFirestore.instance
              .collection("workouts")
              .where("category", isEqualTo: category)
              .orderBy("totalLikes", descending: true)
              .orderBy("name")
              .snapshots(),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            // durante il caricamento dei dati dal db viene mostrato un indicatore che ruota
            ? Center(child: CircularProgressIndicator())
            // una volta caricati i dati viene mostrata la lista degli allenamenti
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
                            // se è stata caricata l'immagine dell'allenamento quella verrà mostrata
                            ? Image.network(
                                data["imageUrl"],
                                fit: BoxFit.contain,
                              )
                            // se non è stata caricata l'immagine dell'allenamento verrà mostrata un'immagine standard
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
}
