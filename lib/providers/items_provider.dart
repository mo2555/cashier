import 'dart:convert';
import 'dart:io';

import 'package:cashier/helper/pdf_viewer_widget.dart';
import 'package:flutter/material.dart' as m;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;

class ItemsProvider extends m.ChangeNotifier {
  List<String> header = [
    "Items",
    "Price",
    "Qty.",
    "Disc.",
    "SubTotal",
  ];

  List<String> header2 = [
    "Item",
    "Price",
    "Disc.",
    "SubTotal",
  ];

  String? groupValue;

  changeGroupValue(String? value) {
    groupValue = value;
    notifyListeners();
  }

  m.TextEditingController controller = m.TextEditingController();

  List<InvoiceItem> invoiceItems = [];

  InvoiceItem? searchItem;

  resetItem() {
    searchItem = null;
    controller = m.TextEditingController();
    notifyListeners();
  }

  void addToInvoice(InvoiceItem item) {
    if (invoiceItems.indexWhere((element) => element.id == item.id) == -1) {
      invoiceItems.add(item);
    } else {
      invoiceItems.forEach((element) {
        if (element.id == item.id) {
          element.quantity++;
        }
      });
    }
    notifyListeners();
    calculatePrices();
  }

  removeFromInvoice(InvoiceItem item) {
    invoiceItems.removeWhere((element) => element.id == item.id);
    notifyListeners();
    calculatePrices();
  }

  addQty(int id) {
    invoiceItems.forEach((element) {
      if (element.id == id) {
        element.quantity++;
      }
      notifyListeners();
    });
    calculatePrices();
  }

  minQty(int id) {
    invoiceItems.forEach((element) {
      if (element.id == id) {
        if (element.quantity > 1) {
          element.quantity--;
        }
      }
      notifyListeners();
    });
    calculatePrices();
  }

  double total = 0.0;
  double subTotal = 0.0;
  double discounts = 0.0;

  calculatePrices() {
    subTotal = 0.0;
    discounts = 0.0;
    total = 0.0;
    invoiceItems.forEach((element) {
      subTotal += element.quantity * element.unitPrice;
      discounts += element.quantity * element.vat;
      total = subTotal - discounts;
      notifyListeners();
    });
  }

  bool getItemLoading = false;

  scannerSearch(int id) {
    controller.text = id.toString();
    notifyListeners();
    getItem(id);
  }

  Future<void> getItem(int id) async {
    getItemLoading = true;
    notifyListeners();
    try {
      final http.Response response = await http.get(
        Uri.parse('http://cashier.somee.com/api/Items/$id'),
      );
      final body = json.decode(response.body);
      if (body['success'] == true) {
        searchItem = InvoiceItem.fromJson(body['data']);
      }
      getItemLoading = false;
      notifyListeners();
    } on SocketException {
      getItemLoading = false;
      notifyListeners();
      print('object');
    } catch (e) {
      print(e.toString());
      getItemLoading = false;
      notifyListeners();
    }
  }

  resetAll() {
    invoiceItems = [];
    groupValue=null;
    calculatePrices();
    notifyListeners();
  }

  Future<void> generatePDF(Invoice invoice,m.BuildContext context) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    // Save the PDF to a temporary directory
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/my_document.pdf');
    final saved = await file.writeAsBytes(await pdf.save());
    if (Platform.isAndroid) {
      try {
        m.Navigator.push(
          context,
          m.MaterialPageRoute(
            builder: (ctx) => PdfViewerWidget(pdf: saved.path),
          ),
        );
        resetAll();
      } catch (e) {
        print(e.toString());
      }
    } else {
      if (await canLaunch("file://${saved.path}")) {
        await launch("file://${saved.path}");
        resetAll();
      } else {
        print("cannot launch url ]:");
      }
    }
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.address),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      "Items",
      'Date',
      "Qty.",
      "Price",
      "Disc.",
      'Total',
    ];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity - (item.quantity * item.vat);

      return [
        item.description,
        Utils.formatDate(item.date),
        '${item.quantity}',
        '\$ ${item.unitPrice}',
        '\$ ${item.vat}',
        '\$ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  Widget buildTotal(Invoice invoice) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: Utils.formatPrice(subTotal),
                  unite: true,
                ),
                buildText(
                  title: 'Discount',
                  value: Utils.formatPrice(discounts),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount due',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: invoice.supplier.address),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

class Customer {
  final String name;
  final String address;

  const Customer({
    required this.name,
    required this.address,
  });
}

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
  });
}

class InvoiceItem {
  late String description;
  late DateTime date;
  late int quantity;
  late int id;
  late double vat;
  late double unitPrice;

  InvoiceItem({
    required this.id,
    required this.description,
    required this.date,
    required this.quantity,
    required this.vat,
    required this.unitPrice,
  });

  InvoiceItem.fromJson(dynamic json) {
    id = json['id'];
    unitPrice = json['price'].toDouble();
    description = json['name'];
    vat = json['discount'].toDouble();
    date = DateTime.now();
    quantity = 1;
  }
}

class Supplier {
  final String name;
  final String address;
  final String paymentInfo;

  const Supplier({
    required this.name,
    required this.address,
    required this.paymentInfo,
  });
}

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';

  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}
