import 'package:job_posting_bidding_app/model/user.dart';

class BasicActionsResponse {
  bool success;
  String message;

  BasicActionsResponse({
    this.success,
    this.message,
  });

  factory BasicActionsResponse.fromJson(Map<String, dynamic> json) {
    return BasicActionsResponse(
      success: json["success"] == null ? false : json["success"],
    );
  }
}
class PlaceBidResponse {
  bool success;
  String message;

  PlaceBidResponse({
    this.success,
    this.message,
  });

  factory PlaceBidResponse.fromJson(Map<String, dynamic> json) {
    return PlaceBidResponse(
      success: json["success"] == null ? false : json["success"],
      message: json["msg"]
    );
  }
}

class LoginResponse {
  bool success;
  User msg;
  String token;

  LoginResponse({
    this.success,
    this.msg,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        success: json["success"] == null ? false : json["success"],
        msg: json["msg"] == null ? null : User.fromJson(json["msg"]),
        token: json["token"],
      );
}

class RegistrationResponse {
  bool success;
  User user_details;
  String token;

  RegistrationResponse({
    this.success,
    this.user_details,
    this.token,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      RegistrationResponse(
          success: json["success"] == null ? false : json["success"],
          user_details: json["user_details"] == null
              ? null
              : User.fromJson(json["user_details"]),
          token: json["token"]);
}
