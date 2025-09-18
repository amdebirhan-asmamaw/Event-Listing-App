import '../../domain/entities/event_entity.dart';
import '../../domain/repository/event_repository.dart';
import '../source/local/event_local_data_source.dart';
import '../source/remote/event_remote_data_source.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remote;
  final EventLocalDataSource local;

  EventRepositoryImpl(this.remote, this.local);

  @override
  Future<List<EventEntity>> getEvents({String? query}) async {
    try {
      // Try to fetch from remote first
      final remoteEvents = await remote.fetchEvents();

      // Cache the fresh data
      await local.cacheEvents(remoteEvents);

      // Apply search filter if provided
      final filteredEvents = _applySearchFilter(remoteEvents, query);
      return filteredEvents;
    } catch (e) {
      // If remote fails, try to get cached data
      print('Remote fetch failed, using cached data: $e');
      final cachedEvents = await local.getCachedEvents();

      if (cachedEvents.isEmpty) {
        // If no cached data, rethrow the error
        rethrow;
      }

      // Apply search filter to cached data
      final filteredEvents = _applySearchFilter(cachedEvents, query);
      return filteredEvents;
    }
  }

  @override
  Future<EventEntity> getEventDetail(String id) async {
    try {
      // Try to fetch from remote first
      final remoteEvent = await remote.fetchEvent(id);

      // Cache the fresh data
      await local.cacheEvents([remoteEvent]);

      return remoteEvent;
    } catch (e) {
      // If remote fails, try to get cached data
      print('Remote fetch failed for event $id, using cached data: $e');
      final cachedEvent = await local.getCachedEvent(id);

      if (cachedEvent == null) {
        // If no cached data, rethrow the error
        rethrow;
      }

      return cachedEvent;
    }
  }

  @override
  Future<void> bookTicket(String id) async {
    // Add booking to local storage
    await local.addBooking(id);

    // Get current event to update ticket count
    final event = await getEventDetail(id);
    if (event.ticketsAvailable > 0) {
      final newTicketCount = event.ticketsAvailable - 1;
      await local.updateEventTickets(id, newTicketCount);
    }
  }

  @override
  Future<List<EventEntity>> getBookedEvents() async {
    final bookedIds = await local.getBookedIds();
    if (bookedIds.isEmpty) return [];

    final allEvents = await getEvents();
    return allEvents.where((e) => bookedIds.contains(e.id)).toList();
  }

  List<EventEntity> _applySearchFilter(
      List<EventEntity> events, String? query) {
    if (query == null || query.trim().isEmpty) {
      return events;
    }

    final q = query.toLowerCase();
    return events
        .where((e) =>
            e.title.toLowerCase().contains(q) ||
            e.location.toLowerCase().contains(q))
        .toList();
  }
}
