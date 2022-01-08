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
      try {
        await sub?.cancel();
        sub = null;
      } catch (_) {
      }
    });
    return _Disposable._(() async {
      try {
        await sub?.cancel();
        sub = null;
      } catch (_) {
      }
    });
  }

  late final StreamController _ctrl = StreamController.broadcast(sync: true);
}
