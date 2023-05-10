// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:business_light/app/viewmodels/brand_view_model.dart' as _i48;
import 'package:business_light/app/viewmodels/company_view_model.dart' as _i18;
import 'package:business_light/app/viewmodels/customer_view_model.dart' as _i21;
import 'package:business_light/app/viewmodels/dashboard_view_model.dart'
    as _i24;
import 'package:business_light/app/viewmodels/employees_view_model.dart'
    as _i27;
import 'package:business_light/app/viewmodels/order_view_model.dart' as _i30;
import 'package:business_light/app/viewmodels/payment_view_model.dart' as _i33;
import 'package:business_light/app/viewmodels/payout_view_model.dart' as _i36;
import 'package:business_light/app/viewmodels/product_view_model.dart' as _i39;
import 'package:business_light/app/viewmodels/settings_view_model.dart' as _i42;
import 'package:business_light/app/viewmodels/store_view_model.dart' as _i45;
import 'package:business_light/data/datasource/remote/business_api.dart'
    as _i15;
import 'package:business_light/data/datasource/storage/storage_service.dart'
    as _i13;
import 'package:business_light/data/repository/brand_repository.dart' as _i46;
import 'package:business_light/data/repository/company_repository.dart' as _i16;
import 'package:business_light/data/repository/customer_repository.dart'
    as _i19;
import 'package:business_light/data/repository/dashboard_repository.dart'
    as _i22;
import 'package:business_light/data/repository/employees_repository.dart'
    as _i25;
import 'package:business_light/data/repository/order_repository.dart' as _i28;
import 'package:business_light/data/repository/payment_repository.dart' as _i31;
import 'package:business_light/data/repository/payout_repository.dart' as _i34;
import 'package:business_light/data/repository/product_repository.dart' as _i37;
import 'package:business_light/data/repository/settings_repository.dart'
    as _i40;
import 'package:business_light/data/repository/store_repository.dart' as _i43;
import 'package:business_light/domain/mapper/brand_mapper.dart' as _i3;
import 'package:business_light/domain/mapper/company_mapper.dart' as _i4;
import 'package:business_light/domain/mapper/customer_mapper.dart' as _i5;
import 'package:business_light/domain/mapper/dashboard_mapper.dart' as _i6;
import 'package:business_light/domain/mapper/employees_mapper.dart' as _i8;
import 'package:business_light/domain/mapper/order_mapper.dart' as _i9;
import 'package:business_light/domain/mapper/payment_mapper.dart' as _i10;
import 'package:business_light/domain/mapper/payout_mapper.dart' as _i11;
import 'package:business_light/domain/mapper/product_mapper.dart' as _i12;
import 'package:business_light/domain/mapper/store_mapper.dart' as _i14;
import 'package:business_light/domain/usecase/brand_use_case.dart' as _i47;
import 'package:business_light/domain/usecase/company_use_case.dart' as _i17;
import 'package:business_light/domain/usecase/customer_use_case.dart' as _i20;
import 'package:business_light/domain/usecase/dashboard_use_case.dart' as _i23;
import 'package:business_light/domain/usecase/employees_use_case.dart' as _i26;
import 'package:business_light/domain/usecase/order_use_case.dart' as _i29;
import 'package:business_light/domain/usecase/payment_use_case.dart' as _i32;
import 'package:business_light/domain/usecase/payout_use_case.dart' as _i35;
import 'package:business_light/domain/usecase/product_use_case.dart' as _i38;
import 'package:business_light/domain/usecase/settings_use_case.dart' as _i41;
import 'package:business_light/domain/usecase/store_use_case.dart' as _i44;
import 'package:business_light/services/di/app_module.dart' as _i49;
import 'package:business_light/services/dio/dio_service.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

const String _dev = 'dev';
const String _test = 'test';
const String _prod = 'prod';

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.factory<_i3.BrandMapper>(
      () => _i3.BrandMapper(),
      instanceName: 'BrandMapper',
    );
    gh.factory<_i4.CompanyMapper>(
      () => _i4.CompanyMapper(),
      instanceName: 'CompanyMapper',
    );
    gh.factory<_i5.CustomerMapper>(
      () => _i5.CustomerMapper(),
      instanceName: 'CustomerMapper',
    );
    gh.factory<_i6.DashboardMapper>(
      () => _i6.DashboardMapper(),
      instanceName: 'DashboardMapper',
    );
    gh.lazySingleton<_i7.DioService>(() => appModule.remote);
    gh.lazySingleton<_i7.DioService>(
      () => _i7.DioService(),
      instanceName: 'DioService',
    );
    gh.factory<_i8.EmployeesMapper>(
      () => _i8.EmployeesMapper(),
      instanceName: 'EmployeesMapper',
    );
    gh.factory<_i9.OrderMapper>(
      () => _i9.OrderMapper(),
      instanceName: 'OrderMapper',
    );
    gh.factory<_i10.PaymentMapper>(
      () => _i10.PaymentMapper(),
      instanceName: 'PaymentMapper',
    );
    gh.factory<_i11.PayoutMapper>(
      () => _i11.PayoutMapper(),
      instanceName: 'PayoutMapper',
    );
    gh.factory<_i12.ProductMapper>(
      () => _i12.ProductMapper(),
      instanceName: 'ProductMapper',
    );
    gh.lazySingleton<_i13.StorageService>(
      () => _i13.StorageService(),
      instanceName: 'StorageService',
      registerFor: {
        _dev,
        _test,
        _prod,
      },
    );
    gh.lazySingleton<_i13.StorageService>(() => appModule.storage);
    gh.factory<_i14.StoreMapper>(
      () => _i14.StoreMapper(),
      instanceName: 'StoreMapper',
    );
    gh.lazySingleton<_i15.BusinessApi>(
      () => _i15.BusinessApi(gh<_i7.DioService>(instanceName: 'DioService')),
      instanceName: 'BusinessApi',
      registerFor: {
        _dev,
        _test,
        _prod,
      },
    );
    gh.factory<_i16.CompanyRepository>(
      () => _i16.CompanyRepository(
        gh<_i15.BusinessApi>(instanceName: 'BusinessApi'),
        gh<_i13.StorageService>(instanceName: 'StorageService'),
      ),
      instanceName: 'CompanyRepository',
    );
    gh.factory<_i17.CompanyUseCase>(
      () => _i17.CompanyUseCase(
        gh<_i16.CompanyRepository>(instanceName: 'CompanyRepository'),
        gh<_i4.CompanyMapper>(instanceName: 'CompanyMapper'),
      ),
      instanceName: 'CompanyUseCase',
    );
    gh.factory<_i18.CompanyViewModel>(() => _i18.CompanyViewModel(
        gh<_i17.CompanyUseCase>(instanceName: 'CompanyUseCase')));
    gh.factory<_i19.CustomerRepository>(
      () => _i19.CustomerRepository(
        gh<_i15.BusinessApi>(instanceName: 'BusinessApi'),
        gh<_i13.StorageService>(instanceName: 'StorageService'),
      ),
      instanceName: 'CustomerRepository',
    );
    gh.factory<_i20.CustomerUseCase>(
      () => _i20.CustomerUseCase(
        gh<_i19.CustomerRepository>(instanceName: 'CustomerRepository'),
        gh<_i5.CustomerMapper>(instanceName: 'CustomerMapper'),
      ),
      instanceName: 'CustomerUseCase',
    );
    gh.factory<_i21.CustomerViewModel>(() => _i21.CustomerViewModel(
        gh<_i20.CustomerUseCase>(instanceName: 'CustomerUseCase')));
    gh.factory<_i22.DashboardRepository>(
      () => _i22.DashboardRepository(
        gh<_i15.BusinessApi>(instanceName: 'BusinessApi'),
        gh<_i13.StorageService>(instanceName: 'StorageService'),
      ),
      instanceName: 'DashboardRepository',
    );
    gh.factory<_i23.DashboardUseCase>(
      () => _i23.DashboardUseCase(
        gh<_i22.DashboardRepository>(instanceName: 'DashboardRepository'),
        gh<_i6.DashboardMapper>(instanceName: 'DashboardMapper'),
      ),
      instanceName: 'DashboardUseCase',
    );
    gh.factory<_i24.DashboardViewModel>(() => _i24.DashboardViewModel(
        gh<_i23.DashboardUseCase>(instanceName: 'DashboardUseCase')));
    gh.factory<_i25.EmployeesRepository>(
      () => _i25.EmployeesRepository(
        gh<_i15.BusinessApi>(instanceName: 'BusinessApi'),
        gh<_i13.StorageService>(instanceName: 'StorageService'),
      ),
      instanceName: 'EmployeesRepository',
    );
    gh.factory<_i26.EmployeesUseCase>(
      () => _i26.EmployeesUseCase(
        gh<_i25.EmployeesRepository>(instanceName: 'EmployeesRepository'),
        gh<_i8.EmployeesMapper>(instanceName: 'EmployeesMapper'),
      ),
      instanceName: 'EmployeesUseCase',
    );
    gh.factory<_i27.EmployeesViewModel>(() => _i27.EmployeesViewModel(
        gh<_i26.EmployeesUseCase>(instanceName: 'EmployeesUseCase')));
    gh.factory<_i28.OrderRepository>(
      () => _i28.OrderRepository(
        gh<_i15.BusinessApi>(instanceName: 'BusinessApi'),
        gh<_i13.StorageService>(instanceName: 'StorageService'),
      ),
      instanceName: 'OrderRepository',
    );
    gh.factory<_i29.OrderUseCase>(
      () => _i29.OrderUseCase(
        gh<_i28.OrderRepository>(instanceName: 'OrderRepository'),
        gh<_i9.OrderMapper>(instanceName: 'OrderMapper'),
      ),
      instanceName: 'OrderUseCase',
    );
    gh.factory<_i30.OrderViewModel>(() => _i30.OrderViewModel(
        gh<_i29.OrderUseCase>(instanceName: 'OrderUseCase')));
    gh.factory<_i31.PaymentRepository>(
      () => _i31.PaymentRepository(
        gh<_i15.BusinessApi>(instanceName: 'BusinessApi'),
        gh<_i13.StorageService>(instanceName: 'StorageService'),
      ),
      instanceName: 'PaymentRepository',
    );
    gh.factory<_i32.PaymentUseCase>(
      () => _i32.PaymentUseCase(
        gh<_i31.PaymentRepository>(instanceName: 'PaymentRepository'),
        gh<_i10.PaymentMapper>(instanceName: 'PaymentMapper'),
      ),
      instanceName: 'PaymentUseCase',
    );
    gh.factory<_i33.PaymentViewModel>(() => _i33.PaymentViewModel(
        gh<_i32.PaymentUseCase>(instanceName: 'PaymentUseCase')));
    gh.factory<_i34.PayoutRepository>(
      () => _i34.PayoutRepository(
        gh<_i15.BusinessApi>(instanceName: 'BusinessApi'),
        gh<_i13.StorageService>(instanceName: 'StorageService'),
      ),
      instanceName: 'PayoutRepository',
    );
    gh.factory<_i35.PayoutUseCase>(
      () => _i35.PayoutUseCase(
        gh<_i34.PayoutRepository>(instanceName: 'PayoutRepository'),
        gh<_i11.PayoutMapper>(instanceName: 'PayoutMapper'),
      ),
      instanceName: 'PayoutUseCase',
    );
    gh.factory<_i36.PayoutViewModel>(() => _i36.PayoutViewModel(
        gh<_i35.PayoutUseCase>(instanceName: 'PayoutUseCase')));
    gh.factory<_i37.ProductRepository>(
      () => _i37.ProductRepository(
        gh<_i15.BusinessApi>(instanceName: 'BusinessApi'),
        gh<_i13.StorageService>(instanceName: 'StorageService'),
      ),
      instanceName: 'ProductRepository',
    );
    gh.factory<_i38.ProductUseCase>(
      () => _i38.ProductUseCase(
        gh<_i37.ProductRepository>(instanceName: 'ProductRepository'),
        gh<_i12.ProductMapper>(instanceName: 'ProductMapper'),
      ),
      instanceName: 'ProductUseCase',
    );
    gh.factory<_i39.ProductViewModel>(() => _i39.ProductViewModel(
        gh<_i38.ProductUseCase>(instanceName: 'ProductUseCase')));
    gh.factory<_i40.SettingsRepository>(
      () => _i40.SettingsRepository(
          gh<_i13.StorageService>(instanceName: 'StorageService')),
      instanceName: 'SettingsRepository',
    );
    gh.factory<_i41.SettingsUseCase>(
      () => _i41.SettingsUseCase(
          gh<_i40.SettingsRepository>(instanceName: 'SettingsRepository')),
      instanceName: 'SettingsUseCase',
    );
    gh.factory<_i42.SettingsViewModel>(() => _i42.SettingsViewModel(
        gh<_i41.SettingsUseCase>(instanceName: 'SettingsUseCase')));
    gh.factory<_i43.StoreRepository>(
      () => _i43.StoreRepository(
        gh<_i15.BusinessApi>(instanceName: 'BusinessApi'),
        gh<_i13.StorageService>(instanceName: 'StorageService'),
      ),
      instanceName: 'StoreRepository',
    );
    gh.factory<_i44.StoreUseCase>(
      () => _i44.StoreUseCase(
        gh<_i43.StoreRepository>(instanceName: 'StoreRepository'),
        gh<_i14.StoreMapper>(instanceName: 'StoreMapper'),
      ),
      instanceName: 'StoreUseCase',
    );
    gh.factory<_i45.StoreViewModel>(() => _i45.StoreViewModel(
        gh<_i44.StoreUseCase>(instanceName: 'StoreUseCase')));
    gh.factory<_i46.BrandRepository>(
      () => _i46.BrandRepository(
        gh<_i15.BusinessApi>(instanceName: 'BusinessApi'),
        gh<_i13.StorageService>(instanceName: 'StorageService'),
      ),
      instanceName: 'BrandRepository',
    );
    gh.factory<_i47.BrandUseCase>(
      () => _i47.BrandUseCase(
        gh<_i46.BrandRepository>(instanceName: 'BrandRepository'),
        gh<_i3.BrandMapper>(instanceName: 'BrandMapper'),
      ),
      instanceName: 'BrandUseCase',
    );
    gh.factory<_i48.BrandViewModel>(() => _i48.BrandViewModel(
        gh<_i47.BrandUseCase>(instanceName: 'BrandUseCase')));
    return this;
  }
}

class _$AppModule extends _i49.AppModule {}
