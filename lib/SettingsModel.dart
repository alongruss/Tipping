import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tipping/params.dart';

class SettingsModel extends Model {
  final Params _params = Params(min: 10.0, max: 15.0, numOfStars: 7, globalMin:8.0, globalMax:20.0,stepSize:0.5);

  double get min => _params.min;
  double get max => _params.max;
  double get globalMin => _params.globalMin;
  double get globalMax => _params.globalMax;
  double get stepSize => _params.stepSize;
  int get numOfStars => _params.numOfStars;

  void addStar(){
    if (numOfStars<7) _params.numOfStars++;
    notifyListeners();
  }
  void subtractStar(){
    if (numOfStars>3) _params.numOfStars--;
    notifyListeners();
  }

  void addMax(){
    if (max<globalMax) _params.max+=stepSize;
    notifyListeners();
  }
  void subtractMax(){
    if (max>globalMin && min<max) _params.max-=stepSize;
    notifyListeners();
  }

  void addMin(){
    if (min<globalMax && min<max) _params.min+=stepSize;
    notifyListeners();
  }
  void subtractMin(){
    if (min>globalMin) _params.min-=stepSize;
    notifyListeners();
  }

  bool checkTopLimitReached(local,limit){
    if (local+stepSize>limit) return true;
    return false;
  }

  bool checkBottomLimitReached(local,limit){
    if (local-stepSize<limit) return true;
    return false;
  }


}
/*
* return ScopedModelDescendant<SettingsModel>(
  builder: (context, child, settings) {
  return Text("Total price: ${cart.min}");
  },
  );
* */