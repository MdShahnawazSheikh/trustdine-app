import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:trustdine/backend/central_api.dart'; // Assuming loginUser is implemented in this file
import 'package:trustdine/components/CustomTextField.dart';
import 'package:trustdine/components/LargeCustomButton.dart';
import 'package:trustdine/main.dart';
import 'package:trustdine/storage/cache.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoggingIn = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter both email and password.");
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    try {
      Map<String, dynamic> userData =
          await loginUser(_emailController.text, _passwordController.text);
      String token = userData['authtoken'];
      await SecureStorageManager.saveCredentials(token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    } catch (e) {
      setState(() {
        _isLoggingIn = false;
      });
      Fluttertoast.showToast(
          msg: "Wrong Credentials! Contact us: trustdine.com");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double logoWidth = screenWidth / 2.6;
    if (screenWidth > screenHeight) {
      logoWidth = screenHeight / 3;
    }
    Color textColor = Color.fromARGB(230, 230, 237, 243);
    return Scaffold(
      backgroundColor: Color(0xFF0d154d),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset(
              "assets/illustrations/hills_night.json",
              frameRate: FrameRate(30),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: textColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please sign in to continue",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: textColor,
                        ),
                  ),
                  const SizedBox(
                    height: 44.0,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    hintText: "Email Address",
                    prefixIcon: Icons.mail,
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    prefixIcon: Icons.security,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  _isLoggingIn
                      ? const Center(
                          child: CircularProgressIndicator(
                            semanticsLabel: "Logging You In",
                            backgroundColor: Colors.grey,
                            color: Color.fromARGB(255, 255, 255, 255),
                            semanticsValue: AutofillHints.countryName,
                          ),
                        )
                      : Center(
                          child: LargeCustomButton(
                            yourText: "Login",
                            onPressedFunction: _handleLogin,
                            buttonColor: Color.fromARGB(230, 233, 245, 255),
                            textColor: Color(0xFF0d154d),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
