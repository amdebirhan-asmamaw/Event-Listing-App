# Event Listing App

A Flutter app that lists events, shows event details, and lets users book tickets (locally via Hive). Networking pulls an event list from a public JSON endpoint.

- API source: `https://gist.githubusercontent.com/degisew/83563097c967c13b6be276d7caa1f1e8/raw/events.json`

## Prerequisites

- Flutter SDK (3.x recommended)
- Dart SDK (bundled with Flutter)
- Android Studio or Xcode (for device emulators)
- Java 11+ for Android builds
- Git (optional)

Verify setup:

```bash
flutter --version
```

## Getting Started

1. Install dependencies

```bash
flutter pub get
```

2. Generate and prepare platforms (already in repo, but run if needed)

```bash
flutter create .
```

3. Run on a device or emulator

- Android:

```bash
flutter run -d android
```

- iOS (macOS only):

```bash
flutter run -d ios
```

- Web:

```bash
flutter run -d chrome
```

## Environments & Permissions

- Android permissions are set in `android/app/src/main/AndroidManifest.xml`:
  - `INTERNET` and `ACCESS_NETWORK_STATE` are enabled for API calls.
- Hive local storage is initialized on app start and requires no special runtime permissions.
- Web CORS: The app fetches from a `raw.githubusercontent.com`/Gist URL which generally permits cross-origin GETs.

## API

- Events JSON: `https://gist.githubusercontent.com/degisew/83563097c967c13b6be276d7caa1f1e8/raw/events.json`
- Response shape (array of events):

```json
[
  {
    "id": 1,
    "title": "Addis Music Festival",
    "date": "2025-10-05",
    "location": "Addis Ababa",
    "description": "A fun outdoor music festival featuring local and international artists.",
    "tickets": 50,
    "image": "https://picsum.photos/400/200?random=1"
  }
]
```

## Project Structure (Feature-first)

- `lib/main.dart`: App entry; sets up DI with `GetIt` and launches `MainNavigationPage`.
- `lib/features/events/`
  - `event_injection.dart`: Registers dependencies (ApiClient, data sources, repository, usecases, blocs) and initializes Hive.
  - `domain/`
    - `entities/event_entity.dart`: Core event model used across layers.
    - `repository/event_repository.dart`: Domain-facing repository interface.
    - `usecases/`: `GetEvents`, `GetEventDetail`, `BookTicket`, `GetBookedEvents`.
  - `data/`
    - `models/event_model.dart`: Data model with `fromJson` and mapping to entity.
    - `models/event_hive_model.dart`: Hive model + adapter.
    - `source/remote/event_remote_data_source.dart`: Fetches events from the JSON URL.
    - `source/local/event_local_data_source.dart`: Persists events + bookings with Hive.
    - `repository/event_repository_impl.dart`: Orchestrates remote/local, search filtering, bookings.
  - `presentation/`
    - `bloc/`: `event_list_bloc`, `event_detail_bloc`, `booking_bloc` for state management.
    - `pages/`: UI screens (`event_list_page.dart`, `event_detail_page.dart`, `my_booking_page.dart`, `main_navigation_page.dart`).
- `lib/core/`
  - `network/api_client.dart`: HTTP client wrapper; returns decoded JSON in a `{data, statusCode}` envelope and unified error messages.
  - `storage/hive_service.dart`: Hive init and CRUD utilities for events and booking IDs.
  - `widgets/gradient_appbar.dart`: Shared styled app bar.
  - `utils/formatters.dart`: Date formatting.

## Data Flow

- List

  1. UI dispatches `LoadEvents` in `EventListBloc`.
  2. `GetEvents` usecase -> `EventRepositoryImpl.getEvents`.
  3. Repository calls `EventRemoteDataSource.fetchEvents()` which uses `ApiClient.get(url)`.
  4. On success: cache via `EventLocalDataSource.cacheEvents` (Hive) and emit loaded state. On failure: fallback to cached.

- Detail

  1. Details page creates its own `EventDetailBloc` (scoped to route) and dispatches `LoadEventDetail(id)`.
  2. `GetEventDetail` -> repository -> `remote.fetchEvent(id)` or cached fallback.

- Booking
  1. Details page also scopes a `BookingBloc`.
  2. On button press, dispatch `MakeBooking(id)` -> `BookTicket` usecase.
  3. Repository updates local Hive bookings and decrements ticket count in cached events.
  4. `BlocListener` refreshes details and shows a SnackBar.

## Key Implementation Notes

- Networking

  - `ApiClient.get(path)` accepts full URLs or paths relative to `baseUrl` and returns `{ 'data': dynamic, 'statusCode': int }`.
  - Errors are normalized (404, 5xx, network failures, invalid JSON).

- Remote Data Source

  - `fetchEvents()` and `fetchEvent(id)` call the Gist URL and parse the list payload.

- Local Storage (Hive)

  - Boxes: `events` for event cache, `bookings` for booked IDs and sync metadata.
  - `HiveService` handles initialization, adapters, and CRUD.

- State Management
  - BLoC with `flutter_bloc` for list, detail, and bookings.
  - The details page uses `MultiBlocProvider` to scope `EventDetailBloc` and `BookingBloc` to the route.

## Running & Building

- Run (debug):

```bash
flutter run
```

- Build Android APK (release):

```bash
flutter build apk --release
```

- Build Android AppBundle:

```bash
flutter build appbundle --release
```

- Build iOS (requires Xcode/macOS):

```bash
flutter build ios --release
```

- Build Web:

```bash
flutter build web --release
```

## Troubleshooting

- Blank list or error loading events

  - Ensure device has internet connectivity.
  - Verify the API endpoint is reachable in a browser.
  - Hot restart the app to reset providers and DI.

- "Provider not found" on details page

  - The details route now scopes its own `EventDetailBloc` and `BookingBloc`. If you modified routing/providers, ensure `EventDetailPage` is below the corresponding providers or use `MultiBlocProvider` as in the code.

- Layout exceptions (AspectRatio/RenderBox not laid out)

  - The list thumbnail uses a fixed `SizedBox(width: 110, height: 110)` in the row; if you change card layout, keep explicit constraints for images inside rows.

- Booking not reflecting in details
  - The details page listens for `BookingLoaded` and refetches details to update ticket counts. Ensure `BookingBloc` is provided in the details route.

## Extending the App

- Add search enhancements: debounce the text field, filter by date.
- Add favorites separate from bookings.
- Persist theme settings with Hive.
- Introduce offline-first sync strategy using `shouldSync` in `HiveService`.

## Tech Stack

- Flutter, Dart
- BLoC (`flutter_bloc`)
- Dependency Injection: `get_it`
- Local storage: `hive` / `hive_flutter`
- HTTP: `http`

## License

This project is provided as-is for demonstration purposes.
