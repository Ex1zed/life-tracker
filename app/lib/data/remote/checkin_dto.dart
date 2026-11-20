import '../local/app_database.dart';

/// A check-in as the API sends and receives it (JSON, snake_case, UTC times).
class CheckinDto {
  const CheckinDto({
    required this.id,
    required this.date,
    required this.mood,
    required this.energy,
    required this.productivity,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String id;
  final String date;
  final int mood;
  final int energy;
  final int productivity;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  factory CheckinDto.fromJson(Map<String, dynamic> json) => CheckinDto(
        id: json['id'] as String,
        date: json['date'] as String,
        mood: json['mood'] as int,
        energy: json['energy'] as int,
        productivity: json['productivity'] as int,
        note: json['note'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        deletedAt: json['deleted_at'] == null
            ? null
            : DateTime.parse(json['deleted_at'] as String),
      );

  factory CheckinDto.fromRow(DailyCheckin row) => CheckinDto(
        id: row.id,
        date: row.date,
        mood: row.mood,
        energy: row.energy,
        productivity: row.productivity,
        note: row.note,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'mood': mood,
        'energy': energy,
        'productivity': productivity,
        'note': note,
        'created_at': createdAt.toUtc().toIso8601String(),
        'updated_at': updatedAt.toUtc().toIso8601String(),
        'deleted_at': deletedAt?.toUtc().toIso8601String(),
      };
}