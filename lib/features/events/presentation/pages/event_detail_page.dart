import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/formatters.dart';
import '../bloc/event_detail_bloc/event_detail_bloc.dart';
import '../bloc/booking_bloc/booking_bloc.dart';

class EventDetailPage extends StatelessWidget {
  final String id;
  const EventDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<EventDetailBloc>()..add(LoadEventDetail(id)),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<EventDetailBloc, EventDetailState>(
            builder: (context, state) {
              if (state is EventDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is EventDetailError) {
                return Center(child: Text(state.message));
              }
              if (state is EventDetailLoaded) {
                final e = state.event;
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 260,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(e.title,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(e.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.image, size: 48))),
                            Container(
                                decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black54, Colors.transparent],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Icon(Icons.schedule),
                              const SizedBox(width: 8),
                              Text(formatDate(e.date))
                            ]),
                            const SizedBox(height: 8),
                            Row(children: [
                              const Icon(Icons.place),
                              const SizedBox(width: 8),
                              Expanded(child: Text(e.location))
                            ]),
                            const SizedBox(height: 12),
                            Text(e.description),
                            const SizedBox(height: 16),
                            Row(children: [
                              const Icon(Icons.confirmation_num_outlined),
                              const SizedBox(width: 8),
                              Text('${e.ticketsAvailable} tickets available',
                                  style: TextStyle(
                                      color: e.ticketsAvailable > 0
                                          ? Colors.green
                                          : Colors.red)),
                            ]),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: e.ticketsAvailable > 0
                                    ? () {
                                        context
                                            .read<BookingBloc>()
                                            .add(MakeBooking(e.id));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text('Ticket booked!')));
                                      }
                                    : null,
                                icon: const Icon(Icons.shopping_bag_outlined),
                                label: const Text('Book Ticket'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
