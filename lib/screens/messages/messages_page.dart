import 'package:flutter/material.dart';
import 'package:job_posting_bidding_app/screens/messages/message_detail_page.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';

class MessagesPage extends StatefulWidget {
  static const String tag = 'MessagePage';
  static String pageName="Messages";
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetails(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(50),
                            offset: Offset(0, 0),
                            blurRadius: 5,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://i.pravatar.cc/11$index'),
                                  minRadius: 35,
                                  backgroundColor: Colors.grey[200],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Gurjap Singh',
                                  style: TextStyle(
                                    color: ThemeConstant.color_3,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                ),
                                Text(
                                  'Hi How are you ?',
                                  style: TextStyle(
                                    color: ThemeConstant.color_3,
                                    fontSize: 14,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                ),
                                Text(
                                  '11:00 AM',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
    );
  }
}