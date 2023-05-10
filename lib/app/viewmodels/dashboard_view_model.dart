import 'package:injectable/injectable.dart';

import '../../domain/entity/payment.dart';
import '../../domain/entity/payout.dart';
import '../../domain/usecase/dashboard_use_case.dart';

/// View Model to save and using data on screen
// @LazySingleton()
@Injectable()
class DashboardViewModel extends DashboardViewModelBase {
  DashboardViewModel(@Named('DashboardUseCase') this.useCase);

  //! Lists
  List<Payment> paymentsLast5Days = [];
  List<Payout> payoutsLast5Days = [];
  List<Payment> paymentsData = [];
  List<Payout> payoutsData = [];

  //! UseCase
  DashboardUseCase useCase;

  //! Storage Methods
  /// Load all needed data in one single method
  @override
  Future<void> loadData() async {
    paymentsLast5Days = await getPaymentsLast5Storage();
    payoutsLast5Days = await getPayoutsLast5Storage();
    paymentsData = await getPaymentsDataStorage();
    payoutsData = await getPayoutsDataStorage();
  }

  /// Get payments due to (Today,Yesterday,Week,Month) from storage
  @override
  Future<List<Payment>> getPaymentsDataStorage() =>
      useCase.getPaymentsDataStorage();

  /// Get last 5 payments from storage
  @override
  Future<List<Payment>> getPaymentsLast5Storage() =>
      useCase.getPaymentsLast5Storage();

  /// Get payouts due to (Today,Yesterday,Week,Month) from storage
  @override
  Future<List<Payout>> getPayoutsDataStorage() =>
      useCase.getPayoutsDataStorage();

  /// Get last 5 payouts from storage
  @override
  Future<List<Payout>> getPayoutsLast5Storage() =>
      useCase.getPayoutsLast5Storage();
}

/// Declare all behaviors that will be used in the ViewModel
abstract class DashboardViewModelBase {
  Future<void> loadData();
  Future<List<Payment>> getPaymentsDataStorage();
  Future<List<Payment>> getPaymentsLast5Storage();
  Future<List<Payout>> getPayoutsDataStorage();
  Future<List<Payout>> getPayoutsLast5Storage();
}
