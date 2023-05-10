import '../../../../services/dio/dio_service.dart';

class BrandBox extends BrandBoxOperations {
  BrandBox(this.dioService);

  DioService dioService;

  @override
  getData() {}
}

abstract class BrandBoxOperations {
  getData();
}
