import 'package:flutter/material.dart';

class Modal {
  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Minimum percent'),
                Text('Maximum percent'),
                Text('Number of stars'),
              ],
            ),
          );
        });
  }
}
