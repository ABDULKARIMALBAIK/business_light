import 'package:injectable/injectable.dart';

/// Mapper to convert PaymentModel to Payment (Model to DTO)
@Named('PaymentMapper')
@Injectable()
class PaymentMapper implements PaymentMapperOperations {
  //? This class convert Model obj to DTO obj when get data via API
}

abstract class PaymentMapperOperations {}
