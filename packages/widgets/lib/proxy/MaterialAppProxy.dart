import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MaterialAppProxy extends SingleChildRenderObjectWidget {

  final StreamSink<Size> streamSize;

  MaterialAppProxy({
    Key key,
    @required MaterialApp child,
    this.streamSize
  }): super(key: key, child: child);

  @override
  RenderObject createRenderObject(
      BuildContext context) => _MaterialAppProxyElement(null, streamSize);
}

class _MaterialAppProxyElement extends RenderProxyBox {

  final StreamSink<Size> _streamSize;
  bool _isDone = false;

  _MaterialAppProxyElement([
    RenderBox child,
    StreamSink<Size> streamSize
  ]) : _streamSize = streamSize, super(child) {
    watchDone();
  }

  Future watchDone() async {
    if (_streamSize == null) {
      _isDone = true;
    } else {
      await _streamSize.done;
      _isDone = true;
    }
  }

  @override
  void performLayout() {
    super.performLayout();

    if (_streamSize != null && !_isDone) {
      _streamSize.add(size);
    }
  }
}
