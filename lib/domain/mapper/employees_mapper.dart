import 'package:injectable/injectable.dart';

/// Mapper to convert EmployeesModel to Employees (Model to DTO)
@Named('EmployeesMapper')
@Injectable()
class EmployeesMapper implements EmployeesMapperOperations {
  //? This class convert Model obj to DTO obj when get data via API
}

abstract class EmployeesMapperOperations {}
