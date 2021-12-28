
// model dello user
class UserModel {
  String? username;
  String? profileImageUrl;

  UserModel({this.username, this.profileImageUrl});

  // ottiene i dati dell'utente dal db e li inserisce all'interno di un oggetto di tipo UserModel
  factory UserModel.fromMap(map) {
    return UserModel(
        username: map["username"], profileImageUrl: map["imageUrl"]);
  }

  get email => null;

  // carica i dati nel db a partire da un oggetto di tipo UserModel
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'imageUrl': profileImageUrl,
    };
  }
}
