import 'package:flutter/material.dart';
import 'package:massigym_flutter/strings.dart';

// schermata delle home dell'applicazione
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Home")),
        body: SingleChildScrollView(
            child: Column(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Categorie",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ))
          ]),
          buildCard(Strings.cardioCategory, Strings.cardioTopDescription,
              Strings.cardioBottomDescription, Strings.cardioImageUrl),
          buildCard(Strings.legsCategory, Strings.legsTopDescription,
              Strings.legsBottomDescription, Strings.legsImageUrl),
          buildCard(Strings.armsCategory, Strings.armsTopDescription,
              Strings.armsBottomDescription, Strings.armsImageUrl)
        ])));
  }

  // widget per il modello della card di ogni categoria
  Widget buildCard(category, workout_top_description,
      workout_bottom_description, workout_imageUrl) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Card(
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              Stack(
                children: [
                  Ink.image(
                    image: NetworkImage(workout_imageUrl),
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.all(20).copyWith(bottom: 10),
                  child: Column(children: [
                    Row(children: [
                      Text(category,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 24))
                    ]),
                    SizedBox(height: 10),
                    Text(
                      workout_top_description,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      workout_bottom_description,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                  ]))
            ])));
  }
}
