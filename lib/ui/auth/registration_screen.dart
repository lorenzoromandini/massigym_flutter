import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:massigym_flutter/models/user_model.dart';
import 'package:massigym_flutter/strings.dart';
import 'package:massigym_flutter/ui/auth/login_screen.dart';

// schermata di Registrazione
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confermaPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    // form dello username
    final usernameField = TextFormField(
      autofocus: false,
      controller: usernameController,
      keyboardType: TextInputType.name,
      // regole per l'inserimento dello username
      validator: (value) {
        RegExp regexp = RegExp(r'^.{5,}$');
        if (value!.isEmpty) {
          return (Strings.usernameRequired);
        }
        if (!regexp.hasMatch(value)) {
          return (Strings.usernameInvalid);
        }
      },
      onSaved: (value) {
        usernameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // form dell'email
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      // regole per l'inserimento dell'email
      validator: (value) {
        RegExp regexp = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
        if (value!.isEmpty) {
          return (Strings.emailRequired);
        }
        if (!regexp.hasMatch(value)) {
          return (Strings.emailInvalid);
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // form della password
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      // regole per l'inserimento della password
      validator: (value) {
        RegExp regexp = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return (Strings.passwordRequired);
        }
        if (!regexp.hasMatch(value)) {
          return (Strings.passwordInvalid);
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // form della conferma password
    final confermaPasswordField = TextFormField(
      autofocus: false,
      controller: confermaPasswordController,
      obscureText: true,
      // password e conferma password sono differenti
      validator: (value) {
        if (confermaPasswordController.text != passwordController.text) {
          return Strings.passwordNotEquals;
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
          hintText: Strings.passwordConfirm,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // bottone della registrazione
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.deepPurple,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailController.text, passwordController.text);
        },
        child: const Text(
          "Registrati",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Registrazione"),
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
                      SizedBox(
                          height: 200,
                          child: Image.asset(
                            "assets/icon/icon.png",
                            fit: BoxFit.contain,
                          )),
                      const SizedBox(height: 40),
                      usernameField,
                      const SizedBox(height: 30),
                      emailField,
                      const SizedBox(height: 30),
                      passwordField,
                      const SizedBox(height: 30),
                      confermaPasswordField,
                      const SizedBox(height: 30),
                      signUpButton,
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(Strings.yetRegistered),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                            child: const Text(
                              "Torna al Login",
                              style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  // metodo che invoca la funzione di registrazione di Firebase, passando come parametri email e password inseriti nella form
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  // metodo che svolge il compito di inserire i dati immessi nella form all'interno del database Firebase Firestore
  void postToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.username = usernameController.text;
    userModel.profileImageUrl = "";

    // email e username vengono inseriti nella collection "users"
    await firebaseFirestore
        .collection("users")
        .doc(user!.email)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Account creato con successo");

    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }
}
