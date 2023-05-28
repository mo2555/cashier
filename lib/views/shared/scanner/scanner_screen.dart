// import 'package:flutter_zxing/flutter_zxing.dart';
import 'dart:io';

import 'package:cashier/helper/extensions.dart';
import 'package:cashier/providers/items_provider.dart';
import 'package:cashier/views/shared/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// Use ReaderWidget to quickly read barcode from camera image
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey inter = GlobalKey(debugLabel: 'inter');

  Barcode? result;

  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<ItemsProvider>(context, listen: false).resetItem();
    });
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ItemsProvider>(builder: (context, provider, _) {
        return Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: (result != null)
                    ? TextButton(
                        onPressed: () async {
                          if (result != null && result!.code != null) {
                            provider.scannerSearch(int.parse(result!.code!));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const SearchScreen(),
                              ),
                            );
                          }
                        },
                        child: const Text("Get Item"),
                      )
                    : const Text('Scan a code'),
              ),
            )
          ],
        );
      }),
    );
  }
}
