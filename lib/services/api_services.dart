import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:otp_nodejs/config/config.dart';
import 'package:otp_nodejs/models/otp_login_response.dart';

class APIServices {
  static var client = http.Client();

  static Future<OtpLoginResponseModel> otpLogin(String mobileNo) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiUrl, Config.otpLoginAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {"phone": mobileNo},
      ),
    );

    return otpLoginResponseJson(response.body);
  }

  static Future<OtpLoginResponseModel> verifyOtp(
    String mobileNo,
    String otpHash,
    String OtpCode,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiUrl, Config.otpVerifyAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {"phone": mobileNo, "otp": OtpCode, "hash": otpHash},
      ),
    );

    return otpLoginResponseJson(response.body);
  }
}
