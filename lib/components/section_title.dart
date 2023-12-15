import 'package:flutter/material.dart';
import 'package:trustdine/constants.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    required this.press,
    required this.buttonText,
  });

  final String title, buttonText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      TextButton(
          onPressed: press,
          style: TextButton.styleFrom(foregroundColor: kActiveColor),
          child: Text(
            buttonText,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: kActiveColor),
          ))
    ]);
  }
}

class SectionTitleNoButton extends StatelessWidget {
  const SectionTitleNoButton({
    super.key,
    required this.title,
    // required this.press,
  });

  final String title;
  // final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
