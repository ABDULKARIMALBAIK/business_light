import 'dart:math';

import 'package:flutter/material.dart';

/// Api help to make widget responsible to changes of window
class CustomSize {
  CustomSize({
    required double constWidth,
    required double constHeight,
    required double screenWidth,
    required double screenHeight,
  }) {
    _currentScreenHeight = screenHeight - constHeight;
    _currentScreenWidth = screenWidth - constWidth;
  }
  late double _currentScreenHeight;
  late double _currentScreenWidth;

  /// Changing by radius
  double setRadius(double inputRadius) {
    final double width = (inputRadius / 411) * _currentScreenWidth;
    final double height = (inputRadius / 843) * _currentScreenHeight;
    return min(height, width);
  }

  /// Changing by height
  double setHeight(double inputHeight) {
    if (((inputHeight / 843) * _currentScreenHeight) < 1) {
      return 1;
    } else {
      return (inputHeight / 843) * _currentScreenHeight;
    }
  }

  /// Changing by width
  double setWidth(double inputWidth) {
    if (((inputWidth / 411) * _currentScreenWidth) < 1) {
      return 1;
    } else {
      return (inputWidth / 411) * _currentScreenWidth;
    }
  }

  double get screenHeight => _currentScreenHeight;
  double get screenWidth => _currentScreenWidth;
}

typedef Sizer = Widget Function(CustomSize customSize);

/// Widget to make screen responsive
class ScreenSizer extends StatelessWidget {
  ScreenSizer({
    required this.builder,
    this.context,
    this.constWidth = 0.0,
    this.constHeight = 0.0,
    Key? key,
  }) : super(key: key);
  final GlobalKey globalKey = GlobalKey();
  final Sizer builder;
  final double constWidth;
  final double constHeight;
  final BuildContext? context;
  @override
  Widget build(BuildContext context) {
    return Container(
      key: globalKey,
      child: LayoutBuilder(builder: (context, constraints) {
        final CustomSize customSize = CustomSize(
          constHeight: constHeight,
          screenHeight: constraints.maxHeight,
          screenWidth: constraints.maxWidth,
          constWidth: constWidth,
        );
        return builder(customSize);
      }),
    );
  }
}
