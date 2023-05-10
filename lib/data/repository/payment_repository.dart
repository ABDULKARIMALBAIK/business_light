import 'package:business_light/domain/entity/payment.dart';
import 'package:injectable/injectable.dart' show Named, Injectable;

import '../../domain/entity/order.dart';
import '../datasource/remote/business_api.dart';
import '../datasource/storage/storage_service.dart';

/// Repository to make all operations on storage and remote server
@Named('PaymentRepository')
@Injectable()
class PaymentRepository extends PaymentRepositoryOperations {
  PaymentRepository(@Named('BusinessApi') this.api,
      @Named('StorageService') this.storageService);

  final BusinessApi api;
  final StorageService storageService;

  //! Remote Functions
  /// Get payments data from server
  @override
  getAllPaymentsRemote() {}

  /// delete the payment on the server
  @override
  deletePaymentRemote() {}

  /// add new payment on the server
  @override
  addPaymentRemote() {}

  /// edit the payment on the server
  @override
  editPaymentRemote() {}

  /// Get orders data from server
  @override
  loadAllOrdersRemote() {}

  //! Storage Functions
  /// add new payment on the storage
  @override
  Future<void> addPaymentStorage(Payment payment, Order? selectedOrder) async =>
      storageService.paymentBox.addPaymentStorage(payment, selectedOrder);

  /// edit the payment on the storage
  @override
  Future<void> editPaymentStorage(
          {required int? id,
          required String code,
          required double price,
          required String description,
          required PaymentType paymentType,
          required DateTime date}) async =>
      storageService.paymentBox.editPaymentStorage(
          id: id,
          code: code,
          price: price,
          description: description,
          paymentType: paymentType,
          date: date);

  /// delete the payment on the storage
  @override
  Future<void> deletePaymentStorage(int? id) async =>
      storageService.paymentBox.deletePaymentStorage(id);

  /// Get payments data from storage
  @override
  Future<List<Payment>> getAllPaymentStorage(
      {String? filterCode,
      double? filterPrice,
      String? filterDescription,
      PaymentType? paymentType,
      DateTime? startDate,
      DateTime? endDate,
      int? filterIndexSort,
      bool? desc}) {
    return storageService.paymentBox.getAllPaymentStorage(
        filterCode: filterCode,
        filterPrice: filterPrice,
        filterDescription: filterDescription,
        paymentType: paymentType,
        startDate: startDate,
        endDate: endDate,
        filterIndexSort: filterIndexSort,
        desc: desc);
  }

  /// Get orders data from storage
  @override
  Future<List<Order>> loadAllOrdersStorage() async => storageService.orderBox
      .getAllOrdersStorage(filterIndexSort: 0, desc: false);
}

//! Define all repo's methods of Payment
abstract class PaymentRepositoryOperations {
  Future<List<Payment>> getAllPaymentStorage(
      {String? filterCode,
      double? filterPrice,
      String? filterDescription,
      PaymentType? paymentType,
      DateTime? startDate,
      DateTime? endDate,
      int? filterIndexSort,
      bool? desc});

  Future<void> deletePaymentStorage(int? id);
  Future<void> addPaymentStorage(Payment payment, Order? selectedOrder);
  Future<void> editPaymentStorage(
      {required int? id,
      required String code,
      required double price,
      required String description,
      required PaymentType paymentType,
      required DateTime date});

  Future<List<Order>> loadAllOrdersStorage();

  getAllPaymentsRemote();
  deletePaymentRemote();
  addPaymentRemote();
  editPaymentRemote();
  loadAllOrdersRemote();
}
