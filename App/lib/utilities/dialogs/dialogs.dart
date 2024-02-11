import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputDialog {

  InputDialog({
    required this.title,
    required this.textInputType,
    this.message,
    this.inputFieldText,
    this.inputFieldHintText,
    this.inputFieldBorder,
    this.inputFieldLength,
    this.inputFieldError,
    this.leftButtonText,
    this.rightButtonText,
    this.onLeftButtonClick,
    this.onRightButtonClick,
    this.rightButtonDisableEmpty = false
  });

  final String title;
  final TextInputType textInputType;
  final String? message;
  final String? inputFieldText;
  final String? inputFieldHintText;
  final InputBorder? inputFieldBorder;
  final int? inputFieldLength;
  final String? inputFieldError;
  final String? leftButtonText;
  final String? rightButtonText;
  final Function(String text)? onLeftButtonClick;
  final Function(String text)? onRightButtonClick;

  final bool? rightButtonDisableEmpty;

  showInputDialog(var context) {
    final textController = TextEditingController().obs;
    textController.value.text = inputFieldText ?? "";
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
              width: min(500, MediaQuery.of(context).size.width),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (message != null) Text(message!),
                  if (message != null) const Padding(padding: EdgeInsets.only(top: 8)),
                  TextField(
                    decoration: InputDecoration(
                      border: inputFieldBorder,
                      hintText: inputFieldHintText,
                      errorText: inputFieldError
                    ),
                    maxLines: 1,
                    maxLength: inputFieldLength,
                    controller: textController.value,
                    onChanged: (value) => textController.refresh(),
                    keyboardType: textInputType,
                    obscureText: textInputType == TextInputType.visiblePassword,
                    enableSuggestions: textInputType != TextInputType.visiblePassword,
                    autocorrect: false,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              if (leftButtonText != null) TextButton(onPressed: () {
                if (onLeftButtonClick != null) {
                  onLeftButtonClick!(textController.value.text);
                }
                Navigator.pop(context, true);
                }, child: Text(leftButtonText!)),
              if (rightButtonText != null) Obx(() => TextButton(onPressed: textController.value.text.isNotEmpty || !rightButtonDisableEmpty! ? () {
                if (onRightButtonClick != null) {
                  onRightButtonClick!(textController.value.text);
                }
                Navigator.pop(context, true);
              } : null, child: Text(rightButtonText!)),)
            ],
          ),
        );
      },
    );
  }
}