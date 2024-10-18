import 'package:dio/dio.dart';

abstract class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});

  factory ServerFailure.formDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(message: 'Connection timeout with ApiServer');

      case DioExceptionType.sendTimeout:
        return ServerFailure(message: 'Send timeout with ApiServer');

      case DioExceptionType.receiveTimeout:
        return ServerFailure(message: 'Receive timeout with ApiServer');

      case DioExceptionType.badCertificate:
        return ServerFailure(message: 'Bad certificate');

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            error.response!, error.response!.statusCode!);

      case DioExceptionType.cancel:
        return ServerFailure(message: 'Request to ApiServer was cancelled');

      case DioExceptionType.connectionError:
        return ServerFailure(message: 'Connection error with ApiServer');

      case DioExceptionType.unknown:
        return ServerFailure(message: 'Something went wrong');
    }
  }
  factory ServerFailure.fromResponse(dynamic response, int statusCode) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(message: response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure(
          message: 'Your request not found, please try again error 404');
    } else if (statusCode == 500) {
      return ServerFailure(
          message: 'Internal server error, please try again error 500');
    } else {
      return ServerFailure(
          message: "Something went wrong server failure, please try again");
    }
  }
}
