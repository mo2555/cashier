import 'package:cashier/helper/extensions.dart';
import 'package:cashier/providers/items_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pay/pay_widget.dart';

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({Key? key, required this.width, this.fromMobile = false})
      : super(key: key);
  final double width;
  final bool fromMobile;

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsProvider>(builder: (context, provider, _) {
      return SizedBox(
        width: width,
        child: InteractiveViewer(
          constrained: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              fromMobile
                  ? provider.invoiceItems.length + 3
                  : provider.invoiceItems.length + 2,
              (index) => index == provider.invoiceItems.length + 2 && fromMobile
                  ? PayWidget(
                      width: 100.appWidth(context) - 40,
                      fromMobile: true,
                    )
                  : index == 0
                      ? Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: List.generate(
                              provider.header.length + 1,
                              (inner) => Container(
                                width:
                                    inner == 0 ? width * 0.26 : width * 0.145,
                                margin: inner == 0
                                    ? const EdgeInsets.only(left: 8)
                                    : null,
                                child: provider.header.length == inner
                                    ? null
                                    : Text(
                                        provider.header[inner],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        )
                      : index == 1
                          ? const SizedBox(
                              height: 12,
                            )
                          : Container(
                              height: 70,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                              ),
                              child: Row(
                                children: List.generate(
                                  6,
                                  (inner) => Container(
                                    width: inner == 0
                                        ? width * 0.26
                                        : width * 0.145,
                                    margin: inner == 0
                                        ? const EdgeInsets.only(left: 8)
                                        : null,
                                    child: inner == 0
                                        ? Text(
                                            provider.invoiceItems[index - 2]
                                                .description,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )
                                        : inner == 2
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      provider.minQty(provider
                                                          .invoiceItems[
                                                              index - 2]
                                                          .id);
                                                    },
                                                    child: const Text(
                                                      '-',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    '${provider.invoiceItems[index - 2].quantity}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      provider.addQty(provider
                                                          .invoiceItems[
                                                              index - 2]
                                                          .id);
                                                    },
                                                    child: const Text(
                                                      '+',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : inner == 5
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          provider.removeFromInvoice(
                                                              provider.invoiceItems[
                                                                  index - 2]);
                                                        },
                                                        child: const Icon(
                                                          Icons.delete_outline,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: const Icon(
                                                          Icons.edit,
                                                          color: Colors.green,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Text(
                                                    '\$ ${inner == 1 ? provider.invoiceItems[index - 2].unitPrice : inner == 3 ? provider.invoiceItems[index - 2].vat : (provider.invoiceItems[index - 2].unitPrice * provider.invoiceItems[index - 2].quantity) - (provider.invoiceItems[index - 2].vat * provider.invoiceItems[index - 2].quantity)}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                  ),
                                ),
                              ),
                            ),
            ),
          ),
        ),
      );
    });
  }
}
