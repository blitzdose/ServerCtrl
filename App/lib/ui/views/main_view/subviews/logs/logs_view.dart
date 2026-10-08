import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utilities/api/models/log_entry.dart';
import '../../../../../values/colors.dart';
import 'logs_controller.dart';

class LogsView extends StatelessWidget {

  final controller = Get.find<LogsController>();
  final ScrollController scrollController = ScrollController();

  LogsView({super.key});

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
                        child: ListView.separated(
                            separatorBuilder: (context, index) => const Divider(height: 0,),
                            padding: EdgeInsets.zero,
                            itemCount: controller.logs.length,
                            itemBuilder: (context, index) => LogRow(logEntry: controller.logs[index],)
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

class LogRow extends StatelessWidget {

  final LogEntry logEntry;
  const LogRow({super.key, required this.logEntry});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    switch(logEntry.type) {
      case LogEntryType.LOGIN_SUCCESS:
        textColor = MColors.logSuccess;
        break;
      case LogEntryType.LOGIN_FAIL:
        textColor = MColors.logDanger;
        break;
      case LogEntryType.DOWNLOADED_FILES:
      case LogEntryType.UPLOADED_FILES:
        textColor = MColors.logInfo;
        break;
      default:
        textColor = MColors.logWarn;
        break;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(logEntry.line, style: TextStyle(color: textColor)),
    );
  }

}