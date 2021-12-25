class UserModel {
  String? username;
  String? profileImageUrl;

  UserModel({this.username, this.profileImageUrl});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      username: map["username"],
      profileImageUrl: map["imageUrl"]
    );
  }

  get email => null;

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'imageUrl': profileImageUrl,
    };
  }
}
