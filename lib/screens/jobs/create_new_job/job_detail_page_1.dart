import 'package:direct_select/direct_select.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/model/user.dart';
import 'package:job_posting_bidding_app/screens/jobs/create_new_job/job_detail_page_2.dart';
import 'package:job_posting_bidding_app/screens/profile/address_view_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';

class JobDetailPageArgument {
  final Service service;

  JobDetailPageArgument({this.service});
}

class JobDetailPage1 extends StatefulWidget {
  static const String tag = 'job-detail-page-1';
  final JobDetailPageArgument args;

  JobDetailPage1({this.args});

  @override
  _JobDetailPage1State createState() => _JobDetailPage1State();
}

class _JobDetailPage1State extends State<JobDetailPage1> {
  int sub_service_index = 0;
  int add_address_index ;
  final _desController = TextEditingController();
  final _titleController = TextEditingController();
  String _selectedAddress;
  final _budgetAmountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Job job = Job();
  User user;
  bool loading = false;


  @override
  void initState() {
    loadUser();
    super.initState();
  }

  loadUser() {
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        loading = true;
      });

      ServerApis().fetchProfile(user.uid).then((res) {
        if (mounted) {
          if (res != null &&
              res.success &&
              res.user != null &&
              res.user.length != 0) {
            this.user = res.user[0];
          }
          setState(() {
            loading = false;
          });
        }
      });
    });
  }

  DropdownButton _itemDown() => DropdownButton<int>(
        items: widget.args.service.sub_services.map((service) {
          return DropdownMenuItem(
            value: widget.args.service.sub_services.indexOf(service),
            child: Text(
              service??"",
          ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            sub_service_index = value;
            job.sub_service = widget
                .args.service.sub_services[sub_service_index];
          });
        },
        value: sub_service_index,
        isExpanded: true,
      );

  getBody() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Expanded(
              child: Card(
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _titleController,
                        style: ThemeConstant.text_style_600_18_3,
                        decoration:
                            const InputDecoration(labelText: 'Job title'),
                        validator:
                            RequiredValidator(errorText: 'Title is required'),
                        keyboardType: TextInputType.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Choose Sub Service",
                          style: ThemeConstant.text_style_600_18_3,
                        ),
                      ),
                      _itemDown(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              controller: _desController,
                              style: ThemeConstant.text_style_600_18_3,
                              decoration: const InputDecoration(
                                  labelText: 'Description'),
                              validator: RequiredValidator(
                                  errorText: 'Description is required'),
                              maxLines: 2,
                              keyboardType: TextInputType.text,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Choose Address",
                                style: ThemeConstant.text_style_600_18_3,
                              ),
                            ),
                            (this.user != null &&
                                    this.user.address != null && this.user.address.length!=0 &&
                                    this.user.address[0].address_line1 != null)
                                ? Column(
                                    children: this
                                        .user
                                        .address
                                        .map((t) => RadioListTile(
                                              title:
                                                  Text("${t.getFullAddress()}"),
                                              groupValue: add_address_index,
                                              value:
                                                  this.user.address.indexOf(t),
                                              onChanged: (val) {
                                                setState(() {
                                                  add_address_index = this
                                                      .user
                                                      .address
                                                      .indexOf(t);
                                                  _selectedAddress =
                                                      t.getFullAddress();
                                                  print(_selectedAddress);
                                                });
                                              },
                                            ))
                                        .toList())
                                : Text("No address found!"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(),
                                FlatButton(
                                  child: Text(
                                    "Manage Address",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  onPressed: () async{
                                    await Navigator.pushNamed(
                                        context, AddressViewPage.tag);
                                    loadUser();
                                  },
                                ),
                              ],
                            ),
                            TextFormField(
                              controller: _budgetAmountController,
                              style: ThemeConstant.text_style_600_18_3,
                              decoration: const InputDecoration(
                                  labelText: 'Bugdet (INR)'),
                              validator: RequiredValidator(
                                  errorText: 'Bugdet Amount is required'),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
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
                  color: ThemeConstant.primaryColor,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      if (_selectedAddress != null) {
                        job.service_name = widget.args.service.service_name;
                        job.sub_service =
                            widget.args.service.sub_services[sub_service_index];
                        job.description = _desController.text.trim();
                        job.title = _titleController.text.trim();
                        job.address = _selectedAddress;
                        job.amount =
                            int.parse(_budgetAmountController.text.trim());
                        Navigator.pushNamed(context, JobDetailPage2.tag,
                            arguments: JobDetailPage2Argument(job: job));
                      } else {
                        print("address is null");
                      }
                    }
                  },
                  child: Text(
                    "Next",
                    style: ThemeConstant.text_style_500_18_2,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      body: getBody(),
      appBar: MyAppBars.getBackAppBar("Fill Job Detail", () {
        Navigator.pop(context);
      }),
    );
  }
}

class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({Key key, this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: isForList
          ? _buildItem(context)
          : Card(
              child: Stack(
                children: <Widget>[
                  _buildItem(context),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
    );
  }

  _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
