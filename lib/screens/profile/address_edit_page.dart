import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/model/user.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/utils/utils.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';
import 'package:latlong/latlong.dart' as latlong;
import 'package:location/location.dart';

class AddressEditPage extends StatefulWidget {
  static const String tag = 'address-edit-page';
  final Address address;

  AddressEditPage({this.address});

  @override
  State<StatefulWidget> createState() {
    return AddressEditPageState();
  }
}

class AddressEditPageState extends State<AddressEditPage> {
  String error_message;
  FirebaseUser user;
  final _formKey = GlobalKey<FormState>();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _landmarkController = TextEditingController();
  final _locationController = TextEditingController();
  final _pinCodeController = TextEditingController();
  bool saving = false;
  latlong.LatLng latLng;

  @override
  void initState() {
    if (widget.address != null) {
      _addressLine1Controller.text = widget.address.address_line1;
      _addressLine2Controller.text = widget.address.address_line2;
      _landmarkController.text = widget.address.landmark;
      _pinCodeController.text = widget.address.pincode;

      latLng = latlong.LatLng(widget.address.lat, widget.address.lng);
      Utils.getPredictionFromLatLng(latLng).then((res) {
        if (mounted) {
          _locationController.text = res?.addressLine ??
              (widget.address.lat.toString() +
                  "," +
                  widget.address.lng.toString());
        }
      });
    }
    FirebaseAuth.instance.currentUser().then((user) {
      this.user = user;
    });
    super.initState();
  }

  getLocationPermission() async {
    var location = new Location();
    try {
      location.requestPermission(); //to lunch location permission popup
    } on Exception catch (e) {}
  }

  getLocation() async {
    if (await Location().hasPermission() == PermissionStatus.GRANTED) {
      LocationResult result = await showLocationPicker(
        context,
        "AIzaSyDzHhxbODUJJ2jD3sFt8M77d1qCvOGTp1I",
        myLocationButtonEnabled: true,
      );
      print(result);
      if (result != null && result.latLng != null) {
        this.latLng =
            latlong.LatLng(result.latLng.latitude, result.latLng.longitude);
        print("here");
        Utils.getPredictionFromLatLng(latLng).then((res) {
          if (res != null) {
            if (mounted) {
              _locationController.text = res.addressLine ??
                  (result.latLng.latitude.toString() +
                      "," +
                      result.latLng.longitude.toString());
            }
          }
        });
      } else {
        _locationController.text = "";
        this.latLng = null;
      }
    } else {
      getLocationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.place,
                                        color: ThemeConstant.color_3,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              TextFormField(
                                                controller:
                                                    _addressLine1Controller,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText:
                                                            "Address Line 1"),
                                                validator: RequiredValidator(
                                                    errorText:
                                                        'this field is required'),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 1,
                                                color:
                                                    ThemeConstant.primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.place,
                                        color: ThemeConstant.color_3,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              TextFormField(
                                                controller:
                                                    _addressLine2Controller,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText:
                                                            "Address Line 2"),
                                                validator: RequiredValidator(
                                                    errorText:
                                                        'this field is required'),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 1,
                                                color:
                                                    ThemeConstant.primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.place,
                                        color: ThemeConstant.color_3,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              TextFormField(
                                                controller: _landmarkController,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText: "Landmark"),
                                                validator: RequiredValidator(
                                                    errorText:
                                                        'this field is required'),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 1,
                                                color:
                                                    ThemeConstant.primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.place,
                                        color: ThemeConstant.color_3,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              TextFormField(
                                                controller: _pinCodeController,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText: "Pincode"),
                                                validator: RequiredValidator(
                                                    errorText:
                                                        'this field is required'),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 1,
                                                color:
                                                    ThemeConstant.primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.place,
                                        color: ThemeConstant.color_3,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              TextFormField(
                                                controller: _locationController,
                                                maxLines: 2,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText: "Location"),
                                                validator: (value) {
                                                  if (value.trim().isEmpty) {
                                                    return "this field is required";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 1,
                                                color:
                                                    ThemeConstant.primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          getLocation();
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: ThemeConstant.color_3,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          error_message != null
              ? Text(
                  error_message,
                  style: ThemeConstant.text_style_400_16_4,
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      elevation: 16,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(16),
                      color: ThemeConstant.primaryColor,
                      onPressed: !saving
                          ? () {
                              if (_formKey.currentState.validate()) {
                                try {
                                  if (this.user != null) {
                                    setState(() {
                                      saving = true;
                                    });
                                    if (this.latLng != null) {
                                      if (widget.address != null) {
                                        print("here");
                                        Address address = Address(
                                            lat: latLng.latitude,
                                            lng: latLng.longitude,
                                            address_id:
                                            this.widget.address.address_id,
                                            address_line1:
                                            _addressLine1Controller.text,
                                            address_line2:
                                            _addressLine2Controller.text,
                                            landmark: _landmarkController.text,
                                            pincode: _pinCodeController.text);
                                        ServerApis()
                                            .editAddress(this.user.uid, address)
                                            .then((res) {
                                          if (mounted) {
                                            if (res != null) {
                                              if (res.success) {
                                                Navigator.pop(
                                                    context, "reload");
                                                Utils.showDialogOfApp(
                                                    context,
                                                    "Updated",
                                                    "Address is now updated!");
                                                return;
                                              }
                                            }
                                            setState(() {
                                              saving = false;
                                              error_message =
                                              "Something went wrong,Try Again!";
                                            });
                                          }
                                        });
                                      }
                                      else {
                                        Address address = Address(
                                            lat: latLng.latitude,
                                            lng: latLng.longitude,
                                            address_line1:
                                            _addressLine1Controller.text,
                                            address_line2:
                                            _addressLine2Controller.text,
                                            landmark: _landmarkController.text,
                                            pincode: _pinCodeController.text);
                                        ServerApis()
                                            .addAddress(this.user.uid, address)
                                            .then((res) {
                                          if (mounted) {
                                            if (res != null) {
                                              if (res.success) {
                                                Navigator.pop(
                                                    context, "reload");
                                                Utils.showDialogOfApp(
                                                    context,
                                                    "Added",
                                                    "New Address Added!");
                                                return;
                                              }
                                            }
                                            setState(() {
                                              saving = false;
                                              error_message =
                                              "Something went wrong,Try Again!";
                                            });
                                          }
                                        });
                                      }
                                    } else {
                                      if (widget.address != null) {
                                        print("here");

                                        Address address = Address(
                                            lat: double.parse(
                                                _locationController
                                                    .text
                                                    .split(",")[0]),
                                            lng: double.parse(
                                                _locationController
                                                    .text
                                                    .split(",")[1]),
                                            address_id:
                                            this.widget.address.address_id,
                                            address_line1:
                                            _addressLine1Controller.text,
                                            address_line2:
                                            _addressLine2Controller.text,
                                            landmark: _landmarkController.text,
                                            pincode: _pinCodeController.text);
                                        ServerApis()
                                            .editAddress(this.user.uid, address)
                                            .then((res) {
                                          if (mounted) {
                                            if (res != null) {
                                              if (res.success) {
                                                Navigator.pop(
                                                    context, "reload");
                                                Utils.showDialogOfApp(
                                                    context,
                                                    "Updated",
                                                    "Address is now updated!");
                                                return;
                                              }
                                            }
                                            setState(() {
                                              saving = false;
                                              error_message =
                                              "Something went wrong,Try Again!";
                                            });
                                          }
                                        });
                                      }
                                      else {
                                        Address address = Address(
                                            lat: double.parse(
                                                _locationController
                                                    .text
                                                    .split(",")[0]),
                                            lng: double.parse(
                                                _locationController
                                                    .text
                                                    .split(",")[1]),
                                            address_line1:
                                            _addressLine1Controller.text,
                                            address_line2:
                                            _addressLine2Controller.text,
                                            landmark: _landmarkController.text,
                                            pincode: _pinCodeController.text);
                                        ServerApis()
                                            .addAddress(this.user.uid, address)
                                            .then((res) {
                                          if (mounted) {
                                            if (res != null) {
                                              if (res.success) {
                                                Navigator.pop(
                                                    context, "reload");
                                                Utils.showDialogOfApp(
                                                    context,
                                                    "Added",
                                                    "New Address Added!");
                                                return;
                                              }
                                            }
                                            setState(() {
                                              saving = false;
                                              error_message =
                                              "Something went wrong,Try Again!";
                                            });
                                          }
                                        });
                                      }
                                    }
                                  }
                                }
                                catch(e){
                                  setState(() {
                                    saving=false;
                                  });
                                }
                              }
                            }
                          : null,
                      child: Text(
                        !saving ? "Save" : "Saving..",
                        style: ThemeConstant.text_style_500_18_2,
                      ),
                    )),
                SizedBox(
                  height: 8,
                ),
                this.widget.address != null
                    ? SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          elevation: 16,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(16),
                          color: ThemeConstant.color_4,
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    title: Text(
                                        "Do you want really delete this address?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Yes"),
                                        onPressed: () {
                                          if (user != null) {
                                            ServerApis()
                                                .deleteAddress(user.uid,
                                                    widget.address.address_id)
                                                .then((res) {
                                              if (mounted) {
                                                if (res != null) {
                                                  if (res.success) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(
                                                        context, "reload");
                                                    Utils.showDialogOfApp(
                                                        context,
                                                        "Deleted",
                                                        "Address is deleted!");
                                                    return;
                                                  }
                                                }
                                                setState(() {
                                                  error_message =
                                                      "Something went wrong,Try Again!";
                                                });
                                              }
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Delete Address",
                            style: ThemeConstant.text_style_500_18_2,
                          ),
                        ))
                    : Container(),
              ],
            ),
          ),
        ],
      ),
      appBar: MyAppBars.getBackAppBar("Address", () {
        Navigator.pop(context);
      }),
    );
  }
}
