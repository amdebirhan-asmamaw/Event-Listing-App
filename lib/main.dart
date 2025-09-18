import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'features/events/event_injection.dart';
import 'features/events/presentation/pages/main_navigation_page.dart';

final sl = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injectEventFeature(sl);

  runApp(const EventApp());
}

class EventApp extends StatelessWidget {
  const EventApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = const Color(0xFF6C5CE7); // Indigo-violet
    return MaterialApp(
      title: 'Events',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: baseColor),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
        cardTheme: CardTheme(
          elevation: 1.5,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const MainNavigationPage(),
    );
  }
}
