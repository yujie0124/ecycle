import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:ecycle/models/event_model.dart';
import 'package:intl/intl.dart';

class EventData {
  String title = '';
  DateTime time;
  String summary = '';
}

class EventEditor extends StatefulWidget {
  final Event _event;

  @override
  State<StatefulWidget> createState() {
    return new EventEditorState();
  }

  EventEditor(this._event) {
    createState();
  }
}

class EventEditorState extends State<EventEditor> {
  final dateFormat = DateFormat("MMMM d, yyyy 'at' h:mma");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  EventData _eventData = new EventData();

  @override
  Widget build(BuildContext context) {

    final titleWidget = new TextFormField(
      keyboardType: TextInputType.text,
      decoration: new InputDecoration(
          hintText: 'Event Name',
          labelText: 'Event Title',
          labelStyle: TextStyle(fontSize: 18.0,color: Colors.teal),
          hintStyle: TextStyle(fontSize: 18.0, color: Colors.teal),
          contentPadding: EdgeInsets.all(16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          )
      ),
      initialValue: widget._event != null ? widget._event.title : '',
      validator: this._validateTitle,
      onSaved: (String value) => this._eventData.title = value,
    );

    final notesWidget = new TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      decoration: InputDecoration(
          hintText: 'Notes',
          labelText: 'Enter your notes here',
          hintStyle: TextStyle(fontSize: 18.0, color: Colors.teal),
          labelStyle: TextStyle(fontSize: 18.0,color: Colors.teal),
          contentPadding: EdgeInsets.all(16.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0)
          )
      ),
      initialValue: widget._event != null ? widget._event.summary : '',
      onSaved: (String value) => this._eventData.summary = value,
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        leading: new BackButton(),
        title: new Text('Edit This Event'),
        actions: <Widget>[
          new Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(15.0),
            child: new InkWell(
              child: new Text(
                'SAVE',
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
              onTap: () => _saveNewEvent(context),
            ),
          )
        ],
      ),
      body: new Form(
          key: this._formKey,
          child: SingleChildScrollView(
            child: new Container(
              padding: EdgeInsets.all(10.0),
              child: new Column(
                children: <Widget>[
                  titleWidget,
                  SizedBox(height: 16.0),
                  new DateTimeField(
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          initialDate: widget._event != null ? widget._event.time : DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime:
                          TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      }else{
                        return DateTime.now();
                      }
                    },
                    initialValue: widget._event != null ? widget._event.time : DateTime.now(),
                    //inputType: InputType.both,
                    format: dateFormat,
                    keyboardType: TextInputType.datetime,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                    //editable: true,
                    decoration: InputDecoration(
                        labelText: 'Event Date',
                        labelStyle: TextStyle(color: Colors.teal),
                        hintStyle: TextStyle(color: Colors.teal),
                        hintText: 'November 1, 2021 at 5:00PM',
                        contentPadding: EdgeInsets.all(20.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)
                        )
                    ),
                    validator: this._validateDate,
                    onSaved: (DateTime value) => this._eventData.time = value,
                  ),
                  SizedBox(height: 16.0),
                  notesWidget,
                ],
              ),
            ),
          )

      ),
    );
  }

  String _validateTitle(String value) {
    if (value.isEmpty) {
      return 'Please enter a valid title.';
    } else {
      return null;
    }
  }

  String _validateDate(DateTime value) {
    if ( (value != null)
        && (value.day >= 1 && value.day <= 31)
        && (value.month >= 1 && value.month <= 12)
        && (value.year >= 2020 && value.year <= 3000)) {
      return null;
    } else {
      return 'Please enter a valid event date.';
    }
  }

  Future _saveNewEvent(BuildContext context) async {
    FirebaseUser currentUser = await _auth.currentUser();
    print('current user: $currentUser');

    if (currentUser != null && this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
      //print(widget._event.documentId);
      Firestore.instance.collection("calendar_events").document(widget._event.documentId).setData({'name': _eventData.title, 'summary': _eventData.summary,
        'time': _eventData.time, 'email': currentUser.email});

      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text("Editing This Event"),
            content: new Text("You have successfully edited this event!"),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context, true);
                },
              )
            ],
          ));

    } else {
      print('Error validating data and saving to firestore.');
    }
  }

}