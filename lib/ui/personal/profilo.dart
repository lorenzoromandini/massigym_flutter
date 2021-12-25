import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:massigym_flutter/models/user_model.dart';
import 'package:massigym_flutter/ui/auth/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class Profilo extends StatefulWidget {
  const Profilo({Key? key}) : super(key: key);

  @override
  _ProfiloState createState() => _ProfiloState();
}

class _ProfiloState extends State<Profilo> {
  User? user = FirebaseAuth.instance.currentUser;
  final storage = FirebaseStorage.instance;

  UserModel userModel = UserModel();

  String imageUrl = "";
  int check = 0;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.email)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  checkImageProfile() {}

  checkImage() async {
    var snapshot = await storage.ref().child("profileImage/${user!.email}");
    var downloadUrl = await snapshot.getDownloadURL();
    if (downloadUrl != null) {
      setState(() {
        imageUrl = downloadUrl;
      });
    }
    return imageUrl;
  }

  uploadImage() async {
    final picker = ImagePicker();
    PickedFile? image;

    // Check permission
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.request();

    if (permissionStatus.isGranted) {
      // select image
      image = await picker.getImage(source: ImageSource.gallery);
      var file = File(image!.path);
      if (image != "") {
        // upload to firebase
        var snapshot = await storage
            .ref()
            .child("profileImage/${user!.email}")
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
        userModel.profileImageUrl = imageUrl;
        FirebaseFirestore.instance
            .collection("users")
            .doc(user!.email)
            .update({"imageUrl": userModel.profileImageUrl});
      } else {
        print("No path received");
      }
    } else {
      print("Grant Permissioms and try again");
    }
  }

  shootImage() async {
    final shooter = ImagePicker();
    PickedFile? image;

    // Check permission
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.request();

    if (permissionStatus.isGranted) {
      // select image
      image = await shooter.getImage(source: ImageSource.camera);
      var file = File(image!.path);
      if (image != "") {
        // upload to firebase
        var snapshot = await storage
            .ref()
            .child("profileImage/${user!.email}")
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
        userModel.profileImageUrl = imageUrl;
        FirebaseFirestore.instance
            .collection("users")
            .doc(user!.email)
            .update({"imageUrl": userModel.profileImageUrl});
      } else {
        print("No path received");
      }
    } else {
      print("Grant Permissioms and try again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profilo"),
        elevation: 0,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                logout(context);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 80, 40, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 250,
                width: 400,
                child: (checkImage() != "")
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                      )
                    : Image.asset("assets/profile_image_empty.png",
                        fit: BoxFit.contain),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () => uploadImage(), child: Text("Upload image")),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () => shootImage(), child: Text("Shoot image")),
              const SizedBox(height: 40),
              Text("${userModel.username}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
              Text("${user!.email}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }
}
