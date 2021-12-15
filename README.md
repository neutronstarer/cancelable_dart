# Cancel operation

## Usage

```dart

final cancelable = Cancelable();

final disposable = cancelable.whenCancel((){
    // cancel your operation
});
// do someing

// when operation finished, dispose cancelletion of the operation.
disposable.dispose();
```

### cancel operation
```dart
cancelable.cancel();
```