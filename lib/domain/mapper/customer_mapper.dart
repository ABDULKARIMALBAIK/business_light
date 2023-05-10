import 'package:injectable/injectable.dart';

/// Mapper to convert CustomerModel to Customer (Model to DTO)
@Named('CustomerMapper')
@Injectable()
class CustomerMapper implements CustomerMapperOperations {
  //? This class convert Model obj to DTO obj when get data via API
}

abstract class CustomerMapperOperations {}
