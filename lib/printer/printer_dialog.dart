// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trustdine/screens/auth/login_screen.dart';
import 'package:trustdine/storage/cache.dart';
import 'package:trustdine/ui_configs.dart';
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
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Control Panel",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          // Printer Settings
          ExpansionTile(
            title: const Text("Printer Settings"),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton(
                value: selectedDevice,
                hint: const Text("Select thermal printer"),
                onChanged: (device) {
                  setState(() {
                    selectedDevice = device;
                  });
                },
                items: devices
                    .map(
                        (e) => DropdownMenuItem(value: e, child: Text(e.name!)))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedDevice != null) {
                        await BlueThermalPrinter.instance
                            .connect(selectedDevice!);
                        setState(() {
                          isConnected = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87),
                    child: isConnected
                        ? const Text("Connected")
                        : const Text("Connect"),
                  ),
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
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87),
                    child: const Text("Test Printer"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),

          // Layout Settings
          ExpansionTile(
            title: const Text("Layout Settings"),
            children: [
              // Shrink
              ExpansionTile(
                title: const Text("Shrink"),
                children: [
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        topPad += 1;
                      });
                      await SecureStorageManager.savePadding();
                      await SecureStorageManager.getPadding();
                      print(topPad);
                    },
                    icon: const Icon(Icons.arrow_downward),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            leftPad += 1;
                          });
                          await SecureStorageManager.savePadding();
                        },
                        icon: const Icon(Icons.arrow_forward_ios_sharp),
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            rightPad += 1;
                          });
                          await SecureStorageManager.savePadding();
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        bottomPad += 1;
                      });
                      await SecureStorageManager.savePadding();
                    },
                    icon: const Icon(Icons.arrow_upward),
                  ),
                  TextButton(
                    onPressed: () {
                      print("${[topPad, bottomPad, leftPad, rightPad]}");
                    },
                    child: Text("Show Config"),
                  )
                ],
              ),

              // Expand
              ExpansionTile(
                title: const Text("Expand"),
                children: [
                  IconButton(
                    onPressed: () async {
                      await SecureStorageManager.savePadding();
                      if (topPad > 0) {
                        setState(() {
                          topPad -= 1;
                        });
                      } else {
                        Fluttertoast.showToast(msg: "Already at minimum");
                      }
                    },
                    icon: const Icon(Icons.arrow_upward),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await SecureStorageManager.savePadding();
                          if (leftPad > 0) {
                            setState(() {
                              leftPad -= 1;
                            });
                          } else {
                            Fluttertoast.showToast(msg: "Already at minimum");
                          }
                        },
                        icon: const Icon(Icons.arrow_back_ios_sharp),
                      ),
                      IconButton(
                        onPressed: () async {
                          await SecureStorageManager.savePadding();
                          if (rightPad > 0) {
                            setState(() {
                              rightPad -= 1;
                            });
                          } else {
                            Fluttertoast.showToast(msg: "Already at minimum");
                          }
                        },
                        icon: const Icon(Icons.arrow_forward_ios_sharp),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      await SecureStorageManager.savePadding();
                      if (bottomPad > 0) {
                        setState(() {
                          bottomPad -= 1;
                        });
                      } else {
                        Fluttertoast.showToast(msg: "Already at minimum");
                      }
                    },
                    icon: const Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),
          ExpansionTile(
              title: Text(
                "Auth Manager",
                style: TextStyle(color: Colors.red.shade600),
              ),
              expandedAlignment: Alignment.topLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Clicking the button below will log you out and you will need to signin again with email and password.",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          SystemNavigator.pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: const Text("Exit App"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await SecureStorageManager.deleteToken();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) =>
                                false, // This will remove all routes from the stack
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                        ),
                        child: const Text("Logout"),
                      ),
                    ),
                  ],
                ),
              ]),
        ],
      ),
    );
  }
}
