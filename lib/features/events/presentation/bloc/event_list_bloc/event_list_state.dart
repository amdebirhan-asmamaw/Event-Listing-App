part of 'event_list_bloc.dart';

abstract class EventListState extends Equatable {
  const EventListState();
  @override
  List<Object?> get props => [];
}

class EventListInitial extends EventListState {}

class EventListLoading extends EventListState {}

class EventListLoaded extends EventListState {
  final List<EventEntity> events;
  final String query;
  const EventListLoaded(this.events, {this.query = ''});

  @override
  List<Object?> get props => [events, query];
}

class EventListError extends EventListState {
  final String message;
  const EventListError(this.message);

  @override
  List<Object?> get props => [message];
}
