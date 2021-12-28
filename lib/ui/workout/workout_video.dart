import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:massigym_flutter/strings.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class WorkoutVideo extends StatefulWidget {
  DocumentSnapshot data;

  WorkoutVideo({Key? key, required this.data}) : super(key: key);

  @override
  _WorkoutVideoState createState() => _WorkoutVideoState();
}

class _WorkoutVideoState extends State<WorkoutVideo> {
  VideoPlayerController? controller;
  String? videoUrl;

  Future<void>? initializeVideoPlayer;

  @override
  void initState() {
    videoUrl = widget.data["videoUrl"];
    controller = VideoPlayerController.network(videoUrl!);
    initializeVideoPlayer = controller!.initialize();
    controller!.setLooping(true);
    controller!.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  downloadVideo() async {
    Fluttertoast.showToast(msg: Strings.downloadInitialized);
    final appStorage = await getExternalStorageDirectory();
    final file = File('${appStorage!.path}/${widget.data["name"]}.mp4');
    final response = await Dio().get(widget.data["videoUrl"],
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0));
    Fluttertoast.showToast(msg: Strings.downloadPending);

    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return Fluttertoast.showToast(
        msg: "Download completato: $file", toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    final downloadButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.deepPurple,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16)),
        onPressed: () {
          downloadVideo();
        },
        child: Text(
          "Download Video",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.data["name"]} - Video"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 10),
              child: FutureBuilder(
                future: initializeVideoPlayer,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: controller!.value.aspectRatio,
                      child: VideoPlayer(controller!),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            downloadButton,
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          setState(() {
            if (controller!.value.isPlaying) {
              controller!.pause();
            } else {
              controller!.play();
            }
          });
        },
        child: Icon(controller!.value.isPlaying
            ? Icons.pause
            : Icons.play_arrow_rounded),
      ),
    );
  }
}
