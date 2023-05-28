import 'package:cashier/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/navigation_provider.dart';
import '../../../shared/search/search_screen.dart';

class NavigationWindowsWidget extends StatelessWidget {
  const NavigationWindowsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      margin: EdgeInsets.only(
        bottom: 15.appHeight(context),
        right: 5,
      ),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child:
      Consumer<NavigationProvider>(builder: (context, provider, _) {
        return Column(
          children: [
            IconButton(
              onPressed: () {
                provider.scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(
                Icons.menu,
              ),
            ),
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
            // const SizedBox(
            //   height: 10,
            // ),
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
            const Spacer(),
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
          ],
        );
      }),
    );
  }
}
