part of 'event_detail_bloc.dart';

abstract class EventDetailState extends Equatable {
  const EventDetailState();
  @override
  List<Object?> get props => [];
}

class EventDetailInitial extends EventDetailState {}

class EventDetailLoading extends EventDetailState {}

class EventDetailLoaded extends EventDetailState {
  final EventEntity event;
  const EventDetailLoaded(this.event);
  @override
  List<Object?> get props => [event];
}

class EventDetailError extends EventDetailState {
  final String message;
  const EventDetailError(this.message);
  @override
  List<Object?> get props => [message];
}
