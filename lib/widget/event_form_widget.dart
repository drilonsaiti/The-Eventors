import 'package:flutter/material.dart';
import 'package:the_eventors_app/db/category_database.dart';

class EventFormWidget extends StatelessWidget {
  final int? username;
  final String title;
  final String duration;
  final String location;
  final String description;
  final String? guest;

  List? categoires = [];
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedLocation;

  final ValueChanged<String> onChangedDuration;
  final ValueChanged<String> onChangedDescription;
  final ValueChanged<String> onChangedGuest;

  EventFormWidget({
    Key? key,
    this.username = 0,
    this.title = "",
    this.duration = '',
    this.location = '',
    this.description = '',
    this.guest,
    required this.onChangedTitle,
    required this.onChangedDuration,
    required this.onChangedLocation,
    required this.onChangedDescription,
    required this.onChangedGuest,
  }) : super(key: key);

  Future getAllCategory() async {
    this.categoires = await CategoryDatabase.instance.readAllCategories();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              SizedBox(height: 16),
              buildDuration(),
              SizedBox(height: 16),
              buildDescription(),
              SizedBox(height: 16),
              buildLocation(),
              SizedBox(height: 16),
              buildGuest(),
            ],
          ),
        ),
      );
  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black, fontSize: 24),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.title),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Title of event",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (title) {
          if (title != null && title.isEmpty)
            return 'The title cannot be empty';
        },
        onChanged: onChangedTitle,
      );
  Widget buildLocation() => TextFormField(
        maxLines: 1,
        initialValue: location,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black, fontSize: 24),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.location_city),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Location of event",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (title) {
          if (title != null && title.isEmpty)
            return 'The title cannot be empty';
        },
        onChanged: onChangedLocation,
      );
  Widget buildDuration() => TextFormField(
        maxLines: 1,
        initialValue: duration,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black, fontSize: 24),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.timelapse),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Duration",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (title) {
          if (title != null && title.isEmpty)
            return 'The title cannot be empty';
        },
        onChanged: onChangedDuration,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        initialValue: description,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black, fontSize: 24),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.description),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Description of event",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (title) {
          if (title != null && title.isEmpty)
            return 'The title cannot be empty';
        },
        onChanged: onChangedDescription,
      );

  Widget buildGuest() => TextFormField(
        maxLines: 1,
        initialValue: guest,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black, fontSize: 24),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.group),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText:
              "Add guest on event,sepreate with , example: Bill Gates,Elon Musk",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: onChangedGuest,
      );

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
