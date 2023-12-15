import 'dart:async';
import 'package:intl/intl.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:trustdine/apiData.dart';
import 'package:trustdine/backend/api_processes.dart';
import 'package:trustdine/backend/cartManager.dart';
import 'package:trustdine/storage/cache.dart';

class PrinterUtils {
  BlueThermalPrinter _printer = BlueThermalPrinter.instance;

  Future<List<BluetoothDevice>> getBondedDevices() async {
    return await _printer.getBondedDevices();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await _printer.connect(device);
  }

  Future<void> disconnectDevice() async {
    await _printer.disconnect();
  }

  Future<void> newLine() async {
    await _printer.printNewLine();
  }

  Future get isConnected async {
    return await _printer.isConnected;
  }

  Future<void> printData(String data) async {
    if (await isConnected) {
      _printer.printNewLine();
      _printer.printCustom(data, 5, 10);
    }
  }

  Future<void> printQR() async {
    if (await isConnected) {
      _printer.printNewLine();
      _printer.printQRcode("Test Print", 250, 250, 15);
    }
  }

  Future<void> cutPaper() async {
    if (await isConnected) {
      _printer.paperCut();
    }
  }

  Future<void> printRestaurantReceipt(String restaurantName, String orderID,
      List<AddedProduct> cartItems, double totalAmount) async {
    String? token = await SecureStorageManager.getToken() as String;

    double discountPercentage =
        double.parse(InvoiceData[0]['discount'].toString());
    double discountAmount = (discountPercentage / 100) * totalAmount;
    double amountAfterDiscount = totalAmount - discountAmount;
    double gstPercentage = double.parse(InvoiceData[0]['gst'].toString());
    double gstAmount = (gstPercentage / 100) * amountAfterDiscount;
    sendRevenueData(amountAfterDiscount + gstAmount);
    if (await isConnected) {
      try {
        _printer.printNewLine();
        // _printer.printImage("trustdine_logo.png");
        _printer.printCustom("**************************", 1, 1);
        // _printer.printNewLine();
        _printer.printCustom("${InvoiceData[0]['companyName']}", 2, 1);
        // _printer.printNewLine();
        _printer.printCustom("**************************", 1, 1);
        _printer.printNewLine();
        _printer.printCustom(
          "${InvoiceData[0]['companyAddress']}",
          1,
          1,
        );
        _printer.printCustom("GSTIN: ${InvoiceData[0]['GSTIN']}", 1, 1);
        _printer.printCustom("${InvoiceData[0]['companyEmail']}", 1, 1);
        DateTime now = DateTime.now();
        String formattedDateTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
        _printer.printCustom("$formattedDateTime", 1, 1);

        _printer.printNewLine();
        _printer.printQRcode(orderID, 250, 250, 1);
        _printer.printCustom("----------------------------", 1, 1);
        _printer.printCustom("Item       Qty        Price", 1, 1);
        _printer.printCustom("----------------------------", 1, 1);
        _printer.printNewLine();
        for (AddedProduct item in CartManager().addedProducts) {
          _printer.printCustom(
            "${item.productName}  x ${item.quantity} (${item.size}) --- Rs ${item.price}",
            1,
            1,
          );
        }
        _printer.printCustom("----------------------------", 1, 1);
        _printer.printCustom(
            "Discount @$discountPercentage% ----- -Rs $discountAmount", 1, 1);
        _printer.printCustom(
            "GST @$gstPercentage% ----- +Rs ${gstAmount.toStringAsFixed(2)}",
            1,
            1);
        _printer.printCustom("----------------------------", 1, 1);
        _printer.printNewLine();
        _printer.printNewLine();

        _printer.printCustom("----------------------------", 1, 1);
        _printer.printCustom(
            "Total: Rs ${(amountAfterDiscount + gstAmount).toStringAsFixed(2)}",
            2,
            1);
        _printer.printCustom("(Price Inclusive of GST $gstPercentage%)", 1, 1);
        _printer.printCustom("----------------------------", 1, 1);
        /*  _printer.printLeftRight(
            "   Total", "${totalAmount.toStringAsFixed(2)} INR  ", 1); */
        _printer.printNewLine();
        _printer.printNewLine();
        _printer.printCustom("**************************", 1, 1);
        _printer.printCustom("${InvoiceData[0]['footerText']}", 1, 1);
        _printer.printCustom("\nYour Order ID: $orderID", 1, 1);
        _printer.printCustom("**************************", 1, 1);
        _printer.printNewLine();
        _printer.printNewLine();
        _printer.paperCut();
      } catch (e) {
        print(e);
      }
    }
  }
}
