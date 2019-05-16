import 'package:flutter/material.dart';
import 'calculatorPage.dart';
import 'settingsPage.dart';
import 'params.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.green,
        buttonColor: Colors.green,
        textTheme: TextTheme(
          display1: TextStyle(
              color: Colors.white, fontSize: 36.0, fontWeight: FontWeight.w500),
          headline: TextStyle(
              color: Colors.green, fontSize: 36.0, fontWeight: FontWeight.w500),
          title: TextStyle(
              color: Colors.green, fontSize: 24.0, fontWeight: FontWeight.w300),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = PageController(
    initialPage: 0,
  );

  final params = Params(min: 10.0, max: 15.0, numOfStars: 7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      controller: controller,
      children: [
        CalculatorPage(params: params),
        SettingsPage(title: 'Settings', params: params)
      ],
    ));
  }
}