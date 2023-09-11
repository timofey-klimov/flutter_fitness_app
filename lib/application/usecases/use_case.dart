abstract class UseCaseWithArgs<TRequest, TResponse> {
  Future<TResponse> call(TRequest request);
}

abstract class UseCase<TResponse> {
  Future<TResponse> call();
}
