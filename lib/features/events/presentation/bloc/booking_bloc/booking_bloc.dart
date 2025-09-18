import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/event_entity.dart';
import '../../../domain/usecases/book_ticket.dart';
import '../../../domain/usecases/get_booked_events.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookTicket bookTicket;
  final GetBookedEvents getBooked;
  BookingBloc(this.bookTicket, this.getBooked) : super(BookingInitial()) {
    on<LoadBookings>((event, emit) async {
      emit(BookingLoading());
      try {
        final items = await getBooked();
        emit(BookingLoaded(items));
      } catch (e) {
        emit(const BookingError('Failed to load bookings'));
      }
    });

    on<MakeBooking>((event, emit) async {
      try {
        await bookTicket(event.id);
        final items = await getBooked();
        emit(BookingLoaded(items));
      } catch (e) {
        emit(const BookingError('Booking failed'));
      }
    });
  }
}
