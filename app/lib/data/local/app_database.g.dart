// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SleepEntriesTable extends SleepEntries
    with TableInfo<$SleepEntriesTable, SleepEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepStartMeta = const VerificationMeta(
    'sleepStart',
  );
  @override
  late final GeneratedColumn<DateTime> sleepStart = GeneratedColumn<DateTime>(
    'sleep_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sleepEndMeta = const VerificationMeta(
    'sleepEnd',
  );
  @override
  late final GeneratedColumn<DateTime> sleepEnd = GeneratedColumn<DateTime>(
    'sleep_end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SleepSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SleepSource>($SleepEntriesTable.$convertersource);
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
    'quality',
    aliasedName,
    true,
    check: () => ComparableExpr(quality).isBetweenValues(1, 10),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    sleepStart,
    sleepEnd,
    source,
    quality,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sleep_start')) {
      context.handle(
        _sleepStartMeta,
        sleepStart.isAcceptableOrUnknown(data['sleep_start']!, _sleepStartMeta),
      );
    } else if (isInserting) {
      context.missing(_sleepStartMeta);
    }
    if (data.containsKey('sleep_end')) {
      context.handle(
        _sleepEndMeta,
        sleepEnd.isAcceptableOrUnknown(data['sleep_end']!, _sleepEndMeta),
      );
    } else if (isInserting) {
      context.missing(_sleepEndMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SleepEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      sleepStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sleep_start'],
      )!,
      sleepEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sleep_end'],
      )!,
      source: $SleepEntriesTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SleepEntriesTable createAlias(String alias) {
    return $SleepEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SleepSource, String, String> $convertersource =
      const EnumNameConverter<SleepSource>(SleepSource.values);
}

class SleepEntry extends DataClass implements Insertable<SleepEntry> {
  /// UUID generated on the phone, the same on every device.
  final String id;
  final DateTime createdAt;

  /// Set on every local change; resolves sync conflicts (latest wins).
  final DateTime updatedAt;

  /// Soft delete: deletions are synced like any other change.
  final DateTime? deletedAt;
  final DateTime sleepStart;
  final DateTime sleepEnd;

  /// Stored as text "health" / "manual", same values as the server enum.
  final SleepSource source;

  /// Null until the morning rating.
  final int? quality;
  final String? note;
  const SleepEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.sleepStart,
    required this.sleepEnd,
    required this.source,
    this.quality,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sleep_start'] = Variable<DateTime>(sleepStart);
    map['sleep_end'] = Variable<DateTime>(sleepEnd);
    {
      map['source'] = Variable<String>(
        $SleepEntriesTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || quality != null) {
      map['quality'] = Variable<int>(quality);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SleepEntriesCompanion toCompanion(bool nullToAbsent) {
    return SleepEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      sleepStart: Value(sleepStart),
      sleepEnd: Value(sleepEnd),
      source: Value(source),
      quality: quality == null && nullToAbsent
          ? const Value.absent()
          : Value(quality),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory SleepEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      sleepStart: serializer.fromJson<DateTime>(json['sleepStart']),
      sleepEnd: serializer.fromJson<DateTime>(json['sleepEnd']),
      source: $SleepEntriesTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      quality: serializer.fromJson<int?>(json['quality']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'sleepStart': serializer.toJson<DateTime>(sleepStart),
      'sleepEnd': serializer.toJson<DateTime>(sleepEnd),
      'source': serializer.toJson<String>(
        $SleepEntriesTable.$convertersource.toJson(source),
      ),
      'quality': serializer.toJson<int?>(quality),
      'note': serializer.toJson<String?>(note),
    };
  }

  SleepEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? sleepStart,
    DateTime? sleepEnd,
    SleepSource? source,
    Value<int?> quality = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => SleepEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    sleepStart: sleepStart ?? this.sleepStart,
    sleepEnd: sleepEnd ?? this.sleepEnd,
    source: source ?? this.source,
    quality: quality.present ? quality.value : this.quality,
    note: note.present ? note.value : this.note,
  );
  SleepEntry copyWithCompanion(SleepEntriesCompanion data) {
    return SleepEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      sleepStart: data.sleepStart.present
          ? data.sleepStart.value
          : this.sleepStart,
      sleepEnd: data.sleepEnd.present ? data.sleepEnd.value : this.sleepEnd,
      source: data.source.present ? data.source.value : this.source,
      quality: data.quality.present ? data.quality.value : this.quality,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('sleepStart: $sleepStart, ')
          ..write('sleepEnd: $sleepEnd, ')
          ..write('source: $source, ')
          ..write('quality: $quality, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    sleepStart,
    sleepEnd,
    source,
    quality,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.sleepStart == this.sleepStart &&
          other.sleepEnd == this.sleepEnd &&
          other.source == this.source &&
          other.quality == this.quality &&
          other.note == this.note);
}

class SleepEntriesCompanion extends UpdateCompanion<SleepEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> sleepStart;
  final Value<DateTime> sleepEnd;
  final Value<SleepSource> source;
  final Value<int?> quality;
  final Value<String?> note;
  final Value<int> rowid;
  const SleepEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.sleepStart = const Value.absent(),
    this.sleepEnd = const Value.absent(),
    this.source = const Value.absent(),
    this.quality = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SleepEntriesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required DateTime sleepStart,
    required DateTime sleepEnd,
    required SleepSource source,
    this.quality = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       sleepStart = Value(sleepStart),
       sleepEnd = Value(sleepEnd),
       source = Value(source);
  static Insertable<SleepEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? sleepStart,
    Expression<DateTime>? sleepEnd,
    Expression<String>? source,
    Expression<int>? quality,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (sleepStart != null) 'sleep_start': sleepStart,
      if (sleepEnd != null) 'sleep_end': sleepEnd,
      if (source != null) 'source': source,
      if (quality != null) 'quality': quality,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SleepEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? sleepStart,
    Value<DateTime>? sleepEnd,
    Value<SleepSource>? source,
    Value<int?>? quality,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return SleepEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      sleepStart: sleepStart ?? this.sleepStart,
      sleepEnd: sleepEnd ?? this.sleepEnd,
      source: source ?? this.source,
      quality: quality ?? this.quality,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (sleepStart.present) {
      map['sleep_start'] = Variable<DateTime>(sleepStart.value);
    }
    if (sleepEnd.present) {
      map['sleep_end'] = Variable<DateTime>(sleepEnd.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $SleepEntriesTable.$convertersource.toSql(source.value),
      );
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleepEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('sleepStart: $sleepStart, ')
          ..write('sleepEnd: $sleepEnd, ')
          ..write('source: $source, ')
          ..write('quality: $quality, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyCheckinsTable extends DailyCheckins
    with TableInfo<$DailyCheckinsTable, DailyCheckin> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyCheckinsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    false,
    check: () => ComparableExpr(mood).isBetweenValues(1, 10),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _energyMeta = const VerificationMeta('energy');
  @override
  late final GeneratedColumn<int> energy = GeneratedColumn<int>(
    'energy',
    aliasedName,
    false,
    check: () => ComparableExpr(energy).isBetweenValues(1, 10),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productivityMeta = const VerificationMeta(
    'productivity',
  );
  @override
  late final GeneratedColumn<int> productivity = GeneratedColumn<int>(
    'productivity',
    aliasedName,
    false,
    check: () => ComparableExpr(productivity).isBetweenValues(1, 10),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    date,
    mood,
    energy,
    productivity,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_checkins';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyCheckin> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('energy')) {
      context.handle(
        _energyMeta,
        energy.isAcceptableOrUnknown(data['energy']!, _energyMeta),
      );
    } else if (isInserting) {
      context.missing(_energyMeta);
    }
    if (data.containsKey('productivity')) {
      context.handle(
        _productivityMeta,
        productivity.isAcceptableOrUnknown(
          data['productivity']!,
          _productivityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productivityMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyCheckin map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyCheckin(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      )!,
      energy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy'],
      )!,
      productivity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}productivity'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $DailyCheckinsTable createAlias(String alias) {
    return $DailyCheckinsTable(attachedDatabase, alias);
  }
}

class DailyCheckin extends DataClass implements Insertable<DailyCheckin> {
  /// UUID generated on the phone, the same on every device.
  final String id;
  final DateTime createdAt;

  /// Set on every local change; resolves sync conflicts (latest wins).
  final DateTime updatedAt;

  /// Soft delete: deletions are synced like any other change.
  final DateTime? deletedAt;

  /// Local calendar date as "YYYY-MM-DD": exact, sortable, matches the API.
  final String date;
  final int mood;
  final int energy;
  final int productivity;
  final String? note;
  const DailyCheckin({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.date,
    required this.mood,
    required this.energy,
    required this.productivity,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['date'] = Variable<String>(date);
    map['mood'] = Variable<int>(mood);
    map['energy'] = Variable<int>(energy);
    map['productivity'] = Variable<int>(productivity);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  DailyCheckinsCompanion toCompanion(bool nullToAbsent) {
    return DailyCheckinsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      date: Value(date),
      mood: Value(mood),
      energy: Value(energy),
      productivity: Value(productivity),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory DailyCheckin.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyCheckin(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      date: serializer.fromJson<String>(json['date']),
      mood: serializer.fromJson<int>(json['mood']),
      energy: serializer.fromJson<int>(json['energy']),
      productivity: serializer.fromJson<int>(json['productivity']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'date': serializer.toJson<String>(date),
      'mood': serializer.toJson<int>(mood),
      'energy': serializer.toJson<int>(energy),
      'productivity': serializer.toJson<int>(productivity),
      'note': serializer.toJson<String?>(note),
    };
  }

  DailyCheckin copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? date,
    int? mood,
    int? energy,
    int? productivity,
    Value<String?> note = const Value.absent(),
  }) => DailyCheckin(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    date: date ?? this.date,
    mood: mood ?? this.mood,
    energy: energy ?? this.energy,
    productivity: productivity ?? this.productivity,
    note: note.present ? note.value : this.note,
  );
  DailyCheckin copyWithCompanion(DailyCheckinsCompanion data) {
    return DailyCheckin(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      date: data.date.present ? data.date.value : this.date,
      mood: data.mood.present ? data.mood.value : this.mood,
      energy: data.energy.present ? data.energy.value : this.energy,
      productivity: data.productivity.present
          ? data.productivity.value
          : this.productivity,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyCheckin(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('date: $date, ')
          ..write('mood: $mood, ')
          ..write('energy: $energy, ')
          ..write('productivity: $productivity, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    date,
    mood,
    energy,
    productivity,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyCheckin &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.date == this.date &&
          other.mood == this.mood &&
          other.energy == this.energy &&
          other.productivity == this.productivity &&
          other.note == this.note);
}

class DailyCheckinsCompanion extends UpdateCompanion<DailyCheckin> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> date;
  final Value<int> mood;
  final Value<int> energy;
  final Value<int> productivity;
  final Value<String?> note;
  final Value<int> rowid;
  const DailyCheckinsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.date = const Value.absent(),
    this.mood = const Value.absent(),
    this.energy = const Value.absent(),
    this.productivity = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyCheckinsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required String date,
    required int mood,
    required int energy,
    required int productivity,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       date = Value(date),
       mood = Value(mood),
       energy = Value(energy),
       productivity = Value(productivity);
  static Insertable<DailyCheckin> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? date,
    Expression<int>? mood,
    Expression<int>? energy,
    Expression<int>? productivity,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (date != null) 'date': date,
      if (mood != null) 'mood': mood,
      if (energy != null) 'energy': energy,
      if (productivity != null) 'productivity': productivity,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyCheckinsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? date,
    Value<int>? mood,
    Value<int>? energy,
    Value<int>? productivity,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return DailyCheckinsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      productivity: productivity ?? this.productivity,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (energy.present) {
      map['energy'] = Variable<int>(energy.value);
    }
    if (productivity.present) {
      map['productivity'] = Variable<int>(productivity.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyCheckinsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('date: $date, ')
          ..write('mood: $mood, ')
          ..write('energy: $energy, ')
          ..write('productivity: $productivity, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, UserSettings> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UTC'),
  );
  static const VerificationMeta _sleepGoalMinutesMeta = const VerificationMeta(
    'sleepGoalMinutes',
  );
  @override
  late final GeneratedColumn<int> sleepGoalMinutes = GeneratedColumn<int>(
    'sleep_goal_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(480),
  );
  static const VerificationMeta _bedtimeMeta = const VerificationMeta(
    'bedtime',
  );
  @override
  late final GeneratedColumn<int> bedtime = GeneratedColumn<int>(
    'bedtime',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(23 * 60),
  );
  static const VerificationMeta _windDownMinutesMeta = const VerificationMeta(
    'windDownMinutes',
  );
  @override
  late final GeneratedColumn<int> windDownMinutes = GeneratedColumn<int>(
    'wind_down_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(120),
  );
  static const VerificationMeta _morningReminderMeta = const VerificationMeta(
    'morningReminder',
  );
  @override
  late final GeneratedColumn<int> morningReminder = GeneratedColumn<int>(
    'morning_reminder',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(9 * 60),
  );
  static const VerificationMeta _eveningReminderMeta = const VerificationMeta(
    'eveningReminder',
  );
  @override
  late final GeneratedColumn<int> eveningReminder = GeneratedColumn<int>(
    'evening_reminder',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(21 * 60),
  );
  static const VerificationMeta _shareNotesWithAiMeta = const VerificationMeta(
    'shareNotesWithAi',
  );
  @override
  late final GeneratedColumn<bool> shareNotesWithAi = GeneratedColumn<bool>(
    'share_notes_with_ai',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("share_notes_with_ai" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    timezone,
    sleepGoalMinutes,
    bedtime,
    windDownMinutes,
    morningReminder,
    eveningReminder,
    shareNotesWithAi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettings> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    }
    if (data.containsKey('sleep_goal_minutes')) {
      context.handle(
        _sleepGoalMinutesMeta,
        sleepGoalMinutes.isAcceptableOrUnknown(
          data['sleep_goal_minutes']!,
          _sleepGoalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('bedtime')) {
      context.handle(
        _bedtimeMeta,
        bedtime.isAcceptableOrUnknown(data['bedtime']!, _bedtimeMeta),
      );
    }
    if (data.containsKey('wind_down_minutes')) {
      context.handle(
        _windDownMinutesMeta,
        windDownMinutes.isAcceptableOrUnknown(
          data['wind_down_minutes']!,
          _windDownMinutesMeta,
        ),
      );
    }
    if (data.containsKey('morning_reminder')) {
      context.handle(
        _morningReminderMeta,
        morningReminder.isAcceptableOrUnknown(
          data['morning_reminder']!,
          _morningReminderMeta,
        ),
      );
    }
    if (data.containsKey('evening_reminder')) {
      context.handle(
        _eveningReminderMeta,
        eveningReminder.isAcceptableOrUnknown(
          data['evening_reminder']!,
          _eveningReminderMeta,
        ),
      );
    }
    if (data.containsKey('share_notes_with_ai')) {
      context.handle(
        _shareNotesWithAiMeta,
        shareNotesWithAi.isAcceptableOrUnknown(
          data['share_notes_with_ai']!,
          _shareNotesWithAiMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSettings map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettings(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
      sleepGoalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_goal_minutes'],
      )!,
      bedtime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bedtime'],
      )!,
      windDownMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wind_down_minutes'],
      )!,
      morningReminder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}morning_reminder'],
      ),
      eveningReminder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}evening_reminder'],
      ),
      shareNotesWithAi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}share_notes_with_ai'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class UserSettings extends DataClass implements Insertable<UserSettings> {
  /// UUID generated on the phone, the same on every device.
  final String id;
  final DateTime createdAt;

  /// Set on every local change; resolves sync conflicts (latest wins).
  final DateTime updatedAt;

  /// Soft delete: deletions are synced like any other change.
  final DateTime? deletedAt;
  final String timezone;
  final int sleepGoalMinutes;
  final int bedtime;
  final int windDownMinutes;

  /// Null means the reminder is turned off.
  final int? morningReminder;
  final int? eveningReminder;
  final bool shareNotesWithAi;
  const UserSettings({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.timezone,
    required this.sleepGoalMinutes,
    required this.bedtime,
    required this.windDownMinutes,
    this.morningReminder,
    this.eveningReminder,
    required this.shareNotesWithAi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['timezone'] = Variable<String>(timezone);
    map['sleep_goal_minutes'] = Variable<int>(sleepGoalMinutes);
    map['bedtime'] = Variable<int>(bedtime);
    map['wind_down_minutes'] = Variable<int>(windDownMinutes);
    if (!nullToAbsent || morningReminder != null) {
      map['morning_reminder'] = Variable<int>(morningReminder);
    }
    if (!nullToAbsent || eveningReminder != null) {
      map['evening_reminder'] = Variable<int>(eveningReminder);
    }
    map['share_notes_with_ai'] = Variable<bool>(shareNotesWithAi);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      timezone: Value(timezone),
      sleepGoalMinutes: Value(sleepGoalMinutes),
      bedtime: Value(bedtime),
      windDownMinutes: Value(windDownMinutes),
      morningReminder: morningReminder == null && nullToAbsent
          ? const Value.absent()
          : Value(morningReminder),
      eveningReminder: eveningReminder == null && nullToAbsent
          ? const Value.absent()
          : Value(eveningReminder),
      shareNotesWithAi: Value(shareNotesWithAi),
    );
  }

  factory UserSettings.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettings(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      timezone: serializer.fromJson<String>(json['timezone']),
      sleepGoalMinutes: serializer.fromJson<int>(json['sleepGoalMinutes']),
      bedtime: serializer.fromJson<int>(json['bedtime']),
      windDownMinutes: serializer.fromJson<int>(json['windDownMinutes']),
      morningReminder: serializer.fromJson<int?>(json['morningReminder']),
      eveningReminder: serializer.fromJson<int?>(json['eveningReminder']),
      shareNotesWithAi: serializer.fromJson<bool>(json['shareNotesWithAi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'timezone': serializer.toJson<String>(timezone),
      'sleepGoalMinutes': serializer.toJson<int>(sleepGoalMinutes),
      'bedtime': serializer.toJson<int>(bedtime),
      'windDownMinutes': serializer.toJson<int>(windDownMinutes),
      'morningReminder': serializer.toJson<int?>(morningReminder),
      'eveningReminder': serializer.toJson<int?>(eveningReminder),
      'shareNotesWithAi': serializer.toJson<bool>(shareNotesWithAi),
    };
  }

  UserSettings copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? timezone,
    int? sleepGoalMinutes,
    int? bedtime,
    int? windDownMinutes,
    Value<int?> morningReminder = const Value.absent(),
    Value<int?> eveningReminder = const Value.absent(),
    bool? shareNotesWithAi,
  }) => UserSettings(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    timezone: timezone ?? this.timezone,
    sleepGoalMinutes: sleepGoalMinutes ?? this.sleepGoalMinutes,
    bedtime: bedtime ?? this.bedtime,
    windDownMinutes: windDownMinutes ?? this.windDownMinutes,
    morningReminder: morningReminder.present
        ? morningReminder.value
        : this.morningReminder,
    eveningReminder: eveningReminder.present
        ? eveningReminder.value
        : this.eveningReminder,
    shareNotesWithAi: shareNotesWithAi ?? this.shareNotesWithAi,
  );
  UserSettings copyWithCompanion(SettingsCompanion data) {
    return UserSettings(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      sleepGoalMinutes: data.sleepGoalMinutes.present
          ? data.sleepGoalMinutes.value
          : this.sleepGoalMinutes,
      bedtime: data.bedtime.present ? data.bedtime.value : this.bedtime,
      windDownMinutes: data.windDownMinutes.present
          ? data.windDownMinutes.value
          : this.windDownMinutes,
      morningReminder: data.morningReminder.present
          ? data.morningReminder.value
          : this.morningReminder,
      eveningReminder: data.eveningReminder.present
          ? data.eveningReminder.value
          : this.eveningReminder,
      shareNotesWithAi: data.shareNotesWithAi.present
          ? data.shareNotesWithAi.value
          : this.shareNotesWithAi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettings(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('timezone: $timezone, ')
          ..write('sleepGoalMinutes: $sleepGoalMinutes, ')
          ..write('bedtime: $bedtime, ')
          ..write('windDownMinutes: $windDownMinutes, ')
          ..write('morningReminder: $morningReminder, ')
          ..write('eveningReminder: $eveningReminder, ')
          ..write('shareNotesWithAi: $shareNotesWithAi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    timezone,
    sleepGoalMinutes,
    bedtime,
    windDownMinutes,
    morningReminder,
    eveningReminder,
    shareNotesWithAi,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettings &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.timezone == this.timezone &&
          other.sleepGoalMinutes == this.sleepGoalMinutes &&
          other.bedtime == this.bedtime &&
          other.windDownMinutes == this.windDownMinutes &&
          other.morningReminder == this.morningReminder &&
          other.eveningReminder == this.eveningReminder &&
          other.shareNotesWithAi == this.shareNotesWithAi);
}

class SettingsCompanion extends UpdateCompanion<UserSettings> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> timezone;
  final Value<int> sleepGoalMinutes;
  final Value<int> bedtime;
  final Value<int> windDownMinutes;
  final Value<int?> morningReminder;
  final Value<int?> eveningReminder;
  final Value<bool> shareNotesWithAi;
  final Value<int> rowid;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.timezone = const Value.absent(),
    this.sleepGoalMinutes = const Value.absent(),
    this.bedtime = const Value.absent(),
    this.windDownMinutes = const Value.absent(),
    this.morningReminder = const Value.absent(),
    this.eveningReminder = const Value.absent(),
    this.shareNotesWithAi = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.timezone = const Value.absent(),
    this.sleepGoalMinutes = const Value.absent(),
    this.bedtime = const Value.absent(),
    this.windDownMinutes = const Value.absent(),
    this.morningReminder = const Value.absent(),
    this.eveningReminder = const Value.absent(),
    this.shareNotesWithAi = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserSettings> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? timezone,
    Expression<int>? sleepGoalMinutes,
    Expression<int>? bedtime,
    Expression<int>? windDownMinutes,
    Expression<int>? morningReminder,
    Expression<int>? eveningReminder,
    Expression<bool>? shareNotesWithAi,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (timezone != null) 'timezone': timezone,
      if (sleepGoalMinutes != null) 'sleep_goal_minutes': sleepGoalMinutes,
      if (bedtime != null) 'bedtime': bedtime,
      if (windDownMinutes != null) 'wind_down_minutes': windDownMinutes,
      if (morningReminder != null) 'morning_reminder': morningReminder,
      if (eveningReminder != null) 'evening_reminder': eveningReminder,
      if (shareNotesWithAi != null) 'share_notes_with_ai': shareNotesWithAi,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? timezone,
    Value<int>? sleepGoalMinutes,
    Value<int>? bedtime,
    Value<int>? windDownMinutes,
    Value<int?>? morningReminder,
    Value<int?>? eveningReminder,
    Value<bool>? shareNotesWithAi,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      timezone: timezone ?? this.timezone,
      sleepGoalMinutes: sleepGoalMinutes ?? this.sleepGoalMinutes,
      bedtime: bedtime ?? this.bedtime,
      windDownMinutes: windDownMinutes ?? this.windDownMinutes,
      morningReminder: morningReminder ?? this.morningReminder,
      eveningReminder: eveningReminder ?? this.eveningReminder,
      shareNotesWithAi: shareNotesWithAi ?? this.shareNotesWithAi,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (sleepGoalMinutes.present) {
      map['sleep_goal_minutes'] = Variable<int>(sleepGoalMinutes.value);
    }
    if (bedtime.present) {
      map['bedtime'] = Variable<int>(bedtime.value);
    }
    if (windDownMinutes.present) {
      map['wind_down_minutes'] = Variable<int>(windDownMinutes.value);
    }
    if (morningReminder.present) {
      map['morning_reminder'] = Variable<int>(morningReminder.value);
    }
    if (eveningReminder.present) {
      map['evening_reminder'] = Variable<int>(eveningReminder.value);
    }
    if (shareNotesWithAi.present) {
      map['share_notes_with_ai'] = Variable<bool>(shareNotesWithAi.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('timezone: $timezone, ')
          ..write('sleepGoalMinutes: $sleepGoalMinutes, ')
          ..write('bedtime: $bedtime, ')
          ..write('windDownMinutes: $windDownMinutes, ')
          ..write('morningReminder: $morningReminder, ')
          ..write('eveningReminder: $eveningReminder, ')
          ..write('shareNotesWithAi: $shareNotesWithAi, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SleepEntriesTable sleepEntries = $SleepEntriesTable(this);
  late final $DailyCheckinsTable dailyCheckins = $DailyCheckinsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sleepEntries,
    dailyCheckins,
    settings,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$SleepEntriesTableCreateCompanionBuilder =
    SleepEntriesCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      required DateTime sleepStart,
      required DateTime sleepEnd,
      required SleepSource source,
      Value<int?> quality,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$SleepEntriesTableUpdateCompanionBuilder =
    SleepEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> sleepStart,
      Value<DateTime> sleepEnd,
      Value<SleepSource> source,
      Value<int?> quality,
      Value<String?> note,
      Value<int> rowid,
    });

class $$SleepEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SleepEntriesTable> {
  $$SleepEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sleepStart => $composableBuilder(
    column: $table.sleepStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sleepEnd => $composableBuilder(
    column: $table.sleepEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SleepSource, SleepSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SleepEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepEntriesTable> {
  $$SleepEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sleepStart => $composableBuilder(
    column: $table.sleepStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sleepEnd => $composableBuilder(
    column: $table.sleepEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SleepEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepEntriesTable> {
  $$SleepEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get sleepStart => $composableBuilder(
    column: $table.sleepStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sleepEnd =>
      $composableBuilder(column: $table.sleepEnd, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SleepSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$SleepEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepEntriesTable,
          SleepEntry,
          $$SleepEntriesTableFilterComposer,
          $$SleepEntriesTableOrderingComposer,
          $$SleepEntriesTableAnnotationComposer,
          $$SleepEntriesTableCreateCompanionBuilder,
          $$SleepEntriesTableUpdateCompanionBuilder,
          (
            SleepEntry,
            BaseReferences<_$AppDatabase, $SleepEntriesTable, SleepEntry>,
          ),
          SleepEntry,
          PrefetchHooks Function()
        > {
  $$SleepEntriesTableTableManager(_$AppDatabase db, $SleepEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> sleepStart = const Value.absent(),
                Value<DateTime> sleepEnd = const Value.absent(),
                Value<SleepSource> source = const Value.absent(),
                Value<int?> quality = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SleepEntriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                sleepStart: sleepStart,
                sleepEnd: sleepEnd,
                source: source,
                quality: quality,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required DateTime sleepStart,
                required DateTime sleepEnd,
                required SleepSource source,
                Value<int?> quality = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SleepEntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                sleepStart: sleepStart,
                sleepEnd: sleepEnd,
                source: source,
                quality: quality,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SleepEntriesTable, SleepEntry>(table),
                  BaseReferences<_$AppDatabase, $SleepEntriesTable, SleepEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SleepEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepEntriesTable,
      SleepEntry,
      $$SleepEntriesTableFilterComposer,
      $$SleepEntriesTableOrderingComposer,
      $$SleepEntriesTableAnnotationComposer,
      $$SleepEntriesTableCreateCompanionBuilder,
      $$SleepEntriesTableUpdateCompanionBuilder,
      (
        SleepEntry,
        BaseReferences<_$AppDatabase, $SleepEntriesTable, SleepEntry>,
      ),
      SleepEntry,
      PrefetchHooks Function()
    >;
typedef $$DailyCheckinsTableCreateCompanionBuilder =
    DailyCheckinsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      required String date,
      required int mood,
      required int energy,
      required int productivity,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$DailyCheckinsTableUpdateCompanionBuilder =
    DailyCheckinsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> date,
      Value<int> mood,
      Value<int> energy,
      Value<int> productivity,
      Value<String?> note,
      Value<int> rowid,
    });

class $$DailyCheckinsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyCheckinsTable> {
  $$DailyCheckinsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productivity => $composableBuilder(
    column: $table.productivity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyCheckinsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyCheckinsTable> {
  $$DailyCheckinsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productivity => $composableBuilder(
    column: $table.productivity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyCheckinsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyCheckinsTable> {
  $$DailyCheckinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<int> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => column);

  GeneratedColumn<int> get productivity => $composableBuilder(
    column: $table.productivity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$DailyCheckinsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyCheckinsTable,
          DailyCheckin,
          $$DailyCheckinsTableFilterComposer,
          $$DailyCheckinsTableOrderingComposer,
          $$DailyCheckinsTableAnnotationComposer,
          $$DailyCheckinsTableCreateCompanionBuilder,
          $$DailyCheckinsTableUpdateCompanionBuilder,
          (
            DailyCheckin,
            BaseReferences<_$AppDatabase, $DailyCheckinsTable, DailyCheckin>,
          ),
          DailyCheckin,
          PrefetchHooks Function()
        > {
  $$DailyCheckinsTableTableManager(_$AppDatabase db, $DailyCheckinsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyCheckinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyCheckinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyCheckinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> mood = const Value.absent(),
                Value<int> energy = const Value.absent(),
                Value<int> productivity = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyCheckinsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                date: date,
                mood: mood,
                energy: energy,
                productivity: productivity,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required String date,
                required int mood,
                required int energy,
                required int productivity,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyCheckinsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                date: date,
                mood: mood,
                energy: energy,
                productivity: productivity,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyCheckinsTable, DailyCheckin>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DailyCheckinsTable,
                    DailyCheckin
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyCheckinsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyCheckinsTable,
      DailyCheckin,
      $$DailyCheckinsTableFilterComposer,
      $$DailyCheckinsTableOrderingComposer,
      $$DailyCheckinsTableAnnotationComposer,
      $$DailyCheckinsTableCreateCompanionBuilder,
      $$DailyCheckinsTableUpdateCompanionBuilder,
      (
        DailyCheckin,
        BaseReferences<_$AppDatabase, $DailyCheckinsTable, DailyCheckin>,
      ),
      DailyCheckin,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> timezone,
  Value<int> sleepGoalMinutes,
  Value<int> bedtime,
  Value<int> windDownMinutes,
  Value<int?> morningReminder,
  Value<int?> eveningReminder,
  Value<bool> shareNotesWithAi,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> timezone,
  Value<int> sleepGoalMinutes,
  Value<int> bedtime,
  Value<int> windDownMinutes,
  Value<int?> morningReminder,
  Value<int?> eveningReminder,
  Value<bool> shareNotesWithAi,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepGoalMinutes => $composableBuilder(
    column: $table.sleepGoalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bedtime => $composableBuilder(
    column: $table.bedtime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get windDownMinutes => $composableBuilder(
    column: $table.windDownMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get morningReminder => $composableBuilder(
    column: $table.morningReminder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eveningReminder => $composableBuilder(
    column: $table.eveningReminder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get shareNotesWithAi => $composableBuilder(
    column: $table.shareNotesWithAi,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepGoalMinutes => $composableBuilder(
    column: $table.sleepGoalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bedtime => $composableBuilder(
    column: $table.bedtime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get windDownMinutes => $composableBuilder(
    column: $table.windDownMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get morningReminder => $composableBuilder(
    column: $table.morningReminder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eveningReminder => $composableBuilder(
    column: $table.eveningReminder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get shareNotesWithAi => $composableBuilder(
    column: $table.shareNotesWithAi,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<int> get sleepGoalMinutes => $composableBuilder(
    column: $table.sleepGoalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bedtime =>
      $composableBuilder(column: $table.bedtime, builder: (column) => column);

  GeneratedColumn<int> get windDownMinutes => $composableBuilder(
    column: $table.windDownMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get morningReminder => $composableBuilder(
    column: $table.morningReminder,
    builder: (column) => column,
  );

  GeneratedColumn<int> get eveningReminder => $composableBuilder(
    column: $table.eveningReminder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get shareNotesWithAi => $composableBuilder(
    column: $table.shareNotesWithAi,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          UserSettings,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            UserSettings,
            BaseReferences<_$AppDatabase, $SettingsTable, UserSettings>,
          ),
          UserSettings,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<int> sleepGoalMinutes = const Value.absent(),
                Value<int> bedtime = const Value.absent(),
                Value<int> windDownMinutes = const Value.absent(),
                Value<int?> morningReminder = const Value.absent(),
                Value<int?> eveningReminder = const Value.absent(),
                Value<bool> shareNotesWithAi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                timezone: timezone,
                sleepGoalMinutes: sleepGoalMinutes,
                bedtime: bedtime,
                windDownMinutes: windDownMinutes,
                morningReminder: morningReminder,
                eveningReminder: eveningReminder,
                shareNotesWithAi: shareNotesWithAi,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<int> sleepGoalMinutes = const Value.absent(),
                Value<int> bedtime = const Value.absent(),
                Value<int> windDownMinutes = const Value.absent(),
                Value<int?> morningReminder = const Value.absent(),
                Value<int?> eveningReminder = const Value.absent(),
                Value<bool> shareNotesWithAi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                timezone: timezone,
                sleepGoalMinutes: sleepGoalMinutes,
                bedtime: bedtime,
                windDownMinutes: windDownMinutes,
                morningReminder: morningReminder,
                eveningReminder: eveningReminder,
                shareNotesWithAi: shareNotesWithAi,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, UserSettings>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, UserSettings>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      UserSettings,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (
        UserSettings,
        BaseReferences<_$AppDatabase, $SettingsTable, UserSettings>,
      ),
      UserSettings,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SleepEntriesTableTableManager get sleepEntries =>
      $$SleepEntriesTableTableManager(_db, _db.sleepEntries);
  $$DailyCheckinsTableTableManager get dailyCheckins =>
      $$DailyCheckinsTableTableManager(_db, _db.dailyCheckins);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
