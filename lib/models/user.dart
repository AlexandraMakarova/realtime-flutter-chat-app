// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.online,
    this.name,
    this.email,
    this.userId,
  });

  bool online;
  String name;
  String email;
  String userId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        online: json["online"],
        name: json["name"],
        email: json["email"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "online": online,
        "name": name,
        "email": email,
        "userId": userId,
      };
}
