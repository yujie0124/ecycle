import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class SchedulePage extends StatefulWidget{
  SchedulePage({Key key}) : super(key: key);
  @override
  _SchedulePage createState() => _SchedulePage();
}

class _SchedulePage extends State<SchedulePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        child: SfCalendar(
          view: CalendarView.month,
        ),
      )
    );
  }
}
