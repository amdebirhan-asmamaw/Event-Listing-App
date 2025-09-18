import '../repository/event_repository.dart';

class BookTicket {
  final EventRepository repo;
  BookTicket(this.repo);
  Future<void> call(String id) => repo.bookTicket(id);
}
