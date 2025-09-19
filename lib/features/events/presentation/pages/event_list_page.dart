import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/gradient_appbar.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/event_entity.dart';
import '../bloc/event_list_bloc/event_list_bloc.dart';
import 'event_detail_page.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EventListBloc>().add(const LoadEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Discover Events',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => context
                .read<EventListBloc>()
                .add(LoadEvents(query: _search.text)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              controller: _search,
              onChanged: (v) =>
                  context.read<EventListBloc>().add(LoadEvents(query: v)),
              decoration: InputDecoration(
                hintText: 'Search by name or location',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<EventListBloc, EventListState>(
              builder: (context, state) {
                if (state is EventListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is EventListError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off, size: 56),
                          const SizedBox(height: 12),
                          Text(state.message, textAlign: TextAlign.center),
                          const SizedBox(height: 8),
                          FilledButton(
                            onPressed: () => context
                                .read<EventListBloc>()
                                .add(LoadEvents(query: _search.text)),
                            child: const Text('Retry'),
                          )
                        ],
                      ),
                    ),
                  );
                }
                if (state is EventListLoaded) {
                  final items = state.events;
                  if (items.isEmpty) {
                    return const Center(
                        child: Text('No events match your search.'));
                  }
                  return RefreshIndicator(
                    onRefresh: () async => context
                        .read<EventListBloc>()
                        .add(LoadEvents(query: _search.text)),
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) =>
                          _EventCard(event: items[index]),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventEntity event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final gradient =
        const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF00D4FF)]);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => EventDetailPage(id: event.id))),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16)),
                child: SizedBox(
                  width: 110,
                  height: 110,
                  child: Image.network(
                    event.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, size: 36),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (rect) => gradient.createShader(rect),
                        child: Text(event.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white)),
                      ),
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.schedule, size: 16),
                        const SizedBox(width: 6),
                        Text(formatDate(event.date))
                      ]),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.place, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                            child: Text(event.location,
                                maxLines: 1, overflow: TextOverflow.ellipsis))
                      ]),
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.confirmation_num_outlined, size: 16),
                        const SizedBox(width: 6),
                        Text('${event.ticketsAvailable} left',
                            style: TextStyle(
                                color: event.ticketsAvailable > 0
                                    ? Colors.green
                                    : Colors.red))
                      ]),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
