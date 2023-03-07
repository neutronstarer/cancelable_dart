import 'dart:async';

/// [Disposable] Dispose class
abstract class Disposable {
  /// [dispose] dispose cancel-awaiting.
  void dispose();
}

/// [Cancelable] Cancel context.
abstract class Cancelable {
  /// [Cancelable] Create instance.
  factory Cancelable() {
    return _Cancelable();
  }

  /// [cancel] Cancel.
  FutureOr<void> cancel();

  /// [whenCancel] Call [f] when cancel.
  /// [f] cancel function.
  Disposable whenCancel(FutureOr<void> Function() f);
}

class _Disposable implements Disposable {
  _Disposable._(this._dispose);

  @override
  void dispose() {
    _dispose?.call();
    _dispose = null;
  }

  void Function()? _dispose;
}

class _Cancelable implements Cancelable {
  _Cancelable();

  var cancels = <FutureOr<void> Function()>[];
  FutureOr<void> cancel() async {
    for (int i = 0; i < cancels.length; i++) {
      final f = cancels[i];
      await f();
    }
    cancels.clear();
  }

  Disposable whenCancel(FutureOr<void> Function() f) {
    cancels.add(f);
    return _Disposable._(() {
      cancels.remove(f);
    });
  }
}
