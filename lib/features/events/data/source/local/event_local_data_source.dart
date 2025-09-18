import '../../models/event_model.dart';
import '../../models/event_hive_model.dart';
import 'package:event_listing_app/core/storage/hive_service.dart';

abstract class EventLocalDataSource {
  Future<List<String>> getBookedIds();
  Future<void> saveBookedIds(List<String> ids);
  Future<void> cacheEvents(List<EventModel> events);
  Future<List<EventModel>> getCachedEvents();
  Future<EventModel?> getCachedEvent(String id);
  Future<void> updateEventTickets(String id, int newTicketCount);
  Future<void> addBooking(String eventId);
  bool isEventBooked(String eventId);
  DateTime? getLastSync();
  bool shouldSync();
}

class EventLocalDataSourceImpl implements EventLocalDataSource {
  EventLocalDataSourceImpl();

  @override
  Future<List<String>> getBookedIds() async {
    try {
      return HiveService.getBookedEventIds();
    } catch (e) {
      print('Error getting booked IDs: $e');
      return [];
    }
  }

  @override
  Future<void> saveBookedIds(List<String> ids) async {
    // This method is kept for compatibility but not used in Hive implementation
    // Individual bookings are managed through addBooking/removeBooking
  }

  @override
  Future<void> cacheEvents(List<EventModel> events) async {
    try {
      final hiveEvents =
          events.map((e) => EventHiveModel.fromEntity(e)).toList();
      await HiveService.saveEvents(hiveEvents);
    } catch (e) {
      print('Error caching events: $e');
      rethrow;
    }
  }

  @override
  Future<List<EventModel>> getCachedEvents() async {
    try {
      final hiveEvents = HiveService.getCachedEvents();
      return hiveEvents
          .map((e) => EventModel.fromEntity(e.toEntity()))
          .toList();
    } catch (e) {
      print('Error getting cached events: $e');
      return [];
    }
  }

  @override
  Future<EventModel?> getCachedEvent(String id) async {
    try {
      final hiveEvent = HiveService.getCachedEvent(id);
      if (hiveEvent != null) {
        return EventModel.fromEntity(hiveEvent.toEntity());
      }
      return null;
    } catch (e) {
      print('Error getting cached event $id: $e');
      return null;
    }
  }

  @override
  Future<void> updateEventTickets(String id, int newTicketCount) async {
    await HiveService.updateEventTickets(id, newTicketCount);
  }

  @override
  Future<void> addBooking(String eventId) async {
    try {
      await HiveService.addBooking(eventId);
    } catch (e) {
      print('Error adding booking for event $eventId: $e');
      rethrow;
    }
  }

  @override
  bool isEventBooked(String eventId) {
    try {
      return HiveService.isEventBooked(eventId);
    } catch (e) {
      print('Error checking if event $eventId is booked: $e');
      return false;
    }
  }

  @override
  DateTime? getLastSync() {
    return HiveService.getLastSync();
  }

  @override
  bool shouldSync() {
    return HiveService.shouldSync();
  }
}
