import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/files/files_controller.dart';
import 'package:server_ctrl/ui/widgets/animated_linear_progress_indicator.dart';
import 'package:server_ctrl/ui/widgets/middle_elipsis_text.dart';
import 'package:server_ctrl/utilities/dialogs/dialogs.dart';
import 'package:server_ctrl/utilities/api/models/server_file.dart';

import '../../../../../generated/l10n.dart';

class FilesView extends StatelessWidget {
  final controller = Get.find<FilesController>();
  final ScrollController scrollController = ScrollController();

  FilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (ModalRoute.of(context)?.isCurrent == true &&
                !Scaffold.of(context).isDrawerOpen) {
              if (controller.path == "/") {
                SystemNavigator.pop();
                return;
              }
              controller.navigateByIndex(controller.path, controller.path.split("/").length - 2);
            } else {
              navigator!.pop(context);
            }
          },
          child: Stack(
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
                            controller.multiSelectMode(false);
                            await controller.lazyLoader.refresh();
                          },
                          child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                    height: 0,
                                  ),
                              padding: EdgeInsets.zero,
                              itemCount: controller.files.length,
                              itemBuilder: (context, index) {
                                ServerFile file = controller.files.keys.elementAt(index);
                                return Obx(
                                  () => FilesRow(
                                    file: file,
                                    checked: controller.files[file] ?? false,
                                    onChanged: (value) {
                                      controller.files[file] = value;
                                    },
                                    onLongPressed: () {
                                      controller.multiSelectMode(true);
                                      controller.params.onSetLeading(IconButton(
                                          onPressed: () {
                                            controller.files.updateAll((key, value) => false);
                                            controller.multiSelectMode(false);
                                            controller.onShown();
                                          },
                                          icon: Icon(Icons.close_rounded)));
                                      controller.params.onSetActions([
                                        IconButton(
                                            onPressed: () async {
                                              controller.downloadMultipleFile(controller.files.entries.where((e) => e.value).map((e) => e.key).toList());

                                              controller.files.updateAll((key, value) => false);
                                              controller.multiSelectMode(false);
                                              controller.onShown();
                                            },
                                            icon: const Icon(Icons.download_rounded)),
                                        IconButton(
                                            onPressed: () async {
                                              ConfirmationDialog(
                                                title: Text("Delete files"),
                                                message: MarkdownBody(data: "Are you sure you want to delete the selected files?"),
                                                onConfirm: () {
                                                  controller.deleteMultipleFile(controller.files.entries.where((e) => e.value).map((e) => e.key).toList());

                                                  controller.files.updateAll((key, value) => false);
                                                  controller.multiSelectMode(false);
                                                  controller.onShown();
                                                  Get.back();
                                                },
                                                onCanceled: () {
                                                  Get.back();
                                                },
                                              ).showConfirmationDialog(context);
                                            },
                                            icon: const Icon(
                                                Icons.delete_rounded)),
                                        IconButton(
                                            onPressed: () {
                                              bool containsUnselectedElements = controller.files.values.contains(false);
                                              controller.files.updateAll((key, value) => containsUnselectedElements);
                                            },
                                            icon: const Icon(
                                                Icons.select_all_rounded))
                                      ]);
                                    },
                                    multiSelectMode:
                                        controller.multiSelectMode.value,
                                    onTap: (file) {
                                      controller.navigate(file.name);
                                    },
                                    popupMenuItems: [
                                      if (file.isFile && controller.editableFiles.contains(file.name.split(".").last))
                                        PopupMenuItem<int>(
                                          child: Text(S.current.edit),
                                          onTap: () {
                                            controller.editSingleFile(file);
                                          },
                                        ),
                                      if (file.isFile && controller.extractableFiles.contains(file.name.split(".").last))
                                        PopupMenuItem<int>(
                                          child: Text(S.current.extract),
                                          onTap: () {
                                            controller.extractSingleFile(file);
                                          },
                                        ),
                                      PopupMenuItem<int>(
                                        child: Text(S.current.download),
                                        onTap: () {
                                          if (file.isFile) {
                                            controller.downloadSingleFile(file);
                                          } else {
                                            controller.downloadMultipleFile([file]);
                                          }
                                        },
                                      ),
                                      PopupMenuItem<int>(
                                        child: Text(S.current.rename),
                                        onTap: () {
                                          InputDialog(
                                            title: S.current.rename,
                                            textInputType: TextInputType.name,
                                            inputFieldLabelText: "New name",
                                            barrierDismissible: true,
                                            inputFieldText: file.name,
                                            inputFieldBorder: OutlineInputBorder(),
                                            leftButtonText: "Cancel",
                                            rightButtonText: "Save",
                                            highlightOffset: (0, file.name.lastIndexOf(".")),
                                            onRightButtonClick: (text) {
                                              controller.renameFile(file, text);
                                              Get.back();
                                            },
                                          ).showInputDialog(context);
                                        },
                                      ),
                                      PopupMenuItem<int>(
                                        child: Text(S.current.delete),
                                        onTap: () {
                                          ConfirmationDialog(
                                            title: Text("Delete ${file.isFile ? "file" : "folder"}"),
                                            message: MarkdownBody(data: "Are you sure you want to delete **${file.name}**?"),
                                            onConfirm: () {
                                              controller.deleteSingleFile(file);
                                              Get.back();
                                            },
                                            onCanceled: () {
                                              Get.back();
                                            },
                                          ).showConfirmationDialog(context);
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ))),
              ),
              if (controller.showProgress.value) const LinearProgressIndicator()
            ],
          ),
        ));
  }

  static PreferredSizeWidget generateBreadcrumb(
      FilesController controller, String path) {
    var pathParts = path.split("/");
    pathParts.removeWhere((element) => element.isEmpty);
    pathParts.insert(0, "/");

    return PreferredSize(
        preferredSize: Size(double.infinity, 24),
        child: Align(
          alignment: Alignment.centerLeft,
          child: BreadCrumb(
            items: pathParts.asMap().entries.map((entry) {
              int idx = entry.key;
              String name = entry.value;

              return BreadCrumbItem(
                  content: Text(
                    name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: idx == pathParts.length - 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: idx == pathParts.length - 1
                            ? null
                            : Theme.of(navigator!.context)
                                .textTheme
                                .bodyMedium!
                                .color!
                                .withValues(alpha: 0.75)),
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: idx == 0
                      ? EdgeInsetsGeometry.only(left: 65)
                      : EdgeInsets.zero,
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    controller.navigateByIndex(path, idx);
                  });
            }).toList(),
            divider: Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 16,
            ),
            overflow: ScrollableOverflow(
                keepLastDivider: false,
                reverse: true,
                direction: Axis.horizontal),
          ),
        ));
  }

  static Widget generateSaveFileDialog(String filename, Rxn<double> progress, Rx<bool> enableSaveButton, {required Function() onCancel, required Function() onSave}) {
    return Obx(() => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Downloading File"),
      content: PopScope(
        canPop: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              filename, // Display the actual filename
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            AnimatedLinearProgressIndicator(
              value: progress.value,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("${((progress.value ?? 0) * 100).toStringAsFixed(0)}%",)
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onCancel();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: enableSaveButton.value ? () async {
            onSave();
          } : null,
          child: const Text("Save"),
        ),
      ],
    ));
  }

  static Widget generateEditFileDownloadDialog(String filename, Rxn<double> progress, {required Function() onCancel}) {
    return Obx(() => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Downloading File"),
      content: PopScope(
        canPop: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              filename, // Display the actual filename
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            AnimatedLinearProgressIndicator(
              value: progress.value,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("${((progress.value ?? 0) * 100).toStringAsFixed(0)}%",)
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onCancel();
          },
          child: const Text("Cancel"),
        )
      ],
    ));
  }

  static Widget generateUploadFileDialog(String filename, RxBool finished, RxInt uploadedSize, RxInt totalSize, var cancelToken) {
    return AlertDialog(
      title: Text(filename),
      content: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: finished.isFalse ? <Widget>[
          LinearProgressIndicator(
            value: (uploadedSize.value == 0 || uploadedSize.value == totalSize.value) ? null : uploadedSize.value / totalSize.value,
          ),
          const Padding(padding: EdgeInsets.only(top: 4.0)),
          Text("${(uploadedSize.value / totalSize.value * 100).toInt()}%", textAlign: TextAlign.end)
        ] : [
          Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(uploadedSize == totalSize ? "File uploaded successfully" : "Upload canceled")
              ]
          )
        ],
      )),
      actions: [
        Obx(() =>
        finished.isTrue ? TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Ok"))
            : TextButton(
          onPressed: () {
            cancelToken.cancel();
          },
          child: Text("Cancel"),
        ))],
    );
  }

  static ExpandableFab generateFloatingActionButton(FilesController filesController) {
    final key = GlobalKey<ExpandableFabState>();
    return ExpandableFab(
      key: key,
      type: ExpandableFabType.up,
      childrenAnimation: ExpandableFabAnimation.none,
      distance: 60,
      duration: Duration(milliseconds: 150),
      overlayStyle: ExpandableFabOverlayStyle(
        color: Get.theme.colorScheme.surface.withValues(alpha: 0.8)
      ),
      openButtonBuilder: DefaultFloatingActionButtonBuilder(
          child: const Icon(Icons.add_rounded)
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        fabSize: ExpandableFabSize.small,
        child: const Icon(Icons.close),
        backgroundColor: Get.theme.colorScheme.onPrimaryContainer,
        foregroundColor: Get.theme.colorScheme.primaryContainer,
      ),
      children: [
        Row(
          children: [
            const Text('Folder'),
            const SizedBox(width: 20),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: () async {
                final state = key.currentState;
                if (state != null) {
                  state.toggle();
                  await Future.delayed(const Duration(milliseconds: 200));
                }
                InputDialog(
                  title: "New folder",
                  inputFieldLabelText: "Name",
                  textInputType: TextInputType.text,
                  barrierDismissible: false,
                  inputFieldBorder: OutlineInputBorder(),
                  leftButtonText: "Cancel",
                  rightButtonText: "Create",
                  onLeftButtonClick: (text) => Get.back(),
                  rightButtonDisableEmpty: true,
                  onRightButtonClick: (name) {
                    Get.back();
                    filesController.createNewFile(name, true);
                  },
                ).showInputDialog(Get.context);
              },
              child: const Icon(Icons.folder_rounded),
            ),
          ],
        ),
        Row(
          children: [
            const Text('File'),
            const SizedBox(width: 20),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: () async {
                final state = key.currentState;
                if (state != null) {
                  state.toggle();
                  await Future.delayed(const Duration(milliseconds: 200));
                }
                InputDialog(
                  title: "New file",
                  inputFieldLabelText: "Name",
                  textInputType: TextInputType.text,
                  barrierDismissible: false,
                  inputFieldBorder: OutlineInputBorder(),
                  leftButtonText: "Cancel",
                  rightButtonText: "Create",
                  onLeftButtonClick: (text) => Get.back(),
                  rightButtonDisableEmpty: true,
                  onRightButtonClick: (name) {
                    Get.back();
                    filesController.createNewFile(name, false);
                  },
                ).showInputDialog(Get.context);
              },
              child: const Icon(Icons.description_rounded),
            ),
          ],
        ),
        Row(
          children: [
            const Text('Upload'),
            const SizedBox(width: 20),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: () async {
                final state = key.currentState;
                if (state != null) {
                  state.toggle();
                  await Future.delayed(const Duration(milliseconds: 200));
                }
                filesController.uploadFiles();
              },
              child: const Icon(Icons.upload_rounded),
            ),
          ],
        ),
      ],
    );
  }
}

class FilesRow extends StatefulWidget {
  final ServerFile file;
  final bool checked;
  final ValueChanged<bool> onChanged;
  final Function() onLongPressed;
  final bool multiSelectMode;
  final List<PopupMenuItem<int>> popupMenuItems;

  final Function(ServerFile file) onTap;

  const FilesRow({
    super.key,
    required this.file,
    required this.checked,
    required this.onChanged,
    required this.onLongPressed,
    required this.multiSelectMode,
    required this.onTap,
    required this.popupMenuItems,
  });

  @override
  State<StatefulWidget> createState() => _FilesRowState();
}

class _FilesRowState extends State<FilesRow> {
  GlobalKey keyEntry = GlobalKey();
  GlobalKey keyMenu = GlobalKey();

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.folder_rounded;
    if (widget.file.isFile) {
      icon = Icons.description_rounded;
    }
    return SizedBox(
      height: 58,
      child: InkWell(
        key: keyEntry,
        onTap: () {
          if (widget.multiSelectMode) {
            widget.onChanged(!widget.checked);
            return;
          }

          RenderBox box =
              keyEntry.currentContext?.findRenderObject() as RenderBox;
          Offset position = box.localToGlobal(Offset.zero);
          double y = position.dy + 5;
          double x = MediaQuery.of(keyEntry.currentContext!).size.width;

          if (widget.file.name == ".." || !widget.file.isFile) {
            widget.onTap(widget.file);
            return;
          }
          showPopupMenu(context, x, y);
        },
        onLongPress: () {
          widget.onChanged(!widget.checked);
          widget.onLongPressed();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon),
              const Padding(padding: EdgeInsets.only(right: 16)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MiddleEllipsisText(
                              widget.file.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Opacity(
                            opacity: 0.75,
                            child: Text("${DateFormat('dd. MMM. yyyy').format(widget.file.parsedDateTime())}\t\t\t${widget.file.parsedSize()}", style: const TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                    !widget.multiSelectMode
                        ? !widget.file.isFile
                            ? IconButton(
                                key: keyMenu,
                                onPressed: () {
                                  RenderBox box = keyEntry.currentContext?.findRenderObject() as RenderBox;
                                  Offset position = box.localToGlobal(Offset.zero);
                                  double y = position.dy + 5;
                                  double x = MediaQuery.of(keyEntry.currentContext!).size.width;

                                  showPopupMenu(context, x, y);
                                },
                                icon: const Icon(Icons.more_vert_rounded))
                            : Container()
                        : Checkbox(
                            value: widget.checked,
                            onChanged: (value) {
                              widget.onChanged(value ?? false);
                            },
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showPopupMenu(BuildContext context, double x, double y) async {
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(x, y, 0, 0),
        items: widget.popupMenuItems,
        elevation: 8);
  }
}

