import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:massigym_flutter/strings.dart';
import 'package:massigym_flutter/ui/auth/login_screen.dart';

// schermata di modifica della password, a cui è possibile accedere attraverso la schermata del Profilo
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
    // form della nuova password
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      // regole per l'inserimento della nuova password
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
          hintText: "Nuova Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // form della conferma password
    final confermaPasswordField = TextFormField(
      autofocus: false,
      controller: confermaPasswordController,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return (Strings.passwordConfirmRequired);
        }
        // password e conferma password sono differenti
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

    // bottone di modifica password
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
          Strings.changePassword,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.changePassword),
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

  // metodo che invoca la funzione di modifica password di Firebase, passando come parametro la nuova password inserita nella form
  void changePassword(String password) async {
    User? user = FirebaseAuth.instance.currentUser;
    user!.updatePassword(password).then((_) async {
      Fluttertoast.showToast(
          msg: Strings.passwordChangedSuccessfully,
          toastLength: Toast.LENGTH_SHORT);

      // una volta modificata la password l'utente viene disconnesso e dovrà effettuare nuovamente il login per accedere
      await FirebaseAuth.instance.signOut();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: Strings.passwordNotChanged + error.toString(),
          toastLength: Toast.LENGTH_LONG);
    });
  }
}
