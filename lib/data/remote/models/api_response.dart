abstract class ApiResponse<T> {}

class Success<T> extends ApiResponse<T> {
  T? data;

  Success({required this.data});
}

class Failure<T> extends ApiResponse<T> {
  String? errorMessage;
  int? code;

  Failure({required this.errorMessage, this.code});
}

