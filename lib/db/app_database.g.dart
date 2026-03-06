// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SubscriptionsTableTable extends SubscriptionsTable
    with TableInfo<$SubscriptionsTableTable, SubscriptionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subscriptionIdMeta = const VerificationMeta(
    'subscriptionId',
  );
  @override
  late final GeneratedColumn<String> subscriptionId = GeneratedColumn<String>(
    'subscription_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billingCycleMeta = const VerificationMeta(
    'billingCycle',
  );
  @override
  late final GeneratedColumn<String> billingCycle = GeneratedColumn<String>(
    'billing_cycle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextBillingDateMeta = const VerificationMeta(
    'nextBillingDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextBillingDate =
      GeneratedColumn<DateTime>(
        'next_billing_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
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
  static const VerificationMeta _freeTrialMeta = const VerificationMeta(
    'freeTrial',
  );
  @override
  late final GeneratedColumn<bool> freeTrial = GeneratedColumn<bool>(
    'free_trial',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("free_trial" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderDaysMeta = const VerificationMeta(
    'reminderDays',
  );
  @override
  late final GeneratedColumn<int> reminderDays = GeneratedColumn<int>(
    'reminder_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    id,
    name,
    subscriptionId,
    price,
    currency,
    billingCycle,
    category,
    startDate,
    nextBillingDate,
    autoRenew,
    freeTrial,
    reminderDays,
    notes,
    createdAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubscriptionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('subscription_id')) {
      context.handle(
        _subscriptionIdMeta,
        subscriptionId.isAcceptableOrUnknown(
          data['subscription_id']!,
          _subscriptionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subscriptionIdMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('billing_cycle')) {
      context.handle(
        _billingCycleMeta,
        billingCycle.isAcceptableOrUnknown(
          data['billing_cycle']!,
          _billingCycleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_billingCycleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('next_billing_date')) {
      context.handle(
        _nextBillingDateMeta,
        nextBillingDate.isAcceptableOrUnknown(
          data['next_billing_date']!,
          _nextBillingDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextBillingDateMeta);
    }
    if (data.containsKey('auto_renew')) {
      context.handle(
        _autoRenewMeta,
        autoRenew.isAcceptableOrUnknown(data['auto_renew']!, _autoRenewMeta),
      );
    }
    if (data.containsKey('free_trial')) {
      context.handle(
        _freeTrialMeta,
        freeTrial.isAcceptableOrUnknown(data['free_trial']!, _freeTrialMeta),
      );
    }
    if (data.containsKey('reminder_days')) {
      context.handle(
        _reminderDaysMeta,
        reminderDays.isAcceptableOrUnknown(
          data['reminder_days']!,
          _reminderDaysMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubscriptionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionsTableData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      subscriptionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_id'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      billingCycle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}billing_cycle'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      nextBillingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_billing_date'],
      )!,
      autoRenew: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_renew'],
      )!,
      freeTrial: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}free_trial'],
      )!,
      reminderDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_days'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $SubscriptionsTableTable createAlias(String alias) {
    return $SubscriptionsTableTable(attachedDatabase, alias);
  }
}

class SubscriptionsTableData extends DataClass
    implements Insertable<SubscriptionsTableData> {
  final String? userId;
  final int id;
  final String name;
  final String subscriptionId;
  final double price;
  final String currency;
  final String billingCycle;
  final String category;
  final DateTime startDate;
  final DateTime nextBillingDate;
  final bool autoRenew;
  final bool freeTrial;
  final int reminderDays;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  const SubscriptionsTableData({
    this.userId,
    required this.id,
    required this.name,
    required this.subscriptionId,
    required this.price,
    required this.currency,
    required this.billingCycle,
    required this.category,
    required this.startDate,
    required this.nextBillingDate,
    required this.autoRenew,
    required this.freeTrial,
    required this.reminderDays,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['subscription_id'] = Variable<String>(subscriptionId);
    map['price'] = Variable<double>(price);
    map['currency'] = Variable<String>(currency);
    map['billing_cycle'] = Variable<String>(billingCycle);
    map['category'] = Variable<String>(category);
    map['start_date'] = Variable<DateTime>(startDate);
    map['next_billing_date'] = Variable<DateTime>(nextBillingDate);
    map['auto_renew'] = Variable<bool>(autoRenew);
    map['free_trial'] = Variable<bool>(freeTrial);
    map['reminder_days'] = Variable<int>(reminderDays);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  SubscriptionsTableCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsTableCompanion(
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      id: Value(id),
      name: Value(name),
      subscriptionId: Value(subscriptionId),
      price: Value(price),
      currency: Value(currency),
      billingCycle: Value(billingCycle),
      category: Value(category),
      startDate: Value(startDate),
      nextBillingDate: Value(nextBillingDate),
      autoRenew: Value(autoRenew),
      freeTrial: Value(freeTrial),
      reminderDays: Value(reminderDays),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory SubscriptionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionsTableData(
      userId: serializer.fromJson<String?>(json['userId']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      subscriptionId: serializer.fromJson<String>(json['subscriptionId']),
      price: serializer.fromJson<double>(json['price']),
      currency: serializer.fromJson<String>(json['currency']),
      billingCycle: serializer.fromJson<String>(json['billingCycle']),
      category: serializer.fromJson<String>(json['category']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      nextBillingDate: serializer.fromJson<DateTime>(json['nextBillingDate']),
      autoRenew: serializer.fromJson<bool>(json['autoRenew']),
      freeTrial: serializer.fromJson<bool>(json['freeTrial']),
      reminderDays: serializer.fromJson<int>(json['reminderDays']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String?>(userId),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'subscriptionId': serializer.toJson<String>(subscriptionId),
      'price': serializer.toJson<double>(price),
      'currency': serializer.toJson<String>(currency),
      'billingCycle': serializer.toJson<String>(billingCycle),
      'category': serializer.toJson<String>(category),
      'startDate': serializer.toJson<DateTime>(startDate),
      'nextBillingDate': serializer.toJson<DateTime>(nextBillingDate),
      'autoRenew': serializer.toJson<bool>(autoRenew),
      'freeTrial': serializer.toJson<bool>(freeTrial),
      'reminderDays': serializer.toJson<int>(reminderDays),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  SubscriptionsTableData copyWith({
    Value<String?> userId = const Value.absent(),
    int? id,
    String? name,
    String? subscriptionId,
    double? price,
    String? currency,
    String? billingCycle,
    String? category,
    DateTime? startDate,
    DateTime? nextBillingDate,
    bool? autoRenew,
    bool? freeTrial,
    int? reminderDays,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => SubscriptionsTableData(
    userId: userId.present ? userId.value : this.userId,
    id: id ?? this.id,
    name: name ?? this.name,
    subscriptionId: subscriptionId ?? this.subscriptionId,
    price: price ?? this.price,
    currency: currency ?? this.currency,
    billingCycle: billingCycle ?? this.billingCycle,
    category: category ?? this.category,
    startDate: startDate ?? this.startDate,
    nextBillingDate: nextBillingDate ?? this.nextBillingDate,
    autoRenew: autoRenew ?? this.autoRenew,
    freeTrial: freeTrial ?? this.freeTrial,
    reminderDays: reminderDays ?? this.reminderDays,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  SubscriptionsTableData copyWithCompanion(SubscriptionsTableCompanion data) {
    return SubscriptionsTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      subscriptionId: data.subscriptionId.present
          ? data.subscriptionId.value
          : this.subscriptionId,
      price: data.price.present ? data.price.value : this.price,
      currency: data.currency.present ? data.currency.value : this.currency,
      billingCycle: data.billingCycle.present
          ? data.billingCycle.value
          : this.billingCycle,
      category: data.category.present ? data.category.value : this.category,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      nextBillingDate: data.nextBillingDate.present
          ? data.nextBillingDate.value
          : this.nextBillingDate,
      autoRenew: data.autoRenew.present ? data.autoRenew.value : this.autoRenew,
      freeTrial: data.freeTrial.present ? data.freeTrial.value : this.freeTrial,
      reminderDays: data.reminderDays.present
          ? data.reminderDays.value
          : this.reminderDays,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsTableData(')
          ..write('userId: $userId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('category: $category, ')
          ..write('startDate: $startDate, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('autoRenew: $autoRenew, ')
          ..write('freeTrial: $freeTrial, ')
          ..write('reminderDays: $reminderDays, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    id,
    name,
    subscriptionId,
    price,
    currency,
    billingCycle,
    category,
    startDate,
    nextBillingDate,
    autoRenew,
    freeTrial,
    reminderDays,
    notes,
    createdAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionsTableData &&
          other.userId == this.userId &&
          other.id == this.id &&
          other.name == this.name &&
          other.subscriptionId == this.subscriptionId &&
          other.price == this.price &&
          other.currency == this.currency &&
          other.billingCycle == this.billingCycle &&
          other.category == this.category &&
          other.startDate == this.startDate &&
          other.nextBillingDate == this.nextBillingDate &&
          other.autoRenew == this.autoRenew &&
          other.freeTrial == this.freeTrial &&
          other.reminderDays == this.reminderDays &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class SubscriptionsTableCompanion
    extends UpdateCompanion<SubscriptionsTableData> {
  final Value<String?> userId;
  final Value<int> id;
  final Value<String> name;
  final Value<String> subscriptionId;
  final Value<double> price;
  final Value<String> currency;
  final Value<String> billingCycle;
  final Value<String> category;
  final Value<DateTime> startDate;
  final Value<DateTime> nextBillingDate;
  final Value<bool> autoRenew;
  final Value<bool> freeTrial;
  final Value<int> reminderDays;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  const SubscriptionsTableCompanion({
    this.userId = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.subscriptionId = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.billingCycle = const Value.absent(),
    this.category = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextBillingDate = const Value.absent(),
    this.autoRenew = const Value.absent(),
    this.freeTrial = const Value.absent(),
    this.reminderDays = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  SubscriptionsTableCompanion.insert({
    this.userId = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    required String subscriptionId,
    required double price,
    required String currency,
    required String billingCycle,
    required String category,
    required DateTime startDate,
    required DateTime nextBillingDate,
    this.autoRenew = const Value.absent(),
    this.freeTrial = const Value.absent(),
    this.reminderDays = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
  }) : name = Value(name),
       subscriptionId = Value(subscriptionId),
       price = Value(price),
       currency = Value(currency),
       billingCycle = Value(billingCycle),
       category = Value(category),
       startDate = Value(startDate),
       nextBillingDate = Value(nextBillingDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SubscriptionsTableData> custom({
    Expression<String>? userId,
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? subscriptionId,
    Expression<double>? price,
    Expression<String>? currency,
    Expression<String>? billingCycle,
    Expression<String>? category,
    Expression<DateTime>? startDate,
    Expression<DateTime>? nextBillingDate,
    Expression<bool>? autoRenew,
    Expression<bool>? freeTrial,
    Expression<int>? reminderDays,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (subscriptionId != null) 'subscription_id': subscriptionId,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (billingCycle != null) 'billing_cycle': billingCycle,
      if (category != null) 'category': category,
      if (startDate != null) 'start_date': startDate,
      if (nextBillingDate != null) 'next_billing_date': nextBillingDate,
      if (autoRenew != null) 'auto_renew': autoRenew,
      if (freeTrial != null) 'free_trial': freeTrial,
      if (reminderDays != null) 'reminder_days': reminderDays,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  SubscriptionsTableCompanion copyWith({
    Value<String?>? userId,
    Value<int>? id,
    Value<String>? name,
    Value<String>? subscriptionId,
    Value<double>? price,
    Value<String>? currency,
    Value<String>? billingCycle,
    Value<String>? category,
    Value<DateTime>? startDate,
    Value<DateTime>? nextBillingDate,
    Value<bool>? autoRenew,
    Value<bool>? freeTrial,
    Value<int>? reminderDays,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
  }) {
    return SubscriptionsTableCompanion(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      name: name ?? this.name,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      autoRenew: autoRenew ?? this.autoRenew,
      freeTrial: freeTrial ?? this.freeTrial,
      reminderDays: reminderDays ?? this.reminderDays,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (subscriptionId.present) {
      map['subscription_id'] = Variable<String>(subscriptionId.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (billingCycle.present) {
      map['billing_cycle'] = Variable<String>(billingCycle.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (nextBillingDate.present) {
      map['next_billing_date'] = Variable<DateTime>(nextBillingDate.value);
    }
    if (autoRenew.present) {
      map['auto_renew'] = Variable<bool>(autoRenew.value);
    }
    if (freeTrial.present) {
      map['free_trial'] = Variable<bool>(freeTrial.value);
    }
    if (reminderDays.present) {
      map['reminder_days'] = Variable<int>(reminderDays.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('category: $category, ')
          ..write('startDate: $startDate, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('autoRenew: $autoRenew, ')
          ..write('freeTrial: $freeTrial, ')
          ..write('reminderDays: $reminderDays, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, UsersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPremiumUserMeta = const VerificationMeta(
    'isPremiumUser',
  );
  @override
  late final GeneratedColumn<bool> isPremiumUser = GeneratedColumn<bool>(
    'is_premium_user',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_premium_user" IN (0, 1))',
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
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    isPremiumUser,
    createdAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('is_premium_user')) {
      context.handle(
        _isPremiumUserMeta,
        isPremiumUser.isAcceptableOrUnknown(
          data['is_premium_user']!,
          _isPremiumUserMeta,
        ),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      isPremiumUser: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_premium_user'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UsersTableData extends DataClass implements Insertable<UsersTableData> {
  final String id;
  final String name;
  final String email;
  final bool isPremiumUser;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  const UsersTableData({
    required this.id,
    required this.name,
    required this.email,
    required this.isPremiumUser,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['is_premium_user'] = Variable<bool>(isPremiumUser);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      isPremiumUser: Value(isPremiumUser),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory UsersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      isPremiumUser: serializer.fromJson<bool>(json['isPremiumUser']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'isPremiumUser': serializer.toJson<bool>(isPremiumUser),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  UsersTableData copyWith({
    String? id,
    String? name,
    String? email,
    bool? isPremiumUser,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => UsersTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    isPremiumUser: isPremiumUser ?? this.isPremiumUser,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  UsersTableData copyWithCompanion(UsersTableCompanion data) {
    return UsersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      isPremiumUser: data.isPremiumUser.present
          ? data.isPremiumUser.value
          : this.isPremiumUser,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('isPremiumUser: $isPremiumUser, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    isPremiumUser,
    createdAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.isPremiumUser == this.isPremiumUser &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class UsersTableCompanion extends UpdateCompanion<UsersTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<bool> isPremiumUser;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.isPremiumUser = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersTableCompanion.insert({
    required String id,
    required String name,
    required String email,
    this.isPremiumUser = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       email = Value(email),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UsersTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<bool>? isPremiumUser,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (isPremiumUser != null) 'is_premium_user': isPremiumUser,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? email,
    Value<bool>? isPremiumUser,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return UsersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isPremiumUser: isPremiumUser ?? this.isPremiumUser,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (isPremiumUser.present) {
      map['is_premium_user'] = Variable<bool>(isPremiumUser.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('isPremiumUser: $isPremiumUser, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubscriptionsTableTable subscriptionsTable =
      $SubscriptionsTableTable(this);
  late final $UsersTableTable usersTable = $UsersTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    subscriptionsTable,
    usersTable,
  ];
}

typedef $$SubscriptionsTableTableCreateCompanionBuilder =
    SubscriptionsTableCompanion Function({
      Value<String?> userId,
      Value<int> id,
      required String name,
      required String subscriptionId,
      required double price,
      required String currency,
      required String billingCycle,
      required String category,
      required DateTime startDate,
      required DateTime nextBillingDate,
      Value<bool> autoRenew,
      Value<bool> freeTrial,
      Value<int> reminderDays,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isSynced,
    });
typedef $$SubscriptionsTableTableUpdateCompanionBuilder =
    SubscriptionsTableCompanion Function({
      Value<String?> userId,
      Value<int> id,
      Value<String> name,
      Value<String> subscriptionId,
      Value<double> price,
      Value<String> currency,
      Value<String> billingCycle,
      Value<String> category,
      Value<DateTime> startDate,
      Value<DateTime> nextBillingDate,
      Value<bool> autoRenew,
      Value<bool> freeTrial,
      Value<int> reminderDays,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
    });

class $$SubscriptionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subscriptionId => $composableBuilder(
    column: $table.subscriptionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoRenew => $composableBuilder(
    column: $table.autoRenew,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get freeTrial => $composableBuilder(
    column: $table.freeTrial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderDays => $composableBuilder(
    column: $table.reminderDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubscriptionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subscriptionId => $composableBuilder(
    column: $table.subscriptionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoRenew => $composableBuilder(
    column: $table.autoRenew,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get freeTrial => $composableBuilder(
    column: $table.freeTrial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderDays => $composableBuilder(
    column: $table.reminderDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubscriptionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get subscriptionId => $composableBuilder(
    column: $table.subscriptionId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoRenew =>
      $composableBuilder(column: $table.autoRenew, builder: (column) => column);

  GeneratedColumn<bool> get freeTrial =>
      $composableBuilder(column: $table.freeTrial, builder: (column) => column);

  GeneratedColumn<int> get reminderDays => $composableBuilder(
    column: $table.reminderDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$SubscriptionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionsTableTable,
          SubscriptionsTableData,
          $$SubscriptionsTableTableFilterComposer,
          $$SubscriptionsTableTableOrderingComposer,
          $$SubscriptionsTableTableAnnotationComposer,
          $$SubscriptionsTableTableCreateCompanionBuilder,
          $$SubscriptionsTableTableUpdateCompanionBuilder,
          (
            SubscriptionsTableData,
            BaseReferences<
              _$AppDatabase,
              $SubscriptionsTableTable,
              SubscriptionsTableData
            >,
          ),
          SubscriptionsTableData,
          PrefetchHooks Function()
        > {
  $$SubscriptionsTableTableTableManager(
    _$AppDatabase db,
    $SubscriptionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String?> userId = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> subscriptionId = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> billingCycle = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> nextBillingDate = const Value.absent(),
                Value<bool> autoRenew = const Value.absent(),
                Value<bool> freeTrial = const Value.absent(),
                Value<int> reminderDays = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => SubscriptionsTableCompanion(
                userId: userId,
                id: id,
                name: name,
                subscriptionId: subscriptionId,
                price: price,
                currency: currency,
                billingCycle: billingCycle,
                category: category,
                startDate: startDate,
                nextBillingDate: nextBillingDate,
                autoRenew: autoRenew,
                freeTrial: freeTrial,
                reminderDays: reminderDays,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<String?> userId = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String name,
                required String subscriptionId,
                required double price,
                required String currency,
                required String billingCycle,
                required String category,
                required DateTime startDate,
                required DateTime nextBillingDate,
                Value<bool> autoRenew = const Value.absent(),
                Value<bool> freeTrial = const Value.absent(),
                Value<int> reminderDays = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
              }) => SubscriptionsTableCompanion.insert(
                userId: userId,
                id: id,
                name: name,
                subscriptionId: subscriptionId,
                price: price,
                currency: currency,
                billingCycle: billingCycle,
                category: category,
                startDate: startDate,
                nextBillingDate: nextBillingDate,
                autoRenew: autoRenew,
                freeTrial: freeTrial,
                reminderDays: reminderDays,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubscriptionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionsTableTable,
      SubscriptionsTableData,
      $$SubscriptionsTableTableFilterComposer,
      $$SubscriptionsTableTableOrderingComposer,
      $$SubscriptionsTableTableAnnotationComposer,
      $$SubscriptionsTableTableCreateCompanionBuilder,
      $$SubscriptionsTableTableUpdateCompanionBuilder,
      (
        SubscriptionsTableData,
        BaseReferences<
          _$AppDatabase,
          $SubscriptionsTableTable,
          SubscriptionsTableData
        >,
      ),
      SubscriptionsTableData,
      PrefetchHooks Function()
    >;
typedef $$UsersTableTableCreateCompanionBuilder =
    UsersTableCompanion Function({
      required String id,
      required String name,
      required String email,
      Value<bool> isPremiumUser,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$UsersTableTableUpdateCompanionBuilder =
    UsersTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> email,
      Value<bool> isPremiumUser,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$UsersTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPremiumUser => $composableBuilder(
    column: $table.isPremiumUser,
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

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPremiumUser => $composableBuilder(
    column: $table.isPremiumUser,
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

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<bool> get isPremiumUser => $composableBuilder(
    column: $table.isPremiumUser,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$UsersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTableTable,
          UsersTableData,
          $$UsersTableTableFilterComposer,
          $$UsersTableTableOrderingComposer,
          $$UsersTableTableAnnotationComposer,
          $$UsersTableTableCreateCompanionBuilder,
          $$UsersTableTableUpdateCompanionBuilder,
          (
            UsersTableData,
            BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData>,
          ),
          UsersTableData,
          PrefetchHooks Function()
        > {
  $$UsersTableTableTableManager(_$AppDatabase db, $UsersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<bool> isPremiumUser = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion(
                id: id,
                name: name,
                email: email,
                isPremiumUser: isPremiumUser,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String email,
                Value<bool> isPremiumUser = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion.insert(
                id: id,
                name: name,
                email: email,
                isPremiumUser: isPremiumUser,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTableTable,
      UsersTableData,
      $$UsersTableTableFilterComposer,
      $$UsersTableTableOrderingComposer,
      $$UsersTableTableAnnotationComposer,
      $$UsersTableTableCreateCompanionBuilder,
      $$UsersTableTableUpdateCompanionBuilder,
      (
        UsersTableData,
        BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData>,
      ),
      UsersTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubscriptionsTableTableTableManager get subscriptionsTable =>
      $$SubscriptionsTableTableTableManager(_db, _db.subscriptionsTable);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db, _db.usersTable);
}
