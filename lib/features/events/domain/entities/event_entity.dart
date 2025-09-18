import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final int ticketsAvailable;
  final String thumbnailUrl;
  final String imageUrl;

  const EventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.ticketsAvailable,
    required this.thumbnailUrl,
    required this.imageUrl,
  });

  EventEntity copyWith({int? ticketsAvailable}) => EventEntity(
        id: id,
        title: title,
        description: description,
        date: date,
        location: location,
        ticketsAvailable: ticketsAvailable ?? this.ticketsAvailable,
        thumbnailUrl: thumbnailUrl,
        imageUrl: imageUrl,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        date,
        location,
        ticketsAvailable,
        thumbnailUrl,
        imageUrl
      ];
}
