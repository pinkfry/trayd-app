import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/screens/messages/message_detail_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';

class BidExpertItem extends StatelessWidget {
  final Bid bid;
  final Expert expert;

  BidExpertItem(
      {this.bid, this.expert});

  @override
  Widget build(BuildContext context) {
    print("expert.hire_status");
    print(expert.hire_status);
    return Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      bid.name ?? "",
                      style: TextStyle(
                        color: ThemeConstant.color_3,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
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
            ],
          ),
        ),
      );
  }
}
