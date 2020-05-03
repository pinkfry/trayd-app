import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';

class JobListItem extends StatelessWidget {
  final Job job;
  final Function onTab;

  JobListItem({this.job, this.onTab});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Hero(
                          tag: this.job.id + "-description",
                          child: Text(
                            this.job.title??"",
                            style: ThemeConstant.text_style_500_20_3,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Text(
                        "8 km",
                        style: ThemeConstant.text_style_600_18_3,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          Hero(
                            tag: this.job.id + "-sub_service",
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: new BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      new BorderRadius.all(Radius.circular(8))),
                              child: Text(
                                this.job.sub_service ?? "",
                                style: ThemeConstant.text_style_400_14_2,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                        ],
                      ),
                      Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Hero(
                        tag: this.job.id + "-amount",
                        child: Text(
                            "\u20b9 "+this.job.amount.toString() ?? "",
                            style: ThemeConstant.text_style_600_20_3,
                        ),
                      ),
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Text(this.job.service_date ?? "",
                          style: ThemeConstant.text_style_500_16_3),
                      SizedBox(width: 8,),
                      Text(this.job.service_time ?? "",
                          style: ThemeConstant.text_style_500_16_3),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
