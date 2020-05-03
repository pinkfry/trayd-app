import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_posting_bidding_app/screens/home/home_page.dart';
import 'package:job_posting_bidding_app/screens/jobs/create_new_job/job_detail_page_1.dart';
import 'package:job_posting_bidding_app/screens/jobs/create_new_job/job_detail_page_2.dart';
import 'package:job_posting_bidding_app/screens/jobs/create_new_job/service_list_page.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_bid_page.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_expert_page.dart';
import 'package:job_posting_bidding_app/screens/jobs/job_hire_page.dart';
import 'package:job_posting_bidding_app/screens/jobs/my_posted_jobs_page.dart';
import 'package:job_posting_bidding_app/screens/messages/messages_page.dart';
import 'package:job_posting_bidding_app/screens/more/help_page.dart';
import 'package:job_posting_bidding_app/screens/more/issue_report_page.dart';
import 'package:job_posting_bidding_app/screens/more/privacy_policy.dart';
import 'package:job_posting_bidding_app/screens/profile/address_edit_page.dart';
import 'package:job_posting_bidding_app/screens/profile/address_view_page.dart';
import 'package:job_posting_bidding_app/screens/profile/edit_profile_page.dart';
import 'package:job_posting_bidding_app/screens/profile/edit_profile_page_2.dart';
import 'package:job_posting_bidding_app/screens/profile/login_page.dart';
import 'package:job_posting_bidding_app/screens/profile/profile_page.dart';
import 'package:job_posting_bidding_app/screens/profile/verify_code_page.dart';
import 'package:job_posting_bidding_app/screens/splash/splash_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:page_transition/page_transition.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Job App',
        theme: ThemeConstant.theme,
        home: SplashPage(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case SplashPage.tag:
              return PageTransition(
                  child: SplashPage(), type: PageTransitionType.fade);
            case LoginPage.tag:
              return PageTransition(
                  child: LoginPage(), type: PageTransitionType.fade);
            case VerifyCodePage.tag:
              return PageTransition(
                  child: VerifyCodePage(), type: PageTransitionType.fade);
            case EditProfilePage.tag:
              return PageTransition(
                  child: EditProfilePage(), type: PageTransitionType.fade);
            case EditProfilePage2.tag:
              return PageTransition(
                  child: EditProfilePage2(), type: PageTransitionType.fade);
            case HomePage.tag:
              return PageTransition(
                  child: HomePage(), type: PageTransitionType.fade);
            case AddressViewPage.tag:
              return PageTransition(
                  child: AddressViewPage(), type: PageTransitionType.fade);
            case ProfilePage.tag:
              return PageTransition(
                  child: ProfilePage(user_id: settings.arguments,), type: PageTransitionType.fade);
            case ServicesListPage.tag:
              return PageTransition(
                  child: ServicesListPage(), type: PageTransitionType.fade);
            case MessagesPage.tag:
              return PageTransition(
                  child: MessagesPage(), type: PageTransitionType.fade);
            case JobDetailPage1.tag:
              return PageTransition(
                  child: JobDetailPage1(
                    args: settings.arguments,
                  ),
                  type: PageTransitionType.fade);
            case JobDetailPage2.tag:
              return PageTransition(
                  child: JobDetailPage2(
                    args: settings.arguments,
                  ),
                  type: PageTransitionType.fade);
            case MyPostedJobsPage.tag:
              return PageTransition(
                  child: MyPostedJobsPage(), type: PageTransitionType.fade);
            case JobHirePage.tag:
              return PageTransition(
                  child: JobHirePage(
                    job: settings.arguments,
                  ),
                  type: PageTransitionType.fade);
            case JobBidPage.tag:
              return PageTransition(
                  child: JobBidPage(
                    job: settings.arguments,
                  ),
                  type: PageTransitionType.fade);
            case JobExpertPage.tag:
              return PageTransition(
                  child: JobExpertPage(
                    job: settings.arguments,
                  ),
                  type: PageTransitionType.fade);
            case AddressEditPage.tag:
              return PageTransition(
                  child: AddressEditPage(address: settings.arguments,), type: PageTransitionType.fade);
            case HelpSupportPage.tag:
              return PageTransition(
                  child: HelpSupportPage(), type: PageTransitionType.fade);
            case IssueReportPage.tag:
              return PageTransition(
                  child: IssueReportPage(), type: PageTransitionType.fade);
            case PrivacyPolicyPage.tag:
              return PageTransition(
                  child: PrivacyPolicyPage(), type: PageTransitionType.fade);
            default:
              return null;
          }
        });
  }
}
