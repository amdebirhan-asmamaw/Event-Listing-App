import '../../../../../core/network/api_client.dart';
import '../../models/event_model.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> fetchEvents();
  Future<EventModel> fetchEvent(String id);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final ApiClient client;
  EventRemoteDataSourceImpl(this.client);

  @override
  Future<List<EventModel>> fetchEvents() async {
    final res = await client.get('/events.json');
    final data = res['data'];
    if (data is List) {
      return data
          .map((e) => EventModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    throw Exception('Invalid events payload');
  }

  @override
  Future<EventModel> fetchEvent(String id) async {
    final res = await client.get('/events.json');
    final data = res['data'];
    if (data is List) {
      final eventData = data.firstWhere((e) => e['id'].toString() == id);
      return EventModel.fromJson(Map<String, dynamic>.from(eventData));
    }
    throw Exception('Invalid event payload');
  }
}
