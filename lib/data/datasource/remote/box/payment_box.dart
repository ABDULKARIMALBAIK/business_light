import '../../../../services/dio/dio_service.dart';

class PaymentBox extends PaymentBoxOperations {
  PaymentBox(this.dioService);

  DioService dioService;

  @override
  getData() {}
}

abstract class PaymentBoxOperations {
  getData();
}
