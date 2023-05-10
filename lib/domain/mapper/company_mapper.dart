import 'package:injectable/injectable.dart';

/// Mapper to convert CompanyModel to Company (Model to DTO)
@Named('CompanyMapper')
@Injectable()
class CompanyMapper implements CompanyMapperOperations {
  //? This class convert Model obj to DTO obj when get data via API
}

abstract class CompanyMapperOperations {}
