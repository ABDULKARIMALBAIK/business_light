import 'dart:core';
import 'dart:developer';
import 'package:business_light/data/datasource/storage/box/company_box.dart';
import 'package:business_light/data/datasource/storage/box/global_box.dart';
import 'package:business_light/data/datasource/storage/box/product_box.dart';
import 'package:business_light/domain/entity/attribute.dart';
import 'package:business_light/domain/entity/brand.dart';
import 'package:business_light/domain/entity/pack.dart';
import 'package:business_light/domain/entity/company.dart';
import 'package:business_light/domain/entity/currency.dart';
import 'package:business_light/domain/entity/debt.dart';
import 'package:business_light/domain/entity/global.dart';
import 'package:business_light/domain/entity/note.dart';
import 'package:business_light/domain/entity/order.dart';
import 'package:business_light/domain/entity/page.dart';
import 'package:business_light/domain/entity/payment.dart';
import 'package:business_light/domain/entity/payout.dart';
import 'package:business_light/domain/entity/product.dart';
import 'package:business_light/domain/entity/product_order.dart';
import 'package:business_light/domain/entity/store.dart';
import 'package:business_light/domain/entity/user.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import 'box/brand_box.dart';
import 'box/dashboard_box.dart';
import 'box/order_box.dart';
import 'box/payment_box.dart';
import 'box/payout_box.dart';
import 'box/store_box.dart';
import 'box/user_box.dart';

/// Storage service to create database and make all operations on database
@dev
@test
@prod
@Named('StorageService')
@LazySingleton()
class StorageService {
  //! Boxes
  static late final GlobalBox _globalBox;
  static late final BrandBox _brandBox;
  static late final StoreBox _storeBox;
  static late final ProductBox _productBox;
  static late final UserBox _userBox;
  static late final CompanyBox _companyBox;
  static late final PaymentBox _paymentBox;
  static late final PayoutBox _payoutBox;
  static late final OrderBox _orderBox;
  static late final DashboardBox _dashboardBox;
  late final Isar store;

  //! Methods
  /// Create and open database
  Future<void> openDatabaseStore({Isar? storeIsolate}) async {
    try {
      if (storeIsolate != null) {
        store = storeIsolate;
      } else {
        store = await Isar.open(schemas());
        log("Database Store opened successfully");
      }

      await initBoxes();
    } catch (e) {
      log("ObjectBoxException from openDatabaseStore: $e");
    }
  }

  /// Initial all boxes
  Future<void> initBoxes() async {
    _globalBox = GlobalBox(store);
    _brandBox = BrandBox(store);
    _storeBox = StoreBox(store);
    _productBox = ProductBox(store);
    _userBox = UserBox(store);
    _companyBox = CompanyBox(store);
    _paymentBox = PaymentBox(store);
    _payoutBox = PayoutBox(store);
    _orderBox = OrderBox(store);
    _dashboardBox = DashboardBox(store);
  }

  /// Setup schemas to create database
  List<CollectionSchema<dynamic>> schemas() {
    return [
      GlobalSchema,
      AttributeSchema,
      AttributeDetailsSchema,
      BrandSchema,
      PackSchema,
      CompanySchema,
      CurrencySchema,
      DebtSchema,
      NoteSchema,
      OrderSchema,
      PageSchema,
      PaymentSchema,
      PayoutSchema,
      ProductSchema,
      StoreSchema,
      UserSchema,
      ProductOrderSchema
    ];
  }

  //! Operations Database
  /// Check if database is opened or not
  bool isOpen() => store.isOpen;

  /// Close database
  Future<bool> close() => store.close();

  /// Size of database
  Future<int> size() => store.getSize();

  /// Clear data from database
  Future<void> clearDB() async {
    // store.clear();
    await store.brands.clear();
    await store.stores.clear();
    await store.products.clear();
    await store.productOrders.clear();
    await store.products.clear();
    await store.users.clear();
    await store.companys.clear();
    await store.payments.clear();
    await store.payouts.clear();
    await store.debts.clear();
  }

  //! Getter Boxes
  GlobalBox get globalBox => _globalBox;
  BrandBox get brandBox => _brandBox;
  StoreBox get storeBox => _storeBox;
  ProductBox get productBox => _productBox;
  UserBox get userBox => _userBox;
  CompanyBox get companyBox => _companyBox;
  PaymentBox get paymentBox => _paymentBox;
  PayoutBox get payoutBox => _payoutBox;
  OrderBox get orderBox => _orderBox;
  DashboardBox get dashboardBox => _dashboardBox;
}
