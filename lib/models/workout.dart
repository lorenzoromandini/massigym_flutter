import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutModel {
  String? userMail;
  String? userName;
  String? category;
  String? name;
  String? description;
  int? duration;
  String? imageUrl;
  String? videoUrl;
  List<String>? searchKeyList;
  List<String>? favourites;
  List<String>? likes;

  WorkoutModel(
      {this.category,
      this.description,
      this.duration,
      this.favourites,
      this.imageUrl,
      this.videoUrl,
      this.name,
      this.likes,
      this.userMail,
      this.userName});

  // receiving data from server
  factory WorkoutModel.fromMap(map) {
    return WorkoutModel(
      userMail: map["userMail"],
      userName: map["userName"],
      category: map["category"],
      name: map["name"],
      description: map["description"],
      duration: map["duration"],
      imageUrl: map["imageUrl"],
      videoUrl: map["videoUrl"],
      favourites: map["favourites"] == null ? null : map["favourites"],
      likes: map["likes"] == null ? null : map["likes"],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'userMail': userMail,
      'userName': userName,
      'category': category,
      'name': name,
      'description': description,
      'duration': duration,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'favourites': favourites,
      'likes': likes,
      'searchKeywords': searchKeyList
    };
  }
}
