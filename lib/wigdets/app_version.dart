import 'package:flutter/material.dart';

class AppVersion extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppVersionState();
  }
}

class _AppVersionState extends State<AppVersion> {
  String versionNumber = "";

  @override
  void initState() {
    super.initState();
    _getVersionNumber().then((onValue) {
      setState(() {
        this.versionNumber = onValue;
      });
    });
  }

  Future<String> _getVersionNumber() async {
    return "0.0.1+0";
  }

  @override
  Widget build(BuildContext context) {
    return Text(versionNumber,);
  }
}
