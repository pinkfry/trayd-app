import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/screens/orders/orders_as_customer.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';

class MyPostedJobsPage extends StatelessWidget {
  static const String tag="MyPostedJobsPage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      appBar: MyAppBars.getBackAppBar("Posted Jobs", () {
        Navigator.pop(context);
      }),
      body: OrdersAsCustomer(),
    );
  }
}
