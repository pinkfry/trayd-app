import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/screens/more/help_page.dart';
import 'package:job_posting_bidding_app/screens/more/privacy_policy.dart';
import 'package:job_posting_bidding_app/screens/profile/edit_profile_page.dart';
import 'package:job_posting_bidding_app/screens/profile/edit_profile_page_2.dart';
import 'package:job_posting_bidding_app/screens/profile/profile_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';

class MoreScreen extends StatefulWidget {
  static String pageName = "More";

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  void initState() {
    super.initState();
  }

  _getBody() {
    return ListView(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.pushNamed(context,ProfilePage.tag);
          },
          title: Text("Account Settings",
            style: ThemeConstant.text_style_500_18_3
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context,HelpSupportPage.tag);

          },
          title: Text("Help & Support",
              style: ThemeConstant.text_style_500_18_3
          ),
        ),
        ListTile(
          onTap: () {},
          title: Text("Payment Methods",
              style: ThemeConstant.text_style_500_18_3
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, PrivacyPolicyPage.tag);
          },
          title: Text("Privacy Policy",
              style: ThemeConstant.text_style_500_18_3),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getBody();
  }
}
