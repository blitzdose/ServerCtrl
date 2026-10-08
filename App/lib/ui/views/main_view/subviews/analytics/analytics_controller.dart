import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/utilities/api/api.dart';
import 'package:server_ctrl/utilities/api/models/system_data.dart';

import '../subview_controller.dart';

class AnalyticsController extends SubviewController {
  final cpuUsageSpots = <FlSpot>[].obs;

  final memoryUsageSpots = <FlSpot>[].obs;

  final systemData = SystemData(0, 0, 0, 0, 0, 0, 0, 0, []).obs;
  List<SystemData> historicSystemData = [];

  AnalyticsController({required super.system, required super.userPermissions, required super.onSetActions, required super.onSetLeading, required super.onSetBottom});

  @override
  Future<void> updateData() async {
    SystemData? systemData = await SystemApi(system).getSystemData();
    if (systemData != null) {
      this.systemData(systemData);
    }

    List<SystemData>? historicSystemData = await SystemApi(system).getHistoricSystemData();
    if (historicSystemData != null) {
      this.historicSystemData.clear();
      this.historicSystemData.addAll(historicSystemData);
    }

    cpuUsageSpots.clear();
    memoryUsageSpots.clear();
    for (int i = 0; i<this.historicSystemData.length; i++) {
      SystemData dataPoint = this.historicSystemData[i];
      cpuUsageSpots.add(FlSpot(i*1.0, dataPoint.cpuLoadAsDouble()));
      memoryUsageSpots.add(FlSpot(i*1.0, (dataPoint.memoryUsageAsDouble())));
    }
  }
}