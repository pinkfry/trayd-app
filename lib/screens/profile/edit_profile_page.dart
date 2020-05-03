import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/database/app_settings.dart';
import 'package:job_posting_bidding_app/screens/home/home_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';

class EditProfilePage extends StatefulWidget {
  static const String tag = 'edit-profile-page';

  @override
  State<StatefulWidget> createState() {
    return EditProfilePageState();
  }
}

class EditProfilePageState extends State<EditProfilePage> {
  String error_message;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String password;
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        elevation: 16,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.person,
                                        color: ThemeConstant.color_3,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              TextFormField(
                                                controller: _nameController,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText:
                                                            "Enter Your full name"),
                                                validator: RequiredValidator(
                                                    errorText:
                                                        'this field is required'),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 1,
                                                color:
                                                    ThemeConstant.primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.mail,
                                        color: ThemeConstant.color_3,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              TextFormField(
                                                controller: _emailController,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText: "Email *"),
                                                validator: EmailValidator(
                                                    errorText:
                                                        'enter a valid email address'),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 1,
                                                color:
                                                    ThemeConstant.primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.lock,
                                        color: ThemeConstant.color_3,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              TextFormField(
                                                controller: _passwordController,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText:
                                                            "Enter new password"),
                                                obscureText: true,
                                                onChanged: (val) =>
                                                    password = val,
                                                // assign the the multi validator to the TextFormField validator
                                                validator: passwordValidator,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 1,
                                                color:
                                                    ThemeConstant.primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.lock,
                                        color: ThemeConstant.color_3,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              TextFormField(
                                                controller:
                                                    _confirmPasswordController,
                                                obscureText: true,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText:
                                                            "Confirm password again"),
                                                validator: (val) => MatchValidator(
                                                        errorText:
                                                            'passwords do not match')
                                                    .validateMatch(
                                                        val, password),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 1,
                                                color:
                                                    ThemeConstant.primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          error_message != null
              ? Text(
                  error_message,
                  style: ThemeConstant.text_style_400_16_4,
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(16),
                  color: ThemeConstant.primaryColor,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      registerUser();
                    }
                  },
                  child: Text(
                    "Save",
                    style: ThemeConstant.text_style_500_22_2,
                  ),
                )),
          ),
        ],
      ),
      appBar: MyAppBars.getBackAppBar("Update Basic Info", null),
    );
  }

  registerUser() {
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
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.currentUser().then((user) {
      ServerApis()
          .registration(_nameController.text, _emailController.text, password,
              user.uid, user.phoneNumber)
          .then((res) {
        if (mounted) {
          if (res != null) {
            if (res.success) {
              if (res.user_details != null && res.token != null) {
                SharedPreferencesTest().setUserToken(res.token);
                SharedPreferencesTest().setUserEmail(res.user_details.email);
                SharedPreferencesTest().setUserFullName(res.user_details.name);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    HomePage.tag, (Route<dynamic> route) => false);
              } else {
                Navigator.pop(context);
                error_message =
                    "You have entered dublicate detail!. Try Again!";
                setState(() {});
              }
            } else {
              Navigator.pop(context);
              error_message = "Some error occured!";
              setState(() {});
            }
          } else {
            Navigator.pop(context);
            error_message = "Server not responding.. Try again!";
            setState(() {});
          }
        }
      });
    });
  }
}
