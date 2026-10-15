import 'package:base_flutter/models/response/login_response_data.dart';

class ResponseConfig {
  static T convertResponse<T>(dynamic json) {
    String type = T.toString();
    int index = type.lastIndexOf("?");
    if (index != -1) {
      type = type.substring(0, index);
    }
    switch (type) {
      case "LoginResponseData":
        return LoginResponseData.fromJson(json) as T;
      default:
        return json as T;
    }
  }
}
