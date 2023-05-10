import 'package:business_light/data/datasource/storage/storage_service.dart';
import 'package:injectable/injectable.dart';

import '../dio/dio_service.dart';

@module
abstract class AppModule {
  //! Inject Storage Service
  @LazySingleton()
  StorageService get storage => StorageService();

  //! Inject Dio Service
  @LazySingleton()
  DioService get remote => DioService();
}
