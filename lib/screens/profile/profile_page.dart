import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/model/user.dart';
import 'package:job_posting_bidding_app/screens/profile/address_view_page.dart';
import 'package:job_posting_bidding_app/screens/profile/edit_profile_page_2.dart';
import 'package:job_posting_bidding_app/screens/profile/rating_review_card.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';

class ProfilePage extends StatefulWidget {
  static const String tag = 'profile-page';
  final String user_id;

  ProfilePage({this.user_id});

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  FirebaseUser firebaseUser;
  User user;
  bool loading = false;

  loadUser() {
    setState(() {
      loading = true;
    });
    FirebaseAuth.instance.currentUser().then((user) {
      this.firebaseUser = user;
      ServerApis().fetchProfile(this.widget.user_id??firebaseUser.uid).then((res) {
        if (mounted) {
          if (res != null &&
              res.success &&
              res.user != null &&
              res.user.length != 0) {
            this.user = res.user[0];
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

  getAddressCard() {
    if (user != null && user.address != null && user.address.length != 0) {
      return Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Address",
                  style: TextStyle(
                    color: ThemeConstant.color_3,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Text(
                  user.address[0].address_line1??"",
                  style: TextStyle(
                    color: ThemeConstant.color_3,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Text(
                  user.address[0].landmark??"",
                  style: TextStyle(
                    color: ThemeConstant.color_3,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          firebaseUser.uid == user.user_id
              ? Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: IconButton(
                          onPressed: () async {
                            await Navigator.pushNamed(
                                context, AddressViewPage.tag,);
                            loadUser();
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),
                        ))
                  ],
                )
              : Container()
        ],
      );
    }
    if (firebaseUser.uid == user.user_id) {
      return Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Address",
                  style: TextStyle(
                    color: ThemeConstant.color_3,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Text(
                  "No address added yet",
                  style: TextStyle(
                    color: ThemeConstant.color_3,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: IconButton(
                    onPressed: () async {
                      await Navigator.pushNamed(
                        context,
                        AddressViewPage.tag,
                      );
                      loadUser();
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                  ))
            ],
          )
        ],
      );
    }
    return Container();
  }

  getRatingReviewCards() {
    if (user != null && user.rating_review != null) {
      List<Widget> list = List();
      for (int i = 0; i < user.rating_review.length; i++) {
        list.add(RatingReviewCard(
          review: user.rating_review[i],
        ));
      }
      if (list.isNotEmpty) {
        return list;
      }
    }
    return [Text("No Review Recevied!")];
  }

  getBody() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (user != null) {
      return Column(children: <Widget>[
        Expanded(
            child: SingleChildScrollView(
                child: Container(
                    width: double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            margin: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.only(
                                topRight: Radius.circular(16),
                                topLeft: Radius.circular(16),
                              ),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Form(
                                  child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: CircleAvatar(
                                          backgroundImage: (user != null &&
                                                  user.img_url != null &&
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
                                          backgroundColor: Colors.grey[200],
                                        ),
                                      )
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                  ),
                                  Text(
                                    user.name ?? "",
                                    style: ThemeConstant.text_style_500_22_3,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  getAddressCard()
                                ],
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Card(
                            margin: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.only(
                                topRight: Radius.circular(16),
                                topLeft: Radius.circular(16),
                              ),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Form(
                                  child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Contact Detail",
                                              style: TextStyle(
                                                color: ThemeConstant.color_3,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                            ),
                                            Text(
                                              user.phone_no ?? "",
                                              style: TextStyle(
                                                color: ThemeConstant.color_3,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                            ),
                                            Text(
                                              user.email ?? "",
                                              style: TextStyle(
                                                color: ThemeConstant.color_3,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Card(
                            margin: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.only(
                                topRight: Radius.circular(16),
                                topLeft: Radius.circular(16),
                              ),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Form(
                                  child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Reviews",
                                              style: TextStyle(
                                                color: ThemeConstant.color_3,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            )
                                          ]..addAll(getRatingReviewCards()),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                            ),
                          ),
                        ])))),
        firebaseUser.uid != user.user_id
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      elevation: 16,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(16),
                      color: ThemeConstant.color_3,
                      onPressed: () async {
                        await Navigator.pushNamed(
                            context, EditProfilePage2.tag);
                        loadUser();
                      },
                      child: Text(
                        "Edit Profile",
                        style: ThemeConstant.text_style_500_18_2,
                      ),
                    )),
              )
      ]);
    }
    return Center(child: Text("Something went wrong, Try Again!"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      body: getBody(),
      appBar: MyAppBars.getBackAppBar("Profile", () {
        Navigator.pop(context);
      }),
    );
  }
}
