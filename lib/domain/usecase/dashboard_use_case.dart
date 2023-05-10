import 'package:injectable/injectable.dart';

import '../../data/repository/dashboard_repository.dart';
import '../entity/payment.dart';
import '../entity/payout.dart';
import '../mapper/dashboard_mapper.dart';
import '../repository/dashboard_operations.dart';

/// Usecase to make all operations in view model of dashboard
@Named('DashboardUseCase')
@Injectable()
class DashboardUseCase implements DashBoardOperations {
  DashboardUseCase(@Named('DashboardRepository') this.repository,
      @Named('DashboardMapper') this.mapper);

  final DashboardRepository repository;
  final DashboardMapper mapper;

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
      repository.getPaymentsDataStorage();

  /// Get last 5 payments from storage
  @override
  Future<List<Payment>> getPaymentsLast5Storage() =>
      repository.getPaymentsLast5Storage();

  /// Get payouts due to (Today,Yesterday,Week,Month) from storage
  @override
  Future<List<Payout>> getPayoutsDataStorage() =>
      repository.getPayoutsDataStorage();

  /// Get last 5 payouts from storage
  @override
  Future<List<Payout>> getPayoutsLast5Storage() =>
      repository.getPayoutsLast5Storage();
}
