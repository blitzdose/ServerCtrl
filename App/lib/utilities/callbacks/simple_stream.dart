class SimpleStream<T> {
  void Function(T)? _listener;

  SimpleSubscription listen(void Function(T) callback) {
    _listener = callback;
    return SimpleSubscription._(() {
      if (identical(_listener, callback)) {
        _listener = null;
      }
    });
  }

  void push(T data) {
    _listener?.call(data);
  }
}

class SimpleSubscription {
  SimpleSubscription._(this._onCancel);

  void Function()? _onCancel;

  void cancel() {
    _onCancel?.call();
    _onCancel = null;
  }
}