class UserModel {
  bool active;
  DateTime lastseen;
  String username;
  String photoUrl;
  String? _id;

  String? get id => _id;

  UserModel({
    required this.active,
    required this.lastseen,
    required this.username,
    required this.photoUrl,
    // required this.id,
  });

  toJson() => {
        "active": active,
        "last_seen": lastseen,
        "username": username,
        "photo_url": photoUrl,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userModel = UserModel(
      active: json['active'],
      lastseen: json['last_seen'],
      username: json['username'],
      photoUrl: json['photo_url'],
    );
    userModel._id = json['id'];
    return userModel;
  }
}
