import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/screens/profile/edit_profile_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class VerifyCodePage extends StatefulWidget {
  static const String tag = 'verifiy-code-page';

  @override
  _VerifyCodePageState createState() => new _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage>
    with TickerProviderStateMixin {
  final _otpController = TextEditingController();

  String error_message;
  String mobile_number;
  bool enableLoginButton = false;

  @override
  void initState() {
    super.initState();
  }

  void _onLoading() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Text("Submitting..."),
              ],
            ),
          ),
        );
      },
    );
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
      Navigator.pushNamed(context, EditProfilePage.tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      appBar: MyAppBars.getBackAppBar("Verify Mobile Number", () {
        Navigator.pop(context);
      }),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 64, right: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Text(
                  "A verification code has been sent to  +91  via SMS",
                  style: ThemeConstant.text_style_500_22_3,
                  textAlign: TextAlign.center,
                ),
                PinInputTextFormField(
                  controller: _otpController,
                  pinLength: 4,
                  decoration: UnderlineDecoration(
                      enteredColor: Colors.green, hintText: "----"),
                  textInputAction: TextInputAction.go,
                  onChanged: (pin) {
                    setState(() {
                      error_message = null;
                    });
                    if (pin.length == 4) {
                      _onLoading();
                    }
                  },
                  onSaved: (pin) {},
                  validator: (pin) {
                    if (pin.isEmpty) {
                      return 'Pin cannot empty.';
                    }
                    setState(() {});
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                error_message != null
                    ? Text(
                        error_message,
                        style: ThemeConstant.text_style_500_22_1,
                      )
                    : Container(),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Want to Resent code?",
                  style: ThemeConstant.text_style_400_16_3,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
