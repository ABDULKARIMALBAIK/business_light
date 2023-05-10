import 'package:injectable/injectable.dart';

/// Mapper to convert PayoutModel to Payout (Model to DTO)
@Named('PayoutMapper')
@Injectable()
class PayoutMapper implements PayoutMapperOperations {
  //? This class convert Model obj to DTO obj when get data via API
}

abstract class PayoutMapperOperations {}
