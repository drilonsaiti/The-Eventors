import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:the_eventors_app/db/myparticipant_database.dart';

import 'package:the_eventors_app/db/user_database.dart';
import 'package:the_eventors_app/models/my_participant.dart';
import 'package:the_eventors_app/models/user.dart';
import 'package:the_eventors_app/pages/home_page.dart';
import 'package:the_eventors_app/widget/user_form_widget.dart';

class RegisterPage extends StatefulWidget {
  final User? user;

  const RegisterPage({
    Key? key,
    this.user,
  }) : super(key: key);
  @override
  _RegisterPageeState createState() => _RegisterPageeState();
}

class _RegisterPageeState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late String username;
  late String email;
  late String password;

  @override
  void initState() {
    super.initState();

    username = widget.user?.username ?? '';
    email = widget.user?.email ?? '';
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create an account, It's free ",
                    style: TextStyle(fontSize: 25, color: Colors.grey[700]),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: UserFormWidget(
                      username: username,
                      email: email,
                      password: password,
                      onChangedUsername: (username) =>
                          setState(() => this.username = username),
                      onChangedEmail: (email) =>
                          setState(() => this.email = email),
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
                  onPressed: addUser,
                  color: Color(0xff0095FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Sign up",
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
                            text: 'Already have an account?, ',
                            style: new TextStyle(color: Colors.black),
                          ),
                          new TextSpan(
                            text: 'Login',
                            style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pop();
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ));
  /*floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 170.0, left: 25.0),
          child: buildButton(),
        )*/

  Widget buildButton() {
    final isFormValid =
        username.isNotEmpty && email.isNotEmpty && password.isNotEmpty;

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: addUser,
          child: Text(
            "SignUp",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
  }

  Future addUser() async {
    final isValid = _formKey.currentState!.validate();

    final usernameExist =
        await UserDatabase.instance.getByUsername(this.username);
    final emailExist = await UserDatabase.instance.getByEmail(this.email);

    debugPrint("USERNAME EXISTS " + usernameExist.toString());
    debugPrint("EMAIL EXISTS " + emailExist.toString());
    if (usernameExist == 1) {
      Fluttertoast.showToast(
          msg: "Username already exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (emailExist == 1) {
      Fluttertoast.showToast(
          msg: "This email already is register to our app",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (usernameExist == 1 && emailExist == 1) {
      Fluttertoast.showToast(
          msg: "This email and username already is register to our app",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      final user = User(
          username: username, email: email, password: password, images: "");

      /*final my_participant = MyParticipant(
          username: username, eventId: "", going: "", interesed: "");
      await MyParticipantDatabase.instance.create(my_participant);*/
      await UserDatabase.instance.create(user);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
