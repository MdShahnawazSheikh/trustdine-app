import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeeeeef),
      body: Column(
        children: [
          Lottie.asset("assets/illustrations/rocket_taking_off.json"),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ways to SignUp",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "- Visit our website: www.trustdine.com",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "- Contact us at: developer.trustsign@gmail.com",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          BackButton(),
        ],
      ),
    );
  }
}
