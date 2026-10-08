import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_ctrl/generated/l10n.dart';

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
    this.rightButtonDisableEmpty = false,
    this.barrierDismissible = false,
    this.highlightOffset
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
  final bool barrierDismissible;
  final (int, int)? highlightOffset;

  final bool? rightButtonDisableEmpty;

  showInputDialog(var context) {
    final textController = TextEditingController(text: inputFieldText ?? "").obs;
    if (highlightOffset != null) {
      textController.value.selection = TextSelection(
          baseOffset: highlightOffset!.$1,
          extentOffset: highlightOffset!.$2
      );
    }
    Get.dialog(
      barrierDismissible: barrierDismissible,
      AlertDialog(
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
                autofocus: true,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          if (leftButtonText != null) TextButton(onPressed: () {
            if (onLeftButtonClick != null) {
              onLeftButtonClick!(textController.value.text);
            } else {
              Navigator.pop(context, true);
            }
          }, child: Text(leftButtonText!)),
          if (rightButtonText != null) Obx(() => TextButton(onPressed: textController.value.text.isNotEmpty || !rightButtonDisableEmpty! ? () {
            if (onRightButtonClick != null) {
              onRightButtonClick!(textController.value.text);
            } else {
              Navigator.pop(context, true);
            }
          } : null, child: Text(rightButtonText!)),)
        ],
      )
    );
  }
}

class ConfirmationDialog {

  final Widget title;
  final Widget message;
  String? confirmButtonText;
  String? dismissButtonText;
  final Function() onConfirm;
  final Function() onCanceled;

  ConfirmationDialog({
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCanceled,
    this.confirmButtonText,
    this.dismissButtonText,
  }) {
    confirmButtonText ??= S.current.yes;
    dismissButtonText ??= S.current.cancel;
  }

  showConfirmationDialog(var context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
      return Padding(
          padding: const EdgeInsets.all(32),
          child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              title: title,
              content: SizedBox(
                width: min(500, MediaQuery
                    .of(context)
                    .size
                    .width),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    message,
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () => onCanceled(),
                        child: Text(dismissButtonText!)),
                    TextButton(onPressed: () => onConfirm(),
                        child: Text(confirmButtonText!)),
                  ],
                )
              ]
          )
      );
    });
  }
}