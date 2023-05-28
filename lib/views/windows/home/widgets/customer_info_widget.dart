import 'package:cashier/helper/extensions.dart';
import 'package:flutter/material.dart';

class CustomerInfoWidget extends StatelessWidget {
  const CustomerInfoWidget({Key? key, required this.width}) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: width,
      margin: EdgeInsets.only(
        right: 2.appWidth(context),
      ),
      child: Column(
        children: [
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 8,
              ),
              const Text(
                'Cashier #1',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                height: 40,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/woman.png',
                ),
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
