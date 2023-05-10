import '../../../../services/dio/dio_service.dart';

class PayoutBox extends PayoutBoxOperations {
  PayoutBox(this.dioService);

  DioService dioService;

  @override
  getData() {}
}

abstract class PayoutBoxOperations {
  getData();
}
