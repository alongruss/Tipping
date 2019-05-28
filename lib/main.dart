import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tipping/calculatorPage.dart';
import 'package:tipping/settingsPage.dart';
import 'package:tipping/SettingsModel.dart';
import 'package:tipping/params.dart';

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
              color: Colors.white, fontSize: 32.0, fontWeight: FontWeight.w500),
          headline: TextStyle(
              color: Colors.green, fontSize: 32.0, fontWeight: FontWeight.w500),
          subhead: TextStyle(
              color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.w500),
          title: TextStyle(
              color: Colors.green, fontSize: 20.0, fontWeight: FontWeight.w300),
          body1: TextStyle(fontSize: 16.0, fontFamily: 'Hind'),
          body2: TextStyle(fontSize: 14.0, fontFamily: 'Hind',color: Colors.grey[400]),
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

  final settings = SettingsModel();

  final params = Params(min: 10.0, max: 15.0, numOfStars: 7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      controller: controller,
      children: [
        ScopedModel<SettingsModel>(
            model: settings, child: CalculatorPage(params: params)),
      ],
    ));
  }
}
