import 'package:business_light/data/datasource/remote/box/brand_box.dart';
import 'package:business_light/data/datasource/remote/box/company_box.dart';
import 'package:business_light/data/datasource/remote/box/dashboard_box.dart';
import 'package:business_light/data/datasource/remote/box/order_box.dart';
import 'package:business_light/data/datasource/remote/box/payment_box.dart';
import 'package:business_light/data/datasource/remote/box/payout_box.dart';
import 'package:business_light/data/datasource/remote/box/product_box.dart';
import 'package:business_light/data/datasource/remote/box/store_box.dart';
import 'package:business_light/data/datasource/remote/box/user_box.dart';
import 'package:injectable/injectable.dart';

import '../../../services/dio/dio_service.dart';

/// Remote service to connect to backend and make all operations on remote database
@dev
@test
@prod
@Named('BusinessApi')
@LazySingleton()
class BusinessApi {
  BusinessApi(@Named('DioService') this.dioService) {
    //! Init Boxes
    _brandBox = BrandBox(dioService);
    _companyBox = CompanyBox(dioService);
    _dashboardBox = DashboardBox(dioService);
    _orderBox = OrderBox(dioService);
    _paymentBox = PaymentBox(dioService);
    _payoutBox = PayoutBox(dioService);
    _productBox = ProductBox(dioService);
    _storeBox = StoreBox(dioService);
    _userBox = UserBox(dioService);
  }

  final DioService dioService;

  //! Boxes
  late BrandBox _brandBox;
  late CompanyBox _companyBox;
  late DashboardBox _dashboardBox;
  late OrderBox _orderBox;
  late PaymentBox _paymentBox;
  late PayoutBox _payoutBox;
  late ProductBox _productBox;
  late StoreBox _storeBox;
  late UserBox _userBox;

  //! Getters Boxes
  BrandBox get brandBox => _brandBox;
  CompanyBox get companyBox => _companyBox;
  DashboardBox get dashboardBox => _dashboardBox;
  OrderBox get orderBox => _orderBox;
  PaymentBox get paymentBox => _paymentBox;
  PayoutBox get payoutBox => _payoutBox;
  ProductBox get productBox => _productBox;
  StoreBox get storeBox => _storeBox;
  UserBox get userBox => _userBox;
}
