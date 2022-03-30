import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_eventors_app/pages/category_page.dart';
import 'package:the_eventors_app/pages/event_page.dart';

import 'package:the_eventors_app/pages/home_page.dart';
import 'package:the_eventors_app/pages/my_events_info.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'The eventors';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFFFFFFF),
          primaryColor: Colors.blueAccent,
        ),
        home: HomePage(),
      );
}
