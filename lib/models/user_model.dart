class UserModel {
  String? username;

  UserModel({this.username});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      username: map["username"],
    );
  }

  get email => null;

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'username': username,
    };
  }
}
