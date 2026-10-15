import 'package:json_annotation/json_annotation.dart';

import '../user_info.dart';

part 'login_response_data.g.dart';

@JsonSerializable()
class LoginResponseData {
  UserInfo? user_info;

  LoginResponseData();

  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDataToJson(this);
}
