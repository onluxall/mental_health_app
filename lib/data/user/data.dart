import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class UserData {
  UserData({
    this.id,
    this.name,
    this.email,
    this.quizCompleted,
  });

  final String? id;
  final String? name;
  final String? email;
  final bool? quizCompleted;

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
