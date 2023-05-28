
import 'dart:io';

import 'package:cashier/views/shared/scanner/scanner_screen.dart';
import 'package:cashier/views/shared/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/navigation_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key, this.fromMobile = true}) : super(key: key);
  final bool fromMobile;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          left: 20,
        ),
        child: Consumer<NavigationProvider>(builder: (context, provider, _) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                width: double.infinity,
                color: provider.currentIndex == 0
                    ? Colors.deepPurpleAccent.withOpacity(0.2)
                    : Colors.transparent,
                child: IconButton(
                  onPressed: () {
                    provider.changeCurrentIndex(0);
                  },
                  icon: const Icon(
                    Icons.home,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(
              //     vertical: 5,
              //   ),
              //   width: double.infinity,
              //   color: provider.currentIndex == 1
              //       ? Colors.deepPurpleAccent.withOpacity(0.2)
              //       : Colors.transparent,
              //   child: IconButton(
              //     onPressed: () {
              //       provider.changeCurrentIndex(1);
              //     },
              //     icon: const Icon(
              //       Icons.arrow_right_alt_rounded,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const SearchScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.search_rounded,
                ),
              ),
              if(Platform.isAndroid)
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const ScannerScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.qr_code_2,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
