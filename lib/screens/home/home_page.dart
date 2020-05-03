import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/utils/utils.dart';
import 'package:latlong/latlong.dart' as latlong;
import 'package:job_posting_bidding_app/database/app_settings.dart';
import 'package:job_posting_bidding_app/model/user.dart';
import 'package:job_posting_bidding_app/screens/dashboard/dashboard_page.dart';
import 'package:job_posting_bidding_app/screens/jobs/create_new_job/service_list_page.dart';
import 'package:job_posting_bidding_app/screens/jobs/project_as_expert.dart';
import 'package:job_posting_bidding_app/screens/messages/messages_page.dart';
import 'package:job_posting_bidding_app/screens/more/more_screen.dart';
import 'package:job_posting_bidding_app/screens/orders/orders_as_customer.dart';
import 'package:job_posting_bidding_app/screens/profile/login_page.dart';
import 'package:job_posting_bidding_app/screens/profile/profile_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';

const int DRAWER_DASHBOARD = 0;
const int DRAWER_PROJECT_AS_EXPERT = 1;
const int DRAWER_ORDER_AS_CUSTOMERS = 2;
const int DRAWER_MESSAGE = 3;
const int DRAWER_MORE = 4;

class HomePage extends StatefulWidget {
  static const String tag = 'home-page';

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
   String name;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedDrawerIndex = 0;
  int _selectedBottomIndex = 0;
  User user = User();

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) async {
      this.user.user_id = user.uid;
      this.user.email = await SharedPreferencesTest().getUserEmail();
      this.user.name = await SharedPreferencesTest().getUserFullName();
      this.user.img_url = await SharedPreferencesTest().getUserProfile();
      if (mounted) {
        setState(() {});
      }
    });
    load();
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case DRAWER_DASHBOARD:
        return DashboardPage(scaffoldkey:_scaffoldKey);
      case DRAWER_PROJECT_AS_EXPERT:
        return ProjectAsExpert();
      case DRAWER_ORDER_AS_CUSTOMERS:
        return OrdersAsCustomer();
      case DRAWER_MESSAGE:
        return MessagesPage();
      case DRAWER_MORE:
        return MoreScreen();
      default:
        return MoreScreen();
    }
  }


  _getAppBar(int pos) {
   
    switch (pos) {
      case DRAWER_DASHBOARD:
        name = DashboardPage.pageName;
        break;
      case DRAWER_PROJECT_AS_EXPERT:
        name = ProjectAsExpert.pageName;
        break;
      case DRAWER_ORDER_AS_CUSTOMERS:
        name = OrdersAsCustomer.pageName;
        break;
      case DRAWER_MESSAGE:
        name = MessagesPage.pageName;
        break;
      case DRAWER_MORE:
        name = MoreScreen.pageName;
        break;
    }
    return MyAppBars.getMenuAppBar(name ?? "", () {
      _scaffoldKey.currentState.openDrawer();
    },context);
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }
  //  void load() {
  //       if (this.user.location != null) {
  //           final latLng =
  //               latlong.LatLng(this.user.location.lat, this.user.location.lng);
  //           Utils.getPredictionFromLatLng(latLng).then((address) {
  //             if (address != null) {
  //               if (mounted) {
  //                 setState(() {
  //                   this.user.google_address = address.featureName;
                   
  //                     DashboardPage.pageName=this?.user?.google_address ?? "Select Location";
                    
  //                 });
  //               }
  //             }
  //           });
  //         } 
  //         else{
  //           setState(() {
  //             DashboardPage.pageName="Hello bhai ";
  //           });
            
  //         }
          
  //       } 

  load() async {
    latlong.LatLng latLng;
    User innerUser;
    return FirebaseAuth.instance.currentUser().then((user) {
      return ServerApis().fetchProfile(user.uid).then((_user) {
        if (mounted && _user != null && _user.user != null) {
          
            innerUser = _user.user[0];
          }
          if (innerUser.location != null) {
            latLng =latlong.LatLng(innerUser.location.lat, innerUser.location.lng);
            Utils.getPredictionFromLatLng(latLng).then((address) {
              if (address != null) {
                if (mounted) {
                  setState(() {
                    innerUser.google_address = address.featureName;
                   
                      DashboardPage.pageName =
                          innerUser?.google_address ?? "Select Location";
                    
                  });
                }
              }
            });
          } else {
            setState(() {
              latLng = null;
            });
          }
         
        
    });
  });
}



 

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_selectedDrawerIndex != DRAWER_DASHBOARD) {
            setState(() {
              _selectedDrawerIndex = DRAWER_DASHBOARD;
            });
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: _getAppBar(_selectedDrawerIndex),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: ThemeConstant.primaryColor,
                  ),
                  accountName: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ProfilePage.tag);
                      },
                      child: Text(this.user.name ?? "")),
                  accountEmail: Text(this.user.email ?? ""),
                  currentAccountPicture: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ProfilePage.tag);
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.red,
                          backgroundImage: (user != null &&
                                  user.img_url != null &&
                                  user.img_url.trim().isNotEmpty)
                              ? NetworkImage(
                                  user.img_url,
                                )
                              : AssetImage(
                                  "assets/images/default_picture.png",
                                ))),
                ),
                ListTile(
                  leading: Icon(Icons.art_track),
                  title: Text(DashboardPage.pageName ?? ""),
                  selected: DRAWER_DASHBOARD == _selectedDrawerIndex,
                  onTap: () => _onSelectItem(DRAWER_DASHBOARD),
                ),
                ListTile(
                  leading: Icon(Icons.web),
                  title: Text(ProjectAsExpert.pageName ?? ""),
                  selected: DRAWER_PROJECT_AS_EXPERT == _selectedDrawerIndex,
                  onTap: () => _onSelectItem(DRAWER_PROJECT_AS_EXPERT),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.card_travel),
                  title: Text(OrdersAsCustomer.pageName ?? ""),
                  selected: DRAWER_ORDER_AS_CUSTOMERS == _selectedDrawerIndex,
                  onTap: () => _onSelectItem(DRAWER_ORDER_AS_CUSTOMERS),
                ),
                ListTile(
                  leading: Icon(Icons.message),
                  title: Text(MessagesPage.pageName ?? ""),
                  selected: DRAWER_MESSAGE == _selectedDrawerIndex,
                  onTap: () => _onSelectItem(DRAWER_MESSAGE),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text("Logout"),
                  onTap: () {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    auth.signOut().then((res) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginPage.tag, (Route<dynamic> route) => false);
                    });
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels:true,
            currentIndex: _selectedBottomIndex,
            backgroundColor: ThemeConstant.primaryColor,
            type: BottomNavigationBarType.fixed,
            onTap: (q) {
              switch (q) {
                case 0:
                  setState(() {
                  _selectedDrawerIndex = DRAWER_DASHBOARD;
                  _selectedBottomIndex = 0;
                });

                  break;
                case 1:

                  Navigator.pushNamed(context, ServicesListPage.tag);
                  return;
                case 2:
                  setState(() {
                    _selectedDrawerIndex = DRAWER_MESSAGE;
                    _selectedBottomIndex = 2;
                  });
                  break;
                case 3:
                  setState(() {
                    _selectedDrawerIndex = DRAWER_ORDER_AS_CUSTOMERS;
                    _selectedBottomIndex = 3;
                  });
                  break;
                case 4:
                  setState(() {
                    _selectedDrawerIndex = DRAWER_MORE;
                    _selectedBottomIndex = 4;
                  });
                  break;
              }

            }, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.work,
                  color: ThemeConstant.background_color,
                ),
                backgroundColor: ThemeConstant.primaryColor,
                icon: Icon(
                  Icons.work,
                  color: ThemeConstant.color_8,
                ),
                title: Text(
                  'Jobs',
                  style: ThemeConstant.text_style_400_12_2,
                ),
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.add,
                  color: ThemeConstant.background_color,
                ),
                backgroundColor: ThemeConstant.primaryColor,
                icon: Icon(Icons.add, color: ThemeConstant.color_8),
                title:
                    Text('Post job', style: ThemeConstant.text_style_400_12_2),
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.mail,
                  color: ThemeConstant.background_color,
                ),
                backgroundColor: ThemeConstant.primaryColor,
                icon: Icon(Icons.mail, color: ThemeConstant.color_8),
                title:
                    Text('Messages', style: ThemeConstant.text_style_400_12_2),
              ),
              BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.add_shopping_cart,
                    color: ThemeConstant.background_color,
                  ),
                  backgroundColor: ThemeConstant.primaryColor,
                  icon: Icon(Icons.add_shopping_cart, color: ThemeConstant.color_8),
                  title: Text('Bookings',
                      style: ThemeConstant.text_style_400_12_2)),
              BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.more,
                    color: ThemeConstant.background_color,
                  ),
                  backgroundColor: ThemeConstant.primaryColor,
                  icon: Icon(Icons.more, color: ThemeConstant.color_8),
                  title: Text('More', style: ThemeConstant.text_style_400_12_2))
            ],
          ),
          backgroundColor: ThemeConstant.background_color,
          body: _getDrawerItemWidget(_selectedDrawerIndex),
//          floatingActionButton: FloatingActionButton(
//            backgroundColor: ThemeConstant.primaryColor,
//            onPressed: () {
//              Navigator.pushNamed(context, ServicesListPage.tag);
//            },
//            elevation: 20,
//            child: Icon(Icons.add),
//          ),
//          floatingActionButtonLocation:
//              FloatingActionButtonLocation.centerDocked,
//          bottomNavigationBar: BottomAppBar(
//            child: Column(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                new Row(
//                  mainAxisSize: MainAxisSize.max,
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    FlatButton(
//                      onPressed: () {
//                        Navigator.pushNamed(context, MyPostedJobsPage.tag);
//                      },
//                      padding: EdgeInsets.all(10.0),
//                      child: Column(
//                        mainAxisSize: MainAxisSize.min,
//                        children: <Widget>[
//                          Icon(
//                            Icons.work,
//                            color: ThemeConstant.color_3,
//                          ),
//                          Text(
//                            "Jobs",
//                            style: ThemeConstant.text_style_500_22_3,
//                          ),
//                        ],
//                      ),
//                    ),
//                    FlatButton(
//                      onPressed: () async {
//                        setState(() => _selectedDrawerIndex = DRAWER_MESSAGE);
//                      },
//                      padding: EdgeInsets.all(10.0),
//                      child: Column(
//                        mainAxisSize: MainAxisSize.min,
//                        children: <Widget>[
//                          Icon(Icons.message, color: ThemeConstant.color_3),
//                          Text("Message",
//                              style: ThemeConstant.text_style_500_22_3),
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//              ],
//            ),
//          ),
        ));

       
  }
}
