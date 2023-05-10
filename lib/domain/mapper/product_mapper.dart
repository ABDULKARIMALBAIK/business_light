import 'package:injectable/injectable.dart';

/// Mapper to convert ProductModel to Product (Model to DTO)
@Named('ProductMapper')
@Injectable()
class ProductMapper implements ProductMapperOperations {
  //? This class convert Model obj to DTO obj when get data via API
}

abstract class ProductMapperOperations {}
