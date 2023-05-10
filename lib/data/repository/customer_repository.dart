import 'package:injectable/injectable.dart' show Named, Injectable;

import '../../domain/entity/order.dart';
import '../../domain/entity/payment.dart';
import '../../domain/entity/user.dart';
import '../datasource/remote/business_api.dart';
import '../datasource/storage/storage_service.dart';

/// Repository to make all operations on storage and remote server
@Named('CustomerRepository')
@Injectable()
class CustomerRepository extends CustomersRepositoryOperations {
  CustomerRepository(@Named('BusinessApi') this.api,
      @Named('StorageService') this.storageService);

  final BusinessApi api;
  final StorageService storageService;

  //! Remote Functions
  /// add new customer on the server
  @override
  addCustomerRemote() {}

  /// delete the customer on the server
  @override
  deleteCustomerRemote() {}

  /// edit the customer on the server
  @override
  editCustomerRemote() {}

  /// Get customers data from server
  @override
  getAllCustomersRemote() {}

  /// Get orders of customer data from server
  @override
  getAllCustomerOrdersRemote() {}

  /// Get payments of customer data from server
  @override
  getAllCustomerPaymentsRemote() {}

  //! Storage Functions
  /// add new customer on the storage
  @override
  Future<void> addCustomerStorage(User customer) async =>
      storageService.userBox.addUserStorage(customer);

  /// Get orders of customer from storage
  @override
  Future<List<Order>> getAllCustomerOrdersStorage(User customer) async =>
      storageService.orderBox.getAllCustomerOrdersStorage(customer);

  /// Get payments of customer from storage
  @override
  Future<List<Payment>> getAllCustomerPaymentsStorage(User customer) async =>
      storageService.paymentBox.getAllCustomerPaymentsStorage(customer);

  /// edit the customer on the storage
  @override
  Future<void> editCustomerStorage(
          {int? id,
          required String fullName,
          required String email,
          required String password,
          required String phone,
          required String imagePath,
          required String jobDescription}) async =>
      storageService.userBox.editUserStorage(
          id: id,
          fullName: fullName,
          email: email,
          password: password,
          phone: phone,
          salary: 0.0.toString(),
          jobDescription: jobDescription,
          imagePath: imagePath,
          level: UserLevel.customer);

  /// delete the customer on the storage
  @override
  Future<void> deleteCustomerStorage(int? id) async =>
      storageService.userBox.deleteUserStorage(id);

  /// Get customers data from storage
  @override
  Future<List<User>> getAllCustomersStorage(
      {String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterJobDescription,
      int? filterIndexSort,
      bool? desc}) {
    return storageService.userBox.getAllCustomersStorage(
        filterEmail: filterEmail,
        filterName: filterName,
        filterPhone: filterPhone,
        filterJobDescription: filterJobDescription,
        filterIndexSort: filterIndexSort,
        desc: desc);
  }
}

//! Define all repo's methods of Customers
abstract class CustomersRepositoryOperations {
  Future<List<User>> getAllCustomersStorage(
      {String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterJobDescription,
      int? filterIndexSort,
      bool? desc});

  Future<List<Order>> getAllCustomerOrdersStorage(User customer);
  Future<List<Payment>> getAllCustomerPaymentsStorage(User customer);

  Future<void> deleteCustomerStorage(int? id);
  Future<void> addCustomerStorage(User customer);
  Future<void> editCustomerStorage(
      {int? id,
      required String fullName,
      required String email,
      required String password,
      required String phone,
      required String imagePath,
      required String jobDescription});

  getAllCustomersRemote();
  getAllCustomerOrdersRemote();
  getAllCustomerPaymentsRemote();
  deleteCustomerRemote();
  addCustomerRemote();
  editCustomerRemote();
}
