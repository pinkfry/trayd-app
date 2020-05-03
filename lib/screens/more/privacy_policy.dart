import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';

class PrivacyPolicyPage extends StatefulWidget {
  static const String tag = 'privacy-policy-page';

  @override
  State<StatefulWidget> createState() {
    return PrivacyPolicyPageState();
  }
}

class PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ListTile(
              title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                  text: "Intro\n\n",
                  style: ThemeConstant.text_style_400_16_3,
                  children: [
                    TextSpan(
                        text:
                            "APP_NAME takes your privacy seriously. "
                                "To better protect your privacy we provide this privacy policy "
                                "notice explaining the way your personal information "
                                "is collected and used\n\n",
                        style: ThemeConstant.text_style_400_14_3,

                    ),
                    TextSpan(
                        text: "Collection of Routine Information\n\n",
                        style: ThemeConstant.text_style_400_16_3,
                        children: [
                          TextSpan(
                            text:
                            "This app track basic information about their users. "
                                "This information includes, but is not limited to, "
                                "IP addresses, app details,"
                                " timestamps and referring pages. None of this information can "
                                "personally identify specific user to this app."
                                " The information is tracked for routine administration and "
                                "maintenance purposes \n\n ",
                            style: ThemeConstant.text_style_400_14_3,

                          ),
                        ]),

                    TextSpan(
                        text: "Advertisement and Other Third Parties\n\n",
                        style: ThemeConstant.text_style_400_16_3,
                        children: [
                          TextSpan(
                            text:
                            "Advertising partners and other third parties may use cookies, "
                                "scripts and/or web beacons to track "
                                "user activities on this app "
                                "in order to display advertisements and other useful "
                                "information. Such tracking is done directly by the"
                                " third parties through their own servers and "
                                "is subject to their own privacy policies. "
                                "This app has no access or control over these cookies,"
                                " scripts and/or web beacons that may be used by third parties.\n\n",
                            style: ThemeConstant.text_style_400_14_3,

                          ),
                        ]),

                    TextSpan(
                        text: "Links to Third Party Websites\n\n",
                        style: ThemeConstant.text_style_400_16_3,
                        children: [
                          TextSpan(
                            text:
                            "We have included links on this app for your use and reference."
                                " We are not responsible for the privacy policies on "
                                "these websites. You should be aware that the privacy policies "
                                "of these websites may differ from our own.\n\n",
                            style: ThemeConstant.text_style_400_14_3,

                          ),
                        ]),
                    TextSpan(
                        text: "Security\n\n",
                        style: ThemeConstant.text_style_400_16_3,
                        children: [
                          TextSpan(
                            text:
                            "The security of your personal information is important to us,"
                                " but remember that no method of transmission over the Internet,"
                                " or method of electronic storage, is 100% secure. While we strive to use"
                                " commercially acceptable means to protect your personal "
                                "information, we cannot guarantee its absolute security.\n\n",
                            style: ThemeConstant.text_style_400_14_3,

                          ),
                        ]),
                    TextSpan(
                        text: "Changes To This Privacy Policy\n\n",
                        style: ThemeConstant.text_style_400_16_3,
                        children: [
                          TextSpan(
                            text:
                            "This Privacy Policy is effective as of [[Date]] and will remain in effect except with respect to any changes in its provisions in the future, which will be in effect immediately after being posted on this page.\n\n",
                            style: ThemeConstant.text_style_400_14_3,

                          ),
                        ]),
                    TextSpan(
                        text: "Contact Information\n\n",
                        style: ThemeConstant.text_style_400_16_3,
                        children: [
                          TextSpan(
                            text:
                            "For any questions or concerns regarding the privacy policy,"
                                " please send us an email to [[Contact Email Address]].\n\n",
                            style: ThemeConstant.text_style_400_14_3,

                          ),
                        ]),
                  ]),
            ),
          )),
        ],
      ),
      appBar: MyAppBars.getBackAppBar("Privacy Policy", () {
        Navigator.pop(context);
      }),
    );
  }
}
