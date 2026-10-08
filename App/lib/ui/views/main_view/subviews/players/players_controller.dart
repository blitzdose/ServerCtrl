import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/subview_controller.dart';
import 'package:server_ctrl/utilities/api/api.dart';
import 'package:server_ctrl/utilities/api/models/player.dart';
import 'package:server_ctrl/utilities/api/models/server_data.dart';
import 'package:server_ctrl/utilities/lazyloader/lazy_loader.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../utilities/snackbar/snackbar.dart';

class PlayersController extends SubviewController {

  final players = <Player>[].obs;
  final serverType = ServerType.BUNGEE.obs;
  final showProgress = false.obs;

  late LazyLoader lazyLoader;

  PlayersController({required super.system, required super.userPermissions, required super.onSetActions, required super.onSetLeading, required super.onSetBottom});

  @override
  void onInit() {
    super.onInit();
    lazyLoader = LazyLoader<Player>(
        loadingFunction: (pagination) => PlayerApi(system).getOnlinePlayer(pagination),
        pageSize: 10,
        onLoadingChanged: (finished) => showProgress(!finished),
        onEntriesUpdated: (entries) => players.assignAll(entries),
    );
    asyncInit();
  }

  @override
  void onShown() {
    super.onShown();
    onSetActions.call(
        [
          IconButton(
              onPressed: () {
                lazyLoader.refresh();
              },
              icon: const Icon(Icons.refresh_rounded)
          )
        ]
    );
  }

  @override
  Future<void> updateData() async {

  }

  Future<void> asyncInit() async {
    ServerData? serverData = await ServerApi(system).getServerData();
    if (serverData != null) {
      serverType(serverData.type);
    }
    lazyLoader.loadNext();
  }

  Future<void> sendCommand(Player player, String command) async {
    if (!await ConsoleApi(system).executeCommand("$command ${player.name}")) {
      Snackbar.createWithTitle(S.current.players, S.current.error_sending_command, true);
    }
  }

}