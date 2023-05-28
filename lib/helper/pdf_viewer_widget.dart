import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerWidget extends StatefulWidget {
  const PdfViewerWidget({Key? key, required this.pdf}) : super(key: key);
final String pdf;
  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  var pdfController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pdfController= PdfController(
      document: PdfDocument.openFile(widget.pdf),
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor:Colors.black,
      ),
      body: Center(
          child: PdfView(
            controller: pdfController,
          )
      ),
    );
  }
}
