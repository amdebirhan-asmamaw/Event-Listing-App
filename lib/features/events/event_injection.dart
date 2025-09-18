import 'package:get_it/get_it.dart';
import '../../core/network/api_client.dart';
import 'package:event_listing_app/core/storage/hive_service.dart';
import 'data/repository/event_repository_impl.dart';
import 'data/source/local/event_local_data_source.dart';
import 'data/source/remote/event_remote_data_source.dart';
import 'domain/repository/event_repository.dart';
import 'domain/usecases/book_ticket.dart';
import 'domain/usecases/get_booked_events.dart';
import 'domain/usecases/get_event_detail.dart';
import 'domain/usecases/get_events.dart';
import 'presentation/bloc/booking_bloc/booking_bloc.dart';
import 'presentation/bloc/event_detail_bloc/event_detail_bloc.dart';
import 'presentation/bloc/event_list_bloc/event_list_bloc.dart';

Future<void> injectEventFeature(GetIt sl) async {
  // Initialize Hive
  await HiveService.init();

  // external
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // data sources
  sl.registerLazySingleton<EventRemoteDataSource>(
      () => EventRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<EventLocalDataSource>(
      () => EventLocalDataSourceImpl());

  // repo
  sl.registerLazySingleton<EventRepository>(
      () => EventRepositoryImpl(sl(), sl()));

  // usecases
  sl.registerLazySingleton(() => GetEvents(sl()));
  sl.registerLazySingleton(() => GetEventDetail(sl()));
  sl.registerLazySingleton(() => BookTicket(sl()));
  sl.registerLazySingleton(() => GetBookedEvents(sl()));

  // blocs
  sl.registerFactory(() => EventListBloc(sl()));
  sl.registerFactory(() => EventDetailBloc(sl()));
  sl.registerFactory(() => BookingBloc(sl(), sl()));
}
