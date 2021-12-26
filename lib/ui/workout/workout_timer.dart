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
              SizedBox(height: 50),
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
                text: isRunning ? "Pause" : "Resume",
                onClicked: () {
                  if (isRunning) {
                    stopTimer(reset: false);
                  } else {
                    startTimer(reset: false);
                  }
                }),
            SizedBox(width: 20),
            ButtonWidget(
                text: "Cancel",
                onClicked: () {
                  stopTimer();
                }),
          ])
        : ButtonWidget(
            text: "Start Timer",
            color: Colors.white,
            backgroundColor: Colors.black,
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
          strokeWidth: 12,
          valueColor: AlwaysStoppedAnimation(Colors.white70),
          backgroundColor: Colors.green,
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
  final String text;
  final VoidCallback onClicked;
  final Color backgroundColor;
  final Color color;
  const ButtonWidget(
      {Key? key,
      required this.text,
      required this.onClicked,
      this.backgroundColor = Colors.black,
      this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
        onPressed: onClicked,
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: color),
        ));
  }
}
