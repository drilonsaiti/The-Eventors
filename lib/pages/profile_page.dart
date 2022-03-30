import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:the_eventors_app/db/user_database.dart';
import 'package:the_eventors_app/models/user.dart';
import 'package:the_eventors_app/pages/event_page.dart';
import 'package:the_eventors_app/pages/home_page.dart';
import 'package:the_eventors_app/widget/profile_widget.dart';
import 'package:the_eventors_app/widget/user_form_widget.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User userState;
  bool isLoading = false;
  String imageData = "";
  File? imageFile;
  @override
  void initState() {
    super.initState();
    refreshUser();
    imageData = this.userState.images ?? "";
  }

  showImage(String image) {
    return Image.memory(base64Decode(image));
  }

  choiceImage() async {
    var pickedImage =
        await ImagePicker.platform.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
      imageData = base64Encode(imageFile!.readAsBytesSync());
      debugPrint("IMAGE DATA " + imageData.substring(0, 10));
      final user = this.userState.copy(
          username: this.userState.username,
          email: this.userState.email,
          password: this.userState.password,
          images: imageData);
      await UserDatabase.instance.update(user);
      this.userState = (await UserDatabase.instance
          .readUserByUsername(this.userState.username))!;
      bool has = this.userState.images == imageData;
      debugPrint(has.toString());
      return imageData;
    } else {
      return null;
    }
  }

  Future refreshUser() async {
    setState(() => isLoading = true);

    this.userState = widget.user;

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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  Text(
                    "Your profile",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Profile information ",
                    style: TextStyle(fontSize: 25, color: Colors.grey[700]),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          foregroundColor: Colors.white,
                          minRadius: 60.0,
                          child: imageData != ""
                              ? CircleAvatar(
                                  radius: 100.0,
                                  backgroundImage:
                                      MemoryImage(base64Decode(imageData)))
                              : CircleAvatar(
                                  radius: 100.0,
                                  backgroundImage: AssetImage(
                                      "assets/images/profile-icon.png")),
                        ),
                        Positioned(
                          height: 35,
                          width: 35,
                          top: 150,
                          left: 110,
                          child: FloatingActionButton(
                            onPressed: () {
                              choiceImage();
                              debugPrint(
                                  "After choice " + this.userState.images!);
                            },
                            backgroundColor: Colors.blueAccent,
                            child: const Icon(Icons.add),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: Text(
                        '@username',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        this.userState.username,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        this.userState.email,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
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
                  onPressed: logout,
                  color: Color.fromARGB(255, 173, 26, 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Log out",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("username");

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext ctx) => HomePage()));
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
