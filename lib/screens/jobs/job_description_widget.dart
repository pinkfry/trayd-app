import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';

class JobDescription extends StatelessWidget {
  final Job job;

  JobDescription({this.job});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // SizedBox(
        //     width: double.infinity,
        //     child:Hero(
        //         tag: this.job.id + "-title",
        //         child: Text(
        //       this.job.title ?? "",
        //       style:
        //       ThemeConstant.text_style_600_17_3,
        //       textAlign: TextAlign.center,
        //       maxLines: 2,
        //       overflow: TextOverflow.ellipsis,
        //     ))),
        // SizedBox(
        //   height: 8,
        // ),
        // Row(
        //   mainAxisAlignment:
        //   MainAxisAlignment.spaceBetween,
        //   children: <Widget>[
        //     Expanded(
        //         child: Wrap(
        //           children: <Widget>[
        //             Column(
        //               crossAxisAlignment:
        //               CrossAxisAlignment.start,
        //               children: <Widget>[
        //                  Text(
        //                   "Job Type",
        //                   style: ThemeConstant
        //                       .text_style_600_18_3,
        //                 ),
        //                 Row(
        //                   children: <Widget>[
        //                     Expanded(
        //                       child: Text(
        //                         this
        //                             .job
        //                             .service_name ??
        //                             "",
        //                         style: ThemeConstant
        //                             .text_style_500_18_primaryColor,
        //                         maxLines: 1,
        //                       ),
        //                     ),
        //                     SizedBox(
        //                       width: 4,
        //                     ),
        //                     Expanded(
        //                       child: Text(
        //                         this
        //                             .job
        //                             .sub_service ??
        //                             "",
        //                         style: ThemeConstant
        //                             .text_style_500_18_primaryColor,
        //                         maxLines: 1,
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ],
        //         )),
        //   ],
        // ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Job Description",
          style: ThemeConstant.text_style_600_18_3,
        ),
         Text(
            this.job.description ?? "",
            style: ThemeConstant
                .text_style_500_18_primaryColor,
          ),

        SizedBox(
          height: 8,
        ),
        Text(
          "Job Address",
          style: ThemeConstant.text_style_600_18_3,
        ),Text(this.job.address ?? "",
                style: ThemeConstant
                    .text_style_500_18_primaryColor),
        SizedBox(
          height: 8,
        ),
        Text(
          "Service Date",
          style: ThemeConstant.text_style_600_18_3,
        ),
        Text(this.job.service_date ?? "",
            style: ThemeConstant
                .text_style_500_18_primaryColor),
        SizedBox(
          height: 8,
        ),
        Text(
          "Service Time",
          style: ThemeConstant.text_style_600_18_3,
        ),
        Text(this.job.service_time ?? "",
            style: ThemeConstant
                .text_style_500_18_primaryColor),
        SizedBox(
          height: 8,
        ),
        Text(
          "Amount",
          style: ThemeConstant.text_style_600_18_3,
        ),
        Text(
            this.job.amount.toString() + " INR" ??
                "",
            style: ThemeConstant
                .text_style_500_18_primaryColor),
      ],
    );
  }
}
