import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../generated/l10n.dart';
import 'home_controller.dart';

class HomeTab extends StatelessWidget {
  final controller = Get.put(HomeController());

  HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: Obx(() {
                              return SfRadialGauge(
                                enableLoadingAnimation: true,
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 100,
                                    startAngle: 150,
                                    endAngle: 30,
                                    showAxisLine: true,
                                    showTicks: false,
                                    showLabels: false,
                                    axisLineStyle: const AxisLineStyle(
                                        thickness: 8,
                                        cornerStyle: CornerStyle.bothCurve
                                    ),
                                    ranges: [
                                      GaugeRange(
                                        startValue: 0,
                                        endValue: 100,
                                        color: Colors.transparent,
                                      )
                                    ],
                                    annotations: [
                                      GaugeAnnotation(
                                        widget: Text(
                                            "${controller.cpuUsage.value}%",
                                            style: const TextStyle(
                                              fontSize: 24,)),
                                        angle: 90,
                                        positionFactor: 0,
                                      )
                                    ],
                                    pointers: [
                                      RangePointer(
                                        value: controller.cpuUsage.value < 5 ? 5 : controller.cpuUsage.value,
                                        cornerStyle: CornerStyle.bothCurve,
                                        enableAnimation: true,
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .primary,
                                        width: 8,
                                      )
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: Obx(() {
                              return SfRadialGauge(
                                enableLoadingAnimation: true,
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 100,
                                    startAngle: 150,
                                    endAngle: 30,
                                    showAxisLine: true,
                                    showTicks: false,
                                    showLabels: false,
                                    axisLineStyle: const AxisLineStyle(
                                        cornerStyle: CornerStyle.bothCurve,
                                        thickness: 8
                                    ),
                                    ranges: [
                                      GaugeRange(
                                        startValue: 0,
                                        endValue: 100,
                                        color: Colors.transparent,
                                      )
                                    ],
                                    annotations: [
                                      GaugeAnnotation(
                                        widget: Text(
                                            "${controller.memoryUsage.value.toStringAsFixed(2)}%",
                                            style: const TextStyle(
                                              fontSize: 24,)),
                                        angle: 90,
                                        positionFactor: 0,
                                      )
                                    ],
                                    pointers: [
                                      RangePointer(
                                        value: controller.memoryUsage.value < 5 ? 5 : controller.memoryUsage.value,
                                        cornerStyle: CornerStyle.bothCurve,
                                        enableAnimation: true,
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .primary,
                                        width: 8,
                                      )
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 140, 0, 0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 13, 0),
                              child: Text(
                                S.current.cpu_usage,
                                textAlign: TextAlign.center,
                              ),
                            )),
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(21, 0, 0, 0),
                              child: Text(
                                S.current.memory_usage,
                                textAlign: TextAlign.center,
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            padding: EdgeInsets.zero,
            itemCount: 7,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                SizedBox(
                  height: 48,
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
      ],
    );
  }

  getSystemParametersListItem(int index) {
    List data = [
      [S.current.cpu_cores, "${controller.cpuCores.value}"],
      [S.current.cpu_load, "${controller.cpuLoad.value}%"],
      [S.current.usable_memory, "${controller.usableMemory.value} MB"],
      [S.current.allocated_memory, "${controller.allocatedMemory.value} MB"],
      [S.current.used_memory, "${controller.usedMemory.value} MB"],
      [
        S.current.total_system_memory,
        "${controller.totalSystemMemory.value} MB"
      ],
      [S.current.free_memory, "${controller.freeMemory.value} MB"],
    ];

    return <Widget>[
      Text(data[index][0], style: const TextStyle(fontSize: 18),),
      Text(data[index][1], style: const TextStyle(fontSize: 18),)
    ];
  }
}
