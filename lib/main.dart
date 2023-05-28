import 'dart:io';

import 'package:cashier/helper/extensions.dart';
import 'package:cashier/providers/items_provider.dart';
import 'package:cashier/providers/navigation_provider.dart';
import 'package:cashier/views/mobile/home/my_home_mobile_screen.dart';
import 'package:cashier/views/start/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'views/windows/home/my_home_windows_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Cashier');
    setWindowMaxSize(const Size(10000, 1500));
    setWindowMinSize(const Size(450, 900));
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: NavigationProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ItemsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cashier',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const StartScreen(),
    );
  }
}
