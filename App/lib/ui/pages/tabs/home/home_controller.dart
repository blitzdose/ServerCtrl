import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:server_ctrl/utilities/http/http_utils.dart';

import '../../../../utilities/http/session.dart';
import '../../../navigation/layout_structure.dart';
import '../tab.dart';

class HomeController extends TabxController {
  final cpuUsage = 0.0.obs;
  final cpuUsageSpots = <FlSpot>[].obs;

  final memoryUsage = 0.0.obs;
  final memoryUsageSpots = <FlSpot>[].obs;

  final cpuCores = 0.obs;
  final cpuLoad = 0.0.obs;
  final usableMemory = 0.obs;
  final allocatedMemory = 0.obs;
  final usedMemory = 0.obs;
  final totalSystemMemory = 0.obs;
  final freeMemory = 0.obs;
  final RxMap<String, dynamic> fileSystemSpaces = RxMap<String, dynamic>();

  HomeController() {
    //updateData();
    LayoutStructureState.controller.actions.clear();
  }

  @override
  void updateData() async {
    http.Response response = await fetchData();
    http.Response responseHistoricData = await fetchHistoricData();
    if (!HttpUtils.isSuccess(response) || !HttpUtils.isSuccess(responseHistoricData)) {
      return;
    }

    var data = jsonDecode(response.body);

    cpuUsage(data['cpuLoad'] / 100);
    memoryUsage((data['totalSystemMem'] - data['freeSystemMem']) * 100.0 / data['totalSystemMem']);

    cpuCores(data['cpuCores']);
    cpuLoad(data['cpuLoad'] / 100);
    usableMemory(data['memMax']);
    allocatedMemory(data['memTotal']);
    usedMemory(data['memUsed']);
    totalSystemMemory(data['totalSystemMem']);
    freeMemory(data['freeSystemMem']);

    SplayTreeMap<String, dynamic> fileSystems = SplayTreeMap<String, dynamic>();
    fileSystems.addAll(data['fileSystemSpaces']);
    fileSystemSpaces.clear();
    fileSystemSpaces.addAll(fileSystems);

    cpuUsageSpots.clear();
    memoryUsageSpots.clear();
    var historicData = jsonDecode(responseHistoricData.body)['data'];
    for (int i = 0; i<historicData.length; i++) {
      var dataPoint = historicData[i];
      cpuUsageSpots.add(FlSpot(i*1.0, dataPoint['cpuLoad'] / 100));
      memoryUsageSpots.add(FlSpot(i*1.0, (data['totalSystemMem'] - data['freeSystemMem']) * 100.0 / data['totalSystemMem']));
    }
  }

  @override
  Future<http.Response> fetchData() async {
    return await Session.get("/api/system/data");
  }

  Future<http.Response> fetchHistoricData() async {
    return await Session.get("/api/system/historicData");
  }

}