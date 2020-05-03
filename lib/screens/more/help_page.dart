import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/screens/more/issue_report_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';

class HelpSupportPage extends StatefulWidget {
  static const String tag = 'help-support-page';

  @override
  State<StatefulWidget> createState() {
    return HelpSupportPageState();
  }
}

class HelpSupportPageState extends State<HelpSupportPage> {
  TextEditingController titleEditingController;
  TextEditingController bodyEditingController;
  bool submitting = false;



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
            onTap: () {
              Navigator.pushNamed(context, IssueReportPage.tag);
            },
            title: Text("Do you Have any issue? click to report",
                style: ThemeConstant.text_style_500_18_3),
            trailing: Icon(Icons.error,color: ThemeConstant.color_5,),
          ),
          ListTile(
            onTap: () {},
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Contact", style: ThemeConstant.text_style_500_18_3),
            ),
            subtitle: Text("developer@jobpost.com",
                style: ThemeConstant.text_style_500_12_3),
          ),
          ListTile(
            leading: Icon(Icons.question_answer,color: ThemeConstant.color_5,),
            title: Text("FAQs", style: ThemeConstant.text_style_500_20_3),

          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Lorem ipsum dolor sit amet",
                  style: ThemeConstant.text_style_500_18_3),
            ),
            subtitle: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. ",
              style: ThemeConstant.text_style_500_12_3,
            ),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Lorem ipsum dolor sit amet",
                  style: ThemeConstant.text_style_500_18_3),
            ),
            subtitle: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. ",
              style: ThemeConstant.text_style_500_12_3,
            ),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Lorem ipsum dolor sit amet",
                  style: ThemeConstant.text_style_500_18_3),
            ),
            subtitle: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. ",
              style: ThemeConstant.text_style_500_12_3,
            ),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Lorem ipsum dolor sit amet",
                  style: ThemeConstant.text_style_500_18_3),
            ),
            subtitle: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. ",
              style: ThemeConstant.text_style_500_12_3,
            ),
          ),
        ],
      ),
      appBar: MyAppBars.getBackAppBar("Help & Support", () {
        Navigator.pop(context);
      }),
    );
  }
}
