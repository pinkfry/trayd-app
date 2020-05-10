import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/screens/home/home_page.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_description_widget.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';

class JobBidPage extends StatefulWidget {
  static const String tag = "JobBidPage";
  final Job job;

  JobBidPage({this.job});

  @override
  _JobBidPageState createState() => _JobBidPageState();
}

class _JobBidPageState extends State<JobBidPage> {
  bool placing_bid = false;
  final _bidAmountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String error_message;
  int bid_amount = 0;

  onBidChange() {
    setState(() {
      if (_bidAmountController.text.isEmpty) {
        bid_amount = 0;
      } else {
        bid_amount = int.parse(_bidAmountController.text);
      }
    });
  }

  @override
  void initState() {
    _bidAmountController.addListener(onBidChange);
    super.initState();
  }

  @override
  void dispose() {
    _bidAmountController.removeListener(onBidChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Job job = this.widget.job;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // navigation bar color
      statusBarColor: ThemeConstant.color_background, // status bar color
    ));
    return Scaffold(
      backgroundColor: ThemeConstant.color_background,
      appBar: MyAppBars.getBackAppBar("Job", () {
        Navigator.pop(context);
      }),
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            CustomScrollView(slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 2,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                  width: double.infinity,
                                  child: Hero(
                                      tag: job.id + "-title",
                                      child: Text(
                                        job.title ?? "",
                                        style:
                                            ThemeConstant.text_style_600_17_3,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  job.service_name ?? "",
                                  style: ThemeConstant
                                      .text_style_600_14_grey,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  job.sub_service ?? "",
                                  style: ThemeConstant
                                      .text_style_600_14_grey,
                                  maxLines: 1,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 60.0,
                          alignment: Alignment.bottomCenter,
                          child: Text(job.amount.toString() + " INR" ?? "",
                              textAlign: TextAlign.end,
                              style: ThemeConstant
                                  .text_style_500_18_primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                        ),
                        elevation: 0.0,
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                JobDescription(
                                  job: this.widget.job,
                                ),
                                TextFormField(
                                  controller: _bidAmountController,
                                  style: ThemeConstant.text_style_600_18_3,
                                  decoration: const InputDecoration(
                                      labelText: 'Bid Amount(INR)'),
                                  validator: RequiredValidator(
                                      errorText: 'Bid Amount Required'),
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "Fees: 20% of the bid amount",
                                          textAlign: TextAlign.end,
                                        )),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: bid_amount != 0
                                          ? Text(
                                              "You will recieve: " +
                                                  ((bid_amount * 0.8).round())
                                                      .toString() +
                                                  " INR",
                                              textAlign: TextAlign.end,
                                              style: ThemeConstant
                                                  .text_style_400_16_3,
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                                error_message != null
                                    ? Text(error_message)
                                    : Container()
                              ],
                            ))),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ]),
              ),
            ]),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      elevation: 16,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(16),
                      color: ThemeConstant.primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          if (!placing_bid) {
                            placing_bid = true;
                            setState(() {});
                            FirebaseAuth.instance.currentUser().then((user) {
                              if (mounted) {
                                ServerApis()
                                    .placeBid(user.uid, widget.job.id,
                                        int.parse(_bidAmountController.text))
                                    .then((res) {
                                  if (mounted) {
                                    if (res != null && res.success) {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(HomePage.tag,
                                              (Route<dynamic> route) => false)
                                          .then((e) {});
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          // return object of type Dialog
                                          return AlertDialog(
                                            title: CircleAvatar(
                                              radius: 30,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(Icons.done,
                                                    size: 40,
                                                    color:
                                                        ThemeConstant.color_2),
                                              ),
                                              backgroundColor:
                                                  ThemeConstant.primaryColor,
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  "Bid Placed",
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  "Employer will review your bid and hire you if interested!",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  "Close",
                                                  style: TextStyle(
                                                      color: ThemeConstant
                                                          .primaryColor),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else if (res != null &&
                                        res.message != null) {
                                      setState(() {
                                        error_message = res.message;
                                      });
                                    }
                                    setState(() {
                                      placing_bid = false;
                                    });
                                  }
                                });
                              }
                            });
                          }
                        }
                      },
                      child: Text(
                        !placing_bid ? "Place Bid" : "Placing Bid...",
                        style: ThemeConstant.text_style_500_18_2,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
