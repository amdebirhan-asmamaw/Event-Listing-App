import '../entities/event_entity.dart';
import '../repository/event_repository.dart';

class GetEventDetail {
  final EventRepository repo;
  GetEventDetail(this.repo);
  Future<EventEntity> call(String id) => repo.getEventDetail(id);
}
