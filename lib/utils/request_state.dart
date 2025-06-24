abstract class RequestState<T> {
  T? result;
  RequestState({this.result});
}

class RequestStateInitial<T> extends RequestState<T> {}

class RequestStateLoading<T> extends RequestState<T> {}

class RequestStateError<T> extends RequestState<T> {
  final String message;
  RequestStateError({
    required this.message,
  });
}

class RequestStateEmpty<T> extends RequestState<T> {}

class RequestStateLoaded<T> extends RequestState<T> {
  RequestStateLoaded({required super.result});
}
