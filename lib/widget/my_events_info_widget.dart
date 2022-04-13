import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_eventors_app/db/events_database.dart';
import 'package:the_eventors_app/models/event.dart';
import 'package:the_eventors_app/pages/event_form_page.dart';
import 'package:the_eventors_app/pages/event_page.dart';
import 'package:the_eventors_app/pages/my_events_info.dart';

class MyEventsWidget extends StatefulWidget {
  final Event event;

  MyEventsWidget(this.event);

  @override
  State<StatefulWidget> createState() {
    return MyEventsWidgetState();
  }
}

class MyEventsWidgetState extends State<MyEventsWidget> {
  MyEventsWidgetState();

  showImage(String image) {
    return Image.memory(
      base64Decode(image),
      fit: BoxFit.fitWidth,
      height: 50,
      width: 100,
    );
  }

  convertDateTime(DateTime time) {
    final f = new DateFormat('dd-MM-yyyy hh:mm');

    return f.format(time).toString();
  }

  Widget get MyEventsWidget {
    return new Card(
        shadowColor: Colors.black,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            leading:
                showImage(widget.event.images.split(" , ").first.toString()),
            title: Text(
                '${widget.event.title} start on: ${this.convertDateTime(widget.event.startTime)}'),
            subtitle: Text('${widget.event.location}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(onPressed: editEvent, icon: Icon(Icons.edit)),
              IconButton(onPressed: deleteEvent, icon: Icon(Icons.delete)),
            ]),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: MyEventsWidget,
    );
  }

  editEvent() {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventFormPage(event: widget.event),
        ));
  }

  deleteEvent() async {
    await EventDatabase.instance.delete(widget.event.id!);

    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyEvents(),
        ));
  }
}
