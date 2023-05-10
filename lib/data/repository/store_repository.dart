import 'package:business_light/domain/entity/store.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/status.dart';
import '../datasource/remote/business_api.dart';
import '../datasource/storage/storage_service.dart';

/// Repository to make all operations on storage and remote server
@Named('StoreRepository')
@Injectable()
class StoreRepository extends StoreRepositoryOperations {
  StoreRepository(@Named('BusinessApi') this.api,
      @Named('StorageService') this.storageService);

  final BusinessApi api;
  final StorageService storageService;

  //! Remote Functions
  /// Get stores data from server
  @override
  getAllStoresRemote() {}

  /// delete the store on the server
  @override
  deleteStoreRemote() {}

  /// add new store on the server
  @override
  addStoreRemote() {}

  /// edit the store on the server
  @override
  editStoreRemote() {}

  //! Storage Functions
  /// Get stores data from storage
  @override
  Future<List<Store>> getAllStoresStorage(
      {String? filterName,
      Status? filterStatus,
      String? filterCode,
      int? filterIndexSort,
      bool? desc}) {
    return storageService.storeBox.getAllStores(
        filterName: filterName,
        filterStatus: filterStatus,
        filterCode: filterCode,
        filterIndexSort: filterIndexSort,
        desc: desc);
  }

  /// add new store on the storage
  @override
  Future<void> addStoreStorage(Store store) =>
      storageService.storeBox.addStoreStorage(store);

  /// delete the store on the storage
  @override
  deleteStoreStorage(int? id) => storageService.storeBox.deleteStoreStorage(id);

  /// edit the store on the storage
  @override
  Future<void> editStoreStorage(
          int? id, String name, String code, Status statusAddEdit) =>
      storageService.storeBox.editStoreStorage(id, name, code, statusAddEdit);
}

//! Define all repo's methods of Store
abstract class StoreRepositoryOperations {
  Future<List<Store>> getAllStoresStorage(
      {String? filterName,
      Status? filterStatus,
      String? filterCode,
      int? filterIndexSort,
      bool? desc});

  Future<void> deleteStoreStorage(int? id);
  Future<void> addStoreStorage(Store store);
  Future<void> editStoreStorage(
      int? id, String name, String code, Status statusAddEdit);

  getAllStoresRemote();
  deleteStoreRemote();
  addStoreRemote();
  editStoreRemote();
}
