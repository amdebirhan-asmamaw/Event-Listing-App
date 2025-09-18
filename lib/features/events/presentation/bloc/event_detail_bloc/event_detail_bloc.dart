import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/event_entity.dart';
import '../../../domain/usecases/get_event_detail.dart';

part 'event_detail_event.dart';
part 'event_detail_state.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final GetEventDetail getDetail;
  EventDetailBloc(this.getDetail) : super(EventDetailInitial()) {
    on<LoadEventDetail>((event, emit) async {
      emit(EventDetailLoading());
      try {
        final item = await getDetail(event.id);
        emit(EventDetailLoaded(item));
      } catch (e) {
        emit(const EventDetailError('Could not load event details.'));
      }
    });
  }
}
