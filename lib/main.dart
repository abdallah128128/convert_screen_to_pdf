import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary(
        key: _printKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  children: const [
                    Text('Convert Screen To Pdf'),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _printScreen,
        child: const Icon(Icons.save),
      ),
    );
  }

  void _printScreen() {
    Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();

      final image = await WidgetWraper.fromKey(
        key: _printKey,
        pixelRatio: 3.0,
      );

      doc.addPage(pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Expanded(
                child: pw.Image(image),
              ),
            );
          }));

      return doc.save();
    },

    );
  }
}