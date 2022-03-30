import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:the_eventors_app/db/user_database.dart';

class UserLogindWidget extends StatelessWidget {
  final String? username;
  final String? password;
  final ValueChanged<String> onChangedUsername;
  final ValueChanged<String> onChangedPassword;

  const UserLogindWidget({
    Key? key,
    this.username = '',
    this.password = '',
    required this.onChangedUsername,
    required this.onChangedPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildUsername(),
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
          hintText: "@username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (title) {
          if (title != null && title.isEmpty)
            return 'The username cannot be empty';
          else if (UserDatabase.instance.getByUsername(title.toString()) == -1)
            return "The username doesnt exists";
        },
        onChanged: onChangedUsername,
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
        ),
        validator: (title) {
          if (title != null && title.isEmpty)
            return 'The password cannot be empty';
          else if (UserDatabase.instance.readUser(title!) == null) {
            return 'The password doesnt match';
          }
        },
        onChanged: onChangedPassword,
      );

  Widget buildButton() => TextFormField(
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
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The password cannot be empty'
            : null,
        onChanged: onChangedPassword,
      );

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
