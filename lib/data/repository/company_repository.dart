import 'package:injectable/injectable.dart';

import '../../domain/entity/company.dart';
import '../datasource/remote/business_api.dart';
import '../datasource/storage/storage_service.dart';

/// Repository to make all operations on storage and remote server
@Named('CompanyRepository')
@Injectable()
class CompanyRepository extends CompanyRepositoryOperations {
  CompanyRepository(@Named('BusinessApi') this.api,
      @Named('StorageService') this.storageService);

  final BusinessApi api;
  final StorageService storageService;

  //! Remote Functions
  /// add new company on the server
  @override
  addCompanyRemote() {}

  /// delete the company on the server
  @override
  deleteCompanyRemote() {}

  /// edit the company on the server
  @override
  editCompanyRemote() {}

  /// Get companies data from server
  @override
  getAllCompaniesRemote() {}

  //! Storage Functions
  /// add new company on the storage
  @override
  Future<void> addCompanyStorage(Company company) async =>
      storageService.companyBox.addCompanyStorage(company);

  /// edit the company on the storage
  @override
  Future<void> editCompanyStorage(
          {required int? id,
          required String name,
          required String email,
          required String phone,
          required String address,
          required String imagePath,
          required String country,
          required String bio}) async =>
      storageService.companyBox.editCompanyStorage(
          id: id,
          name: name,
          email: email,
          phone: phone,
          address: address,
          imagePath: imagePath,
          country: country,
          bio: bio);

  /// delete the company on the storage
  @override
  Future<void> deleteCompanyStorage(int? id) async =>
      storageService.companyBox.deleteCompanyStorage(id);

  /// Get companies data from storage
  @override
  Future<List<Company>> getAllCompaniesStorage(
      {String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterAddress,
      String? filterCountry,
      String? filterBio,
      int? filterIndexSort,
      bool? desc}) {
    return storageService.companyBox.getAllCompaniesStorage(
      filterName: filterName,
      filterEmail: filterEmail,
      filterPhone: filterPhone,
      filterAddress: filterAddress,
      filterCountry: filterCountry,
      filterBio: filterBio,
      filterIndexSort: filterIndexSort,
      desc: desc,
    );
  }
}

//! Define all repo's methods of Company
abstract class CompanyRepositoryOperations {
  Future<List<Company>> getAllCompaniesStorage(
      {String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterAddress,
      String? filterCountry,
      String? filterBio,
      int? filterIndexSort,
      bool? desc});

  Future<void> deleteCompanyStorage(int? id);
  Future<void> addCompanyStorage(Company company);
  Future<void> editCompanyStorage(
      {required int? id,
      required String name,
      required String email,
      required String phone,
      required String address,
      required String imagePath,
      required String country,
      required String bio});

  getAllCompaniesRemote();
  deleteCompanyRemote();
  addCompanyRemote();
  editCompanyRemote();
}
