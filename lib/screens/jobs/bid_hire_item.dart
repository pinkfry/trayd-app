import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/screens/messages/message_detail_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';

class BidHireItem extends StatelessWidget {
  final Bid bid;
  final Expert expert;

  final Function onHire;
  final Function onCancelHire;
  final Function onProvideFeedback;
  final Function onMessage;
  final Function onProfileClick;

  BidHireItem(
      {this.bid, this.expert,  this.onProfileClick, this.onHire, this.onCancelHire,this.onProvideFeedback, this.onMessage});

  @override
  Widget build(BuildContext context) {
    print("expert.hire_status");
    print(expert.hire_status);
    return Card(
      margin: const EdgeInsets.only(top: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: onProfileClick,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://i.pravatar.cc/111'),
                                minRadius: 35,
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: onProfileClick,
                        child: Text(
                          bid.name ?? "",
                          style: TextStyle(
                            color: ThemeConstant.color_3,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    bid.bid_amount.toString() + " INR" ?? "",
                    style: ThemeConstant.text_style_600_18_3,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                (expert!=null && expert.expert_status==0)?Padding(
                  padding: EdgeInsets.all(4),
                  child: RaisedButton(
                    child: Text(
                      expert.hire_status == 0
                          ? "Hire"
                          : (expert.hire_status == 1
                              ? "Cancel Hire"
                              : (expert.hire_status == 2 ? "Completed" : "")),
                      style: ThemeConstant.text_style_500_16_2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.all(4),
                    color: expert.hire_status == 0
                        ? ThemeConstant.primaryColor
                        : (expert.hire_status == 1
                            ? ThemeConstant.color_4
                            : (expert.hire_status == 2
                                ? ThemeConstant.primaryColor
                                : ThemeConstant.primaryColor)),
                    onPressed: expert.hire_status == 0
                        ? onHire
                        : (expert.hire_status == 1
                            ? onCancelHire
                            : (expert.hire_status == 2 ? null : null)),
                  ),
                ):Container(),
                (expert!=null && expert.expert_status==2)?Padding(
                  padding: EdgeInsets.all(4),
                  child: RaisedButton(
                    child: Text(
                     "Provide Feedback",
                      style: ThemeConstant.text_style_500_16_2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.all(4),
                    color: ThemeConstant.primaryColor,
                    onPressed: onProvideFeedback,
                  ),
                ):Container(),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: RaisedButton(
                    child: Text(
                      "Message",
                      style: ThemeConstant.text_style_500_16_2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.all(4),
                    color: ThemeConstant.color_3,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetails(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
