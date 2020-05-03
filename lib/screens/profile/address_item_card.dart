import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/model/user.dart';
import 'package:job_posting_bidding_app/screens/profile/address_view_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';

class AddressListItem extends StatelessWidget {
  final Address address;
  final Function onTap;

  AddressListItem({this.address,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    address.address_line1??"",
                    style: TextStyle(
                      color: ThemeConstant.color_3,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  Text(
                    address.address_line2??"",
                    style: TextStyle(
                      color: ThemeConstant.color_3,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  Text(
                    address.landmark??"",
                    style: TextStyle(
                      color: ThemeConstant.color_3,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  Text(
                    address.lat.toString() + "," + address.lng.toString(),
                    style: TextStyle(
                      color: ThemeConstant.color_3,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: IconButton(
                      onPressed: onTap,
                      icon: Icon(
                        Icons.edit,
                        color: ThemeConstant.color_3,
                        size: 18,
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
