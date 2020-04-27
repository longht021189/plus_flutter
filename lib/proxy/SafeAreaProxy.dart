import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SafeAreaProxy extends StatefulWidget {

  final StreamSink<EdgeInsets> streamPadding;
  final Widget child;

  SafeAreaProxy({
    Key key,
    @required this.child,
    this.streamPadding
  }): super(key: key);

  @override
  State createState() => _SafeAreaProxyState();
}

class _SafeAreaProxyState extends State<SafeAreaProxy> {

  bool _isDone = false;

  Future _watchDone() async {
    if (widget.streamPadding == null) {
      _isDone = true;
    } else {
      await widget.streamPadding.done;
      _isDone = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _watchDone();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.streamPadding != null && !_isDone) {
      final padding = MediaQuery.of(context).padding;
      widget.streamPadding.add(padding);
    }

    return widget.child;
  }
}
