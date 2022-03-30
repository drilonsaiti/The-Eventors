import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:the_eventors_app/db/category_database.dart';

import 'package:the_eventors_app/db/user_database.dart';
import 'package:the_eventors_app/models/category.dart';
import 'package:the_eventors_app/models/category.dart';
import 'package:the_eventors_app/pages/event_page.dart';
import 'package:the_eventors_app/pages/registration_page.dart';
import 'package:the_eventors_app/widget/category_add.dart';
import 'package:the_eventors_app/widget/category_widget.dart';
import 'package:the_eventors_app/widget/user_form_widget.dart';
import 'package:the_eventors_app/widget/user_login_widget.dart';

class CategoryPage extends StatefulWidget {
  final Category? category;

  const CategoryPage({
    Key? key,
    this.category,
  }) : super(key: key);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;

  @override
  void initState() {
    super.initState();

    name = widget.category?.name ?? '';
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
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Category",
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Add category to database",
                    style: TextStyle(fontSize: 25, color: Colors.grey[700]),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: CategoryAdd(
                      name: name,
                      onChangedname: (name) => setState(() => this.name = name),
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
                    "Add to database",
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
      );
  /*floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 170.0, left: 25.0),
          child: buildButton(),
        )*/

  Widget buildButton() {
    final isFormValid = name.isNotEmpty;

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: login,
          child: Text(
            "Add to database",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
  }

  Future login() async {
    final category = Category(
      name: name,
    );
    await CategoryDatabase.instance.create(category);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CategoryPage()));

    /*final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final category = await CategoryDatabase.instance.getCategory(this.name);
      if (category == 1) {
        
      } else {
        Fluttertoast.showToast(
            msg: "The category already exists",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }*/
  }
}
