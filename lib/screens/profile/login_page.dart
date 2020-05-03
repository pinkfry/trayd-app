import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/database/app_settings.dart';
import 'package:job_posting_bidding_app/screens/home/home_page.dart';
import 'package:job_posting_bidding_app/screens/profile/edit_profile_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/logo_widget.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class LoginPage extends StatefulWidget {
  static const String tag = 'login-page';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String login_error_message;
  String otp_error_message;
  String verificationId;
  bool otp_screen = false;
  bool enableLoginButton = false;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      checkInput();
    });
  }

  void checkInput() {
    if (_phoneController.text.length == 10) {
      setState(() {
        enableLoginButton = true;
      });
    } else {
      setState(() {
        enableLoginButton = false;
      });
    }
    setState(() {
      login_error_message = null;
    });
  }

  Future<void> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth
        .verifyPhoneNumber(
            phoneNumber: "+91"+phone,
            timeout: Duration(seconds: 60),
            verificationCompleted: (AuthCredential credential) async {
              AuthResult result = await _auth.signInWithCredential(credential);
              FirebaseUser user = result.user;

              checkUser(user);
            },
            verificationFailed: (AuthException exception) {
              if (exception.code == "invalidCredential") {
                login_error_message =
                    "Incorrect Format try Eg. +<country-code> <number>";
                setState(() {});
              }
            },
            codeSent: (String verificationId, [int forceResendingToken]) {
              otp_screen = true;
              this.verificationId = verificationId;
              setState(() {});
            },
            codeAutoRetrievalTimeout: null)
        .catchError((err) {
      if (err is PlatformException) {
        login_error_message = login_error_message;
        setState(() {});
      }
    });
  }

  checkUser(FirebaseUser user) {
    if (user != null) {
      ServerApis().login(user.uid).then((res) {
        if (res != null && res.success) {
          if (res.msg != null) {
            SharedPreferencesTest().setUserToken(res.token);
            SharedPreferencesTest().setUserEmail(res.msg.email);
            SharedPreferencesTest().setUserProfile(res.msg.img_url);
            SharedPreferencesTest().setUserFullName(res.msg.name);
            Navigator.of(context).pushNamedAndRemoveUntil(
                HomePage.tag, (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                EditProfilePage.tag, (Route<dynamic> route) => false);
          }
        }
      });
    }
  }

  onPinSubmit(String code) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: code);
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
    _auth.signInWithCredential(credential).then((result) {
      if (mounted) {
        FirebaseUser user = result.user;
        checkUser(user);
      }
    }).catchError((err) {
      if (err is PlatformException) {
        if (err.code == "ERROR_INVALID_VERIFICATION_CODE") {
          Navigator.pop(context);
          otp_error_message = "Invalid OTP";
          setState(() {});
        }
      }
    }).timeout(Duration(seconds: 60), onTimeout: () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      body: !otp_screen
          ? Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: LogoWidget(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Start Finding Jobs!",
                        style: ThemeConstant.text_style_500_22_3,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          hintText: "Enter your 10 digit mobile number",
                          contentPadding: EdgeInsets.all(15.0),
                        ),
                      ),
                      login_error_message != null
                          ? Text(
                              login_error_message,
                              style: ThemeConstant.text_style_400_16_4,
                            )
                          : Container(),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.all(8),
                              color: ThemeConstant.primaryColor,
                              onPressed: enableLoginButton
                                  ? () {
                                      String phoneNumber =
                                          _phoneController.text.trim();
                                      if (phoneNumber.isNotEmpty)
                                        loginUser(phoneNumber, context);
                                    }
                                  : null,
                              child: Text(
                                "Sign In",
                                style: ThemeConstant.text_style_500_22_2,
                              )))
                    ],
                  ),
                )
              ],
            )
          : Column(
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
                        "A verification code has been sent to ${_phoneController.text} via SMS",
                        style: ThemeConstant.text_style_500_22_3,
                        textAlign: TextAlign.center,
                      ),
                      PinInputTextFormField(
                        focusNode: FocusNode(),
                        controller: _otpController,
                        pinLength: 6,
                        decoration: UnderlineDecoration(
                            enteredColor: Colors.green, hintText: "------"),
                        textInputAction: TextInputAction.go,
                        onChanged: (pin) {
                          setState(() {
                            otp_error_message = null;
                          });
                          if (pin.length == 6) {
                            onPinSubmit(pin.trim());
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
                      otp_error_message != null
                          ? Text(
                              otp_error_message,
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
