import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:massigym_flutter/ui/auth/login_screen.dart';
import 'package:massigym_flutter/ui/common/bottomNavBar.dart';

// punto di partenza dell'applicazione
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // collegamento al database Firebase
  await Firebase.initializeApp(
      /*
    options: const FirebaseOptions(
      apiKey: "AIzaSyAKAV2o4YGcJNFnUbgdxN4cVzr9s2EUrSE", // Your apiKey
      appId: "XXX", // Your appId
      messagingSenderId: "XXX", // Your messagingSenderId
      projectId: "massigym-80757", // Your projectId
    ), */
      );

  // quelle commentate sono opzione richieste per il funzionamento dell'app su browser,
  // mentre su telefono ed emulatore non sono necessarie


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'massigym_flutter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}

// splash screen dell'app, avviene all'apertura 
class StartScreen extends StatefulWidget {
  StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000), () {
      // session : verifica se l'utente era già loggato
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BottomNavBar()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo_start_screen.png'),
          ],
        ),
      ),
    );
  }
}
