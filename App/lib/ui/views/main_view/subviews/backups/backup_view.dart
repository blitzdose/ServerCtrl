import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/backups/backup_controller.dart';
import 'package:server_ctrl/utilities/api/models/backup.dart';
import 'package:server_ctrl/utilities/dialogs/dialogs.dart';
import 'package:server_ctrl/values/colors.dart';

import '../../../../../utilities/snackbar/snackbar.dart';

class BackupView extends StatelessWidget {
  final controller = Get.find<BackupController>();
  final ScrollController scrollController = ScrollController();

  BackupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Stack(
          children: [
            SizedBox(
              child: Scrollbar(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.asyncInit();
                      },
                      child: ListView.builder(
                        itemCount: controller.backups.length,
                        itemBuilder: (context, index) {
                          return BackupRow(
                            backup: controller.backups[index],
                            onDelete: () async {
                              await controller.deleteBackup(controller.backups[index]);
                              controller.asyncInit();
                            },
                            onDownload: () async {
                              await controller.downloadBackup(controller.backups[index]);
                              controller.asyncInit();
                            },
                          );
                        },
                      ),
                    ),
                  )
              ),
            ),
            if (controller.showProgress.value) const LinearProgressIndicator() else const SizedBox(height: 4.0),
          ],
        )
    );
  }

  static Widget generateFloatingActionButton(BackupController controller) {
    return FloatingActionButton(
      child: Icon(Icons.add_rounded),
      onPressed: () {
        final backupType = BackupType.FULL.obs;
        Get.dialog(
            barrierDismissible: false,
            AlertDialog(
              title: Text("Create Backup"),
              content: Obx(() => RadioGroup<BackupType>(
                    onChanged: (value) {
                      backupType(value);
                    },
                    groupValue: backupType.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<BackupType>(
                          value: BackupType.FULL,
                          title: Text("Full Backup"),
                        ),
                        RadioListTile<BackupType>(
                          value: BackupType.WORLD,
                          title: Text("Backup worlds"),
                        )
                      ],
                    )
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
                    TextButton(onPressed: () async {
                      if (backupType.value == BackupType.FULL) {
                        Get.back();
                        await controller.startFullBackup();
                        await controller.asyncInit();
                      } else if (backupType.value == BackupType.WORLD) {

                      }
                    }, child: Obx(() => Text(backupType.value == BackupType.FULL? "Create" : "Next"))),
                  ],
                )
              ],
            )
        );
      },
    );
  }
}

class BackupRow extends StatefulWidget {
  final Backup backup;
  final Function()? onDelete;
  final Function()? onDownload;

  const BackupRow({required this.backup, this.onDelete, this.onDownload, super.key});

  @override
  State<BackupRow> createState() => _BackupRowState();
}

class _BackupRowState extends State<BackupRow> {
  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: MColors.cardTint(context),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (widget.backup.state == BackupState.RUNNING) {
            Snackbar.createWithTitle("Backup", "Backup is running");
            return;
          }
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return Padding(
                  padding: const EdgeInsets.all(32),
                  child: AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      title: Text("Backup"),
                      content: SizedBox(
                        width: min(500, MediaQuery.of(context).size.width),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.backup.parsedDate(), style: const TextStyle(fontSize: 18),),
                            Text(widget.backup.filename)
                          ],
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(onPressed: () {
                                  Get.back();
                                  ConfirmationDialog(
                                      title: Text("Delete backup?"),
                                      message: Text("Are you sure you want to delete this backup?"),
                                      onConfirm: () {
                                        widget.onDelete?.call();
                                        Get.back();
                                      },
                                      onCanceled: () => Get.back(),
                                  ).showConfirmationDialog(context);
                                }, child: Text("Delete")),
                                TextButton(onPressed: () {
                                  widget.onDownload?.call();
                                }, child: Text("Download"))
                              ],
                            )
                          ],
                        )
                      ]
                  )
              );
            },
          );
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                        child: Icon(widget.backup.state.getIcon(), size: 32),
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.backup.id.toString()),
                            Text(widget.backup.parsedSize(2)),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(top: 4.0)),
                        Text(widget.backup.parsedDate(), style: const TextStyle(fontSize: 18),),
                        const Padding(padding: EdgeInsets.only(top: 8.0)),
                        widget.backup.state == BackupState.RUNNING ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("${(widget.backup.percentageComplete * 100).toStringAsFixed(2)}\u{202F}%"),
                          ],
                        ) : Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
            TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: widget.backup.state == BackupState.FINISHED || widget.backup.state == BackupState.ERROR ? 1.0 : widget.backup.percentageComplete.toDouble()),
                duration: const Duration(milliseconds: 250),
                builder: (context, value, _) => LinearProgressIndicator(value: value, color: widget.backup.state.getColor(), backgroundColor: widget.backup.state == BackupState.ERROR ? widget.backup.state.getColor() : null,))
          ],
        ),
      ),
    );
  }
}