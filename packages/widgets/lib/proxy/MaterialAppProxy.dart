import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class _StreamWrapper {
  final StreamSink<Size> _streamSize;
  bool _isDone = false;

  _StreamWrapper(this._streamSize);

  Future watchDone() async {
    if (_streamSize == null) {
      _isDone = true;
    } else {
      await _streamSize.done;
      _isDone = true;
    }
  }

  void updateSize(Size size) {
    if (!_isDone) {
      _streamSize.add(size);
    }
  }
}

class MaterialAppProxy extends SingleChildRenderObjectWidget {

  final Function(Size) callback;

  MaterialAppProxy._internal({
    Key key,
    @required MaterialApp child,
    this.callback
  }) : super(key: key, child: child);

  factory MaterialAppProxy({
    Key key,
    @required MaterialApp child,
    Function(Size) callback
  }) {
    return MaterialAppProxy._internal(
      key: key, child: child, callback: callback);
  }

  factory MaterialAppProxy.withStream({
    Key key,
    @required MaterialApp child,
    StreamSink<Size> streamSize
  }) {
    final callback = _StreamWrapper(streamSize);

    return MaterialAppProxy._internal(
      key: key, child: child, callback: callback.updateSize);
  }

  @override
  RenderObject createRenderObject(
      BuildContext context) => _MaterialAppProxyElement(null, callback);
}

class _MaterialAppProxyElement extends RenderProxyBox {

  final Function(Size) _callback;

  _MaterialAppProxyElement([
    RenderBox child,
    Function(Size) callback
  ]) : _callback = callback, super(child);

  @override
  void performLayout() {
    super.performLayout();

    if (_callback != null) {
      _callback(size);
    }
  }
}
