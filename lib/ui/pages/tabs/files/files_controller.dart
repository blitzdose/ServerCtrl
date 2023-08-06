import 'package:http/http.dart' as http;
import 'package:minecraft_server_remote/ui/pages/tabs/tab.dart';
import 'package:minecraft_server_remote/utilities/http/session.dart';

class FilesController extends TabxController {

  @override
  Future<http.Response> fetchData() {
    return Session.post("/api/files/list", "{\"path\": \"/\"}");
  }

  @override
  void updateData() {

  }

}