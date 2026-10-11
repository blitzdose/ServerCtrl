import 'package:characters/characters.dart';
import 'package:flutter/material.dart';

/// A single-line text that is shortened in the middle ("long_na…me.txt")
/// when it does not fit into the width given by its parent.
///
/// The available width is taken from the parent's constraints, so any
/// padding/siblings around the widget are respected automatically.
class MiddleEllipsisText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String ellipsis;
  final TextAlign? textAlign;

  const MiddleEllipsisText(
      this.text, {
        super.key,
        this.style,
        this.ellipsis = '…',
        this.textAlign,
      });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = DefaultTextStyle.of(context).style.merge(style);
    final textScaler = MediaQuery.textScalerOf(context);
    final textDirection = Directionality.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final display = _fit(
          text,
          constraints.maxWidth,
          effectiveStyle,
          textScaler,
          textDirection,
        );
        return Text(
          display,
          style: style,
          textAlign: textAlign,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.clip,
        );
      },
    );
  }

  String _fit(
      String text,
      double maxWidth,
      TextStyle style,
      TextScaler textScaler,
      TextDirection textDirection,
      ) {
    if (!maxWidth.isFinite) return text;

    final painter = TextPainter(
      textDirection: textDirection,
      textScaler: textScaler,
      maxLines: 1,
    );

    bool fits(String s) {
      painter.text = TextSpan(text: s, style: style);
      painter.layout();
      return painter.width <= maxWidth;
    }

    try {
      if (fits(text)) return text;

      final chars = text.characters;
      final n = chars.length;

      String build(int visible) {
        final tailCount = (visible / 2).ceil();
        final headCount = visible - tailCount;
        return '${chars.take(headCount)}$ellipsis${chars.takeLast(tailCount)}';
      }

      // Binary search for the largest number of visible characters that fits.
      int lo = 0, hi = n - 1;
      while (lo < hi) {
        final mid = (lo + hi + 1) ~/ 2;
        if (fits(build(mid))) {
          lo = mid;
        } else {
          hi = mid - 1;
        }
      }
      return build(lo);
    } finally {
      painter.dispose();
    }
  }
}