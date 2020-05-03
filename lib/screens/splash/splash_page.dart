import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/database/app_settings.dart';
import 'package:job_posting_bidding_app/screens/home/home_page.dart';
import 'package:job_posting_bidding_app/screens/profile/edit_profile_page.dart';
import 'package:job_posting_bidding_app/screens/profile/login_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/app_version.dart';
import 'package:job_posting_bidding_app/wigdets/logo_widget.dart';

class SplashPage extends StatefulWidget {
  static const String tag = 'splash-page';

  @override
  State<StatefulWidget> createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showSnackBar = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => check_status());
    super.initState();
  }

  void check_status() {
    Future.delayed(Duration(seconds: 1), () {
      if(mounted) {
        FirebaseAuth auth = FirebaseAuth.instance;
        auth.currentUser().then((user) {
          if (user != null) {
            ServerApis().login(user.uid).then((res) {
              if (res != null) {
                if(res.success && res.token != null){
                SharedPreferencesTest().setUserToken(res.token);
                if (res.msg != null) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomePage.tag, (Route<dynamic> route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      EditProfilePage.tag, (Route<dynamic> route) => false);
                }}
              }else{
                setState(() {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Server is not reachable!'),
                    duration: Duration(minutes: 10),
                    action: SnackBarAction(
                      label: 'Retry',
                      onPressed: () {
                        check_status();
                      },
                    ),
                  ));
                });
              }
            });
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginPage.tag, (Route<dynamic> route) => false);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      key: _scaffoldKey,
      body: Stack(children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: LogoWidget(),
        ),
        Align(
          alignment: Alignment.topRight,
          child: SvgPicture.asset(
            "assets/images/top_right.svg",
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: AppVersion(),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: SvgPicture.asset(
            "assets/images/bottom_left.svg",
          ),
        ),
      ]),
    );
  }
}
