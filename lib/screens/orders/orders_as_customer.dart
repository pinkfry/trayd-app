import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_hire_page.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_list_item.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_list_item_2.dart';
import 'package:job_posting_bidding_app/screens/jobs/jobs_list_loading.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';

class OrdersAsCustomer extends StatefulWidget {
  static String pageName = "Orders as Customer";

  @override
  _OrdersAsCustomerState createState() => _OrdersAsCustomerState();
}

class _OrdersAsCustomerState extends State<OrdersAsCustomer> {
  List<Job> jobs;
  bool loading;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    loading = true;
    return FirebaseAuth.instance.currentUser().then((user) {
      return ServerApis().getMyPostedJobs(user.uid).then((res) {
        if (mounted) {
          if (_refreshIndicatorKey != null &&
              _refreshIndicatorKey.currentState != null)
            _refreshIndicatorKey.currentState.deactivate();
          if (res != null) {
            if (res.success && res.jobs != null) {
              jobs = res.jobs;
            }
          }
          setState(() {
            loading = false;
          });
        }
        return;
      });
    });
  }

  Future<void> _refresh() {
    return load();
  }

  _getBody() {
    if (loading) {
      return ListView(
        children: <Widget>[
          JobsListLoading(),
          JobsListLoading(),
          JobsListLoading(),
          JobsListLoading(),
          JobsListLoading(),
          JobsListLoading(),
        ],
      );
    }
    if (jobs != null && jobs.length != 0) {
      return Container(
        color: ThemeConstant.color_background,
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (BuildContext context, int index) {
                  return JobListItem2(
                    job: jobs[index],
                    onTab: () async {
                      final result = await Navigator.pushNamed(
                          context, JobHirePage.tag,
                          arguments: jobs[index]);
                      print("result");
                      print(result);
                      if(result!=null){
                        load();
                      }
                    },
                  );
                }),
          ));
    } else {
      return Center(
        child: Text("no jobs!"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getBody();
  }
}
