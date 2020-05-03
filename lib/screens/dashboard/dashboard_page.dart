import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/model/user.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_bid_page.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_list_item.dart';
import 'package:job_posting_bidding_app/screens/jobs/jobs_list_loading.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/utils/utils.dart';
import 'package:latlong/latlong.dart' as latlong;
import 'package:location/location.dart';

class DashboardPage extends StatefulWidget {
  static String pageName = "Jobs";
  GlobalKey<ScaffoldState> scaffoldkey;
  DashboardPage({this.scaffoldkey});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Job> jobs;
  bool loading;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  User user;

  latlong.LatLng latLng;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    loading = true;
    return FirebaseAuth.instance.currentUser().then((user) {
      return ServerApis().fetchProfile(user.uid).then((_user) {
        if (mounted && _user != null && _user.user != null) {
          setState(() {
            this.user = _user.user[0];
          
               DashboardPage.pageName ="hello";
                // this?.user?.google_address ?? "Select Location";
          
           
          });
          if (this.user.location != null) {
            latLng =latlong.LatLng(this.user.location.lat, this.user.location.lng);
            Utils.getPredictionFromLatLng(latLng).then((address) {
              if (address != null) {
                if (mounted) {
                  setState(() {
                    this.user.google_address = address.featureName;
                   
                      DashboardPage.pageName =
                          this?.user?.google_address ?? "Select Location";
                    
                  });
                }
              }
            });
          } else {
            setState(() {
              latLng = null;
            });
          }
          return ServerApis().getJobs(user.uid).then((res) {
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
        } else {
          return null;
        }
      });
    });
  }

  Future<void> _refresh() {
    return load();
  }

  onJobClick(Job job) {
    Navigator.pushNamed(context, JobBidPage.tag, arguments: job);
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
        Utils.getPredictionFromLatLng(latLng).then((res) {
          if (mounted) {
            if (res != null) {
              if (user != null) {
                setState(() {
                  user.google_address = res.featureName;
                });
              }
              if (mounted) {
                ServerApis().addLatLng(user.user_id, result.latLng.latitude,
                    result.latLng.longitude);
              }
            }
          }
        });
      } else {
        this.latLng = null;
      }
    } else {
      getLocationPermission();
    }
  }

  getLocationPermission() async {
    var location = new Location();
    try {
      location.requestPermission(); //to lunch location permission popup
    } on Exception catch (e) {}
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
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      this?.user?.google_address ?? "Select Location",
                      style: ThemeConstant.text_style_500_18_3,
                    ),
                  ),
                  Builder(
                    builder: (context) => FlatButton(
                      child: Text(
                        "Change Location",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () async {
                        getLocation();
                      },
                    ),
                  )
                ],
              ),
              Expanded(
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refresh,
                  child: ListView.builder(
                      itemCount: jobs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return JobListItem(
                          job: jobs[index],
                          onTab: () {
                            onJobClick(jobs[index]);
                          },
                        );
                      }),
                ),
              ),
            ],
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
