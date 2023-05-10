import 'package:injectable/injectable.dart';

/// Mapper to convert BrandModel to Brand (Model to DTO)
@Named('BrandMapper')
@Injectable()
class BrandMapper implements BrandMapperOperations {
  //? This class convert Model obj to DTO obj when get data via API
}

abstract class BrandMapperOperations {}
