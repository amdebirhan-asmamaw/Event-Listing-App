import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_listing_app/features/events/presentation/bloc/booking_bloc/booking_bloc.dart';
import 'package:event_listing_app/features/events/presentation/bloc/event_detail_bloc/event_detail_bloc.dart';
import 'package:event_listing_app/features/events/presentation/bloc/event_list_bloc/event_list_bloc.dart';
import 'package:event_listing_app/features/events/presentation/pages/event_list_page.dart';
import 'package:event_listing_app/features/events/presentation/pages/my_booking_page.dart';
import 'package:event_listing_app/main.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<EventListBloc>()),
        BlocProvider(create: (_) => sl<EventDetailBloc>()),
        BlocProvider(create: (_) => sl<BookingBloc>()),
      ],
      child: Scaffold(
        body: IndexedStack(
            index: _index, children: const [EventListPage(), MyBookingsPage()]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.event), label: 'Events'),
            NavigationDestination(
                icon: Icon(Icons.bookmark_added_outlined),
                label: 'My Bookings'),
          ],
          onDestinationSelected: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}
