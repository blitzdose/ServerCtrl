import 'package:flutter/material.dart';

class InputDialog {

  InputDialog({
    required this.title,
    required this.textInputType,
    this.message,
    this.inputFieldText,
    this.inputFieldHintText,
    this.inputFieldBorder,
    this.leftButtonText,
    this.rightButtonText,
    this.onLeftButtonClick,
    this.onRightButtonClick
  });

  final String title;
  final TextInputType textInputType;
  final String? message;
  final String? inputFieldText;
  final String? inputFieldHintText;
  final InputBorder? inputFieldBorder;
  final String? leftButtonText;
  final String? rightButtonText;
  final Function(String text)? onLeftButtonClick;
  final Function(String text)? onRightButtonClick;

  showInputDialog(var context) {
    TextEditingController textController = TextEditingController();
    textController.text = inputFieldText ?? "";
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: Text(title),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (message != null) Text(message!),
                  if (message != null) const Padding(padding: EdgeInsets.only(top: 8)),
                  TextField(
                    decoration: InputDecoration(
                      border: inputFieldBorder,
                      hintText: inputFieldHintText
                    ),
                    maxLines: 1,
                    controller: textController,
                    keyboardType: textInputType,
                    autocorrect: false,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              if (leftButtonText != null) TextButton(onPressed: () {
                if (onLeftButtonClick != null) {
                  onLeftButtonClick!(textController.text);
                }
                Navigator.pop(context, true);
                }, child: Text(leftButtonText!)),
              if (rightButtonText != null) TextButton(onPressed: () {
                if (onRightButtonClick != null) {
                  onRightButtonClick!(textController.text);
                }
                Navigator.pop(context, true);
              }, child: Text(rightButtonText!)),
            ],
          ),
        );
      },
    );
  }
}