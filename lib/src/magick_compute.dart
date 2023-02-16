part of 'image_magick_q8.dart';

// This whole file was copied from `isolate.dart` and `_isolates_io.dart`
// because the `compute` function from those files depends on flutter
// so the `compute` function here is identical to that one except that it does
// not depend on flutter.

typedef _ComputeCallback<Q, R> = FutureOr<R> Function(Q message);

/// Clone of `isolates.compute` but does not depend on flutter.
Future<R> _magickCompute<Q, R>(_ComputeCallback<Q, R> callback, Q message,
    {String? debugLabel}) async {
  debugLabel ??= callback.toString();

  final Flow flow = Flow.begin();
  Timeline.startSync('$debugLabel: start', flow: flow);
  final RawReceivePort port = RawReceivePort();
  Timeline.finishSync();

  void timeEndAndCleanup() {
    Timeline.startSync('$debugLabel: end', flow: Flow.end(flow.id));
    port.close();
    Timeline.finishSync();
  }

  final Completer<dynamic> completer = Completer<dynamic>();
  port.handler = (dynamic msg) {
    timeEndAndCleanup();
    completer.complete(msg);
  };

  try {
    await Isolate.spawn<_IsolateConfiguration<Q, R>>(
      _spawn,
      _IsolateConfiguration<Q, R>(
        callback,
        message,
        port.sendPort,
        debugLabel,
        flow.id,
      ),
      onExit: port.sendPort,
      onError: port.sendPort,
      debugName: debugLabel,
    );
  } on Object {
    timeEndAndCleanup();
    rethrow;
  }

  final dynamic response = await completer.future;
  if (response == null) {
    throw RemoteError('Isolate exited without result or error.', '');
  }

  assert(response is List<dynamic>);
  response as List<dynamic>;

  final int type = response.length;
  assert(1 <= type && type <= 3);

  switch (type) {
    // success; see _buildSuccessResponse
    case 1:
      return response[0] as R;

    // native error; see Isolate.addErrorListener
    case 2:
      await Future<Never>.error(RemoteError(
        response[0] as String,
        response[1] as String,
      ));

    // caught error; see _buildErrorResponse
    case 3:
    default:
      assert(type == 3 && response[2] == null);

      await Future<Never>.error(
        response[0] as Object,
        response[1] as StackTrace,
      );
  }
}

class _IsolateConfiguration<Q, R> {
  const _IsolateConfiguration(
    this.callback,
    this.message,
    this.resultPort,
    this.debugLabel,
    this.flowId,
  );

  final _ComputeCallback<Q, R> callback;
  final Q message;
  final SendPort resultPort;
  final String debugLabel;
  final int flowId;

  FutureOr<R> applyAndTime() => Timeline.timeSync(
        debugLabel,
        () => callback(message),
        flow: Flow.step(flowId),
      );
}

Future<void> _spawn<Q, R>(_IsolateConfiguration<Q, R> configuration) async {
  late final List<dynamic> computationResult;

  try {
    computationResult =
        _buildSuccessResponse(await configuration.applyAndTime());
  } catch (e, s) {
    computationResult = _buildErrorResponse(e, s);
  }

  Isolate.exit(configuration.resultPort, computationResult);
}

List<R> _buildSuccessResponse<R>(R result) => List<R>.filled(1, result);

List<dynamic> _buildErrorResponse(Object error, StackTrace stack) =>
    List<dynamic>.filled(3, null)
      ..[0] = error
      ..[1] = stack;
