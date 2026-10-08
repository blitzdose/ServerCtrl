import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/analytics/analytics_controller.dart';
import 'package:server_ctrl/utilities/api/models/system_data.dart';

import '../../../../../generated/l10n.dart';

class AnalyticsView extends StatelessWidget {
  final controller = Get.find<AnalyticsController>();

  AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Obx(() => SizedBox(
                      height: 230,
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 0,
                              color: context.isDarkMode ? Theme.of(context).colorScheme.surfaceContainerLow : Theme.of(context).colorScheme.surfaceContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(S.current.cpu_usage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                          Expanded(
                                            child: LineChart(
                                              LineChartData(
                                                lineTouchData: const LineTouchData(enabled: false),
                                                lineBarsData: [
                                                  LineChartBarData(
                                                    show: controller.memoryUsageSpots.isNotEmpty,
                                                    color: Theme.of(context).colorScheme.primary,
                                                    spots: controller.cpuUsageSpots,
                                                    isCurved: true,
                                                    isStrokeCapRound: true,
                                                    barWidth: 3,
                                                    belowBarData: BarAreaData(
                                                      show: true,
                                                      color: Theme.of(context).colorScheme.primary.withAlpha(50),
                                                    ),
                                                    dotData: const FlDotData(show: false),
                                                  ),
                                                ],
                                                minY: 0,
                                                maxY: 100,
                                                titlesData: const FlTitlesData(
                                                    show: false
                                                ),
                                                gridData: FlGridData(
                                                  show: true,
                                                  drawHorizontalLine: true,
                                                  drawVerticalLine: true,
                                                  horizontalInterval: 10,
                                                  verticalInterval: 1,
                                                  getDrawingHorizontalLine: (_) => FlLine(
                                                    color: Theme.of(context).colorScheme.onSecondary,
                                                    dashArray: [8, 2],
                                                    strokeWidth: 0.8,
                                                  ),
                                                  getDrawingVerticalLine: (_) => FlLine(
                                                    color: Theme.of(context).colorScheme.onSecondary,
                                                    dashArray: [8, 2],
                                                    strokeWidth: 0.8,
                                                  ),
                                                ),
                                                borderData: FlBorderData(show: false),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text("${controller.systemData.value.cpuLoadAsDouble().toStringAsFixed(2)}%", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(S.current.memory_usage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                          Expanded(
                                            child: LineChart(
                                              LineChartData(
                                                lineTouchData: const LineTouchData(enabled: false),
                                                lineBarsData: [
                                                  LineChartBarData(
                                                    show: controller.memoryUsageSpots.isNotEmpty,
                                                    color: Theme.of(context).colorScheme.primary,
                                                    spots: controller.memoryUsageSpots,
                                                    isCurved: true,
                                                    isStrokeCapRound: true,
                                                    barWidth: 3,
                                                    belowBarData: BarAreaData(
                                                      show: true,
                                                      color: Theme.of(context).colorScheme.primary.withAlpha(50),
                                                    ),
                                                    dotData: const FlDotData(show: false),
                                                  ),
                                                ],
                                                minY: 0,
                                                maxY: 100,
                                                titlesData: const FlTitlesData(
                                                    show: false
                                                ),
                                                gridData: FlGridData(
                                                  show: true,
                                                  drawHorizontalLine: true,
                                                  drawVerticalLine: true,
                                                  horizontalInterval: 10,
                                                  verticalInterval: 1,
                                                  getDrawingHorizontalLine: (_) => FlLine(
                                                    color: Theme.of(context).colorScheme.onSecondary,
                                                    dashArray: [8, 2],
                                                    strokeWidth: 0.8,
                                                  ),
                                                  getDrawingVerticalLine: (_) => FlLine(
                                                    color: Theme.of(context).colorScheme.onSecondary,
                                                    dashArray: [8, 2],
                                                    strokeWidth: 0.8,
                                                  ),
                                                ),
                                                borderData: FlBorderData(show: false),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text("${controller.systemData.value.memoryUsageAsDouble().toStringAsFixed(2)}%", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                    Obx(() => Card(
                      color: context.isDarkMode ? Theme.of(context).colorScheme.surfaceContainerLow : Theme.of(context).colorScheme.surfaceContainer,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                        child: Wrap(
                          direction: Axis.horizontal,
                          runSpacing: 16.0,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Wrap(
                                direction: Axis.horizontal,
                                runSpacing: 16.0,
                                children: [
                                  for (FileSystemSpace fileSystemSpace in controller.systemData.value.fileSystemSpaces)
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(S.current.diskUsage(fileSystemSpace.name), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                                            Text("${(100 - ((fileSystemSpace.usableSpace / fileSystemSpace.totalSpace) * 100)).toStringAsFixed(2)}%", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TweenAnimationBuilder<double>(
                                                duration: const Duration(milliseconds: 200),
                                                curve: Curves.easeInOut,
                                                tween: Tween<double>(
                                                    begin: 0,
                                                    end: (1.0 - (fileSystemSpace.usableSpace / fileSystemSpace.totalSpace))
                                                ),
                                                builder: (context, value, _) => LinearProgressIndicator(
                                                  value: value,
                                                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                  minHeight: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ),
                    Obx(() => Card(
                      color: context.isDarkMode ? Theme.of(context).colorScheme.surfaceContainerLow : Theme.of(context).colorScheme.surfaceContainer,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const Divider(),
                          padding: EdgeInsets.zero,
                          itemCount: 5 + controller.systemData.value.fileSystemSpaces.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              SizedBox(
                                height: 24,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Obx(() {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: getSystemParametersListItem(index),
                                    );
                                  }),
                                ),
                              ),
                        ),
                      ),
                    ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> getSystemParametersListItem(int index) {
    List data = [
      [S.current.cpu_cores, "${controller.systemData.value.cpuCores}"],
      [S.current.allocated_memory, "${controller.systemData.value.memMax} MB"],
      [S.current.used_memory, "${controller.systemData.value.memUsed} MB"],
      [S.current.total_system_memory, "${controller.systemData.value.totalSystemMem} MB"],
      [S.current.free_memory, "${controller.systemData.value.freeSystemMem} MB"],
    ];

    for (FileSystemSpace fileSystemSpace in controller.systemData.value.fileSystemSpaces) {
      data.add([S.current.availableDiskSpace(fileSystemSpace.name), getFileSizeString(bytes: fileSystemSpace.usableSpace)]);
    }

    return <Widget>[
      Text(data[index][0], style: const TextStyle(fontSize: 18),),
      Text(data[index][1], style: const TextStyle(fontSize: 18),)
    ];
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = [" B", " KB", " MB", " GB", " TB"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }
}