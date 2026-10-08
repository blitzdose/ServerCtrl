class SimpleStream<T> {
  void Function(T)? _listener;

  void listen(void Function(T) callback) {
    _listener = callback;
  }

  void push(T data) {
    if (_listener != null) {
      _listener!(data);
    }
  }
}