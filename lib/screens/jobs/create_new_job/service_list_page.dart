import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/screens/jobs/create_new_job/job_detail_page_1.dart';
import 'package:job_posting_bidding_app/screens/jobs/create_new_job/service_item.dart';
import 'package:job_posting_bidding_app/screens/jobs/create_new_job/service_list_loading.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';
import 'package:job_posting_bidding_app/wigdets/search_box.dart';

class ServicesListPage extends StatefulWidget {
  static const String tag = 'service-list-page';

  @override
  _ServicesListPageState createState() => _ServicesListPageState();
}

class _ServicesListPageState extends State<ServicesListPage> {
  ServiceListResponse response;
  bool loading;

  @override
  void initState() {
    print("here");
    loading = true;
    ServerApis().getServiceList().then((res) {
      if (res != null) {
        if (res.success) {
          response = res;
        }
      }
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  List<Widget> getListOfServices() {
    if (response != null &&
        response.services != null &&
        response.services.length != 0) {
      List<Widget> services = List();
      for (int i = 0; i < response.services.length; i++) {
        services.add(ServiceWidget(
          service: response.services[i],
          onTab: () {
            JobDetailPageArgument argument=JobDetailPageArgument(service: response.services[i]);
            Navigator.pushNamed(context, JobDetailPage1.tag,arguments: argument);
          },
        ));
      }
      return services;
    }
    return [];
  }

  Widget getBody() {
    if (loading) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 4,
          ),
          SizedBox(
            width: double.infinity,
            child: SearchBox(),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              children: List.generate(100, (index) {
                return ServiceListLoading();
              }),
            ),
          ),
        ],
      );
    }
    if (response == null ||
        response.services == null ||
        response.services.length == 0) {
      return Text("Some error");
    }
    print("response");
    return Column(
      children: <Widget>[
        SizedBox(
          height: 4,
        ),
        SizedBox(
          width: double.infinity,
          child: SearchBox(),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 4,
            // Generate 100 widgets that display their index in the List.
            children: getListOfServices(),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      body: getBody(),
      appBar: MyAppBars.getBackAppBar("Choose One Service", () {
        Navigator.pop(context);
      }),
    );
  }
}
