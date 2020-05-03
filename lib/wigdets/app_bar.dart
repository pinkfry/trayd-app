import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/utils/utils.dart';
import 'package:latlong/latlong.dart';

import 'package:latlong/latlong.dart' as latlong;
import 'package:location/location.dart';

class MyAppBars {
  BuildContext context;
  MyAppBars.first(BuildContext context){
    this.context=context;

  }
  LatLng latLng;
  static AppBar getMenuAppBar(String screen_name, Function onMenuPressed,BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeConstant.primaryColor,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: onMenuPressed),
        title: GestureDetector(
            onTap: () {
              getLocation(context);
            },
            child: Text(
              screen_name,
              style: TextStyle(color: Colors.white),
            )));
  }

  static AppBar getBackAppBar(String screen_name, Function onBackPressed) {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeConstant.primaryColor,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBackPressed),
        title: Text(
          screen_name,
          style: TextStyle(color: Colors.white),
        ));
  }

  static AppBar getCrossButtonAppBar(
      String screen_name, Function onCrossPressed) {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 8, // button color
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.clear,
                    color: ThemeConstant.color_3,
                    size: 18,
                  ),
                ),
                onTap: onCrossPressed,
              ),
            ),
            Text(
              screen_name ?? "",
              style: ThemeConstant.text_style_600_22_3,
              textAlign: TextAlign.start,
            ),
            SizedBox(
              width: 1,
            )
          ],
        ));
  }



  static getLocation(BuildContext context) async {
    if (await Location().hasPermission() == PermissionStatus.GRANTED) {
      LocationResult result = await showLocationPicker(
        context,
        "AIzaSyDzHhxbODUJJ2jD3sFt8M77d1qCvOGTp1I",
        myLocationButtonEnabled: true,
      );
      // print(result);
      // if (result != null && result.latLng != null) {
      //   this.latLng =
      //       latlong.LatLng(result.latLng.latitude, result.latLng.longitude);
        // Utils.getPredictionFromLatLng(latLng).then((res) {
        //   if (mounted) {
        //     if (res != null) {
        //       if (user != null) {
        //         setState(() {
        //           user.google_address = res.featureName;
        //         });
        //       }
        //       if (mounted) {
        //         ServerApis().addLatLng(user.user_id, result.latLng.latitude,
        //             result.latLng.longitude);
        //       }
        //     }
        //   }
        // });
      // } 
      // else {
      //   // this.latLng = null;
      // }
    } else {
      getLocationPermission();
    }
  }
   static  getLocationPermission() async {
    var location = new Location();
    try {
      location.requestPermission(); //to lunch location permission popup
    } on Exception catch (e) {}
  }
}
