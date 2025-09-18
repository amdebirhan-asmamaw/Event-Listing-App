// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventHiveModelAdapter extends TypeAdapter<EventHiveModel> {
  @override
  final int typeId = 0;

  @override
  EventHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      date: fields[3] as DateTime,
      location: fields[4] as String,
      ticketsAvailable: fields[5] as int,
      thumbnailUrl: fields[6] as String,
      imageUrl: fields[7] as String,
      lastUpdated: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EventHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.ticketsAvailable)
      ..writeByte(6)
      ..write(obj.thumbnailUrl)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
