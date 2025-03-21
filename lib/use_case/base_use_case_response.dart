class BaseUseCaseResponse {
  final bool isLoading;
  final dynamic error;

  bool isSuccessful() => error == null && !isLoading;

  BaseUseCaseResponse({
    this.isLoading = false,
    this.error,
  });
}
