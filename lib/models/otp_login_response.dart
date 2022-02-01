import 'dart:convert';

OtpLoginResponseModel otpLoginResponseJson(String str) =>
    OtpLoginResponseModel.fromJson(json.decode(str));

class OtpLoginResponseModel {
  late final String message;
  late final String? data;

  OtpLoginResponseModel({
    required this.message,
    this.data,
  });

  OtpLoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'];
  }
}
