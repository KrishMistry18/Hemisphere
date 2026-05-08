// Web stub for tflite_flutter.
// Provides no-op implementations so the app compiles on web.
// ML features are disabled on web — the conditional export in
// ml_service.dart ensures ml_service_web.dart is used instead.

class Interpreter {
  Interpreter._();

  static Future<Interpreter> fromAsset(
    String assetName, {
    InterpreterOptions? options,
  }) async {
    throw UnsupportedError('tflite_flutter is not supported on web.');
  }

  void run(Object input, Object output) {}

  void runForMultipleInputs(
    List<Object> inputs,
    Map<int, Object> outputs,
  ) {}

  void close() {}

  List<dynamic> get inputTensors => [];
  List<dynamic> get outputTensors => [];
}

class InterpreterOptions {
  int threads = 1;
  bool useNnApiForAndroid = false;
}

class Tensor {
  List<int> get shape => [];
  dynamic get data => null;
}

// Stub for the reshape extension used in ml_service_io.dart
extension ListReshapeStub on List {
  List reshape(List<int> shape) => this;
}
