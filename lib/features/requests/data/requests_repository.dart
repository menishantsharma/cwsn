import 'package:cwsn/features/requests/data/requests_data.dart';
import 'package:cwsn/features/requests/models/request_model.dart';

class RequestsRepository {
  Future<List<CaregiverRequest>> getRequests() async {
    await Future.delayed(Duration(seconds: 2));
    return mockRequests;
  }
}
