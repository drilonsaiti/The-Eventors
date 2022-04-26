import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:the_eventors_app/db/user_database.dart';
import 'package:the_eventors_app/models/user.dart';
import 'package:the_eventors_app/pages/event_page.dart';
import 'package:the_eventors_app/pages/registration_page.dart';
import 'package:the_eventors_app/widget/user_login_widget.dart';

class LoginPage extends StatefulWidget {
  final User? user;

  const LoginPage({
    Key? key,
    this.user,
  }) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String username;
  late String password;

  @override
  void initState() {
    super.initState();

    username = widget.user?.username ?? '';
    password = widget.user?.password ?? '';
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
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 60,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Login to your account ",
                    style: TextStyle(fontSize: 25, color: Colors.grey[700]),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: UserLogindWidget(
                      username: username,
                      password: password,
                      onChangedUsername: (username) =>
                          setState(() => this.username = username),
                      onChangedPassword: (password) =>
                          setState(() => this.password = password),
                    ),
                  ),
                ],
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
                  onPressed: login,
                  color: Color(0xff0095FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: new RichText(
                      text: new TextSpan(
                        children: [
                          new TextSpan(
                            text: 'Don\'t have an account? ',
                            style: new TextStyle(color: Colors.black),
                          ),
                          new TextSpan(
                            text: 'Sing up',
                            style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                                ;
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3 - 15,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/draw2.png"))),
              ),
            ],
          ),
        ),
      );
  /*floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 170.0, left: 25.0),
          child: buildButton(),
        )*/

  Widget buildButton() {
    final isFormValid = username.isNotEmpty && password.isNotEmpty;

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: login,
          child: Text(
            "SignUp",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
  }

  Future login() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final user =
          await UserDatabase.instance.getLogin(this.username, this.password);
      if (user == 1) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', this.username);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => EventPage()));
      } else {
        Fluttertoast.showToast(
            msg: "Invalid username or password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
