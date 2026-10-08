import 'package:flutter/material.dart';
import 'package:server_ctrl/ui/views/main_view/main_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../generated/l10n.dart';
import '../../../navigator_key.dart';

class NoServersAddedWidget extends StatelessWidget {
  final MainController controller;
  const NoServersAddedWidget(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [

            Text("No clients added", style: const TextStyle(fontSize: 32, ), textAlign: TextAlign.center),
            const Divider(),
            Text("You have successfully connected to the ServerCtrl SERVER. But you have not provisioned a CLIENT yet.", textAlign: TextAlign.center),
            const Padding(padding: EdgeInsets.only(top: 48.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton.icon(
                    onPressed: () {
                      showDialog(
                        context: navigatorKey.currentContext!,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text("How do I provision a client?"),
                              content: Text("ServerCtrl uses two different types of the Plugin: A Server and a Client.\n\nThe Server-Plugin manages connections, users, etc. and orchestrates everything.\n\nThe Client-Plugin is what interfaces with your actual server to get current players, the console, and more. The Client-Plugin connects to the Server-Plugin. This allows you to connect multiple servers together.\n\nFor more information have a look at the documentation."),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(onPressed: () => launchUrl(Uri.parse("https://serverctrl.blitzdose.de/docs/intro")), child: Text("Documentation")),
                                    TextButton(onPressed: () => Navigator.pop(context), child: Text(S.current.ok))
                                  ],
                                )
                              ]
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.help_rounded),
                    label: Text(S.current.help)),
                FilledButton.icon(
                  onPressed: () {
                    controller.addClient();
                  },
                  icon: Icon(Icons.add_rounded),
                  label: Text("Add Client"),
                )
              ],
            )
          ]
      ),
    );
  }
}

class ClientNotConnectedWidget extends StatelessWidget {
  const ClientNotConnectedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Icon(Icons.sentiment_very_dissatisfied_rounded, size: 96,),
          Text("Client is not connected", style: TextStyle(fontSize: 17),)
        ],
      ),
    );
  }
}