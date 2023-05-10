import '../entity/payment.dart';
import '../entity/payout.dart';

///Declare all operations to Dashboard screen (Data and operations)
abstract class DashBoardOperations {
  Future<List<Payment>> getPaymentsDataStorage();
  Future<List<Payment>> getPaymentsLast5Storage();
  Future<List<Payout>> getPayoutsDataStorage();
  Future<List<Payout>> getPayoutsLast5Storage();

  getPaymentsDataRemote();
  getPaymentsLast5DaysRemote();
  getPayoutsDataRemote();
  getPayoutsLast5DaysRemote();
}
