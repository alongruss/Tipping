import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tipping/SettingsModel.dart';
import 'package:tipping/params.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key key, this.params}) : super(key: key);
  final Params params;

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double input = 0.0;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SettingsModel>(
        builder: (context, child, settingsModel) {
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
                    });
                  },
                  onSaved: (String value) {
                    setState(() {
                      input = double.parse(value);
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
            child: ScopedModel<SettingsModel>(
                model: settingsModel, child: Recipt(settingsModel: settingsModel, input: input)),
          ),
        ]),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return ScopedModel<SettingsModel>(
                      model: settingsModel, child: MyDialog());
                });
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
    });
  }
}

class Recipt extends StatefulWidget {
  Recipt({this.settingsModel, this.input});

  final SettingsModel settingsModel;
  final double input;

  @override
  _ReciptState createState() => new _ReciptState();
}

class _ReciptState extends State<Recipt> {
  double rating = 3.0;
  double percent = 0.5;
  int tip = 0;

  Widget build(BuildContext context) {
    percent = lerpDouble(widget.settingsModel.min, widget.settingsModel.max,
        rating / widget.settingsModel.numOfStars);
    tip = (percent * 0.01 * widget.input).round();

    /*percent = lerpDouble(widget.params.min, widget.params.max,
        rating / widget.params.numOfStars);
    tip = (percent * 0.01 * widget.input).round();*/

    return Card(
      color: Colors.white,
      child: Container(
          width: 300,
          height: 400,
          padding: EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ScopedModelDescendant<SettingsModel>(
                    builder: (context, child, settings) {
                  return RatingScale(
                    rating: rating,
                    onRatingChanged: (newRating) =>
                        setState(() => this.rating = newRating),
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ScopedModelDescendant<SettingsModel>(
                        builder: (context, child, settings) {
                      return Text(settings.min.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.body2);
                    }),
                    Text('Linear', style: Theme.of(context).textTheme.body2),
                    ScopedModelDescendant<SettingsModel>(
                        builder: (context, child, settings) {
                      return Text(settings.max.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.body2);
                    }),
                  ],
                ),
                Divider(color: Colors.green),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Percent:', style: Theme.of(context).textTheme.title),
                    Text(percent.toStringAsFixed(1) + '%',
                        style: Theme.of(context).textTheme.title),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Tip: (rounded)', style: Theme.of(context).textTheme.title),
                    Text(tip.toString(),
                        style: Theme.of(context).textTheme.title),
                  ],
                ),
                Divider(color: Colors.green),
                Text(
                  'Sum: ' + (widget.input + tip).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline,
                ),
              ])),
    );
  }
}

typedef void RatingChangeCallback(double newRating);

class RatingScale extends StatelessWidget {
  final RatingChangeCallback onRatingChanged;
  final Color color;
  double rating;

  RatingScale({this.rating, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: color ?? Theme.of(context).buttonColor,
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
      onTap: onRatingChanged == null
          ? null
          : () => onRatingChanged((index + 0.5).roundToDouble()),
      child: icon,
    );
  }

  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ScopedModelDescendant<SettingsModel>(
                builder: (context, child, model) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: new List.generate(
                      model.numOfStars, (index) => buildStar(context, index)));
            }),
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

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      elevation: 5,
      title: new Text('Settings'),
      children: <Widget>[
        ScopedModelDescendant<SettingsModel>(
          builder: (context, child, settings) {
            return Container(
              width: 100,
                height:300,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Minimum percent'),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.arrow_drop_up),
                                onPressed: () {
                                  settings.addStar();
                                },
                              ),
                              Text(
                                settings.min.toStringAsFixed(1),
                                textAlign: TextAlign.center,
                              ),
                              IconButton(
                                  icon: Icon(Icons.arrow_drop_down),
                                  onPressed: () {
                                    settings.subtractStar();
                                  }),
                            ])
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Maximum percent'),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.arrow_drop_up),
                                onPressed: () {
                                  settings.addStar();
                                },
                              ),
                              Text(
                                settings.max.toStringAsFixed(1),
                                textAlign: TextAlign.center,
                              ),
                              IconButton(
                                  icon: Icon(Icons.arrow_drop_down),
                                  onPressed: () {
                                    settings.subtractStar();
                                  }),
                            ])
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Number of stars'),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.arrow_drop_up),
                                onPressed: () {
                                  settings.addStar();
                                },
                              ),
                              Text(
                                settings.numOfStars.toString(),
                                textAlign: TextAlign.center,
                              ),
                              IconButton(
                                  icon: Icon(Icons.arrow_drop_down),
                                  onPressed: () {
                                    settings.subtractStar();
                                  }),
                            ])
                      ],
                    ),
                RatingScale(rating:settings.numOfStars.toDouble(),color:Colors.grey[350]),
                  ],
                ));
          },
        ),
      ],
    );
  }
}
