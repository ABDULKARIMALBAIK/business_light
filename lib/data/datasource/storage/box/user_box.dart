import 'dart:developer';

import 'package:isar/isar.dart';

import '../../../../domain/entity/user.dart';

class UserBox extends UserBoxOperations {
  UserBox(this._store);

  final Isar _store;

  // add new user on the storage
  @override
  Future<void> addUserStorage(User employee) async {
    await _store.writeTxn(() async {
      await _store.users.put(employee);
    });
  }

  /// edit the user on the storage
  @override
  Future<void> editUserStorage(
      {int? id,
      required String fullName,
      required String email,
      required String password,
      required String salary,
      required String phone,
      required String jobDescription,
      required String imagePath,
      required UserLevel level}) async {
    await _store.writeTxn(() async {
      final editUser = await _store.users.get(id!);

      editUser!.fullName = fullName;
      editUser.email = email;
      editUser.password = password;
      editUser.salary = double.tryParse(salary) ?? 0.0;
      editUser.phone = phone;
      editUser.jobDescription = jobDescription;
      editUser.imagePath = imagePath;
      editUser.level = level;
      await _store.users.put(editUser);
    });
  }

  /// delete the user on the storage
  @override
  Future<void> deleteUserStorage(int? id) async {
    await _store.writeTxn(() async {
      final success = await _store.users.delete(id ?? 0);
      log('delete is successful $success');
    });
  }

  /// Get employees data from storage
  @override
  Future<List<User>> getAllEmployeesStorage(
      {String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterJobDescription,
      UserLevel? filterLevel,
      String? filterGreaterSalary,
      String? filterLowerSalary,
      int? filterIndexSort,
      bool? desc}) async {
    List<User> employees = [];
    var query = _store.users.filter().idIsNotNull();
    query = query.not().levelEqualTo(UserLevel.customer);

    if (filterName != null) {
      if (filterName.isNotEmpty) {
        query = query.fullNameContains(filterName, caseSensitive: false);
      }
    }

    if (filterEmail != null) {
      if (filterEmail.isNotEmpty) {
        query = query.emailContains(filterEmail, caseSensitive: false);
      }
    }

    if (filterGreaterSalary != null) {
      if (filterGreaterSalary.isNotEmpty) {
        query = query.salaryGreaterThan(
            double.tryParse(filterGreaterSalary) ?? 0.0,
            include: true);
      }
    }

    if (filterLowerSalary != null) {
      if (filterLowerSalary.isNotEmpty) {
        query = query.salaryLessThan(double.tryParse(filterLowerSalary) ?? 0.0,
            include: true);
      }
    }

    if (filterPhone != null) {
      if (filterPhone.isNotEmpty) {
        query = query.phoneContains(filterPhone, caseSensitive: false);
      }
    }

    if (filterJobDescription != null) {
      if (filterJobDescription.isNotEmpty) {
        query = query.jobDescriptionContains(filterJobDescription,
            caseSensitive: false);
      }
    }

    if (filterLevel != null) {
      if (filterLevel == UserLevel.manager) {
        query = query.levelEqualTo(UserLevel.manager);
      } else if (filterLevel == UserLevel.worker) {
        query = query.levelEqualTo(UserLevel.worker);
      } else if (filterLevel == UserLevel.other) {
        query = query.levelEqualTo(UserLevel.other);
      }
    }

    if (filterIndexSort != null) {
      switch (filterIndexSort) {
        //By Id
        case 0:
          {
            employees = await query.findAll();
            break;
          }
        //By Name
        case 1:
          {
            if (desc != null) {
              if (!desc) {
                employees = await query.sortByFullName().findAll();
              } else {
                employees = await query.sortByFullNameDesc().findAll();
              }
            }
            break;
          }
        //By Email
        case 2:
          {
            if (desc != null) {
              if (!desc) {
                employees = await query.sortByEmail().findAll();
              } else {
                employees = await query.sortByEmailDesc().findAll();
              }
            }
            break;
          }
        //By Phone
        case 3:
          {
            if (desc != null) {
              if (!desc) {
                employees = await query.sortByPhone().findAll();
              } else {
                employees = await query.sortByPhoneDesc().findAll();
              }
            }
            break;
          }
        //By Job Desc
        case 4:
          {
            if (desc != null) {
              if (!desc) {
                employees = await query.sortByJobDescription().findAll();
              } else {
                employees = await query.sortByJobDescriptionDesc().findAll();
              }
            }
            break;
          }
        //By Salary
        case 5:
          {
            if (desc != null) {
              if (!desc) {
                employees = await query.sortBySalary().findAll();
              } else {
                employees = await query.sortBySalaryDesc().findAll();
              }
            }
            break;
          }
        //By Level
        case 6:
          {
            if (desc != null) {
              if (!desc) {
                employees = await query.sortByLevel().findAll();
              } else {
                employees = await query.sortByLevelDesc().findAll();
              }
            }
            break;
          }
        default:
          {
            employees = await query.findAll();
            break;
          }
      }
    }

    if (filterIndexSort != null) {
      if (filterIndexSort == 0) {
        if (desc != null) {
          if (desc) {
            employees = await query.findAll();
            employees.sort((a, b) => Comparable.compare(b.id!, a.id!));
          }
        }
      }
    }

    return employees;
  }

  /// Get customers data from storage
  @override
  Future<List<User>> getAllCustomersStorage(
      {String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterJobDescription,
      int? filterIndexSort,
      bool? desc}) async {
    List<User> customers = [];
    var query = _store.users.filter().idIsNotNull();
    query = query.levelEqualTo(UserLevel.customer);

    if (filterName != null) {
      if (filterName.isNotEmpty) {
        query = query.fullNameContains(filterName, caseSensitive: false);
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

    if (filterJobDescription != null) {
      if (filterJobDescription.isNotEmpty) {
        query = query.jobDescriptionContains(filterJobDescription,
            caseSensitive: false);
      }
    }

    if (filterIndexSort != null) {
      switch (filterIndexSort) {
        //By Id
        case 0:
          {
            customers = await query.findAll();
            break;
          }
        //By Name
        case 1:
          {
            if (desc != null) {
              if (!desc) {
                customers = await query.sortByFullName().findAll();
              } else {
                customers = await query.sortByFullNameDesc().findAll();
              }
            }
            break;
          }
        //By Email
        case 2:
          {
            if (desc != null) {
              if (!desc) {
                customers = await query.sortByEmail().findAll();
              } else {
                customers = await query.sortByEmailDesc().findAll();
              }
            }
            break;
          }
        //By Phone
        case 3:
          {
            if (desc != null) {
              if (!desc) {
                customers = await query.sortByPhone().findAll();
              } else {
                customers = await query.sortByPhoneDesc().findAll();
              }
            }
            break;
          }

        //By Job Desc
        case 4:
          {
            if (desc != null) {
              if (!desc) {
                customers = await query.sortByJobDescription().findAll();
              } else {
                customers = await query.sortByJobDescriptionDesc().findAll();
              }
            }
            break;
          }
        //By Level
        // case 5:
        //   {
        //     if (desc != null) {
        //       if (!desc) {
        //         employees = await query.sortByLevel().findAll();
        //       } else {
        //         employees = await query.sortByLevelDesc().findAll();
        //       }
        //     }
        //     break;
        //   }
        default:
          {
            customers = await query.findAll();
            break;
          }
      }
    }

    if (filterIndexSort != null) {
      if (filterIndexSort == 0) {
        if (desc != null) {
          if (desc) {
            customers = await query.findAll();
            customers.sort((a, b) => Comparable.compare(b.id!, a.id!));
          }
        }
      }
    }

    return customers;
  }
}

//! Define all repo's methods of Store
abstract class UserBoxOperations {
  Future<List<User>> getAllEmployeesStorage(
      {String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterJobDescription,
      UserLevel? filterLevel,
      String? filterGreaterSalary,
      String? filterLowerSalary,
      int? filterIndexSort,
      bool? desc});

  Future<List<User>> getAllCustomersStorage(
      {String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterJobDescription,
      int? filterIndexSort,
      bool? desc});

  Future<void> deleteUserStorage(int? id);
  Future<void> addUserStorage(User employee);
  Future<void> editUserStorage(
      {int? id,
      required String fullName,
      required String email,
      required String password,
      required String phone,
      required String salary,
      required String jobDescription,
      required String imagePath,
      required UserLevel level});
}
