import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/event_entity.dart';
import '../../../domain/usecases/get_events.dart';

part 'event_list_event.dart';
part 'event_list_state.dart';

class EventListBloc extends Bloc<EventListEvent, EventListState> {
  final GetEvents getEvents;
  EventListBloc(this.getEvents) : super(EventListInitial()) {
    on<LoadEvents>((event, emit) async {
      emit(EventListLoading());
      try {
        final items = await getEvents(query: event.query);
        emit(EventListLoaded(items, query: event.query ?? ''));
      } catch (e) {
        emit(EventListError('Failed to load events. Please try again.'));
      }
    });
  }
}
