import 'dart:async';

/// [Disposable] Dispose class
abstract class Disposable {
  /// [dispose] dispose cancel-awaiting.
  Future<void> dispose();
}

/// [Cancelable] Cancel context.
abstract class Cancelable {
  /// [Cancelable] Create instance.
  factory Cancelable() {
    return _Cancelable();
  }

  /// [cancel] Cancel.
  void cancel();

  /// [whenCancel] Call [f] when cancel.
  /// [f] cancel function.
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
