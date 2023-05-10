import '../../../../services/dio/dio_service.dart';

class CompanyBox extends CompanyBoxOperations {
  CompanyBox(this.dioService);

  DioService dioService;

  @override
  getData() {}
}

abstract class CompanyBoxOperations {
  getData();
}
