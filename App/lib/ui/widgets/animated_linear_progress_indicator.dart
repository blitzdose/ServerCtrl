import 'package:flutter/material.dart';

class AnimatedLinearProgressIndicator extends StatelessWidget {
  /// The target progress value, between 0.0 and 1.0.
  final double? value;

  /// The duration of the animation when [value] changes. Default is 300ms.
  final Duration duration;

  /// The animation curve to use. Default is [Curves.easeInOut].
  final Curve curve;

  final Color? backgroundColor;
  final Animation<Color?>? valueColor;
  final double? minHeight;
  final String? semanticsLabel;
  final String? semanticsValue;

  const AnimatedLinearProgressIndicator({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOut,
    this.backgroundColor,
    this.valueColor,
    this.minHeight,
    this.semanticsLabel,
    this.semanticsValue,
  });

  @override
  Widget build(BuildContext context) {
    final double? targetValue = value?.clamp(0.0, 1.0);

    if (targetValue == null) {
      return LinearProgressIndicator(
        value: targetValue, // Pass the intermediate animated value here
        backgroundColor: backgroundColor,
        valueColor: valueColor,
        minHeight: minHeight,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: targetValue),
      duration: duration,
      curve: curve,
      builder: (BuildContext context, double animatedValue, Widget? child) {
        return LinearProgressIndicator(
          value: animatedValue, // Pass the intermediate animated value here
          backgroundColor: backgroundColor,
          valueColor: valueColor,
          minHeight: minHeight,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
        );
      },
    );
  }
}