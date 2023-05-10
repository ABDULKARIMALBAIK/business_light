import 'package:business_light/data/datasource/storage/storage_service.dart';
import 'package:business_light/services/di/injection.dart';
import 'package:business_light/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'dio_controller.dart';
import 'request_interceptor.dart';

///[DioService] initial dio object to fetch data online
@Named('DioService')
@LazySingleton()
class DioService {
  static late final Dio _dio;

  /// Create [Dio] object and use [RequestInterceptor] to make a channel that help test data
  DioService() {
    final BaseOptions options = BaseOptions(
      baseUrl: DataHelper.baseUrl,
      sendTimeout: 20000,
      connectTimeout: 20000,
      receiveTimeout: 40000,
      contentType: "application/json",
    );
    final Dio dio = Dio(options);
    dio.interceptors.addAll([
      RequestInterceptor(
        dioController: DioController(
          dio: dio,
          storageService: getItClient.get<StorageService>(),
        ),
      ),
    ]);
    _dio = dio;
  }

  Dio get dioClient => _dio;
}
