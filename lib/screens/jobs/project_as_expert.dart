import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_expert_page.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_list_item_2.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_list_item_3.dart';
import 'package:job_posting_bidding_app/screens/jobs/jobs_list_loading.dart';

class ProjectAsExpert extends StatefulWidget {
  static String pageName = "Projects as Expert";

  @override
  _ProjectAsExpertState createState() => _ProjectAsExpertState();
}

class _ProjectAsExpertState extends State<ProjectAsExpert> {
  List<Job> jobs;
  String user_id;
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
      return ServerApis().expertGetAll(user.uid).then((res) {
        this.user_id=user.uid;
        if (mounted) {
          if (_refreshIndicatorKey != null &&
              _refreshIndicatorKey.currentState != null)
            _refreshIndicatorKey.currentState.deactivate();
          if (res != null) {
            jobs = List();
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
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (BuildContext context, int index) {
                  return JobListItem3(
                    job: jobs[index],
                    user_id: user_id,
                    onTab: () async {
                      final result = await Navigator.pushNamed(
                          context, JobExpertPage.tag,
                          arguments: jobs[index]);
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
