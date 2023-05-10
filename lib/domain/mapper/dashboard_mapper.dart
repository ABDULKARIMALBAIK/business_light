import 'package:injectable/injectable.dart';

/// Mapper to convert DashboardModel to Dashboard (Model to DTO)
@Named('DashboardMapper')
@Injectable()
class DashboardMapper implements DashboardMapperOperations {
  //? This class convert Model obj to DTO obj when get data via API
}

abstract class DashboardMapperOperations {}
