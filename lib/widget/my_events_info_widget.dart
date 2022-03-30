import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_eventors_app/models/event.dart';

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
        shape: StadiumBorder(
          side: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            leading:
                showImage(widget.event.images.split(" , ").first.toString()),
            title: Text(
                '${widget.event.title} start on: ${this.convertDateTime(widget.event.startTime)}'),
            subtitle: Text('${widget.event.location}'),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: MyEventsWidget,
    );
  }
}
