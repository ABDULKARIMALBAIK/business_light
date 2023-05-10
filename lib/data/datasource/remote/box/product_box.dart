import '../../../../services/dio/dio_service.dart';

class ProductBox extends ProductBoxOperations {
  ProductBox(this.dioService);

  DioService dioService;

  @override
  getData() {}
}

abstract class ProductBoxOperations {
  getData();
}
