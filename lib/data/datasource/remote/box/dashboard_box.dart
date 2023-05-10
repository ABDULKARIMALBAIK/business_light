import '../../../../services/dio/dio_service.dart';

class DashboardBox extends DashboardBoxOperations {
  DashboardBox(this.dioService);

  DioService dioService;

  @override
  getData() {}
}

abstract class DashboardBoxOperations {
  getData();
}
