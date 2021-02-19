import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecycle/event_creator.dart';
import 'package:ecycle/models/event_model.dart';
import 'package:intl/intl.dart';

import 'event_edit.dart';

class EventsView extends StatefulWidget {
  final DateTime _eventDate;

  EventsView(DateTime date) : _eventDate = date;

  @override
  State<StatefulWidget> createState() {
    return EventsViewState(_eventDate);
  }
}

class EventsViewState extends State<EventsView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DateTime _eventDate;
  var refreshkey = GlobalKey<RefreshIndicatorState>();

  EventsViewState(DateTime date) : _eventDate = date;

  Future<QuerySnapshot> _getEvents() async {
    FirebaseUser currentUser = await _auth.currentUser();

    if (currentUser != null) {
      QuerySnapshot events = await Firestore.instance
          .collection('calendar_events')
          .where('time', isGreaterThan: new DateTime(_eventDate.year, _eventDate.month, _eventDate.day-1, 23, 59, 59))
          .where('time', isLessThan: new DateTime(_eventDate.year, _eventDate.month, _eventDate.day+1))
          .where('email', isEqualTo: currentUser.email)
          .getDocuments();

      return events;
    } else {
      return null;
    }
  }

  Future<Null> refreshList() async {
    refreshkey.currentState?.show(atTop: true);
    await Future.delayed(Duration(seconds: 2));
    if (!mounted) return;
    setState(() {

    });
  }

  void initState() {
    refreshList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        leading: new BackButton(),
        title: new Text(_eventDate.month.toString() + '/' + _eventDate.day.toString()
            + '/' + _eventDate.year.toString() + ' Events'),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onFabClicked,
        child: new Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: refreshList,
        key: refreshkey,
        child: FutureBuilder(
            future: _getEvents(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new LinearProgressIndicator();
                case ConnectionState.done:
                default:
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  else {
                    return ListView(
                      children: snapshot.data.documents.map((document) {
                        Timestamp timestamp = document.data['time'];
                        DateTime _eventTime = DateTime.tryParse(timestamp.toDate().toString());
                        var eventDateFormatter = new DateFormat("MMMM d, yyyy 'at' h:mma");

                        return new GestureDetector(
                            onTap: () => _onCardClicked(document),
                            child:
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),

                                  ),
                                  color: Color(0xFF333366),
                                  elevation: 10,
                                  child: new Row(
                                    children: <Widget>[
                                      new Expanded(
                                        child:
                                        new Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(padding: EdgeInsets.all(8.0)),
                                            new Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                new Text('    Event: ',
                                                  style: TextStyle(color: Colors.white, fontFamily: "Poppins", fontSize: 20),
                                                ),
                                                Flexible(
                                                  child: new Text(document.data['name'],maxLines: 4,
                                                    style: TextStyle(color: Colors.amberAccent, fontFamily: "Poppins", fontSize: 20),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            new Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                new Text('    Time: ',
                                                  //style: Theme.of(context).textTheme.headline5
                                                  style: TextStyle(color: Colors.white, fontFamily: "Poppins", fontSize: 18),
                                                ),
                                                Flexible(
                                                  child: new Text(eventDateFormatter.format(_eventTime),maxLines: 3,
                                                    //style: Theme.of(context).textTheme.headline5
                                                    style: TextStyle(color: Colors.amberAccent, fontFamily: "Poppins", fontSize: 18),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            new Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                             children: [
                                               new Text('     Summary: ',
                                                 style: TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 15),
                                               ),
                                               Flexible(
                                                 child: new Text(document.data['summary'],maxLines: 10,
                                                   style: TextStyle(color: Colors.amberAccent, fontFamily: "Poppins",fontSize: 15),
                                                 ),
                                               ),
                                             ],
                                            ),
                                            Padding(padding: EdgeInsets.all(8.0)),
                                          ],
                                        ),
                                      ),
                                      new Container(
                                          child: new IconButton(
                                              color: Colors.white,
                                              iconSize: 25.0,
                                              padding: EdgeInsets.all(2.0),
                                              icon: new Icon(Icons.delete),
                                              onPressed: () => _deleteEvent(document))
                                      ),

                                    ],
                                  ),

                              ),
                            ),

                        );
                      }).toList(),
                    );
                  }
              }
            }
        ),
      ),
    );
  }

  void _onCardClicked(DocumentSnapshot document) async {
    Event event = new Event(document.data['name'], document.data['summary'],
        DateTime.tryParse(document.data['time'].toDate().toString()), document.documentID);
    final reload = await Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)
    => new EventEditor(event)));
    if(reload){
      Navigator.pop(context, true);
    }
  }


  void _deleteEvent(DocumentSnapshot document) {
      // set up the buttons
      Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed:  () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = FlatButton(
        child: Text("Yes"),
        onPressed:  () {
          setState(() {
            Firestore.instance.collection('calendar_events').document(document.documentID).delete();
          });
          Navigator.pop(context);
          Navigator.pop(context, true);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Delete Event"),
        content: Text("Would you like to delete this event?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );

  }

  void _onFabClicked() async{
    DateTime _createDateTime = new DateTime(_eventDate.year, _eventDate.month, _eventDate.day,
        DateTime.now().hour, DateTime.now().minute);

    Event _event = new Event("", "",_createDateTime, null);

    final reload = await Navigator.push(context, MaterialPageRoute(
        builder: (context) => EventCreator(_event)
    ));
        if(reload){
          refreshList();
        }

  }
}