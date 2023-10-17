import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:trustdine/screens/auth/login_screen.dart';
import 'package:trustdine/storage/cache.dart';
import 'printer_utils.dart';

class PrinterDialog extends StatefulWidget {
  @override
  _PrinterDialogState createState() => _PrinterDialogState();
}

class _PrinterDialogState extends State<PrinterDialog> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  void getDevices() async {
    devices = await BlueThermalPrinter.instance.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          const BoxShadow(
              color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Configure Printer",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          // Add receipt content here
          const SizedBox(height: 20),
          DropdownButton(
            value: selectedDevice,
            hint: const Text("Select thermal printer"),
            onChanged: (device) {
              setState(() {
                selectedDevice = device;
              });
            },
            items: devices
                .map((e) => DropdownMenuItem(child: Text(e.name!), value: e))
                .toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (selectedDevice != null) {
                await BlueThermalPrinter.instance.connect(selectedDevice!);
                setState(() {
                  isConnected = true;
                });
              }
            },
            child:
                isConnected ? const Text("Connected") : const Text("Connect"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () async {
              if (isConnected) {
                PrinterUtils printerUtils = PrinterUtils();
                await printerUtils.newLine();
                await printerUtils.printData("Test Print Successfull");
                await printerUtils.newLine();
                await printerUtils.printQR();
                await printerUtils.newLine();
              }
            },
            child: const Text("Test Printer"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () async {
              await SecureStorageManager.deleteToken();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false, // This will remove all routes from the stack
              );
            },
            child: const Text("Logout"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
          ),
        ],
      ),
    );
  }
}
