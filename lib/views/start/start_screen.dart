import 'package:cashier/helper/extensions.dart';
import 'package:flutter/material.dart';

import '../mobile/home/my_home_mobile_screen.dart';
import '../windows/home/my_home_windows_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 100.appWidth(context) > 800
        ?  MyHomeWindowsScreen()
        : const MyHomeMobileScreen();
  }
}
