import 'package:flutter/material.dart';
import 'package:otp_nodejs/services/api_services.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class OtpVerifyPage extends StatefulWidget {
  final String? mobileNo;
  final String? otpHash;
  const OtpVerifyPage({this.mobileNo, this.otpHash});

  @override
  _OtpVerifyPageState createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  String _otpCode = "";
  final int _otpCodeLength = 4;
  bool isAPICallProcess = false;
  late FocusNode myFocusNode;
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();

    SmsAutoFill().listenForCode.call();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SmsAutoFill().unregisterListener();
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ProgressHUD(
          child: verifyOtpUI(),
          inAsyncCall: isAPICallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  verifyOtpUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/pic.png",
          height: 150,
          fit: BoxFit.contain,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "OTP verification",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            "Enter OTP code sent to your mobile \n+91-${widget.mobileNo}",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: PinFieldAutoFill(
            codeLength: _otpCodeLength,
            decoration: UnderlineDecoration(
              textStyle: TextStyle(fontSize: 20, color: Colors.black),
              colorBuilder: FixedColorBuilder(
                Colors.black.withOpacity(0.3),
              ),
            ),
            currentCode: _otpCode,
            onCodeChanged: (code) {
              if (code!.length == _otpCodeLength) {
                FocusScope.of(context).requestFocus(FocusNode());
                _otpCode = code;
              }
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: FormHelper.submitButton("Verify", () {
            setState(() {
              isAPICallProcess = true;
            });
            APIServices.verifyOtp(
              widget.mobileNo!,
              widget.otpHash!,
              _otpCode,
            ).then(
              (response) async {
                setState(
                  () {
                    isAPICallProcess = false;
                  },
                );
                print(response.message);
                print(response.data);
                if (response.data != null) {
                  FormHelper.showSimpleAlertDialog(
                    context,
                    "Shopping APP",
                    response.message,
                    "OK",
                    () {
                      Navigator.pop(context);
                    },
                  );
                } else {
                  FormHelper.showSimpleAlertDialog(
                    context,
                    "Shopping APP",
                    response.message,
                    "OK",
                    () {
                      Navigator.pop(context);
                    },
                  );
                }
              },
            );
          },
              borderColor: HexColor("#78D0B1"),
              btnColor: HexColor("#78D0B1"),
              txtColor: HexColor("#000000"),
              borderRadius: 20),
        )
      ],
    );
  }
}
