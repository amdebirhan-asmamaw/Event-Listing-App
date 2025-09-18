import '../entities/event_entity.dart';
import '../repository/event_repository.dart';

class GetEvents {
  final EventRepository repo;
  GetEvents(this.repo);
  Future<List<EventEntity>> call({String? query}) =>
      repo.getEvents(query: query);
}
