import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'event_creator.dart';
import 'event_view.dart';

List listName=[];
List listTime=[];

class SchedulePage extends StatefulWidget{
  SchedulePage({Key key}) : super(key: key);
  @override
  _SchedulePage createState() => _SchedulePage();
}

class _SchedulePage extends State<SchedulePage>{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var refreshkey = GlobalKey<RefreshIndicatorState>();

   getCollection() async {
    FirebaseUser currentUser = await _auth.currentUser();
    List<DocumentSnapshot> tempList;
    List<Map<dynamic, dynamic>> list = new List();
    QuerySnapshot collectionSnapshot = await Firestore.instance.collection(
        "calendar_events")
        .where('email', isEqualTo: currentUser.email)
        .getDocuments();

    tempList = collectionSnapshot.documents;

    list = tempList.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data;
    }).toList();
    print(list);
    listName.clear();
    listTime.clear();
    for (int i = 0; i < tempList.length; i++) {
      listName.add(list[i]['name']);
      listTime.add(list[i]['time'].toDate());
    }
    print(listName);
    print(listTime);
  }

  List<Meeting> _getDataSource() {
    List<Meeting> meetings = <Meeting>[];
    print("done getCollection");

    for(int i=0; i<listName.length; i++)
    {
      final DateTime date = listTime[i];
      final DateTime startTime2 = DateTime(date.year, date.month, date.day, date.hour, date.minute, date.second);
      final DateTime endTime2 = startTime2.add(Duration(hours: 2));
    meetings.add(Meeting(listName[i], startTime2, endTime2, Color(0xFF0F8644), false));
    }
    print(meetings);
    return meetings;
  }

  Future<Null> refreshList() async {
    refreshkey.currentState?.show(atTop: true);
    await Future.delayed(Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      getCollection();
      _getDataSource();
    });
  }

  @override
  void initState() {
    getCollection();
    refreshList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        body:  RefreshIndicator(
          onRefresh: refreshList,
          key: refreshkey,
          child: Container(
             child: SfCalendar(
                view: CalendarView.month,
                showNavigationArrow: true,
                todayHighlightColor: Colors.blue,
                dataSource: MeetingDataSource(_getDataSource()),
                monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
               allowedViews: [ CalendarView.day,
                 CalendarView.week,
                 CalendarView.month,
                 CalendarView.schedule
               ],
               onTap: (CalendarTapDetails details)async {
                 final reload = await Navigator.push(context, MaterialPageRoute(builder: (context)=> EventsView(details.date)));
                 if (reload) {
                   refreshList();
                 }
               },
              ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.add),
          backgroundColor: Colors.indigoAccent,
          onPressed: ()async{
            final reload = await Navigator.push(context, MaterialPageRoute(builder: (context)=> EventCreator(context=null)));

            if (reload) {
              refreshList();
            }
          }
      ),

    );
  }


}




class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].date;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.date, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime date;
  DateTime to;
  Color background;
  bool isAllDay;
}