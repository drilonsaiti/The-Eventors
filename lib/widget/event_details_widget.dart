import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shine/flutter_shine.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_eventors_app/db/myparticipant_database.dart';
import 'package:the_eventors_app/db/participant_database.dart';
import 'package:the_eventors_app/models/event.dart';
import 'package:the_eventors_app/models/my_participant.dart';
import 'package:the_eventors_app/models/participant.dart';
import 'package:the_eventors_app/pages/maps_page.dart';

class EventDetailsContent extends StatefulWidget {
  final int? eventId;
  const EventDetailsContent({Key? key, required this.eventId})
      : super(key: key);

  @override
  _EventDetailsPage createState() => _EventDetailsPage();

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _EventDetailsPage extends State<EventDetailsContent> {
  bool isLoading = false;
  bool hasPresedGoing = false;
  bool hasPresedInteresed = false;
  var lengthGoing;
  @override
  void initState() {
    super.initState();
    getGoingParticpant(widget.eventId);
    getInteresedParticpant(widget.eventId);
    getInteresed();
    getGoing();
    getLengthGoing();
  }

  readImage(String img) {
    if (Image.memory(base64Decode(img)) != null) {
      return "true";
    }
    return false;
  }

  getInteresed() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('username').toString();
    final participant = await ParticipantDatabase.instance
        .getParticipantByEvent(widget.eventId);

    List<String> list = participant.interesed!.split(",");
    int indx = list.indexOf(user.toString());
    if (indx != -1) {
      debugPrint("IN INDX");
      hasPresedInteresed = true;
    }
    setState(() {
      isLoading = false;
    });
  }

  getGoing() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('username').toString();
    final participant = await ParticipantDatabase.instance
        .getParticipantByEvent(widget.eventId);

    List<String> list = participant.going!.split(",");
    int indx = list.indexOf(user.toString());
    if (indx != -1) {
      debugPrint("IN INDX");
      hasPresedGoing = true;
    }
    setState(() {
      isLoading = false;
    });
  }

  getLengthGoing() {
    setState(() {
      isLoading = true;
    });
    this.lengthGoing = getGoingParticpant(widget.eventId);

    setState(() {
      isLoading = false;
    });
  }

  convertDateTime(DateTime time) {
    final f = new DateFormat('dd-MM-yyyy hh:mm');

    return f.format(time).toString();
  }

  @override
  Widget build(BuildContext context) {
    final event = Provider.of<Event>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 100,
          ),
          FlutterShine(
              config: Config(shadowColor: Colors.black, opacity: 1.0),
              builder: (BuildContext context, ShineShadow shineShadow) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
                  child: Text(
                    event.title,
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                        shadows: shineShadow.shadows),
                  ),
                );
              }),
          SizedBox(
            height: 10,
          ),
          FlutterShine(
            config: Config(shadowColor: Colors.black, opacity: 1.0),
            builder: (BuildContext context, ShineShadow shineShadow) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.24),
                child: FittedBox(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "-",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Color.fromARGB(255, 255, 255, 255),
                            shadows: shineShadow.shadows),
                      ),
                      IconShadowWidget(
                        Icon(Icons.location_on, color: Colors.white, size: 36),
                        shadowColor: Colors.black,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      RichText(
                        text: TextSpan(
                            text: event.location,
                            style: TextStyle(
                              fontSize: 30.0,
                              shadows: shineShadow.shadows,
                              color: Color.fromARGB(255, 252, 252, 252),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapScreen(
                                              event: event,
                                            )));
                              }),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          FlutterShine(
              config: Config(shadowColor: Colors.black, opacity: 1.0),
              builder: (BuildContext context, ShineShadow shineShadow) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.24),
                  child: FittedBox(
                    child: Row(
                      children: <Widget>[
                        Text(
                          " - ",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Color.fromARGB(255, 255, 255, 255),
                            shadows: shineShadow.shadows,
                          ),
                        ),
                        IconShadowWidget(
                          Icon(Icons.date_range, color: Colors.white, size: 36),
                          shadowColor: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          /*event.startTime
                        .toString()
                        .substring(0, event.startTime.toString().length - 4),*/
                          convertDateTime(event.startTime),
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Color.fromARGB(255, 252, 252, 252),
                            shadows: shineShadow.shadows,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("GUESTS",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 0, 0, 0),
                )),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                for (final guest in event.guest!.split(","))
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      child: SizedBox(
                        child: guest != ""
                            ? Text(
                                guest.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    backgroundColor: Colors.blueAccent,
                                    fontSize: 25.0),
                              )
                            : Text(
                                "No guest for this event",
                                style: TextStyle(color: Colors.black),
                              ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (event.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: event.title + "!  \n",
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.blueAccent,
                    ),
                  ),
                  TextSpan(
                    text: event.description,
                    style: TextStyle(
                        fontSize: 20,
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        decoration: TextDecoration.overline,
                        decorationColor: Colors.white),
                  ),
                ]),
              ),
            ),
          if (event.images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
              child: Text(
                "GALLERY",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                for (final galleryImagePath in event.images.split(" , "))
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                          child: Image.memory(
                        base64Decode(galleryImagePath),
                        height: 180,
                        width: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Text('');
                        },
                      )),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
            // ignore: prefer_if_null_operators
            child: FutureBuilder<String>(
                future: getGoingParticpant(event.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF000000),
                      ),
                    );
                  }
                  return Text(
                    "We waiting for you,be part of us",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000),
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 0, bottom: 16),
            // ignore: prefer_if_null_operators
            child: FutureBuilder<String>(
                future: getInteresedParticpant(event.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF000000),
                      ),
                    );
                  }
                  return Text(
                    "",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF000000),
                    ),
                  );
                }),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                    child: RaisedButton(
                        onPressed: () {
                          if (hasPresedInteresed == false) {
                            setState(() {
                              getGoing();
                              getGoingParticpant(event.id);
                              if (hasPresedGoing == false) {
                                setState(() {
                                  hasPresedGoing = true;
                                  hasPresedInteresed = false;
                                });
                                addGoingParticipant(event.id);
                                //addGoingMyParticipant(event.id);
                                getGoingParticpant(event.id);
                              } else {
                                removeGoingParticipant(event.id);
                                // removeGoingMyParticipant(event.id);
                                getGoingParticpant(event.id);
                                setState(() {
                                  hasPresedGoing = false;
                                });
                              }
                            });
                          }
                        },
                        child: hasPresedGoing == false
                            ? Text("Going")
                            : RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(Icons.check, size: 18),
                                    ),
                                    TextSpan(
                                      text: " Going",
                                    ),
                                  ],
                                ),
                              ),
                        color: hasPresedGoing == false &&
                                hasPresedInteresed == false
                            ? Colors.blueAccent
                            : Colors.blueGrey,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(50)))),
                VerticalDivider(),
                Expanded(
                    child: RaisedButton(
                  onPressed: () {
                    if (hasPresedGoing == false) {
                      setState(() {
                        getInteresed();
                        getInteresedParticpant(event.id);
                        if (hasPresedInteresed == false) {
                          setState(() {
                            hasPresedInteresed = true;
                            hasPresedGoing = false;
                          });
                          addInteresedParticipant(event.id);
                          //addInteresedMyParticipant(event.id);
                          getInteresedParticpant(event.id);
                        } else {
                          removeInteresedParticipant(event.id);
                          //removeInteresedMyParticipant(event.id);
                          getInteresedParticpant(event.id);
                          setState(() {
                            hasPresedInteresed = false;
                          });
                        }
                      });
                    }
                    getInteresedParticpant(event.id);
                  },
                  child: hasPresedInteresed == false
                      ? Text("Interesed")
                      : RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.check,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: " Interesed",
                              ),
                            ],
                          ),
                        ),
                  color: hasPresedInteresed == false && hasPresedGoing == false
                      ? Colors.white
                      : Colors.blueGrey,
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(50)),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  addGoingParticipant(int? event) async {
    final participant =
        await ParticipantDatabase.instance.getParticipantByEvent(event);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('username').toString();
    String going = participant.going! + user.toString() + ",";

    final participantObj = participant.copy(
        eventId: event, going: going, interesed: participant.interesed);
    await ParticipantDatabase.instance.update(participantObj);
  }

  /*addGoingMyParticipant(int? event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username').toString();
    final participantByUsername = await MyParticipantDatabase.instance
        .getMyParticipantByUsername(username);
    String eventIds = participantByUsername.eventId! + event.toString() + ",";
    String going = participantByUsername.going! + event.toString() + ",";
    final myParticipant = MyParticipant(
        username: username,
        eventId: eventIds,
        going: going,
        interesed: participantByUsername.interesed);
    await MyParticipantDatabase.instance.update(myParticipant);
  }*/

  removeGoingParticipant(int? event) async {
    final participant =
        await ParticipantDatabase.instance.getParticipantByEvent(event);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('username').toString();
    List<String> going = [];
    going = participant.going!.split(",");
    int length = participant.going!.split(",").length;

    int id = going.indexOf(user.toString());
    going.removeAt(id);
    String strGoing = going.join(",");

    final participantObj = participant.copy(
        eventId: event, going: strGoing, interesed: participant.interesed);
    await ParticipantDatabase.instance.update(participantObj);
  }

  /*removeGoingMyParticipant(int? event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username').toString();
    final participantByUsername = await MyParticipantDatabase.instance
        .getMyParticipantByUsername(username);

    List<String> going = [];
    going = participantByUsername.going!.split(",");

    int id = going.indexOf(username.toString());
    going.removeAt(id);
    String strGoing = going.join(",");

    final participantObj = participantByUsername.copy(
        eventId: participantByUsername.eventId,
        going: strGoing,
        interesed: participantByUsername.interesed);
    await MyParticipantDatabase.instance.update(participantObj);
  }*/

  Future<String> getGoingParticpant(int? event) async {
    Participant participant =
        await ParticipantDatabase.instance.getParticipantByEvent(event);
    int lengthINT = participant.going!.split(",").length - 1;
    String length = "Number of going participant is: " + lengthINT.toString();
    return length;
  }

  addInteresedParticipant(int? event) async {
    final participant =
        await ParticipantDatabase.instance.getParticipantByEvent(event);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('username').toString();
    String interesed = participant.interesed! + user.toString() + ",";

    final participantObj = participant.copy(
        eventId: event, going: participant.going, interesed: interesed);
    await ParticipantDatabase.instance.update(participantObj);
  }

  /*addInteresedMyParticipant(int? event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username').toString();
    final participantByUsername = await MyParticipantDatabase.instance
        .getMyParticipantByUsername(username);
    String interesed =
        participantByUsername.interesed! + event.toString() + ",";
    final myParticipant = MyParticipant(
        username: username,
        eventId: participantByUsername.eventId,
        going: participantByUsername.going,
        interesed: interesed);
    debugPrint("My " + interesed);
    await MyParticipantDatabase.instance.update(myParticipant);
  }*/

  removeInteresedParticipant(int? event) async {
    final participant =
        await ParticipantDatabase.instance.getParticipantByEvent(event);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('username').toString();
    List<String> interesed = [];
    interesed = participant.interesed!.split(",");

    int id = interesed.indexOf(user.toString());
    interesed.removeAt(id);
    String strInteresed = interesed.join(",");

    final participantObj = participant.copy(
        eventId: event, going: participant.going, interesed: strInteresed);
    await ParticipantDatabase.instance.update(participantObj);
  }

  /*removeInteresedMyParticipant(int? event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username').toString();
    final participantByUsername = await MyParticipantDatabase.instance
        .getMyParticipantByUsername(username);

    List<String> interesed = [];
    interesed = participantByUsername.interesed!.split(",");

    int id = interesed.indexOf(username.toString());
    interesed.remove(username);
    String strInteresed = interesed.join(",");

    final participantObj = participantByUsername.copy(
        eventId: participantByUsername.eventId,
        going: participantByUsername.going,
        interesed: strInteresed);
    await MyParticipantDatabase.instance.update(participantObj);
  }*/

  Future<String> getInteresedParticpant(int? event) async {
    Participant participant =
        await ParticipantDatabase.instance.getParticipantByEvent(event);

    int lengthINT = participant.interesed!.split(",").length - 1;
    var length = "Number of interesed participant is: " + lengthINT.toString();
    return length;
  }
}
