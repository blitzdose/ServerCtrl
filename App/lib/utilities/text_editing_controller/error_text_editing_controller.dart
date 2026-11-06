import 'package:material_ui/material_ui.dart';
import 'package:getxify/getxify.dart';

class ErrorTextEditingController extends TextEditingController {
  var errorMessage = Rxn<String>();

  ErrorTextEditingController() {
    addListener(() {
      errorMessage.value = null;
    },);
  }
}