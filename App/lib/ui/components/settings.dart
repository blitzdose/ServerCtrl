import 'package:flutter/material.dart';

class SettingsSectionTitle extends StatelessWidget {

  const SettingsSectionTitle(
      this.text, {
        Key? key,
      }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500
        )
    );
  }

}

class SettingsTileTitle extends StatelessWidget {

  const SettingsTileTitle(
      this.text, {
        Key? key,
      }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16
        )
    );
  }

}