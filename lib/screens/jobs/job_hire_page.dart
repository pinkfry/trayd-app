import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/screens/jobs/bid_hire_item.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_description_widget.dart';
import 'package:job_posting_bidding_app/screens/profile/profile_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/utils/utils.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';

class JobHirePage extends StatefulWidget {
  static const String tag = "JobHirePage";
  final Job job;

  JobHirePage({this.job});

  @override
  _JobHirePageState createState() => _JobHirePageState();
}

class _JobHirePageState extends State<JobHirePage> {
  bool loading_job = false;
  Job job;
  final _FeedBackFormKey = GlobalKey<FormState>();
  final _FeedBackTextController = TextEditingController();
  double _feedBackRating = 1;
  FirebaseUser firebaseUser;

  onHire(Bid bid) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Do you really want to hire " +
                bid.name +
                " in " +
                bid.bid_amount.toString() +
                " INR ?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  ServerApis().hire(bid.user_id, job.id).then((res) {
                    if (mounted) {
                      if (res.success) {
                        loadJob();
                      }
                    }
                  });
                },
                child: Text("Yes"),
              ),
            ],
          );
        });
  }

  onCancelHire(Bid bid) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Do you really want to cancel hire " + bid.name + " ?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  ServerApis().cancelHire(bid.user_id, job.id).then((res) {
                    if (mounted) {
                      if (res.success) {
                        loadJob();
                      }
                    }
                  });
                },
                child: Text("Yes"),
              ),
            ],
          );
        });
  }

  onProvideFeedback(String user_id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: RatingBar(
              initialRating: _feedBackRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _feedBackRating = rating;
              },
            ),
            content: Form(
                key: _FeedBackFormKey,
                child: TextFormField(
                  controller: _FeedBackTextController,
                  decoration: InputDecoration(hintText: "Your feedback"),
                  validator:
                      RequiredValidator(errorText: 'this field is required'),
                  maxLines: 2,
                )),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () {
                  if (_FeedBackFormKey.currentState.validate()) {
//                    Navigator.pop(context);
                    ServerApis()
                        .addReview(
                            firebaseUser.uid,
                            user_id,
                            _feedBackRating.round(),
                            _FeedBackTextController.text)
                        .then((res) {
                      if (res != null) {
                        if (res.success) {
                          Navigator.pop(context);
                        }
                      }
                    });
                  }
                },
                child: Text("Yes"),
              ),
            ],
          );
        });
  }

  Widget getHiredBid() {
    if (job != null && job.bids != null) {
      for (int i = 0; i < job.bids.length; i++) {
        Expert expert = Expert();
        if (job.selected_expert != null) {
          if (job.selected_expert == job.bids[i].user_id) {
            print("expert_status");
            expert.hire_status = job.status;
            expert.expert_status = job.expert_status;
            return BidHireItem(
              bid: job.bids[i],
              expert: expert,
              onHire: () {
                onHire(job.bids[i]);
              },
              onCancelHire: () {
                onCancelHire(job.bids[i]);
              },
              onProvideFeedback: () {
                onProvideFeedback(job.bids[i].user_id);
              },
              onProfileClick: () {
                Navigator.pushNamed(context, ProfilePage.tag,
                    arguments: job.bids[i].user_id);
              },
            );
          }
        }
      }
    }
    return Container();
  }

  List<Widget> getBids() {
    List<Widget> list = List();
    if (job != null && job.bids != null) {
      for (int i = 0; i < job.bids.length; i++) {
        Expert expert = Expert();
        if (job.selected_expert != null) {
          if (job.selected_expert == job.bids[i].user_id) {
            print("expert_status");
            expert.hire_status = job.status;
            expert.expert_status = job.expert_status;
          }
        }

        list.add(BidHireItem(
          bid: job.bids[i],
          expert: expert,
          onHire: () {
            onHire(job.bids[i]);
          },
          onCancelHire: () {
            onCancelHire(job.bids[i]);
          },
          onProvideFeedback: () {
            onProvideFeedback(job.bids[i].user_id);
          }, onProfileClick: () {
          Navigator.pushNamed(context, ProfilePage.tag,
              arguments: job.bids[i].user_id);
        },
        ));
      }
    }
    if (list.length == 0) {
      return [
        Text(
          "No bids",
          style: ThemeConstant.text_style_500_16_3,
        )
      ];
    }
    return list;
  }

  @override
  void initState() {
    loadJob();
    super.initState();
  }

  loadJob() {
    loading_job = true;
    FirebaseAuth.instance.currentUser().then((user) {
      this.firebaseUser = user;
      ServerApis().getJobById(widget.job.id).then((res) {
        if (mounted) {
          if (res != null) {
            if (res.success && res.jobs != null && res.jobs.length != 0) {
              job = res.jobs[0];
            }
          }
          setState(() {
            loading_job = false;
          });
        }
      });
    });
  }

  getBody() {
    if (loading_job) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (job != null) {
      return Form(
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Card(
                          margin: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(6.0),
                          ),
                          elevation: 4,
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    JobDescription(
                                      job: this.job,
                                    )
                                  ],
                                ),
                              ))),
                      (job.selected_expert != null &&
                              job.selected_expert.isNotEmpty)
                          ? Container(
                              width: double.infinity,
                              child: Card(
                                  margin: const EdgeInsets.all(8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(6.0),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Project Status",
                                          style:
                                              ThemeConstant.text_style_600_18_3,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              job.expert_status == 1
                                                  ? Icons.directions_bike
                                                  : job.expert_status == 2
                                                      ? Icons.done
                                                      : Icons.alarm,
                                              color: ThemeConstant.primaryColor,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              job.expert_status == 1
                                                  ? "Expert is Coming for the job!"
                                                  : job.expert_status == 2
                                                      ? "Project is Marked Completed By Expert"
                                                      : "Waiting for Expert reponse",
                                              style: ThemeConstant
                                                  .text_style_500_16_3,
                                            )
                                          ],
                                        )
                                      ]..add(getHiredBid()),
                                    ),
                                  )))
                          : Container(),
                      Container(
                          width: double.infinity,
                          child: Card(
                              margin: const EdgeInsets.all(8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Bids",
                                      style: ThemeConstant.text_style_600_18_3,
                                    ),
                                  ]..addAll(getBids()),
                                ),
                              ))),
                    ],
                  ),
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
                      color: ThemeConstant.color_4,
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title:
                                    Text("Do you want really delete this job?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Yes"),
                                    onPressed: () {
                                      FirebaseAuth.instance
                                          .currentUser()
                                          .then((user) {
                                        ServerApis()
                                            .deleteJob(user.uid, job.id)
                                            .then((res) {
                                          if (res != null) {
                                            if (mounted) {
                                              Navigator.pop(context);
                                              Navigator.of(context)
                                                  .pop("relaod");
                                              Utils.showDialogOfApp(
                                                  context,
                                                  "Deleted",
                                                  "Job is paramanently deleted!");
                                            }
                                          }
                                        });
                                      });
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Text(
                        "Delete Job",
                        style: ThemeConstant.text_style_500_18_2,
                      ),
                    )),
              ),
            ],
          ),
        ),
      );
    }
    return Center(
      child: Text("Some unknown error occured!"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      body: getBody(),
      appBar: MyAppBars.getBackAppBar("Your Posted Job", () {
        Navigator.pop(context);
      }),
    );
  }
}
