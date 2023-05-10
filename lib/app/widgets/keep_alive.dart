import 'package:flutter/material.dart';

/// Widget save some data like scroll position
class KeepAliveWidget extends StatefulWidget {
  final Widget widget;
  const KeepAliveWidget({
    required this.widget,
    Key? key,
  }) : super(key: key);

  @override
  KeepAliveWidgetState createState() => KeepAliveWidgetState._();
}

class KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  KeepAliveWidgetState._();
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.widget;
  }

  @override
  bool get wantKeepAlive => true;
}
