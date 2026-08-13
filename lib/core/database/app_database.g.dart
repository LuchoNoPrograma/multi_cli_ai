// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CliProfilesTable extends CliProfiles
    with TableInfo<$CliProfilesTable, CliProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CliProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toolKeyMeta = const VerificationMeta(
    'toolKey',
  );
  @override
  late final GeneratedColumn<String> toolKey = GeneratedColumn<String>(
    'tool_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('codex'),
  );
  static const VerificationMeta _profileNameMeta = const VerificationMeta(
    'profileName',
  );
  @override
  late final GeneratedColumn<String> profileName = GeneratedColumn<String>(
    'profile_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commandNameMeta = const VerificationMeta(
    'commandName',
  );
  @override
  late final GeneratedColumn<String> commandName = GeneratedColumn<String>(
    'command_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileHomeMeta = const VerificationMeta(
    'profileHome',
  );
  @override
  late final GeneratedColumn<String> profileHome = GeneratedColumn<String>(
    'profile_home',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _profileSourceMeta = const VerificationMeta(
    'profileSource',
  );
  @override
  late final GeneratedColumn<String> profileSource = GeneratedColumn<String>(
    'profile_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileTypeMeta = const VerificationMeta(
    'profileType',
  );
  @override
  late final GeneratedColumn<String> profileType = GeneratedColumn<String>(
    'profile_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasAuthFileMeta = const VerificationMeta(
    'hasAuthFile',
  );
  @override
  late final GeneratedColumn<bool> hasAuthFile = GeneratedColumn<bool>(
    'has_auth_file',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_auth_file" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isAvailableMeta = const VerificationMeta(
    'isAvailable',
  );
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
    'is_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_available" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  static const VerificationMeta _lastDiscoveredAtMeta = const VerificationMeta(
    'lastDiscoveredAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastDiscoveredAt =
      GeneratedColumn<DateTime>(
        'last_discovered_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _lastLaunchedAtMeta = const VerificationMeta(
    'lastLaunchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastLaunchedAt =
      GeneratedColumn<DateTime>(
        'last_launched_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    toolKey,
    profileName,
    commandName,
    displayName,
    profileHome,
    profileSource,
    profileType,
    hasAuthFile,
    isAvailable,
    isFavorite,
    createdAt,
    lastDiscoveredAt,
    lastLaunchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cli_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<CliProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tool_key')) {
      context.handle(
        _toolKeyMeta,
        toolKey.isAcceptableOrUnknown(data['tool_key']!, _toolKeyMeta),
      );
    }
    if (data.containsKey('profile_name')) {
      context.handle(
        _profileNameMeta,
        profileName.isAcceptableOrUnknown(
          data['profile_name']!,
          _profileNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profileNameMeta);
    }
    if (data.containsKey('command_name')) {
      context.handle(
        _commandNameMeta,
        commandName.isAcceptableOrUnknown(
          data['command_name']!,
          _commandNameMeta,
        ),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('profile_home')) {
      context.handle(
        _profileHomeMeta,
        profileHome.isAcceptableOrUnknown(
          data['profile_home']!,
          _profileHomeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profileHomeMeta);
    }
    if (data.containsKey('profile_source')) {
      context.handle(
        _profileSourceMeta,
        profileSource.isAcceptableOrUnknown(
          data['profile_source']!,
          _profileSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profileSourceMeta);
    }
    if (data.containsKey('profile_type')) {
      context.handle(
        _profileTypeMeta,
        profileType.isAcceptableOrUnknown(
          data['profile_type']!,
          _profileTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profileTypeMeta);
    }
    if (data.containsKey('has_auth_file')) {
      context.handle(
        _hasAuthFileMeta,
        hasAuthFile.isAcceptableOrUnknown(
          data['has_auth_file']!,
          _hasAuthFileMeta,
        ),
      );
    }
    if (data.containsKey('is_available')) {
      context.handle(
        _isAvailableMeta,
        isAvailable.isAcceptableOrUnknown(
          data['is_available']!,
          _isAvailableMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_discovered_at')) {
      context.handle(
        _lastDiscoveredAtMeta,
        lastDiscoveredAt.isAcceptableOrUnknown(
          data['last_discovered_at']!,
          _lastDiscoveredAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastDiscoveredAtMeta);
    }
    if (data.containsKey('last_launched_at')) {
      context.handle(
        _lastLaunchedAtMeta,
        lastLaunchedAt.isAcceptableOrUnknown(
          data['last_launched_at']!,
          _lastLaunchedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CliProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CliProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      toolKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tool_key'],
      )!,
      profileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_name'],
      )!,
      commandName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}command_name'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      profileHome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_home'],
      )!,
      profileSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_source'],
      )!,
      profileType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_type'],
      )!,
      hasAuthFile: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_auth_file'],
      )!,
      isAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_available'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastDiscoveredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_discovered_at'],
      )!,
      lastLaunchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_launched_at'],
      ),
    );
  }

  @override
  $CliProfilesTable createAlias(String alias) {
    return $CliProfilesTable(attachedDatabase, alias);
  }
}

class CliProfile extends DataClass implements Insertable<CliProfile> {
  final String id;
  final String toolKey;
  final String profileName;
  final String? commandName;
  final String displayName;
  final String profileHome;
  final String profileSource;
  final String profileType;
  final bool hasAuthFile;
  final bool isAvailable;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime lastDiscoveredAt;
  final DateTime? lastLaunchedAt;
  const CliProfile({
    required this.id,
    required this.toolKey,
    required this.profileName,
    this.commandName,
    required this.displayName,
    required this.profileHome,
    required this.profileSource,
    required this.profileType,
    required this.hasAuthFile,
    required this.isAvailable,
    required this.isFavorite,
    required this.createdAt,
    required this.lastDiscoveredAt,
    this.lastLaunchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tool_key'] = Variable<String>(toolKey);
    map['profile_name'] = Variable<String>(profileName);
    if (!nullToAbsent || commandName != null) {
      map['command_name'] = Variable<String>(commandName);
    }
    map['display_name'] = Variable<String>(displayName);
    map['profile_home'] = Variable<String>(profileHome);
    map['profile_source'] = Variable<String>(profileSource);
    map['profile_type'] = Variable<String>(profileType);
    map['has_auth_file'] = Variable<bool>(hasAuthFile);
    map['is_available'] = Variable<bool>(isAvailable);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_discovered_at'] = Variable<DateTime>(lastDiscoveredAt);
    if (!nullToAbsent || lastLaunchedAt != null) {
      map['last_launched_at'] = Variable<DateTime>(lastLaunchedAt);
    }
    return map;
  }

  CliProfilesCompanion toCompanion(bool nullToAbsent) {
    return CliProfilesCompanion(
      id: Value(id),
      toolKey: Value(toolKey),
      profileName: Value(profileName),
      commandName: commandName == null && nullToAbsent
          ? const Value.absent()
          : Value(commandName),
      displayName: Value(displayName),
      profileHome: Value(profileHome),
      profileSource: Value(profileSource),
      profileType: Value(profileType),
      hasAuthFile: Value(hasAuthFile),
      isAvailable: Value(isAvailable),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
      lastDiscoveredAt: Value(lastDiscoveredAt),
      lastLaunchedAt: lastLaunchedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLaunchedAt),
    );
  }

  factory CliProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CliProfile(
      id: serializer.fromJson<String>(json['id']),
      toolKey: serializer.fromJson<String>(json['toolKey']),
      profileName: serializer.fromJson<String>(json['profileName']),
      commandName: serializer.fromJson<String?>(json['commandName']),
      displayName: serializer.fromJson<String>(json['displayName']),
      profileHome: serializer.fromJson<String>(json['profileHome']),
      profileSource: serializer.fromJson<String>(json['profileSource']),
      profileType: serializer.fromJson<String>(json['profileType']),
      hasAuthFile: serializer.fromJson<bool>(json['hasAuthFile']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastDiscoveredAt: serializer.fromJson<DateTime>(json['lastDiscoveredAt']),
      lastLaunchedAt: serializer.fromJson<DateTime?>(json['lastLaunchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'toolKey': serializer.toJson<String>(toolKey),
      'profileName': serializer.toJson<String>(profileName),
      'commandName': serializer.toJson<String?>(commandName),
      'displayName': serializer.toJson<String>(displayName),
      'profileHome': serializer.toJson<String>(profileHome),
      'profileSource': serializer.toJson<String>(profileSource),
      'profileType': serializer.toJson<String>(profileType),
      'hasAuthFile': serializer.toJson<bool>(hasAuthFile),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastDiscoveredAt': serializer.toJson<DateTime>(lastDiscoveredAt),
      'lastLaunchedAt': serializer.toJson<DateTime?>(lastLaunchedAt),
    };
  }

  CliProfile copyWith({
    String? id,
    String? toolKey,
    String? profileName,
    Value<String?> commandName = const Value.absent(),
    String? displayName,
    String? profileHome,
    String? profileSource,
    String? profileType,
    bool? hasAuthFile,
    bool? isAvailable,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? lastDiscoveredAt,
    Value<DateTime?> lastLaunchedAt = const Value.absent(),
  }) => CliProfile(
    id: id ?? this.id,
    toolKey: toolKey ?? this.toolKey,
    profileName: profileName ?? this.profileName,
    commandName: commandName.present ? commandName.value : this.commandName,
    displayName: displayName ?? this.displayName,
    profileHome: profileHome ?? this.profileHome,
    profileSource: profileSource ?? this.profileSource,
    profileType: profileType ?? this.profileType,
    hasAuthFile: hasAuthFile ?? this.hasAuthFile,
    isAvailable: isAvailable ?? this.isAvailable,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt ?? this.createdAt,
    lastDiscoveredAt: lastDiscoveredAt ?? this.lastDiscoveredAt,
    lastLaunchedAt: lastLaunchedAt.present
        ? lastLaunchedAt.value
        : this.lastLaunchedAt,
  );
  CliProfile copyWithCompanion(CliProfilesCompanion data) {
    return CliProfile(
      id: data.id.present ? data.id.value : this.id,
      toolKey: data.toolKey.present ? data.toolKey.value : this.toolKey,
      profileName: data.profileName.present
          ? data.profileName.value
          : this.profileName,
      commandName: data.commandName.present
          ? data.commandName.value
          : this.commandName,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      profileHome: data.profileHome.present
          ? data.profileHome.value
          : this.profileHome,
      profileSource: data.profileSource.present
          ? data.profileSource.value
          : this.profileSource,
      profileType: data.profileType.present
          ? data.profileType.value
          : this.profileType,
      hasAuthFile: data.hasAuthFile.present
          ? data.hasAuthFile.value
          : this.hasAuthFile,
      isAvailable: data.isAvailable.present
          ? data.isAvailable.value
          : this.isAvailable,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastDiscoveredAt: data.lastDiscoveredAt.present
          ? data.lastDiscoveredAt.value
          : this.lastDiscoveredAt,
      lastLaunchedAt: data.lastLaunchedAt.present
          ? data.lastLaunchedAt.value
          : this.lastLaunchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CliProfile(')
          ..write('id: $id, ')
          ..write('toolKey: $toolKey, ')
          ..write('profileName: $profileName, ')
          ..write('commandName: $commandName, ')
          ..write('displayName: $displayName, ')
          ..write('profileHome: $profileHome, ')
          ..write('profileSource: $profileSource, ')
          ..write('profileType: $profileType, ')
          ..write('hasAuthFile: $hasAuthFile, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastDiscoveredAt: $lastDiscoveredAt, ')
          ..write('lastLaunchedAt: $lastLaunchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    toolKey,
    profileName,
    commandName,
    displayName,
    profileHome,
    profileSource,
    profileType,
    hasAuthFile,
    isAvailable,
    isFavorite,
    createdAt,
    lastDiscoveredAt,
    lastLaunchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CliProfile &&
          other.id == this.id &&
          other.toolKey == this.toolKey &&
          other.profileName == this.profileName &&
          other.commandName == this.commandName &&
          other.displayName == this.displayName &&
          other.profileHome == this.profileHome &&
          other.profileSource == this.profileSource &&
          other.profileType == this.profileType &&
          other.hasAuthFile == this.hasAuthFile &&
          other.isAvailable == this.isAvailable &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt &&
          other.lastDiscoveredAt == this.lastDiscoveredAt &&
          other.lastLaunchedAt == this.lastLaunchedAt);
}

class CliProfilesCompanion extends UpdateCompanion<CliProfile> {
  final Value<String> id;
  final Value<String> toolKey;
  final Value<String> profileName;
  final Value<String?> commandName;
  final Value<String> displayName;
  final Value<String> profileHome;
  final Value<String> profileSource;
  final Value<String> profileType;
  final Value<bool> hasAuthFile;
  final Value<bool> isAvailable;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastDiscoveredAt;
  final Value<DateTime?> lastLaunchedAt;
  final Value<int> rowid;
  const CliProfilesCompanion({
    this.id = const Value.absent(),
    this.toolKey = const Value.absent(),
    this.profileName = const Value.absent(),
    this.commandName = const Value.absent(),
    this.displayName = const Value.absent(),
    this.profileHome = const Value.absent(),
    this.profileSource = const Value.absent(),
    this.profileType = const Value.absent(),
    this.hasAuthFile = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastDiscoveredAt = const Value.absent(),
    this.lastLaunchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CliProfilesCompanion.insert({
    required String id,
    this.toolKey = const Value.absent(),
    required String profileName,
    this.commandName = const Value.absent(),
    required String displayName,
    required String profileHome,
    required String profileSource,
    required String profileType,
    this.hasAuthFile = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.isFavorite = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastDiscoveredAt,
    this.lastLaunchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileName = Value(profileName),
       displayName = Value(displayName),
       profileHome = Value(profileHome),
       profileSource = Value(profileSource),
       profileType = Value(profileType),
       createdAt = Value(createdAt),
       lastDiscoveredAt = Value(lastDiscoveredAt);
  static Insertable<CliProfile> custom({
    Expression<String>? id,
    Expression<String>? toolKey,
    Expression<String>? profileName,
    Expression<String>? commandName,
    Expression<String>? displayName,
    Expression<String>? profileHome,
    Expression<String>? profileSource,
    Expression<String>? profileType,
    Expression<bool>? hasAuthFile,
    Expression<bool>? isAvailable,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastDiscoveredAt,
    Expression<DateTime>? lastLaunchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (toolKey != null) 'tool_key': toolKey,
      if (profileName != null) 'profile_name': profileName,
      if (commandName != null) 'command_name': commandName,
      if (displayName != null) 'display_name': displayName,
      if (profileHome != null) 'profile_home': profileHome,
      if (profileSource != null) 'profile_source': profileSource,
      if (profileType != null) 'profile_type': profileType,
      if (hasAuthFile != null) 'has_auth_file': hasAuthFile,
      if (isAvailable != null) 'is_available': isAvailable,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
      if (lastDiscoveredAt != null) 'last_discovered_at': lastDiscoveredAt,
      if (lastLaunchedAt != null) 'last_launched_at': lastLaunchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CliProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? toolKey,
    Value<String>? profileName,
    Value<String?>? commandName,
    Value<String>? displayName,
    Value<String>? profileHome,
    Value<String>? profileSource,
    Value<String>? profileType,
    Value<bool>? hasAuthFile,
    Value<bool>? isAvailable,
    Value<bool>? isFavorite,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastDiscoveredAt,
    Value<DateTime?>? lastLaunchedAt,
    Value<int>? rowid,
  }) {
    return CliProfilesCompanion(
      id: id ?? this.id,
      toolKey: toolKey ?? this.toolKey,
      profileName: profileName ?? this.profileName,
      commandName: commandName ?? this.commandName,
      displayName: displayName ?? this.displayName,
      profileHome: profileHome ?? this.profileHome,
      profileSource: profileSource ?? this.profileSource,
      profileType: profileType ?? this.profileType,
      hasAuthFile: hasAuthFile ?? this.hasAuthFile,
      isAvailable: isAvailable ?? this.isAvailable,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      lastDiscoveredAt: lastDiscoveredAt ?? this.lastDiscoveredAt,
      lastLaunchedAt: lastLaunchedAt ?? this.lastLaunchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (toolKey.present) {
      map['tool_key'] = Variable<String>(toolKey.value);
    }
    if (profileName.present) {
      map['profile_name'] = Variable<String>(profileName.value);
    }
    if (commandName.present) {
      map['command_name'] = Variable<String>(commandName.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (profileHome.present) {
      map['profile_home'] = Variable<String>(profileHome.value);
    }
    if (profileSource.present) {
      map['profile_source'] = Variable<String>(profileSource.value);
    }
    if (profileType.present) {
      map['profile_type'] = Variable<String>(profileType.value);
    }
    if (hasAuthFile.present) {
      map['has_auth_file'] = Variable<bool>(hasAuthFile.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastDiscoveredAt.present) {
      map['last_discovered_at'] = Variable<DateTime>(lastDiscoveredAt.value);
    }
    if (lastLaunchedAt.present) {
      map['last_launched_at'] = Variable<DateTime>(lastLaunchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CliProfilesCompanion(')
          ..write('id: $id, ')
          ..write('toolKey: $toolKey, ')
          ..write('profileName: $profileName, ')
          ..write('commandName: $commandName, ')
          ..write('displayName: $displayName, ')
          ..write('profileHome: $profileHome, ')
          ..write('profileSource: $profileSource, ')
          ..write('profileType: $profileType, ')
          ..write('hasAuthFile: $hasAuthFile, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastDiscoveredAt: $lastDiscoveredAt, ')
          ..write('lastLaunchedAt: $lastLaunchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfileMetadatasTable extends ProfileMetadatas
    with TableInfo<$ProfileMetadatasTable, ProfileMetadata> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileMetadatasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cli_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _accountEmailMeta = const VerificationMeta(
    'accountEmail',
  );
  @override
  late final GeneratedColumn<String> accountEmail = GeneratedColumn<String>(
    'account_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _accountDisplayNameMeta =
      const VerificationMeta('accountDisplayName');
  @override
  late final GeneratedColumn<String> accountDisplayName =
      GeneratedColumn<String>(
        'account_display_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _planNameMeta = const VerificationMeta(
    'planName',
  );
  @override
  late final GeneratedColumn<String> planName = GeneratedColumn<String>(
    'plan_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _purchasedOnMeta = const VerificationMeta(
    'purchasedOn',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedOn = GeneratedColumn<DateTime>(
    'purchased_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextRenewalOnMeta = const VerificationMeta(
    'nextRenewalOn',
  );
  @override
  late final GeneratedColumn<DateTime> nextRenewalOn =
      GeneratedColumn<DateTime>(
        'next_renewal_on',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _billingIntervalMeta = const VerificationMeta(
    'billingInterval',
  );
  @override
  late final GeneratedColumn<String> billingInterval = GeneratedColumn<String>(
    'billing_interval',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('monthly'),
  );
  static const VerificationMeta _expectedAmountMinorMeta =
      const VerificationMeta('expectedAmountMinor');
  @override
  late final GeneratedColumn<int> expectedAmountMinor = GeneratedColumn<int>(
    'expected_amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _autoRenewMeta = const VerificationMeta(
    'autoRenew',
  );
  @override
  late final GeneratedColumn<bool> autoRenew = GeneratedColumn<bool>(
    'auto_renew',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_renew" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _subscriptionStatusMeta =
      const VerificationMeta('subscriptionStatus');
  @override
  late final GeneratedColumn<String> subscriptionStatus =
      GeneratedColumn<String>(
        'subscription_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('active'),
      );
  static const VerificationMeta _purchasedFromMeta = const VerificationMeta(
    'purchasedFrom',
  );
  @override
  late final GeneratedColumn<String> purchasedFrom = GeneratedColumn<String>(
    'purchased_from',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _paymentMethodLabelMeta =
      const VerificationMeta('paymentMethodLabel');
  @override
  late final GeneratedColumn<String> paymentMethodLabel =
      GeneratedColumn<String>(
        'payment_method_label',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
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
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    accountEmail,
    accountDisplayName,
    planName,
    notes,
    tagsJson,
    purchasedOn,
    nextRenewalOn,
    billingInterval,
    expectedAmountMinor,
    currencyCode,
    autoRenew,
    subscriptionStatus,
    purchasedFrom,
    paymentMethodLabel,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_metadatas';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileMetadata> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('account_email')) {
      context.handle(
        _accountEmailMeta,
        accountEmail.isAcceptableOrUnknown(
          data['account_email']!,
          _accountEmailMeta,
        ),
      );
    }
    if (data.containsKey('account_display_name')) {
      context.handle(
        _accountDisplayNameMeta,
        accountDisplayName.isAcceptableOrUnknown(
          data['account_display_name']!,
          _accountDisplayNameMeta,
        ),
      );
    }
    if (data.containsKey('plan_name')) {
      context.handle(
        _planNameMeta,
        planName.isAcceptableOrUnknown(data['plan_name']!, _planNameMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    if (data.containsKey('purchased_on')) {
      context.handle(
        _purchasedOnMeta,
        purchasedOn.isAcceptableOrUnknown(
          data['purchased_on']!,
          _purchasedOnMeta,
        ),
      );
    }
    if (data.containsKey('next_renewal_on')) {
      context.handle(
        _nextRenewalOnMeta,
        nextRenewalOn.isAcceptableOrUnknown(
          data['next_renewal_on']!,
          _nextRenewalOnMeta,
        ),
      );
    }
    if (data.containsKey('billing_interval')) {
      context.handle(
        _billingIntervalMeta,
        billingInterval.isAcceptableOrUnknown(
          data['billing_interval']!,
          _billingIntervalMeta,
        ),
      );
    }
    if (data.containsKey('expected_amount_minor')) {
      context.handle(
        _expectedAmountMinorMeta,
        expectedAmountMinor.isAcceptableOrUnknown(
          data['expected_amount_minor']!,
          _expectedAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('auto_renew')) {
      context.handle(
        _autoRenewMeta,
        autoRenew.isAcceptableOrUnknown(data['auto_renew']!, _autoRenewMeta),
      );
    }
    if (data.containsKey('subscription_status')) {
      context.handle(
        _subscriptionStatusMeta,
        subscriptionStatus.isAcceptableOrUnknown(
          data['subscription_status']!,
          _subscriptionStatusMeta,
        ),
      );
    }
    if (data.containsKey('purchased_from')) {
      context.handle(
        _purchasedFromMeta,
        purchasedFrom.isAcceptableOrUnknown(
          data['purchased_from']!,
          _purchasedFromMeta,
        ),
      );
    }
    if (data.containsKey('payment_method_label')) {
      context.handle(
        _paymentMethodLabelMeta,
        paymentMethodLabel.isAcceptableOrUnknown(
          data['payment_method_label']!,
          _paymentMethodLabelMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId};
  @override
  ProfileMetadata map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileMetadata(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      accountEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_email'],
      )!,
      accountDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_display_name'],
      )!,
      planName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_name'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      purchasedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_on'],
      ),
      nextRenewalOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_renewal_on'],
      ),
      billingInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}billing_interval'],
      )!,
      expectedAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_amount_minor'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      autoRenew: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_renew'],
      )!,
      subscriptionStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_status'],
      )!,
      purchasedFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchased_from'],
      )!,
      paymentMethodLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method_label'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProfileMetadatasTable createAlias(String alias) {
    return $ProfileMetadatasTable(attachedDatabase, alias);
  }
}

class ProfileMetadata extends DataClass implements Insertable<ProfileMetadata> {
  final String profileId;
  final String accountEmail;
  final String accountDisplayName;
  final String planName;
  final String notes;
  final String tagsJson;
  final DateTime? purchasedOn;
  final DateTime? nextRenewalOn;
  final String billingInterval;
  final int expectedAmountMinor;
  final String currencyCode;
  final bool autoRenew;
  final String subscriptionStatus;
  final String purchasedFrom;
  final String paymentMethodLabel;
  final DateTime updatedAt;
  const ProfileMetadata({
    required this.profileId,
    required this.accountEmail,
    required this.accountDisplayName,
    required this.planName,
    required this.notes,
    required this.tagsJson,
    this.purchasedOn,
    this.nextRenewalOn,
    required this.billingInterval,
    required this.expectedAmountMinor,
    required this.currencyCode,
    required this.autoRenew,
    required this.subscriptionStatus,
    required this.purchasedFrom,
    required this.paymentMethodLabel,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['account_email'] = Variable<String>(accountEmail);
    map['account_display_name'] = Variable<String>(accountDisplayName);
    map['plan_name'] = Variable<String>(planName);
    map['notes'] = Variable<String>(notes);
    map['tags_json'] = Variable<String>(tagsJson);
    if (!nullToAbsent || purchasedOn != null) {
      map['purchased_on'] = Variable<DateTime>(purchasedOn);
    }
    if (!nullToAbsent || nextRenewalOn != null) {
      map['next_renewal_on'] = Variable<DateTime>(nextRenewalOn);
    }
    map['billing_interval'] = Variable<String>(billingInterval);
    map['expected_amount_minor'] = Variable<int>(expectedAmountMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    map['auto_renew'] = Variable<bool>(autoRenew);
    map['subscription_status'] = Variable<String>(subscriptionStatus);
    map['purchased_from'] = Variable<String>(purchasedFrom);
    map['payment_method_label'] = Variable<String>(paymentMethodLabel);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProfileMetadatasCompanion toCompanion(bool nullToAbsent) {
    return ProfileMetadatasCompanion(
      profileId: Value(profileId),
      accountEmail: Value(accountEmail),
      accountDisplayName: Value(accountDisplayName),
      planName: Value(planName),
      notes: Value(notes),
      tagsJson: Value(tagsJson),
      purchasedOn: purchasedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasedOn),
      nextRenewalOn: nextRenewalOn == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRenewalOn),
      billingInterval: Value(billingInterval),
      expectedAmountMinor: Value(expectedAmountMinor),
      currencyCode: Value(currencyCode),
      autoRenew: Value(autoRenew),
      subscriptionStatus: Value(subscriptionStatus),
      purchasedFrom: Value(purchasedFrom),
      paymentMethodLabel: Value(paymentMethodLabel),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProfileMetadata.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileMetadata(
      profileId: serializer.fromJson<String>(json['profileId']),
      accountEmail: serializer.fromJson<String>(json['accountEmail']),
      accountDisplayName: serializer.fromJson<String>(
        json['accountDisplayName'],
      ),
      planName: serializer.fromJson<String>(json['planName']),
      notes: serializer.fromJson<String>(json['notes']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      purchasedOn: serializer.fromJson<DateTime?>(json['purchasedOn']),
      nextRenewalOn: serializer.fromJson<DateTime?>(json['nextRenewalOn']),
      billingInterval: serializer.fromJson<String>(json['billingInterval']),
      expectedAmountMinor: serializer.fromJson<int>(
        json['expectedAmountMinor'],
      ),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      autoRenew: serializer.fromJson<bool>(json['autoRenew']),
      subscriptionStatus: serializer.fromJson<String>(
        json['subscriptionStatus'],
      ),
      purchasedFrom: serializer.fromJson<String>(json['purchasedFrom']),
      paymentMethodLabel: serializer.fromJson<String>(
        json['paymentMethodLabel'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'accountEmail': serializer.toJson<String>(accountEmail),
      'accountDisplayName': serializer.toJson<String>(accountDisplayName),
      'planName': serializer.toJson<String>(planName),
      'notes': serializer.toJson<String>(notes),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'purchasedOn': serializer.toJson<DateTime?>(purchasedOn),
      'nextRenewalOn': serializer.toJson<DateTime?>(nextRenewalOn),
      'billingInterval': serializer.toJson<String>(billingInterval),
      'expectedAmountMinor': serializer.toJson<int>(expectedAmountMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'autoRenew': serializer.toJson<bool>(autoRenew),
      'subscriptionStatus': serializer.toJson<String>(subscriptionStatus),
      'purchasedFrom': serializer.toJson<String>(purchasedFrom),
      'paymentMethodLabel': serializer.toJson<String>(paymentMethodLabel),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProfileMetadata copyWith({
    String? profileId,
    String? accountEmail,
    String? accountDisplayName,
    String? planName,
    String? notes,
    String? tagsJson,
    Value<DateTime?> purchasedOn = const Value.absent(),
    Value<DateTime?> nextRenewalOn = const Value.absent(),
    String? billingInterval,
    int? expectedAmountMinor,
    String? currencyCode,
    bool? autoRenew,
    String? subscriptionStatus,
    String? purchasedFrom,
    String? paymentMethodLabel,
    DateTime? updatedAt,
  }) => ProfileMetadata(
    profileId: profileId ?? this.profileId,
    accountEmail: accountEmail ?? this.accountEmail,
    accountDisplayName: accountDisplayName ?? this.accountDisplayName,
    planName: planName ?? this.planName,
    notes: notes ?? this.notes,
    tagsJson: tagsJson ?? this.tagsJson,
    purchasedOn: purchasedOn.present ? purchasedOn.value : this.purchasedOn,
    nextRenewalOn: nextRenewalOn.present
        ? nextRenewalOn.value
        : this.nextRenewalOn,
    billingInterval: billingInterval ?? this.billingInterval,
    expectedAmountMinor: expectedAmountMinor ?? this.expectedAmountMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    autoRenew: autoRenew ?? this.autoRenew,
    subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
    purchasedFrom: purchasedFrom ?? this.purchasedFrom,
    paymentMethodLabel: paymentMethodLabel ?? this.paymentMethodLabel,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProfileMetadata copyWithCompanion(ProfileMetadatasCompanion data) {
    return ProfileMetadata(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      accountEmail: data.accountEmail.present
          ? data.accountEmail.value
          : this.accountEmail,
      accountDisplayName: data.accountDisplayName.present
          ? data.accountDisplayName.value
          : this.accountDisplayName,
      planName: data.planName.present ? data.planName.value : this.planName,
      notes: data.notes.present ? data.notes.value : this.notes,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      purchasedOn: data.purchasedOn.present
          ? data.purchasedOn.value
          : this.purchasedOn,
      nextRenewalOn: data.nextRenewalOn.present
          ? data.nextRenewalOn.value
          : this.nextRenewalOn,
      billingInterval: data.billingInterval.present
          ? data.billingInterval.value
          : this.billingInterval,
      expectedAmountMinor: data.expectedAmountMinor.present
          ? data.expectedAmountMinor.value
          : this.expectedAmountMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      autoRenew: data.autoRenew.present ? data.autoRenew.value : this.autoRenew,
      subscriptionStatus: data.subscriptionStatus.present
          ? data.subscriptionStatus.value
          : this.subscriptionStatus,
      purchasedFrom: data.purchasedFrom.present
          ? data.purchasedFrom.value
          : this.purchasedFrom,
      paymentMethodLabel: data.paymentMethodLabel.present
          ? data.paymentMethodLabel.value
          : this.paymentMethodLabel,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileMetadata(')
          ..write('profileId: $profileId, ')
          ..write('accountEmail: $accountEmail, ')
          ..write('accountDisplayName: $accountDisplayName, ')
          ..write('planName: $planName, ')
          ..write('notes: $notes, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('purchasedOn: $purchasedOn, ')
          ..write('nextRenewalOn: $nextRenewalOn, ')
          ..write('billingInterval: $billingInterval, ')
          ..write('expectedAmountMinor: $expectedAmountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('autoRenew: $autoRenew, ')
          ..write('subscriptionStatus: $subscriptionStatus, ')
          ..write('purchasedFrom: $purchasedFrom, ')
          ..write('paymentMethodLabel: $paymentMethodLabel, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    accountEmail,
    accountDisplayName,
    planName,
    notes,
    tagsJson,
    purchasedOn,
    nextRenewalOn,
    billingInterval,
    expectedAmountMinor,
    currencyCode,
    autoRenew,
    subscriptionStatus,
    purchasedFrom,
    paymentMethodLabel,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileMetadata &&
          other.profileId == this.profileId &&
          other.accountEmail == this.accountEmail &&
          other.accountDisplayName == this.accountDisplayName &&
          other.planName == this.planName &&
          other.notes == this.notes &&
          other.tagsJson == this.tagsJson &&
          other.purchasedOn == this.purchasedOn &&
          other.nextRenewalOn == this.nextRenewalOn &&
          other.billingInterval == this.billingInterval &&
          other.expectedAmountMinor == this.expectedAmountMinor &&
          other.currencyCode == this.currencyCode &&
          other.autoRenew == this.autoRenew &&
          other.subscriptionStatus == this.subscriptionStatus &&
          other.purchasedFrom == this.purchasedFrom &&
          other.paymentMethodLabel == this.paymentMethodLabel &&
          other.updatedAt == this.updatedAt);
}

class ProfileMetadatasCompanion extends UpdateCompanion<ProfileMetadata> {
  final Value<String> profileId;
  final Value<String> accountEmail;
  final Value<String> accountDisplayName;
  final Value<String> planName;
  final Value<String> notes;
  final Value<String> tagsJson;
  final Value<DateTime?> purchasedOn;
  final Value<DateTime?> nextRenewalOn;
  final Value<String> billingInterval;
  final Value<int> expectedAmountMinor;
  final Value<String> currencyCode;
  final Value<bool> autoRenew;
  final Value<String> subscriptionStatus;
  final Value<String> purchasedFrom;
  final Value<String> paymentMethodLabel;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProfileMetadatasCompanion({
    this.profileId = const Value.absent(),
    this.accountEmail = const Value.absent(),
    this.accountDisplayName = const Value.absent(),
    this.planName = const Value.absent(),
    this.notes = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.purchasedOn = const Value.absent(),
    this.nextRenewalOn = const Value.absent(),
    this.billingInterval = const Value.absent(),
    this.expectedAmountMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.autoRenew = const Value.absent(),
    this.subscriptionStatus = const Value.absent(),
    this.purchasedFrom = const Value.absent(),
    this.paymentMethodLabel = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfileMetadatasCompanion.insert({
    required String profileId,
    this.accountEmail = const Value.absent(),
    this.accountDisplayName = const Value.absent(),
    this.planName = const Value.absent(),
    this.notes = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.purchasedOn = const Value.absent(),
    this.nextRenewalOn = const Value.absent(),
    this.billingInterval = const Value.absent(),
    this.expectedAmountMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.autoRenew = const Value.absent(),
    this.subscriptionStatus = const Value.absent(),
    this.purchasedFrom = const Value.absent(),
    this.paymentMethodLabel = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       updatedAt = Value(updatedAt);
  static Insertable<ProfileMetadata> custom({
    Expression<String>? profileId,
    Expression<String>? accountEmail,
    Expression<String>? accountDisplayName,
    Expression<String>? planName,
    Expression<String>? notes,
    Expression<String>? tagsJson,
    Expression<DateTime>? purchasedOn,
    Expression<DateTime>? nextRenewalOn,
    Expression<String>? billingInterval,
    Expression<int>? expectedAmountMinor,
    Expression<String>? currencyCode,
    Expression<bool>? autoRenew,
    Expression<String>? subscriptionStatus,
    Expression<String>? purchasedFrom,
    Expression<String>? paymentMethodLabel,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (accountEmail != null) 'account_email': accountEmail,
      if (accountDisplayName != null)
        'account_display_name': accountDisplayName,
      if (planName != null) 'plan_name': planName,
      if (notes != null) 'notes': notes,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (purchasedOn != null) 'purchased_on': purchasedOn,
      if (nextRenewalOn != null) 'next_renewal_on': nextRenewalOn,
      if (billingInterval != null) 'billing_interval': billingInterval,
      if (expectedAmountMinor != null)
        'expected_amount_minor': expectedAmountMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (autoRenew != null) 'auto_renew': autoRenew,
      if (subscriptionStatus != null) 'subscription_status': subscriptionStatus,
      if (purchasedFrom != null) 'purchased_from': purchasedFrom,
      if (paymentMethodLabel != null)
        'payment_method_label': paymentMethodLabel,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfileMetadatasCompanion copyWith({
    Value<String>? profileId,
    Value<String>? accountEmail,
    Value<String>? accountDisplayName,
    Value<String>? planName,
    Value<String>? notes,
    Value<String>? tagsJson,
    Value<DateTime?>? purchasedOn,
    Value<DateTime?>? nextRenewalOn,
    Value<String>? billingInterval,
    Value<int>? expectedAmountMinor,
    Value<String>? currencyCode,
    Value<bool>? autoRenew,
    Value<String>? subscriptionStatus,
    Value<String>? purchasedFrom,
    Value<String>? paymentMethodLabel,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProfileMetadatasCompanion(
      profileId: profileId ?? this.profileId,
      accountEmail: accountEmail ?? this.accountEmail,
      accountDisplayName: accountDisplayName ?? this.accountDisplayName,
      planName: planName ?? this.planName,
      notes: notes ?? this.notes,
      tagsJson: tagsJson ?? this.tagsJson,
      purchasedOn: purchasedOn ?? this.purchasedOn,
      nextRenewalOn: nextRenewalOn ?? this.nextRenewalOn,
      billingInterval: billingInterval ?? this.billingInterval,
      expectedAmountMinor: expectedAmountMinor ?? this.expectedAmountMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      autoRenew: autoRenew ?? this.autoRenew,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      purchasedFrom: purchasedFrom ?? this.purchasedFrom,
      paymentMethodLabel: paymentMethodLabel ?? this.paymentMethodLabel,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (accountEmail.present) {
      map['account_email'] = Variable<String>(accountEmail.value);
    }
    if (accountDisplayName.present) {
      map['account_display_name'] = Variable<String>(accountDisplayName.value);
    }
    if (planName.present) {
      map['plan_name'] = Variable<String>(planName.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (purchasedOn.present) {
      map['purchased_on'] = Variable<DateTime>(purchasedOn.value);
    }
    if (nextRenewalOn.present) {
      map['next_renewal_on'] = Variable<DateTime>(nextRenewalOn.value);
    }
    if (billingInterval.present) {
      map['billing_interval'] = Variable<String>(billingInterval.value);
    }
    if (expectedAmountMinor.present) {
      map['expected_amount_minor'] = Variable<int>(expectedAmountMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (autoRenew.present) {
      map['auto_renew'] = Variable<bool>(autoRenew.value);
    }
    if (subscriptionStatus.present) {
      map['subscription_status'] = Variable<String>(subscriptionStatus.value);
    }
    if (purchasedFrom.present) {
      map['purchased_from'] = Variable<String>(purchasedFrom.value);
    }
    if (paymentMethodLabel.present) {
      map['payment_method_label'] = Variable<String>(paymentMethodLabel.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileMetadatasCompanion(')
          ..write('profileId: $profileId, ')
          ..write('accountEmail: $accountEmail, ')
          ..write('accountDisplayName: $accountDisplayName, ')
          ..write('planName: $planName, ')
          ..write('notes: $notes, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('purchasedOn: $purchasedOn, ')
          ..write('nextRenewalOn: $nextRenewalOn, ')
          ..write('billingInterval: $billingInterval, ')
          ..write('expectedAmountMinor: $expectedAmountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('autoRenew: $autoRenew, ')
          ..write('subscriptionStatus: $subscriptionStatus, ')
          ..write('purchasedFrom: $purchasedFrom, ')
          ..write('paymentMethodLabel: $paymentMethodLabel, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CostSharesTable extends CostShares
    with TableInfo<$CostSharesTable, CostShare> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CostSharesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cli_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _personNameMeta = const VerificationMeta(
    'personName',
  );
  @override
  late final GeneratedColumn<String> personName = GeneratedColumn<String>(
    'person_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedAmountMinorMeta =
      const VerificationMeta('expectedAmountMinor');
  @override
  late final GeneratedColumn<int> expectedAmountMinor = GeneratedColumn<int>(
    'expected_amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paidAmountMinorMeta = const VerificationMeta(
    'paidAmountMinor',
  );
  @override
  late final GeneratedColumn<int> paidAmountMinor = GeneratedColumn<int>(
    'paid_amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _paymentStatusMeta = const VerificationMeta(
    'paymentStatus',
  );
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
    'payment_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _paidOnMeta = const VerificationMeta('paidOn');
  @override
  late final GeneratedColumn<DateTime> paidOn = GeneratedColumn<DateTime>(
    'paid_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    personName,
    expectedAmountMinor,
    paidAmountMinor,
    currencyCode,
    paymentStatus,
    paidOn,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cost_shares';
  @override
  VerificationContext validateIntegrity(
    Insertable<CostShare> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('person_name')) {
      context.handle(
        _personNameMeta,
        personName.isAcceptableOrUnknown(data['person_name']!, _personNameMeta),
      );
    } else if (isInserting) {
      context.missing(_personNameMeta);
    }
    if (data.containsKey('expected_amount_minor')) {
      context.handle(
        _expectedAmountMinorMeta,
        expectedAmountMinor.isAcceptableOrUnknown(
          data['expected_amount_minor']!,
          _expectedAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('paid_amount_minor')) {
      context.handle(
        _paidAmountMinorMeta,
        paidAmountMinor.isAcceptableOrUnknown(
          data['paid_amount_minor']!,
          _paidAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('payment_status')) {
      context.handle(
        _paymentStatusMeta,
        paymentStatus.isAcceptableOrUnknown(
          data['payment_status']!,
          _paymentStatusMeta,
        ),
      );
    }
    if (data.containsKey('paid_on')) {
      context.handle(
        _paidOnMeta,
        paidOn.isAcceptableOrUnknown(data['paid_on']!, _paidOnMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CostShare map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CostShare(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      personName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_name'],
      )!,
      expectedAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_amount_minor'],
      )!,
      paidAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_amount_minor'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      paymentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_status'],
      )!,
      paidOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_on'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $CostSharesTable createAlias(String alias) {
    return $CostSharesTable(attachedDatabase, alias);
  }
}

class CostShare extends DataClass implements Insertable<CostShare> {
  final String id;
  final String profileId;
  final String personName;
  final int expectedAmountMinor;
  final int paidAmountMinor;
  final String currencyCode;
  final String paymentStatus;
  final DateTime? paidOn;
  final String notes;
  const CostShare({
    required this.id,
    required this.profileId,
    required this.personName,
    required this.expectedAmountMinor,
    required this.paidAmountMinor,
    required this.currencyCode,
    required this.paymentStatus,
    this.paidOn,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['person_name'] = Variable<String>(personName);
    map['expected_amount_minor'] = Variable<int>(expectedAmountMinor);
    map['paid_amount_minor'] = Variable<int>(paidAmountMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    map['payment_status'] = Variable<String>(paymentStatus);
    if (!nullToAbsent || paidOn != null) {
      map['paid_on'] = Variable<DateTime>(paidOn);
    }
    map['notes'] = Variable<String>(notes);
    return map;
  }

  CostSharesCompanion toCompanion(bool nullToAbsent) {
    return CostSharesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      personName: Value(personName),
      expectedAmountMinor: Value(expectedAmountMinor),
      paidAmountMinor: Value(paidAmountMinor),
      currencyCode: Value(currencyCode),
      paymentStatus: Value(paymentStatus),
      paidOn: paidOn == null && nullToAbsent
          ? const Value.absent()
          : Value(paidOn),
      notes: Value(notes),
    );
  }

  factory CostShare.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CostShare(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      personName: serializer.fromJson<String>(json['personName']),
      expectedAmountMinor: serializer.fromJson<int>(
        json['expectedAmountMinor'],
      ),
      paidAmountMinor: serializer.fromJson<int>(json['paidAmountMinor']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      paidOn: serializer.fromJson<DateTime?>(json['paidOn']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'personName': serializer.toJson<String>(personName),
      'expectedAmountMinor': serializer.toJson<int>(expectedAmountMinor),
      'paidAmountMinor': serializer.toJson<int>(paidAmountMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'paidOn': serializer.toJson<DateTime?>(paidOn),
      'notes': serializer.toJson<String>(notes),
    };
  }

  CostShare copyWith({
    String? id,
    String? profileId,
    String? personName,
    int? expectedAmountMinor,
    int? paidAmountMinor,
    String? currencyCode,
    String? paymentStatus,
    Value<DateTime?> paidOn = const Value.absent(),
    String? notes,
  }) => CostShare(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    personName: personName ?? this.personName,
    expectedAmountMinor: expectedAmountMinor ?? this.expectedAmountMinor,
    paidAmountMinor: paidAmountMinor ?? this.paidAmountMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    paidOn: paidOn.present ? paidOn.value : this.paidOn,
    notes: notes ?? this.notes,
  );
  CostShare copyWithCompanion(CostSharesCompanion data) {
    return CostShare(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      personName: data.personName.present
          ? data.personName.value
          : this.personName,
      expectedAmountMinor: data.expectedAmountMinor.present
          ? data.expectedAmountMinor.value
          : this.expectedAmountMinor,
      paidAmountMinor: data.paidAmountMinor.present
          ? data.paidAmountMinor.value
          : this.paidAmountMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      paidOn: data.paidOn.present ? data.paidOn.value : this.paidOn,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CostShare(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('personName: $personName, ')
          ..write('expectedAmountMinor: $expectedAmountMinor, ')
          ..write('paidAmountMinor: $paidAmountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('paidOn: $paidOn, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    personName,
    expectedAmountMinor,
    paidAmountMinor,
    currencyCode,
    paymentStatus,
    paidOn,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CostShare &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.personName == this.personName &&
          other.expectedAmountMinor == this.expectedAmountMinor &&
          other.paidAmountMinor == this.paidAmountMinor &&
          other.currencyCode == this.currencyCode &&
          other.paymentStatus == this.paymentStatus &&
          other.paidOn == this.paidOn &&
          other.notes == this.notes);
}

class CostSharesCompanion extends UpdateCompanion<CostShare> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> personName;
  final Value<int> expectedAmountMinor;
  final Value<int> paidAmountMinor;
  final Value<String> currencyCode;
  final Value<String> paymentStatus;
  final Value<DateTime?> paidOn;
  final Value<String> notes;
  final Value<int> rowid;
  const CostSharesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.personName = const Value.absent(),
    this.expectedAmountMinor = const Value.absent(),
    this.paidAmountMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.paidOn = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CostSharesCompanion.insert({
    required String id,
    required String profileId,
    required String personName,
    this.expectedAmountMinor = const Value.absent(),
    this.paidAmountMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.paidOn = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       personName = Value(personName);
  static Insertable<CostShare> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? personName,
    Expression<int>? expectedAmountMinor,
    Expression<int>? paidAmountMinor,
    Expression<String>? currencyCode,
    Expression<String>? paymentStatus,
    Expression<DateTime>? paidOn,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (personName != null) 'person_name': personName,
      if (expectedAmountMinor != null)
        'expected_amount_minor': expectedAmountMinor,
      if (paidAmountMinor != null) 'paid_amount_minor': paidAmountMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (paidOn != null) 'paid_on': paidOn,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CostSharesCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String>? personName,
    Value<int>? expectedAmountMinor,
    Value<int>? paidAmountMinor,
    Value<String>? currencyCode,
    Value<String>? paymentStatus,
    Value<DateTime?>? paidOn,
    Value<String>? notes,
    Value<int>? rowid,
  }) {
    return CostSharesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      personName: personName ?? this.personName,
      expectedAmountMinor: expectedAmountMinor ?? this.expectedAmountMinor,
      paidAmountMinor: paidAmountMinor ?? this.paidAmountMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paidOn: paidOn ?? this.paidOn,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (personName.present) {
      map['person_name'] = Variable<String>(personName.value);
    }
    if (expectedAmountMinor.present) {
      map['expected_amount_minor'] = Variable<int>(expectedAmountMinor.value);
    }
    if (paidAmountMinor.present) {
      map['paid_amount_minor'] = Variable<int>(paidAmountMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (paidOn.present) {
      map['paid_on'] = Variable<DateTime>(paidOn.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CostSharesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('personName: $personName, ')
          ..write('expectedAmountMinor: $expectedAmountMinor, ')
          ..write('paidAmountMinor: $paidAmountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('paidOn: $paidOn, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsageChecksTable extends UsageChecks
    with TableInfo<$UsageChecksTable, UsageCheck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageChecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cli_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _queryMethodMeta = const VerificationMeta(
    'queryMethod',
  );
  @override
  late final GeneratedColumn<String> queryMethod = GeneratedColumn<String>(
    'query_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('codex-app-server'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planTypeMeta = const VerificationMeta(
    'planType',
  );
  @override
  late final GeneratedColumn<String> planType = GeneratedColumn<String>(
    'plan_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountEmailMeta = const VerificationMeta(
    'accountEmail',
  );
  @override
  late final GeneratedColumn<String> accountEmail = GeneratedColumn<String>(
    'account_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountDisplayNameMeta =
      const VerificationMeta('accountDisplayName');
  @override
  late final GeneratedColumn<String> accountDisplayName =
      GeneratedColumn<String>(
        'account_display_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _errorCodeMeta = const VerificationMeta(
    'errorCode',
  );
  @override
  late final GeneratedColumn<String> errorCode = GeneratedColumn<String>(
    'error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    queryMethod,
    status,
    startedAt,
    completedAt,
    durationMs,
    planType,
    accountEmail,
    accountDisplayName,
    errorCode,
    errorMessage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_checks';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageCheck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('query_method')) {
      context.handle(
        _queryMethodMeta,
        queryMethod.isAcceptableOrUnknown(
          data['query_method']!,
          _queryMethodMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('plan_type')) {
      context.handle(
        _planTypeMeta,
        planType.isAcceptableOrUnknown(data['plan_type']!, _planTypeMeta),
      );
    }
    if (data.containsKey('account_email')) {
      context.handle(
        _accountEmailMeta,
        accountEmail.isAcceptableOrUnknown(
          data['account_email']!,
          _accountEmailMeta,
        ),
      );
    }
    if (data.containsKey('account_display_name')) {
      context.handle(
        _accountDisplayNameMeta,
        accountDisplayName.isAcceptableOrUnknown(
          data['account_display_name']!,
          _accountDisplayNameMeta,
        ),
      );
    }
    if (data.containsKey('error_code')) {
      context.handle(
        _errorCodeMeta,
        errorCode.isAcceptableOrUnknown(data['error_code']!, _errorCodeMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsageCheck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageCheck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      queryMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}query_method'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      planType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_type'],
      ),
      accountEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_email'],
      ),
      accountDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_display_name'],
      ),
      errorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_code'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
    );
  }

  @override
  $UsageChecksTable createAlias(String alias) {
    return $UsageChecksTable(attachedDatabase, alias);
  }
}

class UsageCheck extends DataClass implements Insertable<UsageCheck> {
  final String id;
  final String profileId;
  final String queryMethod;
  final String status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? durationMs;
  final String? planType;
  final String? accountEmail;
  final String? accountDisplayName;
  final String? errorCode;
  final String? errorMessage;
  const UsageCheck({
    required this.id,
    required this.profileId,
    required this.queryMethod,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.durationMs,
    this.planType,
    this.accountEmail,
    this.accountDisplayName,
    this.errorCode,
    this.errorMessage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['query_method'] = Variable<String>(queryMethod);
    map['status'] = Variable<String>(status);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || planType != null) {
      map['plan_type'] = Variable<String>(planType);
    }
    if (!nullToAbsent || accountEmail != null) {
      map['account_email'] = Variable<String>(accountEmail);
    }
    if (!nullToAbsent || accountDisplayName != null) {
      map['account_display_name'] = Variable<String>(accountDisplayName);
    }
    if (!nullToAbsent || errorCode != null) {
      map['error_code'] = Variable<String>(errorCode);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  UsageChecksCompanion toCompanion(bool nullToAbsent) {
    return UsageChecksCompanion(
      id: Value(id),
      profileId: Value(profileId),
      queryMethod: Value(queryMethod),
      status: Value(status),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      planType: planType == null && nullToAbsent
          ? const Value.absent()
          : Value(planType),
      accountEmail: accountEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(accountEmail),
      accountDisplayName: accountDisplayName == null && nullToAbsent
          ? const Value.absent()
          : Value(accountDisplayName),
      errorCode: errorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(errorCode),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory UsageCheck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageCheck(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      queryMethod: serializer.fromJson<String>(json['queryMethod']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      planType: serializer.fromJson<String?>(json['planType']),
      accountEmail: serializer.fromJson<String?>(json['accountEmail']),
      accountDisplayName: serializer.fromJson<String?>(
        json['accountDisplayName'],
      ),
      errorCode: serializer.fromJson<String?>(json['errorCode']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'queryMethod': serializer.toJson<String>(queryMethod),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'durationMs': serializer.toJson<int?>(durationMs),
      'planType': serializer.toJson<String?>(planType),
      'accountEmail': serializer.toJson<String?>(accountEmail),
      'accountDisplayName': serializer.toJson<String?>(accountDisplayName),
      'errorCode': serializer.toJson<String?>(errorCode),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  UsageCheck copyWith({
    String? id,
    String? profileId,
    String? queryMethod,
    String? status,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<String?> planType = const Value.absent(),
    Value<String?> accountEmail = const Value.absent(),
    Value<String?> accountDisplayName = const Value.absent(),
    Value<String?> errorCode = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
  }) => UsageCheck(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    queryMethod: queryMethod ?? this.queryMethod,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    planType: planType.present ? planType.value : this.planType,
    accountEmail: accountEmail.present ? accountEmail.value : this.accountEmail,
    accountDisplayName: accountDisplayName.present
        ? accountDisplayName.value
        : this.accountDisplayName,
    errorCode: errorCode.present ? errorCode.value : this.errorCode,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
  );
  UsageCheck copyWithCompanion(UsageChecksCompanion data) {
    return UsageCheck(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      queryMethod: data.queryMethod.present
          ? data.queryMethod.value
          : this.queryMethod,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      planType: data.planType.present ? data.planType.value : this.planType,
      accountEmail: data.accountEmail.present
          ? data.accountEmail.value
          : this.accountEmail,
      accountDisplayName: data.accountDisplayName.present
          ? data.accountDisplayName.value
          : this.accountDisplayName,
      errorCode: data.errorCode.present ? data.errorCode.value : this.errorCode,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageCheck(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('queryMethod: $queryMethod, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('planType: $planType, ')
          ..write('accountEmail: $accountEmail, ')
          ..write('accountDisplayName: $accountDisplayName, ')
          ..write('errorCode: $errorCode, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    queryMethod,
    status,
    startedAt,
    completedAt,
    durationMs,
    planType,
    accountEmail,
    accountDisplayName,
    errorCode,
    errorMessage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageCheck &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.queryMethod == this.queryMethod &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.durationMs == this.durationMs &&
          other.planType == this.planType &&
          other.accountEmail == this.accountEmail &&
          other.accountDisplayName == this.accountDisplayName &&
          other.errorCode == this.errorCode &&
          other.errorMessage == this.errorMessage);
}

class UsageChecksCompanion extends UpdateCompanion<UsageCheck> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> queryMethod;
  final Value<String> status;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int?> durationMs;
  final Value<String?> planType;
  final Value<String?> accountEmail;
  final Value<String?> accountDisplayName;
  final Value<String?> errorCode;
  final Value<String?> errorMessage;
  final Value<int> rowid;
  const UsageChecksCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.queryMethod = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.planType = const Value.absent(),
    this.accountEmail = const Value.absent(),
    this.accountDisplayName = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsageChecksCompanion.insert({
    required String id,
    required String profileId,
    this.queryMethod = const Value.absent(),
    required String status,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.planType = const Value.absent(),
    this.accountEmail = const Value.absent(),
    this.accountDisplayName = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       status = Value(status),
       startedAt = Value(startedAt);
  static Insertable<UsageCheck> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? queryMethod,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? durationMs,
    Expression<String>? planType,
    Expression<String>? accountEmail,
    Expression<String>? accountDisplayName,
    Expression<String>? errorCode,
    Expression<String>? errorMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (queryMethod != null) 'query_method': queryMethod,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (durationMs != null) 'duration_ms': durationMs,
      if (planType != null) 'plan_type': planType,
      if (accountEmail != null) 'account_email': accountEmail,
      if (accountDisplayName != null)
        'account_display_name': accountDisplayName,
      if (errorCode != null) 'error_code': errorCode,
      if (errorMessage != null) 'error_message': errorMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsageChecksCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String>? queryMethod,
    Value<String>? status,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int?>? durationMs,
    Value<String?>? planType,
    Value<String?>? accountEmail,
    Value<String?>? accountDisplayName,
    Value<String?>? errorCode,
    Value<String?>? errorMessage,
    Value<int>? rowid,
  }) {
    return UsageChecksCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      queryMethod: queryMethod ?? this.queryMethod,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      durationMs: durationMs ?? this.durationMs,
      planType: planType ?? this.planType,
      accountEmail: accountEmail ?? this.accountEmail,
      accountDisplayName: accountDisplayName ?? this.accountDisplayName,
      errorCode: errorCode ?? this.errorCode,
      errorMessage: errorMessage ?? this.errorMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (queryMethod.present) {
      map['query_method'] = Variable<String>(queryMethod.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (planType.present) {
      map['plan_type'] = Variable<String>(planType.value);
    }
    if (accountEmail.present) {
      map['account_email'] = Variable<String>(accountEmail.value);
    }
    if (accountDisplayName.present) {
      map['account_display_name'] = Variable<String>(accountDisplayName.value);
    }
    if (errorCode.present) {
      map['error_code'] = Variable<String>(errorCode.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageChecksCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('queryMethod: $queryMethod, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('planType: $planType, ')
          ..write('accountEmail: $accountEmail, ')
          ..write('accountDisplayName: $accountDisplayName, ')
          ..write('errorCode: $errorCode, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuotaWindowsTable extends QuotaWindows
    with TableInfo<$QuotaWindowsTable, QuotaWindow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuotaWindowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkIdMeta = const VerificationMeta(
    'checkId',
  );
  @override
  late final GeneratedColumn<String> checkId = GeneratedColumn<String>(
    'check_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usage_checks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _limitIdMeta = const VerificationMeta(
    'limitId',
  );
  @override
  late final GeneratedColumn<String> limitId = GeneratedColumn<String>(
    'limit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _limitNameMeta = const VerificationMeta(
    'limitName',
  );
  @override
  late final GeneratedColumn<String> limitName = GeneratedColumn<String>(
    'limit_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _windowTypeMeta = const VerificationMeta(
    'windowType',
  );
  @override
  late final GeneratedColumn<String> windowType = GeneratedColumn<String>(
    'window_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usedPercentMeta = const VerificationMeta(
    'usedPercent',
  );
  @override
  late final GeneratedColumn<double> usedPercent = GeneratedColumn<double>(
    'used_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _windowDurationMinutesMeta =
      const VerificationMeta('windowDurationMinutes');
  @override
  late final GeneratedColumn<int> windowDurationMinutes = GeneratedColumn<int>(
    'window_duration_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resetsAtMeta = const VerificationMeta(
    'resetsAt',
  );
  @override
  late final GeneratedColumn<DateTime> resetsAt = GeneratedColumn<DateTime>(
    'resets_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reachedTypeMeta = const VerificationMeta(
    'reachedType',
  );
  @override
  late final GeneratedColumn<String> reachedType = GeneratedColumn<String>(
    'reached_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planTypeMeta = const VerificationMeta(
    'planType',
  );
  @override
  late final GeneratedColumn<String> planType = GeneratedColumn<String>(
    'plan_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    checkId,
    limitId,
    limitName,
    windowType,
    usedPercent,
    windowDurationMinutes,
    resetsAt,
    reachedType,
    planType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quota_windows';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuotaWindow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('check_id')) {
      context.handle(
        _checkIdMeta,
        checkId.isAcceptableOrUnknown(data['check_id']!, _checkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_checkIdMeta);
    }
    if (data.containsKey('limit_id')) {
      context.handle(
        _limitIdMeta,
        limitId.isAcceptableOrUnknown(data['limit_id']!, _limitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_limitIdMeta);
    }
    if (data.containsKey('limit_name')) {
      context.handle(
        _limitNameMeta,
        limitName.isAcceptableOrUnknown(data['limit_name']!, _limitNameMeta),
      );
    }
    if (data.containsKey('window_type')) {
      context.handle(
        _windowTypeMeta,
        windowType.isAcceptableOrUnknown(data['window_type']!, _windowTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_windowTypeMeta);
    }
    if (data.containsKey('used_percent')) {
      context.handle(
        _usedPercentMeta,
        usedPercent.isAcceptableOrUnknown(
          data['used_percent']!,
          _usedPercentMeta,
        ),
      );
    }
    if (data.containsKey('window_duration_minutes')) {
      context.handle(
        _windowDurationMinutesMeta,
        windowDurationMinutes.isAcceptableOrUnknown(
          data['window_duration_minutes']!,
          _windowDurationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('resets_at')) {
      context.handle(
        _resetsAtMeta,
        resetsAt.isAcceptableOrUnknown(data['resets_at']!, _resetsAtMeta),
      );
    }
    if (data.containsKey('reached_type')) {
      context.handle(
        _reachedTypeMeta,
        reachedType.isAcceptableOrUnknown(
          data['reached_type']!,
          _reachedTypeMeta,
        ),
      );
    }
    if (data.containsKey('plan_type')) {
      context.handle(
        _planTypeMeta,
        planType.isAcceptableOrUnknown(data['plan_type']!, _planTypeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuotaWindow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuotaWindow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      checkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_id'],
      )!,
      limitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}limit_id'],
      )!,
      limitName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}limit_name'],
      ),
      windowType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}window_type'],
      )!,
      usedPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}used_percent'],
      ),
      windowDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}window_duration_minutes'],
      ),
      resetsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resets_at'],
      ),
      reachedType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reached_type'],
      ),
      planType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_type'],
      ),
    );
  }

  @override
  $QuotaWindowsTable createAlias(String alias) {
    return $QuotaWindowsTable(attachedDatabase, alias);
  }
}

class QuotaWindow extends DataClass implements Insertable<QuotaWindow> {
  final String id;
  final String checkId;
  final String limitId;
  final String? limitName;
  final String windowType;
  final double? usedPercent;
  final int? windowDurationMinutes;
  final DateTime? resetsAt;
  final String? reachedType;
  final String? planType;
  const QuotaWindow({
    required this.id,
    required this.checkId,
    required this.limitId,
    this.limitName,
    required this.windowType,
    this.usedPercent,
    this.windowDurationMinutes,
    this.resetsAt,
    this.reachedType,
    this.planType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['check_id'] = Variable<String>(checkId);
    map['limit_id'] = Variable<String>(limitId);
    if (!nullToAbsent || limitName != null) {
      map['limit_name'] = Variable<String>(limitName);
    }
    map['window_type'] = Variable<String>(windowType);
    if (!nullToAbsent || usedPercent != null) {
      map['used_percent'] = Variable<double>(usedPercent);
    }
    if (!nullToAbsent || windowDurationMinutes != null) {
      map['window_duration_minutes'] = Variable<int>(windowDurationMinutes);
    }
    if (!nullToAbsent || resetsAt != null) {
      map['resets_at'] = Variable<DateTime>(resetsAt);
    }
    if (!nullToAbsent || reachedType != null) {
      map['reached_type'] = Variable<String>(reachedType);
    }
    if (!nullToAbsent || planType != null) {
      map['plan_type'] = Variable<String>(planType);
    }
    return map;
  }

  QuotaWindowsCompanion toCompanion(bool nullToAbsent) {
    return QuotaWindowsCompanion(
      id: Value(id),
      checkId: Value(checkId),
      limitId: Value(limitId),
      limitName: limitName == null && nullToAbsent
          ? const Value.absent()
          : Value(limitName),
      windowType: Value(windowType),
      usedPercent: usedPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(usedPercent),
      windowDurationMinutes: windowDurationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(windowDurationMinutes),
      resetsAt: resetsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resetsAt),
      reachedType: reachedType == null && nullToAbsent
          ? const Value.absent()
          : Value(reachedType),
      planType: planType == null && nullToAbsent
          ? const Value.absent()
          : Value(planType),
    );
  }

  factory QuotaWindow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuotaWindow(
      id: serializer.fromJson<String>(json['id']),
      checkId: serializer.fromJson<String>(json['checkId']),
      limitId: serializer.fromJson<String>(json['limitId']),
      limitName: serializer.fromJson<String?>(json['limitName']),
      windowType: serializer.fromJson<String>(json['windowType']),
      usedPercent: serializer.fromJson<double?>(json['usedPercent']),
      windowDurationMinutes: serializer.fromJson<int?>(
        json['windowDurationMinutes'],
      ),
      resetsAt: serializer.fromJson<DateTime?>(json['resetsAt']),
      reachedType: serializer.fromJson<String?>(json['reachedType']),
      planType: serializer.fromJson<String?>(json['planType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'checkId': serializer.toJson<String>(checkId),
      'limitId': serializer.toJson<String>(limitId),
      'limitName': serializer.toJson<String?>(limitName),
      'windowType': serializer.toJson<String>(windowType),
      'usedPercent': serializer.toJson<double?>(usedPercent),
      'windowDurationMinutes': serializer.toJson<int?>(windowDurationMinutes),
      'resetsAt': serializer.toJson<DateTime?>(resetsAt),
      'reachedType': serializer.toJson<String?>(reachedType),
      'planType': serializer.toJson<String?>(planType),
    };
  }

  QuotaWindow copyWith({
    String? id,
    String? checkId,
    String? limitId,
    Value<String?> limitName = const Value.absent(),
    String? windowType,
    Value<double?> usedPercent = const Value.absent(),
    Value<int?> windowDurationMinutes = const Value.absent(),
    Value<DateTime?> resetsAt = const Value.absent(),
    Value<String?> reachedType = const Value.absent(),
    Value<String?> planType = const Value.absent(),
  }) => QuotaWindow(
    id: id ?? this.id,
    checkId: checkId ?? this.checkId,
    limitId: limitId ?? this.limitId,
    limitName: limitName.present ? limitName.value : this.limitName,
    windowType: windowType ?? this.windowType,
    usedPercent: usedPercent.present ? usedPercent.value : this.usedPercent,
    windowDurationMinutes: windowDurationMinutes.present
        ? windowDurationMinutes.value
        : this.windowDurationMinutes,
    resetsAt: resetsAt.present ? resetsAt.value : this.resetsAt,
    reachedType: reachedType.present ? reachedType.value : this.reachedType,
    planType: planType.present ? planType.value : this.planType,
  );
  QuotaWindow copyWithCompanion(QuotaWindowsCompanion data) {
    return QuotaWindow(
      id: data.id.present ? data.id.value : this.id,
      checkId: data.checkId.present ? data.checkId.value : this.checkId,
      limitId: data.limitId.present ? data.limitId.value : this.limitId,
      limitName: data.limitName.present ? data.limitName.value : this.limitName,
      windowType: data.windowType.present
          ? data.windowType.value
          : this.windowType,
      usedPercent: data.usedPercent.present
          ? data.usedPercent.value
          : this.usedPercent,
      windowDurationMinutes: data.windowDurationMinutes.present
          ? data.windowDurationMinutes.value
          : this.windowDurationMinutes,
      resetsAt: data.resetsAt.present ? data.resetsAt.value : this.resetsAt,
      reachedType: data.reachedType.present
          ? data.reachedType.value
          : this.reachedType,
      planType: data.planType.present ? data.planType.value : this.planType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuotaWindow(')
          ..write('id: $id, ')
          ..write('checkId: $checkId, ')
          ..write('limitId: $limitId, ')
          ..write('limitName: $limitName, ')
          ..write('windowType: $windowType, ')
          ..write('usedPercent: $usedPercent, ')
          ..write('windowDurationMinutes: $windowDurationMinutes, ')
          ..write('resetsAt: $resetsAt, ')
          ..write('reachedType: $reachedType, ')
          ..write('planType: $planType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    checkId,
    limitId,
    limitName,
    windowType,
    usedPercent,
    windowDurationMinutes,
    resetsAt,
    reachedType,
    planType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuotaWindow &&
          other.id == this.id &&
          other.checkId == this.checkId &&
          other.limitId == this.limitId &&
          other.limitName == this.limitName &&
          other.windowType == this.windowType &&
          other.usedPercent == this.usedPercent &&
          other.windowDurationMinutes == this.windowDurationMinutes &&
          other.resetsAt == this.resetsAt &&
          other.reachedType == this.reachedType &&
          other.planType == this.planType);
}

class QuotaWindowsCompanion extends UpdateCompanion<QuotaWindow> {
  final Value<String> id;
  final Value<String> checkId;
  final Value<String> limitId;
  final Value<String?> limitName;
  final Value<String> windowType;
  final Value<double?> usedPercent;
  final Value<int?> windowDurationMinutes;
  final Value<DateTime?> resetsAt;
  final Value<String?> reachedType;
  final Value<String?> planType;
  final Value<int> rowid;
  const QuotaWindowsCompanion({
    this.id = const Value.absent(),
    this.checkId = const Value.absent(),
    this.limitId = const Value.absent(),
    this.limitName = const Value.absent(),
    this.windowType = const Value.absent(),
    this.usedPercent = const Value.absent(),
    this.windowDurationMinutes = const Value.absent(),
    this.resetsAt = const Value.absent(),
    this.reachedType = const Value.absent(),
    this.planType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuotaWindowsCompanion.insert({
    required String id,
    required String checkId,
    required String limitId,
    this.limitName = const Value.absent(),
    required String windowType,
    this.usedPercent = const Value.absent(),
    this.windowDurationMinutes = const Value.absent(),
    this.resetsAt = const Value.absent(),
    this.reachedType = const Value.absent(),
    this.planType = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       checkId = Value(checkId),
       limitId = Value(limitId),
       windowType = Value(windowType);
  static Insertable<QuotaWindow> custom({
    Expression<String>? id,
    Expression<String>? checkId,
    Expression<String>? limitId,
    Expression<String>? limitName,
    Expression<String>? windowType,
    Expression<double>? usedPercent,
    Expression<int>? windowDurationMinutes,
    Expression<DateTime>? resetsAt,
    Expression<String>? reachedType,
    Expression<String>? planType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checkId != null) 'check_id': checkId,
      if (limitId != null) 'limit_id': limitId,
      if (limitName != null) 'limit_name': limitName,
      if (windowType != null) 'window_type': windowType,
      if (usedPercent != null) 'used_percent': usedPercent,
      if (windowDurationMinutes != null)
        'window_duration_minutes': windowDurationMinutes,
      if (resetsAt != null) 'resets_at': resetsAt,
      if (reachedType != null) 'reached_type': reachedType,
      if (planType != null) 'plan_type': planType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuotaWindowsCompanion copyWith({
    Value<String>? id,
    Value<String>? checkId,
    Value<String>? limitId,
    Value<String?>? limitName,
    Value<String>? windowType,
    Value<double?>? usedPercent,
    Value<int?>? windowDurationMinutes,
    Value<DateTime?>? resetsAt,
    Value<String?>? reachedType,
    Value<String?>? planType,
    Value<int>? rowid,
  }) {
    return QuotaWindowsCompanion(
      id: id ?? this.id,
      checkId: checkId ?? this.checkId,
      limitId: limitId ?? this.limitId,
      limitName: limitName ?? this.limitName,
      windowType: windowType ?? this.windowType,
      usedPercent: usedPercent ?? this.usedPercent,
      windowDurationMinutes:
          windowDurationMinutes ?? this.windowDurationMinutes,
      resetsAt: resetsAt ?? this.resetsAt,
      reachedType: reachedType ?? this.reachedType,
      planType: planType ?? this.planType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (checkId.present) {
      map['check_id'] = Variable<String>(checkId.value);
    }
    if (limitId.present) {
      map['limit_id'] = Variable<String>(limitId.value);
    }
    if (limitName.present) {
      map['limit_name'] = Variable<String>(limitName.value);
    }
    if (windowType.present) {
      map['window_type'] = Variable<String>(windowType.value);
    }
    if (usedPercent.present) {
      map['used_percent'] = Variable<double>(usedPercent.value);
    }
    if (windowDurationMinutes.present) {
      map['window_duration_minutes'] = Variable<int>(
        windowDurationMinutes.value,
      );
    }
    if (resetsAt.present) {
      map['resets_at'] = Variable<DateTime>(resetsAt.value);
    }
    if (reachedType.present) {
      map['reached_type'] = Variable<String>(reachedType.value);
    }
    if (planType.present) {
      map['plan_type'] = Variable<String>(planType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuotaWindowsCompanion(')
          ..write('id: $id, ')
          ..write('checkId: $checkId, ')
          ..write('limitId: $limitId, ')
          ..write('limitName: $limitName, ')
          ..write('windowType: $windowType, ')
          ..write('usedPercent: $usedPercent, ')
          ..write('windowDurationMinutes: $windowDurationMinutes, ')
          ..write('resetsAt: $resetsAt, ')
          ..write('reachedType: $reachedType, ')
          ..write('planType: $planType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ResetCreditSnapshotsTable extends ResetCreditSnapshots
    with TableInfo<$ResetCreditSnapshotsTable, ResetCreditSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResetCreditSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _checkIdMeta = const VerificationMeta(
    'checkId',
  );
  @override
  late final GeneratedColumn<String> checkId = GeneratedColumn<String>(
    'check_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usage_checks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _availableCountMeta = const VerificationMeta(
    'availableCount',
  );
  @override
  late final GeneratedColumn<int> availableCount = GeneratedColumn<int>(
    'available_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextExpiresAtMeta = const VerificationMeta(
    'nextExpiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextExpiresAt =
      GeneratedColumn<DateTime>(
        'next_expires_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    checkId,
    availableCount,
    nextExpiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reset_credit_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<ResetCreditSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('check_id')) {
      context.handle(
        _checkIdMeta,
        checkId.isAcceptableOrUnknown(data['check_id']!, _checkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_checkIdMeta);
    }
    if (data.containsKey('available_count')) {
      context.handle(
        _availableCountMeta,
        availableCount.isAcceptableOrUnknown(
          data['available_count']!,
          _availableCountMeta,
        ),
      );
    }
    if (data.containsKey('next_expires_at')) {
      context.handle(
        _nextExpiresAtMeta,
        nextExpiresAt.isAcceptableOrUnknown(
          data['next_expires_at']!,
          _nextExpiresAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {checkId};
  @override
  ResetCreditSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResetCreditSnapshot(
      checkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_id'],
      )!,
      availableCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}available_count'],
      )!,
      nextExpiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_expires_at'],
      ),
    );
  }

  @override
  $ResetCreditSnapshotsTable createAlias(String alias) {
    return $ResetCreditSnapshotsTable(attachedDatabase, alias);
  }
}

class ResetCreditSnapshot extends DataClass
    implements Insertable<ResetCreditSnapshot> {
  final String checkId;
  final int availableCount;
  final DateTime? nextExpiresAt;
  const ResetCreditSnapshot({
    required this.checkId,
    required this.availableCount,
    this.nextExpiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['check_id'] = Variable<String>(checkId);
    map['available_count'] = Variable<int>(availableCount);
    if (!nullToAbsent || nextExpiresAt != null) {
      map['next_expires_at'] = Variable<DateTime>(nextExpiresAt);
    }
    return map;
  }

  ResetCreditSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return ResetCreditSnapshotsCompanion(
      checkId: Value(checkId),
      availableCount: Value(availableCount),
      nextExpiresAt: nextExpiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextExpiresAt),
    );
  }

  factory ResetCreditSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResetCreditSnapshot(
      checkId: serializer.fromJson<String>(json['checkId']),
      availableCount: serializer.fromJson<int>(json['availableCount']),
      nextExpiresAt: serializer.fromJson<DateTime?>(json['nextExpiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'checkId': serializer.toJson<String>(checkId),
      'availableCount': serializer.toJson<int>(availableCount),
      'nextExpiresAt': serializer.toJson<DateTime?>(nextExpiresAt),
    };
  }

  ResetCreditSnapshot copyWith({
    String? checkId,
    int? availableCount,
    Value<DateTime?> nextExpiresAt = const Value.absent(),
  }) => ResetCreditSnapshot(
    checkId: checkId ?? this.checkId,
    availableCount: availableCount ?? this.availableCount,
    nextExpiresAt: nextExpiresAt.present
        ? nextExpiresAt.value
        : this.nextExpiresAt,
  );
  ResetCreditSnapshot copyWithCompanion(ResetCreditSnapshotsCompanion data) {
    return ResetCreditSnapshot(
      checkId: data.checkId.present ? data.checkId.value : this.checkId,
      availableCount: data.availableCount.present
          ? data.availableCount.value
          : this.availableCount,
      nextExpiresAt: data.nextExpiresAt.present
          ? data.nextExpiresAt.value
          : this.nextExpiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResetCreditSnapshot(')
          ..write('checkId: $checkId, ')
          ..write('availableCount: $availableCount, ')
          ..write('nextExpiresAt: $nextExpiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(checkId, availableCount, nextExpiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResetCreditSnapshot &&
          other.checkId == this.checkId &&
          other.availableCount == this.availableCount &&
          other.nextExpiresAt == this.nextExpiresAt);
}

class ResetCreditSnapshotsCompanion
    extends UpdateCompanion<ResetCreditSnapshot> {
  final Value<String> checkId;
  final Value<int> availableCount;
  final Value<DateTime?> nextExpiresAt;
  final Value<int> rowid;
  const ResetCreditSnapshotsCompanion({
    this.checkId = const Value.absent(),
    this.availableCount = const Value.absent(),
    this.nextExpiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResetCreditSnapshotsCompanion.insert({
    required String checkId,
    this.availableCount = const Value.absent(),
    this.nextExpiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : checkId = Value(checkId);
  static Insertable<ResetCreditSnapshot> custom({
    Expression<String>? checkId,
    Expression<int>? availableCount,
    Expression<DateTime>? nextExpiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (checkId != null) 'check_id': checkId,
      if (availableCount != null) 'available_count': availableCount,
      if (nextExpiresAt != null) 'next_expires_at': nextExpiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResetCreditSnapshotsCompanion copyWith({
    Value<String>? checkId,
    Value<int>? availableCount,
    Value<DateTime?>? nextExpiresAt,
    Value<int>? rowid,
  }) {
    return ResetCreditSnapshotsCompanion(
      checkId: checkId ?? this.checkId,
      availableCount: availableCount ?? this.availableCount,
      nextExpiresAt: nextExpiresAt ?? this.nextExpiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (checkId.present) {
      map['check_id'] = Variable<String>(checkId.value);
    }
    if (availableCount.present) {
      map['available_count'] = Variable<int>(availableCount.value);
    }
    if (nextExpiresAt.present) {
      map['next_expires_at'] = Variable<DateTime>(nextExpiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResetCreditSnapshotsCompanion(')
          ..write('checkId: $checkId, ')
          ..write('availableCount: $availableCount, ')
          ..write('nextExpiresAt: $nextExpiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyUsageBucketsTable extends DailyUsageBuckets
    with TableInfo<$DailyUsageBucketsTable, DailyUsageBucket> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyUsageBucketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkIdMeta = const VerificationMeta(
    'checkId',
  );
  @override
  late final GeneratedColumn<String> checkId = GeneratedColumn<String>(
    'check_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usage_checks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cli_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<DateTime> day = GeneratedColumn<DateTime>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokensMeta = const VerificationMeta('tokens');
  @override
  late final GeneratedColumn<int> tokens = GeneratedColumn<int>(
    'tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activeMinutesMeta = const VerificationMeta(
    'activeMinutes',
  );
  @override
  late final GeneratedColumn<int> activeMinutes = GeneratedColumn<int>(
    'active_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageCountMeta = const VerificationMeta(
    'messageCount',
  );
  @override
  late final GeneratedColumn<int> messageCount = GeneratedColumn<int>(
    'message_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    checkId,
    profileId,
    day,
    tokens,
    activeMinutes,
    messageCount,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_usage_buckets';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyUsageBucket> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('check_id')) {
      context.handle(
        _checkIdMeta,
        checkId.isAcceptableOrUnknown(data['check_id']!, _checkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_checkIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('tokens')) {
      context.handle(
        _tokensMeta,
        tokens.isAcceptableOrUnknown(data['tokens']!, _tokensMeta),
      );
    }
    if (data.containsKey('active_minutes')) {
      context.handle(
        _activeMinutesMeta,
        activeMinutes.isAcceptableOrUnknown(
          data['active_minutes']!,
          _activeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('message_count')) {
      context.handle(
        _messageCountMeta,
        messageCount.isAcceptableOrUnknown(
          data['message_count']!,
          _messageCountMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyUsageBucket map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyUsageBucket(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      checkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}day'],
      )!,
      tokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tokens'],
      )!,
      activeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_minutes'],
      ),
      messageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}message_count'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $DailyUsageBucketsTable createAlias(String alias) {
    return $DailyUsageBucketsTable(attachedDatabase, alias);
  }
}

class DailyUsageBucket extends DataClass
    implements Insertable<DailyUsageBucket> {
  final String id;
  final String checkId;
  final String profileId;
  final DateTime day;
  final int tokens;
  final int? activeMinutes;
  final int? messageCount;
  final String source;
  const DailyUsageBucket({
    required this.id,
    required this.checkId,
    required this.profileId,
    required this.day,
    required this.tokens,
    this.activeMinutes,
    this.messageCount,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['check_id'] = Variable<String>(checkId);
    map['profile_id'] = Variable<String>(profileId);
    map['day'] = Variable<DateTime>(day);
    map['tokens'] = Variable<int>(tokens);
    if (!nullToAbsent || activeMinutes != null) {
      map['active_minutes'] = Variable<int>(activeMinutes);
    }
    if (!nullToAbsent || messageCount != null) {
      map['message_count'] = Variable<int>(messageCount);
    }
    map['source'] = Variable<String>(source);
    return map;
  }

  DailyUsageBucketsCompanion toCompanion(bool nullToAbsent) {
    return DailyUsageBucketsCompanion(
      id: Value(id),
      checkId: Value(checkId),
      profileId: Value(profileId),
      day: Value(day),
      tokens: Value(tokens),
      activeMinutes: activeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(activeMinutes),
      messageCount: messageCount == null && nullToAbsent
          ? const Value.absent()
          : Value(messageCount),
      source: Value(source),
    );
  }

  factory DailyUsageBucket.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyUsageBucket(
      id: serializer.fromJson<String>(json['id']),
      checkId: serializer.fromJson<String>(json['checkId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      day: serializer.fromJson<DateTime>(json['day']),
      tokens: serializer.fromJson<int>(json['tokens']),
      activeMinutes: serializer.fromJson<int?>(json['activeMinutes']),
      messageCount: serializer.fromJson<int?>(json['messageCount']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'checkId': serializer.toJson<String>(checkId),
      'profileId': serializer.toJson<String>(profileId),
      'day': serializer.toJson<DateTime>(day),
      'tokens': serializer.toJson<int>(tokens),
      'activeMinutes': serializer.toJson<int?>(activeMinutes),
      'messageCount': serializer.toJson<int?>(messageCount),
      'source': serializer.toJson<String>(source),
    };
  }

  DailyUsageBucket copyWith({
    String? id,
    String? checkId,
    String? profileId,
    DateTime? day,
    int? tokens,
    Value<int?> activeMinutes = const Value.absent(),
    Value<int?> messageCount = const Value.absent(),
    String? source,
  }) => DailyUsageBucket(
    id: id ?? this.id,
    checkId: checkId ?? this.checkId,
    profileId: profileId ?? this.profileId,
    day: day ?? this.day,
    tokens: tokens ?? this.tokens,
    activeMinutes: activeMinutes.present
        ? activeMinutes.value
        : this.activeMinutes,
    messageCount: messageCount.present ? messageCount.value : this.messageCount,
    source: source ?? this.source,
  );
  DailyUsageBucket copyWithCompanion(DailyUsageBucketsCompanion data) {
    return DailyUsageBucket(
      id: data.id.present ? data.id.value : this.id,
      checkId: data.checkId.present ? data.checkId.value : this.checkId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      day: data.day.present ? data.day.value : this.day,
      tokens: data.tokens.present ? data.tokens.value : this.tokens,
      activeMinutes: data.activeMinutes.present
          ? data.activeMinutes.value
          : this.activeMinutes,
      messageCount: data.messageCount.present
          ? data.messageCount.value
          : this.messageCount,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyUsageBucket(')
          ..write('id: $id, ')
          ..write('checkId: $checkId, ')
          ..write('profileId: $profileId, ')
          ..write('day: $day, ')
          ..write('tokens: $tokens, ')
          ..write('activeMinutes: $activeMinutes, ')
          ..write('messageCount: $messageCount, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    checkId,
    profileId,
    day,
    tokens,
    activeMinutes,
    messageCount,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyUsageBucket &&
          other.id == this.id &&
          other.checkId == this.checkId &&
          other.profileId == this.profileId &&
          other.day == this.day &&
          other.tokens == this.tokens &&
          other.activeMinutes == this.activeMinutes &&
          other.messageCount == this.messageCount &&
          other.source == this.source);
}

class DailyUsageBucketsCompanion extends UpdateCompanion<DailyUsageBucket> {
  final Value<String> id;
  final Value<String> checkId;
  final Value<String> profileId;
  final Value<DateTime> day;
  final Value<int> tokens;
  final Value<int?> activeMinutes;
  final Value<int?> messageCount;
  final Value<String> source;
  final Value<int> rowid;
  const DailyUsageBucketsCompanion({
    this.id = const Value.absent(),
    this.checkId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.day = const Value.absent(),
    this.tokens = const Value.absent(),
    this.activeMinutes = const Value.absent(),
    this.messageCount = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyUsageBucketsCompanion.insert({
    required String id,
    required String checkId,
    required String profileId,
    required DateTime day,
    this.tokens = const Value.absent(),
    this.activeMinutes = const Value.absent(),
    this.messageCount = const Value.absent(),
    required String source,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       checkId = Value(checkId),
       profileId = Value(profileId),
       day = Value(day),
       source = Value(source);
  static Insertable<DailyUsageBucket> custom({
    Expression<String>? id,
    Expression<String>? checkId,
    Expression<String>? profileId,
    Expression<DateTime>? day,
    Expression<int>? tokens,
    Expression<int>? activeMinutes,
    Expression<int>? messageCount,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checkId != null) 'check_id': checkId,
      if (profileId != null) 'profile_id': profileId,
      if (day != null) 'day': day,
      if (tokens != null) 'tokens': tokens,
      if (activeMinutes != null) 'active_minutes': activeMinutes,
      if (messageCount != null) 'message_count': messageCount,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyUsageBucketsCompanion copyWith({
    Value<String>? id,
    Value<String>? checkId,
    Value<String>? profileId,
    Value<DateTime>? day,
    Value<int>? tokens,
    Value<int?>? activeMinutes,
    Value<int?>? messageCount,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return DailyUsageBucketsCompanion(
      id: id ?? this.id,
      checkId: checkId ?? this.checkId,
      profileId: profileId ?? this.profileId,
      day: day ?? this.day,
      tokens: tokens ?? this.tokens,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      messageCount: messageCount ?? this.messageCount,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (checkId.present) {
      map['check_id'] = Variable<String>(checkId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (day.present) {
      map['day'] = Variable<DateTime>(day.value);
    }
    if (tokens.present) {
      map['tokens'] = Variable<int>(tokens.value);
    }
    if (activeMinutes.present) {
      map['active_minutes'] = Variable<int>(activeMinutes.value);
    }
    if (messageCount.present) {
      map['message_count'] = Variable<int>(messageCount.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyUsageBucketsCompanion(')
          ..write('id: $id, ')
          ..write('checkId: $checkId, ')
          ..write('profileId: $profileId, ')
          ..write('day: $day, ')
          ..write('tokens: $tokens, ')
          ..write('activeMinutes: $activeMinutes, ')
          ..write('messageCount: $messageCount, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommandLogsTable extends CommandLogs
    with TableInfo<$CommandLogsTable, CommandLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommandLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _commandMeta = const VerificationMeta(
    'command',
  );
  @override
  late final GeneratedColumn<String> command = GeneratedColumn<String>(
    'command',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outputMeta = const VerificationMeta('output');
  @override
  late final GeneratedColumn<String> output = GeneratedColumn<String>(
    'output',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exitCodeMeta = const VerificationMeta(
    'exitCode',
  );
  @override
  late final GeneratedColumn<int> exitCode = GeneratedColumn<int>(
    'exit_code',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    command,
    summary,
    output,
    status,
    exitCode,
    startedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'command_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CommandLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    }
    if (data.containsKey('command')) {
      context.handle(
        _commandMeta,
        command.isAcceptableOrUnknown(data['command']!, _commandMeta),
      );
    } else if (isInserting) {
      context.missing(_commandMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('output')) {
      context.handle(
        _outputMeta,
        output.isAcceptableOrUnknown(data['output']!, _outputMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('exit_code')) {
      context.handle(
        _exitCodeMeta,
        exitCode.isAcceptableOrUnknown(data['exit_code']!, _exitCodeMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CommandLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommandLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      ),
      command: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}command'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      output: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}output'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      exitCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exit_code'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $CommandLogsTable createAlias(String alias) {
    return $CommandLogsTable(attachedDatabase, alias);
  }
}

class CommandLog extends DataClass implements Insertable<CommandLog> {
  final String id;
  final String? profileId;
  final String command;
  final String summary;
  final String output;
  final String status;
  final int? exitCode;
  final DateTime startedAt;
  final DateTime? completedAt;
  const CommandLog({
    required this.id,
    this.profileId,
    required this.command,
    required this.summary,
    required this.output,
    required this.status,
    this.exitCode,
    required this.startedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || profileId != null) {
      map['profile_id'] = Variable<String>(profileId);
    }
    map['command'] = Variable<String>(command);
    map['summary'] = Variable<String>(summary);
    map['output'] = Variable<String>(output);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || exitCode != null) {
      map['exit_code'] = Variable<int>(exitCode);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  CommandLogsCompanion toCompanion(bool nullToAbsent) {
    return CommandLogsCompanion(
      id: Value(id),
      profileId: profileId == null && nullToAbsent
          ? const Value.absent()
          : Value(profileId),
      command: Value(command),
      summary: Value(summary),
      output: Value(output),
      status: Value(status),
      exitCode: exitCode == null && nullToAbsent
          ? const Value.absent()
          : Value(exitCode),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory CommandLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommandLog(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String?>(json['profileId']),
      command: serializer.fromJson<String>(json['command']),
      summary: serializer.fromJson<String>(json['summary']),
      output: serializer.fromJson<String>(json['output']),
      status: serializer.fromJson<String>(json['status']),
      exitCode: serializer.fromJson<int?>(json['exitCode']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String?>(profileId),
      'command': serializer.toJson<String>(command),
      'summary': serializer.toJson<String>(summary),
      'output': serializer.toJson<String>(output),
      'status': serializer.toJson<String>(status),
      'exitCode': serializer.toJson<int?>(exitCode),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  CommandLog copyWith({
    String? id,
    Value<String?> profileId = const Value.absent(),
    String? command,
    String? summary,
    String? output,
    String? status,
    Value<int?> exitCode = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => CommandLog(
    id: id ?? this.id,
    profileId: profileId.present ? profileId.value : this.profileId,
    command: command ?? this.command,
    summary: summary ?? this.summary,
    output: output ?? this.output,
    status: status ?? this.status,
    exitCode: exitCode.present ? exitCode.value : this.exitCode,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  CommandLog copyWithCompanion(CommandLogsCompanion data) {
    return CommandLog(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      command: data.command.present ? data.command.value : this.command,
      summary: data.summary.present ? data.summary.value : this.summary,
      output: data.output.present ? data.output.value : this.output,
      status: data.status.present ? data.status.value : this.status,
      exitCode: data.exitCode.present ? data.exitCode.value : this.exitCode,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommandLog(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('command: $command, ')
          ..write('summary: $summary, ')
          ..write('output: $output, ')
          ..write('status: $status, ')
          ..write('exitCode: $exitCode, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    command,
    summary,
    output,
    status,
    exitCode,
    startedAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommandLog &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.command == this.command &&
          other.summary == this.summary &&
          other.output == this.output &&
          other.status == this.status &&
          other.exitCode == this.exitCode &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class CommandLogsCompanion extends UpdateCompanion<CommandLog> {
  final Value<String> id;
  final Value<String?> profileId;
  final Value<String> command;
  final Value<String> summary;
  final Value<String> output;
  final Value<String> status;
  final Value<int?> exitCode;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const CommandLogsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.command = const Value.absent(),
    this.summary = const Value.absent(),
    this.output = const Value.absent(),
    this.status = const Value.absent(),
    this.exitCode = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommandLogsCompanion.insert({
    required String id,
    this.profileId = const Value.absent(),
    required String command,
    required String summary,
    this.output = const Value.absent(),
    required String status,
    this.exitCode = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       command = Value(command),
       summary = Value(summary),
       status = Value(status),
       startedAt = Value(startedAt);
  static Insertable<CommandLog> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? command,
    Expression<String>? summary,
    Expression<String>? output,
    Expression<String>? status,
    Expression<int>? exitCode,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (command != null) 'command': command,
      if (summary != null) 'summary': summary,
      if (output != null) 'output': output,
      if (status != null) 'status': status,
      if (exitCode != null) 'exit_code': exitCode,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommandLogsCompanion copyWith({
    Value<String>? id,
    Value<String?>? profileId,
    Value<String>? command,
    Value<String>? summary,
    Value<String>? output,
    Value<String>? status,
    Value<int?>? exitCode,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return CommandLogsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      command: command ?? this.command,
      summary: summary ?? this.summary,
      output: output ?? this.output,
      status: status ?? this.status,
      exitCode: exitCode ?? this.exitCode,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (command.present) {
      map['command'] = Variable<String>(command.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (output.present) {
      map['output'] = Variable<String>(output.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (exitCode.present) {
      map['exit_code'] = Variable<int>(exitCode.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommandLogsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('command: $command, ')
          ..write('summary: $summary, ')
          ..write('output: $output, ')
          ..write('status: $status, ')
          ..write('exitCode: $exitCode, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _settingKeyMeta = const VerificationMeta(
    'settingKey',
  );
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
    'setting_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingValueMeta = const VerificationMeta(
    'settingValue',
  );
  @override
  late final GeneratedColumn<String> settingValue = GeneratedColumn<String>(
    'setting_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  @override
  List<GeneratedColumn> get $columns => [settingKey, settingValue, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('setting_key')) {
      context.handle(
        _settingKeyMeta,
        settingKey.isAcceptableOrUnknown(data['setting_key']!, _settingKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('setting_value')) {
      context.handle(
        _settingValueMeta,
        settingValue.isAcceptableOrUnknown(
          data['setting_value']!,
          _settingValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_settingValueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {settingKey};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      settingKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_key'],
      )!,
      settingValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String settingKey;
  final String settingValue;
  final DateTime updatedAt;
  const AppSetting({
    required this.settingKey,
    required this.settingValue,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['setting_key'] = Variable<String>(settingKey);
    map['setting_value'] = Variable<String>(settingValue);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      settingKey: Value(settingKey),
      settingValue: Value(settingValue),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      settingKey: serializer.fromJson<String>(json['settingKey']),
      settingValue: serializer.fromJson<String>(json['settingValue']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'settingKey': serializer.toJson<String>(settingKey),
      'settingValue': serializer.toJson<String>(settingValue),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({
    String? settingKey,
    String? settingValue,
    DateTime? updatedAt,
  }) => AppSetting(
    settingKey: settingKey ?? this.settingKey,
    settingValue: settingValue ?? this.settingValue,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      settingKey: data.settingKey.present
          ? data.settingKey.value
          : this.settingKey,
      settingValue: data.settingValue.present
          ? data.settingValue.value
          : this.settingValue,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(settingKey, settingValue, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.settingKey == this.settingKey &&
          other.settingValue == this.settingValue &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> settingKey;
  final Value<String> settingValue;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.settingKey = const Value.absent(),
    this.settingValue = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String settingKey,
    required String settingValue,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : settingKey = Value(settingKey),
       settingValue = Value(settingValue),
       updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? settingKey,
    Expression<String>? settingValue,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (settingKey != null) 'setting_key': settingKey,
      if (settingValue != null) 'setting_value': settingValue,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? settingKey,
    Value<String>? settingValue,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      settingKey: settingKey ?? this.settingKey,
      settingValue: settingValue ?? this.settingValue,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (settingValue.present) {
      map['setting_value'] = Variable<String>(settingValue.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CliProfilesTable cliProfiles = $CliProfilesTable(this);
  late final $ProfileMetadatasTable profileMetadatas = $ProfileMetadatasTable(
    this,
  );
  late final $CostSharesTable costShares = $CostSharesTable(this);
  late final $UsageChecksTable usageChecks = $UsageChecksTable(this);
  late final $QuotaWindowsTable quotaWindows = $QuotaWindowsTable(this);
  late final $ResetCreditSnapshotsTable resetCreditSnapshots =
      $ResetCreditSnapshotsTable(this);
  late final $DailyUsageBucketsTable dailyUsageBuckets =
      $DailyUsageBucketsTable(this);
  late final $CommandLogsTable commandLogs = $CommandLogsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cliProfiles,
    profileMetadatas,
    costShares,
    usageChecks,
    quotaWindows,
    resetCreditSnapshots,
    dailyUsageBuckets,
    commandLogs,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cli_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('profile_metadatas', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cli_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cost_shares', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cli_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('usage_checks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'usage_checks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quota_windows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'usage_checks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reset_credit_snapshots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'usage_checks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('daily_usage_buckets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cli_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('daily_usage_buckets', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CliProfilesTableCreateCompanionBuilder =
    CliProfilesCompanion Function({
      required String id,
      Value<String> toolKey,
      required String profileName,
      Value<String?> commandName,
      required String displayName,
      required String profileHome,
      required String profileSource,
      required String profileType,
      Value<bool> hasAuthFile,
      Value<bool> isAvailable,
      Value<bool> isFavorite,
      required DateTime createdAt,
      required DateTime lastDiscoveredAt,
      Value<DateTime?> lastLaunchedAt,
      Value<int> rowid,
    });
typedef $$CliProfilesTableUpdateCompanionBuilder =
    CliProfilesCompanion Function({
      Value<String> id,
      Value<String> toolKey,
      Value<String> profileName,
      Value<String?> commandName,
      Value<String> displayName,
      Value<String> profileHome,
      Value<String> profileSource,
      Value<String> profileType,
      Value<bool> hasAuthFile,
      Value<bool> isAvailable,
      Value<bool> isFavorite,
      Value<DateTime> createdAt,
      Value<DateTime> lastDiscoveredAt,
      Value<DateTime?> lastLaunchedAt,
      Value<int> rowid,
    });

final class $$CliProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $CliProfilesTable, CliProfile> {
  $$CliProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProfileMetadatasTable, List<ProfileMetadata>>
  _profileMetadatasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.profileMetadatas,
    aliasName: 'cli_profiles__id__profile_metadatas__profile_id',
  );

  $$ProfileMetadatasTableProcessedTableManager get profileMetadatasRefs {
    final manager = $$ProfileMetadatasTableTableManager(
      $_db,
      $_db.profileMetadatas,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _profileMetadatasRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CostSharesTable, List<CostShare>>
  _costSharesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.costShares,
    aliasName: 'cli_profiles__id__cost_shares__profile_id',
  );

  $$CostSharesTableProcessedTableManager get costSharesRefs {
    final manager = $$CostSharesTableTableManager(
      $_db,
      $_db.costShares,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_costSharesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UsageChecksTable, List<UsageCheck>>
  _usageChecksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.usageChecks,
    aliasName: 'cli_profiles__id__usage_checks__profile_id',
  );

  $$UsageChecksTableProcessedTableManager get usageChecksRefs {
    final manager = $$UsageChecksTableTableManager(
      $_db,
      $_db.usageChecks,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_usageChecksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DailyUsageBucketsTable, List<DailyUsageBucket>>
  _dailyUsageBucketsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dailyUsageBuckets,
        aliasName: 'cli_profiles__id__daily_usage_buckets__profile_id',
      );

  $$DailyUsageBucketsTableProcessedTableManager get dailyUsageBucketsRefs {
    final manager = $$DailyUsageBucketsTableTableManager(
      $_db,
      $_db.dailyUsageBuckets,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dailyUsageBucketsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CliProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $CliProfilesTable> {
  $$CliProfilesTableFilterComposer({
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

  ColumnFilters<String> get toolKey => $composableBuilder(
    column: $table.toolKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileName => $composableBuilder(
    column: $table.profileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get commandName => $composableBuilder(
    column: $table.commandName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileHome => $composableBuilder(
    column: $table.profileHome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileSource => $composableBuilder(
    column: $table.profileSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileType => $composableBuilder(
    column: $table.profileType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasAuthFile => $composableBuilder(
    column: $table.hasAuthFile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastDiscoveredAt => $composableBuilder(
    column: $table.lastDiscoveredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLaunchedAt => $composableBuilder(
    column: $table.lastLaunchedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> profileMetadatasRefs(
    Expression<bool> Function($$ProfileMetadatasTableFilterComposer f) f,
  ) {
    final $$ProfileMetadatasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.profileMetadatas,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileMetadatasTableFilterComposer(
            $db: $db,
            $table: $db.profileMetadatas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> costSharesRefs(
    Expression<bool> Function($$CostSharesTableFilterComposer f) f,
  ) {
    final $$CostSharesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.costShares,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CostSharesTableFilterComposer(
            $db: $db,
            $table: $db.costShares,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> usageChecksRefs(
    Expression<bool> Function($$UsageChecksTableFilterComposer f) f,
  ) {
    final $$UsageChecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usageChecks,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageChecksTableFilterComposer(
            $db: $db,
            $table: $db.usageChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dailyUsageBucketsRefs(
    Expression<bool> Function($$DailyUsageBucketsTableFilterComposer f) f,
  ) {
    final $$DailyUsageBucketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyUsageBuckets,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyUsageBucketsTableFilterComposer(
            $db: $db,
            $table: $db.dailyUsageBuckets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CliProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $CliProfilesTable> {
  $$CliProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get toolKey => $composableBuilder(
    column: $table.toolKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileName => $composableBuilder(
    column: $table.profileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commandName => $composableBuilder(
    column: $table.commandName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileHome => $composableBuilder(
    column: $table.profileHome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileSource => $composableBuilder(
    column: $table.profileSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileType => $composableBuilder(
    column: $table.profileType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasAuthFile => $composableBuilder(
    column: $table.hasAuthFile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastDiscoveredAt => $composableBuilder(
    column: $table.lastDiscoveredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLaunchedAt => $composableBuilder(
    column: $table.lastLaunchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CliProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CliProfilesTable> {
  $$CliProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get toolKey =>
      $composableBuilder(column: $table.toolKey, builder: (column) => column);

  GeneratedColumn<String> get profileName => $composableBuilder(
    column: $table.profileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get commandName => $composableBuilder(
    column: $table.commandName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileHome => $composableBuilder(
    column: $table.profileHome,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileSource => $composableBuilder(
    column: $table.profileSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileType => $composableBuilder(
    column: $table.profileType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasAuthFile => $composableBuilder(
    column: $table.hasAuthFile,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastDiscoveredAt => $composableBuilder(
    column: $table.lastDiscoveredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastLaunchedAt => $composableBuilder(
    column: $table.lastLaunchedAt,
    builder: (column) => column,
  );

  Expression<T> profileMetadatasRefs<T extends Object>(
    Expression<T> Function($$ProfileMetadatasTableAnnotationComposer a) f,
  ) {
    final $$ProfileMetadatasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.profileMetadatas,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileMetadatasTableAnnotationComposer(
            $db: $db,
            $table: $db.profileMetadatas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> costSharesRefs<T extends Object>(
    Expression<T> Function($$CostSharesTableAnnotationComposer a) f,
  ) {
    final $$CostSharesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.costShares,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CostSharesTableAnnotationComposer(
            $db: $db,
            $table: $db.costShares,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> usageChecksRefs<T extends Object>(
    Expression<T> Function($$UsageChecksTableAnnotationComposer a) f,
  ) {
    final $$UsageChecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usageChecks,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageChecksTableAnnotationComposer(
            $db: $db,
            $table: $db.usageChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dailyUsageBucketsRefs<T extends Object>(
    Expression<T> Function($$DailyUsageBucketsTableAnnotationComposer a) f,
  ) {
    final $$DailyUsageBucketsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dailyUsageBuckets,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DailyUsageBucketsTableAnnotationComposer(
                $db: $db,
                $table: $db.dailyUsageBuckets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CliProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CliProfilesTable,
          CliProfile,
          $$CliProfilesTableFilterComposer,
          $$CliProfilesTableOrderingComposer,
          $$CliProfilesTableAnnotationComposer,
          $$CliProfilesTableCreateCompanionBuilder,
          $$CliProfilesTableUpdateCompanionBuilder,
          (CliProfile, $$CliProfilesTableReferences),
          CliProfile,
          PrefetchHooks Function({
            bool profileMetadatasRefs,
            bool costSharesRefs,
            bool usageChecksRefs,
            bool dailyUsageBucketsRefs,
          })
        > {
  $$CliProfilesTableTableManager(_$AppDatabase db, $CliProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CliProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CliProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CliProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> toolKey = const Value.absent(),
                Value<String> profileName = const Value.absent(),
                Value<String?> commandName = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> profileHome = const Value.absent(),
                Value<String> profileSource = const Value.absent(),
                Value<String> profileType = const Value.absent(),
                Value<bool> hasAuthFile = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastDiscoveredAt = const Value.absent(),
                Value<DateTime?> lastLaunchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CliProfilesCompanion(
                id: id,
                toolKey: toolKey,
                profileName: profileName,
                commandName: commandName,
                displayName: displayName,
                profileHome: profileHome,
                profileSource: profileSource,
                profileType: profileType,
                hasAuthFile: hasAuthFile,
                isAvailable: isAvailable,
                isFavorite: isFavorite,
                createdAt: createdAt,
                lastDiscoveredAt: lastDiscoveredAt,
                lastLaunchedAt: lastLaunchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> toolKey = const Value.absent(),
                required String profileName,
                Value<String?> commandName = const Value.absent(),
                required String displayName,
                required String profileHome,
                required String profileSource,
                required String profileType,
                Value<bool> hasAuthFile = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                required DateTime createdAt,
                required DateTime lastDiscoveredAt,
                Value<DateTime?> lastLaunchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CliProfilesCompanion.insert(
                id: id,
                toolKey: toolKey,
                profileName: profileName,
                commandName: commandName,
                displayName: displayName,
                profileHome: profileHome,
                profileSource: profileSource,
                profileType: profileType,
                hasAuthFile: hasAuthFile,
                isAvailable: isAvailable,
                isFavorite: isFavorite,
                createdAt: createdAt,
                lastDiscoveredAt: lastDiscoveredAt,
                lastLaunchedAt: lastLaunchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CliProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                profileMetadatasRefs = false,
                costSharesRefs = false,
                usageChecksRefs = false,
                dailyUsageBucketsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (profileMetadatasRefs) db.profileMetadatas,
                    if (costSharesRefs) db.costShares,
                    if (usageChecksRefs) db.usageChecks,
                    if (dailyUsageBucketsRefs) db.dailyUsageBuckets,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (profileMetadatasRefs)
                        await $_getPrefetchedData<
                          CliProfile,
                          $CliProfilesTable,
                          ProfileMetadata
                        >(
                          currentTable: table,
                          referencedTable: $$CliProfilesTableReferences
                              ._profileMetadatasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CliProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).profileMetadatasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (costSharesRefs)
                        await $_getPrefetchedData<
                          CliProfile,
                          $CliProfilesTable,
                          CostShare
                        >(
                          currentTable: table,
                          referencedTable: $$CliProfilesTableReferences
                              ._costSharesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CliProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).costSharesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (usageChecksRefs)
                        await $_getPrefetchedData<
                          CliProfile,
                          $CliProfilesTable,
                          UsageCheck
                        >(
                          currentTable: table,
                          referencedTable: $$CliProfilesTableReferences
                              ._usageChecksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CliProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).usageChecksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dailyUsageBucketsRefs)
                        await $_getPrefetchedData<
                          CliProfile,
                          $CliProfilesTable,
                          DailyUsageBucket
                        >(
                          currentTable: table,
                          referencedTable: $$CliProfilesTableReferences
                              ._dailyUsageBucketsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CliProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).dailyUsageBucketsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CliProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CliProfilesTable,
      CliProfile,
      $$CliProfilesTableFilterComposer,
      $$CliProfilesTableOrderingComposer,
      $$CliProfilesTableAnnotationComposer,
      $$CliProfilesTableCreateCompanionBuilder,
      $$CliProfilesTableUpdateCompanionBuilder,
      (CliProfile, $$CliProfilesTableReferences),
      CliProfile,
      PrefetchHooks Function({
        bool profileMetadatasRefs,
        bool costSharesRefs,
        bool usageChecksRefs,
        bool dailyUsageBucketsRefs,
      })
    >;
typedef $$ProfileMetadatasTableCreateCompanionBuilder =
    ProfileMetadatasCompanion Function({
      required String profileId,
      Value<String> accountEmail,
      Value<String> accountDisplayName,
      Value<String> planName,
      Value<String> notes,
      Value<String> tagsJson,
      Value<DateTime?> purchasedOn,
      Value<DateTime?> nextRenewalOn,
      Value<String> billingInterval,
      Value<int> expectedAmountMinor,
      Value<String> currencyCode,
      Value<bool> autoRenew,
      Value<String> subscriptionStatus,
      Value<String> purchasedFrom,
      Value<String> paymentMethodLabel,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProfileMetadatasTableUpdateCompanionBuilder =
    ProfileMetadatasCompanion Function({
      Value<String> profileId,
      Value<String> accountEmail,
      Value<String> accountDisplayName,
      Value<String> planName,
      Value<String> notes,
      Value<String> tagsJson,
      Value<DateTime?> purchasedOn,
      Value<DateTime?> nextRenewalOn,
      Value<String> billingInterval,
      Value<int> expectedAmountMinor,
      Value<String> currencyCode,
      Value<bool> autoRenew,
      Value<String> subscriptionStatus,
      Value<String> purchasedFrom,
      Value<String> paymentMethodLabel,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ProfileMetadatasTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProfileMetadatasTable, ProfileMetadata> {
  $$ProfileMetadatasTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CliProfilesTable _profileIdTable(_$AppDatabase db) => db.cliProfiles
      .createAlias('profile_metadatas__profile_id__cli_profiles__id');

  $$CliProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$CliProfilesTableTableManager(
      $_db,
      $_db.cliProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProfileMetadatasTableFilterComposer
    extends Composer<_$AppDatabase, $ProfileMetadatasTable> {
  $$ProfileMetadatasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get accountEmail => $composableBuilder(
    column: $table.accountEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountDisplayName => $composableBuilder(
    column: $table.accountDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planName => $composableBuilder(
    column: $table.planName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedOn => $composableBuilder(
    column: $table.purchasedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRenewalOn => $composableBuilder(
    column: $table.nextRenewalOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billingInterval => $composableBuilder(
    column: $table.billingInterval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoRenew => $composableBuilder(
    column: $table.autoRenew,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subscriptionStatus => $composableBuilder(
    column: $table.subscriptionStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchasedFrom => $composableBuilder(
    column: $table.purchasedFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethodLabel => $composableBuilder(
    column: $table.paymentMethodLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CliProfilesTableFilterComposer get profileId {
    final $$CliProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.cliProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CliProfilesTableFilterComposer(
            $db: $db,
            $table: $db.cliProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfileMetadatasTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfileMetadatasTable> {
  $$ProfileMetadatasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get accountEmail => $composableBuilder(
    column: $table.accountEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountDisplayName => $composableBuilder(
    column: $table.accountDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planName => $composableBuilder(
    column: $table.planName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedOn => $composableBuilder(
    column: $table.purchasedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRenewalOn => $composableBuilder(
    column: $table.nextRenewalOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billingInterval => $composableBuilder(
    column: $table.billingInterval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoRenew => $composableBuilder(
    column: $table.autoRenew,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subscriptionStatus => $composableBuilder(
    column: $table.subscriptionStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchasedFrom => $composableBuilder(
    column: $table.purchasedFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethodLabel => $composableBuilder(
    column: $table.paymentMethodLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CliProfilesTableOrderingComposer get profileId {
    final $$CliProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.cliProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CliProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.cliProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfileMetadatasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfileMetadatasTable> {
  $$ProfileMetadatasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get accountEmail => $composableBuilder(
    column: $table.accountEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountDisplayName => $composableBuilder(
    column: $table.accountDisplayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planName =>
      $composableBuilder(column: $table.planName, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedOn => $composableBuilder(
    column: $table.purchasedOn,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextRenewalOn => $composableBuilder(
    column: $table.nextRenewalOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get billingInterval => $composableBuilder(
    column: $table.billingInterval,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoRenew =>
      $composableBuilder(column: $table.autoRenew, builder: (column) => column);

  GeneratedColumn<String> get subscriptionStatus => $composableBuilder(
    column: $table.subscriptionStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get purchasedFrom => $composableBuilder(
    column: $table.purchasedFrom,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethodLabel => $composableBuilder(
    column: $table.paymentMethodLabel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CliProfilesTableAnnotationComposer get profileId {
    final $$CliProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.cliProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CliProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.cliProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfileMetadatasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfileMetadatasTable,
          ProfileMetadata,
          $$ProfileMetadatasTableFilterComposer,
          $$ProfileMetadatasTableOrderingComposer,
          $$ProfileMetadatasTableAnnotationComposer,
          $$ProfileMetadatasTableCreateCompanionBuilder,
          $$ProfileMetadatasTableUpdateCompanionBuilder,
          (ProfileMetadata, $$ProfileMetadatasTableReferences),
          ProfileMetadata,
          PrefetchHooks Function({bool profileId})
        > {
  $$ProfileMetadatasTableTableManager(
    _$AppDatabase db,
    $ProfileMetadatasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileMetadatasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileMetadatasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileMetadatasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> accountEmail = const Value.absent(),
                Value<String> accountDisplayName = const Value.absent(),
                Value<String> planName = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<DateTime?> purchasedOn = const Value.absent(),
                Value<DateTime?> nextRenewalOn = const Value.absent(),
                Value<String> billingInterval = const Value.absent(),
                Value<int> expectedAmountMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<bool> autoRenew = const Value.absent(),
                Value<String> subscriptionStatus = const Value.absent(),
                Value<String> purchasedFrom = const Value.absent(),
                Value<String> paymentMethodLabel = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfileMetadatasCompanion(
                profileId: profileId,
                accountEmail: accountEmail,
                accountDisplayName: accountDisplayName,
                planName: planName,
                notes: notes,
                tagsJson: tagsJson,
                purchasedOn: purchasedOn,
                nextRenewalOn: nextRenewalOn,
                billingInterval: billingInterval,
                expectedAmountMinor: expectedAmountMinor,
                currencyCode: currencyCode,
                autoRenew: autoRenew,
                subscriptionStatus: subscriptionStatus,
                purchasedFrom: purchasedFrom,
                paymentMethodLabel: paymentMethodLabel,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                Value<String> accountEmail = const Value.absent(),
                Value<String> accountDisplayName = const Value.absent(),
                Value<String> planName = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<DateTime?> purchasedOn = const Value.absent(),
                Value<DateTime?> nextRenewalOn = const Value.absent(),
                Value<String> billingInterval = const Value.absent(),
                Value<int> expectedAmountMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<bool> autoRenew = const Value.absent(),
                Value<String> subscriptionStatus = const Value.absent(),
                Value<String> purchasedFrom = const Value.absent(),
                Value<String> paymentMethodLabel = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProfileMetadatasCompanion.insert(
                profileId: profileId,
                accountEmail: accountEmail,
                accountDisplayName: accountDisplayName,
                planName: planName,
                notes: notes,
                tagsJson: tagsJson,
                purchasedOn: purchasedOn,
                nextRenewalOn: nextRenewalOn,
                billingInterval: billingInterval,
                expectedAmountMinor: expectedAmountMinor,
                currencyCode: currencyCode,
                autoRenew: autoRenew,
                subscriptionStatus: subscriptionStatus,
                purchasedFrom: purchasedFrom,
                paymentMethodLabel: paymentMethodLabel,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProfileMetadatasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable:
                                    $$ProfileMetadatasTableReferences
                                        ._profileIdTable(db),
                                referencedColumn:
                                    $$ProfileMetadatasTableReferences
                                        ._profileIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProfileMetadatasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfileMetadatasTable,
      ProfileMetadata,
      $$ProfileMetadatasTableFilterComposer,
      $$ProfileMetadatasTableOrderingComposer,
      $$ProfileMetadatasTableAnnotationComposer,
      $$ProfileMetadatasTableCreateCompanionBuilder,
      $$ProfileMetadatasTableUpdateCompanionBuilder,
      (ProfileMetadata, $$ProfileMetadatasTableReferences),
      ProfileMetadata,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$CostSharesTableCreateCompanionBuilder =
    CostSharesCompanion Function({
      required String id,
      required String profileId,
      required String personName,
      Value<int> expectedAmountMinor,
      Value<int> paidAmountMinor,
      Value<String> currencyCode,
      Value<String> paymentStatus,
      Value<DateTime?> paidOn,
      Value<String> notes,
      Value<int> rowid,
    });
typedef $$CostSharesTableUpdateCompanionBuilder =
    CostSharesCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<String> personName,
      Value<int> expectedAmountMinor,
      Value<int> paidAmountMinor,
      Value<String> currencyCode,
      Value<String> paymentStatus,
      Value<DateTime?> paidOn,
      Value<String> notes,
      Value<int> rowid,
    });

final class $$CostSharesTableReferences
    extends BaseReferences<_$AppDatabase, $CostSharesTable, CostShare> {
  $$CostSharesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CliProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.cliProfiles.createAlias('cost_shares__profile_id__cli_profiles__id');

  $$CliProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$CliProfilesTableTableManager(
      $_db,
      $_db.cliProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CostSharesTableFilterComposer
    extends Composer<_$AppDatabase, $CostSharesTable> {
  $$CostSharesTableFilterComposer({
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

  ColumnFilters<String> get personName => $composableBuilder(
    column: $table.personName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidAmountMinor => $composableBuilder(
    column: $table.paidAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidOn => $composableBuilder(
    column: $table.paidOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$CliProfilesTableFilterComposer get profileId {
    final $$CliProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.cliProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CliProfilesTableFilterComposer(
            $db: $db,
            $table: $db.cliProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CostSharesTableOrderingComposer
    extends Composer<_$AppDatabase, $CostSharesTable> {
  $$CostSharesTableOrderingComposer({
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

  ColumnOrderings<String> get personName => $composableBuilder(
    column: $table.personName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidAmountMinor => $composableBuilder(
    column: $table.paidAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidOn => $composableBuilder(
    column: $table.paidOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$CliProfilesTableOrderingComposer get profileId {
    final $$CliProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.cliProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CliProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.cliProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CostSharesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CostSharesTable> {
  $$CostSharesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get personName => $composableBuilder(
    column: $table.personName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paidAmountMinor => $composableBuilder(
    column: $table.paidAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paidOn =>
      $composableBuilder(column: $table.paidOn, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$CliProfilesTableAnnotationComposer get profileId {
    final $$CliProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.cliProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CliProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.cliProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CostSharesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CostSharesTable,
          CostShare,
          $$CostSharesTableFilterComposer,
          $$CostSharesTableOrderingComposer,
          $$CostSharesTableAnnotationComposer,
          $$CostSharesTableCreateCompanionBuilder,
          $$CostSharesTableUpdateCompanionBuilder,
          (CostShare, $$CostSharesTableReferences),
          CostShare,
          PrefetchHooks Function({bool profileId})
        > {
  $$CostSharesTableTableManager(_$AppDatabase db, $CostSharesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CostSharesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CostSharesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CostSharesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> personName = const Value.absent(),
                Value<int> expectedAmountMinor = const Value.absent(),
                Value<int> paidAmountMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<DateTime?> paidOn = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CostSharesCompanion(
                id: id,
                profileId: profileId,
                personName: personName,
                expectedAmountMinor: expectedAmountMinor,
                paidAmountMinor: paidAmountMinor,
                currencyCode: currencyCode,
                paymentStatus: paymentStatus,
                paidOn: paidOn,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required String personName,
                Value<int> expectedAmountMinor = const Value.absent(),
                Value<int> paidAmountMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<DateTime?> paidOn = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CostSharesCompanion.insert(
                id: id,
                profileId: profileId,
                personName: personName,
                expectedAmountMinor: expectedAmountMinor,
                paidAmountMinor: paidAmountMinor,
                currencyCode: currencyCode,
                paymentStatus: paymentStatus,
                paidOn: paidOn,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CostSharesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable: $$CostSharesTableReferences
                                    ._profileIdTable(db),
                                referencedColumn: $$CostSharesTableReferences
                                    ._profileIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CostSharesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CostSharesTable,
      CostShare,
      $$CostSharesTableFilterComposer,
      $$CostSharesTableOrderingComposer,
      $$CostSharesTableAnnotationComposer,
      $$CostSharesTableCreateCompanionBuilder,
      $$CostSharesTableUpdateCompanionBuilder,
      (CostShare, $$CostSharesTableReferences),
      CostShare,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$UsageChecksTableCreateCompanionBuilder =
    UsageChecksCompanion Function({
      required String id,
      required String profileId,
      Value<String> queryMethod,
      required String status,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<int?> durationMs,
      Value<String?> planType,
      Value<String?> accountEmail,
      Value<String?> accountDisplayName,
      Value<String?> errorCode,
      Value<String?> errorMessage,
      Value<int> rowid,
    });
typedef $$UsageChecksTableUpdateCompanionBuilder =
    UsageChecksCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<String> queryMethod,
      Value<String> status,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<int?> durationMs,
      Value<String?> planType,
      Value<String?> accountEmail,
      Value<String?> accountDisplayName,
      Value<String?> errorCode,
      Value<String?> errorMessage,
      Value<int> rowid,
    });

final class $$UsageChecksTableReferences
    extends BaseReferences<_$AppDatabase, $UsageChecksTable, UsageCheck> {
  $$UsageChecksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CliProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.cliProfiles.createAlias('usage_checks__profile_id__cli_profiles__id');

  $$CliProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$CliProfilesTableTableManager(
      $_db,
      $_db.cliProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$QuotaWindowsTable, List<QuotaWindow>>
  _quotaWindowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quotaWindows,
    aliasName: 'usage_checks__id__quota_windows__check_id',
  );

  $$QuotaWindowsTableProcessedTableManager get quotaWindowsRefs {
    final manager = $$QuotaWindowsTableTableManager(
      $_db,
      $_db.quotaWindows,
    ).filter((f) => f.checkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quotaWindowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ResetCreditSnapshotsTable,
    List<ResetCreditSnapshot>
  >
  _resetCreditSnapshotsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.resetCreditSnapshots,
        aliasName: 'usage_checks__id__reset_credit_snapshots__check_id',
      );

  $$ResetCreditSnapshotsTableProcessedTableManager
  get resetCreditSnapshotsRefs {
    final manager = $$ResetCreditSnapshotsTableTableManager(
      $_db,
      $_db.resetCreditSnapshots,
    ).filter((f) => f.checkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _resetCreditSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DailyUsageBucketsTable, List<DailyUsageBucket>>
  _dailyUsageBucketsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dailyUsageBuckets,
        aliasName: 'usage_checks__id__daily_usage_buckets__check_id',
      );

  $$DailyUsageBucketsTableProcessedTableManager get dailyUsageBucketsRefs {
    final manager = $$DailyUsageBucketsTableTableManager(
      $_db,
      $_db.dailyUsageBuckets,
    ).filter((f) => f.checkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dailyUsageBucketsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsageChecksTableFilterComposer
    extends Composer<_$AppDatabase, $UsageChecksTable> {
  $$UsageChecksTableFilterComposer({
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

  ColumnFilters<String> get queryMethod => $composableBuilder(
    column: $table.queryMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountEmail => $composableBuilder(
    column: $table.accountEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountDisplayName => $composableBuilder(
    column: $table.accountDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  $$CliProfilesTableFilterComposer get profileId {
    final $$CliProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.cliProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CliProfilesTableFilterComposer(
            $db: $db,
            $table: $db.cliProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> quotaWindowsRefs(
    Expression<bool> Function($$QuotaWindowsTableFilterComposer f) f,
  ) {
    final $$QuotaWindowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quotaWindows,
      getReferencedColumn: (t) => t.checkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotaWindowsTableFilterComposer(
            $db: $db,
            $table: $db.quotaWindows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> resetCreditSnapshotsRefs(
    Expression<bool> Function($$ResetCreditSnapshotsTableFilterComposer f) f,
  ) {
    final $$ResetCreditSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resetCreditSnapshots,
      getReferencedColumn: (t) => t.checkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResetCreditSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.resetCreditSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dailyUsageBucketsRefs(
    Expression<bool> Function($$DailyUsageBucketsTableFilterComposer f) f,
  ) {
    final $$DailyUsageBucketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyUsageBuckets,
      getReferencedColumn: (t) => t.checkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyUsageBucketsTableFilterComposer(
            $db: $db,
            $table: $db.dailyUsageBuckets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsageChecksTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageChecksTable> {
  $$UsageChecksTableOrderingComposer({
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

  ColumnOrderings<String> get queryMethod => $composableBuilder(
    column: $table.queryMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountEmail => $composableBuilder(
    column: $table.accountEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountDisplayName => $composableBuilder(
    column: $table.accountDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  $$CliProfilesTableOrderingComposer get profileId {
    final $$CliProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.cliProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CliProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.cliProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsageChecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageChecksTable> {
  $$UsageChecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get queryMethod => $composableBuilder(
    column: $table.queryMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planType =>
      $composableBuilder(column: $table.planType, builder: (column) => column);

  GeneratedColumn<String> get accountEmail => $composableBuilder(
    column: $table.accountEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountDisplayName => $composableBuilder(
    column: $table.accountDisplayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorCode =>
      $composableBuilder(column: $table.errorCode, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  $$CliProfilesTableAnnotationComposer get profileId {
    final $$CliProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.cliProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CliProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.cliProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> quotaWindowsRefs<T extends Object>(
    Expression<T> Function($$QuotaWindowsTableAnnotationComposer a) f,
  ) {
    final $$QuotaWindowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quotaWindows,
      getReferencedColumn: (t) => t.checkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotaWindowsTableAnnotationComposer(
            $db: $db,
            $table: $db.quotaWindows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> resetCreditSnapshotsRefs<T extends Object>(
    Expression<T> Function($$ResetCreditSnapshotsTableAnnotationComposer a) f,
  ) {
    final $$ResetCreditSnapshotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.resetCreditSnapshots,
          getReferencedColumn: (t) => t.checkId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ResetCreditSnapshotsTableAnnotationComposer(
                $db: $db,
                $table: $db.resetCreditSnapshots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> dailyUsageBucketsRefs<T extends Object>(
    Expression<T> Function($$DailyUsageBucketsTableAnnotationComposer a) f,
  ) {
    final $$DailyUsageBucketsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dailyUsageBuckets,
          getReferencedColumn: (t) => t.checkId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DailyUsageBucketsTableAnnotationComposer(
                $db: $db,
                $table: $db.dailyUsageBuckets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$UsageChecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsageChecksTable,
          UsageCheck,
          $$UsageChecksTableFilterComposer,
          $$UsageChecksTableOrderingComposer,
          $$UsageChecksTableAnnotationComposer,
          $$UsageChecksTableCreateCompanionBuilder,
          $$UsageChecksTableUpdateCompanionBuilder,
          (UsageCheck, $$UsageChecksTableReferences),
          UsageCheck,
          PrefetchHooks Function({
            bool profileId,
            bool quotaWindowsRefs,
            bool resetCreditSnapshotsRefs,
            bool dailyUsageBucketsRefs,
          })
        > {
  $$UsageChecksTableTableManager(_$AppDatabase db, $UsageChecksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageChecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageChecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageChecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> queryMethod = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> planType = const Value.absent(),
                Value<String?> accountEmail = const Value.absent(),
                Value<String?> accountDisplayName = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageChecksCompanion(
                id: id,
                profileId: profileId,
                queryMethod: queryMethod,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                durationMs: durationMs,
                planType: planType,
                accountEmail: accountEmail,
                accountDisplayName: accountDisplayName,
                errorCode: errorCode,
                errorMessage: errorMessage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                Value<String> queryMethod = const Value.absent(),
                required String status,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> planType = const Value.absent(),
                Value<String?> accountEmail = const Value.absent(),
                Value<String?> accountDisplayName = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageChecksCompanion.insert(
                id: id,
                profileId: profileId,
                queryMethod: queryMethod,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                durationMs: durationMs,
                planType: planType,
                accountEmail: accountEmail,
                accountDisplayName: accountDisplayName,
                errorCode: errorCode,
                errorMessage: errorMessage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UsageChecksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                profileId = false,
                quotaWindowsRefs = false,
                resetCreditSnapshotsRefs = false,
                dailyUsageBucketsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (quotaWindowsRefs) db.quotaWindows,
                    if (resetCreditSnapshotsRefs) db.resetCreditSnapshots,
                    if (dailyUsageBucketsRefs) db.dailyUsageBuckets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.profileId,
                                    referencedTable:
                                        $$UsageChecksTableReferences
                                            ._profileIdTable(db),
                                    referencedColumn:
                                        $$UsageChecksTableReferences
                                            ._profileIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (quotaWindowsRefs)
                        await $_getPrefetchedData<
                          UsageCheck,
                          $UsageChecksTable,
                          QuotaWindow
                        >(
                          currentTable: table,
                          referencedTable: $$UsageChecksTableReferences
                              ._quotaWindowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsageChecksTableReferences(
                                db,
                                table,
                                p0,
                              ).quotaWindowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.checkId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (resetCreditSnapshotsRefs)
                        await $_getPrefetchedData<
                          UsageCheck,
                          $UsageChecksTable,
                          ResetCreditSnapshot
                        >(
                          currentTable: table,
                          referencedTable: $$UsageChecksTableReferences
                              ._resetCreditSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsageChecksTableReferences(
                                db,
                                table,
                                p0,
                              ).resetCreditSnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.checkId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dailyUsageBucketsRefs)
                        await $_getPrefetchedData<
                          UsageCheck,
                          $UsageChecksTable,
                          DailyUsageBucket
                        >(
                          currentTable: table,
                          referencedTable: $$UsageChecksTableReferences
                              ._dailyUsageBucketsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsageChecksTableReferences(
                                db,
                                table,
                                p0,
                              ).dailyUsageBucketsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.checkId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsageChecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsageChecksTable,
      UsageCheck,
      $$UsageChecksTableFilterComposer,
      $$UsageChecksTableOrderingComposer,
      $$UsageChecksTableAnnotationComposer,
      $$UsageChecksTableCreateCompanionBuilder,
      $$UsageChecksTableUpdateCompanionBuilder,
      (UsageCheck, $$UsageChecksTableReferences),
      UsageCheck,
      PrefetchHooks Function({
        bool profileId,
        bool quotaWindowsRefs,
        bool resetCreditSnapshotsRefs,
        bool dailyUsageBucketsRefs,
      })
    >;
typedef $$QuotaWindowsTableCreateCompanionBuilder =
    QuotaWindowsCompanion Function({
      required String id,
      required String checkId,
      required String limitId,
      Value<String?> limitName,
      required String windowType,
      Value<double?> usedPercent,
      Value<int?> windowDurationMinutes,
      Value<DateTime?> resetsAt,
      Value<String?> reachedType,
      Value<String?> planType,
      Value<int> rowid,
    });
typedef $$QuotaWindowsTableUpdateCompanionBuilder =
    QuotaWindowsCompanion Function({
      Value<String> id,
      Value<String> checkId,
      Value<String> limitId,
      Value<String?> limitName,
      Value<String> windowType,
      Value<double?> usedPercent,
      Value<int?> windowDurationMinutes,
      Value<DateTime?> resetsAt,
      Value<String?> reachedType,
      Value<String?> planType,
      Value<int> rowid,
    });

final class $$QuotaWindowsTableReferences
    extends BaseReferences<_$AppDatabase, $QuotaWindowsTable, QuotaWindow> {
  $$QuotaWindowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsageChecksTable _checkIdTable(_$AppDatabase db) =>
      db.usageChecks.createAlias('quota_windows__check_id__usage_checks__id');

  $$UsageChecksTableProcessedTableManager get checkId {
    final $_column = $_itemColumn<String>('check_id')!;

    final manager = $$UsageChecksTableTableManager(
      $_db,
      $_db.usageChecks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_checkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuotaWindowsTableFilterComposer
    extends Composer<_$AppDatabase, $QuotaWindowsTable> {
  $$QuotaWindowsTableFilterComposer({
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

  ColumnFilters<String> get limitId => $composableBuilder(
    column: $table.limitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get limitName => $composableBuilder(
    column: $table.limitName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get windowType => $composableBuilder(
    column: $table.windowType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get usedPercent => $composableBuilder(
    column: $table.usedPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get windowDurationMinutes => $composableBuilder(
    column: $table.windowDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resetsAt => $composableBuilder(
    column: $table.resetsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reachedType => $composableBuilder(
    column: $table.reachedType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnFilters(column),
  );

  $$UsageChecksTableFilterComposer get checkId {
    final $$UsageChecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkId,
      referencedTable: $db.usageChecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageChecksTableFilterComposer(
            $db: $db,
            $table: $db.usageChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuotaWindowsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuotaWindowsTable> {
  $$QuotaWindowsTableOrderingComposer({
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

  ColumnOrderings<String> get limitId => $composableBuilder(
    column: $table.limitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get limitName => $composableBuilder(
    column: $table.limitName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get windowType => $composableBuilder(
    column: $table.windowType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get usedPercent => $composableBuilder(
    column: $table.usedPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get windowDurationMinutes => $composableBuilder(
    column: $table.windowDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resetsAt => $composableBuilder(
    column: $table.resetsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reachedType => $composableBuilder(
    column: $table.reachedType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsageChecksTableOrderingComposer get checkId {
    final $$UsageChecksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkId,
      referencedTable: $db.usageChecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageChecksTableOrderingComposer(
            $db: $db,
            $table: $db.usageChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuotaWindowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuotaWindowsTable> {
  $$QuotaWindowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get limitId =>
      $composableBuilder(column: $table.limitId, builder: (column) => column);

  GeneratedColumn<String> get limitName =>
      $composableBuilder(column: $table.limitName, builder: (column) => column);

  GeneratedColumn<String> get windowType => $composableBuilder(
    column: $table.windowType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get usedPercent => $composableBuilder(
    column: $table.usedPercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get windowDurationMinutes => $composableBuilder(
    column: $table.windowDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get resetsAt =>
      $composableBuilder(column: $table.resetsAt, builder: (column) => column);

  GeneratedColumn<String> get reachedType => $composableBuilder(
    column: $table.reachedType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planType =>
      $composableBuilder(column: $table.planType, builder: (column) => column);

  $$UsageChecksTableAnnotationComposer get checkId {
    final $$UsageChecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkId,
      referencedTable: $db.usageChecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageChecksTableAnnotationComposer(
            $db: $db,
            $table: $db.usageChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuotaWindowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuotaWindowsTable,
          QuotaWindow,
          $$QuotaWindowsTableFilterComposer,
          $$QuotaWindowsTableOrderingComposer,
          $$QuotaWindowsTableAnnotationComposer,
          $$QuotaWindowsTableCreateCompanionBuilder,
          $$QuotaWindowsTableUpdateCompanionBuilder,
          (QuotaWindow, $$QuotaWindowsTableReferences),
          QuotaWindow,
          PrefetchHooks Function({bool checkId})
        > {
  $$QuotaWindowsTableTableManager(_$AppDatabase db, $QuotaWindowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuotaWindowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuotaWindowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuotaWindowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> checkId = const Value.absent(),
                Value<String> limitId = const Value.absent(),
                Value<String?> limitName = const Value.absent(),
                Value<String> windowType = const Value.absent(),
                Value<double?> usedPercent = const Value.absent(),
                Value<int?> windowDurationMinutes = const Value.absent(),
                Value<DateTime?> resetsAt = const Value.absent(),
                Value<String?> reachedType = const Value.absent(),
                Value<String?> planType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuotaWindowsCompanion(
                id: id,
                checkId: checkId,
                limitId: limitId,
                limitName: limitName,
                windowType: windowType,
                usedPercent: usedPercent,
                windowDurationMinutes: windowDurationMinutes,
                resetsAt: resetsAt,
                reachedType: reachedType,
                planType: planType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String checkId,
                required String limitId,
                Value<String?> limitName = const Value.absent(),
                required String windowType,
                Value<double?> usedPercent = const Value.absent(),
                Value<int?> windowDurationMinutes = const Value.absent(),
                Value<DateTime?> resetsAt = const Value.absent(),
                Value<String?> reachedType = const Value.absent(),
                Value<String?> planType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuotaWindowsCompanion.insert(
                id: id,
                checkId: checkId,
                limitId: limitId,
                limitName: limitName,
                windowType: windowType,
                usedPercent: usedPercent,
                windowDurationMinutes: windowDurationMinutes,
                resetsAt: resetsAt,
                reachedType: reachedType,
                planType: planType,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuotaWindowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({checkId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (checkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.checkId,
                                referencedTable: $$QuotaWindowsTableReferences
                                    ._checkIdTable(db),
                                referencedColumn: $$QuotaWindowsTableReferences
                                    ._checkIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuotaWindowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuotaWindowsTable,
      QuotaWindow,
      $$QuotaWindowsTableFilterComposer,
      $$QuotaWindowsTableOrderingComposer,
      $$QuotaWindowsTableAnnotationComposer,
      $$QuotaWindowsTableCreateCompanionBuilder,
      $$QuotaWindowsTableUpdateCompanionBuilder,
      (QuotaWindow, $$QuotaWindowsTableReferences),
      QuotaWindow,
      PrefetchHooks Function({bool checkId})
    >;
typedef $$ResetCreditSnapshotsTableCreateCompanionBuilder =
    ResetCreditSnapshotsCompanion Function({
      required String checkId,
      Value<int> availableCount,
      Value<DateTime?> nextExpiresAt,
      Value<int> rowid,
    });
typedef $$ResetCreditSnapshotsTableUpdateCompanionBuilder =
    ResetCreditSnapshotsCompanion Function({
      Value<String> checkId,
      Value<int> availableCount,
      Value<DateTime?> nextExpiresAt,
      Value<int> rowid,
    });

final class $$ResetCreditSnapshotsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ResetCreditSnapshotsTable,
          ResetCreditSnapshot
        > {
  $$ResetCreditSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsageChecksTable _checkIdTable(_$AppDatabase db) => db.usageChecks
      .createAlias('reset_credit_snapshots__check_id__usage_checks__id');

  $$UsageChecksTableProcessedTableManager get checkId {
    final $_column = $_itemColumn<String>('check_id')!;

    final manager = $$UsageChecksTableTableManager(
      $_db,
      $_db.usageChecks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_checkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ResetCreditSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $ResetCreditSnapshotsTable> {
  $$ResetCreditSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get availableCount => $composableBuilder(
    column: $table.availableCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextExpiresAt => $composableBuilder(
    column: $table.nextExpiresAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsageChecksTableFilterComposer get checkId {
    final $$UsageChecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkId,
      referencedTable: $db.usageChecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageChecksTableFilterComposer(
            $db: $db,
            $table: $db.usageChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResetCreditSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $ResetCreditSnapshotsTable> {
  $$ResetCreditSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get availableCount => $composableBuilder(
    column: $table.availableCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextExpiresAt => $composableBuilder(
    column: $table.nextExpiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsageChecksTableOrderingComposer get checkId {
    final $$UsageChecksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkId,
      referencedTable: $db.usageChecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageChecksTableOrderingComposer(
            $db: $db,
            $table: $db.usageChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResetCreditSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResetCreditSnapshotsTable> {
  $$ResetCreditSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get availableCount => $composableBuilder(
    column: $table.availableCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextExpiresAt => $composableBuilder(
    column: $table.nextExpiresAt,
    builder: (column) => column,
  );

  $$UsageChecksTableAnnotationComposer get checkId {
    final $$UsageChecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkId,
      referencedTable: $db.usageChecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageChecksTableAnnotationComposer(
            $db: $db,
            $table: $db.usageChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResetCreditSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ResetCreditSnapshotsTable,
          ResetCreditSnapshot,
          $$ResetCreditSnapshotsTableFilterComposer,
          $$ResetCreditSnapshotsTableOrderingComposer,
          $$ResetCreditSnapshotsTableAnnotationComposer,
          $$ResetCreditSnapshotsTableCreateCompanionBuilder,
          $$ResetCreditSnapshotsTableUpdateCompanionBuilder,
          (ResetCreditSnapshot, $$ResetCreditSnapshotsTableReferences),
          ResetCreditSnapshot,
          PrefetchHooks Function({bool checkId})
        > {
  $$ResetCreditSnapshotsTableTableManager(
    _$AppDatabase db,
    $ResetCreditSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResetCreditSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResetCreditSnapshotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ResetCreditSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> checkId = const Value.absent(),
                Value<int> availableCount = const Value.absent(),
                Value<DateTime?> nextExpiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResetCreditSnapshotsCompanion(
                checkId: checkId,
                availableCount: availableCount,
                nextExpiresAt: nextExpiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String checkId,
                Value<int> availableCount = const Value.absent(),
                Value<DateTime?> nextExpiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResetCreditSnapshotsCompanion.insert(
                checkId: checkId,
                availableCount: availableCount,
                nextExpiresAt: nextExpiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ResetCreditSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({checkId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (checkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.checkId,
                                referencedTable:
                                    $$ResetCreditSnapshotsTableReferences
                                        ._checkIdTable(db),
                                referencedColumn:
                                    $$ResetCreditSnapshotsTableReferences
                                        ._checkIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ResetCreditSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ResetCreditSnapshotsTable,
      ResetCreditSnapshot,
      $$ResetCreditSnapshotsTableFilterComposer,
      $$ResetCreditSnapshotsTableOrderingComposer,
      $$ResetCreditSnapshotsTableAnnotationComposer,
      $$ResetCreditSnapshotsTableCreateCompanionBuilder,
      $$ResetCreditSnapshotsTableUpdateCompanionBuilder,
      (ResetCreditSnapshot, $$ResetCreditSnapshotsTableReferences),
      ResetCreditSnapshot,
      PrefetchHooks Function({bool checkId})
    >;
typedef $$DailyUsageBucketsTableCreateCompanionBuilder =
    DailyUsageBucketsCompanion Function({
      required String id,
      required String checkId,
      required String profileId,
      required DateTime day,
      Value<int> tokens,
      Value<int?> activeMinutes,
      Value<int?> messageCount,
      required String source,
      Value<int> rowid,
    });
typedef $$DailyUsageBucketsTableUpdateCompanionBuilder =
    DailyUsageBucketsCompanion Function({
      Value<String> id,
      Value<String> checkId,
      Value<String> profileId,
      Value<DateTime> day,
      Value<int> tokens,
      Value<int?> activeMinutes,
      Value<int?> messageCount,
      Value<String> source,
      Value<int> rowid,
    });

final class $$DailyUsageBucketsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DailyUsageBucketsTable,
          DailyUsageBucket
        > {
  $$DailyUsageBucketsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsageChecksTable _checkIdTable(_$AppDatabase db) => db.usageChecks
      .createAlias('daily_usage_buckets__check_id__usage_checks__id');

  $$UsageChecksTableProcessedTableManager get checkId {
    final $_column = $_itemColumn<String>('check_id')!;

    final manager = $$UsageChecksTableTableManager(
      $_db,
      $_db.usageChecks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_checkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CliProfilesTable _profileIdTable(_$AppDatabase db) => db.cliProfiles
      .createAlias('daily_usage_buckets__profile_id__cli_profiles__id');

  $$CliProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$CliProfilesTableTableManager(
      $_db,
      $_db.cliProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DailyUsageBucketsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyUsageBucketsTable> {
  $$DailyUsageBucketsTableFilterComposer({
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

  ColumnFilters<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tokens => $composableBuilder(
    column: $table.tokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeMinutes => $composableBuilder(
    column: $table.activeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get messageCount => $composableBuilder(
    column: $table.messageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  $$UsageChecksTableFilterComposer get checkId {
    final $$UsageChecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkId,
      referencedTable: $db.usageChecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageChecksTableFilterComposer(
            $db: $db,
            $table: $db.usageChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CliProfilesTableFilterComposer get profileId {
    final $$CliProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.cliProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CliProfilesTableFilterComposer(
            $db: $db,
            $table: $db.cliProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyUsageBucketsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyUsageBucketsTable> {
  $$DailyUsageBucketsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tokens => $composableBuilder(
    column: $table.tokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeMinutes => $composableBuilder(
    column: $table.activeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get messageCount => $composableBuilder(
    column: $table.messageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsageChecksTableOrderingComposer get checkId {
    final $$UsageChecksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkId,
      referencedTable: $db.usageChecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageChecksTableOrderingComposer(
            $db: $db,
            $table: $db.usageChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CliProfilesTableOrderingComposer get profileId {
    final $$CliProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.cliProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CliProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.cliProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyUsageBucketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyUsageBucketsTable> {
  $$DailyUsageBucketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get tokens =>
      $composableBuilder(column: $table.tokens, builder: (column) => column);

  GeneratedColumn<int> get activeMinutes => $composableBuilder(
    column: $table.activeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get messageCount => $composableBuilder(
    column: $table.messageCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  $$UsageChecksTableAnnotationComposer get checkId {
    final $$UsageChecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkId,
      referencedTable: $db.usageChecks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageChecksTableAnnotationComposer(
            $db: $db,
            $table: $db.usageChecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CliProfilesTableAnnotationComposer get profileId {
    final $$CliProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.cliProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CliProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.cliProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyUsageBucketsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyUsageBucketsTable,
          DailyUsageBucket,
          $$DailyUsageBucketsTableFilterComposer,
          $$DailyUsageBucketsTableOrderingComposer,
          $$DailyUsageBucketsTableAnnotationComposer,
          $$DailyUsageBucketsTableCreateCompanionBuilder,
          $$DailyUsageBucketsTableUpdateCompanionBuilder,
          (DailyUsageBucket, $$DailyUsageBucketsTableReferences),
          DailyUsageBucket,
          PrefetchHooks Function({bool checkId, bool profileId})
        > {
  $$DailyUsageBucketsTableTableManager(
    _$AppDatabase db,
    $DailyUsageBucketsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyUsageBucketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyUsageBucketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyUsageBucketsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> checkId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<DateTime> day = const Value.absent(),
                Value<int> tokens = const Value.absent(),
                Value<int?> activeMinutes = const Value.absent(),
                Value<int?> messageCount = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyUsageBucketsCompanion(
                id: id,
                checkId: checkId,
                profileId: profileId,
                day: day,
                tokens: tokens,
                activeMinutes: activeMinutes,
                messageCount: messageCount,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String checkId,
                required String profileId,
                required DateTime day,
                Value<int> tokens = const Value.absent(),
                Value<int?> activeMinutes = const Value.absent(),
                Value<int?> messageCount = const Value.absent(),
                required String source,
                Value<int> rowid = const Value.absent(),
              }) => DailyUsageBucketsCompanion.insert(
                id: id,
                checkId: checkId,
                profileId: profileId,
                day: day,
                tokens: tokens,
                activeMinutes: activeMinutes,
                messageCount: messageCount,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyUsageBucketsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({checkId = false, profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (checkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.checkId,
                                referencedTable:
                                    $$DailyUsageBucketsTableReferences
                                        ._checkIdTable(db),
                                referencedColumn:
                                    $$DailyUsageBucketsTableReferences
                                        ._checkIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable:
                                    $$DailyUsageBucketsTableReferences
                                        ._profileIdTable(db),
                                referencedColumn:
                                    $$DailyUsageBucketsTableReferences
                                        ._profileIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DailyUsageBucketsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyUsageBucketsTable,
      DailyUsageBucket,
      $$DailyUsageBucketsTableFilterComposer,
      $$DailyUsageBucketsTableOrderingComposer,
      $$DailyUsageBucketsTableAnnotationComposer,
      $$DailyUsageBucketsTableCreateCompanionBuilder,
      $$DailyUsageBucketsTableUpdateCompanionBuilder,
      (DailyUsageBucket, $$DailyUsageBucketsTableReferences),
      DailyUsageBucket,
      PrefetchHooks Function({bool checkId, bool profileId})
    >;
typedef $$CommandLogsTableCreateCompanionBuilder =
    CommandLogsCompanion Function({
      required String id,
      Value<String?> profileId,
      required String command,
      required String summary,
      Value<String> output,
      required String status,
      Value<int?> exitCode,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$CommandLogsTableUpdateCompanionBuilder =
    CommandLogsCompanion Function({
      Value<String> id,
      Value<String?> profileId,
      Value<String> command,
      Value<String> summary,
      Value<String> output,
      Value<String> status,
      Value<int?> exitCode,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

class $$CommandLogsTableFilterComposer
    extends Composer<_$AppDatabase, $CommandLogsTable> {
  $$CommandLogsTableFilterComposer({
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

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get command => $composableBuilder(
    column: $table.command,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get output => $composableBuilder(
    column: $table.output,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exitCode => $composableBuilder(
    column: $table.exitCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CommandLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $CommandLogsTable> {
  $$CommandLogsTableOrderingComposer({
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

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get command => $composableBuilder(
    column: $table.command,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get output => $composableBuilder(
    column: $table.output,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exitCode => $composableBuilder(
    column: $table.exitCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CommandLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CommandLogsTable> {
  $$CommandLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get command =>
      $composableBuilder(column: $table.command, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get output =>
      $composableBuilder(column: $table.output, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get exitCode =>
      $composableBuilder(column: $table.exitCode, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$CommandLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CommandLogsTable,
          CommandLog,
          $$CommandLogsTableFilterComposer,
          $$CommandLogsTableOrderingComposer,
          $$CommandLogsTableAnnotationComposer,
          $$CommandLogsTableCreateCompanionBuilder,
          $$CommandLogsTableUpdateCompanionBuilder,
          (
            CommandLog,
            BaseReferences<_$AppDatabase, $CommandLogsTable, CommandLog>,
          ),
          CommandLog,
          PrefetchHooks Function()
        > {
  $$CommandLogsTableTableManager(_$AppDatabase db, $CommandLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommandLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommandLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommandLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> profileId = const Value.absent(),
                Value<String> command = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> output = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> exitCode = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CommandLogsCompanion(
                id: id,
                profileId: profileId,
                command: command,
                summary: summary,
                output: output,
                status: status,
                exitCode: exitCode,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> profileId = const Value.absent(),
                required String command,
                required String summary,
                Value<String> output = const Value.absent(),
                required String status,
                Value<int?> exitCode = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CommandLogsCompanion.insert(
                id: id,
                profileId: profileId,
                command: command,
                summary: summary,
                output: output,
                status: status,
                exitCode: exitCode,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CommandLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CommandLogsTable,
      CommandLog,
      $$CommandLogsTableFilterComposer,
      $$CommandLogsTableOrderingComposer,
      $$CommandLogsTableAnnotationComposer,
      $$CommandLogsTableCreateCompanionBuilder,
      $$CommandLogsTableUpdateCompanionBuilder,
      (
        CommandLog,
        BaseReferences<_$AppDatabase, $CommandLogsTable, CommandLog>,
      ),
      CommandLog,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String settingKey,
      required String settingValue,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> settingKey,
      Value<String> settingValue,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> settingKey = const Value.absent(),
                Value<String> settingValue = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                settingKey: settingKey,
                settingValue: settingValue,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String settingKey,
                required String settingValue,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                settingKey: settingKey,
                settingValue: settingValue,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CliProfilesTableTableManager get cliProfiles =>
      $$CliProfilesTableTableManager(_db, _db.cliProfiles);
  $$ProfileMetadatasTableTableManager get profileMetadatas =>
      $$ProfileMetadatasTableTableManager(_db, _db.profileMetadatas);
  $$CostSharesTableTableManager get costShares =>
      $$CostSharesTableTableManager(_db, _db.costShares);
  $$UsageChecksTableTableManager get usageChecks =>
      $$UsageChecksTableTableManager(_db, _db.usageChecks);
  $$QuotaWindowsTableTableManager get quotaWindows =>
      $$QuotaWindowsTableTableManager(_db, _db.quotaWindows);
  $$ResetCreditSnapshotsTableTableManager get resetCreditSnapshots =>
      $$ResetCreditSnapshotsTableTableManager(_db, _db.resetCreditSnapshots);
  $$DailyUsageBucketsTableTableManager get dailyUsageBuckets =>
      $$DailyUsageBucketsTableTableManager(_db, _db.dailyUsageBuckets);
  $$CommandLogsTableTableManager get commandLogs =>
      $$CommandLogsTableTableManager(_db, _db.commandLogs);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
