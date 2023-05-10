import 'dart:io';

import 'package:dio/dio.dart';

/// Handle all exception when fetch data online
class CustomException implements Exception {
  final CustomError error;

  CustomException._(this.error);

  @override
  String toString() => "message : $error";
}

/// [ExceptionHandler] check error and throw [CustomException]
class ExceptionHandler {
  factory ExceptionHandler(dynamic error) {
    switch (error.runtimeType) {
      case FormatException:
        error as FormatException;
        throw CustomException._(CustomError.formatException);
      case DioError:
        error as DioError;
        if (error.type == DioErrorType.connectTimeout ||
            error.type == DioErrorType.receiveTimeout ||
            error.type == DioErrorType.sendTimeout ||
            error.type == DioErrorType.cancel ||
            (error.message.contains("SocketException"))) {
          throw CustomException._(CustomError.noInternet);
        } else {
          if (error.response != null) {
            if (error.response!.statusCode == 401) {}
            if (error.response!.statusCode == 409) {
              if (error.response!.data["message"] == "wrong password") {
                throw CustomException._(CustomError.notExists);
              } else if (error.response!.data["message"]
                  .toString()
                  .contains('than')) {
                throw CustomException._(CustomError.moreThan10);
              } else {
                throw CustomException._(CustomError.alreadyExists);
              }
            }
            if (error.response!.statusCode == 404) {
              throw CustomException._(CustomError.notExists);
            }
            if (error.response!.statusCode == 405) {}
          } else {
            throw CustomException._(CustomError.unKnown);
          }
        }
        throw CustomException._(CustomError.unKnown);
      case SocketException:
        error as SocketException;
        throw CustomException._(CustomError.noInternet);
      case HttpException:
        error as HttpException;
        throw CustomException._(CustomError.noInternet);
      default:
        throw CustomException._(CustomError.unKnown);
    }
  }
}

/// All use cases for exception of dio
enum CustomError {
  noInternet,
  unKnown,
  alreadyExists,
  formatException,
  fieldsEmpty,
  notExists,
  weakPassword,
  ensurePasswordCorrect,
  imageNotPicked,
  chooseJobType,
  chooseLocation,
  moreThan10,
}
