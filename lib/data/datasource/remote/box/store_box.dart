import '../../../../services/dio/dio_service.dart';

class StoreBox extends StoreBoxOperations {
  StoreBox(this.dioService);

  DioService dioService;

  @override
  getData() {}
}

abstract class StoreBoxOperations {
  getData();
}
