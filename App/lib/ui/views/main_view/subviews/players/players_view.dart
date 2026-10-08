import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/players/players_controller.dart';
import 'package:server_ctrl/utilities/api/models/permission.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../navigator_key.dart';
import '../../../../../utilities/api/models/player.dart';
import '../../../../../utilities/api/models/server_data.dart';
import '../../../../../values/colors.dart';

class PlayersView extends StatelessWidget {
  final controller = Get.find<PlayersController>();
  final ScrollController scrollController = ScrollController();

  PlayersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Stack(
          children: [
            Scrollbar(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 60) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.lazyLoader.loadNext();
                      });
                    }
                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.lazyLoader.refresh();
                    },
                    child: ListView.builder(
                      itemCount: controller.players.length,
                        itemBuilder: (context, index) {
                          return PlayerRow(
                            player: controller.players[index],
                            serverType: controller.serverType.value,
                            userPermissions: controller.params.userPermissions,
                            onCommand: (command) => controller.sendCommand(controller.players[index], command),
                          );
                        },
                    ),
                  )
                )
              ),
            ),
            if (controller.showProgress.value) const LinearProgressIndicator()
          ],
        )
    );
  }
}

class PlayerRow extends StatelessWidget {
  final Player player;
  final ServerType serverType;
  final List<Permission> userPermissions;
  final Function(String command) onCommand;
  const PlayerRow({super.key, required this.player, required this.serverType, required this.userPermissions, required this.onCommand});

  @override
  Widget build(BuildContext context) {
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
                  fit: BoxFit.fill,
                  image: NetworkImage(player.textureLink),
                  width: 84,
                  height: 84,
                )
              ],
            ),
            serverType == ServerType.SPIGOT ? Row(
              children: <Widget>[
                if (userPermissions.contains(Permission.KICK)) TextButton(
                    onPressed: () => onCommand("kick"),
                    child: Text(S.current.kick)
                ),
                if (userPermissions.contains(Permission.BAN)) TextButton(
                    onPressed: () => onCommand("ban"),
                    child: Text(S.current.ban)
                ),
                if (userPermissions.contains(Permission.OP)) TextButton(
                    onPressed: () => onCommand(player.isOp ? "deop" : "op"),
                    child: Text(player.isOp ? S.current.deop : S.current.op)
                ),
              ],
            ) : Container()
          ],
        ),
      ),
    );
  }

}