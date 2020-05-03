import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      if(_bidAmountController.text.isEmpty){
        bid_amount=0;
      }else {
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
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                      margin: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      elevation: 4,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
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
                                        child: Text("Fees: 20% of the bid amount",textAlign: TextAlign.end,)),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: bid_amount != 0 ? Text(
                                          "You will recieve: " +
                                              ((bid_amount * 0.8).round()).toString() +
                                              " INR",textAlign: TextAlign.end,style: ThemeConstant.text_style_400_16_3,) : Container(),
                                    ),
                                  ],
                                ),
                                error_message != null
                                    ? Text(error_message)
                                    : Container()
                              ],
                            ),
                          ))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
            ],
          ),
        ),
      ),
      appBar: MyAppBars.getBackAppBar("Job", () {
        Navigator.pop(context);
      }),
    );
  }
}
