import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:job_posting_bidding_app/model/user.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';

class RatingReviewCard extends StatelessWidget {
  final Review review;

  RatingReviewCard({this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(review.name??"",style:  TextStyle(
            color: ThemeConstant.color_3,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),),
        ),
        RatingBar(
          initialRating: review.rating.toDouble(),
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: null,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(review.review??"",style:  TextStyle(
            color: ThemeConstant.color_3,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),),
        ),
      ],
    );
  }
}
