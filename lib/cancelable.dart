library cancelable;

import 'dart:async';

class Cancelable {
  cancel() {
    _ctrl.add(null);
  }

  StreamSubscription whenCancel(Function() f) {
    StreamSubscription? sub;
    sub = _ctrl.stream.listen((_) async {
      f();
      await sub?.cancel();
    });
    return sub;
  }

  late final StreamController _ctrl = StreamController.broadcast();
}
