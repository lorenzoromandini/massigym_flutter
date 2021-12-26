import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

/*

  checkImage() async {
    var snapshot = await storage.ref().child("profileImage/${user!.email}");
    var downloadUrl = await snapshot.getDownloadURL();
    if (downloadUrl != null) {
      setState(() {
        imageUrl = downloadUrl;
      });
    }
    print(userModel.profileImageUrl);
    return imageUrl;
  }
  */

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
                child: (userModel.profileImageUrl != "")
                    ? Image.network(
                        userModel.profileImageUrl!,
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
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePassword())),
                  child: Text("Change Password")),
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

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confermaPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regexp = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password required");
        }
        if (!regexp.hasMatch(value)) {
          return ("Please enter a valid password. (Min. 6 characters)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nuova Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final confermaPasswordField = TextFormField(
      autofocus: false,
      controller: confermaPasswordController,
      obscureText: true,
      validator: (value) {
        if (confermaPasswordController.text != passwordController.text) {
          return "Password don't match";
        }
        return null;
      },
      onSaved: (value) {
        confermaPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Conferma Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final changePasswordButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          changePassword(passwordController.text);
        },
        child: const Text(
          "Change Password",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36, 60, 36, 36),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    passwordField,
                    const SizedBox(height: 45),
                    confermaPasswordField,
                    const SizedBox(height: 45),
                    changePasswordButton,
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void changePassword(String password) async {
    User? user = FirebaseAuth.instance.currentUser;
    user!.updatePassword(password).then((_) async {
      Fluttertoast.showToast(
          msg: "Successfully changed password",
          toastLength: Toast.LENGTH_SHORT);
      await FirebaseAuth.instance.signOut();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Password can't be changed" + error.toString(),
          toastLength: Toast.LENGTH_LONG);

      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }
}
