import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:job_posting_bidding_app/api/app_server.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/screens/home/home_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/utils/utils.dart';
import 'package:job_posting_bidding_app/wigdets/app_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class JobDetailPage2Argument {
  final Job job;

  JobDetailPage2Argument({this.job});
}

class JobDetailPage2 extends StatefulWidget {
  static const String tag = 'job-detail-page-2';
  final JobDetailPage2Argument args;

  JobDetailPage2({this.args});

  @override
  _JobDetailPage2State createState() => _JobDetailPage2State();
}

class _JobDetailPage2State extends State<JobDetailPage2> {
  DateTime dateTime = DateTime.now();
  CalendarController _calendarController;
  Job job;
  int selected_time=0;

  @override
  void initState() {
    _calendarController = CalendarController();
    job = widget.args.job;
    super.initState();
  }

  post_job() {
    FirebaseAuth.instance.currentUser().then((user) {
      job.user_id=user.uid;
      ServerApis().addJob(job).then((res) {
        if (mounted && res != null && res.success) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              HomePage.tag, (Route<dynamic> route) => false).then((e){

          });
          Utils.showDialogOfApp(context, "Job Posted",  "We will soon receive bids on this");
        }
      });
    });
  }
  List<String> times=[
    "Morning 8 AM to 12 PM",
    "Afternoon 12 PM to 4 PM",
    "Evening 4 PM to 7 PM",
    "Late Evening 7 PM to 10 PM",
  ];
  List<String> times_values=[
    "Morning",
    "Afternoon",
    "Evening",
    "Late Evening",
  ];


  DropdownButton _itemDown() => DropdownButton<int>(
    items: times.map((time) {
      return DropdownMenuItem(
        value: times.indexOf(time),
        child: Text(
          time??"",
        ),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        selected_time = value;
      });
    },
    value: selected_time,
    isExpanded: true,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstant.background_color,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Schedule date",
                          style: ThemeConstant.text_style_600_18_3,
                        ),
                        TableCalendar(
                          calendarController: _calendarController,
                          availableGestures: AvailableGestures.all,
                          formatAnimation: FormatAnimation.slide,
                          initialCalendarFormat: CalendarFormat.twoWeeks,
                          availableCalendarFormats: const {
                            CalendarFormat.twoWeeks: '',
                          },
                          startDay: DateTime.now(),
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          calendarStyle: CalendarStyle(
                            selectedColor: Colors.deepOrange[400],
                            todayColor: Colors.deepOrange[200],
                            markersColor: Colors.brown[700],
                            outsideDaysVisible: false,
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonTextStyle: TextStyle()
                                .copyWith(color: Colors.white, fontSize: 15.0),
                            formatButtonDecoration: BoxDecoration(
                              color: Colors.deepOrange[400],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                        Text(
                          "Schedule time",
                          style: ThemeConstant.text_style_600_18_3,
                        ),
                        _itemDown()
                      ],
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(16),
                  color: ThemeConstant.primaryColor,
                  onPressed: () {
                    var date = _calendarController.selectedDay;
                    var formatter = new DateFormat.yMd();
                    String formatted = formatter.format(date);
                    print(formatted);
                    var time_formatter = new DateFormat.jm();
                    String time_formatted = time_formatter.format(dateTime);
                    print(time_formatted);
                    job.service_date = formatted;
                    job.service_time = times_values[selected_time];
                    post_job();
                  },
                  child: Text(
                    "Post Job",
                    style: ThemeConstant.text_style_500_18_2,
                  ),
                )),
          ),
        ],
      ),
      appBar: MyAppBars.getBackAppBar("Choose Time", () {
        Navigator.pop(context);
      }),
    );
  }
}
