import 'dart:async';

abstract class Disposable {
  Future<void> dispose();
}

abstract class Cancelable {
  factory Cancelable() {
    return _Cancelable();
  }
  void cancel();
  Disposable whenCancel(Function() f);
}

class _Disposable implements Disposable {
  _Disposable._(this._dispose);

  @override
  Future<void> dispose() async {
    await _dispose?.call();
    _dispose = null;
  }

  Future<void> Function()? _dispose;
}

class _Cancelable implements Cancelable {
  _Cancelable();

  void cancel() {
    _ctrl.add(null);
  }

  Disposable whenCancel(Function() f) {
    StreamSubscription? sub;
    sub = _ctrl.stream.listen((_) async {
      f();
      await sub?.cancel();
    });
    return _Disposable._(() async {
      await sub?.cancel();
      sub = null;
    });
  }

  late final StreamController _ctrl = StreamController.broadcast(sync: true);
}
