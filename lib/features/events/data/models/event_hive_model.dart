import 'package:hive/hive.dart';
import '../../domain/entities/event_entity.dart';

part 'event_hive_model.g.dart';

@HiveType(typeId: 0)
class EventHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String location;

  @HiveField(5)
  final int ticketsAvailable;

  @HiveField(6)
  final String thumbnailUrl;

  @HiveField(7)
  final String imageUrl;

  @HiveField(8)
  final DateTime lastUpdated;

  EventHiveModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.ticketsAvailable,
    required this.thumbnailUrl,
    required this.imageUrl,
    required this.lastUpdated,
  });

  factory EventHiveModel.fromEntity(EventEntity entity) {
    return EventHiveModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      date: entity.date,
      location: entity.location,
      ticketsAvailable: entity.ticketsAvailable,
      thumbnailUrl: entity.thumbnailUrl,
      imageUrl: entity.imageUrl,
      lastUpdated: DateTime.now(),
    );
  }

  EventEntity toEntity() {
    return EventEntity(
      id: id,
      title: title,
      description: description,
      date: date,
      location: location,
      ticketsAvailable: ticketsAvailable,
      thumbnailUrl: thumbnailUrl,
      imageUrl: imageUrl,
    );
  }

  EventHiveModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? location,
    int? ticketsAvailable,
    String? thumbnailUrl,
    String? imageUrl,
    DateTime? lastUpdated,
  }) {
    return EventHiveModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      ticketsAvailable: ticketsAvailable ?? this.ticketsAvailable,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
