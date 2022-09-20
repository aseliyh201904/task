import 'package:flutter/material.dart';
import 'package:task/screen/test_screen.dart';

import 'screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/my_home_page',
      routes: {
        '/my_home_page': (context) => MyHomePage(),
        '/test_screen': (context) => TestScreen(),
      },
    );
  }
}
