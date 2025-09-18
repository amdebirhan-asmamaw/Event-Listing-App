import '../entities/event_entity.dart';

abstract class EventRepository {
  Future<List<EventEntity>> getEvents({String? query});
  Future<EventEntity> getEventDetail(String id);
  Future<void> bookTicket(String id);
  Future<List<EventEntity>> getBookedEvents();
}
