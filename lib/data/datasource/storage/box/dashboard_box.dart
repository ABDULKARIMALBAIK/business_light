import 'package:isar/isar.dart';

import '../../../../domain/entity/payment.dart';
import '../../../../domain/entity/payout.dart';

// Storage Box to make operations on Dashboard
class DashboardBox extends DashboardBoxOperations {
  DashboardBox(this._store);

  final Isar _store;

  /// Get payments due to (Today,Yesterday,Week,Month) from storage
  @override
  Future<List<Payment>> getPaymentsDataStorage() async {
    List<Payment> payments = []; //has 4 payments only
    final now = DateTime.now();

    //Today
    var queryToday = _store.payments.filter().idIsNotNull();
    final today = DateTime(now.year, now.month, now.day);

    queryToday = queryToday.dateBetween(
        today, today.add(const Duration(hours: 23, minutes: 59)),
        includeLower: true, includeUpper: true);

    List<Payment> paymentsToday = [];
    paymentsToday = await queryToday.findAll();

    if (paymentsToday.isNotEmpty) {
      Payment paymentToday = Payment()
        ..price = paymentsToday
            .map<double>((payment) => payment.price ?? 0.0)
            .toList()
            .reduce((value, element) => value + element);
      payments.add(paymentToday);
    } else {
      Payment paymentToday = Payment()..price = 0;
      payments.add(paymentToday);
    }

    //Yesterday
    var queryYesterday = _store.payments.filter().idIsNotNull();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    queryYesterday = queryYesterday.dateBetween(
        yesterday, yesterday.add(const Duration(hours: 23, minutes: 59)),
        includeLower: true, includeUpper: true);

    List<Payment> paymentsYesterday = [];
    paymentsYesterday = await queryYesterday.findAll();

    if (paymentsYesterday.isNotEmpty) {
      Payment paymentYesterday = Payment()
        ..price = paymentsYesterday
            .map<double>((payment) => payment.price ?? 0.0)
            .toList()
            .reduce((value, element) => value + element);
      payments.add(paymentYesterday);
    } else {
      Payment paymentYesterday = Payment()..price = 0;
      payments.add(paymentYesterday);
    }

    //Last 7 Days (Week)
    var queryWeek = _store.payments.filter().idIsNotNull();
    final week = DateTime(now.year, now.month, now.day - 7);
    final weekNow = DateTime(now.year, now.month, now.day, 23, 59);
    queryWeek = queryWeek.dateBetween(week, weekNow,
        includeLower: true, includeUpper: true);
    List<Payment> paymentsWeek = [];
    paymentsWeek = await queryWeek.findAll();
    if (paymentsWeek.isNotEmpty) {
      Payment paymentWeek = Payment()
        ..price = paymentsWeek
            .map<double>((payment) => payment.price ?? 0.0)
            .toList()
            .reduce((value, element) => value + element);
      payments.add(paymentWeek);
    } else {
      Payment paymentWeek = Payment()..price = 0;
      payments.add(paymentWeek);
    }

    //Last 30 Days (Month)
    var queryMonth = _store.payments.filter().idIsNotNull();
    final month = DateTime(now.year, now.month, now.day - 30);
    final monthNow = DateTime(now.year, now.month, now.day, 23, 59);
    queryMonth = queryMonth.dateBetween(month, monthNow,
        includeLower: true, includeUpper: true);
    List<Payment> paymentsMonth = [];
    paymentsMonth = await queryMonth.findAll();
    if (paymentsMonth.isNotEmpty) {
      Payment paymentMonth = Payment()
        ..price = paymentsMonth
            .map<double>((payment) => payment.price ?? 0.0)
            .toList()
            .reduce((value, element) => value + element);
      payments.add(paymentMonth);
    } else {
      Payment paymentMonth = Payment()..price = 0;
      payments.add(paymentMonth);
    }

    return payments;
  }

  /// Get last 5 payments from storage
  @override
  Future<List<Payment>> getPaymentsLast5Storage() async {
    List<Payment> payments = [];
    var query = _store.payments.filter().idIsNotNull();
    payments = await query.sortByDateDesc().limit(5).findAll();

    return payments;
  }

  /// Get payouts due to (Today,Yesterday,Week,Month) from storage
  @override
  Future<List<Payout>> getPayoutsDataStorage() async {
    List<Payout> payouts = []; //has 4 payouts only
    final now = DateTime.now();

    //Today
    var queryToday = _store.payouts.filter().idIsNotNull();
    final today = DateTime(now.year, now.month, now.day);

    queryToday = queryToday.dateBetween(
        today, today.add(const Duration(hours: 23, minutes: 59)),
        includeLower: true, includeUpper: true);
    List<Payout> payoutsToday = [];
    payoutsToday = await queryToday.findAll();

    if (payoutsToday.isNotEmpty) {
      Payout payoutToday = Payout()
        ..price = payoutsToday
            .map<double>((payout) => payout.price ?? 0.0)
            .toList()
            .reduce((value, element) => value + element);
      payouts.add(payoutToday);
    } else {
      Payout payoutToday = Payout()..price = 0;
      payouts.add(payoutToday);
    }

    //Yesterday
    var queryYesterday = _store.payouts.filter().idIsNotNull();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    queryYesterday = queryYesterday.dateBetween(
        yesterday, yesterday.add(const Duration(hours: 23, minutes: 59)),
        includeLower: true, includeUpper: true);
    List<Payout> payoutsYesterday = [];
    payoutsYesterday = await queryYesterday.findAll();

    if (payoutsYesterday.isNotEmpty) {
      Payout payoutYesterday = Payout()
        ..price = payoutsYesterday
            .map<double>((payout) => payout.price ?? 0.0)
            .toList()
            .reduce((value, element) => value + element);
      payouts.add(payoutYesterday);
    } else {
      Payout payoutYesterday = Payout()..price = 0;
      payouts.add(payoutYesterday);
    }

    //Last 7 Days (Week)
    var queryWeek = _store.payouts.filter().idIsNotNull();
    final week = DateTime(now.year, now.month, now.day - 7);
    final weekNow = DateTime(now.year, now.month, now.day, 23, 59);

    queryWeek = queryWeek.dateBetween(week, weekNow,
        includeLower: true, includeUpper: true);
    List<Payout> payoutsWeek = [];
    payoutsWeek = await queryWeek.findAll();

    if (payoutsWeek.isNotEmpty) {
      Payout payoutWeek = Payout()
        ..price = payoutsWeek
            .map<double>((payout) => payout.price ?? 0.0)
            .toList()
            .reduce((value, element) => value + element);
      payouts.add(payoutWeek);
    } else {
      Payout payoutWeek = Payout()..price = 0;
      payouts.add(payoutWeek);
    }

    //Last 30 Days (Month)
    var queryMonth = _store.payouts.filter().idIsNotNull();
    final month = DateTime(now.year, now.month, now.day - 30);
    final monthNow = DateTime(now.year, now.month, now.day, 23, 59);
    queryMonth = queryMonth.dateBetween(month, monthNow,
        includeLower: true, includeUpper: true);
    List<Payout> payoutsMonth = [];
    payoutsMonth = await queryMonth.findAll();
    if (payoutsMonth.isNotEmpty) {
      Payout payoutMonth = Payout()
        ..price = payoutsMonth
            .map<double>((payout) => payout.price ?? 0.0)
            .toList()
            .reduce((value, element) => value + element);
      payouts.add(payoutMonth);
    } else {
      Payout payoutMonth = Payout()..price = 0;
      payouts.add(payoutMonth);
    }

    return payouts;
  }

  /// Get last 5 payouts from storage
  @override
  Future<List<Payout>> getPayoutsLast5Storage() async {
    List<Payout> payouts = [];
    var query = _store.payouts.filter().idIsNotNull();
    payouts = await query.sortByDateDesc().limit(5).findAll();

    return payouts;
  }
}

abstract class DashboardBoxOperations {
  Future<List<Payment>> getPaymentsDataStorage();
  Future<List<Payment>> getPaymentsLast5Storage();
  Future<List<Payout>> getPayoutsDataStorage();
  Future<List<Payout>> getPayoutsLast5Storage();
}
