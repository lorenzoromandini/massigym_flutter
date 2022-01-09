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

// schermata del profilo dell'utente
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

  // alla creazione della schermata vengono ottenuti i dati dell'utente e immessi in un oggetto di tipo UserModel
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

  // metodo per il caricamento dell'immagine del profilo dall'archivio del telefono
  uploadImage() async {
    final picker = ImagePicker();
    PickedFile? image;

    // attesa che vengano concessi i permessi per accedere all'archivio del telefono
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.request();

    if (permissionStatus.isGranted) {
      // viene mostrato l'archivio dell'utente dove questi sceglie l'immagine da inserire
      image = await picker.getImage(source: ImageSource.gallery);
      var file = File(image!.path);
      if (image != "") {
        // l'immagine viene caricata all'interno dello Storage di Firebase nella cartella "profileImage",
        // avente come nome l'email dell'utente
        var snapshot = await storage
            .ref()
            .child("profileImage/${user!.email}")
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });

        userModel.profileImageUrl = imageUrl;

        // dopo che l'immagine è stata caricata su Firebase Storage, l'Url viene inserito
        // all'interno del documento dell'utente nel Firestore
        FirebaseFirestore.instance
            .collection("users")
            .doc(user!.email)
            .update({"imageUrl": userModel.profileImageUrl});

        Fluttertoast.showToast(msg: Strings.profileImageChanged);
      } else {
        Fluttertoast.showToast(msg: Strings.noPathReceived);
      }
    } else {
      Fluttertoast.showToast(msg: Strings.grantPermissions);
    }
  }

  // metodo per il caricamento dell'immagine del profilo tramite scatto della foto
  shootImage() async {
    final shooter = ImagePicker();
    PickedFile? image;

    // attesa che vengano concessi i permessi per accedere alla fotocamera
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.request();

    if (permissionStatus.isGranted) {
      // si apre la fotocamera e l'utente può scattare la foto
      image = await shooter.getImage(source: ImageSource.camera);
      var file = File(image!.path);
      if (image != "") {
        // l'immagine viene caricata all'interno dello Storage di Firebase nella cartella "profileImage",
        // avente come nome l'email dell'utente
        var snapshot = await storage
            .ref()
            .child("profileImage/${user!.email}")
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
        userModel.profileImageUrl = imageUrl;
        // dopo che l'immagine è stata caricata su Firebase Storage, l'Url viene inserito
        // all'interno del documento dell'utente nel Firestore
        FirebaseFirestore.instance
            .collection("users")
            .doc(user!.email)
            .update({"imageUrl": userModel.profileImageUrl});

        Fluttertoast.showToast(msg: Strings.profileImageChanged);
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
              // se è stata caricata l'immagine del profilo quella verrà mostrata
              "${userModel.profileImageUrl}",
              fit: BoxFit.contain,
            )
          // se non è stata caricata l'immagine del profilo verrà mostrata un'immagine standard
          : Image.asset("assets/profile_image_empty.png", fit: BoxFit.contain),
    );

    // bottone per la selezione dell'immagine dall'archivio
    final uploadImageButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.purple,
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16)),
        onPressed: () => uploadImage(),
        child: Text(
          "Carica Immagine",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ));

    // bottone per aprire la fotocamera e scattare la foto
    final shootImageButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.purple,
            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16)),
        onPressed: () => shootImage(),
        child: Text(
          "Scatta Foto",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ));

    // card che riporta username ed email dell'utente
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

    // bottone per la modifica della password; una volta premuto l'utente verrà indirizzato in
    // una nuova schermata per effettuare la modifica della password
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
      body: SingleChildScrollView(
        child: Center(
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
      ),
    );
  }

  // metodo che invoca la funzione di logout di Firebase; una volta effettuato l'utente verrà
  // reindirizzato alla schermata di login
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(msg: "Logout effettuato");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }
}
