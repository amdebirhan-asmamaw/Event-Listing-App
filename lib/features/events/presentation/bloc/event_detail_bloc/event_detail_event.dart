part of 'event_detail_bloc.dart';

abstract class EventDetailEvent extends Equatable {
  const EventDetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadEventDetail extends EventDetailEvent {
  final String id;
  const LoadEventDetail(this.id);
}
