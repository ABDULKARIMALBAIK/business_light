import 'package:injectable/injectable.dart';

/// Mapper to convert OrderModel to Order (Model to DTO)
@Named('OrderMapper')
@Injectable()
class OrderMapper implements OrderMapperOperations {
  //? This class convert Model obj to DTO obj when get data via API
}

abstract class OrderMapperOperations {}
