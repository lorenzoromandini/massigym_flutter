import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massigym_flutter/strings.dart';
import 'package:video_player/video_player.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.data["name"]} - Video"),
      ),
      body: Padding(
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
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
