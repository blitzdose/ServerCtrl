import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:server_ctrl/navigator_key.dart';
import 'package:server_ctrl/utilities/http/http_utils.dart';
import 'package:server_ctrl/utilities/http/session.dart';
import 'package:server_ctrl/utilities/permissions/permissions.dart';
import 'package:server_ctrl/values/colors.dart';

import '../../../../generated/l10n.dart';
import '../../../../utilities/api/api_utilities.dart';
import '../../../../utilities/snackbar/snackbar.dart';
import '../tab.dart';
import 'models/player.dart';

class PlayersController extends TabxController {

  final playerItems = <Widget>[].obs;

  PlayersController();

  @override
  void updateData() async {
    var response = await fetchData();
    if (HttpUtils.isSuccess(response)) {
      var data = jsonDecode(response.body);
      var players = data["Player"];
      playerItems.clear();
      for (var player in players) {
        playerItems.add(createPlayerWidget(Player(player["name"], player["uuid"], player["texturelink"], bool.parse(player["isOp"]))));
      }
      if (playerItems.isEmpty) {
        playerItems.add(
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text(S.current.noPlayersOnline),
              ),
            )
        );
      }
    }
    showProgress(false);
  }

  @override
  Future<http.Response> fetchData() async {
    return await Session.post("/api/player/online", "{}");
  }

  Widget createPlayerWidget(Player player) {
    return Card(
      surfaceTintColor: MColors.cardTint(navigatorKey.currentContext!),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(player.name, style: const TextStyle(fontSize: 24)),
                      Text(player.uuid)
                    ],
                  ),
                ),
                Image(
                  alignment: Alignment.centerRight,
                  image: NetworkImage(player.textureLink),
                  width: 84,
                  height: 84,
                )
              ],
            ),
            Row(
              children: <Widget>[
                if (userPermissions!.hasPermission(Permissions.PERMISSION_KICK)) TextButton(
                    onPressed: () => sendCommand("kick", player),
                    child: Text(S.current.kick)
                ),
                if (userPermissions!.hasPermission(Permissions.PERMISSION_BAN)) TextButton(
                    onPressed: () => sendCommand("ban", player),
                    child: Text(S.current.ban)
                ),
                if (userPermissions!.hasPermission(Permissions.PERMISSION_OP)) TextButton(
                    onPressed: () => sendCommand(player.isOp ? "deop" : "op", player),
                    child: Text(player.isOp ? S.current.deop : S.current.op)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void sendCommand(String command, Player player) async {
    if (await ApiUtilities.sendCommand("$command ${player.name}")) {
      Snackbar.createWithTitle(S.current.players, S.current.success);
    } else {
      Snackbar.createWithTitle(S.current.players, S.current.error_sending_command, true);
    }
    updateData();
  }
}