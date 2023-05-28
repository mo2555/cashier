import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  int currentIndex = 0;

  changeCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
