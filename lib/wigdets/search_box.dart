import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';

class SearchBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(left: 16,right: 16,bottom: 8,top: 8),
      child:  Container(
          width: double.infinity,
          child: TextFormField(
            style: ThemeConstant.text_style_500_22_3,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: ThemeConstant.text_style_500_22_1,
              prefixIcon: Icon(Icons.search),
            )
        ),
      ),
    );
  }
}
