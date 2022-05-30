import 'package:another_brother/label_info.dart';
import 'package:another_brother/printer_info.dart' as brother;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'dart:async';

class PrintAPI {
  Future<ui.Image> loadImage(String assetPath) async {
    final ByteData img = await rootBundle.load(assetPath);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(img.buffer), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  void print(BuildContext context) async {
    //////////////////////////////////////////////////
    /// Request the Storage permissions required by
    /// another_brother to print.
    //////////////////////////////////////////////////
    if (!await Permission.storage.request().isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Access to storage is needed in order print."),
        ),
      ));
      return;
    }

    var printer = brother.Printer();
    var printInfo = brother.PrinterInfo();
    printInfo.printerModel = brother.Model.QL_1110NWB;
    printInfo.printMode = brother.PrintMode.FIT_TO_PAGE;
    printInfo.isAutoCut = true;
    printInfo.port = brother.Port.BLUETOOTH;
    // Set the label type.
    printInfo.labelNameIndex = QL1100.ordinalFromID(QL1100.W103.getId());

    // Set the printer info so we can use the SDK to get the printers.
    await printer.setPrinterInfo(printInfo);

    // Get a list of printers with my model available in the network.
    List<brother.BluetoothPrinter> printers =
    await printer.getBluetoothPrinters([brother.Model.QL_1110NWB.getName()]);

    if (printers.isEmpty) {
      // Show a message if no printers are found.
      Fluttertoast.showToast(msg: "No paired printers found on your device.");

      return;
    }
    // Get the IP Address from the first printer found.
    printInfo.macAddress = printers.single.macAddress;

    printer.setPrinterInfo(printInfo);
    printer.printImage(await loadImage('assets/brother_hack.png'));
  }

  static Future<void> printPDF(
      BuildContext context, String filepath) async {
    // get Bluetooth permission
    if (!await Permission.bluetoothConnect.request().isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Access to bluetooth connect is needed in order print."),
        ),
      ));
      return;
    }

    if (!await Permission.bluetoothScan.request().isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Access to bluetooth scan is needed in order print."),
        ),
      ));
      return;
    }

    brother.Printer printer = brother.Printer();
    brother.PrinterInfo printInfo = brother.PrinterInfo();

    printInfo.printerModel = brother.Model.QL_1110NWB;
    printInfo.printMode = brother.PrintMode.FIT_TO_PAGE;
    printInfo.isAutoCut = true;
    printInfo.orientation = brother.Orientation.PORTRAIT;
    printInfo.port = brother.Port.BLUETOOTH;
    printInfo.align = brother.Align.CENTER;

    // set the label type
    printInfo.labelNameIndex = QL1100.ordinalFromID(QL1100.W103.getId());

    // set the printer info so we can use the SDK to get the printers
    await printer.setPrinterInfo(printInfo);

    // Get a list of printers with my model available
    List<brother.BluetoothPrinter> printers = await printer
        .getBluetoothPrinters([brother.Model.QL_1110NWB.getName()]);

    if (printers.isEmpty) {
      // Show a message if no printers are found.
      Fluttertoast.showToast(msg: "No paired printers found on your device.");

      return;
    }

    // get the MAC address of the first printer
    printInfo.macAddress = printers.first.macAddress;

    printer.setPrinterInfo(printInfo);


    await printer.printPdfFile(filepath, 1);
    return;
  }
}
