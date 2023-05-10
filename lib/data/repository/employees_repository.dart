import 'package:injectable/injectable.dart';

import '../../domain/entity/payout.dart';
import '../../domain/entity/user.dart';
import '../datasource/remote/business_api.dart';
import '../datasource/storage/storage_service.dart';

/// Repository to make all operations on storage and remote server
@Named('EmployeesRepository')
@Injectable()
class EmployeesRepository extends EmployeesRepositoryOperations {
  EmployeesRepository(@Named('BusinessApi') this.api,
      @Named('StorageService') this.storageService);

  final BusinessApi api;
  final StorageService storageService;

  //! Remote Functions
  /// add new employee on the server
  @override
  addEmployeeRemote() {}

  /// delete the employee on the server
  @override
  deleteEmployeeRemote() {}

  /// edit the employee on the server
  @override
  editEmployeeRemote() {}

  /// Get employees data from server
  @override
  getAllEmployeesRemote() {}

  /// Get payouts data from server
  @override
  getAllPayoutsEmployeeRemote() {}

  /// delete the payout on the server
  @override
  deletePayoutRemote() {}

  //! Storage Functions
  /// add new employee on the storage
  @override
  Future<void> addEmployeeStorage(User employee) async =>
      storageService.userBox.addUserStorage(employee);

  /// edit the employee on the storage
  @override
  Future<void> editEmployeeStorage(
          {int? id,
          required String fullName,
          required String email,
          required String password,
          required String salary,
          required String phone,
          required String jobDescription,
          required String imagePath,
          required UserLevel level}) async =>
      storageService.userBox.editUserStorage(
          id: id,
          fullName: fullName,
          email: email,
          password: password,
          phone: phone,
          salary: salary,
          jobDescription: jobDescription,
          imagePath: imagePath,
          level: level);

  /// delete the employee on the storage
  @override
  Future<void> deleteEmployeeStorage(int? id) async =>
      storageService.userBox.deleteUserStorage(id);

  /// delete the payout on the storage
  @override
  Future<void> deletePayoutStorage(int? id) async =>
      storageService.payoutBox.deletePayoutStorage(id);

  /// Get employees data from storage
  @override
  Future<List<User>> getAllEmployeesStorage(
      {String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterJobDescription,
      UserLevel? filterLevel,
      String? filterGreaterSalary,
      String? filterLowerSalary,
      int? filterIndexSort,
      bool? desc}) {
    return storageService.userBox.getAllEmployeesStorage(
        filterEmail: filterEmail,
        filterName: filterName,
        filterPhone: filterPhone,
        filterJobDescription: filterJobDescription,
        filterLevel: filterLevel,
        filterGreaterSalary: filterGreaterSalary,
        filterLowerSalary: filterLowerSalary,
        filterIndexSort: filterIndexSort,
        desc: desc);
  }

  /// Get payouts data from storage
  @override
  Future<List<Payout>> getAllPayoutsEmployeeStorage(
          {double? filterPrice,
          DateTime? startDate,
          DateTime? endDate,
          User? userDetails,
          int? filterIndexSort,
          bool? desc}) =>
      storageService.payoutBox.getAllPayoutsEmployeeStorage(
          filterPrice: filterPrice,
          startDate: startDate,
          endDate: endDate,
          userDetails: userDetails,
          filterIndexSort: filterIndexSort,
          desc: desc);
}

//! Define all repo's methods of Employees
abstract class EmployeesRepositoryOperations {
  Future<List<User>> getAllEmployeesStorage(
      {String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterJobDescription,
      UserLevel? filterLevel,
      String? filterGreaterSalary,
      String? filterLowerSalary,
      int? filterIndexSort,
      bool? desc});

  Future<void> deleteEmployeeStorage(int? id);
  Future<void> addEmployeeStorage(User employee);
  Future<void> editEmployeeStorage(
      {int? id,
      required String fullName,
      required String email,
      required String password,
      required String salary,
      required String phone,
      required String jobDescription,
      required String imagePath,
      required UserLevel level});

  Future<List<Payout>> getAllPayoutsEmployeeStorage(
      {double? filterPrice,
      DateTime? startDate,
      DateTime? endDate,
      User? userDetails,
      int? filterIndexSort,
      bool? desc});

  Future<void> deletePayoutStorage(int? id);

  getAllEmployeesRemote();
  deleteEmployeeRemote();
  addEmployeeRemote();
  editEmployeeRemote();
  getAllPayoutsEmployeeRemote();
  deletePayoutRemote();
}
