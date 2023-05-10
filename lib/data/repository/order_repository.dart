import 'package:injectable/injectable.dart' show Named, Injectable;

import '../../domain/entity/order.dart';
import '../../domain/entity/payment.dart';
import '../../domain/entity/product.dart';
import '../../domain/entity/product_order.dart';
import '../../domain/entity/user.dart';
import '../datasource/remote/business_api.dart';
import '../datasource/storage/storage_service.dart';

/// Repository to make all operations on storage and remote server
@Named('OrderRepository')
@Injectable()
class OrderRepository extends OrderRepositoryOperations {
  OrderRepository(@Named('BusinessApi') this.api,
      @Named('StorageService') this.storageService);

  final BusinessApi api;
  final StorageService storageService;

  //! Remote Functions
  /// add new order on the server
  @override
  addOrderRemote() {}

  /// Get orders data from server
  @override
  getAllOrdersRemote() {}

  /// delete the order on the server
  @override
  deleteOrderRemote() {}

  /// Get customers data from server
  @override
  getAllCustomersRemote() {}

  /// Get products data from server
  @override
  getAllProductsRemote() {}

  //! Storage Functions
  /// Get customers data from storage
  @override
  getAllCustomersStorage() => storageService.userBox
      .getAllCustomersStorage(filterIndexSort: 1, desc: false);

  /// Get products data from storage
  @override
  Future<List<Product>> getAllProductsStorage() => storageService.productBox
      .getAllProductsStorage(desc: false, filterIndexSort: 1);

  /// add new order on the storage
  @override
  Future<void> addOrderStorage(Order order, List<ProductOrder> productsOrders,
          List<Payment> payments) =>
      storageService.orderBox.addOrderStorage(order, productsOrders, payments);

  /// delete the order on the storage
  @override
  Future<void> deleteOrderStorage(int? id) =>
      storageService.orderBox.deleteOrderStorage(id);

  /// Get orders data from storage
  @override
  getAllOrdersStorage(
      {String? codeFilterController,
      double? greaterTotalPriceFilterController,
      double? lessTotalPriceFilterController,
      double? greaterPricePiecesFilterController,
      double? lessPricePiecesFilterController,
      double? greaterFinalPriceFilterController,
      double? lessFinalPriceFilterController,
      String? descriptionFilterController,
      DateTime? selectedStartDate,
      DateTime? selectedEndDate,
      TypeOrder? typeFilter,
      User? filterCustomer,
      int? filterIndexSort,
      bool? desc}) {
    return storageService.orderBox.getAllOrdersStorage(
        codeFilterController: codeFilterController,
        greaterTotalPriceFilterController: greaterTotalPriceFilterController,
        lessTotalPriceFilterController: lessTotalPriceFilterController,
        greaterPricePiecesFilterController: greaterPricePiecesFilterController,
        lessPricePiecesFilterController: lessPricePiecesFilterController,
        greaterFinalPriceFilterController: greaterFinalPriceFilterController,
        lessFinalPriceFilterController: lessFinalPriceFilterController,
        descriptionFilterController: descriptionFilterController,
        selectedStartDate: selectedStartDate,
        selectedEndDate: selectedEndDate,
        typeFilter: typeFilter,
        filterCustomer: filterCustomer,
        filterIndexSort: filterIndexSort,
        desc: desc);
  }
}

//! Define all repo's methods of Order
abstract class OrderRepositoryOperations {
  getAllOrdersStorage(
      {String? codeFilterController,
      double? greaterTotalPriceFilterController,
      double? lessTotalPriceFilterController,
      double? greaterPricePiecesFilterController,
      double? lessPricePiecesFilterController,
      double? greaterFinalPriceFilterController,
      double? lessFinalPriceFilterController,
      String? descriptionFilterController,
      DateTime? selectedStartDate,
      DateTime? selectedEndDate,
      TypeOrder? typeFilter,
      User? filterCustomer,
      int? filterIndexSort,
      bool? desc});

  Future<List<User>> getAllCustomersStorage();
  Future<List<Product>> getAllProductsStorage();

  Future<void> deleteOrderStorage(int? id);
  Future<void> addOrderStorage(
      Order order, List<ProductOrder> productsOrders, List<Payment> payments);

  getAllOrdersRemote();
  deleteOrderRemote();
  addOrderRemote();
  getAllCustomersRemote();
  getAllProductsRemote();
}
