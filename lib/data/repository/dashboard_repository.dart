import 'package:injectable/injectable.dart';

import '../../domain/entity/payment.dart';
import '../../domain/entity/payout.dart';
import '../datasource/remote/business_api.dart';
import '../datasource/storage/storage_service.dart';

/// Repository to make all operations on storage and remote server
@Named('DashboardRepository')
@Injectable()
class DashboardRepository implements DashboardRepositoryOperations {
  DashboardRepository(@Named('BusinessApi') this.api,
      @Named('StorageService') this.storageService);

  final BusinessApi api;
  final StorageService storageService;

  //! Remote Functions
  /// Get last 5 payments from server
  @override
  getPaymentsLast5DaysRemote() {}

  /// Get payments due to (Today,Yesterday,Week,Month) from server
  @override
  getPaymentsDataRemote() {}

  /// Get payouts due to (Today,Yesterday,Week,Month) from server
  @override
  getPayoutsDataRemote() {}

  /// Get last 5 payouts from server
  @override
  getPayoutsLast5DaysRemote() {}

  /// Get payments due to (Today,Yesterday,Week,Month) from storage
  @override
  Future<List<Payment>> getPaymentsDataStorage() =>
      storageService.dashboardBox.getPaymentsDataStorage();

  /// Get last 5 payments from storage
  @override
  Future<List<Payment>> getPaymentsLast5Storage() =>
      storageService.dashboardBox.getPaymentsLast5Storage();

  /// Get payouts due to (Today,Yesterday,Week,Month) from storage
  @override
  Future<List<Payout>> getPayoutsDataStorage() =>
      storageService.dashboardBox.getPayoutsDataStorage();

  /// Get last 5 payouts from storage
  @override
  Future<List<Payout>> getPayoutsLast5Storage() =>
      storageService.dashboardBox.getPayoutsLast5Storage();
}

abstract class DashboardRepositoryOperations {
  Future<List<Payment>> getPaymentsDataStorage();
  Future<List<Payment>> getPaymentsLast5Storage();
  Future<List<Payout>> getPayoutsDataStorage();
  Future<List<Payout>> getPayoutsLast5Storage();

  getPaymentsDataRemote();
  getPaymentsLast5DaysRemote();
  getPayoutsDataRemote();
  getPayoutsLast5DaysRemote();
}
