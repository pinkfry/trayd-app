import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/model/user.dart';
import 'package:job_posting_bidding_app/screens/profile/address_edit_page.dart';
import 'package:job_posting_bidding_app/screens/profile/address_item_card.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';

class AddressViewPage extends StatefulWidget {
  static const String tag = 'address-view-page';

  AddressViewPage();

  @override
  State<StatefulWidget> createState() {
    return AddressViewPageState();
  }
}

class AddressViewPageState extends State<AddressViewPage> {
  String error_message;
  bool loading;
  List<Address> addresses = List();

  @override
  void initState() {
    loadAddress();
    super.initState();
  }

  loadAddress() {
    setState(() {
      addresses = List();
      loading = true;
    });
    FirebaseAuth.instance.currentUser().then((user) {
      ServerApis().fetchProfile(user.uid).then((res) {
        if (mounted) {
          if (res != null) {
            if (res.user != null && res.user.length != null) {
              this.addresses = res.user[0].address;
              setState(() {
                loading = false;
              });
            }
          }
        }
      });
    });
  }

  getAddressCards() {
    if (this.addresses != null && this.addresses.length != 0) {
      List<Widget> list = List();
      for (int i = 0; i < this.addresses.length; i++) {
        list.add(AddressListItem(
          address: this.addresses[i],
          onTap: ()async {
            final result =await Navigator.pushNamed(context, AddressEditPage.tag,
                arguments: this.addresses[i]);
            if (result != null) {
              loadAddress();
            }
          },
        ));
      }
      if (list.isNotEmpty) {
        return list;
      }
    }
    return [Container(child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("No address added yet!",style: ThemeConstant.text_style_400_16_3,),
    ))];
  }
  getBody(){
    if(loading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return  Column(children: <Widget>[
      Expanded(
          child: SingleChildScrollView(
              child: Container(
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[]..addAll(getAddressCards()))))),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              elevation: 16,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(16),
              color: ThemeConstant.color_3,
              onPressed: () async {
                final result =await Navigator.pushNamed(context, AddressEditPage.tag,);
                if (result != null) {
                  loadAddress();
                }
              },
              child: Text(
                "Add New Address",
                style: ThemeConstant.text_style_500_18_2,
              ),
            )),
      )
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      appBar: MyAppBars.getBackAppBar("Address", () {
        Navigator.pop(context);
      }),
      body:getBody(),
    );
  }
}
