import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/utils/utils.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';


class IssueReportPage extends StatefulWidget {
  static const String tag = 'issue-report-page';

  @override
  State<StatefulWidget> createState() {
    return IssueReportPageState();
  }
}

class IssueReportPageState extends State<IssueReportPage> {
  TextEditingController titleEditingController;
  TextEditingController bodyEditingController;
  bool submitting = false;
  final _formKey = GlobalKey<FormState>();

  void showAlert() {
    Utils.showDialogOfApp(context, "Issue Reported", "We will get back to you on the issue soon");
  }

  @override
  void initState() {
    super.initState();
    titleEditingController = TextEditingController();
    bodyEditingController = TextEditingController();
  }

  void register_complaint_customer() {
    showAlert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Issue Title",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: titleEditingController,
                          validator: (i) {
                            if (i.trim() == "") {
                              return "Please enter title of the issue";
                            }
                            return null;
                          },
                          style: TextStyle(
                              color: ThemeConstant.primaryColor, fontSize: 18),
                          decoration: InputDecoration(
                            hintText: "Please enter issue title",
                            fillColor: ThemeConstant.color_2,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(16.0),
                              ),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 0.0),
                            ),
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Issue Description",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: bodyEditingController,
                          validator: (i) {
                            if (i.trim() == "") {
                              return "Please enter brief information about the issue";
                            }
                            return null;
                          },
                          style: TextStyle(
                              color: ThemeConstant.primaryColor, fontSize: 18),
                          decoration: InputDecoration(
                            hintText: "Please enter issue description",
                            fillColor: ThemeConstant.color_2,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(16.0),
                              ),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 0.0),
                            ),
                          ),
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(8),
                      color: ThemeConstant.primaryColor,
                      onPressed: !submitting
                          ? () {
                        if (_formKey.currentState.validate()) {
                          register_complaint_customer();
                        }
                      }
                          : null,
                      child: !submitting
                          ? Text(
                        "SUBMIT",
                        style: ThemeConstant.text_style_400_20_2,
                      )
                          : Center(child: CircularProgressIndicator()),
                    )),
              )
            ],
          )),
      appBar: MyAppBars.getBackAppBar("Report an Issue", (){
        Navigator.pop(context);
      }),
    );
  }
}

