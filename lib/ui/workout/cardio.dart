import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cardio extends StatefulWidget {
  Cardio({Key? key}) : super(key: key);

  @override
  _CardioState createState() => _CardioState();
}

class _CardioState extends State<Cardio> {
  String name = "";

  /*
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
                    return Container(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(data['name'],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            leading: CircleAvatar(
                              child: Image.asset("assets/logo.png",
                                  width: 100, height: 50, fit: BoxFit.contain),
                              radius: 40,
                              backgroundColor: Colors.lightBlue,
                            ),
                            trailing: Icon(Icons.shopping_basket,
                                color: Colors.red, size: 30),
                          ),
                          Divider(
                            thickness: 2,
                          )
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
*/

/*
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
  */

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
                    return Container(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(data['name'],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            leading: CircleAvatar(
                              child: Image.asset("assets/logo.png",
                                  width: 100, height: 50, fit: BoxFit.contain),
                              radius: 40,
                              backgroundColor: Colors.lightBlue,
                            ),
                            trailing: Icon(Icons.shopping_basket,
                                color: Colors.red, size: 30),
                          ),
                          Divider(
                            thickness: 2,
                          )
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

}
