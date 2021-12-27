import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkoutTimer extends StatefulWidget {
  DocumentSnapshot data;

  WorkoutTimer({Key? key, required this.data}) : super(key: key);

  @override
  _WorkoutTimerState createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> {
  Timer? timer;
  int? durata;

  @override
  void initState() {
    super.initState();
    setState(() {
      durata = (widget.data["duration"]);
    });
  }

  startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (durata! > 0) {
        setState(() {
          durata = durata! - 1;
        });
      } else {
        stopTimer(reset: false);
      }
    });
  }

  stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    setState(() {
      timer?.cancel();
    });
  }

  resetTimer() {
    setState(() {
      durata = (widget.data["duration"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.data["name"]} - Timer"),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 150),
              buildTimer(),
              SizedBox(height: 60),
              buildButtons()
            ],
          ),
        ));
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = durata == widget.data["duration"] || durata == 0;
    return isRunning || !isCompleted
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ButtonWidget(
                icon: isRunning
                    ? Icon(
                        Icons.pause_rounded,
                        color: Colors.amber,
                      )
                    : Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.green,
                      ),
                onClicked: () {
                  if (isRunning) {
                    stopTimer(reset: false);
                  } else {
                    startTimer(reset: false);
                  }
                }),
            SizedBox(width: 40),
            ButtonWidget(
                icon: Icon(
                  Icons.crop_square_rounded,
                  color: Colors.red,
                ),
                onClicked: () {
                  stopTimer();
                }),
          ])
        : ButtonWidget(
            icon: Icon(Icons.play_arrow_rounded, color: Colors.green,),
            onClicked: () {
              startTimer();
            },
          );
  }

  Widget buildTimer() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(fit: StackFit.expand, children: [
        CircularProgressIndicator(
          value: durata! / widget.data["duration"],
          strokeWidth: 15,
          valueColor: AlwaysStoppedAnimation(Colors.white70),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        Center(
          child: buildTime(),
        )
      ]),
    );
  }

  Widget buildTime() {
    if (durata == 0) {
      return Icon(Icons.done, color: Colors.green, size: 112);
    } else {
      return Text(
        '$durata',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 80),
      );
    }
  }
}

class ButtonWidget extends StatelessWidget {
  final Icon icon;
  final VoidCallback onClicked;
  final Color backgroundColor;
  const ButtonWidget({
    Key? key,
    required this.icon,
    required this.onClicked,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
        style: ElevatedButton.styleFrom(
          elevation: 10,
            primary: backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
        onPressed: onClicked,
        child: icon);
  }
}
