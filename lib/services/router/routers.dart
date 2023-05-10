/// Declare all routes which are used in this app
class Routers {
  //! Dashboard Routes
  static String get dashboardRoute => '/';
  static String get dashboardName => 'dashBoard';
  //! Brands Routes
  static String get brandsRoute => '/brands';
  static String get brandsName => 'brands';
  static String get newEditBrandRoute => ':newEditBrand';
  static String get newEditBrandName => 'newEditBrand';
  //! Stores Routes
  static String get storesRoute => '/stores';
  static String get storesName => 'stores';
  static String get newEditStoreRoute => ':newEditStore';
  static String get newEditStoreName => 'newEditStore';
  //! Products Routes
  static String get productsRoute => '/products';
  static String get productsName => 'products';
  static String get newEditProductRoute => ':newEditProduct';
  static String get newEditProductName => 'newEditProduct';
  //! Employees Routes
  static String get employeesRoute => '/employees';
  static String get employeesName => 'employees';
  static String get newEditEmployeeRoute => 'dataAddEdit/:newEditEmployee';
  static String get newEditEmployeeName => 'newEditEmployee';
  static String get employeeDetailsRoute => 'dataDetails/:employeeDetails';
  static String get employeeDetailsName => 'employeeDetails';
  //! Customers Routes
  static String get customerRoute => '/customers';
  static String get customerName => 'customers';
  static String get newEditCustomerRoute => 'dataAddEdit/:newEditCustomer';
  static String get newEditCustomerName => 'newEditCustomer';
  static String get customerDetailsRoute => 'dataDetails/:customerDetails';
  static String get customerDetailsName => 'customerDetails';
  //! Companies Routes
  static String get companyRoute => '/company';
  static String get companyName => 'company';
  static String get newEditCompanyRoute => ':newEditCompany';
  static String get newEditCompanyName => 'newEditCompany';
  //! Payments Routes
  static String get paymentsRoute => '/payments';
  static String get paymentsName => 'payments';
  static String get newEditPaymentsRoute => ':newEditPayment';
  static String get newEditPaymentsName => 'newEditPayment';
  //! Payouts Routes
  static String get payoutsRoute => '/payouts';
  static String get payoutsName => 'payouts';
  static String get newEditPayoutRoute => ':newEditPayout';
  static String get newEditPayoutName => 'newEditPayout';
  //! Orders Routes
  static String get ordersRoute => '/orders';
  static String get ordersName => 'orders';
  static String get newEditOrderRoute => ':newEditOrder';
  static String get newEditOrderName => 'newEditOrder';
  //! Settings Routes
  static String get settingsRoute => '/settings';
  static String get settingsName => 'settings';
}
