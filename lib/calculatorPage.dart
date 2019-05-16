import 'dart:math';
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'settingsPage.dart';
import 'params.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key key, this.params}) : super(key: key);
  final Params params;

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double input = 0.0;
  double tip = 0.0;
  int rating = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(children: <Widget>[
        Flexible(
          flex: 2,
          child: Container(
            alignment: AlignmentDirectional.bottomCenter,
            padding: EdgeInsets.all(32.0),
            height: 210,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('graphics/Screen Group.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
              key: _formKey,
              autovalidate: true,
              child: TextFormField(
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.display1,
                autofocus: true,
                keyboardType: TextInputType.number,
                validator: (arg) {
                  if (DecimalNumberSubmitValidator().isValid(arg)) {
                    return null;
                  } else {
                    input = 0.0;
                    return 'Not a valid number!';
                  }
                },
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (String value) {
                  setState(() {
                    input = double.parse(value);
                    tip = input * widget.params.min * 0.01;
                  });
                },
                onSaved: (String value) {
                  setState(() {
                    input = double.parse(value);
                    tip = input * widget.params.min * 0.01;
                  });
                },
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Bill',
                  enabledBorder: null,
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Recipt(
              params: widget.params,
              input: input),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SettingsPage(title: 'Settings', params: widget.params)));
        },
        tooltip: 'Settings',
        child: Icon(Icons.settings),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        mini: true,
        heroTag: "heroFloatingActionButton",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Recipt extends StatefulWidget {
  Recipt({this.params, this.input});
  final Params params;
  final double input;

  @override
  _ReciptState createState() => new _ReciptState();
}
class _ReciptState extends State<Recipt> {
  double rating = 3.5;
  double percent = 0.5;
  double tip = 0.0;


  Widget build(BuildContext context) {
    percent = lerpDouble(widget.params.min, widget.params.max,rating/widget.params.numOfStars);
    tip = percent*0.01*widget.input;

    return Card(
      color: Colors.white,
      child: Container(
          width: 300,
          height: 400,
          padding: EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RatingScale(starCount: widget.params.numOfStars,rating:rating,onRatingChanged: (newRating) => setState(() => this.rating = newRating),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(widget.params.min.toStringAsFixed(1), style: Theme.of(context).textTheme.body1),
                    Text('Linear', style: Theme.of(context).textTheme.body1),
                    Text(widget.params.max.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.body1),
                  ],
                ),
                Divider(color:Colors.green),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Percent:', style: Theme.of(context).textTheme.title),
                    Text(percent.toStringAsFixed(2)+'%', style: Theme.of(context).textTheme.title),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Tip:', style: Theme.of(context).textTheme.title),
                    Text(tip.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.title),
                  ],
                ),
                Divider(color:Colors.green),
                Text(
                  'Sum: '+(widget.input+tip).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline,
                ),
              ])),
    );
  }
}

typedef void RatingChangeCallback(double newRating);

class RatingScale extends StatelessWidget {
  final int starCount;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  double rating;

  RatingScale(
      {this.starCount = 5, this.rating = 4.0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).buttonColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).buttonColor,
      );
    }
    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: new List.generate(
                      starCount, (index) => buildStar(context, index))),
          ]),
    );
  }
}

class DecimalNumberSubmitValidator {
  bool isValid(String value) {
    try {
      final number = double.parse(value);
      return number > 0.0;
    } catch (e) {
      return false;
    }
  }
}
