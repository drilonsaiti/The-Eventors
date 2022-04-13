import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_eventors_app/db/category_database.dart';
import 'package:the_eventors_app/db/events_database.dart';
import 'package:the_eventors_app/db/user_database.dart';
import 'package:the_eventors_app/models/category.dart';
import 'package:the_eventors_app/models/event.dart';
import 'package:the_eventors_app/models/user.dart';
import 'package:the_eventors_app/pages/event_details_page.dart';
import 'package:the_eventors_app/pages/event_form_page.dart';
import 'package:the_eventors_app/pages/maps_allevents_page.dart';
import 'package:the_eventors_app/pages/my_events_info.dart';
import 'package:the_eventors_app/pages/profile_page.dart';
import 'package:the_eventors_app/widget/category_widget.dart';
import 'package:the_eventors_app/widget/event_widget.dart';
import '../../app_state.dart';
import 'event_page_background.dart';

class EventPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<EventPage> {
  late List<Category>? categories;
  late List<Event>? events;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    categories = [];
    events = [];
    refreshData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshData() async {
    setState(() => isLoading = true);

    this.categories = await CategoryDatabase.instance.readAllCategories();
    this.events = await EventDatabase.instance.readAllEvents();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
        child: Stack(
          children: <Widget>[
            EventPageBackground(
              screenHeight: MediaQuery.of(context).size.height,
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "The eventors",
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Consumer<AppState>(
                        builder: (context, appState, _) =>
                            SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (final category in categories!)
                                CategoryWidget(category: category)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Consumer<AppState>(
                        builder: (context, appState, _) => Column(
                          children: <Widget>[
                            for (final event in events!.where((e) =>
                                e.categoryId == appState.selectedCategoryId))
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          EventDetailsPage(event: event)));
                                },
                                child: EventWidget(
                                  event: event,
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Consumer<AppState>(
                        builder: (context, appState, _) => Column(
                          children: <Widget>[
                            for (final event in events!.where(
                                (element) => 1 == appState.selectedCategoryId))
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          EventDetailsPage(event: event)));
                                },
                                child: EventWidget(
                                  event: event,
                                ),
                              )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape:
            StadiumBorder(side: BorderSide(color: Colors.blueAccent, width: 4)),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EventFormPage()),
          );

          refreshData();
        },
        tooltip: "Create event",
        child: Icon(
          Icons.add,
          color: Colors.blueAccent,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.blueAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => EventPage(),
                icon: Icon(Icons.home),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapAllEventPage(),
                      ));
                },
                icon: Icon(Icons.map),
                color: Colors.white,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyEvents()))
                        .then((value) {
                      setState(() {
                        refreshData();
                      });
                    });
                  },
                  icon: Icon(Icons.event),
                  color: Colors.white),
              IconButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    User user = await UserDatabase.instance
                        .getUserByUsername(prefs.getString("username"));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(user: user),
                        ));
                  },
                  icon: Icon(Icons.person_outline),
                  color: Colors.white),
            ],
          )),
    );
  }

  Future createEvent() {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EventFormPage()));
  }
}
