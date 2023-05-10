import 'package:business_light/app/pages/brand/brand_add_page.dart';
import 'package:business_light/app/pages/brand/brand_page.dart';
import 'package:business_light/app/pages/company/company_add_page.dart';
import 'package:business_light/app/pages/company/company_page.dart';
import 'package:business_light/app/pages/customer/customer_details.dart';
import 'package:business_light/app/pages/customer/customer_page.dart';
import 'package:business_light/app/pages/employees/employees_add_page.dart';
import 'package:business_light/app/pages/employees/employees_details.dart';
import 'package:business_light/app/pages/employees/employees_page.dart';
import 'package:business_light/app/pages/payment/payment_add_page.dart';
import 'package:business_light/app/pages/payment/payment_page.dart';
import 'package:business_light/app/pages/payout/payout_add_page.dart';
import 'package:business_light/app/pages/payout/payout_page.dart';
import 'package:business_light/app/pages/product/product_add_page.dart';
import 'package:business_light/app/pages/product/product_page.dart';
import 'package:business_light/app/pages/settings/settings_page.dart';
import 'package:business_light/app/pages/store/store_add_page.dart';
import 'package:business_light/app/pages/welcome/welcome_page.dart';
import 'package:business_light/domain/entity/company.dart';
import 'package:business_light/domain/entity/payment.dart';
import 'package:business_light/services/router/routers.dart';
import 'package:business_light/utils/resources_path.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:lottie/lottie.dart';

import '../../app/pages/customer/customer_add_page.dart';
import '../../app/pages/dashboard/dashboard_page.dart';
import '../../app/pages/order/order_add_page.dart';
import '../../app/pages/order/order_page.dart';
import '../../app/pages/store/store_page.dart';
import '../../domain/entity/brand.dart';
import '../../domain/entity/order.dart';
import '../../domain/entity/payout.dart';
import '../../domain/entity/product.dart';
import '../../domain/entity/store.dart';
import '../../domain/entity/user.dart';

/// Create [GoRouter] Object to manage routing
class RouteGenerator {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  /// Create [GoRouter] object
  static final GoRouter _router = GoRouter(
    // initialLocation: Routers.dashboardRoute,
    navigatorKey: _rootNavigatorKey,
    // observers: [NavigatorObserver()],
    errorBuilder: (context, state) => unknownScreen(),
    routes: [
      ShellRoute(
          // observers: [NavigatorObserver()],
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return WelcomePage(
              shellContext: _shellNavigatorKey.currentContext,
              state: state,
              child: child,
            );
          },
          routes: [
            //! DashBoard
            GoRoute(
              path: Routers.dashboardRoute,
              name: Routers.dashboardName,
              parentNavigatorKey: _shellNavigatorKey,
              pageBuilder: (context, state) => CustomSlideTransition(
                  key: state.pageKey,
                  restorationId: state.pageKey.value,
                  child: const DashboardPage()),
              // builder: (context, state) => const DashboardPage(),
            ),

            //! Brand
            GoRoute(
                path: Routers.brandsRoute,
                name: Routers.brandsName,
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (context, state) => CustomSlideTransition(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    child: const BrandPage()),
                // builder: (context, state) => BrandPage(),
                routes: [
                  /// New Edit Brand
                  GoRoute(
                    path: Routers.newEditBrandRoute,
                    name: Routers.newEditBrandName,
                    parentNavigatorKey: _shellNavigatorKey,
                    pageBuilder: (context, state) {
                      Brand? editBrand;
                      if (state.extra != null) {
                        editBrand = state.extra as Brand?;
                      }
                      return CustomSlideTransition(
                          key: state.pageKey,
                          restorationId: state.pageKey.value,
                          child: BrandAddPage(
                            isEdit: state.queryParams['isEdit'] ?? 'false',
                            pageNum: state.queryParams['pageNum'] ?? '0',
                            editBrand: editBrand,
                          ));
                    },
                    // builder: (context, state) {
                    //   Brand? editBrand;
                    //   if (state.extra != null) {
                    //     editBrand = state.extra as Brand?;
                    //   }
                    //   return BrandAddPage(
                    //     isEdit: state.queryParams['isEdit'] ?? 'false',
                    //     pageNum: state.queryParams['pageNum'] ?? '0',
                    //     editBrand: editBrand,
                    //   );
                    // }
                  ),
                ]),

            //! Store
            GoRoute(
                path: Routers.storesRoute,
                name: Routers.storesName,
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (context, state) => CustomSlideTransition(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    child: StorePage()),
                // builder: (context, state) => BrandPage(),
                routes: [
                  /// New Edit Store
                  GoRoute(
                    path: Routers.newEditStoreRoute,
                    name: Routers.newEditStoreName,
                    parentNavigatorKey: _shellNavigatorKey,
                    pageBuilder: (context, state) {
                      Store? editStore;
                      if (state.extra != null) {
                        editStore = state.extra as Store?;
                      }
                      return CustomSlideTransition(
                          key: state.pageKey,
                          restorationId: state.pageKey.value,
                          child: StoreAddPage(
                            isEdit: state.queryParams['isEdit'] ?? 'false',
                            pageNum: state.queryParams['pageNum'] ?? '0',
                            editStore: editStore,
                          ));
                    },
                    // builder: (context, state) {
                    //   Brand? editBrand;
                    //   if (state.extra != null) {
                    //     editBrand = state.extra as Brand?;
                    //   }
                    //   return BrandAddPage(
                    //     isEdit: state.queryParams['isEdit'] ?? 'false',
                    //     pageNum: state.queryParams['pageNum'] ?? '0',
                    //     editBrand: editBrand,
                    //   );
                    // }
                  ),
                ]),

            //! Products
            GoRoute(
                path: Routers.productsRoute,
                name: Routers.productsName,
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (context, state) => CustomSlideTransition(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    child: const ProductPage()),
                routes: [
                  /// New Edit Store
                  GoRoute(
                    path: Routers.newEditProductRoute,
                    name: Routers.newEditProductName,
                    parentNavigatorKey: _shellNavigatorKey,
                    pageBuilder: (context, state) {
                      Product? editProduct;
                      if (state.extra != null) {
                        editProduct = state.extra as Product?;
                      }
                      return CustomSlideTransition(
                          key: state.pageKey,
                          restorationId: state.pageKey.value,
                          child: ProductAddPage(
                            isEdit: state.queryParams['isEdit'] ?? 'false',
                            pageNum: state.queryParams['pageNum'] ?? '0',
                            editProduct: editProduct,
                          ));
                    },
                    // builder: (context, state) {
                    //   Brand? editBrand;
                    //   if (state.extra != null) {
                    //     editBrand = state.extra as Brand?;
                    //   }
                    //   return BrandAddPage(
                    //     isEdit: state.queryParams['isEdit'] ?? 'false',
                    //     pageNum: state.queryParams['pageNum'] ?? '0',
                    //     editBrand: editBrand,
                    //   );
                    // }
                  ),
                ]),

            //! Orders
            GoRoute(
                path: Routers.ordersRoute,
                name: Routers.ordersName,
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (context, state) => CustomSlideTransition(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    child: const OrderPage()),
                routes: [
                  /// New Edit Order
                  GoRoute(
                    path: Routers.newEditOrderRoute,
                    name: Routers.newEditOrderName,
                    parentNavigatorKey: _shellNavigatorKey,
                    pageBuilder: (context, state) {
                      Order? editOrder;
                      if (state.extra != null) {
                        editOrder = state.extra as Order?;
                      }
                      return CustomSlideTransition(
                          key: state.pageKey,
                          restorationId: state.pageKey.value,
                          child: OrderAddPage(
                            isEdit: state.queryParams['isEdit'] ?? 'false',
                            pageNum: state.queryParams['pageNum'] ?? '0',
                            editOrder: editOrder,
                          ));
                    },
                    // builder: (context, state) {
                    //   Brand? editBrand;
                    //   if (state.extra != null) {
                    //     editBrand = state.extra as Brand?;
                    //   }
                    //   return BrandAddPage(
                    //     isEdit: state.queryParams['isEdit'] ?? 'false',
                    //     pageNum: state.queryParams['pageNum'] ?? '0',
                    //     editBrand: editBrand,
                    //   );
                    // }
                  ),
                ]),

            //! Companies
            GoRoute(
                path: Routers.companyRoute,
                name: Routers.companyName,
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (context, state) => CustomSlideTransition(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    child: const CompanyPage()),
                routes: [
                  /// New Edit Employee
                  GoRoute(
                    path: Routers.newEditCompanyRoute,
                    name: Routers.newEditCompanyName,
                    parentNavigatorKey: _shellNavigatorKey,
                    pageBuilder: (context, state) {
                      Company? editCompany;
                      if (state.extra != null) {
                        editCompany = state.extra as Company?;
                      }
                      return CustomSlideTransition(
                          key: state.pageKey,
                          restorationId: state.pageKey.value,
                          child: CompanyAddPage(
                            isEdit: state.queryParams['isEdit'] ?? 'false',
                            pageNum: state.queryParams['pageNum'] ?? '0',
                            editCompany: editCompany,
                          ));
                    },
                    // builder: (context, state) {
                    //   Brand? editBrand;
                    //   if (state.extra != null) {
                    //     editBrand = state.extra as Brand?;
                    //   }
                    //   return BrandAddPage(
                    //     isEdit: state.queryParams['isEdit'] ?? 'false',
                    //     pageNum: state.queryParams['pageNum'] ?? '0',
                    //     editBrand: editBrand,
                    //   );
                    // }
                  ),
                ]),

            //! Employees
            GoRoute(
                path: Routers.employeesRoute,
                name: Routers.employeesName,
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (context, state) => CustomSlideTransition(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    child: const EmployeesPage()),
                routes: [
                  /// New Edit Employee
                  GoRoute(
                    path: Routers.newEditEmployeeRoute,
                    name: Routers.newEditEmployeeName,
                    parentNavigatorKey: _shellNavigatorKey,
                    pageBuilder: (context, state) {
                      User? editEmployee;
                      if (state.extra != null) {
                        editEmployee = state.extra as User?;
                      }
                      return CustomSlideTransition(
                          key: state.pageKey,
                          restorationId: state.pageKey.value,
                          child: EmployeesAddPage(
                            isEdit: state.queryParams['isEdit'] ?? 'false',
                            pageNum: state.queryParams['pageNum'] ?? '0',
                            editUser: editEmployee,
                          ));
                    },
                    // builder: (context, state) {
                    //   Brand? editBrand;
                    //   if (state.extra != null) {
                    //     editBrand = state.extra as Brand?;
                    //   }
                    //   return BrandAddPage(
                    //     isEdit: state.queryParams['isEdit'] ?? 'false',
                    //     pageNum: state.queryParams['pageNum'] ?? '0',
                    //     editBrand: editBrand,
                    //   );
                    // }
                  ),

                  /// Employee Details
                  GoRoute(
                    path: Routers.employeeDetailsRoute,
                    name: Routers.employeeDetailsName,
                    parentNavigatorKey: _shellNavigatorKey,
                    pageBuilder: (context, state) {
                      User? employeeDetails;
                      if (state.extra != null) {
                        employeeDetails = state.extra as User?;
                      }
                      return CustomSlideTransition(
                          key: state.pageKey,
                          restorationId: state.pageKey.value,
                          child: EmployeesDetails(
                            isEmployee: 'true',
                            userDetails: employeeDetails,
                          ));
                    },
                    // builder: (context, state) {
                    //   Brand? editBrand;
                    //   if (state.extra != null) {
                    //     editBrand = state.extra as Brand?;
                    //   }
                    //   return BrandAddPage(
                    //     isEdit: state.queryParams['isEdit'] ?? 'false',
                    //     pageNum: state.queryParams['pageNum'] ?? '0',
                    //     editBrand: editBrand,
                    //   );
                    // }
                  ),
                ]),

            //! Customers
            GoRoute(
                path: Routers.customerRoute,
                name: Routers.customerName,
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (context, state) => CustomSlideTransition(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    child: const CustomerPage()),
                routes: [
                  /// Customer Details
                  GoRoute(
                    path: Routers.customerDetailsRoute,
                    name: Routers.customerDetailsName,
                    parentNavigatorKey: _shellNavigatorKey,
                    pageBuilder: (context, state) {
                      User? customerDetails;
                      if (state.extra != null) {
                        customerDetails = state.extra as User?;
                      }
                      return CustomSlideTransition(
                          key: state.pageKey,
                          restorationId: state.pageKey.value,
                          child: CustomerDetails(userDetails: customerDetails));
                    },
                    // builder: (context, state) {
                    //   Brand? editBrand;
                    //   if (state.extra != null) {
                    //     editBrand = state.extra as Brand?;
                    //   }
                    //   return BrandAddPage(
                    //     isEdit: state.queryParams['isEdit'] ?? 'false',
                    //     pageNum: state.queryParams['pageNum'] ?? '0',
                    //     editBrand: editBrand,
                    //   );
                    // }
                  ),

                  /// New Edit Customer
                  GoRoute(
                    path: Routers.newEditCustomerRoute,
                    name: Routers.newEditCustomerName,
                    parentNavigatorKey: _shellNavigatorKey,
                    pageBuilder: (context, state) {
                      User? editCustomer;
                      if (state.extra != null) {
                        editCustomer = state.extra as User?;
                      }
                      return CustomSlideTransition(
                          key: state.pageKey,
                          restorationId: state.pageKey.value,
                          child: CustomerAddPage(
                            isEdit: state.queryParams['isEdit'] ?? 'false',
                            pageNum: state.queryParams['pageNum'] ?? '0',
                            editUser: editCustomer,
                          ));
                    },
                    // builder: (context, state) {
                    //   Brand? editBrand;
                    //   if (state.extra != null) {
                    //     editBrand = state.extra as Brand?;
                    //   }
                    //   return BrandAddPage(
                    //     isEdit: state.queryParams['isEdit'] ?? 'false',
                    //     pageNum: state.queryParams['pageNum'] ?? '0',
                    //     editBrand: editBrand,
                    //   );
                    // }
                  ),
                ]),

            //! Payments
            GoRoute(
                path: Routers.paymentsRoute,
                name: Routers.paymentsName,
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (context, state) => CustomSlideTransition(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    child: const PaymentPage()),
                routes: [
                  /// New Edit Payment
                  GoRoute(
                    path: Routers.newEditPaymentsRoute,
                    name: Routers.newEditPaymentsName,
                    parentNavigatorKey: _shellNavigatorKey,
                    pageBuilder: (context, state) {
                      Payment? editPayment;
                      if (state.extra != null) {
                        editPayment = state.extra as Payment?;
                      }
                      return CustomSlideTransition(
                          key: state.pageKey,
                          restorationId: state.pageKey.value,
                          child: PaymentAddPage(
                            isEdit: state.queryParams['isEdit'] ?? 'false',
                            pageNum: state.queryParams['pageNum'] ?? '0',
                            paymentType: state.queryParams['paymentType'] ??
                                PaymentType.other.name.tr(),
                            editPayment: editPayment,
                          ));
                    },
                    // builder: (context, state) {
                    //   Brand? editBrand;
                    //   if (state.extra != null) {
                    //     editBrand = state.extra as Brand?;
                    //   }
                    //   return BrandAddPage(
                    //     isEdit: state.queryParams['isEdit'] ?? 'false',
                    //     pageNum: state.queryParams['pageNum'] ?? '0',
                    //     editBrand: editBrand,
                    //   );
                    // }
                  ),
                ]),

            //! Payouts
            GoRoute(
                path: Routers.payoutsRoute,
                name: Routers.payoutsName,
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (context, state) => CustomSlideTransition(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    child: const PayoutPage()),
                routes: [
                  /// New Edit Payout
                  GoRoute(
                    path: Routers.newEditPayoutRoute,
                    name: Routers.newEditPayoutName,
                    parentNavigatorKey: _shellNavigatorKey,
                    pageBuilder: (context, state) {
                      Payout? editPayout;
                      if (state.extra != null) {
                        editPayout = state.extra as Payout?;
                      }
                      return CustomSlideTransition(
                          key: state.pageKey,
                          restorationId: state.pageKey.value,
                          child: PayoutAddPage(
                            isEdit: state.queryParams['isEdit'] ?? 'false',
                            pageNum: state.queryParams['pageNum'] ?? '0',
                            payoutType: state.queryParams['payoutType'] ??
                                PayoutType.other.name.tr(),
                            editPayout: editPayout,
                          ));
                    },
                    // builder: (context, state) {
                    //   Brand? editBrand;
                    //   if (state.extra != null) {
                    //     editBrand = state.extra as Brand?;
                    //   }
                    //   return BrandAddPage(
                    //     isEdit: state.queryParams['isEdit'] ?? 'false',
                    //     pageNum: state.queryParams['pageNum'] ?? '0',
                    //     editBrand: editBrand,
                    //   );
                    // }
                  ),
                ]),

            //! Settings
            GoRoute(
                path: Routers.settingsRoute,
                name: Routers.settingsName,
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (context, state) => CustomSlideTransition(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    child: SettingsPage())),
          ]),
    ],
  );

  static GoRouter get routerClient => _router;

  /// Make custom widget to unknown route
  static Widget unknownScreen() {
    return ScaffoldPage.withPadding(
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 250,
                height: 250,
                child: Lottie.asset(
                  ResourcesPath.notFoundPage,
                  width: 250,
                  height: 250,
                )), //SvgPicture.asset(ResourcesPath.notFoundPage)
            const SizedBox(
              height: 20,
            ),
            Text(
              "page_not_found".tr(),
              style: const TextStyle(
                fontSize: 18,
              ),
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// Create custom animation when navigate to next screen
class CustomSlideTransition extends CustomTransitionPage<void> {
  CustomSlideTransition(
      {super.key, required super.child, String? restorationId})
      : super(
          restorationId: restorationId,
          transitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: animation.drive(
                  Tween(
                    begin: const Offset(0, 2),
                    end: Offset.zero,
                  ).chain(
                    CurveTween(curve: Curves.ease),
                  ),
                ),
                child: child,
              ),
            );
          },
        );
}
