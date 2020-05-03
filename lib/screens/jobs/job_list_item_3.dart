import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';

class JobListItem3 extends StatelessWidget {
  final Job job;
  final String user_id;
  final Function onTab;

  JobListItem3({this.job,this.user_id, this.onTab});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: InkWell(
          onTap: onTab,
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: this.job.id + "-service_name",
                    child: Text(
                      this.job.service_name ?? "",
                      style: ThemeConstant.text_style_600_18_3,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          this.job.getStatus()!=null?Container(
                              padding: EdgeInsets.all(4),
                              decoration: new BoxDecoration(
                                  color:  this.job.getExpertHireStatusColor(user_id),
                                  borderRadius:
                                      new BorderRadius.all(Radius.circular(8))),
                              child: Text(
                                this.job.getExpertHireStatus(user_id) ?? "",
                                style: ThemeConstant.text_style_400_14_2,
                              ),
                            ):Container(),
                        ],
                      ),
                      Hero(
                        tag: this.job.id + "-amount",
                        child: Text(
                          this.job.amount.toString() + " INR" ?? "",
                          style: ThemeConstant.text_style_600_18_3,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                          (job.created_on_date??"")+" "+(job.created_on_time??""),
                          style: ThemeConstant.text_style_600_18_3,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
