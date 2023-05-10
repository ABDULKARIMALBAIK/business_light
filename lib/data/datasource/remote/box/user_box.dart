import '../../../../services/dio/dio_service.dart';

class UserBox extends UserBoxOperations {
  UserBox(this.dioService);

  DioService dioService;

  @override
  getData() {}
}

abstract class UserBoxOperations {
  getData();
}
