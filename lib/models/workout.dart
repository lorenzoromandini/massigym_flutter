
class WorkoutModel {
  String? userMail;
  String? uid;
  String? category;
  String? name;
  String? description;
  String? duration;
  List<String>? searchKeyList;

  WorkoutModel({this.userMail, this.category, this.name, this.description, this.duration});

  // receiving data from server
  factory WorkoutModel.fromMap(map) {
    return WorkoutModel(
      userMail: map["user"],
      category: map["category"],
      name: map["name"],
      description: map["description"],
      duration: map["duration"],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'user': userMail,
      'category': category,
      'name': name, 
      'description': description,
      'duration': duration,
      'searchKeywords' : searchKeyList
    };
  }
}
