import 'package:getxify/rx/src/rx_types/extensions/iterable_extensions.dart';
import 'package:getxify/rx/src/rx_types/extensions/primitive_extensions.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/backups/backup_view.dart';
import 'package:server_ctrl/ui/views/main_view/subviews/subview_controller.dart';
import 'package:server_ctrl/utilities/api/api.dart';
import 'package:server_ctrl/utilities/api/models/backup.dart';
import 'package:server_ctrl/utilities/api/models/world.dart';
import 'package:server_ctrl/utilities/snackbar/snackbar.dart';

class BackupController extends SubviewController {
  final backups = <Backup>[].obs;
  final worlds = <World>[].obs;
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
    List<World>? worlds = await BackupApi(params.system).listWorlds();
    if (backups != null) {
      backups.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      this.backups(backups);
    } else {
      Snackbar.createWithTitle("Error", "Error while fetching backups", true);
    }
    this.worlds(worlds ?? []);
    showProgress(false);
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

  Future<void> startWorldsBackup() async {

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