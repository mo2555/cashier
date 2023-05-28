import 'package:cashier/helper/extensions.dart';
import 'package:cashier/providers/navigation_provider.dart';
import 'package:cashier/views/shared/scanner/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({Key? key, required this.width}) : super(key: key);
  final double width;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  String result = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: 70,
      child: Column(
        children: [
          const Spacer(),
          Row(
            children: [
              if (widget.width == 100.appWidth(context))
                IconButton(
                  onPressed: () {
                    Provider.of<NavigationProvider>(context, listen: false)
                        .scaffoldKey
                        .currentState!
                        .openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                  ),
                ),
              const SizedBox(
                width: 12,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'S W',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'SUPERMARKET',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Sales',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '/New sale',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              // if (widget.width != 100.appWidth(context))
              //   IconButton(
              //     onPressed: () async {
              //
              //       // Navigator.push(
              //       //   context,
              //       //   MaterialPageRoute(
              //       //     builder: (ctx) => const ScannerScreen(),
              //       //   ),
              //       // );
              //     },
              //     icon: const Icon(
              //       Icons.qr_code_2,
              //       size: 30,
              //     ),
              //   ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          const Spacer(),
          const Divider(
            thickness: 1,
            height: 1,
          ),
        ],
      ),
    );
  }
}
