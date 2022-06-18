# Cancel operation

## Usage

```dart

final cancelable = Cancelable();

final disposable = cancelable.whenCancel((){
    // cancel your operation
});
// do someing
```

### dispose cancelletion
```dart
disposable.dispose();
```

### cancel operation
```dart
cancelable.cancel();
```