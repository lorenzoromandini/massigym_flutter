import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:massigym_flutter/ui/auth/login_screen.dart';

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
          return ("Password richiesta");
        }
        if (!regexp.hasMatch(value)) {
          return ("Immettere una Password valida. (Min. 6 caratteri)");
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
          return "Le Password non coincidono";
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
      color: Colors.deepPurple,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          changePassword(passwordController.text);
        },
        child: const Text(
          "Modifica Password",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifica Password"),
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