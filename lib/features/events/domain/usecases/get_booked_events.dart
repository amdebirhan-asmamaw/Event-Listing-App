import '../entities/event_entity.dart';
import '../repository/event_repository.dart';

class GetBookedEvents {
  final EventRepository repo;
  GetBookedEvents(this.repo);
  Future<List<EventEntity>> call() => repo.getBookedEvents();
}
