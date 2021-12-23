import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Arms extends StatefulWidget {
  Arms({Key? key}) : super(key: key);

  @override
  _ArmsState createState() => _ArmsState();
}

class _ArmsState extends State<Arms> {
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
                .collection("arms")
                .where("searchKeywords", arrayContains: name)
                .snapshots()
            : FirebaseFirestore.instance.collection("arms").snapshots(),
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
