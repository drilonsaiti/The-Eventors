import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_eventors_app/db/category_database.dart';
import 'package:the_eventors_app/db/events_database.dart';
import 'package:the_eventors_app/db/participant_database.dart';
import 'package:the_eventors_app/models/category.dart';
import 'package:the_eventors_app/models/event.dart';
import 'package:the_eventors_app/models/participant.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:the_eventors_app/pages/my_events_info.dart';
import 'package:the_eventors_app/services/.api.dart';
import 'package:the_eventors_app/widget/event_form_widget.dart';

class EventUpdatePage extends StatefulWidget {
  final Event? event;

  const EventUpdatePage({
    Key? key,
    this.event,
  }) : super(key: key);
  @override
  EventUpdateState createState() => EventUpdateState();
}

class EventUpdateState extends State<EventUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late DateTime startTime;
  late String username;
  late String duration;
  late String location;
  late String description;
  late String guest;
  late String categoryName;
  String imageData = "";
  File? imageFile;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleAPIKey);
  late String time;

  late List<Category>? categories;
  var _category;
  late int categoryId;
  var img;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    categories = [];
    refreshCategories();
    categoryName = "";
    getCategoryName(widget.event?.categoryId);
    //images = [];
    //imageFile = Future<File>;
    username = "";
    time = widget.event?.startTime.toString() ?? "";
    title = widget.event?.title ?? '';
    startTime = widget.event?.startTime ?? DateTime.now();
    duration = widget.event?.duration ?? '';
    location = widget.event?.location ?? '';
    description = widget.event?.description ?? '';
    guest = widget.event?.guest ?? '';
    categoryId = widget.event?.categoryId ?? 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getCategoryName(int? id) async {
    var category = await CategoryDatabase.instance.readById(id);

    setState(() {
      categoryName = category!.name.toString();
    });
    debugPrint(categoryName);
  }

  Future refreshCategories() async {
    setState(() => isLoading = true);

    this.categories = (await CategoryDatabase.instance.readAllCategories());
    getUsername();
    getCategoryName(widget.event?.categoryId);
    setState(() => isLoading = false);
  }

  showImage(String image) {
    return Image.memory(base64Decode(image));
  }

  choiceImage() async {
    var pickedImage =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });

      imageData += base64Encode(imageFile!.readAsBytesSync()) + " , ";
      return imageData;
    } else {
      return null;
    }
  }

  convertDateTime(DateTime? time) {
    final f = new DateFormat('dd-MM-yyyy hh:mm');

    return f.format(time!).toString();
  }

  getLenghtOfImages() {
    var images;
    var length = 0;
    if (imageData == "") {
      var img = widget.event!.images.split(" , ");
      length = img.length - 1;
    }
    if (imageData != null && imageData != "") {
      var images = imageData.split(" , ");
      //length += images.length - 1;
    }
    return length;
  }

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("username");
    username = user.toString();
    debugPrint("USERNAME IN EVENT " + user.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 40,
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    "Create event",
                    style: TextStyle(fontSize: 40.0, color: Colors.blueAccent),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: EventFormWidget(
                      title: title,
                      duration: duration,
                      description: description,
                      location: location,
                      guest: guest,
                      onChangedTitle: (title) =>
                          setState(() => this.title = title),
                      onChangedDuration: (duration) =>
                          setState(() => this.duration = duration),
                      onChangedDescription: (description) =>
                          setState(() => this.description = description),
                      onChangedGuest: (guest) =>
                          setState(() => this.guest = guest),
                      onChangedLocation: (location) =>
                          setState(() => this.location = location),
                    ),
                  ),
                  Column(
                    children: [
                      TextField(
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black, fontSize: 24),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.date_range),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: time == ""
                              ? "Start of event - Date and time"
                              : convertDateTime(widget.event?.startTime),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onTap: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  DateTime.now().hour,
                                  59),
                              maxTime: DateTime(
                                  2022,
                                  DateTime.now().month + 1,
                                  DateTime.now().day,
                                  23,
                                  59), onChanged: (date) {
                            print('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                            setState(() {
                              time = date.toString();
                            });
                          }, onConfirm: (date) {
                            print('confirm $date');
                            setState(() {
                              time = date.toString();
                            });
                            print("TIME TIME " +
                                time.toString().substring(0, time.length - 4));
                            print("IN DATE LOCA " + this.location);
                          }, locale: LocaleType.en);
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 7),
                  Column(
                    children: [
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.category),
                          contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                          hintText: categoryName != ""
                              ? categoryName
                              : "Select category",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: this.categories?.map((e) {
                          return DropdownMenuItem(
                              child: Text(e.name), value: e);
                        }).toList(),
                        onChanged: (Category? value) {
                          setState(() {
                            _category = value!;
                            categoryId = value.id!;
                          });
                        },
                        isExpanded: false,
                        iconSize: 24.0,
                        hint: categoryId == 0
                            ? Text(_category.name.toString(),
                                style: TextStyle(fontSize: 24.0))
                            : Text(
                                categoryName != ""
                                    ? categoryName
                                    : "Select category",
                                style: TextStyle(fontSize: 24.0)),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextButton(
                        onPressed: choiceImage,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.add_a_photo,
                              ),
                              getLenghtOfImages() > 0
                                  ? Text(
                                      "Total img: " +
                                          getLenghtOfImages().toString() +
                                          " click for add more",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  : Text(
                                      'Add images (first image is for cover)',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    )),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: updateEvent,
                  color: Color(0xff0095FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Create event",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )),
        ));
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);

      var placeId = p.placeId;
      double lat = detail.result.geometry!.location.lat;
      double lng = detail.result.geometry!.location.lng;
      print(lat);
      print(lng);
      setState(() {
        this.location = detail.result.formattedAddress.toString();
      });
      var data = await Geocoder.local.findAddressesFromQuery(p.description);

      //this.location = data.first.addressLine;
      debugPrint("GEOCODER " + data.first.countryName);
    }
  }

  Future updateEvent() async {
    List<String> img = widget.event!.images.split(" , ");
    String imgData = "";
    for (int i = 0; i < img.length; i++) {
      if (img[i] != "") {
        imgData += img[i] + " , ";
      }
    }
    imgData += imageData;
    final event = widget.event!.copy(
        title: title,
        startTime: DateTime.parse(time),
        duration: duration,
        location: location,
        description: description,
        images: imgData,
        categoryId: categoryId,
        createdTime: DateTime.now(),
        createdBy: username,
        guest: guest);
    await EventDatabase.instance.update(event);

    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyEvents(),
        ));
  }
}
