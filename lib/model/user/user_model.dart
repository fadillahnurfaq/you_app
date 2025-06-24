import 'package:you_app/model/model_parser.dart';

class UserModel {
  final String email;
  final String username;
  final String name;
  final DateTime? birthDay;
  final int? height;
  final int? weight;
  final List<String> interests;
  UserModel({
    required this.email,
    required this.username,
    required this.name,
    required this.birthDay,
    required this.height,
    required this.weight,
    required this.interests,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json["email"] ?? "",
      username: json["username"] ?? "",
      name: json["name"] ?? "",
      birthDay: ModelParser.parseDate(
        date: json["birthday"] ?? "",
        pattern: "dd MM yyyy",
      ),
      height: ModelParser.intFromJson(json["height"] ?? ""),
      weight: ModelParser.intFromJson(json["weight"] ?? ""),
      interests: json["interests"] is List
          ? List<String>.from(json["interests"]!.map((x) => x))
          : [],
    );
  }

  UserModel copyWith({
    String? email,
    String? username,
    String? name,
    DateTime? birthDay,
    int? height,
    int? weight,
    List<String>? interests,
  }) {
    return UserModel(
      email: email ?? this.email,
      username: username ?? this.username,
      name: name ?? this.name,
      birthDay: birthDay ?? this.birthDay,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      interests: interests ?? this.interests,
    );
  }
}
