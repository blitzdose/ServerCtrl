import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../utilities/http/session.dart';

class HomeController extends GetxController {
  final cpuUsage = 0.0.obs;
  final memoryUsage = 0.0.obs;

  final cpuCores = 0.obs;
  final cpuLoad = 0.0.obs;
  final usableMemory = 0.obs;
  final allocatedMemory = 0.obs;
  final usedMemory = 0.obs;
  final totalSystemMemory = 0.obs;
  final freeMemory = 0.obs;

  static Timer? timer;

  HomeController() {
    updateData();
    continueTimer();
  }

  void updateData() async {
    http.Response response = await fetchData();
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
  }

  Future<http.Response> fetchData() async {
    return await Session.get("/api/system/data");
  }

  void cancelTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  void continueTimer() {
    if (timer == null || !timer!.isActive) {
      updateData();
      timer = Timer.periodic(const Duration(seconds: 5), (timer) => updateData());
    }
  }

}