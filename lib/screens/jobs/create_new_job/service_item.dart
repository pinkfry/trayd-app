import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';

class ServiceWidget extends StatelessWidget {
  final Service service;
  final Function onTab;

  ServiceWidget({this.service, this.onTab});

  @override
  Widget build(BuildContext context) {
    return Container(

        margin: EdgeInsets.all(2),
        child:InkWell(
            onTap: onTab,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: service.img_url,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 56,
                  ),
                  Expanded(child:Text(service.service_name ?? "",maxLines:2,style: ThemeConstant.text_style_400_14_3,textAlign: TextAlign.center,) ,),
                ],
              ),
            ),
          ));
  }
}
