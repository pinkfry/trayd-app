import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class JobsListLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: 160,
                height: 12,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 60.0,
                        height: 12.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: 60.0,
                        height: 12.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Container(
                    width: 30,
                    height: 12,
                    color: Colors.white,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                width: 50,
                height: 12,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                width: 150,
                height: 12,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
