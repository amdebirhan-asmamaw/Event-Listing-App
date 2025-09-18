part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class LoadBookings extends BookingEvent {}

class MakeBooking extends BookingEvent {
  final String id;
  const MakeBooking(this.id);
}
