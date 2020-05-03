import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/screens/jobs/bid_expert_item.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_description_widget.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/utils/utils.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';

class JobExpertPage extends StatefulWidget {
  static const String tag = "JobExpertPage";
  final Job job;

  JobExpertPage({this.job});

  @override
  _JobExpertPageState createState() => _JobExpertPageState();
}

class _JobExpertPageState extends State<JobExpertPage> {
  bool loading_job = false;
  Job job;
  FirebaseUser user;
  TextEditingController _bidUpdateFieldController = TextEditingController();

  onEditHire() {
    if (_bidUpdateFieldController.text != null &&
        _bidUpdateFieldController.text.isNotEmpty) {
      FirebaseAuth.instance.currentUser().then((user) {
        ServerApis()
            .updateBid(
                job.bid_id, job.id, int.parse(_bidUpdateFieldController.text))
            .then((res) {
          if (res != null) {
            if (mounted) {
              Navigator.pop(context);
              Navigator.of(context).pop("relaod");
              Utils.showDialogOfApp(
                  context, "Updated", "You have updated your bid!");
            }
          }
        });
      });
    }
  }

  onRetractHire() {
    FirebaseAuth.instance.currentUser().then((user) {
      ServerApis().cancelBid(job.bid_id, job.id).then((res) {
        if (res != null) {
          if (mounted) {
            Navigator.pop(context);
            Navigator.of(context).pop("relaod");
            Utils.showDialogOfApp(
                context, "Retracted", "You have retract you bid!");
          }
        }
      });
    });
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

        list.add(BidExpertItem(
          bid: job.bids[i],
          expert: expert,
        ));
      }
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
      if (mounted) {
        setState(() {
          this.user = user;
        });
        ServerApis().getJobById(widget.job.id).then((res) {
          if (mounted) {
            if (res != null) {
              if (res.success && res.jobs != null && res.jobs.length != 0) {
                job = res.jobs[0];
                job.bid_id = widget.job.bid_id;
              }
            }
            setState(() {
              loading_job = false;
            });
          }
        });
      }
    });
  }

  updateStatus(int status) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
                status==1?"Are you sure that your going to complete job now?":"Are you sure that you have completed the job?"),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: (){
                  if(status==1){
                    ServerApis().goingOutForService(job.id).then((res){
                      if(mounted){
                        Navigator.pop(context);
                        loadJob();
                      }
                    });
                  }else{
                    ServerApis().completedTheJob(job.id).then((res){
                      if(mounted){
                        Navigator.pop(context);
                        loadJob();
                      }
                    });
                  }
                },
              ),
            ],
          );
        });
  }

  getBody() {
    if (loading_job) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (job != null && user != null) {
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
                            borderRadius: new BorderRadius.circular(4.0),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                JobDescription(job: this.job,)
                              ],
                            ),
                          )),
                      job.selected_expert == user.uid
                          ? Container(
                              width: double.infinity,
                              child: Card(
                                  margin: const EdgeInsets.all(8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Your are hired for this job!",
                                                style: ThemeConstant
                                                    .text_style_500_14_primaryColor),
                                          ]))),
                            )
                          : Container(),
                      (job.selected_expert == user.uid)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    elevation: 16,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    color: ThemeConstant.color_3,
                                    onPressed: job.expert_status == 1
                                        ? () {
                                      updateStatus(2);
                                    }
                                        : job.expert_status == 2
                                            ? null
                                            : () {
                                      updateStatus(1);
                                    },
                                    child: Text(
                                      job.expert_status == 1
                                          ? "Press to Complete!"
                                          : job.expert_status == 2
                                              ? "Project is Completed!"
                                              : "Coming for job now!",
                                      style: ThemeConstant.text_style_500_18_2,
                                    ),
                                  )))
                          : Container(),
                    ],
                  ),
                ),
              ),
              job.selected_expert != user.uid?Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          elevation: 16,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(16),
                          color: ThemeConstant.primaryColor,
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    content: TextField(
                                      controller: _bidUpdateFieldController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: "Bid Amount"),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                          child: Text("Yes"),
                                          onPressed: onEditHire),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Edit Bid",
                            style: ThemeConstant.text_style_500_18_2,
                          ),
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
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
                                    title: Text(
                                        "Do you want really retract your Bid?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Yes"),
                                        onPressed: onRetractHire,
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Retract Bid",
                            style: ThemeConstant.text_style_500_18_2,
                          ),
                        )),
                  ],
                ),
              ):Container(),
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
      appBar: MyAppBars.getBackAppBar("Job As Expert", () {
        Navigator.pop(context);
      }),
    );
  }
}
