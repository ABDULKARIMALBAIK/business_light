import 'package:injectable/injectable.dart';

/// Mapper to convert StoreModel to Store (Model to DTO)
@Named('StoreMapper')
@Injectable()
class StoreMapper implements StoreMapperOperations {
  //? This class convert Model obj to DTO obj when get data via API
}

abstract class StoreMapperOperations {}
