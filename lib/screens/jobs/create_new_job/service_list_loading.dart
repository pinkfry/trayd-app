import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class ServiceListLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                width: double.infinity,
                height: 8.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}