import 'package:cashier/helper/extensions.dart';
import 'package:cashier/providers/navigation_provider.dart';
import 'package:cashier/views/mobile/my_drawer/my_drawer.dart';
import 'package:cashier/views/shared/app_bar_widget/app_bar_widget.dart';
import 'package:cashier/views/shared/items/items_widget.dart';
import 'package:cashier/views/shared/pay/pay_widget.dart';
import 'package:cashier/views/windows/home/widgets/customer_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/navigation_windows_widget.dart';

class MyHomeWindowsScreen extends StatelessWidget {
  const MyHomeWindowsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Provider.of<NavigationProvider>(context).scaffoldKey,
      body: Row(
        children: [
          const NavigationWindowsWidget(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppBarWidget(
                      width: 61.appWidth(context),
                    ),
                    CustomerInfoWidget(
                      width: 37.appWidth(context) - 55,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ItemsWidget(
                          width: 60.appWidth(context),
                        ),
                      ),
                      PayWidget(
                        width: 36.appWidth(context) - 55,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(fromMobile: false,),
    );
  }
}
