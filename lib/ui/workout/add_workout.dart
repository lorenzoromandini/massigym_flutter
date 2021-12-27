import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:massigym_flutter/models/user_model.dart';
import 'package:massigym_flutter/models/workout.dart';
import 'package:massigym_flutter/ui/common/bottomNavBar.dart';
import 'package:permission_handler/permission_handler.dart';

class AddWorkout extends StatefulWidget {
  AddWorkout({Key? key}) : super(key: key);

  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController categoryController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  final List<String> category = ['cardio', 'legs', 'arms'];
  String? categoryValue;
  final List<String> duration = [
    '15',
    '30',
    '45',
    '60',
    '90',
    '120',
    '150',
    '180',
    '210',
    '240',
    '270',
    '300',
    '400',
    '500',
    '600'
  ];
  String? durationValue;
  final storage = FirebaseStorage.instance;
  PickedFile? image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    // name field
    final nameField = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regexp = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("Nome richiesto");
        }
        if (!regexp.hasMatch(value)) {
          return ("Immetti un Nome valido. (Min. 2 caratteri)");
        }
      },
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nome",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20)));

    final categoryField = Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1)),
      child: DropdownButtonFormField<String>(
        hint: Text("Categoria"),
        value: categoryValue,
        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
        iconSize: 36,
        isExpanded: true,
        items: category.map(buildMenuItem).toList(),
        onChanged: (value) => setState(() {
          this.categoryValue = value;
        }),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Categoria richiesta';
          }
        },
      ),
    );

    // description field
    final descriptionField = TextFormField(
      autofocus: false,
      controller: descriptionController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regexp = RegExp(r'^.{15,}$');
        if (value!.isEmpty) {
          return ("Descrizione richiesta");
        }
        if (!regexp.hasMatch(value)) {
          return ("Immetti una Descrizione valida. (Min. 15 caratteri)");
        }
      },
      onSaved: (value) {
        descriptionController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Descrizione",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final durationField = Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1)),
      child: DropdownButtonFormField<String>(
        hint: Text("Durata"),
        value: durationValue,
        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
        iconSize: 36,
        isExpanded: true,
        items: duration.map(buildMenuItem).toList(),
        onChanged: (value) => setState(() {
          this.durationValue = value;
        }),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Durata richiesta';
          }
        },
      ),
    );

    final insertWorkoutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          insertWorkout(nameController.text, categoryController.text,
              descriptionController.text, durationController.text);
        },
        child: const Text(
          "Inserisci Workout",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Inserisci Workout"),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 250,
                        width: 400,
                        child: Image.asset("assets/workout_empty.png",
                            fit: BoxFit.contain),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                          onPressed: () {} // => uploadImage()
                          ,
                          child: Text("Upload image")),
                      const SizedBox(height: 45),
                      nameField,
                      const SizedBox(height: 45),
                      categoryField,
                      const SizedBox(height: 45),
                      descriptionField,
                      const SizedBox(height: 45),
                      durationField,
                      const SizedBox(height: 45),
                      insertWorkoutButton,
                      const SizedBox(height: 45),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  void insertWorkout(
      String name, String category, String description, String duration) async {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      WorkoutModel workoutModel = WorkoutModel();

      var userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.email)
          .get();
      var username = userDoc["username"];

      workoutModel.name = nameController.text;
      workoutModel.category = categoryValue;
      workoutModel.description = descriptionController.text;
      workoutModel.duration = int.parse(durationValue!);
      workoutModel.userMail = user.email;
      workoutModel.userName = username;
      workoutModel.favourites = [];
      workoutModel.ratings = [];
      workoutModel.imageUrl = "";

      List<String> splitName = name.split(" ");
      workoutModel.searchKeyList = [];

      for (int i = 0; i < splitName.length; i++) {
        for (int y = 1; y < splitName[i].length + 1; y++) {
          workoutModel.searchKeyList!
              .add(splitName[i].substring(0, y).toLowerCase());
        }
      }

      final picker = ImagePicker();
      PickedFile? image;
      String imageUrl = "";

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
              .child(
                  "${workoutModel.category}/${user.email}_${workoutModel.name}_image")
              .putFile(file);
          var downloadUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            imageUrl = downloadUrl;
          });
          workoutModel.imageUrl = imageUrl;
          FirebaseFirestore.instance
              .collection(workoutModel.category!)
              .doc()
              .update({"imageUrl": workoutModel.imageUrl = imageUrl});

          await firebaseFirestore
              .collection("${workoutModel.category}")
              .doc()
              .set(workoutModel.toMap());

          /*
      image = await picker.getImage(source: ImageSource.gallery);
      var file = File(image!.path);
      var snapshot = await storage
          .ref()
          .child("${workoutModel.category}/${user.email}_${workoutModel.name}")
          .putFile(file);
          */
        }

        Fluttertoast.showToast(msg: "Allenamento inserito con successo");
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(builder: (context) => BottomNavBar()),
            (route) => false);
      }

      /*
  uploadImage1() async {
    // Check permission
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.request();

    if (permissionStatus.isGranted) {
      // select image
      image = await picker.getImage(source: ImageSource.gallery);
      var file = File(image!.path);
    }
  }*/

    }
  }
}
