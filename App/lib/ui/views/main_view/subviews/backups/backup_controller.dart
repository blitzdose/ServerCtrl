import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/backups/backup_view.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/subview_controller.dart';
import 'package:server_ctrl/utilities/api/api.dart';
import 'package:server_ctrl/utilities/api/models/backup.dart';

import '../../../../../utilities.old/snackbar/snackbar.dart';

class BackupController extends SubviewController {
  final backups = <Backup>[].obs;
  final showProgress = false.obs;

  BackupController({required super.params});

  @override
  Future<void> updateData() async {

  }

  @override void onShown() {
    super.onShown();
    params.onSetFloatingActionButton(BackupView.generateFloatingActionButton(this));
  }

  @override
  void onInit() {
    super.onInit();
    asyncInit();
  }

  Future<void> asyncInit() async {
    showProgress(true);
    List<Backup>? backups = await BackupApi(params.system).listBackups();
    if (backups != null) {
      backups.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      this.backups(backups);
    } else {
      Snackbar.createWithTitle("Error", "Error while fetching backups", true);
    }
    showProgress(false);
  }

  Future<void> startFullBackup() async {
    bool success = await BackupApi(params.system).createFullBackup();
    if (success) {
      Snackbar.createWithTitle("Backup", "Started backup creation");
    } else {
      Snackbar.createWithTitle("Backup", "Full backup could not be created");
    }
  }

  Future<void> deleteBackup(Backup backup) async {
    var success = await BackupApi(params.system).deleteBackup(backup.filename);
    if (success) {
      Snackbar.createWithTitle("Backup", "Successfully deleted backup");
    } else {
      Snackbar.createWithTitle("Backup", "Error while deleting Backup", true);
    }
  }

  Future<void> downloadBackup(Backup backup) async {

  }

}