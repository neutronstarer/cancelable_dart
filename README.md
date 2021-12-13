## Usage

```dart

final cancelable = Cancelable();

final sub = cancelable.whenCancel((){
    // cancel your operation
});
// do someing

// when operation finished, cancel subscription if need.
sub.cancel();
```

### cancel operation
```dart
cancelable.cancel()
```