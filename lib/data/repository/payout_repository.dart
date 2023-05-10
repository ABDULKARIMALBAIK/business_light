import 'package:business_light/domain/entity/payout.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/user.dart';
import '../datasource/remote/business_api.dart';
import '../datasource/storage/storage_service.dart';

/// Repository to make all operations on storage and remote server
@Named('PayoutRepository')
@Injectable()
class PayoutRepository extends PayoutRepositoryOperations {
  PayoutRepository(@Named('BusinessApi') this.api,
      @Named('StorageService') this.storageService);

  final BusinessApi api;
  final StorageService storageService;

  //! Remote Functions
  /// Get payouts data from server
  @override
  getAllPayoutsRemote() {}

  /// delete the payout on the server
  @override
  deletePayoutRemote() {}

  /// add new payout on the server
  @override
  addPayoutRemote() {}

  /// edit the payout on the server
  @override
  editPayoutRemote() {}

  /// Get all employees data from server
  @override
  loadAllEmployeesRemote() {}

  //! Storage Functions
  /// add new payout on the storage
  @override
  Future<void> addPayoutStorage(Payout payout) async =>
      storageService.payoutBox.addPayoutStorage(payout);

  /// edit the payout on the storage
  @override
  Future<void> editPayoutStorage(
          {required int? id,
          required String code,
          required double price,
          required String description,
          required PayoutType payoutType,
          required DateTime date}) async =>
      storageService.payoutBox.editPayoutStorage(
          id: id,
          code: code,
          price: price,
          description: description,
          payoutType: payoutType,
          date: date);

  /// delete the payout on the storage
  @override
  Future<void> deletePayoutStorage(int? id) async =>
      storageService.payoutBox.deletePayoutStorage(id);

  /// Get payouts data from storage
  @override
  Future<List<Payout>> getAllPayoutStorage(
      {String? filterCode,
      double? filterPrice,
      String? filterDescription,
      PayoutType? payoutType,
      DateTime? startDate,
      DateTime? endDate,
      int? filterIndexSort,
      bool? desc}) {
    return storageService.payoutBox.getAllPayoutStorage(
        filterCode: filterCode,
        filterPrice: filterPrice,
        filterDescription: filterDescription,
        payoutType: payoutType,
        startDate: startDate,
        endDate: endDate,
        filterIndexSort: filterIndexSort,
        desc: desc);
  }

  /// Get Employees data from storage
  @override
  Future<List<User>> loadAllEmployeesStorage() =>
      storageService.payoutBox.loadAllEmployeesStorage();
}

//! Define all repo's methods of Payout
abstract class PayoutRepositoryOperations {
  Future<List<Payout>> getAllPayoutStorage(
      {String? filterCode,
      double? filterPrice,
      String? filterDescription,
      PayoutType? payoutType,
      DateTime? startDate,
      DateTime? endDate,
      int? filterIndexSort,
      bool? desc});

  Future<void> deletePayoutStorage(int? id);
  Future<void> addPayoutStorage(Payout payout);
  Future<void> editPayoutStorage(
      {required int? id,
      required String code,
      required double price,
      required String description,
      required PayoutType payoutType,
      required DateTime date});
  Future<List<User>> loadAllEmployeesStorage();

  getAllPayoutsRemote();
  deletePayoutRemote();
  addPayoutRemote();
  editPayoutRemote();
  loadAllEmployeesRemote();
}
