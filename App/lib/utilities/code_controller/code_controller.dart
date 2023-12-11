import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart' show Mode, Node, highlight;

class MyCodeController extends CodeController {
  String? _languageName;

  /// A highlight language to parse the text with
  @override
  Mode? get language => null;

  @override
  set language(Mode? language) {

  }

  set languageName(String language) {
    _languageName = language;
  }

  final _modifierMap = <String, CodeModifier>{};
  final _styleList = <TextStyle>[];
  RegExp? _styleRegExp;

  MyCodeController({
    String? text,
    String? languageName
  }) : super(text: text) {
    _languageName = languageName;
    // Create modifier map
    for (final el in modifiers) {
      _modifierMap[el.char] = el;
    }

    // Build styleRegExp
    final patternList = <String>[];
    if (stringMap != null) {
      patternList.addAll(stringMap!.keys.map((e) => r'(\b' + e + r'\b)'));
      _styleList.addAll(stringMap!.values);
    }
    if (patternMap != null) {
      patternList.addAll(patternMap!.keys.map((e) => '($e)'));
      _styleList.addAll(patternMap!.values);
    }
    _styleRegExp = RegExp(patternList.join('|'), multiLine: true);
  }

  int? _insertedLoc(String a, String b) {
    final sel = selection;

    if (a.length + 1 != b.length || sel.start != sel.end) {
      return null;
    }

    return sel.start;
  }

  @override
  set value(TextEditingValue newValue) {
    final loc = _insertedLoc(text, newValue.text);

    if (loc != null) {
      final char = newValue.text[loc];
      final modifier = _modifierMap[char];
      final val = modifier?.updateString(super.text, selection, params);

      if (val != null) {
        // Update newValue
        newValue = newValue.copyWith(
          text: val.text,
          selection: val.selection,
        );
      }
    }
    super.value = newValue;
  }

  TextSpan _processPatterns(String text, TextStyle? style) {
    final children = <TextSpan>[];

    text.splitMapJoin(
      _styleRegExp!,
      onMatch: (Match m) {
        if (_styleList.isEmpty) {
          return '';
        }

        int idx;
        for (idx = 1;
        idx < m.groupCount &&
            idx <= _styleList.length &&
            m.group(idx) == null;
        idx++) {}

        children.add(TextSpan(
          text: m[0],
          style: _styleList[idx - 1],
        ));
        return '';
      },
      onNonMatch: (String span) {
        children.add(TextSpan(text: span, style: style));
        return '';
      },
    );

    return TextSpan(style: style, children: children);
  }

  TextSpan _processLanguage(
      String text,
      CodeThemeData? widgetTheme,
      TextStyle? style,
      ) {
    final result = highlight.parse(text, language: _languageName);

    final nodes = result.nodes;

    final children = <TextSpan>[];
    var currentSpans = children;
    final stack = <List<TextSpan>>[];

    void traverse(Node node) {
      var val = node.value;
      final nodeChildren = node.children;
      final nodeStyle = widgetTheme?.styles[node.className];

      if (val != null) {
        var child = TextSpan(text: val, style: nodeStyle);

        if (_styleRegExp != null) {
          child = _processPatterns(val, nodeStyle);
        }

        currentSpans.add(child);
      } else if (nodeChildren != null) {
        List<TextSpan> tmp = [];

        currentSpans.add(TextSpan(
          children: tmp,
          style: nodeStyle,
        ));

        stack.add(currentSpans);
        currentSpans = tmp;

        for (final n in nodeChildren) {
          traverse(n);
          if (n == nodeChildren.last) {
            currentSpans = stack.isEmpty ? children : stack.removeLast();
          }
        }
      }
    }

    if (nodes != null) {
      nodes.forEach(traverse);
    }

    return TextSpan(style: style, children: children);
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    bool? withComposing,
  }) {
    // Return parsing
    if (_languageName != null) {
      return _processLanguage(text, CodeTheme.of(context), style);
    }
    if (_styleRegExp != null) {
      return _processPatterns(text, style);
    }
    return TextSpan(text: text, style: style);
  }

  @override
  String get languageId => "";

}
