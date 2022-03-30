import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:the_eventors_app/db/user_database.dart';

class ProfileFormWidget extends StatelessWidget {
  final String? username;
  final String? email;
  final String? password;
  final ValueChanged<String> onChangedEmail;
  final ValueChanged<String> onChangedUsername;
  final ValueChanged<String> onChangedPassword;

  const ProfileFormWidget({
    Key? key,
    this.username = '',
    this.email = '',
    this.password = '',
    required this.onChangedEmail,
    required this.onChangedUsername,
    required this.onChangedPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildUsername(),
              SizedBox(height: 16),
              buildEmail(),
              SizedBox(height: 16),
              buildPassword(),
              SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Already have an account '),
                    TextSpan(
                        text: 'Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, "/home");
                          }),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  Widget buildUsername() => TextFormField(
        maxLines: 1,
        initialValue: username,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black, fontSize: 24),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabled: false,
        ),
        validator: (title) {
          if (title != null && title.isEmpty)
            return 'The username cannot be empty';
          else if (UserDatabase.instance.getByUsername(title!) == -1) {
            return 'The username exists';
          }
        },
        onChanged: onChangedUsername,
      );

  Widget buildEmail() => TextFormField(
        maxLines: 1,
        initialValue: email,
        style: TextStyle(color: Colors.black, fontSize: 24),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabled: false,
        ),
        validator: (title) {
          if (title != null && title.isEmpty)
            return 'The email cannot be empty';
          else if (RegExp(
                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9][a-zA-Z0-9-]{0,253}\.)*[a-zA-Z0-9][a-zA-Z0-9-]{0,253}\.[a-zA-Z0-9]{2,}$")
                  .hasMatch(title!) ==
              false) return "Please enter a valid email address";
        },
        onChanged: onChangedEmail,
      );

  Widget buildPassword() => TextFormField(
        maxLines: 1,
        initialValue: password,
        obscureText: true,
        style: TextStyle(color: Colors.black, fontSize: 24),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabled: false,
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The password cannot be empty'
            : null,
        onChanged: onChangedPassword,
      );

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
