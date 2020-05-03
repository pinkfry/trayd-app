import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:latlong/latlong.dart';
import 'package:geocoder/geocoder.dart';

class Utils {
  static List<String> stringListFromJson(List<dynamic> json) {
    List<String> strings = List();
    if (json == null) return strings;
    for (int i = 0; i < json.length; i++) {
      strings.add(json[i]);
    }
    return strings;
  }

  static Future<Address> getPredictionFromLatLng(LatLng latLng) async {
    try {
      final coordinates = new Coordinates(latLng.latitude, latLng.longitude);
      List<Address> addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
      Address first = addresses.first;
      print("${first.featureName} : ${first.addressLine}");
      return first;
    } catch (e) {
      return null;
    }
  }
  static void showDialogOfApp(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.done, size: 40, color: ThemeConstant.color_2),
            ),
            backgroundColor: ThemeConstant.primaryColor,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title ?? "",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                message ?? "",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Close",
                style: TextStyle(color: ThemeConstant.primaryColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
