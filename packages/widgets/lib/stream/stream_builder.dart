import 'dart:async' as a;
import 'package:flutter/material.dart';

typedef AsyncWidgetBuilder<T> = Widget Function(BuildContext context, T currentValue);
typedef ErrorHandler<T> = void Function(T currentValue, dynamic error);

class StreamBuilder<T> extends StatefulWidget {
  final AsyncWidgetBuilder<T> builder;
  final Stream<T> stream;
  final T initialData;
  final ErrorHandler<T> handler;

  StreamBuilder({ 
    Key key,
    @required this.builder,
    @required this.stream,
    @required this.initialData,
    this.handler
  }): assert(stream != null)
    , assert(builder != null)
    , super(key: key);

  @override
  State<StatefulWidget> createState() => _StreamBuilderState(initialData);
}

class _StreamBuilderState<T> extends State<StreamBuilder<T>> {

  a.StreamSubscription<T> subscription;
  T currentValue;

  _StreamBuilderState(this.currentValue);

  void onData(T value) {
    setState(() {
      currentValue = value;
    });
  }

  void onError(dynamic error) {
    if (widget.handler != null) {
      widget.handler(currentValue, error);
    }
  }

  @override
  void initState() {
    super.initState();

    subscription = widget
      .stream
      .distinct()
      .listen(onData, onError: onError);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder
      .call(context, currentValue);
  }
}
