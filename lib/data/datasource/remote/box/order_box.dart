import '../../../../services/dio/dio_service.dart';

class OrderBox extends OrderBoxOperations {
  OrderBox(this.dioService);

  DioService dioService;

  @override
  getData() {}
}

abstract class OrderBoxOperations {
  getData();
}
