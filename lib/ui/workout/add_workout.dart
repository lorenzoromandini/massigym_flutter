import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:massigym_flutter/models/workout.dart';
import 'package:massigym_flutter/strings.dart';
import 'package:massigym_flutter/ui/common/bottomNavBar.dart';
import 'package:path/path.dart';

// schermata di inserimento di un nuovo workout
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
  File? imageFile = null;
  File? videoFile = null;

  // metodo per la selezione dell'immagine dall'archivio del telefono
  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() {
      imageFile = File(path);
    });
  }

  // metodo per la selezione del video dall'archivio del telefono
  Future selectVideo() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() {
      videoFile = File(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    // metodo per l'inserimento del workout
    insertWorkout(String name, String category, String description,
        String duration) async {
      if (_formKey.currentState!.validate()) {
        Fluttertoast.showToast(
            msg: Strings.addWorkoutInitialized, toastLength: Toast.LENGTH_LONG);

        FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
        User? user = FirebaseAuth.instance.currentUser;
        WorkoutModel workoutModel = WorkoutModel();

        var userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.email)
            .get();
        var username = userDoc["username"];

        // l'oggetto di tipo WorkoutModel viene riempito a partire dai campi delle form,
        // dall'email e dallo username dell'utente, mentre immagine e video sono momentaneamente vuoti
        workoutModel.name = nameController.text;
        workoutModel.category = categoryValue;
        workoutModel.description = descriptionController.text;
        workoutModel.duration = int.parse(durationValue!);
        workoutModel.userMail = user.email;
        workoutModel.userName = username;
        workoutModel.favourites = [];
        workoutModel.likes = [];
        workoutModel.imageUrl = "";
        workoutModel.videoUrl = "";

        // divido il nome del workout per caratteri successivi : questo servirà per la barra di ricerca
        List<String> splitName = name.split(" ");
        workoutModel.searchKeyList = [];

        for (int i = 0; i < splitName.length; i++) {
          for (int y = 1; y < splitName[i].length + 1; y++) {
            workoutModel.searchKeyList!
                .add(splitName[i].substring(0, y).toLowerCase());
          }
        }

        String imageUrl = "";
        String videoUrl = "";

        if (imageFile != null) {
          // se è stata selezionata un'immagine allora verrà caricata nello Storage
          // nella cartella corrispondente alla categoria dell'allenamento, avente come nome
          // l'email dell'utente seguita dal nome dell'allenamento e infine specificato che è un'immagine
          var snapshot = await storage
              .ref()
              .child(
                  "${workoutModel.category}/${user.email}_${workoutModel.name}_image")
              .putFile(imageFile!);
          var downloadUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            imageUrl = downloadUrl;
          });
        }

        if (videoFile != null) {
          // se è stata selezionato un video allora verrà caricato nello Storage
          // nella cartella corrispondente alla categoria dell'allenamento, avente come nome
          // l'email dell'utente seguito dal nome dell'allenamento e infine specificato che è un video
          var snapshot = await storage
              .ref()
              .child(
                  "${workoutModel.category}/${user.email}_${workoutModel.name}_video")
              .putFile(videoFile!);
          var downloadUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            videoUrl = downloadUrl;
          });
        }

        // vengono aggiornati i campi relativi all'immagine e al video con gli Url
        workoutModel.imageUrl = imageUrl;
        workoutModel.videoUrl = videoUrl;

        Fluttertoast.showToast(
            msg: Strings.addWorkoutPending, toastLength: Toast.LENGTH_LONG);

        // viene caricato lo UserModel nel Firestore
        await firebaseFirestore
            .collection("workouts")
            .doc()
            .set(workoutModel.toMap());


        await FirebaseFirestore.instance
        .collection("statistics")
        .doc(workoutModel.category)
        .update({"totalWorkouts": FieldValue.increment(1)});


        Fluttertoast.showToast(msg: Strings.addWorkoutSuccess);

        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(builder: (context) => BottomNavBar()),
            (route) => false);
      }
    }

    // form del nome
    final nameField = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      // regole per l'inserimento del nome
      validator: (value) {
        RegExp regexp = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return (Strings.nameRequired);
        }
        if (!regexp.hasMatch(value)) {
          return (Strings.nameInvalid);
        }
      },
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.book),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nome",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // modello per la form di selezione di categoria e durata
    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20)));

    // form di selezione della categoria
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
            return Strings.categoryRequired;
          }
        },
      ),
    );

    // form della descrizione
    final descriptionField = TextFormField(
      autofocus: false,
      controller: descriptionController,
      keyboardType: TextInputType.name,
      // regole per l'inserimento della descrizione
      validator: (value) {
        RegExp regexp = RegExp(r'^.{10,}$');
        if (value!.isEmpty) {
          return (Strings.descriptionRequired);
        }
        if (!regexp.hasMatch(value)) {
          return (Strings.descriptionInvalid);
        }
      },
      onSaved: (value) {
        descriptionController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.description),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Descrizione",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // form di selezione della durata
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
            return Strings.durationRequired;
          }
        },
      ),
    );

    // bottone per l'inserimento del workout
    final insertWorkoutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.pink,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          insertWorkout(nameController.text, categoryController.text,
              descriptionController.text, durationController.text);
        },
        child: const Text(
          Strings.addWorkout,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    // verifica se sono stati selezionati immagine e video
    final imageFileName =
        imageFile != null ? basename(imageFile!.path) : Strings.noFileSelected;
    final videoFileName =
        videoFile != null ? basename(videoFile!.path) : Strings.noFileSelected;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(Strings.addWorkout),
        elevation: 0,
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
                      ButtonWidget(
                        icon: Icons.attach_file,
                        onClicked: selectImage,
                        text: 'Seleziona Immagine',
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        imageFileName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 45),
                      nameField,
                      const SizedBox(height: 45),
                      categoryField,
                      const SizedBox(height: 45),
                      descriptionField,
                      const SizedBox(height: 45),
                      durationField,
                      const SizedBox(height: 45),
                      ButtonWidget(
                        icon: Icons.attach_file,
                        onClicked: selectVideo,
                        text: 'Seleziona Video',
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        videoFileName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 45),
                      insertWorkoutButton,
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

// modello per il bottone di selezione di immagine e video
class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onClicked;
  final String text;
  const ButtonWidget({
    Key? key,
    required this.icon,
    required this.onClicked,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.deepPurple,
          minimumSize: Size.fromHeight(50),
        ),
        onPressed: onClicked,
        child: buildContent());
  }

  Widget buildContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28),
        SizedBox(
          width: 16,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 22, color: Colors.white),
        )
      ],
    );
  }
}
