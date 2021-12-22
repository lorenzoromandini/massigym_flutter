import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:massigym_flutter/models/movie.dart';
import 'package:massigym_flutter/ui/movie_details_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MovieListScreen(),
    );
  }
}

/*
=======

>>>>>>> 7b4a634d4f87ebc2ce4e598b97a0998c4ea96d25
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
<<<<<<< HEAD

=======
>>>>>>> 7b4a634d4f87ebc2ce4e598b97a0998c4ea96d25
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
<<<<<<< HEAD

=======
>>>>>>> 7b4a634d4f87ebc2ce4e598b97a0998c4ea96d25
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
<<<<<<< HEAD
*/

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Movie o watch"),
        ),
        body: ListView.builder(
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              Movie movie = movieList[index];
              return Card(
                child: ListTile(
                  title: Text(movie.title),
                  subtitle: Text(movie.year.toString()),
                  leading: Image.asset(movie.imageUrl),
                  trailing: Icon(Icons.arrow_forward_rounded),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(movie)));
                  },
                ),
              );
            }));
  }
}
=======
>>>>>>> 7b4a634d4f87ebc2ce4e598b97a0998c4ea96d25
