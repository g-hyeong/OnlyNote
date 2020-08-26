import 'package:flutter/material.dart';
import 'package:onlynote2/screens/home_page.dart';
import 'package:onlynote2/screens/write_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '*',
      routes: {
        '*': (context) => HomePage(),
        '*second': (context) => WritePage()
      },
      theme: ThemeData(
          primaryColor: Color(0xffB5B2FF),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryIconTheme: Theme.of(context)
              .primaryIconTheme
              .copyWith(color: Colors.white) //아이콘들 기본 테마
          ),
    );
  }
}
