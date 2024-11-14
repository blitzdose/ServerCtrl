import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

import 'package:server_ctrl/utilities/http/session.dart';

class Logout extends StatelessWidget {

  Logout({super.key}) {
    logout();
  }

  void logout() async {
    await Session.post("/api/user/logout", {});
    html.window.location.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}