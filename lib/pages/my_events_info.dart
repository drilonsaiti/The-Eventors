import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_eventors_app/db/events_database.dart';

import 'package:the_eventors_app/db/user_database.dart';
import 'package:the_eventors_app/models/event.dart';
import 'package:the_eventors_app/models/user.dart';
import 'package:the_eventors_app/pages/event_page.dart';
import 'package:the_eventors_app/pages/home_page.dart';
import 'package:the_eventors_app/pages/profile_page.dart';
import 'package:the_eventors_app/widget/my_events_info_widget.dart';
import 'package:the_eventors_app/widget/profile_widget.dart';
import 'package:the_eventors_app/widget/user_form_widget.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({
    Key? key,
  }) : super(key: key);

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  late List<Event> events;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    events = [];
    refreshEvents();
  }

  showImage(String image) {
    return Image.memory(
      base64Decode(image),
      fit: BoxFit.fitWidth,
      height: 50,
      width: 100,
    );
  }

  Future refreshEvents() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('username').toString();
    this.events = await EventDatabase.instance.readAllEventsByUsername(user);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          "My created events",
          style: TextStyle(color: Colors.blueAccent),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventPage(),
                ));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          //await Future.delayed(Duration(seconds: 2));
          refreshEvents();
        },
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: ListView.builder(
            itemCount: events.length,
            padding: const EdgeInsets.only(top: 10.0),
            itemBuilder: (BuildContext context, int index) {
              return MyEventsWidget(events[index]);
            },
          ),
        )),
      ));

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    setState(() {
      refreshEvents();
    });
    throw UnimplementedError();
  }
}
