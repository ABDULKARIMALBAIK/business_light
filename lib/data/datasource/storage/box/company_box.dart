import 'dart:developer';

import 'package:business_light/domain/entity/company.dart';
import 'package:isar/isar.dart';

// Storage Box to make operations on Companies
class CompanyBox extends CompanyBoxBoxOperations {
  CompanyBox(this._store);

  final Isar _store;

  /// add new company on the storage
  @override
  Future<void> addCompanyStorage(Company company) async {
    await _store.writeTxn(() async {
      await _store.companys.put(company);
    });
  }

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
      required String bio}) async {
    await _store.writeTxn(() async {
      final editCompany = await _store.companys.get(id!);

      editCompany!.name = name;
      editCompany.email = email;
      editCompany.phone = phone;
      editCompany.address = address;
      editCompany.imagePath = imagePath;
      editCompany.country = country;
      editCompany.bio = bio;
      await _store.companys.put(editCompany);
    });
  }

  /// delete the company on the storage
  @override
  Future<void> deleteCompanyStorage(int? id) async {
    await _store.writeTxn(() async {
      final success = await _store.companys.delete(id ?? 0);
      log('delete is successful $success');
    });
  }

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
      bool? desc}) async {
    List<Company> companies = [];
    var query = _store.companys.filter().idIsNotNull();

    if (filterName != null) {
      if (filterName.isNotEmpty) {
        query = query.nameContains(filterName, caseSensitive: false);
      }
    }

    if (filterEmail != null) {
      if (filterEmail.isNotEmpty) {
        query = query.emailContains(filterEmail, caseSensitive: false);
      }
    }

    if (filterPhone != null) {
      if (filterPhone.isNotEmpty) {
        query = query.phoneContains(filterPhone, caseSensitive: false);
      }
    }

    if (filterAddress != null) {
      if (filterAddress.isNotEmpty) {
        query = query.addressContains(filterAddress, caseSensitive: false);
      }
    }

    if (filterCountry != null) {
      if (filterCountry.isNotEmpty) {
        query = query.countryContains(filterCountry, caseSensitive: false);
      }
    }

    if (filterBio != null) {
      if (filterBio.isNotEmpty) {
        query = query.bioContains(filterBio, caseSensitive: false);
      }
    }

    if (filterIndexSort != null) {
      switch (filterIndexSort) {
        //By Id
        case 0:
          {
            companies = await query.findAll();
            break;
          }
        //By Name
        case 1:
          {
            if (desc != null) {
              if (!desc) {
                companies = await query.sortByName().findAll();
              } else {
                companies = await query.sortByNameDesc().findAll();
              }
            }
            break;
          }
        //By Email
        case 2:
          {
            if (desc != null) {
              if (!desc) {
                companies = await query.sortByEmail().findAll();
              } else {
                companies = await query.sortByEmailDesc().findAll();
              }
            }
            break;
          }
        //By Phone
        case 3:
          {
            if (desc != null) {
              if (!desc) {
                companies = await query.sortByPhone().findAll();
              } else {
                companies = await query.sortByPhoneDesc().findAll();
              }
            }
            break;
          }
        //By Address
        case 4:
          {
            if (desc != null) {
              if (!desc) {
                companies = await query.sortByAddress().findAll();
              } else {
                companies = await query.sortByAddressDesc().findAll();
              }
            }
            break;
          }
        //By Bio
        case 5:
          {
            if (desc != null) {
              if (!desc) {
                companies = await query.sortByBio().findAll();
              } else {
                companies = await query.sortByBioDesc().findAll();
              }
            }
            break;
          }
        //By Country
        case 6:
          {
            if (desc != null) {
              if (!desc) {
                companies = await query.sortByCountry().findAll();
              } else {
                companies = await query.sortByCountryDesc().findAll();
              }
            }
            break;
          }
        default:
          {
            companies = await query.findAll();
            break;
          }
      }
    }

    if (filterIndexSort != null) {
      if (filterIndexSort == 0) {
        if (desc != null) {
          if (desc) {
            companies = await query.findAll();
            companies.sort((a, b) => Comparable.compare(b.id!, a.id!));
          }
        }
      }
    }

    return companies;
  }
}

//! Define all repo's methods of Store
abstract class CompanyBoxBoxOperations {
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
}
