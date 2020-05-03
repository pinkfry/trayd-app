import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/database/app_settings.dart';
import 'package:job_posting_bidding_app/model/user.dart';
import 'package:job_posting_bidding_app/screens/home/home_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';

class EditProfilePage2 extends StatefulWidget {
  static const String tag = 'edit-profile-page-2';

  @override
  State<StatefulWidget> createState() {
    return EditProfilePage2State();
  }
}

class EditProfilePage2State extends State<EditProfilePage2> {
  String error_message;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  FirebaseUser firebaseUser;
  User user;
  bool loading = false;
  bool uploading_profile_pic = false;

  Future _pickSaveImage() async {
    File imageFile = await FilePicker.getFile(type: FileType.image);
    if (imageFile != null && mounted) {
      setState(() {
        uploading_profile_pic = true;
      });
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child("profile_pics")
          .child(firebaseUser.uid)
          .child("profile.jpg");
      StorageUploadTask uploadTask = ref.putFile(imageFile);
      String url = await (await uploadTask.onComplete).ref.getDownloadURL();
      ServerApis().update_image(user.user_id, url).then((res) {
        if (mounted) {
          if (res != null) {
            if (res.success) {
              loadUser(silent_load: true);
            }
          }
          setState(() {
            uploading_profile_pic = false;
          });
        }
      });
    }
  }

  loadUser({bool silent_load = false}) {
    FirebaseAuth.instance.currentUser().then((user) {
      this.firebaseUser = user;
      if (!silent_load) {
        setState(() {
          loading = true;
        });
      }
      ServerApis().fetchProfile(user.uid).then((res) {
        if (mounted) {
          if (res != null &&
              res.success &&
              res.user != null &&
              res.user.length != 0) {
            this.user = res.user[0];
            SharedPreferencesTest().setUserEmail(this.user.email);
            SharedPreferencesTest().setUserProfile(this.user.img_url);
            SharedPreferencesTest().setUserFullName(this.user.name);
            _nameController.text = this.user.name;
            _emailController.text = this.user.email;
          }
          setState(() {
            loading = false;
          });
        }
      });
    });
  }

  @override
  void initState() {
    loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Container(
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        (user != null &&
                                                                user.img_url !=
                                                                    null &&
                                                                user.img_url
                                                                    .trim()
                                                                    .isNotEmpty)
                                                            ? NetworkImage(
                                                                user.img_url,
                                                              )
                                                            : AssetImage(
                                                                "assets/images/default_picture.png",
                                                              ),
                                                    minRadius: 35,
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            FlatButton(
                                              child: Text(uploading_profile_pic
                                                  ? "Uploading..."
                                                  : "Upload new Picture"),
                                              onPressed: !uploading_profile_pic
                                                  ? () {
                                                      _pickSaveImage();
                                                    }
                                                  : null,
                                            )
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.person,
                                              color: ThemeConstant.color_3,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    TextFormField(
                                                      controller:
                                                          _nameController,
                                                      decoration: InputDecoration
                                                          .collapsed(
                                                              hintText:
                                                                  "Enter Your full name"),
                                                      validator: RequiredValidator(
                                                          errorText:
                                                              'this field is required'),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 1,
                                                      color: ThemeConstant
                                                          .primaryColor,
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    TextFormField(
                                                      controller:
                                                          _emailController,
                                                      decoration: InputDecoration
                                                          .collapsed(
                                                              hintText:
                                                                  "Email *"),
                                                      validator: EmailValidator(
                                                          errorText:
                                                              'enter a valid email address'),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 1,
                                                      color: ThemeConstant
                                                          .primaryColor,
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
                            updateUserInfo();
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
      appBar: MyAppBars.getBackAppBar("Edit Profile", () {
        Navigator.pop(context);
      }),
    );
  }

  updateUserInfo() {
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
          .updateProfileInfo(
              _nameController.text, _emailController.text, user.uid)
          .then((res) {
        if (mounted) {
          if (res != null) {
            if (res.success) {
                SharedPreferencesTest().setUserEmail( _emailController.text);
                SharedPreferencesTest().setUserFullName(_nameController.text);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    HomePage.tag, (Route<dynamic> route) => false);
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
