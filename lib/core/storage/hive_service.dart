import 'package:hive_flutter/hive_flutter.dart';
import '../../features/events/data/models/event_hive_model.dart';

class HiveService {
  static const String eventsBoxName = 'events';
  static const String bookingsBoxName = 'bookings';
  static const String lastSyncKey = 'last_sync';

  static Future<void> init() async {
    try {
      await Hive.initFlutter();

      // Register adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(EventHiveModelAdapter());
      }

      // Open boxes with error handling
      if (!Hive.isBoxOpen(eventsBoxName)) {
        await Hive.openBox<EventHiveModel>(eventsBoxName);
      }

      if (!Hive.isBoxOpen(bookingsBoxName)) {
        await Hive.openBox<String>(bookingsBoxName);
      }
    } catch (e) {
      print('Error initializing Hive: $e');
      rethrow;
    }
  }

  static Box<EventHiveModel> get eventsBox {
    if (!Hive.isBoxOpen(eventsBoxName)) {
      throw StateError(
          'Events box is not open. Make sure to call HiveService.init() first.');
    }
    return Hive.box<EventHiveModel>(eventsBoxName);
  }

  static Box<String> get bookingsBox {
    if (!Hive.isBoxOpen(bookingsBoxName)) {
      throw StateError(
          'Bookings box is not open. Make sure to call HiveService.init() first.');
    }
    return Hive.box<String>(bookingsBoxName);
  }

  // Events operations
  static Future<void> saveEvents(List<EventHiveModel> events) async {
    final box = eventsBox;
    await box.clear();
    await box.addAll(events);
    await _updateLastSync();
  }

  static List<EventHiveModel> getCachedEvents() {
    return eventsBox.values.toList();
  }

  static EventHiveModel? getCachedEvent(String id) {
    try {
      return eventsBox.values.firstWhere(
        (event) => event.id == id,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> updateEventTickets(String id, int newTicketCount) async {
    final box = eventsBox;
    try {
      final event = box.values.firstWhere(
        (event) => event.id == id,
      );

      final updatedEvent = event.copyWith(
        ticketsAvailable: newTicketCount,
        lastUpdated: DateTime.now(),
      );

      final index = box.values.toList().indexWhere((e) => e.id == id);
      if (index != -1) {
        await box.putAt(index, updatedEvent);
      }
    } catch (e) {
      print('Event with id $id not found for ticket update: $e');
    }
  }

  // Bookings operations
  static Future<void> addBooking(String eventId) async {
    final box = bookingsBox;
    if (!box.containsKey(eventId)) {
      await box.put(eventId, eventId);
    }
  }

  static List<String> getBookedEventIds() {
    return bookingsBox.values.toList();
  }

  static bool isEventBooked(String eventId) {
    return bookingsBox.containsKey(eventId);
  }

  static Future<void> removeBooking(String eventId) async {
    await bookingsBox.delete(eventId);
  }

  // Sync operations
  static Future<void> _updateLastSync() async {
    final box = bookingsBox;
    await box.put(lastSyncKey, DateTime.now().toIso8601String());
  }

  static DateTime? getLastSync() {
    final box = bookingsBox;
    final lastSyncString = box.get(lastSyncKey);
    if (lastSyncString != null) {
      return DateTime.tryParse(lastSyncString);
    }
    return null;
  }

  static bool shouldSync() {
    final lastSync = getLastSync();
    if (lastSync == null) return true;

    // Sync if last sync was more than 5 minutes ago
    return DateTime.now().difference(lastSync).inMinutes > 5;
  }

  static Future<void> clearAllData() async {
    await eventsBox.clear();
    await bookingsBox.clear();
  }
}
