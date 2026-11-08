import 'package:getxify/getxify.dart';
import 'package:material_ui/material_ui.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/backups/backup_view.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/subview_controller.dart';
import 'package:server_ctrl/ui/widgets/download_save_dialog.dart';
import 'package:server_ctrl/utilities/api/api.dart';
import 'package:server_ctrl/utilities/api/models/backup.dart';
import 'package:server_ctrl/utilities/api/models/world.dart';
import 'package:server_ctrl/utilities/http/file.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';

class BackupController extends SubviewController {
  final backups = <Backup>[].obs;
  final worlds = <World>[].obs;
  final showProgress = false.obs;

  BackupController({required super.params});

  @override
  Future<void> updateData() async {
    await fetchData(showError: false);
  }

  @override void onShown() {
    super.onShown();
    params.onSetFloatingActionButton(BackupView.generateFloatingActionButton(this));
    params.onSetActions.call(
        [
          IconButton(
              onPressed: () {
                asyncInit();
              },
              icon: const Icon(Icons.refresh_rounded)
          )
        ]
    );
  }

  @override
  void onInit() {
    super.onInit();
    asyncInit();
  }

  Future<void> asyncInit() async {
    showProgress(true);
    await fetchData();
    showProgress(false);
  }

  Future<void> fetchData({bool showError = true}) async {
    List<Backup>? backups = await BackupApi(params.system).listBackups();
    List<World>? worlds = await BackupApi(params.system).listWorlds();
    if (backups != null) {
      backups.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      this.backups(backups);
    } else if (showError) {
      Snackbar.createWithTitle("Error", "Error while fetching backups", true);
    }
    this.worlds(worlds ?? []);
  }

  Future<void> startBackup(BackupConfig state) async {
    if (state.backupType == BackupType.FULL) {
      await startFullBackup();
      await asyncInit();
    } else if (state.backupType == BackupType.WORLD) {
      await startWorldsBackup(state.selectedWorlds);
      await asyncInit();
    }
  }

  Future<void> startFullBackup() async {
    showProgress(true);
    bool success = await BackupApi(params.system).createFullBackup();
    if (success) {
      Snackbar.createWithTitle("Backup", "Started backup creation");
    } else {
      Snackbar.createWithTitle("Backup", "Full backup could not be created");
    }
    showProgress(false);
  }

  Future<void> startWorldsBackup(Set<World> selectedWorlds) async {
    showProgress(true);
    bool success = await BackupApi(params.system).createWorldsBackup(selectedWorlds.map((world) => world.uuid,).toList());
    if (success) {
      Snackbar.createWithTitle("Backup", "Started backup creation");
    } else {
      Snackbar.createWithTitle("Backup", "World backup could not be created");
    }
    showProgress(false);
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
    showProgress(true);
    DownloadFile? downloadFile = await BackupApi(params.system).downloadBackup(backup.filename);
    if (downloadFile == null) {
      Snackbar.createWithTitle("Backup", "Error while trying to download file", true);
      return;
    }

    await DownloadSaveDialog.show(
      downloadFile: downloadFile,
      filename: backup.filename,
      onFailed: (status) => Snackbar.createWithTitle("Backup", "Error while trying to download file", true),
      onSuccess: (savedPath) => Snackbar.createWithTitle("Backup", "Successfully saved file"),
    );
  }
}