import 'dart:math';

import 'package:code_forge/code_forge/code_area.dart';
import 'package:code_forge/code_forge/controller.dart';
import 'package:code_forge/code_forge/find_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re_highlight/re_highlight.dart';
import 'package:flutter_highlight/themes/tomorrow-night.dart';

import '../../utilities/api/models/server_file.dart';

class CodeEditor extends StatelessWidget {

  final ServerFile file;
  final String code;
  final Function()? onExit;
  final Future<bool> Function(String editedCode)? onSave;

  final Rx<Icon> searchIcon = const Icon(Icons.search_rounded).obs;
  late final Rx<Widget> appBarTitle = (Text(file.name) as Widget).obs;
  final TextEditingController searchController = TextEditingController();
  final RxBool caseSensitive = false.obs;
  final RxBool regexSearch = false.obs;
  final RxBool showSaveProgress = false.obs;
  final CodeForgeController codeController = CodeForgeController();
  late final FindController findController = FindController(codeController);

  CodeEditor({super.key, required this.file, required this.code, this.onExit, this.onSave}) {
    codeController.text = code;

    searchController.addListener(() {
      updateFindController();
    });
    caseSensitive.listen((_) {
      updateFindController();
    },);
    regexSearch.listen((_) {
      updateFindController();
    },);
  }

  void updateFindController() {
    findController.caseSensitive = caseSensitive.value;
    findController.isRegex = regexSearch.value;
    findController.find(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    String originalFile = code;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (originalFile == codeController.text) {
          onExit?.call();
          return;
        }

        final shouldDiscard = await Get.dialog<bool>(
            AlertDialog(
              title: Text("Discard changes?"),
              content: Text("All your changes will be lost"),
              actions: <Widget>[
                TextButton(onPressed: () {
                  Get.back(result: false);
                }, child: Text("No")),
                TextButton(onPressed: () {
                  Get.back(result: true);
                }, child: Text("Discard")),
              ],
            ),
            barrierDismissible: true
        );
        if (shouldDiscard == true) {
          onExit?.call();
        }
      },
      child: Obx(() => Scaffold(
          appBar: AppBar(
            title: appBarTitle.value,
            leading: IconButton(
              onPressed: () async {
                if (Get.isSnackbarOpen) {
                  await Get.closeCurrentSnackbar();
                }

                Navigator.maybePop(Get.context!);
              },
              icon: const Icon(Icons.close),
            ),
            actions: [
              IconButton(
                icon: Obx(() => searchIcon.value),
                onPressed: () {
                  updateSearchBar(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.save_rounded),
                onPressed: () async {
                  showSaveProgress(true);
                  if (await onSave?.call(codeController.text) == true) {
                    originalFile = codeController.text;
                  }
                  showSaveProgress(false);
                },
              )
            ],
          ),
          body: Stack(
            children: [
              CodeForge(
                language: Highlight().getLanguage(file.name.split(".").last),
                editorTheme: tomorrowNightTheme,
                controller: codeController,
                findController: findController,
              ),
              if (showSaveProgress.value) LinearProgressIndicator(),
            ],)
      ),
      ),
    );
  }

  void showSearchSettings(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Settings"),
            content: SizedBox(
                width: min(300, MediaQuery.of(context).size.width),
                child: Obx(() => ListView(
                  shrinkWrap: true,
                  children: [
                    CheckboxListTile(
                        value: caseSensitive.value,
                        title: Text("Case sensitive"),
                        onChanged: (value) {
                          caseSensitive(value);
                        }),
                    CheckboxListTile(
                        value: regexSearch.value,
                        title: Text("Regex"),
                        onChanged: (value) {
                          regexSearch(value);
                        })
                  ],
                ),
                )),
            actions: <Widget>[
              TextButton(onPressed: () {Navigator.pop(context, true);}, child: Text("Ok")),
            ],
          );
        });
  }

  void updateSearchBar(BuildContext context) {
    if (searchIcon.value.icon == Icons.search_rounded) {
      searchIcon(const Icon(Icons.search_off_rounded));
      appBarTitle(TextField(
        controller: searchController,
        maxLines: 1,
        autofocus: true,
        style: const TextStyle(fontSize: 21),
        decoration: InputDecoration(
            hintText: "Search ...",
            border: InputBorder.none,
            suffixIcon: IconButton(
                icon: const Icon(Icons.tune_rounded),
                onPressed: () {
                  showSearchSettings(context);
                })
        ),
      ) as Widget);
    } else {
      searchController.clear();
      searchIcon(const Icon(Icons.search_rounded));
      appBarTitle(Text(file.name) as Widget);
    }
  }
}