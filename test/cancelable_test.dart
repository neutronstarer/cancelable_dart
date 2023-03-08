import 'dart:async';

import 'package:cancelable/cancelable.dart';

import 'package:test/test.dart';

void main() {
  test('npc', () async {
    final cancelable = Cancelable();
    Timer(Duration(seconds: 1), () {
      cancelable.cancel();
    });
    await Future.wait([
      task(cancelable),
      task(cancelable),
      task(null),
    ]);
  });
}

Future<void> task(Cancelable? cancelable) {
  final c = Completer();
  final timer = Timer(Duration(seconds: 2), () {
    print("done");
    c.complete();
  });
  cancelable?.whenCancel(() async {
    timer.cancel();
    c.complete();
    print("cancel");
  });
  return c.future;
}
