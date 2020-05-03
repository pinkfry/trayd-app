import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'logo_id',
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: SizedBox(height: 8)),
              Expanded(
                  child: Container(
                width: 200,
                height: 200,
                color: Colors.white,
                child: Center(
                  child: Text("LOGO",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28
                    ),
                  ),
                ),
              )),
              Expanded(child: SizedBox(height: 8)),
            ]));
  }
}
