import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_eventors_app/models/event.dart';
import 'package:the_eventors_app/widget/event_details_backgorund.dart';
import 'package:the_eventors_app/widget/event_details_widget.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider<Event>.value(
        value: event,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            EventDetailsBackground(),
            EventDetailsContent(
              eventId: event.id,
            ),
          ],
        ),
      ),
    );
  }
}
