import 'package:flutter/material.dart';

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
        body: Center(child: buildImageInteractionCard()));
  }

  Widget buildCard() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 16,
          child: InkWell(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Ink.image(
                      height: 200,
                      image: AssetImage('assets/cat_cardio.png'),
                      fit: BoxFit.fitWidth,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, top: 16, right: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Silk Spinners",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text("Paccaaa"),
                      Text("Porcoooo, Diiiiii")
                    ],
                  ),
                ),
                ButtonBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageInteractionCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          SizedBox(
            child: Text(
              "Porcoddio",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          Stack(
            children: [
              Text("Pacca"),
              Ink.image(
                image: AssetImage('assets/cat_arms.png'),
                height: 240,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 16,
                right: 16,
                left: 16,
                child: Text(
                  'Cats rule the world!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16).copyWith(bottom: 0),
            child: Text(
              'The cat is the only domesticated species in the family Felidae and is often referred to as the domestic cat to distinguish it from the wild members of the family.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                child: Text('Buy Cat'),
                onPressed: () {},
              ),
              FlatButton(
                child: Text('Buy Cat Food'),
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }
}
