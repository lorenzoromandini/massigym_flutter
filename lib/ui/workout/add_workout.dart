import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:massigym_flutter/models/workout.dart';
import 'package:massigym_flutter/ui/personal/personal_workout.dart';

class AddWorkout extends StatefulWidget {
  AddWorkout({Key? key}) : super(key: key);

  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController categoryController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

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
          return ("Name required");
        }
        if (!regexp.hasMatch(value)) {
          return ("Please enter a valid name. (Min. 2 characters)");
        }
      },
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // category field
    final categoryField = TextFormField(
      autofocus: false,
      controller: categoryController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regexp = RegExp(r'^.{4,}$');
        if (value!.isEmpty) {
          return ("Category required");
        }
        if (!regexp.hasMatch(value)) {
          return ("Please enter a valid category. (Min. 4 characters)");
        }
      },
      onSaved: (value) {
        categoryController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Category",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // description field
    final descriptionField = TextFormField(
      autofocus: false,
      controller: descriptionController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regexp = RegExp(r'^.{15,}$');
        if (value!.isEmpty) {
          return ("Description required");
        }
        if (!regexp.hasMatch(value)) {
          return ("Please enter a valid description. (Min. 15 characters)");
        }
      },
      onSaved: (value) {
        descriptionController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Desciption",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // duration field
    final durationField = TextFormField(
      autofocus: false,
      controller: durationController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regexp = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("Duration required");
        }
        if (!regexp.hasMatch(value)) {
          return ("Please enter a valid duration. (Min. 2 characters)");
        }
      },
      onSaved: (value) {
        durationController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Duration",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
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
          "Inserisci",
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
                          height: 200,
                          child: Image.asset(
                            "assets/logo.png",
                            fit: BoxFit.contain,
                          )),
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
      User? user = _auth.currentUser;
      WorkoutModel workoutModel = WorkoutModel();

      workoutModel.name = nameController.text;
      workoutModel.category = categoryController.text;
      workoutModel.description = descriptionController.text;
      workoutModel.duration = durationController.text;
      workoutModel.userMail = user!.uid;

      await firebaseFirestore
          .collection("${workoutModel.category}")
          .doc(workoutModel.uid)
          .set(workoutModel.toMap());

      Fluttertoast.showToast(msg: "Allenamento inserito con successo");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => PersonalWorkout()),
          (route) => false);
    }
  }
}
