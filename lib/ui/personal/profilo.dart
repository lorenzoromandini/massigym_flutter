import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:massigym_flutter/models/user_model.dart';
import 'package:massigym_flutter/strings.dart';
import 'package:massigym_flutter/ui/auth/login_screen.dart';
import 'package:massigym_flutter/ui/personal/change_password.dart';
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
        print("Nessun path ricevuto");
      }
    } else {
      print("Concedi i permessi e riprova");
    }
  }

  shootImage() async {
    final shooter = ImagePicker();
    PickedFile? image;

    await Permission.photos.request();

    var permissionStatus = await Permission.photos.request();

    if (permissionStatus.isGranted) {
      image = await shooter.getImage(source: ImageSource.camera);
      var file = File(image!.path);
      if (image != "") {
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
        Fluttertoast.showToast(msg: Strings.noPathReceived);
      }
    } else {
      Fluttertoast.showToast(msg: Strings.grantPermissions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageCard = SizedBox(
      height: 250,
      width: 400,
      child: (userModel.profileImageUrl != "")
          ? Image.network(
              "${userModel.profileImageUrl}",
              fit: BoxFit.contain,
            )
          : Image.asset("assets/profile_image_empty.png", fit: BoxFit.contain),
    );
    final uploadImageButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.purple,
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16)),
        onPressed: () => uploadImage(),
        child: Text(
          "Carica Immagine",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ));

    final shootImageButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.purple,
            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16)),
        onPressed: () => shootImage(),
        child: Text(
          "Scatta Foto",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ));
    final credentialCard = Card(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        elevation: 15,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          Padding(
              padding: EdgeInsets.all(20).copyWith(bottom: 10),
              child: Column(children: [
                Text(
                  "${userModel.username}",
                  style: TextStyle(
                      fontSize: 26,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  user!.email!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10),
              ]))
        ]));

    final changePasswordButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.deepPurple,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22)),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChangePassword())),
        child: Text(
          Strings.changePassword,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ));

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
          padding: const EdgeInsets.fromLTRB(40, 70, 40, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              imageCard,
              SizedBox(
                height: 30,
              ),
              Row(children: [
                uploadImageButton,
                SizedBox(
                  width: 12,
                ),
                shootImageButton,
              ]),
              SizedBox(height: 35),
              credentialCard,
              SizedBox(
                height: 40,
              ),
              changePasswordButton,
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
