import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tipping/params.dart';

class SettingsModel extends Model {
  final Params _params = Params(min: 10.0, max: 15.0, numOfStars: 7);

  double get min => _params.min;
  double get max => _params.max;
  int get numOfStars => _params.numOfStars;

  void addStar(){
    if (numOfStars<7) _params.numOfStars++;
    notifyListeners();
  }
  void subtractStar(){
    if (numOfStars>3) _params.numOfStars--;
    notifyListeners();
  }


}
/*
* return ScopedModelDescendant<SettingsModel>(
  builder: (context, child, settings) {
  return Text("Total price: ${cart.min}");
  },
  );
* */