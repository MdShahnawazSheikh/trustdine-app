import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:trustdine/backend/cartManager.dart';
import 'package:trustdine/main.dart';

class GoHomeButton extends StatelessWidget {
  GoHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyApp(),
              ));
        },
        icon: const Icon(IonIcons.home),
        label: const Text("Home"),
        style: IconButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 43, 124, 45),
        ),
      ),
    );
  }
}
