import 'package:cashier/helper/extensions.dart';
import 'package:cashier/views/mobile/my_drawer/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/navigation_provider.dart';
import '../../shared/app_bar_widget/app_bar_widget.dart';
import '../../shared/items/items_widget.dart';
import '../../shared/pay/pay_widget.dart';
import '../../windows/home/widgets/customer_info_widget.dart';
import '../../windows/home/widgets/navigation_windows_widget.dart';

class MyHomeMobileScreen extends StatelessWidget {
  const MyHomeMobileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      key: Provider.of<NavigationProvider>(context).scaffoldKey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarWidget(
              width: 100.appWidth(context),
            ),
            const SizedBox(
              height: 20,
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ItemsWidget(
                  width: 600,
                  fromMobile: true,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

          ],
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}
