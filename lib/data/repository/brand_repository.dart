import 'package:business_light/data/datasource/remote/business_api.dart';
import 'package:business_light/data/datasource/storage/storage_service.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/brand.dart';
import '../../domain/entity/status.dart';

/// Repository to make all operations on storage and remote server
@Named('BrandRepository')
@Injectable()
class BrandRepository implements BrandRepositoryOperations {
  BrandRepository(@Named('BusinessApi') this.api,
      @Named('StorageService') this.storageService);

  final BusinessApi api;
  final StorageService storageService;

  //! Remote Functions
  /// Get brands data from server
  @override
  getAllBrandsRemote() {}

  /// delete the brand on the server
  @override
  deleteBrandRemote() {}

  /// add new brand on the server
  @override
  addBrandRemote() {}

  /// edit the brand on the server
  @override
  editBrandRemote() {}

  //! Storage Functions
  /// Get brands data from storage
  @override
  Future<List<Brand>> getAllBrandsStorage(
      {String? filterName,
      Status? filterStatus,
      int? filterIndexSort,
      bool? desc}) {
    return storageService.brandBox.getAllBrands(
        filterName: filterName,
        filterStatus: filterStatus,
        filterIndexSort: filterIndexSort,
        desc: desc);
  }

  /// delete the brand on the storage
  @override
  deleteBrandStorage(int? id) => storageService.brandBox.deleteBrandStorage(id);

  /// add new brand on the storage
  @override
  Future<void> addBrandStorage(Brand brand) =>
      storageService.brandBox.addBrandStorage(brand);

  /// edit the brand on the storage
  @override
  Future<void> editBrandStorage(int? id, String name, Status statusAddEdit) =>
      storageService.brandBox.editBrandStorage(id, name, statusAddEdit);
}

//! Define all repo's methods of Brand
abstract class BrandRepositoryOperations {
  Future<List<Brand>> getAllBrandsStorage(
      {String? filterName,
      Status? filterStatus,
      int? filterIndexSort,
      bool? desc});

  Future<void> deleteBrandStorage(int? id);
  Future<void> addBrandStorage(Brand brand);
  Future<void> editBrandStorage(int? id, String name, Status statusAddEdit);

  getAllBrandsRemote();
  deleteBrandRemote();
  addBrandRemote();
  editBrandRemote();
}
