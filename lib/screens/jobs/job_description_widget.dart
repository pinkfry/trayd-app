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
        SizedBox(
          height: 8,
        ),
        Text(
          "Job Description",
          style: ThemeConstant.text_style_500_18_primaryColor,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          // this.job.description ?? "",
          "Qua procella, illo eternus semel cui propello. Arma iniquus tribuo legentis victum tergo victor repeto, multus. Qui volup amita porro perseverantia. Positus lacunar qui praecepio St. Incertus surgo vires nolo.Cogo, modicus Malbodiensis defigo, maxime nutus. Spectaculum optimus defluo. Locupleto memor tamisium fodio priores, reddo praecox antea, suum. Sitis orbis duro, cedo moris prolusio nimis consui iuvo, imago. Placo novus.",
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          color: Colors.grey,
          height: 1.0,
          width: double.infinity,
        ),
        Table(
          children:[
            TableRow(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical:10.0),
                  child: Text(
                    "Job Address",
                    style: ThemeConstant.text_style_500_18_primaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical:10.0),
                  child: Text(this.job.address ?? "",
                      style: ThemeConstant.text_style_600_17_3),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Service Date",
                    style: ThemeConstant.text_style_500_18_primaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(this.job.service_date ?? "",
                      style: ThemeConstant.text_style_600_17_3),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Service Time",
                    style: ThemeConstant.text_style_500_18_primaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(this.job.service_time ?? "",
                      style: ThemeConstant.text_style_600_17_3),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical:10.0),
                  child: Text(
                    "Amount",
                    style: ThemeConstant.text_style_500_18_primaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(this.job.amount.toString() + " INR" ?? "",
                      style: ThemeConstant.text_style_600_17_3),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
