import '../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.date,
    required super.location,
    required super.ticketsAvailable,
    required super.thumbnailUrl,
    required super.imageUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      location: json['location'] ?? '',
      ticketsAvailable: (json['tickets'] ?? 0) as int,
      thumbnailUrl: json['image'] ?? '',
      imageUrl: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'location': location,
        'ticketsAvailable': ticketsAvailable,
        'thumbnailUrl': thumbnailUrl,
        'imageUrl': imageUrl,
      };

  factory EventModel.fromEntity(EventEntity entity) {
    return EventModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      date: entity.date,
      location: entity.location,
      ticketsAvailable: entity.ticketsAvailable,
      thumbnailUrl: entity.thumbnailUrl,
      imageUrl: entity.imageUrl,
    );
  }
}
