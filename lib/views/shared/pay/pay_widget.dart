import 'package:cashier/helper/extensions.dart';
import 'package:cashier/providers/items_provider.dart';
import 'package:cashier/views/windows/home/widgets/customer_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PayWidget extends StatelessWidget {
  const PayWidget({Key? key, required this.width, this.fromMobile = false})
      : super(key: key);
  final double width;
  final bool fromMobile;

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsProvider>(builder: (context, provider, _) {
      return Container(
        width: width,
        height: fromMobile ? 670 : 600,
        margin: EdgeInsets.only(
          top: fromMobile ? 20 : 0,
          bottom: 20,
          right: 2.appWidth(context),
          left: 2.appWidth(context),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (fromMobile) CustomerInfoWidget(width: width),
            for (int index = 0; index < 3; index++)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          index == 0
                              ? 'Subtotal'
                              : index == 1
                                  ? 'Discounts'
                                  : 'Total',
                          style: TextStyle(
                            color: index == 2 ? Colors.red : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          index == 0
                              ? '\$ ${provider.subTotal}'
                              : index == 1
                                  ? '-\$ ${provider.discounts}'
                                  : '\$ ${provider.total}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index == 2)
                    const SizedBox(
                      height: 10,
                    ),
                  Divider(
                    color: Colors.black,
                    indent: 0,
                    endIndent: 0,
                    height: index == 2 ? 0 : null,
                  )
                ],
              ),
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  for (int index = 0; index < 3; index++)
                    index == 1
                        ? Container(
                            width: 1,
                            color: Colors.black,
                            height: 80,
                          )
                        : Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  index == 0 ? 'PAID' : 'DUE',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  index == 0
                                      ? '\$ ${provider.total}'
                                      : '\$ 0.0',
                                  style: TextStyle(
                                    color:
                                        index == 2 ? Colors.red : Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
              indent: 0,
              endIndent: 0,
              height: 0,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'ADD PAYMENT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            for (int index = 0; index < 2; index++)
              RadioListTile(
                activeColor: Colors.green,
                value: index.toString(),
                groupValue: provider.groupValue,
                onChanged: provider.changeGroupValue,
                title: Text(
                  index == 0 ? 'CASH' : 'CREDIT CARD',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Spacer(),
            Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  for (int index = 0; index < 3; index++)
                    Expanded(
                      flex: index == 2 ? 2 : 1,
                      child: GestureDetector(
                        onTap: index == 2
                            ? provider.invoiceItems.isEmpty ||
                                    provider.groupValue == null ||
                                    provider.groupValue!.isEmpty
                                ? () {}
                                : () async {
                                    final date = DateTime.now();
                                    final dueDate =
                                        date.add(const Duration(days: 7));

                                    final invoice = Invoice(
                                      supplier: const Supplier(
                                        name: 'Doha Field',
                                        address: 'Doha Street 9, Tanta',
                                        paymentInfo:
                                            'https://paypal.me/sarahfieldzz',
                                      ),
                                      customer: const Customer(
                                        name: 'Apple Inc.',
                                        address:
                                            'Apple Street, Cupertino, CA 95014',
                                      ),
                                      info: InvoiceInfo(
                                        date: date,
                                        dueDate: dueDate,
                                        description: 'My description...',
                                        number: '${DateTime.now().year}-9999',
                                      ),
                                      items: provider.invoiceItems,
                                    );
                                    await provider.generatePDF(invoice,context);
                                  }
                            : () {},
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                index == 2 ? Colors.green : Colors.transparent,
                            border: index == 2
                                ? null
                                : Border.all(
                                    color: Colors.grey,
                                    width: 0.5,
                                  ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: index == 2
                              ? const Text(
                                  'Payment',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      index == 0 ? Icons.print : Icons.discount,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                    Text(
                                      index == 0 ? 'Print' : 'Discount',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    });
  }
}
