import 'package:flutter/material.dart';
import 'params.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title,this.params}) : super(key: key);

  final String title;
  final Params params;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        textTheme: Theme.of(context).textTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MenuItem(label: 'Minimum percent', stringValue: widget.params.min.toString()),
                MenuItem(label: 'Maximum percent', stringValue: widget.params.max.toString()),
                MenuItem(label: 'Number of stars', stringValue: widget.params.numOfStars.toString()),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Back',
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        mini: true,
        heroTag: "heroFloatingActionButton",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .startTop, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MenuItem extends StatelessWidget {
  MenuItem({this.label, this.stringValue});

  final String label;
  final String stringValue;

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Text(
            this.label,
            style: Theme
                .of(context)
                .textTheme
                .title,
          ),
        ),
        Text(
          this.stringValue,
          style: Theme.of(context).textTheme.title,
        ),
      ],
    );
  }
}