// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 11, maxTextLength: 11),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  @override
  late final GeneratedColumn<String> salt = GeneratedColumn<String>(
      'salt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nicknameMeta =
      const VerificationMeta('nickname');
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
      'nickname', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _memberLevelMeta =
      const VerificationMeta('memberLevel');
  @override
  late final GeneratedColumn<int> memberLevel = GeneratedColumn<int>(
      'member_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _experienceMeta =
      const VerificationMeta('experience');
  @override
  late final GeneratedColumn<int> experience = GeneratedColumn<int>(
      'experience', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalProfitMeta =
      const VerificationMeta('totalProfit');
  @override
  late final GeneratedColumn<double> totalProfit = GeneratedColumn<double>(
      'total_profit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalTrainingDaysMeta =
      const VerificationMeta('totalTrainingDays');
  @override
  late final GeneratedColumn<int> totalTrainingDays = GeneratedColumn<int>(
      'total_training_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _avgDailyDurationMeta =
      const VerificationMeta('avgDailyDuration');
  @override
  late final GeneratedColumn<double> avgDailyDuration = GeneratedColumn<double>(
      'avg_daily_duration', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _overallWinRateMeta =
      const VerificationMeta('overallWinRate');
  @override
  late final GeneratedColumn<double> overallWinRate = GeneratedColumn<double>(
      'overall_win_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _avgProfitRateMeta =
      const VerificationMeta('avgProfitRate');
  @override
  late final GeneratedColumn<double> avgProfitRate = GeneratedColumn<double>(
      'avg_profit_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _lastLoginAtMeta =
      const VerificationMeta('lastLoginAt');
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
      'last_login_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        phone,
        password,
        salt,
        nickname,
        avatar,
        email,
        memberLevel,
        experience,
        totalProfit,
        totalTrainingDays,
        avgDailyDuration,
        overallWinRate,
        avgProfitRate,
        status,
        lastLoginAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('salt')) {
      context.handle(
          _saltMeta, salt.isAcceptableOrUnknown(data['salt']!, _saltMeta));
    }
    if (data.containsKey('nickname')) {
      context.handle(_nicknameMeta,
          nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta));
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('member_level')) {
      context.handle(
          _memberLevelMeta,
          memberLevel.isAcceptableOrUnknown(
              data['member_level']!, _memberLevelMeta));
    }
    if (data.containsKey('experience')) {
      context.handle(
          _experienceMeta,
          experience.isAcceptableOrUnknown(
              data['experience']!, _experienceMeta));
    }
    if (data.containsKey('total_profit')) {
      context.handle(
          _totalProfitMeta,
          totalProfit.isAcceptableOrUnknown(
              data['total_profit']!, _totalProfitMeta));
    }
    if (data.containsKey('total_training_days')) {
      context.handle(
          _totalTrainingDaysMeta,
          totalTrainingDays.isAcceptableOrUnknown(
              data['total_training_days']!, _totalTrainingDaysMeta));
    }
    if (data.containsKey('avg_daily_duration')) {
      context.handle(
          _avgDailyDurationMeta,
          avgDailyDuration.isAcceptableOrUnknown(
              data['avg_daily_duration']!, _avgDailyDurationMeta));
    }
    if (data.containsKey('overall_win_rate')) {
      context.handle(
          _overallWinRateMeta,
          overallWinRate.isAcceptableOrUnknown(
              data['overall_win_rate']!, _overallWinRateMeta));
    }
    if (data.containsKey('avg_profit_rate')) {
      context.handle(
          _avgProfitRateMeta,
          avgProfitRate.isAcceptableOrUnknown(
              data['avg_profit_rate']!, _avgProfitRateMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
          _lastLoginAtMeta,
          lastLoginAt.isAcceptableOrUnknown(
              data['last_login_at']!, _lastLoginAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password']),
      salt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}salt']),
      nickname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nickname']),
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      memberLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}member_level'])!,
      experience: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}experience'])!,
      totalProfit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_profit'])!,
      totalTrainingDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_training_days'])!,
      avgDailyDuration: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}avg_daily_duration'])!,
      overallWinRate: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}overall_win_rate'])!,
      avgProfitRate: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}avg_profit_rate'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      lastLoginAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_login_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  /// 用户ID
  final int id;

  /// 手机号
  final String phone;

  /// 加密密码
  final String? password;

  /// 密码盐
  final String? salt;

  /// 用户昵称
  final String? nickname;

  /// 头像URL
  final String? avatar;

  /// 邮箱
  final String? email;

  /// 会员等级(1-10)
  final int memberLevel;

  /// 经验值
  final int experience;

  /// 累计盈亏
  final double totalProfit;

  /// 累计训练天数
  final int totalTrainingDays;

  /// 日均训练时长(分钟)
  final double avgDailyDuration;

  /// 总胜率
  final double overallWinRate;

  /// 平均收益率
  final double avgProfitRate;

  /// 状态: active/inactive/banned
  final String status;

  /// 最后登录时间
  final DateTime? lastLoginAt;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const User(
      {required this.id,
      required this.phone,
      this.password,
      this.salt,
      this.nickname,
      this.avatar,
      this.email,
      required this.memberLevel,
      required this.experience,
      required this.totalProfit,
      required this.totalTrainingDays,
      required this.avgDailyDuration,
      required this.overallWinRate,
      required this.avgProfitRate,
      required this.status,
      this.lastLoginAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    if (!nullToAbsent || salt != null) {
      map['salt'] = Variable<String>(salt);
    }
    if (!nullToAbsent || nickname != null) {
      map['nickname'] = Variable<String>(nickname);
    }
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['member_level'] = Variable<int>(memberLevel);
    map['experience'] = Variable<int>(experience);
    map['total_profit'] = Variable<double>(totalProfit);
    map['total_training_days'] = Variable<int>(totalTrainingDays);
    map['avg_daily_duration'] = Variable<double>(avgDailyDuration);
    map['overall_win_rate'] = Variable<double>(overallWinRate);
    map['avg_profit_rate'] = Variable<double>(avgProfitRate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      phone: Value(phone),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      salt: salt == null && nullToAbsent ? const Value.absent() : Value(salt),
      nickname: nickname == null && nullToAbsent
          ? const Value.absent()
          : Value(nickname),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      memberLevel: Value(memberLevel),
      experience: Value(experience),
      totalProfit: Value(totalProfit),
      totalTrainingDays: Value(totalTrainingDays),
      avgDailyDuration: Value(avgDailyDuration),
      overallWinRate: Value(overallWinRate),
      avgProfitRate: Value(avgProfitRate),
      status: Value(status),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      phone: serializer.fromJson<String>(json['phone']),
      password: serializer.fromJson<String?>(json['password']),
      salt: serializer.fromJson<String?>(json['salt']),
      nickname: serializer.fromJson<String?>(json['nickname']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      email: serializer.fromJson<String?>(json['email']),
      memberLevel: serializer.fromJson<int>(json['memberLevel']),
      experience: serializer.fromJson<int>(json['experience']),
      totalProfit: serializer.fromJson<double>(json['totalProfit']),
      totalTrainingDays: serializer.fromJson<int>(json['totalTrainingDays']),
      avgDailyDuration: serializer.fromJson<double>(json['avgDailyDuration']),
      overallWinRate: serializer.fromJson<double>(json['overallWinRate']),
      avgProfitRate: serializer.fromJson<double>(json['avgProfitRate']),
      status: serializer.fromJson<String>(json['status']),
      lastLoginAt: serializer.fromJson<DateTime?>(json['lastLoginAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'phone': serializer.toJson<String>(phone),
      'password': serializer.toJson<String?>(password),
      'salt': serializer.toJson<String?>(salt),
      'nickname': serializer.toJson<String?>(nickname),
      'avatar': serializer.toJson<String?>(avatar),
      'email': serializer.toJson<String?>(email),
      'memberLevel': serializer.toJson<int>(memberLevel),
      'experience': serializer.toJson<int>(experience),
      'totalProfit': serializer.toJson<double>(totalProfit),
      'totalTrainingDays': serializer.toJson<int>(totalTrainingDays),
      'avgDailyDuration': serializer.toJson<double>(avgDailyDuration),
      'overallWinRate': serializer.toJson<double>(overallWinRate),
      'avgProfitRate': serializer.toJson<double>(avgProfitRate),
      'status': serializer.toJson<String>(status),
      'lastLoginAt': serializer.toJson<DateTime?>(lastLoginAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith(
          {int? id,
          String? phone,
          Value<String?> password = const Value.absent(),
          Value<String?> salt = const Value.absent(),
          Value<String?> nickname = const Value.absent(),
          Value<String?> avatar = const Value.absent(),
          Value<String?> email = const Value.absent(),
          int? memberLevel,
          int? experience,
          double? totalProfit,
          int? totalTrainingDays,
          double? avgDailyDuration,
          double? overallWinRate,
          double? avgProfitRate,
          String? status,
          Value<DateTime?> lastLoginAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      User(
        id: id ?? this.id,
        phone: phone ?? this.phone,
        password: password.present ? password.value : this.password,
        salt: salt.present ? salt.value : this.salt,
        nickname: nickname.present ? nickname.value : this.nickname,
        avatar: avatar.present ? avatar.value : this.avatar,
        email: email.present ? email.value : this.email,
        memberLevel: memberLevel ?? this.memberLevel,
        experience: experience ?? this.experience,
        totalProfit: totalProfit ?? this.totalProfit,
        totalTrainingDays: totalTrainingDays ?? this.totalTrainingDays,
        avgDailyDuration: avgDailyDuration ?? this.avgDailyDuration,
        overallWinRate: overallWinRate ?? this.overallWinRate,
        avgProfitRate: avgProfitRate ?? this.avgProfitRate,
        status: status ?? this.status,
        lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      phone: data.phone.present ? data.phone.value : this.phone,
      password: data.password.present ? data.password.value : this.password,
      salt: data.salt.present ? data.salt.value : this.salt,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      email: data.email.present ? data.email.value : this.email,
      memberLevel:
          data.memberLevel.present ? data.memberLevel.value : this.memberLevel,
      experience:
          data.experience.present ? data.experience.value : this.experience,
      totalProfit:
          data.totalProfit.present ? data.totalProfit.value : this.totalProfit,
      totalTrainingDays: data.totalTrainingDays.present
          ? data.totalTrainingDays.value
          : this.totalTrainingDays,
      avgDailyDuration: data.avgDailyDuration.present
          ? data.avgDailyDuration.value
          : this.avgDailyDuration,
      overallWinRate: data.overallWinRate.present
          ? data.overallWinRate.value
          : this.overallWinRate,
      avgProfitRate: data.avgProfitRate.present
          ? data.avgProfitRate.value
          : this.avgProfitRate,
      status: data.status.present ? data.status.value : this.status,
      lastLoginAt:
          data.lastLoginAt.present ? data.lastLoginAt.value : this.lastLoginAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('password: $password, ')
          ..write('salt: $salt, ')
          ..write('nickname: $nickname, ')
          ..write('avatar: $avatar, ')
          ..write('email: $email, ')
          ..write('memberLevel: $memberLevel, ')
          ..write('experience: $experience, ')
          ..write('totalProfit: $totalProfit, ')
          ..write('totalTrainingDays: $totalTrainingDays, ')
          ..write('avgDailyDuration: $avgDailyDuration, ')
          ..write('overallWinRate: $overallWinRate, ')
          ..write('avgProfitRate: $avgProfitRate, ')
          ..write('status: $status, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      phone,
      password,
      salt,
      nickname,
      avatar,
      email,
      memberLevel,
      experience,
      totalProfit,
      totalTrainingDays,
      avgDailyDuration,
      overallWinRate,
      avgProfitRate,
      status,
      lastLoginAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.phone == this.phone &&
          other.password == this.password &&
          other.salt == this.salt &&
          other.nickname == this.nickname &&
          other.avatar == this.avatar &&
          other.email == this.email &&
          other.memberLevel == this.memberLevel &&
          other.experience == this.experience &&
          other.totalProfit == this.totalProfit &&
          other.totalTrainingDays == this.totalTrainingDays &&
          other.avgDailyDuration == this.avgDailyDuration &&
          other.overallWinRate == this.overallWinRate &&
          other.avgProfitRate == this.avgProfitRate &&
          other.status == this.status &&
          other.lastLoginAt == this.lastLoginAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> phone;
  final Value<String?> password;
  final Value<String?> salt;
  final Value<String?> nickname;
  final Value<String?> avatar;
  final Value<String?> email;
  final Value<int> memberLevel;
  final Value<int> experience;
  final Value<double> totalProfit;
  final Value<int> totalTrainingDays;
  final Value<double> avgDailyDuration;
  final Value<double> overallWinRate;
  final Value<double> avgProfitRate;
  final Value<String> status;
  final Value<DateTime?> lastLoginAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.password = const Value.absent(),
    this.salt = const Value.absent(),
    this.nickname = const Value.absent(),
    this.avatar = const Value.absent(),
    this.email = const Value.absent(),
    this.memberLevel = const Value.absent(),
    this.experience = const Value.absent(),
    this.totalProfit = const Value.absent(),
    this.totalTrainingDays = const Value.absent(),
    this.avgDailyDuration = const Value.absent(),
    this.overallWinRate = const Value.absent(),
    this.avgProfitRate = const Value.absent(),
    this.status = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String phone,
    this.password = const Value.absent(),
    this.salt = const Value.absent(),
    this.nickname = const Value.absent(),
    this.avatar = const Value.absent(),
    this.email = const Value.absent(),
    this.memberLevel = const Value.absent(),
    this.experience = const Value.absent(),
    this.totalProfit = const Value.absent(),
    this.totalTrainingDays = const Value.absent(),
    this.avgDailyDuration = const Value.absent(),
    this.overallWinRate = const Value.absent(),
    this.avgProfitRate = const Value.absent(),
    this.status = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : phone = Value(phone);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? phone,
    Expression<String>? password,
    Expression<String>? salt,
    Expression<String>? nickname,
    Expression<String>? avatar,
    Expression<String>? email,
    Expression<int>? memberLevel,
    Expression<int>? experience,
    Expression<double>? totalProfit,
    Expression<int>? totalTrainingDays,
    Expression<double>? avgDailyDuration,
    Expression<double>? overallWinRate,
    Expression<double>? avgProfitRate,
    Expression<String>? status,
    Expression<DateTime>? lastLoginAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phone != null) 'phone': phone,
      if (password != null) 'password': password,
      if (salt != null) 'salt': salt,
      if (nickname != null) 'nickname': nickname,
      if (avatar != null) 'avatar': avatar,
      if (email != null) 'email': email,
      if (memberLevel != null) 'member_level': memberLevel,
      if (experience != null) 'experience': experience,
      if (totalProfit != null) 'total_profit': totalProfit,
      if (totalTrainingDays != null) 'total_training_days': totalTrainingDays,
      if (avgDailyDuration != null) 'avg_daily_duration': avgDailyDuration,
      if (overallWinRate != null) 'overall_win_rate': overallWinRate,
      if (avgProfitRate != null) 'avg_profit_rate': avgProfitRate,
      if (status != null) 'status': status,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? phone,
      Value<String?>? password,
      Value<String?>? salt,
      Value<String?>? nickname,
      Value<String?>? avatar,
      Value<String?>? email,
      Value<int>? memberLevel,
      Value<int>? experience,
      Value<double>? totalProfit,
      Value<int>? totalTrainingDays,
      Value<double>? avgDailyDuration,
      Value<double>? overallWinRate,
      Value<double>? avgProfitRate,
      Value<String>? status,
      Value<DateTime?>? lastLoginAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      salt: salt ?? this.salt,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      memberLevel: memberLevel ?? this.memberLevel,
      experience: experience ?? this.experience,
      totalProfit: totalProfit ?? this.totalProfit,
      totalTrainingDays: totalTrainingDays ?? this.totalTrainingDays,
      avgDailyDuration: avgDailyDuration ?? this.avgDailyDuration,
      overallWinRate: overallWinRate ?? this.overallWinRate,
      avgProfitRate: avgProfitRate ?? this.avgProfitRate,
      status: status ?? this.status,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (salt.present) {
      map['salt'] = Variable<String>(salt.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (memberLevel.present) {
      map['member_level'] = Variable<int>(memberLevel.value);
    }
    if (experience.present) {
      map['experience'] = Variable<int>(experience.value);
    }
    if (totalProfit.present) {
      map['total_profit'] = Variable<double>(totalProfit.value);
    }
    if (totalTrainingDays.present) {
      map['total_training_days'] = Variable<int>(totalTrainingDays.value);
    }
    if (avgDailyDuration.present) {
      map['avg_daily_duration'] = Variable<double>(avgDailyDuration.value);
    }
    if (overallWinRate.present) {
      map['overall_win_rate'] = Variable<double>(overallWinRate.value);
    }
    if (avgProfitRate.present) {
      map['avg_profit_rate'] = Variable<double>(avgProfitRate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('password: $password, ')
          ..write('salt: $salt, ')
          ..write('nickname: $nickname, ')
          ..write('avatar: $avatar, ')
          ..write('email: $email, ')
          ..write('memberLevel: $memberLevel, ')
          ..write('experience: $experience, ')
          ..write('totalProfit: $totalProfit, ')
          ..write('totalTrainingDays: $totalTrainingDays, ')
          ..write('avgDailyDuration: $avgDailyDuration, ')
          ..write('overallWinRate: $overallWinRate, ')
          ..write('avgProfitRate: $avgProfitRate, ')
          ..write('status: $status, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES users (id) ON DELETE CASCADE'));
  static const VerificationMeta _realNameMeta =
      const VerificationMeta('realName');
  @override
  late final GeneratedColumn<String> realName = GeneratedColumn<String>(
      'real_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _idCardMeta = const VerificationMeta('idCard');
  @override
  late final GeneratedColumn<String> idCard = GeneratedColumn<String>(
      'id_card', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _birthdayMeta =
      const VerificationMeta('birthday');
  @override
  late final GeneratedColumn<DateTime> birthday = GeneratedColumn<DateTime>(
      'birthday', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
      'region', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tradingExperienceMeta =
      const VerificationMeta('tradingExperience');
  @override
  late final GeneratedColumn<String> tradingExperience =
      GeneratedColumn<String>('trading_experience', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _investmentGoalMeta =
      const VerificationMeta('investmentGoal');
  @override
  late final GeneratedColumn<String> investmentGoal = GeneratedColumn<String>(
      'investment_goal', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _riskToleranceMeta =
      const VerificationMeta('riskTolerance');
  @override
  late final GeneratedColumn<String> riskTolerance = GeneratedColumn<String>(
      'risk_tolerance', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _favoriteMarketsMeta =
      const VerificationMeta('favoriteMarkets');
  @override
  late final GeneratedColumn<String> favoriteMarkets = GeneratedColumn<String>(
      'favorite_markets', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
      'bio', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        realName,
        idCard,
        gender,
        birthday,
        region,
        tradingExperience,
        investmentGoal,
        riskTolerance,
        favoriteMarkets,
        bio,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<UserProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('real_name')) {
      context.handle(_realNameMeta,
          realName.isAcceptableOrUnknown(data['real_name']!, _realNameMeta));
    }
    if (data.containsKey('id_card')) {
      context.handle(_idCardMeta,
          idCard.isAcceptableOrUnknown(data['id_card']!, _idCardMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('birthday')) {
      context.handle(_birthdayMeta,
          birthday.isAcceptableOrUnknown(data['birthday']!, _birthdayMeta));
    }
    if (data.containsKey('region')) {
      context.handle(_regionMeta,
          region.isAcceptableOrUnknown(data['region']!, _regionMeta));
    }
    if (data.containsKey('trading_experience')) {
      context.handle(
          _tradingExperienceMeta,
          tradingExperience.isAcceptableOrUnknown(
              data['trading_experience']!, _tradingExperienceMeta));
    }
    if (data.containsKey('investment_goal')) {
      context.handle(
          _investmentGoalMeta,
          investmentGoal.isAcceptableOrUnknown(
              data['investment_goal']!, _investmentGoalMeta));
    }
    if (data.containsKey('risk_tolerance')) {
      context.handle(
          _riskToleranceMeta,
          riskTolerance.isAcceptableOrUnknown(
              data['risk_tolerance']!, _riskToleranceMeta));
    }
    if (data.containsKey('favorite_markets')) {
      context.handle(
          _favoriteMarketsMeta,
          favoriteMarkets.isAcceptableOrUnknown(
              data['favorite_markets']!, _favoriteMarketsMeta));
    }
    if (data.containsKey('bio')) {
      context.handle(
          _bioMeta, bio.isAcceptableOrUnknown(data['bio']!, _bioMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      realName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}real_name']),
      idCard: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id_card']),
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender']),
      birthday: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}birthday']),
      region: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}region']),
      tradingExperience: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}trading_experience']),
      investmentGoal: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}investment_goal']),
      riskTolerance: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}risk_tolerance']),
      favoriteMarkets: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}favorite_markets']),
      bio: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bio']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  /// 用户ID (主键)
  final int userId;

  /// 真实姓名
  final String? realName;

  /// 身份证号 (加密)
  final String? idCard;

  /// 性别: male/female/other
  final String? gender;

  /// 生日
  final DateTime? birthday;

  /// 所在地区
  final String? region;

  /// 交易经验年限
  final String? tradingExperience;

  /// 投资目标
  final String? investmentGoal;

  /// 风险承受能力
  final String? riskTolerance;

  /// 偏好市场 (JSON)
  final String? favoriteMarkets;

  /// 个人简介
  final String? bio;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const UserProfile(
      {required this.userId,
      this.realName,
      this.idCard,
      this.gender,
      this.birthday,
      this.region,
      this.tradingExperience,
      this.investmentGoal,
      this.riskTolerance,
      this.favoriteMarkets,
      this.bio,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    if (!nullToAbsent || realName != null) {
      map['real_name'] = Variable<String>(realName);
    }
    if (!nullToAbsent || idCard != null) {
      map['id_card'] = Variable<String>(idCard);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || birthday != null) {
      map['birthday'] = Variable<DateTime>(birthday);
    }
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    if (!nullToAbsent || tradingExperience != null) {
      map['trading_experience'] = Variable<String>(tradingExperience);
    }
    if (!nullToAbsent || investmentGoal != null) {
      map['investment_goal'] = Variable<String>(investmentGoal);
    }
    if (!nullToAbsent || riskTolerance != null) {
      map['risk_tolerance'] = Variable<String>(riskTolerance);
    }
    if (!nullToAbsent || favoriteMarkets != null) {
      map['favorite_markets'] = Variable<String>(favoriteMarkets);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      userId: Value(userId),
      realName: realName == null && nullToAbsent
          ? const Value.absent()
          : Value(realName),
      idCard:
          idCard == null && nullToAbsent ? const Value.absent() : Value(idCard),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      birthday: birthday == null && nullToAbsent
          ? const Value.absent()
          : Value(birthday),
      region:
          region == null && nullToAbsent ? const Value.absent() : Value(region),
      tradingExperience: tradingExperience == null && nullToAbsent
          ? const Value.absent()
          : Value(tradingExperience),
      investmentGoal: investmentGoal == null && nullToAbsent
          ? const Value.absent()
          : Value(investmentGoal),
      riskTolerance: riskTolerance == null && nullToAbsent
          ? const Value.absent()
          : Value(riskTolerance),
      favoriteMarkets: favoriteMarkets == null && nullToAbsent
          ? const Value.absent()
          : Value(favoriteMarkets),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      userId: serializer.fromJson<int>(json['userId']),
      realName: serializer.fromJson<String?>(json['realName']),
      idCard: serializer.fromJson<String?>(json['idCard']),
      gender: serializer.fromJson<String?>(json['gender']),
      birthday: serializer.fromJson<DateTime?>(json['birthday']),
      region: serializer.fromJson<String?>(json['region']),
      tradingExperience:
          serializer.fromJson<String?>(json['tradingExperience']),
      investmentGoal: serializer.fromJson<String?>(json['investmentGoal']),
      riskTolerance: serializer.fromJson<String?>(json['riskTolerance']),
      favoriteMarkets: serializer.fromJson<String?>(json['favoriteMarkets']),
      bio: serializer.fromJson<String?>(json['bio']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'realName': serializer.toJson<String?>(realName),
      'idCard': serializer.toJson<String?>(idCard),
      'gender': serializer.toJson<String?>(gender),
      'birthday': serializer.toJson<DateTime?>(birthday),
      'region': serializer.toJson<String?>(region),
      'tradingExperience': serializer.toJson<String?>(tradingExperience),
      'investmentGoal': serializer.toJson<String?>(investmentGoal),
      'riskTolerance': serializer.toJson<String?>(riskTolerance),
      'favoriteMarkets': serializer.toJson<String?>(favoriteMarkets),
      'bio': serializer.toJson<String?>(bio),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfile copyWith(
          {int? userId,
          Value<String?> realName = const Value.absent(),
          Value<String?> idCard = const Value.absent(),
          Value<String?> gender = const Value.absent(),
          Value<DateTime?> birthday = const Value.absent(),
          Value<String?> region = const Value.absent(),
          Value<String?> tradingExperience = const Value.absent(),
          Value<String?> investmentGoal = const Value.absent(),
          Value<String?> riskTolerance = const Value.absent(),
          Value<String?> favoriteMarkets = const Value.absent(),
          Value<String?> bio = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UserProfile(
        userId: userId ?? this.userId,
        realName: realName.present ? realName.value : this.realName,
        idCard: idCard.present ? idCard.value : this.idCard,
        gender: gender.present ? gender.value : this.gender,
        birthday: birthday.present ? birthday.value : this.birthday,
        region: region.present ? region.value : this.region,
        tradingExperience: tradingExperience.present
            ? tradingExperience.value
            : this.tradingExperience,
        investmentGoal:
            investmentGoal.present ? investmentGoal.value : this.investmentGoal,
        riskTolerance:
            riskTolerance.present ? riskTolerance.value : this.riskTolerance,
        favoriteMarkets: favoriteMarkets.present
            ? favoriteMarkets.value
            : this.favoriteMarkets,
        bio: bio.present ? bio.value : this.bio,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      userId: data.userId.present ? data.userId.value : this.userId,
      realName: data.realName.present ? data.realName.value : this.realName,
      idCard: data.idCard.present ? data.idCard.value : this.idCard,
      gender: data.gender.present ? data.gender.value : this.gender,
      birthday: data.birthday.present ? data.birthday.value : this.birthday,
      region: data.region.present ? data.region.value : this.region,
      tradingExperience: data.tradingExperience.present
          ? data.tradingExperience.value
          : this.tradingExperience,
      investmentGoal: data.investmentGoal.present
          ? data.investmentGoal.value
          : this.investmentGoal,
      riskTolerance: data.riskTolerance.present
          ? data.riskTolerance.value
          : this.riskTolerance,
      favoriteMarkets: data.favoriteMarkets.present
          ? data.favoriteMarkets.value
          : this.favoriteMarkets,
      bio: data.bio.present ? data.bio.value : this.bio,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('userId: $userId, ')
          ..write('realName: $realName, ')
          ..write('idCard: $idCard, ')
          ..write('gender: $gender, ')
          ..write('birthday: $birthday, ')
          ..write('region: $region, ')
          ..write('tradingExperience: $tradingExperience, ')
          ..write('investmentGoal: $investmentGoal, ')
          ..write('riskTolerance: $riskTolerance, ')
          ..write('favoriteMarkets: $favoriteMarkets, ')
          ..write('bio: $bio, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId,
      realName,
      idCard,
      gender,
      birthday,
      region,
      tradingExperience,
      investmentGoal,
      riskTolerance,
      favoriteMarkets,
      bio,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.userId == this.userId &&
          other.realName == this.realName &&
          other.idCard == this.idCard &&
          other.gender == this.gender &&
          other.birthday == this.birthday &&
          other.region == this.region &&
          other.tradingExperience == this.tradingExperience &&
          other.investmentGoal == this.investmentGoal &&
          other.riskTolerance == this.riskTolerance &&
          other.favoriteMarkets == this.favoriteMarkets &&
          other.bio == this.bio &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> userId;
  final Value<String?> realName;
  final Value<String?> idCard;
  final Value<String?> gender;
  final Value<DateTime?> birthday;
  final Value<String?> region;
  final Value<String?> tradingExperience;
  final Value<String?> investmentGoal;
  final Value<String?> riskTolerance;
  final Value<String?> favoriteMarkets;
  final Value<String?> bio;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserProfilesCompanion({
    this.userId = const Value.absent(),
    this.realName = const Value.absent(),
    this.idCard = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthday = const Value.absent(),
    this.region = const Value.absent(),
    this.tradingExperience = const Value.absent(),
    this.investmentGoal = const Value.absent(),
    this.riskTolerance = const Value.absent(),
    this.favoriteMarkets = const Value.absent(),
    this.bio = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.userId = const Value.absent(),
    this.realName = const Value.absent(),
    this.idCard = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthday = const Value.absent(),
    this.region = const Value.absent(),
    this.tradingExperience = const Value.absent(),
    this.investmentGoal = const Value.absent(),
    this.riskTolerance = const Value.absent(),
    this.favoriteMarkets = const Value.absent(),
    this.bio = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<UserProfile> custom({
    Expression<int>? userId,
    Expression<String>? realName,
    Expression<String>? idCard,
    Expression<String>? gender,
    Expression<DateTime>? birthday,
    Expression<String>? region,
    Expression<String>? tradingExperience,
    Expression<String>? investmentGoal,
    Expression<String>? riskTolerance,
    Expression<String>? favoriteMarkets,
    Expression<String>? bio,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (realName != null) 'real_name': realName,
      if (idCard != null) 'id_card': idCard,
      if (gender != null) 'gender': gender,
      if (birthday != null) 'birthday': birthday,
      if (region != null) 'region': region,
      if (tradingExperience != null) 'trading_experience': tradingExperience,
      if (investmentGoal != null) 'investment_goal': investmentGoal,
      if (riskTolerance != null) 'risk_tolerance': riskTolerance,
      if (favoriteMarkets != null) 'favorite_markets': favoriteMarkets,
      if (bio != null) 'bio': bio,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserProfilesCompanion copyWith(
      {Value<int>? userId,
      Value<String?>? realName,
      Value<String?>? idCard,
      Value<String?>? gender,
      Value<DateTime?>? birthday,
      Value<String?>? region,
      Value<String?>? tradingExperience,
      Value<String?>? investmentGoal,
      Value<String?>? riskTolerance,
      Value<String?>? favoriteMarkets,
      Value<String?>? bio,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UserProfilesCompanion(
      userId: userId ?? this.userId,
      realName: realName ?? this.realName,
      idCard: idCard ?? this.idCard,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      region: region ?? this.region,
      tradingExperience: tradingExperience ?? this.tradingExperience,
      investmentGoal: investmentGoal ?? this.investmentGoal,
      riskTolerance: riskTolerance ?? this.riskTolerance,
      favoriteMarkets: favoriteMarkets ?? this.favoriteMarkets,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (realName.present) {
      map['real_name'] = Variable<String>(realName.value);
    }
    if (idCard.present) {
      map['id_card'] = Variable<String>(idCard.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<DateTime>(birthday.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (tradingExperience.present) {
      map['trading_experience'] = Variable<String>(tradingExperience.value);
    }
    if (investmentGoal.present) {
      map['investment_goal'] = Variable<String>(investmentGoal.value);
    }
    if (riskTolerance.present) {
      map['risk_tolerance'] = Variable<String>(riskTolerance.value);
    }
    if (favoriteMarkets.present) {
      map['favorite_markets'] = Variable<String>(favoriteMarkets.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('userId: $userId, ')
          ..write('realName: $realName, ')
          ..write('idCard: $idCard, ')
          ..write('gender: $gender, ')
          ..write('birthday: $birthday, ')
          ..write('region: $region, ')
          ..write('tradingExperience: $tradingExperience, ')
          ..write('investmentGoal: $investmentGoal, ')
          ..write('riskTolerance: $riskTolerance, ')
          ..write('favoriteMarkets: $favoriteMarkets, ')
          ..write('bio: $bio, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTable extends UserPreferences
    with TableInfo<$UserPreferencesTable, UserPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES users (id) ON DELETE CASCADE'));
  static const VerificationMeta _themeModeMeta =
      const VerificationMeta('themeMode');
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('system'));
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('zh'));
  static const VerificationMeta _textScaleMeta =
      const VerificationMeta('textScale');
  @override
  late final GeneratedColumn<double> textScale = GeneratedColumn<double>(
      'text_scale', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _soundEnabledMeta =
      const VerificationMeta('soundEnabled');
  @override
  late final GeneratedColumn<bool> soundEnabled = GeneratedColumn<bool>(
      'sound_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sound_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _notificationEnabledMeta =
      const VerificationMeta('notificationEnabled');
  @override
  late final GeneratedColumn<bool> notificationEnabled = GeneratedColumn<bool>(
      'notification_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notification_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _autoRefreshMeta =
      const VerificationMeta('autoRefresh');
  @override
  late final GeneratedColumn<bool> autoRefresh = GeneratedColumn<bool>(
      'auto_refresh', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_refresh" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _refreshIntervalMeta =
      const VerificationMeta('refreshInterval');
  @override
  late final GeneratedColumn<int> refreshInterval = GeneratedColumn<int>(
      'refresh_interval', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(30));
  static const VerificationMeta _defaultMarketMeta =
      const VerificationMeta('defaultMarket');
  @override
  late final GeneratedColumn<String> defaultMarket = GeneratedColumn<String>(
      'default_market', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('A股'));
  static const VerificationMeta _defaultPeriodMeta =
      const VerificationMeta('defaultPeriod');
  @override
  late final GeneratedColumn<String> defaultPeriod = GeneratedColumn<String>(
      'default_period', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('day'));
  static const VerificationMeta _indicatorsMeta =
      const VerificationMeta('indicators');
  @override
  late final GeneratedColumn<String> indicators = GeneratedColumn<String>(
      'indicators', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _showGridLinesMeta =
      const VerificationMeta('showGridLines');
  @override
  late final GeneratedColumn<bool> showGridLines = GeneratedColumn<bool>(
      'show_grid_lines', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_grid_lines" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showVolumeMeta =
      const VerificationMeta('showVolume');
  @override
  late final GeneratedColumn<bool> showVolume = GeneratedColumn<bool>(
      'show_volume', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_volume" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        themeMode,
        language,
        textScale,
        soundEnabled,
        notificationEnabled,
        autoRefresh,
        refreshInterval,
        defaultMarket,
        defaultPeriod,
        indicators,
        showGridLines,
        showVolume,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences';
  @override
  VerificationContext validateIntegrity(Insertable<UserPreference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(_themeModeMeta,
          themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('text_scale')) {
      context.handle(_textScaleMeta,
          textScale.isAcceptableOrUnknown(data['text_scale']!, _textScaleMeta));
    }
    if (data.containsKey('sound_enabled')) {
      context.handle(
          _soundEnabledMeta,
          soundEnabled.isAcceptableOrUnknown(
              data['sound_enabled']!, _soundEnabledMeta));
    }
    if (data.containsKey('notification_enabled')) {
      context.handle(
          _notificationEnabledMeta,
          notificationEnabled.isAcceptableOrUnknown(
              data['notification_enabled']!, _notificationEnabledMeta));
    }
    if (data.containsKey('auto_refresh')) {
      context.handle(
          _autoRefreshMeta,
          autoRefresh.isAcceptableOrUnknown(
              data['auto_refresh']!, _autoRefreshMeta));
    }
    if (data.containsKey('refresh_interval')) {
      context.handle(
          _refreshIntervalMeta,
          refreshInterval.isAcceptableOrUnknown(
              data['refresh_interval']!, _refreshIntervalMeta));
    }
    if (data.containsKey('default_market')) {
      context.handle(
          _defaultMarketMeta,
          defaultMarket.isAcceptableOrUnknown(
              data['default_market']!, _defaultMarketMeta));
    }
    if (data.containsKey('default_period')) {
      context.handle(
          _defaultPeriodMeta,
          defaultPeriod.isAcceptableOrUnknown(
              data['default_period']!, _defaultPeriodMeta));
    }
    if (data.containsKey('indicators')) {
      context.handle(
          _indicatorsMeta,
          indicators.isAcceptableOrUnknown(
              data['indicators']!, _indicatorsMeta));
    }
    if (data.containsKey('show_grid_lines')) {
      context.handle(
          _showGridLinesMeta,
          showGridLines.isAcceptableOrUnknown(
              data['show_grid_lines']!, _showGridLinesMeta));
    }
    if (data.containsKey('show_volume')) {
      context.handle(
          _showVolumeMeta,
          showVolume.isAcceptableOrUnknown(
              data['show_volume']!, _showVolumeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreference(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      themeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_mode'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      textScale: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}text_scale'])!,
      soundEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}sound_enabled'])!,
      notificationEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}notification_enabled'])!,
      autoRefresh: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}auto_refresh'])!,
      refreshInterval: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}refresh_interval'])!,
      defaultMarket: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_market'])!,
      defaultPeriod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_period'])!,
      indicators: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}indicators']),
      showGridLines: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_grid_lines'])!,
      showVolume: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_volume'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UserPreferencesTable createAlias(String alias) {
    return $UserPreferencesTable(attachedDatabase, alias);
  }
}

class UserPreference extends DataClass implements Insertable<UserPreference> {
  /// 用户ID (主键)
  final int userId;

  /// 主题模式: system/light/dark
  final String themeMode;

  /// 语言: zh/en
  final String language;

  /// 文字缩放比例
  final double textScale;

  /// 音效开关
  final bool soundEnabled;

  /// 通知开关
  final bool notificationEnabled;

  /// 自动刷新开关
  final bool autoRefresh;

  /// 刷新间隔(秒)
  final int refreshInterval;

  /// 默认市场: A股
  final String defaultMarket;

  /// 默认周期: day
  final String defaultPeriod;

  /// 默认指标 (JSON)
  final String? indicators;

  /// 显示网格线
  final bool showGridLines;

  /// 显示成交量
  final bool showVolume;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const UserPreference(
      {required this.userId,
      required this.themeMode,
      required this.language,
      required this.textScale,
      required this.soundEnabled,
      required this.notificationEnabled,
      required this.autoRefresh,
      required this.refreshInterval,
      required this.defaultMarket,
      required this.defaultPeriod,
      this.indicators,
      required this.showGridLines,
      required this.showVolume,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    map['theme_mode'] = Variable<String>(themeMode);
    map['language'] = Variable<String>(language);
    map['text_scale'] = Variable<double>(textScale);
    map['sound_enabled'] = Variable<bool>(soundEnabled);
    map['notification_enabled'] = Variable<bool>(notificationEnabled);
    map['auto_refresh'] = Variable<bool>(autoRefresh);
    map['refresh_interval'] = Variable<int>(refreshInterval);
    map['default_market'] = Variable<String>(defaultMarket);
    map['default_period'] = Variable<String>(defaultPeriod);
    if (!nullToAbsent || indicators != null) {
      map['indicators'] = Variable<String>(indicators);
    }
    map['show_grid_lines'] = Variable<bool>(showGridLines);
    map['show_volume'] = Variable<bool>(showVolume);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserPreferencesCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesCompanion(
      userId: Value(userId),
      themeMode: Value(themeMode),
      language: Value(language),
      textScale: Value(textScale),
      soundEnabled: Value(soundEnabled),
      notificationEnabled: Value(notificationEnabled),
      autoRefresh: Value(autoRefresh),
      refreshInterval: Value(refreshInterval),
      defaultMarket: Value(defaultMarket),
      defaultPeriod: Value(defaultPeriod),
      indicators: indicators == null && nullToAbsent
          ? const Value.absent()
          : Value(indicators),
      showGridLines: Value(showGridLines),
      showVolume: Value(showVolume),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserPreference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreference(
      userId: serializer.fromJson<int>(json['userId']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      language: serializer.fromJson<String>(json['language']),
      textScale: serializer.fromJson<double>(json['textScale']),
      soundEnabled: serializer.fromJson<bool>(json['soundEnabled']),
      notificationEnabled:
          serializer.fromJson<bool>(json['notificationEnabled']),
      autoRefresh: serializer.fromJson<bool>(json['autoRefresh']),
      refreshInterval: serializer.fromJson<int>(json['refreshInterval']),
      defaultMarket: serializer.fromJson<String>(json['defaultMarket']),
      defaultPeriod: serializer.fromJson<String>(json['defaultPeriod']),
      indicators: serializer.fromJson<String?>(json['indicators']),
      showGridLines: serializer.fromJson<bool>(json['showGridLines']),
      showVolume: serializer.fromJson<bool>(json['showVolume']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'themeMode': serializer.toJson<String>(themeMode),
      'language': serializer.toJson<String>(language),
      'textScale': serializer.toJson<double>(textScale),
      'soundEnabled': serializer.toJson<bool>(soundEnabled),
      'notificationEnabled': serializer.toJson<bool>(notificationEnabled),
      'autoRefresh': serializer.toJson<bool>(autoRefresh),
      'refreshInterval': serializer.toJson<int>(refreshInterval),
      'defaultMarket': serializer.toJson<String>(defaultMarket),
      'defaultPeriod': serializer.toJson<String>(defaultPeriod),
      'indicators': serializer.toJson<String?>(indicators),
      'showGridLines': serializer.toJson<bool>(showGridLines),
      'showVolume': serializer.toJson<bool>(showVolume),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserPreference copyWith(
          {int? userId,
          String? themeMode,
          String? language,
          double? textScale,
          bool? soundEnabled,
          bool? notificationEnabled,
          bool? autoRefresh,
          int? refreshInterval,
          String? defaultMarket,
          String? defaultPeriod,
          Value<String?> indicators = const Value.absent(),
          bool? showGridLines,
          bool? showVolume,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UserPreference(
        userId: userId ?? this.userId,
        themeMode: themeMode ?? this.themeMode,
        language: language ?? this.language,
        textScale: textScale ?? this.textScale,
        soundEnabled: soundEnabled ?? this.soundEnabled,
        notificationEnabled: notificationEnabled ?? this.notificationEnabled,
        autoRefresh: autoRefresh ?? this.autoRefresh,
        refreshInterval: refreshInterval ?? this.refreshInterval,
        defaultMarket: defaultMarket ?? this.defaultMarket,
        defaultPeriod: defaultPeriod ?? this.defaultPeriod,
        indicators: indicators.present ? indicators.value : this.indicators,
        showGridLines: showGridLines ?? this.showGridLines,
        showVolume: showVolume ?? this.showVolume,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserPreference copyWithCompanion(UserPreferencesCompanion data) {
    return UserPreference(
      userId: data.userId.present ? data.userId.value : this.userId,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      language: data.language.present ? data.language.value : this.language,
      textScale: data.textScale.present ? data.textScale.value : this.textScale,
      soundEnabled: data.soundEnabled.present
          ? data.soundEnabled.value
          : this.soundEnabled,
      notificationEnabled: data.notificationEnabled.present
          ? data.notificationEnabled.value
          : this.notificationEnabled,
      autoRefresh:
          data.autoRefresh.present ? data.autoRefresh.value : this.autoRefresh,
      refreshInterval: data.refreshInterval.present
          ? data.refreshInterval.value
          : this.refreshInterval,
      defaultMarket: data.defaultMarket.present
          ? data.defaultMarket.value
          : this.defaultMarket,
      defaultPeriod: data.defaultPeriod.present
          ? data.defaultPeriod.value
          : this.defaultPeriod,
      indicators:
          data.indicators.present ? data.indicators.value : this.indicators,
      showGridLines: data.showGridLines.present
          ? data.showGridLines.value
          : this.showGridLines,
      showVolume:
          data.showVolume.present ? data.showVolume.value : this.showVolume,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreference(')
          ..write('userId: $userId, ')
          ..write('themeMode: $themeMode, ')
          ..write('language: $language, ')
          ..write('textScale: $textScale, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('notificationEnabled: $notificationEnabled, ')
          ..write('autoRefresh: $autoRefresh, ')
          ..write('refreshInterval: $refreshInterval, ')
          ..write('defaultMarket: $defaultMarket, ')
          ..write('defaultPeriod: $defaultPeriod, ')
          ..write('indicators: $indicators, ')
          ..write('showGridLines: $showGridLines, ')
          ..write('showVolume: $showVolume, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId,
      themeMode,
      language,
      textScale,
      soundEnabled,
      notificationEnabled,
      autoRefresh,
      refreshInterval,
      defaultMarket,
      defaultPeriod,
      indicators,
      showGridLines,
      showVolume,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreference &&
          other.userId == this.userId &&
          other.themeMode == this.themeMode &&
          other.language == this.language &&
          other.textScale == this.textScale &&
          other.soundEnabled == this.soundEnabled &&
          other.notificationEnabled == this.notificationEnabled &&
          other.autoRefresh == this.autoRefresh &&
          other.refreshInterval == this.refreshInterval &&
          other.defaultMarket == this.defaultMarket &&
          other.defaultPeriod == this.defaultPeriod &&
          other.indicators == this.indicators &&
          other.showGridLines == this.showGridLines &&
          other.showVolume == this.showVolume &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserPreferencesCompanion extends UpdateCompanion<UserPreference> {
  final Value<int> userId;
  final Value<String> themeMode;
  final Value<String> language;
  final Value<double> textScale;
  final Value<bool> soundEnabled;
  final Value<bool> notificationEnabled;
  final Value<bool> autoRefresh;
  final Value<int> refreshInterval;
  final Value<String> defaultMarket;
  final Value<String> defaultPeriod;
  final Value<String?> indicators;
  final Value<bool> showGridLines;
  final Value<bool> showVolume;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserPreferencesCompanion({
    this.userId = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.language = const Value.absent(),
    this.textScale = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.notificationEnabled = const Value.absent(),
    this.autoRefresh = const Value.absent(),
    this.refreshInterval = const Value.absent(),
    this.defaultMarket = const Value.absent(),
    this.defaultPeriod = const Value.absent(),
    this.indicators = const Value.absent(),
    this.showGridLines = const Value.absent(),
    this.showVolume = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserPreferencesCompanion.insert({
    this.userId = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.language = const Value.absent(),
    this.textScale = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.notificationEnabled = const Value.absent(),
    this.autoRefresh = const Value.absent(),
    this.refreshInterval = const Value.absent(),
    this.defaultMarket = const Value.absent(),
    this.defaultPeriod = const Value.absent(),
    this.indicators = const Value.absent(),
    this.showGridLines = const Value.absent(),
    this.showVolume = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<UserPreference> custom({
    Expression<int>? userId,
    Expression<String>? themeMode,
    Expression<String>? language,
    Expression<double>? textScale,
    Expression<bool>? soundEnabled,
    Expression<bool>? notificationEnabled,
    Expression<bool>? autoRefresh,
    Expression<int>? refreshInterval,
    Expression<String>? defaultMarket,
    Expression<String>? defaultPeriod,
    Expression<String>? indicators,
    Expression<bool>? showGridLines,
    Expression<bool>? showVolume,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (themeMode != null) 'theme_mode': themeMode,
      if (language != null) 'language': language,
      if (textScale != null) 'text_scale': textScale,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (notificationEnabled != null)
        'notification_enabled': notificationEnabled,
      if (autoRefresh != null) 'auto_refresh': autoRefresh,
      if (refreshInterval != null) 'refresh_interval': refreshInterval,
      if (defaultMarket != null) 'default_market': defaultMarket,
      if (defaultPeriod != null) 'default_period': defaultPeriod,
      if (indicators != null) 'indicators': indicators,
      if (showGridLines != null) 'show_grid_lines': showGridLines,
      if (showVolume != null) 'show_volume': showVolume,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserPreferencesCompanion copyWith(
      {Value<int>? userId,
      Value<String>? themeMode,
      Value<String>? language,
      Value<double>? textScale,
      Value<bool>? soundEnabled,
      Value<bool>? notificationEnabled,
      Value<bool>? autoRefresh,
      Value<int>? refreshInterval,
      Value<String>? defaultMarket,
      Value<String>? defaultPeriod,
      Value<String?>? indicators,
      Value<bool>? showGridLines,
      Value<bool>? showVolume,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UserPreferencesCompanion(
      userId: userId ?? this.userId,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      textScale: textScale ?? this.textScale,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      autoRefresh: autoRefresh ?? this.autoRefresh,
      refreshInterval: refreshInterval ?? this.refreshInterval,
      defaultMarket: defaultMarket ?? this.defaultMarket,
      defaultPeriod: defaultPeriod ?? this.defaultPeriod,
      indicators: indicators ?? this.indicators,
      showGridLines: showGridLines ?? this.showGridLines,
      showVolume: showVolume ?? this.showVolume,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (textScale.present) {
      map['text_scale'] = Variable<double>(textScale.value);
    }
    if (soundEnabled.present) {
      map['sound_enabled'] = Variable<bool>(soundEnabled.value);
    }
    if (notificationEnabled.present) {
      map['notification_enabled'] = Variable<bool>(notificationEnabled.value);
    }
    if (autoRefresh.present) {
      map['auto_refresh'] = Variable<bool>(autoRefresh.value);
    }
    if (refreshInterval.present) {
      map['refresh_interval'] = Variable<int>(refreshInterval.value);
    }
    if (defaultMarket.present) {
      map['default_market'] = Variable<String>(defaultMarket.value);
    }
    if (defaultPeriod.present) {
      map['default_period'] = Variable<String>(defaultPeriod.value);
    }
    if (indicators.present) {
      map['indicators'] = Variable<String>(indicators.value);
    }
    if (showGridLines.present) {
      map['show_grid_lines'] = Variable<bool>(showGridLines.value);
    }
    if (showVolume.present) {
      map['show_volume'] = Variable<bool>(showVolume.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesCompanion(')
          ..write('userId: $userId, ')
          ..write('themeMode: $themeMode, ')
          ..write('language: $language, ')
          ..write('textScale: $textScale, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('notificationEnabled: $notificationEnabled, ')
          ..write('autoRefresh: $autoRefresh, ')
          ..write('refreshInterval: $refreshInterval, ')
          ..write('defaultMarket: $defaultMarket, ')
          ..write('defaultPeriod: $defaultPeriod, ')
          ..write('indicators: $indicators, ')
          ..write('showGridLines: $showGridLines, ')
          ..write('showVolume: $showVolume, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MarketsTable extends Markets with TableInfo<$MarketsTable, Market> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MarketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        code,
        name,
        description,
        currency,
        enabled,
        sortOrder,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'markets';
  @override
  VerificationContext validateIntegrity(Insertable<Market> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Market map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Market(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MarketsTable createAlias(String alias) {
    return $MarketsTable(attachedDatabase, alias);
  }
}

class Market extends DataClass implements Insertable<Market> {
  /// 市场ID
  final int id;

  /// 市场代码: A股/SH/SZ/HK/US/FUTURES
  final String code;

  /// 市场名称
  final String name;

  /// 市场描述
  final String? description;

  /// 货币单位
  final String currency;

  /// 是否启用
  final bool enabled;

  /// 排序顺序
  final int sortOrder;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const Market(
      {required this.id,
      required this.code,
      required this.name,
      this.description,
      required this.currency,
      required this.enabled,
      required this.sortOrder,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['currency'] = Variable<String>(currency);
    map['enabled'] = Variable<bool>(enabled);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MarketsCompanion toCompanion(bool nullToAbsent) {
    return MarketsCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      currency: Value(currency),
      enabled: Value(enabled),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Market.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Market(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      currency: serializer.fromJson<String>(json['currency']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'currency': serializer.toJson<String>(currency),
      'enabled': serializer.toJson<bool>(enabled),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Market copyWith(
          {int? id,
          String? code,
          String? name,
          Value<String?> description = const Value.absent(),
          String? currency,
          bool? enabled,
          int? sortOrder,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Market(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        currency: currency ?? this.currency,
        enabled: enabled ?? this.enabled,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Market copyWithCompanion(MarketsCompanion data) {
    return Market(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      currency: data.currency.present ? data.currency.value : this.currency,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Market(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('currency: $currency, ')
          ..write('enabled: $enabled, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, name, description, currency,
      enabled, sortOrder, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Market &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.description == this.description &&
          other.currency == this.currency &&
          other.enabled == this.enabled &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MarketsCompanion extends UpdateCompanion<Market> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> currency;
  final Value<bool> enabled;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MarketsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.currency = const Value.absent(),
    this.enabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MarketsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    this.description = const Value.absent(),
    required String currency,
    this.enabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : code = Value(code),
        name = Value(name),
        currency = Value(currency);
  static Insertable<Market> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? currency,
    Expression<bool>? enabled,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (currency != null) 'currency': currency,
      if (enabled != null) 'enabled': enabled,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MarketsCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? name,
      Value<String?>? description,
      Value<String>? currency,
      Value<bool>? enabled,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MarketsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      currency: currency ?? this.currency,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MarketsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('currency: $currency, ')
          ..write('enabled: $enabled, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SymbolsTable extends Symbols with TableInfo<$SymbolsTable, Symbol> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymbolsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _marketCodeMeta =
      const VerificationMeta('marketCode');
  @override
  late final GeneratedColumn<String> marketCode = GeneratedColumn<String>(
      'market_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES markets (code)'));
  static const VerificationMeta _industryMeta =
      const VerificationMeta('industry');
  @override
  late final GeneratedColumn<String> industry = GeneratedColumn<String>(
      'industry', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sectorMeta = const VerificationMeta('sector');
  @override
  late final GeneratedColumn<String> sector = GeneratedColumn<String>(
      'sector', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastPriceMeta =
      const VerificationMeta('lastPrice');
  @override
  late final GeneratedColumn<double> lastPrice = GeneratedColumn<double>(
      'last_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _changeMeta = const VerificationMeta('change');
  @override
  late final GeneratedColumn<double> change = GeneratedColumn<double>(
      'change', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lotSizeMeta =
      const VerificationMeta('lotSize');
  @override
  late final GeneratedColumn<int> lotSize = GeneratedColumn<int>(
      'lot_size', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _minTickMeta =
      const VerificationMeta('minTick');
  @override
  late final GeneratedColumn<double> minTick = GeneratedColumn<double>(
      'min_tick', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        symbol,
        name,
        marketCode,
        industry,
        sector,
        lastPrice,
        change,
        lotSize,
        minTick,
        enabled,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symbols';
  @override
  VerificationContext validateIntegrity(Insertable<Symbol> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('market_code')) {
      context.handle(
          _marketCodeMeta,
          marketCode.isAcceptableOrUnknown(
              data['market_code']!, _marketCodeMeta));
    } else if (isInserting) {
      context.missing(_marketCodeMeta);
    }
    if (data.containsKey('industry')) {
      context.handle(_industryMeta,
          industry.isAcceptableOrUnknown(data['industry']!, _industryMeta));
    }
    if (data.containsKey('sector')) {
      context.handle(_sectorMeta,
          sector.isAcceptableOrUnknown(data['sector']!, _sectorMeta));
    }
    if (data.containsKey('last_price')) {
      context.handle(_lastPriceMeta,
          lastPrice.isAcceptableOrUnknown(data['last_price']!, _lastPriceMeta));
    }
    if (data.containsKey('change')) {
      context.handle(_changeMeta,
          change.isAcceptableOrUnknown(data['change']!, _changeMeta));
    }
    if (data.containsKey('lot_size')) {
      context.handle(_lotSizeMeta,
          lotSize.isAcceptableOrUnknown(data['lot_size']!, _lotSizeMeta));
    }
    if (data.containsKey('min_tick')) {
      context.handle(_minTickMeta,
          minTick.isAcceptableOrUnknown(data['min_tick']!, _minTickMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Symbol map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Symbol(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      marketCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market_code'])!,
      industry: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}industry']),
      sector: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sector']),
      lastPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}last_price']),
      change: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}change']),
      lotSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lot_size']),
      minTick: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}min_tick']),
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $SymbolsTable createAlias(String alias) {
    return $SymbolsTable(attachedDatabase, alias);
  }
}

class Symbol extends DataClass implements Insertable<Symbol> {
  /// 标的ID
  final int id;

  /// 标的代码: 如SH600519
  final String symbol;

  /// 标的名称
  final String name;

  /// 市场代码
  final String marketCode;

  /// 行业分类
  final String? industry;

  /// 板块
  final String? sector;

  /// 最新价格
  final double? lastPrice;

  /// 涨跌幅
  final double? change;

  /// 每手数量
  final int? lotSize;

  /// 最小变动价位
  final double? minTick;

  /// 是否启用
  final bool enabled;

  /// 创建时间
  final String? createdAt;

  /// 更新时间
  final String? updatedAt;
  const Symbol(
      {required this.id,
      required this.symbol,
      required this.name,
      required this.marketCode,
      this.industry,
      this.sector,
      this.lastPrice,
      this.change,
      this.lotSize,
      this.minTick,
      required this.enabled,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['symbol'] = Variable<String>(symbol);
    map['name'] = Variable<String>(name);
    map['market_code'] = Variable<String>(marketCode);
    if (!nullToAbsent || industry != null) {
      map['industry'] = Variable<String>(industry);
    }
    if (!nullToAbsent || sector != null) {
      map['sector'] = Variable<String>(sector);
    }
    if (!nullToAbsent || lastPrice != null) {
      map['last_price'] = Variable<double>(lastPrice);
    }
    if (!nullToAbsent || change != null) {
      map['change'] = Variable<double>(change);
    }
    if (!nullToAbsent || lotSize != null) {
      map['lot_size'] = Variable<int>(lotSize);
    }
    if (!nullToAbsent || minTick != null) {
      map['min_tick'] = Variable<double>(minTick);
    }
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  SymbolsCompanion toCompanion(bool nullToAbsent) {
    return SymbolsCompanion(
      id: Value(id),
      symbol: Value(symbol),
      name: Value(name),
      marketCode: Value(marketCode),
      industry: industry == null && nullToAbsent
          ? const Value.absent()
          : Value(industry),
      sector:
          sector == null && nullToAbsent ? const Value.absent() : Value(sector),
      lastPrice: lastPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPrice),
      change:
          change == null && nullToAbsent ? const Value.absent() : Value(change),
      lotSize: lotSize == null && nullToAbsent
          ? const Value.absent()
          : Value(lotSize),
      minTick: minTick == null && nullToAbsent
          ? const Value.absent()
          : Value(minTick),
      enabled: Value(enabled),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Symbol.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Symbol(
      id: serializer.fromJson<int>(json['id']),
      symbol: serializer.fromJson<String>(json['symbol']),
      name: serializer.fromJson<String>(json['name']),
      marketCode: serializer.fromJson<String>(json['marketCode']),
      industry: serializer.fromJson<String?>(json['industry']),
      sector: serializer.fromJson<String?>(json['sector']),
      lastPrice: serializer.fromJson<double?>(json['lastPrice']),
      change: serializer.fromJson<double?>(json['change']),
      lotSize: serializer.fromJson<int?>(json['lotSize']),
      minTick: serializer.fromJson<double?>(json['minTick']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'symbol': serializer.toJson<String>(symbol),
      'name': serializer.toJson<String>(name),
      'marketCode': serializer.toJson<String>(marketCode),
      'industry': serializer.toJson<String?>(industry),
      'sector': serializer.toJson<String?>(sector),
      'lastPrice': serializer.toJson<double?>(lastPrice),
      'change': serializer.toJson<double?>(change),
      'lotSize': serializer.toJson<int?>(lotSize),
      'minTick': serializer.toJson<double?>(minTick),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  Symbol copyWith(
          {int? id,
          String? symbol,
          String? name,
          String? marketCode,
          Value<String?> industry = const Value.absent(),
          Value<String?> sector = const Value.absent(),
          Value<double?> lastPrice = const Value.absent(),
          Value<double?> change = const Value.absent(),
          Value<int?> lotSize = const Value.absent(),
          Value<double?> minTick = const Value.absent(),
          bool? enabled,
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent()}) =>
      Symbol(
        id: id ?? this.id,
        symbol: symbol ?? this.symbol,
        name: name ?? this.name,
        marketCode: marketCode ?? this.marketCode,
        industry: industry.present ? industry.value : this.industry,
        sector: sector.present ? sector.value : this.sector,
        lastPrice: lastPrice.present ? lastPrice.value : this.lastPrice,
        change: change.present ? change.value : this.change,
        lotSize: lotSize.present ? lotSize.value : this.lotSize,
        minTick: minTick.present ? minTick.value : this.minTick,
        enabled: enabled ?? this.enabled,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Symbol copyWithCompanion(SymbolsCompanion data) {
    return Symbol(
      id: data.id.present ? data.id.value : this.id,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      name: data.name.present ? data.name.value : this.name,
      marketCode:
          data.marketCode.present ? data.marketCode.value : this.marketCode,
      industry: data.industry.present ? data.industry.value : this.industry,
      sector: data.sector.present ? data.sector.value : this.sector,
      lastPrice: data.lastPrice.present ? data.lastPrice.value : this.lastPrice,
      change: data.change.present ? data.change.value : this.change,
      lotSize: data.lotSize.present ? data.lotSize.value : this.lotSize,
      minTick: data.minTick.present ? data.minTick.value : this.minTick,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Symbol(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('name: $name, ')
          ..write('marketCode: $marketCode, ')
          ..write('industry: $industry, ')
          ..write('sector: $sector, ')
          ..write('lastPrice: $lastPrice, ')
          ..write('change: $change, ')
          ..write('lotSize: $lotSize, ')
          ..write('minTick: $minTick, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      symbol,
      name,
      marketCode,
      industry,
      sector,
      lastPrice,
      change,
      lotSize,
      minTick,
      enabled,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Symbol &&
          other.id == this.id &&
          other.symbol == this.symbol &&
          other.name == this.name &&
          other.marketCode == this.marketCode &&
          other.industry == this.industry &&
          other.sector == this.sector &&
          other.lastPrice == this.lastPrice &&
          other.change == this.change &&
          other.lotSize == this.lotSize &&
          other.minTick == this.minTick &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SymbolsCompanion extends UpdateCompanion<Symbol> {
  final Value<int> id;
  final Value<String> symbol;
  final Value<String> name;
  final Value<String> marketCode;
  final Value<String?> industry;
  final Value<String?> sector;
  final Value<double?> lastPrice;
  final Value<double?> change;
  final Value<int?> lotSize;
  final Value<double?> minTick;
  final Value<bool> enabled;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const SymbolsCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.name = const Value.absent(),
    this.marketCode = const Value.absent(),
    this.industry = const Value.absent(),
    this.sector = const Value.absent(),
    this.lastPrice = const Value.absent(),
    this.change = const Value.absent(),
    this.lotSize = const Value.absent(),
    this.minTick = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SymbolsCompanion.insert({
    this.id = const Value.absent(),
    required String symbol,
    required String name,
    required String marketCode,
    this.industry = const Value.absent(),
    this.sector = const Value.absent(),
    this.lastPrice = const Value.absent(),
    this.change = const Value.absent(),
    this.lotSize = const Value.absent(),
    this.minTick = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : symbol = Value(symbol),
        name = Value(name),
        marketCode = Value(marketCode);
  static Insertable<Symbol> custom({
    Expression<int>? id,
    Expression<String>? symbol,
    Expression<String>? name,
    Expression<String>? marketCode,
    Expression<String>? industry,
    Expression<String>? sector,
    Expression<double>? lastPrice,
    Expression<double>? change,
    Expression<int>? lotSize,
    Expression<double>? minTick,
    Expression<bool>? enabled,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symbol != null) 'symbol': symbol,
      if (name != null) 'name': name,
      if (marketCode != null) 'market_code': marketCode,
      if (industry != null) 'industry': industry,
      if (sector != null) 'sector': sector,
      if (lastPrice != null) 'last_price': lastPrice,
      if (change != null) 'change': change,
      if (lotSize != null) 'lot_size': lotSize,
      if (minTick != null) 'min_tick': minTick,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SymbolsCompanion copyWith(
      {Value<int>? id,
      Value<String>? symbol,
      Value<String>? name,
      Value<String>? marketCode,
      Value<String?>? industry,
      Value<String?>? sector,
      Value<double?>? lastPrice,
      Value<double?>? change,
      Value<int?>? lotSize,
      Value<double?>? minTick,
      Value<bool>? enabled,
      Value<String?>? createdAt,
      Value<String?>? updatedAt}) {
    return SymbolsCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      marketCode: marketCode ?? this.marketCode,
      industry: industry ?? this.industry,
      sector: sector ?? this.sector,
      lastPrice: lastPrice ?? this.lastPrice,
      change: change ?? this.change,
      lotSize: lotSize ?? this.lotSize,
      minTick: minTick ?? this.minTick,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (marketCode.present) {
      map['market_code'] = Variable<String>(marketCode.value);
    }
    if (industry.present) {
      map['industry'] = Variable<String>(industry.value);
    }
    if (sector.present) {
      map['sector'] = Variable<String>(sector.value);
    }
    if (lastPrice.present) {
      map['last_price'] = Variable<double>(lastPrice.value);
    }
    if (change.present) {
      map['change'] = Variable<double>(change.value);
    }
    if (lotSize.present) {
      map['lot_size'] = Variable<int>(lotSize.value);
    }
    if (minTick.present) {
      map['min_tick'] = Variable<double>(minTick.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymbolsCompanion(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('name: $name, ')
          ..write('marketCode: $marketCode, ')
          ..write('industry: $industry, ')
          ..write('sector: $sector, ')
          ..write('lastPrice: $lastPrice, ')
          ..write('change: $change, ')
          ..write('lotSize: $lotSize, ')
          ..write('minTick: $minTick, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $KlineDataTable extends KlineData
    with TableInfo<$KlineDataTable, KlineDataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KlineDataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _marketCodeMeta =
      const VerificationMeta('marketCode');
  @override
  late final GeneratedColumn<String> marketCode = GeneratedColumn<String>(
      'market_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
      'period', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tradeDateMeta =
      const VerificationMeta('tradeDate');
  @override
  late final GeneratedColumn<DateTime> tradeDate = GeneratedColumn<DateTime>(
      'trade_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _openMeta = const VerificationMeta('open');
  @override
  late final GeneratedColumn<double> open = GeneratedColumn<double>(
      'open', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _closeMeta = const VerificationMeta('close');
  @override
  late final GeneratedColumn<double> close = GeneratedColumn<double>(
      'close', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _highMeta = const VerificationMeta('high');
  @override
  late final GeneratedColumn<double> high = GeneratedColumn<double>(
      'high', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lowMeta = const VerificationMeta('low');
  @override
  late final GeneratedColumn<double> low = GeneratedColumn<double>(
      'low', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<double> volume = GeneratedColumn<double>(
      'volume', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _turnoverRateMeta =
      const VerificationMeta('turnoverRate');
  @override
  late final GeneratedColumn<double> turnoverRate = GeneratedColumn<double>(
      'turnover_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _peMeta = const VerificationMeta('pe');
  @override
  late final GeneratedColumn<double> pe = GeneratedColumn<double>(
      'pe', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _pbMeta = const VerificationMeta('pb');
  @override
  late final GeneratedColumn<double> pb = GeneratedColumn<double>(
      'pb', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        symbol,
        marketCode,
        period,
        tradeDate,
        open,
        close,
        high,
        low,
        volume,
        amount,
        turnoverRate,
        pe,
        pb,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kline_data';
  @override
  VerificationContext validateIntegrity(Insertable<KlineDataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('market_code')) {
      context.handle(
          _marketCodeMeta,
          marketCode.isAcceptableOrUnknown(
              data['market_code']!, _marketCodeMeta));
    } else if (isInserting) {
      context.missing(_marketCodeMeta);
    }
    if (data.containsKey('period')) {
      context.handle(_periodMeta,
          period.isAcceptableOrUnknown(data['period']!, _periodMeta));
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('trade_date')) {
      context.handle(_tradeDateMeta,
          tradeDate.isAcceptableOrUnknown(data['trade_date']!, _tradeDateMeta));
    } else if (isInserting) {
      context.missing(_tradeDateMeta);
    }
    if (data.containsKey('open')) {
      context.handle(
          _openMeta, open.isAcceptableOrUnknown(data['open']!, _openMeta));
    } else if (isInserting) {
      context.missing(_openMeta);
    }
    if (data.containsKey('close')) {
      context.handle(
          _closeMeta, close.isAcceptableOrUnknown(data['close']!, _closeMeta));
    } else if (isInserting) {
      context.missing(_closeMeta);
    }
    if (data.containsKey('high')) {
      context.handle(
          _highMeta, high.isAcceptableOrUnknown(data['high']!, _highMeta));
    } else if (isInserting) {
      context.missing(_highMeta);
    }
    if (data.containsKey('low')) {
      context.handle(
          _lowMeta, low.isAcceptableOrUnknown(data['low']!, _lowMeta));
    } else if (isInserting) {
      context.missing(_lowMeta);
    }
    if (data.containsKey('volume')) {
      context.handle(_volumeMeta,
          volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta));
    } else if (isInserting) {
      context.missing(_volumeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('turnover_rate')) {
      context.handle(
          _turnoverRateMeta,
          turnoverRate.isAcceptableOrUnknown(
              data['turnover_rate']!, _turnoverRateMeta));
    }
    if (data.containsKey('pe')) {
      context.handle(_peMeta, pe.isAcceptableOrUnknown(data['pe']!, _peMeta));
    }
    if (data.containsKey('pb')) {
      context.handle(_pbMeta, pb.isAcceptableOrUnknown(data['pb']!, _pbMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symbol, period, tradeDate};
  @override
  KlineDataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KlineDataData(
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      marketCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market_code'])!,
      period: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}period'])!,
      tradeDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}trade_date'])!,
      open: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}open'])!,
      close: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}close'])!,
      high: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}high'])!,
      low: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}low'])!,
      volume: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}volume'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      turnoverRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}turnover_rate']),
      pe: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}pe']),
      pb: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}pb']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $KlineDataTable createAlias(String alias) {
    return $KlineDataTable(attachedDatabase, alias);
  }
}

class KlineDataData extends DataClass implements Insertable<KlineDataData> {
  /// 标的代码
  final String symbol;

  /// 市场代码
  final String marketCode;

  /// 周期: day/week/month/year/1min/5min/15min/30min/60min
  final String period;

  /// 交易日期时间
  final DateTime tradeDate;

  /// 开盘价
  final double open;

  /// 收盘价
  final double close;

  /// 最高价
  final double high;

  /// 最低价
  final double low;

  /// 成交量
  final double volume;

  /// 成交额
  final double amount;

  /// 换手率
  final double? turnoverRate;

  /// 市盈率
  final double? pe;

  /// 市净率
  final double? pb;

  /// 创建时间
  final DateTime createdAt;
  const KlineDataData(
      {required this.symbol,
      required this.marketCode,
      required this.period,
      required this.tradeDate,
      required this.open,
      required this.close,
      required this.high,
      required this.low,
      required this.volume,
      required this.amount,
      this.turnoverRate,
      this.pe,
      this.pb,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symbol'] = Variable<String>(symbol);
    map['market_code'] = Variable<String>(marketCode);
    map['period'] = Variable<String>(period);
    map['trade_date'] = Variable<DateTime>(tradeDate);
    map['open'] = Variable<double>(open);
    map['close'] = Variable<double>(close);
    map['high'] = Variable<double>(high);
    map['low'] = Variable<double>(low);
    map['volume'] = Variable<double>(volume);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || turnoverRate != null) {
      map['turnover_rate'] = Variable<double>(turnoverRate);
    }
    if (!nullToAbsent || pe != null) {
      map['pe'] = Variable<double>(pe);
    }
    if (!nullToAbsent || pb != null) {
      map['pb'] = Variable<double>(pb);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  KlineDataCompanion toCompanion(bool nullToAbsent) {
    return KlineDataCompanion(
      symbol: Value(symbol),
      marketCode: Value(marketCode),
      period: Value(period),
      tradeDate: Value(tradeDate),
      open: Value(open),
      close: Value(close),
      high: Value(high),
      low: Value(low),
      volume: Value(volume),
      amount: Value(amount),
      turnoverRate: turnoverRate == null && nullToAbsent
          ? const Value.absent()
          : Value(turnoverRate),
      pe: pe == null && nullToAbsent ? const Value.absent() : Value(pe),
      pb: pb == null && nullToAbsent ? const Value.absent() : Value(pb),
      createdAt: Value(createdAt),
    );
  }

  factory KlineDataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KlineDataData(
      symbol: serializer.fromJson<String>(json['symbol']),
      marketCode: serializer.fromJson<String>(json['marketCode']),
      period: serializer.fromJson<String>(json['period']),
      tradeDate: serializer.fromJson<DateTime>(json['tradeDate']),
      open: serializer.fromJson<double>(json['open']),
      close: serializer.fromJson<double>(json['close']),
      high: serializer.fromJson<double>(json['high']),
      low: serializer.fromJson<double>(json['low']),
      volume: serializer.fromJson<double>(json['volume']),
      amount: serializer.fromJson<double>(json['amount']),
      turnoverRate: serializer.fromJson<double?>(json['turnoverRate']),
      pe: serializer.fromJson<double?>(json['pe']),
      pb: serializer.fromJson<double?>(json['pb']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symbol': serializer.toJson<String>(symbol),
      'marketCode': serializer.toJson<String>(marketCode),
      'period': serializer.toJson<String>(period),
      'tradeDate': serializer.toJson<DateTime>(tradeDate),
      'open': serializer.toJson<double>(open),
      'close': serializer.toJson<double>(close),
      'high': serializer.toJson<double>(high),
      'low': serializer.toJson<double>(low),
      'volume': serializer.toJson<double>(volume),
      'amount': serializer.toJson<double>(amount),
      'turnoverRate': serializer.toJson<double?>(turnoverRate),
      'pe': serializer.toJson<double?>(pe),
      'pb': serializer.toJson<double?>(pb),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  KlineDataData copyWith(
          {String? symbol,
          String? marketCode,
          String? period,
          DateTime? tradeDate,
          double? open,
          double? close,
          double? high,
          double? low,
          double? volume,
          double? amount,
          Value<double?> turnoverRate = const Value.absent(),
          Value<double?> pe = const Value.absent(),
          Value<double?> pb = const Value.absent(),
          DateTime? createdAt}) =>
      KlineDataData(
        symbol: symbol ?? this.symbol,
        marketCode: marketCode ?? this.marketCode,
        period: period ?? this.period,
        tradeDate: tradeDate ?? this.tradeDate,
        open: open ?? this.open,
        close: close ?? this.close,
        high: high ?? this.high,
        low: low ?? this.low,
        volume: volume ?? this.volume,
        amount: amount ?? this.amount,
        turnoverRate:
            turnoverRate.present ? turnoverRate.value : this.turnoverRate,
        pe: pe.present ? pe.value : this.pe,
        pb: pb.present ? pb.value : this.pb,
        createdAt: createdAt ?? this.createdAt,
      );
  KlineDataData copyWithCompanion(KlineDataCompanion data) {
    return KlineDataData(
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      marketCode:
          data.marketCode.present ? data.marketCode.value : this.marketCode,
      period: data.period.present ? data.period.value : this.period,
      tradeDate: data.tradeDate.present ? data.tradeDate.value : this.tradeDate,
      open: data.open.present ? data.open.value : this.open,
      close: data.close.present ? data.close.value : this.close,
      high: data.high.present ? data.high.value : this.high,
      low: data.low.present ? data.low.value : this.low,
      volume: data.volume.present ? data.volume.value : this.volume,
      amount: data.amount.present ? data.amount.value : this.amount,
      turnoverRate: data.turnoverRate.present
          ? data.turnoverRate.value
          : this.turnoverRate,
      pe: data.pe.present ? data.pe.value : this.pe,
      pb: data.pb.present ? data.pb.value : this.pb,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KlineDataData(')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('period: $period, ')
          ..write('tradeDate: $tradeDate, ')
          ..write('open: $open, ')
          ..write('close: $close, ')
          ..write('high: $high, ')
          ..write('low: $low, ')
          ..write('volume: $volume, ')
          ..write('amount: $amount, ')
          ..write('turnoverRate: $turnoverRate, ')
          ..write('pe: $pe, ')
          ..write('pb: $pb, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(symbol, marketCode, period, tradeDate, open,
      close, high, low, volume, amount, turnoverRate, pe, pb, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KlineDataData &&
          other.symbol == this.symbol &&
          other.marketCode == this.marketCode &&
          other.period == this.period &&
          other.tradeDate == this.tradeDate &&
          other.open == this.open &&
          other.close == this.close &&
          other.high == this.high &&
          other.low == this.low &&
          other.volume == this.volume &&
          other.amount == this.amount &&
          other.turnoverRate == this.turnoverRate &&
          other.pe == this.pe &&
          other.pb == this.pb &&
          other.createdAt == this.createdAt);
}

class KlineDataCompanion extends UpdateCompanion<KlineDataData> {
  final Value<String> symbol;
  final Value<String> marketCode;
  final Value<String> period;
  final Value<DateTime> tradeDate;
  final Value<double> open;
  final Value<double> close;
  final Value<double> high;
  final Value<double> low;
  final Value<double> volume;
  final Value<double> amount;
  final Value<double?> turnoverRate;
  final Value<double?> pe;
  final Value<double?> pb;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const KlineDataCompanion({
    this.symbol = const Value.absent(),
    this.marketCode = const Value.absent(),
    this.period = const Value.absent(),
    this.tradeDate = const Value.absent(),
    this.open = const Value.absent(),
    this.close = const Value.absent(),
    this.high = const Value.absent(),
    this.low = const Value.absent(),
    this.volume = const Value.absent(),
    this.amount = const Value.absent(),
    this.turnoverRate = const Value.absent(),
    this.pe = const Value.absent(),
    this.pb = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KlineDataCompanion.insert({
    required String symbol,
    required String marketCode,
    required String period,
    required DateTime tradeDate,
    required double open,
    required double close,
    required double high,
    required double low,
    required double volume,
    required double amount,
    this.turnoverRate = const Value.absent(),
    this.pe = const Value.absent(),
    this.pb = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : symbol = Value(symbol),
        marketCode = Value(marketCode),
        period = Value(period),
        tradeDate = Value(tradeDate),
        open = Value(open),
        close = Value(close),
        high = Value(high),
        low = Value(low),
        volume = Value(volume),
        amount = Value(amount);
  static Insertable<KlineDataData> custom({
    Expression<String>? symbol,
    Expression<String>? marketCode,
    Expression<String>? period,
    Expression<DateTime>? tradeDate,
    Expression<double>? open,
    Expression<double>? close,
    Expression<double>? high,
    Expression<double>? low,
    Expression<double>? volume,
    Expression<double>? amount,
    Expression<double>? turnoverRate,
    Expression<double>? pe,
    Expression<double>? pb,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symbol != null) 'symbol': symbol,
      if (marketCode != null) 'market_code': marketCode,
      if (period != null) 'period': period,
      if (tradeDate != null) 'trade_date': tradeDate,
      if (open != null) 'open': open,
      if (close != null) 'close': close,
      if (high != null) 'high': high,
      if (low != null) 'low': low,
      if (volume != null) 'volume': volume,
      if (amount != null) 'amount': amount,
      if (turnoverRate != null) 'turnover_rate': turnoverRate,
      if (pe != null) 'pe': pe,
      if (pb != null) 'pb': pb,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KlineDataCompanion copyWith(
      {Value<String>? symbol,
      Value<String>? marketCode,
      Value<String>? period,
      Value<DateTime>? tradeDate,
      Value<double>? open,
      Value<double>? close,
      Value<double>? high,
      Value<double>? low,
      Value<double>? volume,
      Value<double>? amount,
      Value<double?>? turnoverRate,
      Value<double?>? pe,
      Value<double?>? pb,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return KlineDataCompanion(
      symbol: symbol ?? this.symbol,
      marketCode: marketCode ?? this.marketCode,
      period: period ?? this.period,
      tradeDate: tradeDate ?? this.tradeDate,
      open: open ?? this.open,
      close: close ?? this.close,
      high: high ?? this.high,
      low: low ?? this.low,
      volume: volume ?? this.volume,
      amount: amount ?? this.amount,
      turnoverRate: turnoverRate ?? this.turnoverRate,
      pe: pe ?? this.pe,
      pb: pb ?? this.pb,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (marketCode.present) {
      map['market_code'] = Variable<String>(marketCode.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (tradeDate.present) {
      map['trade_date'] = Variable<DateTime>(tradeDate.value);
    }
    if (open.present) {
      map['open'] = Variable<double>(open.value);
    }
    if (close.present) {
      map['close'] = Variable<double>(close.value);
    }
    if (high.present) {
      map['high'] = Variable<double>(high.value);
    }
    if (low.present) {
      map['low'] = Variable<double>(low.value);
    }
    if (volume.present) {
      map['volume'] = Variable<double>(volume.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (turnoverRate.present) {
      map['turnover_rate'] = Variable<double>(turnoverRate.value);
    }
    if (pe.present) {
      map['pe'] = Variable<double>(pe.value);
    }
    if (pb.present) {
      map['pb'] = Variable<double>(pb.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KlineDataCompanion(')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('period: $period, ')
          ..write('tradeDate: $tradeDate, ')
          ..write('open: $open, ')
          ..write('close: $close, ')
          ..write('high: $high, ')
          ..write('low: $low, ')
          ..write('volume: $volume, ')
          ..write('amount: $amount, ')
          ..write('turnoverRate: $turnoverRate, ')
          ..write('pe: $pe, ')
          ..write('pb: $pb, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockFilterResultsTable extends StockFilterResults
    with TableInfo<$StockFilterResultsTable, StockFilterResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockFilterResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _filterDateMeta =
      const VerificationMeta('filterDate');
  @override
  late final GeneratedColumn<DateTime> filterDate = GeneratedColumn<DateTime>(
      'filter_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _conditionTypeMeta =
      const VerificationMeta('conditionType');
  @override
  late final GeneratedColumn<String> conditionType = GeneratedColumn<String>(
      'condition_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _marketCodeMeta =
      const VerificationMeta('marketCode');
  @override
  late final GeneratedColumn<String> marketCode = GeneratedColumn<String>(
      'market_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _symbolNameMeta =
      const VerificationMeta('symbolName');
  @override
  late final GeneratedColumn<String> symbolName = GeneratedColumn<String>(
      'symbol_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _closePriceMeta =
      const VerificationMeta('closePrice');
  @override
  late final GeneratedColumn<double> closePrice = GeneratedColumn<double>(
      'close_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _changePercentMeta =
      const VerificationMeta('changePercent');
  @override
  late final GeneratedColumn<double> changePercent = GeneratedColumn<double>(
      'change_percent', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _extraDataMeta =
      const VerificationMeta('extraData');
  @override
  late final GeneratedColumn<String> extraData = GeneratedColumn<String>(
      'extra_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        filterDate,
        conditionType,
        symbol,
        marketCode,
        symbolName,
        closePrice,
        changePercent,
        extraData,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_filter_results';
  @override
  VerificationContext validateIntegrity(Insertable<StockFilterResult> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('filter_date')) {
      context.handle(
          _filterDateMeta,
          filterDate.isAcceptableOrUnknown(
              data['filter_date']!, _filterDateMeta));
    } else if (isInserting) {
      context.missing(_filterDateMeta);
    }
    if (data.containsKey('condition_type')) {
      context.handle(
          _conditionTypeMeta,
          conditionType.isAcceptableOrUnknown(
              data['condition_type']!, _conditionTypeMeta));
    } else if (isInserting) {
      context.missing(_conditionTypeMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('market_code')) {
      context.handle(
          _marketCodeMeta,
          marketCode.isAcceptableOrUnknown(
              data['market_code']!, _marketCodeMeta));
    } else if (isInserting) {
      context.missing(_marketCodeMeta);
    }
    if (data.containsKey('symbol_name')) {
      context.handle(
          _symbolNameMeta,
          symbolName.isAcceptableOrUnknown(
              data['symbol_name']!, _symbolNameMeta));
    } else if (isInserting) {
      context.missing(_symbolNameMeta);
    }
    if (data.containsKey('close_price')) {
      context.handle(
          _closePriceMeta,
          closePrice.isAcceptableOrUnknown(
              data['close_price']!, _closePriceMeta));
    } else if (isInserting) {
      context.missing(_closePriceMeta);
    }
    if (data.containsKey('change_percent')) {
      context.handle(
          _changePercentMeta,
          changePercent.isAcceptableOrUnknown(
              data['change_percent']!, _changePercentMeta));
    } else if (isInserting) {
      context.missing(_changePercentMeta);
    }
    if (data.containsKey('extra_data')) {
      context.handle(_extraDataMeta,
          extraData.isAcceptableOrUnknown(data['extra_data']!, _extraDataMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockFilterResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockFilterResult(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      filterDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}filter_date'])!,
      conditionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condition_type'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      marketCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market_code'])!,
      symbolName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol_name'])!,
      closePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}close_price'])!,
      changePercent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}change_percent'])!,
      extraData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra_data']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $StockFilterResultsTable createAlias(String alias) {
    return $StockFilterResultsTable(attachedDatabase, alias);
  }
}

class StockFilterResult extends DataClass
    implements Insertable<StockFilterResult> {
  final int id;
  final DateTime filterDate;
  final String conditionType;
  final String symbol;
  final String marketCode;
  final String symbolName;
  final double closePrice;
  final double changePercent;
  final String? extraData;
  final DateTime createdAt;
  const StockFilterResult(
      {required this.id,
      required this.filterDate,
      required this.conditionType,
      required this.symbol,
      required this.marketCode,
      required this.symbolName,
      required this.closePrice,
      required this.changePercent,
      this.extraData,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['filter_date'] = Variable<DateTime>(filterDate);
    map['condition_type'] = Variable<String>(conditionType);
    map['symbol'] = Variable<String>(symbol);
    map['market_code'] = Variable<String>(marketCode);
    map['symbol_name'] = Variable<String>(symbolName);
    map['close_price'] = Variable<double>(closePrice);
    map['change_percent'] = Variable<double>(changePercent);
    if (!nullToAbsent || extraData != null) {
      map['extra_data'] = Variable<String>(extraData);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockFilterResultsCompanion toCompanion(bool nullToAbsent) {
    return StockFilterResultsCompanion(
      id: Value(id),
      filterDate: Value(filterDate),
      conditionType: Value(conditionType),
      symbol: Value(symbol),
      marketCode: Value(marketCode),
      symbolName: Value(symbolName),
      closePrice: Value(closePrice),
      changePercent: Value(changePercent),
      extraData: extraData == null && nullToAbsent
          ? const Value.absent()
          : Value(extraData),
      createdAt: Value(createdAt),
    );
  }

  factory StockFilterResult.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockFilterResult(
      id: serializer.fromJson<int>(json['id']),
      filterDate: serializer.fromJson<DateTime>(json['filterDate']),
      conditionType: serializer.fromJson<String>(json['conditionType']),
      symbol: serializer.fromJson<String>(json['symbol']),
      marketCode: serializer.fromJson<String>(json['marketCode']),
      symbolName: serializer.fromJson<String>(json['symbolName']),
      closePrice: serializer.fromJson<double>(json['closePrice']),
      changePercent: serializer.fromJson<double>(json['changePercent']),
      extraData: serializer.fromJson<String?>(json['extraData']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'filterDate': serializer.toJson<DateTime>(filterDate),
      'conditionType': serializer.toJson<String>(conditionType),
      'symbol': serializer.toJson<String>(symbol),
      'marketCode': serializer.toJson<String>(marketCode),
      'symbolName': serializer.toJson<String>(symbolName),
      'closePrice': serializer.toJson<double>(closePrice),
      'changePercent': serializer.toJson<double>(changePercent),
      'extraData': serializer.toJson<String?>(extraData),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockFilterResult copyWith(
          {int? id,
          DateTime? filterDate,
          String? conditionType,
          String? symbol,
          String? marketCode,
          String? symbolName,
          double? closePrice,
          double? changePercent,
          Value<String?> extraData = const Value.absent(),
          DateTime? createdAt}) =>
      StockFilterResult(
        id: id ?? this.id,
        filterDate: filterDate ?? this.filterDate,
        conditionType: conditionType ?? this.conditionType,
        symbol: symbol ?? this.symbol,
        marketCode: marketCode ?? this.marketCode,
        symbolName: symbolName ?? this.symbolName,
        closePrice: closePrice ?? this.closePrice,
        changePercent: changePercent ?? this.changePercent,
        extraData: extraData.present ? extraData.value : this.extraData,
        createdAt: createdAt ?? this.createdAt,
      );
  StockFilterResult copyWithCompanion(StockFilterResultsCompanion data) {
    return StockFilterResult(
      id: data.id.present ? data.id.value : this.id,
      filterDate:
          data.filterDate.present ? data.filterDate.value : this.filterDate,
      conditionType: data.conditionType.present
          ? data.conditionType.value
          : this.conditionType,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      marketCode:
          data.marketCode.present ? data.marketCode.value : this.marketCode,
      symbolName:
          data.symbolName.present ? data.symbolName.value : this.symbolName,
      closePrice:
          data.closePrice.present ? data.closePrice.value : this.closePrice,
      changePercent: data.changePercent.present
          ? data.changePercent.value
          : this.changePercent,
      extraData: data.extraData.present ? data.extraData.value : this.extraData,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockFilterResult(')
          ..write('id: $id, ')
          ..write('filterDate: $filterDate, ')
          ..write('conditionType: $conditionType, ')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('symbolName: $symbolName, ')
          ..write('closePrice: $closePrice, ')
          ..write('changePercent: $changePercent, ')
          ..write('extraData: $extraData, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, filterDate, conditionType, symbol,
      marketCode, symbolName, closePrice, changePercent, extraData, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockFilterResult &&
          other.id == this.id &&
          other.filterDate == this.filterDate &&
          other.conditionType == this.conditionType &&
          other.symbol == this.symbol &&
          other.marketCode == this.marketCode &&
          other.symbolName == this.symbolName &&
          other.closePrice == this.closePrice &&
          other.changePercent == this.changePercent &&
          other.extraData == this.extraData &&
          other.createdAt == this.createdAt);
}

class StockFilterResultsCompanion extends UpdateCompanion<StockFilterResult> {
  final Value<int> id;
  final Value<DateTime> filterDate;
  final Value<String> conditionType;
  final Value<String> symbol;
  final Value<String> marketCode;
  final Value<String> symbolName;
  final Value<double> closePrice;
  final Value<double> changePercent;
  final Value<String?> extraData;
  final Value<DateTime> createdAt;
  const StockFilterResultsCompanion({
    this.id = const Value.absent(),
    this.filterDate = const Value.absent(),
    this.conditionType = const Value.absent(),
    this.symbol = const Value.absent(),
    this.marketCode = const Value.absent(),
    this.symbolName = const Value.absent(),
    this.closePrice = const Value.absent(),
    this.changePercent = const Value.absent(),
    this.extraData = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StockFilterResultsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime filterDate,
    required String conditionType,
    required String symbol,
    required String marketCode,
    required String symbolName,
    required double closePrice,
    required double changePercent,
    this.extraData = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : filterDate = Value(filterDate),
        conditionType = Value(conditionType),
        symbol = Value(symbol),
        marketCode = Value(marketCode),
        symbolName = Value(symbolName),
        closePrice = Value(closePrice),
        changePercent = Value(changePercent);
  static Insertable<StockFilterResult> custom({
    Expression<int>? id,
    Expression<DateTime>? filterDate,
    Expression<String>? conditionType,
    Expression<String>? symbol,
    Expression<String>? marketCode,
    Expression<String>? symbolName,
    Expression<double>? closePrice,
    Expression<double>? changePercent,
    Expression<String>? extraData,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (filterDate != null) 'filter_date': filterDate,
      if (conditionType != null) 'condition_type': conditionType,
      if (symbol != null) 'symbol': symbol,
      if (marketCode != null) 'market_code': marketCode,
      if (symbolName != null) 'symbol_name': symbolName,
      if (closePrice != null) 'close_price': closePrice,
      if (changePercent != null) 'change_percent': changePercent,
      if (extraData != null) 'extra_data': extraData,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StockFilterResultsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? filterDate,
      Value<String>? conditionType,
      Value<String>? symbol,
      Value<String>? marketCode,
      Value<String>? symbolName,
      Value<double>? closePrice,
      Value<double>? changePercent,
      Value<String?>? extraData,
      Value<DateTime>? createdAt}) {
    return StockFilterResultsCompanion(
      id: id ?? this.id,
      filterDate: filterDate ?? this.filterDate,
      conditionType: conditionType ?? this.conditionType,
      symbol: symbol ?? this.symbol,
      marketCode: marketCode ?? this.marketCode,
      symbolName: symbolName ?? this.symbolName,
      closePrice: closePrice ?? this.closePrice,
      changePercent: changePercent ?? this.changePercent,
      extraData: extraData ?? this.extraData,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (filterDate.present) {
      map['filter_date'] = Variable<DateTime>(filterDate.value);
    }
    if (conditionType.present) {
      map['condition_type'] = Variable<String>(conditionType.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (marketCode.present) {
      map['market_code'] = Variable<String>(marketCode.value);
    }
    if (symbolName.present) {
      map['symbol_name'] = Variable<String>(symbolName.value);
    }
    if (closePrice.present) {
      map['close_price'] = Variable<double>(closePrice.value);
    }
    if (changePercent.present) {
      map['change_percent'] = Variable<double>(changePercent.value);
    }
    if (extraData.present) {
      map['extra_data'] = Variable<String>(extraData.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockFilterResultsCompanion(')
          ..write('id: $id, ')
          ..write('filterDate: $filterDate, ')
          ..write('conditionType: $conditionType, ')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('symbolName: $symbolName, ')
          ..write('closePrice: $closePrice, ')
          ..write('changePercent: $changePercent, ')
          ..write('extraData: $extraData, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DailyStockStatsTable extends DailyStockStats
    with TableInfo<$DailyStockStatsTable, DailyStockStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyStockStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tradeDateMeta =
      const VerificationMeta('tradeDate');
  @override
  late final GeneratedColumn<DateTime> tradeDate = GeneratedColumn<DateTime>(
      'trade_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _marketCodeMeta =
      const VerificationMeta('marketCode');
  @override
  late final GeneratedColumn<String> marketCode = GeneratedColumn<String>(
      'market_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _closePriceMeta =
      const VerificationMeta('closePrice');
  @override
  late final GeneratedColumn<double> closePrice = GeneratedColumn<double>(
      'close_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _openPriceMeta =
      const VerificationMeta('openPrice');
  @override
  late final GeneratedColumn<double> openPrice = GeneratedColumn<double>(
      'open_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _highPriceMeta =
      const VerificationMeta('highPrice');
  @override
  late final GeneratedColumn<double> highPrice = GeneratedColumn<double>(
      'high_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lowPriceMeta =
      const VerificationMeta('lowPrice');
  @override
  late final GeneratedColumn<double> lowPrice = GeneratedColumn<double>(
      'low_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<double> volume = GeneratedColumn<double>(
      'volume', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _return15dMeta =
      const VerificationMeta('return15d');
  @override
  late final GeneratedColumn<double> return15d = GeneratedColumn<double>(
      'return15d', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _return30dMeta =
      const VerificationMeta('return30d');
  @override
  late final GeneratedColumn<double> return30d = GeneratedColumn<double>(
      'return30d', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ma10Meta = const VerificationMeta('ma10');
  @override
  late final GeneratedColumn<double> ma10 = GeneratedColumn<double>(
      'ma10', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ma20Meta = const VerificationMeta('ma20');
  @override
  late final GeneratedColumn<double> ma20 = GeneratedColumn<double>(
      'ma20', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ma50Meta = const VerificationMeta('ma50');
  @override
  late final GeneratedColumn<double> ma50 = GeneratedColumn<double>(
      'ma50', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ma200Meta = const VerificationMeta('ma200');
  @override
  late final GeneratedColumn<double> ma200 = GeneratedColumn<double>(
      'ma200', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _historicalHighMeta =
      const VerificationMeta('historicalHigh');
  @override
  late final GeneratedColumn<double> historicalHigh = GeneratedColumn<double>(
      'historical_high', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _historicalLowMeta =
      const VerificationMeta('historicalLow');
  @override
  late final GeneratedColumn<double> historicalLow = GeneratedColumn<double>(
      'historical_low', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _yearHighMeta =
      const VerificationMeta('yearHigh');
  @override
  late final GeneratedColumn<double> yearHigh = GeneratedColumn<double>(
      'year_high', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _yearLowMeta =
      const VerificationMeta('yearLow');
  @override
  late final GeneratedColumn<double> yearLow = GeneratedColumn<double>(
      'year_low', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isLimitUpMeta =
      const VerificationMeta('isLimitUp');
  @override
  late final GeneratedColumn<bool> isLimitUp = GeneratedColumn<bool>(
      'is_limit_up', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_limit_up" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isLimitDownMeta =
      const VerificationMeta('isLimitDown');
  @override
  late final GeneratedColumn<bool> isLimitDown = GeneratedColumn<bool>(
      'is_limit_down', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_limit_down" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _listingDaysMeta =
      const VerificationMeta('listingDays');
  @override
  late final GeneratedColumn<int> listingDays = GeneratedColumn<int>(
      'listing_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isSuspendedMeta =
      const VerificationMeta('isSuspended');
  @override
  late final GeneratedColumn<bool> isSuspended = GeneratedColumn<bool>(
      'is_suspended', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_suspended" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tradeDate,
        symbol,
        marketCode,
        closePrice,
        openPrice,
        highPrice,
        lowPrice,
        volume,
        return15d,
        return30d,
        ma10,
        ma20,
        ma50,
        ma200,
        historicalHigh,
        historicalLow,
        yearHigh,
        yearLow,
        isLimitUp,
        isLimitDown,
        listingDays,
        isSuspended,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_stock_stats';
  @override
  VerificationContext validateIntegrity(Insertable<DailyStockStat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trade_date')) {
      context.handle(_tradeDateMeta,
          tradeDate.isAcceptableOrUnknown(data['trade_date']!, _tradeDateMeta));
    } else if (isInserting) {
      context.missing(_tradeDateMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('market_code')) {
      context.handle(
          _marketCodeMeta,
          marketCode.isAcceptableOrUnknown(
              data['market_code']!, _marketCodeMeta));
    } else if (isInserting) {
      context.missing(_marketCodeMeta);
    }
    if (data.containsKey('close_price')) {
      context.handle(
          _closePriceMeta,
          closePrice.isAcceptableOrUnknown(
              data['close_price']!, _closePriceMeta));
    } else if (isInserting) {
      context.missing(_closePriceMeta);
    }
    if (data.containsKey('open_price')) {
      context.handle(_openPriceMeta,
          openPrice.isAcceptableOrUnknown(data['open_price']!, _openPriceMeta));
    } else if (isInserting) {
      context.missing(_openPriceMeta);
    }
    if (data.containsKey('high_price')) {
      context.handle(_highPriceMeta,
          highPrice.isAcceptableOrUnknown(data['high_price']!, _highPriceMeta));
    } else if (isInserting) {
      context.missing(_highPriceMeta);
    }
    if (data.containsKey('low_price')) {
      context.handle(_lowPriceMeta,
          lowPrice.isAcceptableOrUnknown(data['low_price']!, _lowPriceMeta));
    } else if (isInserting) {
      context.missing(_lowPriceMeta);
    }
    if (data.containsKey('volume')) {
      context.handle(_volumeMeta,
          volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta));
    } else if (isInserting) {
      context.missing(_volumeMeta);
    }
    if (data.containsKey('return15d')) {
      context.handle(_return15dMeta,
          return15d.isAcceptableOrUnknown(data['return15d']!, _return15dMeta));
    }
    if (data.containsKey('return30d')) {
      context.handle(_return30dMeta,
          return30d.isAcceptableOrUnknown(data['return30d']!, _return30dMeta));
    }
    if (data.containsKey('ma10')) {
      context.handle(
          _ma10Meta, ma10.isAcceptableOrUnknown(data['ma10']!, _ma10Meta));
    }
    if (data.containsKey('ma20')) {
      context.handle(
          _ma20Meta, ma20.isAcceptableOrUnknown(data['ma20']!, _ma20Meta));
    }
    if (data.containsKey('ma50')) {
      context.handle(
          _ma50Meta, ma50.isAcceptableOrUnknown(data['ma50']!, _ma50Meta));
    }
    if (data.containsKey('ma200')) {
      context.handle(
          _ma200Meta, ma200.isAcceptableOrUnknown(data['ma200']!, _ma200Meta));
    }
    if (data.containsKey('historical_high')) {
      context.handle(
          _historicalHighMeta,
          historicalHigh.isAcceptableOrUnknown(
              data['historical_high']!, _historicalHighMeta));
    }
    if (data.containsKey('historical_low')) {
      context.handle(
          _historicalLowMeta,
          historicalLow.isAcceptableOrUnknown(
              data['historical_low']!, _historicalLowMeta));
    }
    if (data.containsKey('year_high')) {
      context.handle(_yearHighMeta,
          yearHigh.isAcceptableOrUnknown(data['year_high']!, _yearHighMeta));
    }
    if (data.containsKey('year_low')) {
      context.handle(_yearLowMeta,
          yearLow.isAcceptableOrUnknown(data['year_low']!, _yearLowMeta));
    }
    if (data.containsKey('is_limit_up')) {
      context.handle(
          _isLimitUpMeta,
          isLimitUp.isAcceptableOrUnknown(
              data['is_limit_up']!, _isLimitUpMeta));
    }
    if (data.containsKey('is_limit_down')) {
      context.handle(
          _isLimitDownMeta,
          isLimitDown.isAcceptableOrUnknown(
              data['is_limit_down']!, _isLimitDownMeta));
    }
    if (data.containsKey('listing_days')) {
      context.handle(
          _listingDaysMeta,
          listingDays.isAcceptableOrUnknown(
              data['listing_days']!, _listingDaysMeta));
    }
    if (data.containsKey('is_suspended')) {
      context.handle(
          _isSuspendedMeta,
          isSuspended.isAcceptableOrUnknown(
              data['is_suspended']!, _isSuspendedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyStockStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyStockStat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tradeDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}trade_date'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      marketCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market_code'])!,
      closePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}close_price'])!,
      openPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}open_price'])!,
      highPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}high_price'])!,
      lowPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}low_price'])!,
      volume: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}volume'])!,
      return15d: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}return15d']),
      return30d: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}return30d']),
      ma10: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ma10']),
      ma20: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ma20']),
      ma50: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ma50']),
      ma200: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ma200']),
      historicalHigh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}historical_high']),
      historicalLow: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}historical_low']),
      yearHigh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}year_high']),
      yearLow: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}year_low']),
      isLimitUp: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_limit_up'])!,
      isLimitDown: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_limit_down'])!,
      listingDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}listing_days'])!,
      isSuspended: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_suspended'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DailyStockStatsTable createAlias(String alias) {
    return $DailyStockStatsTable(attachedDatabase, alias);
  }
}

class DailyStockStat extends DataClass implements Insertable<DailyStockStat> {
  final int id;
  final DateTime tradeDate;
  final String symbol;
  final String marketCode;
  final double closePrice;
  final double openPrice;
  final double highPrice;
  final double lowPrice;
  final double volume;
  final double? return15d;
  final double? return30d;
  final double? ma10;
  final double? ma20;
  final double? ma50;
  final double? ma200;
  final double? historicalHigh;
  final double? historicalLow;
  final double? yearHigh;
  final double? yearLow;
  final bool isLimitUp;
  final bool isLimitDown;
  final int listingDays;
  final bool isSuspended;
  final DateTime createdAt;
  const DailyStockStat(
      {required this.id,
      required this.tradeDate,
      required this.symbol,
      required this.marketCode,
      required this.closePrice,
      required this.openPrice,
      required this.highPrice,
      required this.lowPrice,
      required this.volume,
      this.return15d,
      this.return30d,
      this.ma10,
      this.ma20,
      this.ma50,
      this.ma200,
      this.historicalHigh,
      this.historicalLow,
      this.yearHigh,
      this.yearLow,
      required this.isLimitUp,
      required this.isLimitDown,
      required this.listingDays,
      required this.isSuspended,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trade_date'] = Variable<DateTime>(tradeDate);
    map['symbol'] = Variable<String>(symbol);
    map['market_code'] = Variable<String>(marketCode);
    map['close_price'] = Variable<double>(closePrice);
    map['open_price'] = Variable<double>(openPrice);
    map['high_price'] = Variable<double>(highPrice);
    map['low_price'] = Variable<double>(lowPrice);
    map['volume'] = Variable<double>(volume);
    if (!nullToAbsent || return15d != null) {
      map['return15d'] = Variable<double>(return15d);
    }
    if (!nullToAbsent || return30d != null) {
      map['return30d'] = Variable<double>(return30d);
    }
    if (!nullToAbsent || ma10 != null) {
      map['ma10'] = Variable<double>(ma10);
    }
    if (!nullToAbsent || ma20 != null) {
      map['ma20'] = Variable<double>(ma20);
    }
    if (!nullToAbsent || ma50 != null) {
      map['ma50'] = Variable<double>(ma50);
    }
    if (!nullToAbsent || ma200 != null) {
      map['ma200'] = Variable<double>(ma200);
    }
    if (!nullToAbsent || historicalHigh != null) {
      map['historical_high'] = Variable<double>(historicalHigh);
    }
    if (!nullToAbsent || historicalLow != null) {
      map['historical_low'] = Variable<double>(historicalLow);
    }
    if (!nullToAbsent || yearHigh != null) {
      map['year_high'] = Variable<double>(yearHigh);
    }
    if (!nullToAbsent || yearLow != null) {
      map['year_low'] = Variable<double>(yearLow);
    }
    map['is_limit_up'] = Variable<bool>(isLimitUp);
    map['is_limit_down'] = Variable<bool>(isLimitDown);
    map['listing_days'] = Variable<int>(listingDays);
    map['is_suspended'] = Variable<bool>(isSuspended);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DailyStockStatsCompanion toCompanion(bool nullToAbsent) {
    return DailyStockStatsCompanion(
      id: Value(id),
      tradeDate: Value(tradeDate),
      symbol: Value(symbol),
      marketCode: Value(marketCode),
      closePrice: Value(closePrice),
      openPrice: Value(openPrice),
      highPrice: Value(highPrice),
      lowPrice: Value(lowPrice),
      volume: Value(volume),
      return15d: return15d == null && nullToAbsent
          ? const Value.absent()
          : Value(return15d),
      return30d: return30d == null && nullToAbsent
          ? const Value.absent()
          : Value(return30d),
      ma10: ma10 == null && nullToAbsent ? const Value.absent() : Value(ma10),
      ma20: ma20 == null && nullToAbsent ? const Value.absent() : Value(ma20),
      ma50: ma50 == null && nullToAbsent ? const Value.absent() : Value(ma50),
      ma200:
          ma200 == null && nullToAbsent ? const Value.absent() : Value(ma200),
      historicalHigh: historicalHigh == null && nullToAbsent
          ? const Value.absent()
          : Value(historicalHigh),
      historicalLow: historicalLow == null && nullToAbsent
          ? const Value.absent()
          : Value(historicalLow),
      yearHigh: yearHigh == null && nullToAbsent
          ? const Value.absent()
          : Value(yearHigh),
      yearLow: yearLow == null && nullToAbsent
          ? const Value.absent()
          : Value(yearLow),
      isLimitUp: Value(isLimitUp),
      isLimitDown: Value(isLimitDown),
      listingDays: Value(listingDays),
      isSuspended: Value(isSuspended),
      createdAt: Value(createdAt),
    );
  }

  factory DailyStockStat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyStockStat(
      id: serializer.fromJson<int>(json['id']),
      tradeDate: serializer.fromJson<DateTime>(json['tradeDate']),
      symbol: serializer.fromJson<String>(json['symbol']),
      marketCode: serializer.fromJson<String>(json['marketCode']),
      closePrice: serializer.fromJson<double>(json['closePrice']),
      openPrice: serializer.fromJson<double>(json['openPrice']),
      highPrice: serializer.fromJson<double>(json['highPrice']),
      lowPrice: serializer.fromJson<double>(json['lowPrice']),
      volume: serializer.fromJson<double>(json['volume']),
      return15d: serializer.fromJson<double?>(json['return15d']),
      return30d: serializer.fromJson<double?>(json['return30d']),
      ma10: serializer.fromJson<double?>(json['ma10']),
      ma20: serializer.fromJson<double?>(json['ma20']),
      ma50: serializer.fromJson<double?>(json['ma50']),
      ma200: serializer.fromJson<double?>(json['ma200']),
      historicalHigh: serializer.fromJson<double?>(json['historicalHigh']),
      historicalLow: serializer.fromJson<double?>(json['historicalLow']),
      yearHigh: serializer.fromJson<double?>(json['yearHigh']),
      yearLow: serializer.fromJson<double?>(json['yearLow']),
      isLimitUp: serializer.fromJson<bool>(json['isLimitUp']),
      isLimitDown: serializer.fromJson<bool>(json['isLimitDown']),
      listingDays: serializer.fromJson<int>(json['listingDays']),
      isSuspended: serializer.fromJson<bool>(json['isSuspended']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tradeDate': serializer.toJson<DateTime>(tradeDate),
      'symbol': serializer.toJson<String>(symbol),
      'marketCode': serializer.toJson<String>(marketCode),
      'closePrice': serializer.toJson<double>(closePrice),
      'openPrice': serializer.toJson<double>(openPrice),
      'highPrice': serializer.toJson<double>(highPrice),
      'lowPrice': serializer.toJson<double>(lowPrice),
      'volume': serializer.toJson<double>(volume),
      'return15d': serializer.toJson<double?>(return15d),
      'return30d': serializer.toJson<double?>(return30d),
      'ma10': serializer.toJson<double?>(ma10),
      'ma20': serializer.toJson<double?>(ma20),
      'ma50': serializer.toJson<double?>(ma50),
      'ma200': serializer.toJson<double?>(ma200),
      'historicalHigh': serializer.toJson<double?>(historicalHigh),
      'historicalLow': serializer.toJson<double?>(historicalLow),
      'yearHigh': serializer.toJson<double?>(yearHigh),
      'yearLow': serializer.toJson<double?>(yearLow),
      'isLimitUp': serializer.toJson<bool>(isLimitUp),
      'isLimitDown': serializer.toJson<bool>(isLimitDown),
      'listingDays': serializer.toJson<int>(listingDays),
      'isSuspended': serializer.toJson<bool>(isSuspended),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DailyStockStat copyWith(
          {int? id,
          DateTime? tradeDate,
          String? symbol,
          String? marketCode,
          double? closePrice,
          double? openPrice,
          double? highPrice,
          double? lowPrice,
          double? volume,
          Value<double?> return15d = const Value.absent(),
          Value<double?> return30d = const Value.absent(),
          Value<double?> ma10 = const Value.absent(),
          Value<double?> ma20 = const Value.absent(),
          Value<double?> ma50 = const Value.absent(),
          Value<double?> ma200 = const Value.absent(),
          Value<double?> historicalHigh = const Value.absent(),
          Value<double?> historicalLow = const Value.absent(),
          Value<double?> yearHigh = const Value.absent(),
          Value<double?> yearLow = const Value.absent(),
          bool? isLimitUp,
          bool? isLimitDown,
          int? listingDays,
          bool? isSuspended,
          DateTime? createdAt}) =>
      DailyStockStat(
        id: id ?? this.id,
        tradeDate: tradeDate ?? this.tradeDate,
        symbol: symbol ?? this.symbol,
        marketCode: marketCode ?? this.marketCode,
        closePrice: closePrice ?? this.closePrice,
        openPrice: openPrice ?? this.openPrice,
        highPrice: highPrice ?? this.highPrice,
        lowPrice: lowPrice ?? this.lowPrice,
        volume: volume ?? this.volume,
        return15d: return15d.present ? return15d.value : this.return15d,
        return30d: return30d.present ? return30d.value : this.return30d,
        ma10: ma10.present ? ma10.value : this.ma10,
        ma20: ma20.present ? ma20.value : this.ma20,
        ma50: ma50.present ? ma50.value : this.ma50,
        ma200: ma200.present ? ma200.value : this.ma200,
        historicalHigh:
            historicalHigh.present ? historicalHigh.value : this.historicalHigh,
        historicalLow:
            historicalLow.present ? historicalLow.value : this.historicalLow,
        yearHigh: yearHigh.present ? yearHigh.value : this.yearHigh,
        yearLow: yearLow.present ? yearLow.value : this.yearLow,
        isLimitUp: isLimitUp ?? this.isLimitUp,
        isLimitDown: isLimitDown ?? this.isLimitDown,
        listingDays: listingDays ?? this.listingDays,
        isSuspended: isSuspended ?? this.isSuspended,
        createdAt: createdAt ?? this.createdAt,
      );
  DailyStockStat copyWithCompanion(DailyStockStatsCompanion data) {
    return DailyStockStat(
      id: data.id.present ? data.id.value : this.id,
      tradeDate: data.tradeDate.present ? data.tradeDate.value : this.tradeDate,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      marketCode:
          data.marketCode.present ? data.marketCode.value : this.marketCode,
      closePrice:
          data.closePrice.present ? data.closePrice.value : this.closePrice,
      openPrice: data.openPrice.present ? data.openPrice.value : this.openPrice,
      highPrice: data.highPrice.present ? data.highPrice.value : this.highPrice,
      lowPrice: data.lowPrice.present ? data.lowPrice.value : this.lowPrice,
      volume: data.volume.present ? data.volume.value : this.volume,
      return15d: data.return15d.present ? data.return15d.value : this.return15d,
      return30d: data.return30d.present ? data.return30d.value : this.return30d,
      ma10: data.ma10.present ? data.ma10.value : this.ma10,
      ma20: data.ma20.present ? data.ma20.value : this.ma20,
      ma50: data.ma50.present ? data.ma50.value : this.ma50,
      ma200: data.ma200.present ? data.ma200.value : this.ma200,
      historicalHigh: data.historicalHigh.present
          ? data.historicalHigh.value
          : this.historicalHigh,
      historicalLow: data.historicalLow.present
          ? data.historicalLow.value
          : this.historicalLow,
      yearHigh: data.yearHigh.present ? data.yearHigh.value : this.yearHigh,
      yearLow: data.yearLow.present ? data.yearLow.value : this.yearLow,
      isLimitUp: data.isLimitUp.present ? data.isLimitUp.value : this.isLimitUp,
      isLimitDown:
          data.isLimitDown.present ? data.isLimitDown.value : this.isLimitDown,
      listingDays:
          data.listingDays.present ? data.listingDays.value : this.listingDays,
      isSuspended:
          data.isSuspended.present ? data.isSuspended.value : this.isSuspended,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyStockStat(')
          ..write('id: $id, ')
          ..write('tradeDate: $tradeDate, ')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('closePrice: $closePrice, ')
          ..write('openPrice: $openPrice, ')
          ..write('highPrice: $highPrice, ')
          ..write('lowPrice: $lowPrice, ')
          ..write('volume: $volume, ')
          ..write('return15d: $return15d, ')
          ..write('return30d: $return30d, ')
          ..write('ma10: $ma10, ')
          ..write('ma20: $ma20, ')
          ..write('ma50: $ma50, ')
          ..write('ma200: $ma200, ')
          ..write('historicalHigh: $historicalHigh, ')
          ..write('historicalLow: $historicalLow, ')
          ..write('yearHigh: $yearHigh, ')
          ..write('yearLow: $yearLow, ')
          ..write('isLimitUp: $isLimitUp, ')
          ..write('isLimitDown: $isLimitDown, ')
          ..write('listingDays: $listingDays, ')
          ..write('isSuspended: $isSuspended, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        tradeDate,
        symbol,
        marketCode,
        closePrice,
        openPrice,
        highPrice,
        lowPrice,
        volume,
        return15d,
        return30d,
        ma10,
        ma20,
        ma50,
        ma200,
        historicalHigh,
        historicalLow,
        yearHigh,
        yearLow,
        isLimitUp,
        isLimitDown,
        listingDays,
        isSuspended,
        createdAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyStockStat &&
          other.id == this.id &&
          other.tradeDate == this.tradeDate &&
          other.symbol == this.symbol &&
          other.marketCode == this.marketCode &&
          other.closePrice == this.closePrice &&
          other.openPrice == this.openPrice &&
          other.highPrice == this.highPrice &&
          other.lowPrice == this.lowPrice &&
          other.volume == this.volume &&
          other.return15d == this.return15d &&
          other.return30d == this.return30d &&
          other.ma10 == this.ma10 &&
          other.ma20 == this.ma20 &&
          other.ma50 == this.ma50 &&
          other.ma200 == this.ma200 &&
          other.historicalHigh == this.historicalHigh &&
          other.historicalLow == this.historicalLow &&
          other.yearHigh == this.yearHigh &&
          other.yearLow == this.yearLow &&
          other.isLimitUp == this.isLimitUp &&
          other.isLimitDown == this.isLimitDown &&
          other.listingDays == this.listingDays &&
          other.isSuspended == this.isSuspended &&
          other.createdAt == this.createdAt);
}

class DailyStockStatsCompanion extends UpdateCompanion<DailyStockStat> {
  final Value<int> id;
  final Value<DateTime> tradeDate;
  final Value<String> symbol;
  final Value<String> marketCode;
  final Value<double> closePrice;
  final Value<double> openPrice;
  final Value<double> highPrice;
  final Value<double> lowPrice;
  final Value<double> volume;
  final Value<double?> return15d;
  final Value<double?> return30d;
  final Value<double?> ma10;
  final Value<double?> ma20;
  final Value<double?> ma50;
  final Value<double?> ma200;
  final Value<double?> historicalHigh;
  final Value<double?> historicalLow;
  final Value<double?> yearHigh;
  final Value<double?> yearLow;
  final Value<bool> isLimitUp;
  final Value<bool> isLimitDown;
  final Value<int> listingDays;
  final Value<bool> isSuspended;
  final Value<DateTime> createdAt;
  const DailyStockStatsCompanion({
    this.id = const Value.absent(),
    this.tradeDate = const Value.absent(),
    this.symbol = const Value.absent(),
    this.marketCode = const Value.absent(),
    this.closePrice = const Value.absent(),
    this.openPrice = const Value.absent(),
    this.highPrice = const Value.absent(),
    this.lowPrice = const Value.absent(),
    this.volume = const Value.absent(),
    this.return15d = const Value.absent(),
    this.return30d = const Value.absent(),
    this.ma10 = const Value.absent(),
    this.ma20 = const Value.absent(),
    this.ma50 = const Value.absent(),
    this.ma200 = const Value.absent(),
    this.historicalHigh = const Value.absent(),
    this.historicalLow = const Value.absent(),
    this.yearHigh = const Value.absent(),
    this.yearLow = const Value.absent(),
    this.isLimitUp = const Value.absent(),
    this.isLimitDown = const Value.absent(),
    this.listingDays = const Value.absent(),
    this.isSuspended = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DailyStockStatsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime tradeDate,
    required String symbol,
    required String marketCode,
    required double closePrice,
    required double openPrice,
    required double highPrice,
    required double lowPrice,
    required double volume,
    this.return15d = const Value.absent(),
    this.return30d = const Value.absent(),
    this.ma10 = const Value.absent(),
    this.ma20 = const Value.absent(),
    this.ma50 = const Value.absent(),
    this.ma200 = const Value.absent(),
    this.historicalHigh = const Value.absent(),
    this.historicalLow = const Value.absent(),
    this.yearHigh = const Value.absent(),
    this.yearLow = const Value.absent(),
    this.isLimitUp = const Value.absent(),
    this.isLimitDown = const Value.absent(),
    this.listingDays = const Value.absent(),
    this.isSuspended = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : tradeDate = Value(tradeDate),
        symbol = Value(symbol),
        marketCode = Value(marketCode),
        closePrice = Value(closePrice),
        openPrice = Value(openPrice),
        highPrice = Value(highPrice),
        lowPrice = Value(lowPrice),
        volume = Value(volume);
  static Insertable<DailyStockStat> custom({
    Expression<int>? id,
    Expression<DateTime>? tradeDate,
    Expression<String>? symbol,
    Expression<String>? marketCode,
    Expression<double>? closePrice,
    Expression<double>? openPrice,
    Expression<double>? highPrice,
    Expression<double>? lowPrice,
    Expression<double>? volume,
    Expression<double>? return15d,
    Expression<double>? return30d,
    Expression<double>? ma10,
    Expression<double>? ma20,
    Expression<double>? ma50,
    Expression<double>? ma200,
    Expression<double>? historicalHigh,
    Expression<double>? historicalLow,
    Expression<double>? yearHigh,
    Expression<double>? yearLow,
    Expression<bool>? isLimitUp,
    Expression<bool>? isLimitDown,
    Expression<int>? listingDays,
    Expression<bool>? isSuspended,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tradeDate != null) 'trade_date': tradeDate,
      if (symbol != null) 'symbol': symbol,
      if (marketCode != null) 'market_code': marketCode,
      if (closePrice != null) 'close_price': closePrice,
      if (openPrice != null) 'open_price': openPrice,
      if (highPrice != null) 'high_price': highPrice,
      if (lowPrice != null) 'low_price': lowPrice,
      if (volume != null) 'volume': volume,
      if (return15d != null) 'return15d': return15d,
      if (return30d != null) 'return30d': return30d,
      if (ma10 != null) 'ma10': ma10,
      if (ma20 != null) 'ma20': ma20,
      if (ma50 != null) 'ma50': ma50,
      if (ma200 != null) 'ma200': ma200,
      if (historicalHigh != null) 'historical_high': historicalHigh,
      if (historicalLow != null) 'historical_low': historicalLow,
      if (yearHigh != null) 'year_high': yearHigh,
      if (yearLow != null) 'year_low': yearLow,
      if (isLimitUp != null) 'is_limit_up': isLimitUp,
      if (isLimitDown != null) 'is_limit_down': isLimitDown,
      if (listingDays != null) 'listing_days': listingDays,
      if (isSuspended != null) 'is_suspended': isSuspended,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DailyStockStatsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? tradeDate,
      Value<String>? symbol,
      Value<String>? marketCode,
      Value<double>? closePrice,
      Value<double>? openPrice,
      Value<double>? highPrice,
      Value<double>? lowPrice,
      Value<double>? volume,
      Value<double?>? return15d,
      Value<double?>? return30d,
      Value<double?>? ma10,
      Value<double?>? ma20,
      Value<double?>? ma50,
      Value<double?>? ma200,
      Value<double?>? historicalHigh,
      Value<double?>? historicalLow,
      Value<double?>? yearHigh,
      Value<double?>? yearLow,
      Value<bool>? isLimitUp,
      Value<bool>? isLimitDown,
      Value<int>? listingDays,
      Value<bool>? isSuspended,
      Value<DateTime>? createdAt}) {
    return DailyStockStatsCompanion(
      id: id ?? this.id,
      tradeDate: tradeDate ?? this.tradeDate,
      symbol: symbol ?? this.symbol,
      marketCode: marketCode ?? this.marketCode,
      closePrice: closePrice ?? this.closePrice,
      openPrice: openPrice ?? this.openPrice,
      highPrice: highPrice ?? this.highPrice,
      lowPrice: lowPrice ?? this.lowPrice,
      volume: volume ?? this.volume,
      return15d: return15d ?? this.return15d,
      return30d: return30d ?? this.return30d,
      ma10: ma10 ?? this.ma10,
      ma20: ma20 ?? this.ma20,
      ma50: ma50 ?? this.ma50,
      ma200: ma200 ?? this.ma200,
      historicalHigh: historicalHigh ?? this.historicalHigh,
      historicalLow: historicalLow ?? this.historicalLow,
      yearHigh: yearHigh ?? this.yearHigh,
      yearLow: yearLow ?? this.yearLow,
      isLimitUp: isLimitUp ?? this.isLimitUp,
      isLimitDown: isLimitDown ?? this.isLimitDown,
      listingDays: listingDays ?? this.listingDays,
      isSuspended: isSuspended ?? this.isSuspended,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tradeDate.present) {
      map['trade_date'] = Variable<DateTime>(tradeDate.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (marketCode.present) {
      map['market_code'] = Variable<String>(marketCode.value);
    }
    if (closePrice.present) {
      map['close_price'] = Variable<double>(closePrice.value);
    }
    if (openPrice.present) {
      map['open_price'] = Variable<double>(openPrice.value);
    }
    if (highPrice.present) {
      map['high_price'] = Variable<double>(highPrice.value);
    }
    if (lowPrice.present) {
      map['low_price'] = Variable<double>(lowPrice.value);
    }
    if (volume.present) {
      map['volume'] = Variable<double>(volume.value);
    }
    if (return15d.present) {
      map['return15d'] = Variable<double>(return15d.value);
    }
    if (return30d.present) {
      map['return30d'] = Variable<double>(return30d.value);
    }
    if (ma10.present) {
      map['ma10'] = Variable<double>(ma10.value);
    }
    if (ma20.present) {
      map['ma20'] = Variable<double>(ma20.value);
    }
    if (ma50.present) {
      map['ma50'] = Variable<double>(ma50.value);
    }
    if (ma200.present) {
      map['ma200'] = Variable<double>(ma200.value);
    }
    if (historicalHigh.present) {
      map['historical_high'] = Variable<double>(historicalHigh.value);
    }
    if (historicalLow.present) {
      map['historical_low'] = Variable<double>(historicalLow.value);
    }
    if (yearHigh.present) {
      map['year_high'] = Variable<double>(yearHigh.value);
    }
    if (yearLow.present) {
      map['year_low'] = Variable<double>(yearLow.value);
    }
    if (isLimitUp.present) {
      map['is_limit_up'] = Variable<bool>(isLimitUp.value);
    }
    if (isLimitDown.present) {
      map['is_limit_down'] = Variable<bool>(isLimitDown.value);
    }
    if (listingDays.present) {
      map['listing_days'] = Variable<int>(listingDays.value);
    }
    if (isSuspended.present) {
      map['is_suspended'] = Variable<bool>(isSuspended.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyStockStatsCompanion(')
          ..write('id: $id, ')
          ..write('tradeDate: $tradeDate, ')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('closePrice: $closePrice, ')
          ..write('openPrice: $openPrice, ')
          ..write('highPrice: $highPrice, ')
          ..write('lowPrice: $lowPrice, ')
          ..write('volume: $volume, ')
          ..write('return15d: $return15d, ')
          ..write('return30d: $return30d, ')
          ..write('ma10: $ma10, ')
          ..write('ma20: $ma20, ')
          ..write('ma50: $ma50, ')
          ..write('ma200: $ma200, ')
          ..write('historicalHigh: $historicalHigh, ')
          ..write('historicalLow: $historicalLow, ')
          ..write('yearHigh: $yearHigh, ')
          ..write('yearLow: $yearLow, ')
          ..write('isLimitUp: $isLimitUp, ')
          ..write('isLimitDown: $isLimitDown, ')
          ..write('listingDays: $listingDays, ')
          ..write('isSuspended: $isSuspended, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TrainingSessionsTable extends TrainingSessions
    with TableInfo<$TrainingSessionsTable, TrainingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _marketCodeMeta =
      const VerificationMeta('marketCode');
  @override
  late final GeneratedColumn<String> marketCode = GeneratedColumn<String>(
      'market_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
      'period', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _initialCapitalMeta =
      const VerificationMeta('initialCapital');
  @override
  late final GeneratedColumn<double> initialCapital = GeneratedColumn<double>(
      'initial_capital', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(100000.0));
  static const VerificationMeta _currentCapitalMeta =
      const VerificationMeta('currentCapital');
  @override
  late final GeneratedColumn<double> currentCapital = GeneratedColumn<double>(
      'current_capital', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(100000.0));
  static const VerificationMeta _totalProfitMeta =
      const VerificationMeta('totalProfit');
  @override
  late final GeneratedColumn<double> totalProfit = GeneratedColumn<double>(
      'total_profit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _profitRateMeta =
      const VerificationMeta('profitRate');
  @override
  late final GeneratedColumn<double> profitRate = GeneratedColumn<double>(
      'profit_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _tradeCountMeta =
      const VerificationMeta('tradeCount');
  @override
  late final GeneratedColumn<int> tradeCount = GeneratedColumn<int>(
      'trade_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _winCountMeta =
      const VerificationMeta('winCount');
  @override
  late final GeneratedColumn<int> winCount = GeneratedColumn<int>(
      'win_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _winRateMeta =
      const VerificationMeta('winRate');
  @override
  late final GeneratedColumn<double> winRate = GeneratedColumn<double>(
      'win_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _maxDrawdownMeta =
      const VerificationMeta('maxDrawdown');
  @override
  late final GeneratedColumn<double> maxDrawdown = GeneratedColumn<double>(
      'max_drawdown', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _avgHoldDurationMeta =
      const VerificationMeta('avgHoldDuration');
  @override
  late final GeneratedColumn<double> avgHoldDuration = GeneratedColumn<double>(
      'avg_hold_duration', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _profitLossRatioMeta =
      const VerificationMeta('profitLossRatio');
  @override
  late final GeneratedColumn<double> profitLossRatio = GeneratedColumn<double>(
      'profit_loss_ratio', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _conditionOrderCountMeta =
      const VerificationMeta('conditionOrderCount');
  @override
  late final GeneratedColumn<int> conditionOrderCount = GeneratedColumn<int>(
      'condition_order_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _conditionOrderTriggeredMeta =
      const VerificationMeta('conditionOrderTriggered');
  @override
  late final GeneratedColumn<int> conditionOrderTriggered =
      GeneratedColumn<int>('condition_order_triggered', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _strategyUsedMeta =
      const VerificationMeta('strategyUsed');
  @override
  late final GeneratedColumn<String> strategyUsed = GeneratedColumn<String>(
      'strategy_used', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        symbol,
        marketCode,
        period,
        startDate,
        endDate,
        initialCapital,
        currentCapital,
        totalProfit,
        profitRate,
        tradeCount,
        winCount,
        winRate,
        maxDrawdown,
        avgHoldDuration,
        profitLossRatio,
        conditionOrderCount,
        conditionOrderTriggered,
        strategyUsed,
        status,
        startTime,
        endTime,
        duration,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<TrainingSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('market_code')) {
      context.handle(
          _marketCodeMeta,
          marketCode.isAcceptableOrUnknown(
              data['market_code']!, _marketCodeMeta));
    } else if (isInserting) {
      context.missing(_marketCodeMeta);
    }
    if (data.containsKey('period')) {
      context.handle(_periodMeta,
          period.isAcceptableOrUnknown(data['period']!, _periodMeta));
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('initial_capital')) {
      context.handle(
          _initialCapitalMeta,
          initialCapital.isAcceptableOrUnknown(
              data['initial_capital']!, _initialCapitalMeta));
    }
    if (data.containsKey('current_capital')) {
      context.handle(
          _currentCapitalMeta,
          currentCapital.isAcceptableOrUnknown(
              data['current_capital']!, _currentCapitalMeta));
    }
    if (data.containsKey('total_profit')) {
      context.handle(
          _totalProfitMeta,
          totalProfit.isAcceptableOrUnknown(
              data['total_profit']!, _totalProfitMeta));
    }
    if (data.containsKey('profit_rate')) {
      context.handle(
          _profitRateMeta,
          profitRate.isAcceptableOrUnknown(
              data['profit_rate']!, _profitRateMeta));
    }
    if (data.containsKey('trade_count')) {
      context.handle(
          _tradeCountMeta,
          tradeCount.isAcceptableOrUnknown(
              data['trade_count']!, _tradeCountMeta));
    }
    if (data.containsKey('win_count')) {
      context.handle(_winCountMeta,
          winCount.isAcceptableOrUnknown(data['win_count']!, _winCountMeta));
    }
    if (data.containsKey('win_rate')) {
      context.handle(_winRateMeta,
          winRate.isAcceptableOrUnknown(data['win_rate']!, _winRateMeta));
    }
    if (data.containsKey('max_drawdown')) {
      context.handle(
          _maxDrawdownMeta,
          maxDrawdown.isAcceptableOrUnknown(
              data['max_drawdown']!, _maxDrawdownMeta));
    }
    if (data.containsKey('avg_hold_duration')) {
      context.handle(
          _avgHoldDurationMeta,
          avgHoldDuration.isAcceptableOrUnknown(
              data['avg_hold_duration']!, _avgHoldDurationMeta));
    }
    if (data.containsKey('profit_loss_ratio')) {
      context.handle(
          _profitLossRatioMeta,
          profitLossRatio.isAcceptableOrUnknown(
              data['profit_loss_ratio']!, _profitLossRatioMeta));
    }
    if (data.containsKey('condition_order_count')) {
      context.handle(
          _conditionOrderCountMeta,
          conditionOrderCount.isAcceptableOrUnknown(
              data['condition_order_count']!, _conditionOrderCountMeta));
    }
    if (data.containsKey('condition_order_triggered')) {
      context.handle(
          _conditionOrderTriggeredMeta,
          conditionOrderTriggered.isAcceptableOrUnknown(
              data['condition_order_triggered']!,
              _conditionOrderTriggeredMeta));
    }
    if (data.containsKey('strategy_used')) {
      context.handle(
          _strategyUsedMeta,
          strategyUsed.isAcceptableOrUnknown(
              data['strategy_used']!, _strategyUsedMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      marketCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market_code'])!,
      period: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}period'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      initialCapital: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}initial_capital'])!,
      currentCapital: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}current_capital'])!,
      totalProfit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_profit'])!,
      profitRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}profit_rate'])!,
      tradeCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trade_count'])!,
      winCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}win_count'])!,
      winRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}win_rate'])!,
      maxDrawdown: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_drawdown'])!,
      avgHoldDuration: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}avg_hold_duration'])!,
      profitLossRatio: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}profit_loss_ratio'])!,
      conditionOrderCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}condition_order_count'])!,
      conditionOrderTriggered: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}condition_order_triggered'])!,
      strategyUsed: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}strategy_used']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time']),
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TrainingSessionsTable createAlias(String alias) {
    return $TrainingSessionsTable(attachedDatabase, alias);
  }
}

class TrainingSession extends DataClass implements Insertable<TrainingSession> {
  /// 会话ID
  final int id;

  /// 用户ID
  final int userId;

  /// 标的代码
  final String symbol;

  /// 市场代码
  final String marketCode;

  /// 周期
  final String period;

  /// 开始日期
  final DateTime startDate;

  /// 结束日期
  final DateTime endDate;

  /// 初始资金
  final double initialCapital;

  /// 当前资金
  final double currentCapital;

  /// 总盈亏
  final double totalProfit;

  /// 收益率
  final double profitRate;

  /// 交易次数
  final int tradeCount;

  /// 盈利次数
  final int winCount;

  /// 胜率
  final double winRate;

  /// 最大回撤
  final double maxDrawdown;

  /// 平均持仓时长(天)
  final double avgHoldDuration;

  /// 盈亏比
  final double profitLossRatio;

  /// 条件单数量
  final int conditionOrderCount;

  /// 条件单触发数
  final int conditionOrderTriggered;

  /// 使用的策略 (JSON)
  final String? strategyUsed;

  /// 状态: active/finished/stopped/lost
  final String status;

  /// 开始时间
  final DateTime? startTime;

  /// 结束时间
  final DateTime? endTime;

  /// 训练时长(分钟)
  final int duration;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const TrainingSession(
      {required this.id,
      required this.userId,
      required this.symbol,
      required this.marketCode,
      required this.period,
      required this.startDate,
      required this.endDate,
      required this.initialCapital,
      required this.currentCapital,
      required this.totalProfit,
      required this.profitRate,
      required this.tradeCount,
      required this.winCount,
      required this.winRate,
      required this.maxDrawdown,
      required this.avgHoldDuration,
      required this.profitLossRatio,
      required this.conditionOrderCount,
      required this.conditionOrderTriggered,
      this.strategyUsed,
      required this.status,
      this.startTime,
      this.endTime,
      required this.duration,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['symbol'] = Variable<String>(symbol);
    map['market_code'] = Variable<String>(marketCode);
    map['period'] = Variable<String>(period);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['initial_capital'] = Variable<double>(initialCapital);
    map['current_capital'] = Variable<double>(currentCapital);
    map['total_profit'] = Variable<double>(totalProfit);
    map['profit_rate'] = Variable<double>(profitRate);
    map['trade_count'] = Variable<int>(tradeCount);
    map['win_count'] = Variable<int>(winCount);
    map['win_rate'] = Variable<double>(winRate);
    map['max_drawdown'] = Variable<double>(maxDrawdown);
    map['avg_hold_duration'] = Variable<double>(avgHoldDuration);
    map['profit_loss_ratio'] = Variable<double>(profitLossRatio);
    map['condition_order_count'] = Variable<int>(conditionOrderCount);
    map['condition_order_triggered'] = Variable<int>(conditionOrderTriggered);
    if (!nullToAbsent || strategyUsed != null) {
      map['strategy_used'] = Variable<String>(strategyUsed);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<DateTime>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['duration'] = Variable<int>(duration);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TrainingSessionsCompanion toCompanion(bool nullToAbsent) {
    return TrainingSessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      symbol: Value(symbol),
      marketCode: Value(marketCode),
      period: Value(period),
      startDate: Value(startDate),
      endDate: Value(endDate),
      initialCapital: Value(initialCapital),
      currentCapital: Value(currentCapital),
      totalProfit: Value(totalProfit),
      profitRate: Value(profitRate),
      tradeCount: Value(tradeCount),
      winCount: Value(winCount),
      winRate: Value(winRate),
      maxDrawdown: Value(maxDrawdown),
      avgHoldDuration: Value(avgHoldDuration),
      profitLossRatio: Value(profitLossRatio),
      conditionOrderCount: Value(conditionOrderCount),
      conditionOrderTriggered: Value(conditionOrderTriggered),
      strategyUsed: strategyUsed == null && nullToAbsent
          ? const Value.absent()
          : Value(strategyUsed),
      status: Value(status),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      duration: Value(duration),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TrainingSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingSession(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      symbol: serializer.fromJson<String>(json['symbol']),
      marketCode: serializer.fromJson<String>(json['marketCode']),
      period: serializer.fromJson<String>(json['period']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      initialCapital: serializer.fromJson<double>(json['initialCapital']),
      currentCapital: serializer.fromJson<double>(json['currentCapital']),
      totalProfit: serializer.fromJson<double>(json['totalProfit']),
      profitRate: serializer.fromJson<double>(json['profitRate']),
      tradeCount: serializer.fromJson<int>(json['tradeCount']),
      winCount: serializer.fromJson<int>(json['winCount']),
      winRate: serializer.fromJson<double>(json['winRate']),
      maxDrawdown: serializer.fromJson<double>(json['maxDrawdown']),
      avgHoldDuration: serializer.fromJson<double>(json['avgHoldDuration']),
      profitLossRatio: serializer.fromJson<double>(json['profitLossRatio']),
      conditionOrderCount:
          serializer.fromJson<int>(json['conditionOrderCount']),
      conditionOrderTriggered:
          serializer.fromJson<int>(json['conditionOrderTriggered']),
      strategyUsed: serializer.fromJson<String?>(json['strategyUsed']),
      status: serializer.fromJson<String>(json['status']),
      startTime: serializer.fromJson<DateTime?>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      duration: serializer.fromJson<int>(json['duration']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'symbol': serializer.toJson<String>(symbol),
      'marketCode': serializer.toJson<String>(marketCode),
      'period': serializer.toJson<String>(period),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'initialCapital': serializer.toJson<double>(initialCapital),
      'currentCapital': serializer.toJson<double>(currentCapital),
      'totalProfit': serializer.toJson<double>(totalProfit),
      'profitRate': serializer.toJson<double>(profitRate),
      'tradeCount': serializer.toJson<int>(tradeCount),
      'winCount': serializer.toJson<int>(winCount),
      'winRate': serializer.toJson<double>(winRate),
      'maxDrawdown': serializer.toJson<double>(maxDrawdown),
      'avgHoldDuration': serializer.toJson<double>(avgHoldDuration),
      'profitLossRatio': serializer.toJson<double>(profitLossRatio),
      'conditionOrderCount': serializer.toJson<int>(conditionOrderCount),
      'conditionOrderTriggered':
          serializer.toJson<int>(conditionOrderTriggered),
      'strategyUsed': serializer.toJson<String?>(strategyUsed),
      'status': serializer.toJson<String>(status),
      'startTime': serializer.toJson<DateTime?>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'duration': serializer.toJson<int>(duration),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TrainingSession copyWith(
          {int? id,
          int? userId,
          String? symbol,
          String? marketCode,
          String? period,
          DateTime? startDate,
          DateTime? endDate,
          double? initialCapital,
          double? currentCapital,
          double? totalProfit,
          double? profitRate,
          int? tradeCount,
          int? winCount,
          double? winRate,
          double? maxDrawdown,
          double? avgHoldDuration,
          double? profitLossRatio,
          int? conditionOrderCount,
          int? conditionOrderTriggered,
          Value<String?> strategyUsed = const Value.absent(),
          String? status,
          Value<DateTime?> startTime = const Value.absent(),
          Value<DateTime?> endTime = const Value.absent(),
          int? duration,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TrainingSession(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        symbol: symbol ?? this.symbol,
        marketCode: marketCode ?? this.marketCode,
        period: period ?? this.period,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        initialCapital: initialCapital ?? this.initialCapital,
        currentCapital: currentCapital ?? this.currentCapital,
        totalProfit: totalProfit ?? this.totalProfit,
        profitRate: profitRate ?? this.profitRate,
        tradeCount: tradeCount ?? this.tradeCount,
        winCount: winCount ?? this.winCount,
        winRate: winRate ?? this.winRate,
        maxDrawdown: maxDrawdown ?? this.maxDrawdown,
        avgHoldDuration: avgHoldDuration ?? this.avgHoldDuration,
        profitLossRatio: profitLossRatio ?? this.profitLossRatio,
        conditionOrderCount: conditionOrderCount ?? this.conditionOrderCount,
        conditionOrderTriggered:
            conditionOrderTriggered ?? this.conditionOrderTriggered,
        strategyUsed:
            strategyUsed.present ? strategyUsed.value : this.strategyUsed,
        status: status ?? this.status,
        startTime: startTime.present ? startTime.value : this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        duration: duration ?? this.duration,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TrainingSession copyWithCompanion(TrainingSessionsCompanion data) {
    return TrainingSession(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      marketCode:
          data.marketCode.present ? data.marketCode.value : this.marketCode,
      period: data.period.present ? data.period.value : this.period,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      initialCapital: data.initialCapital.present
          ? data.initialCapital.value
          : this.initialCapital,
      currentCapital: data.currentCapital.present
          ? data.currentCapital.value
          : this.currentCapital,
      totalProfit:
          data.totalProfit.present ? data.totalProfit.value : this.totalProfit,
      profitRate:
          data.profitRate.present ? data.profitRate.value : this.profitRate,
      tradeCount:
          data.tradeCount.present ? data.tradeCount.value : this.tradeCount,
      winCount: data.winCount.present ? data.winCount.value : this.winCount,
      winRate: data.winRate.present ? data.winRate.value : this.winRate,
      maxDrawdown:
          data.maxDrawdown.present ? data.maxDrawdown.value : this.maxDrawdown,
      avgHoldDuration: data.avgHoldDuration.present
          ? data.avgHoldDuration.value
          : this.avgHoldDuration,
      profitLossRatio: data.profitLossRatio.present
          ? data.profitLossRatio.value
          : this.profitLossRatio,
      conditionOrderCount: data.conditionOrderCount.present
          ? data.conditionOrderCount.value
          : this.conditionOrderCount,
      conditionOrderTriggered: data.conditionOrderTriggered.present
          ? data.conditionOrderTriggered.value
          : this.conditionOrderTriggered,
      strategyUsed: data.strategyUsed.present
          ? data.strategyUsed.value
          : this.strategyUsed,
      status: data.status.present ? data.status.value : this.status,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      duration: data.duration.present ? data.duration.value : this.duration,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingSession(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('period: $period, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('initialCapital: $initialCapital, ')
          ..write('currentCapital: $currentCapital, ')
          ..write('totalProfit: $totalProfit, ')
          ..write('profitRate: $profitRate, ')
          ..write('tradeCount: $tradeCount, ')
          ..write('winCount: $winCount, ')
          ..write('winRate: $winRate, ')
          ..write('maxDrawdown: $maxDrawdown, ')
          ..write('avgHoldDuration: $avgHoldDuration, ')
          ..write('profitLossRatio: $profitLossRatio, ')
          ..write('conditionOrderCount: $conditionOrderCount, ')
          ..write('conditionOrderTriggered: $conditionOrderTriggered, ')
          ..write('strategyUsed: $strategyUsed, ')
          ..write('status: $status, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('duration: $duration, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        symbol,
        marketCode,
        period,
        startDate,
        endDate,
        initialCapital,
        currentCapital,
        totalProfit,
        profitRate,
        tradeCount,
        winCount,
        winRate,
        maxDrawdown,
        avgHoldDuration,
        profitLossRatio,
        conditionOrderCount,
        conditionOrderTriggered,
        strategyUsed,
        status,
        startTime,
        endTime,
        duration,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingSession &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.symbol == this.symbol &&
          other.marketCode == this.marketCode &&
          other.period == this.period &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.initialCapital == this.initialCapital &&
          other.currentCapital == this.currentCapital &&
          other.totalProfit == this.totalProfit &&
          other.profitRate == this.profitRate &&
          other.tradeCount == this.tradeCount &&
          other.winCount == this.winCount &&
          other.winRate == this.winRate &&
          other.maxDrawdown == this.maxDrawdown &&
          other.avgHoldDuration == this.avgHoldDuration &&
          other.profitLossRatio == this.profitLossRatio &&
          other.conditionOrderCount == this.conditionOrderCount &&
          other.conditionOrderTriggered == this.conditionOrderTriggered &&
          other.strategyUsed == this.strategyUsed &&
          other.status == this.status &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.duration == this.duration &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TrainingSessionsCompanion extends UpdateCompanion<TrainingSession> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> symbol;
  final Value<String> marketCode;
  final Value<String> period;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<double> initialCapital;
  final Value<double> currentCapital;
  final Value<double> totalProfit;
  final Value<double> profitRate;
  final Value<int> tradeCount;
  final Value<int> winCount;
  final Value<double> winRate;
  final Value<double> maxDrawdown;
  final Value<double> avgHoldDuration;
  final Value<double> profitLossRatio;
  final Value<int> conditionOrderCount;
  final Value<int> conditionOrderTriggered;
  final Value<String?> strategyUsed;
  final Value<String> status;
  final Value<DateTime?> startTime;
  final Value<DateTime?> endTime;
  final Value<int> duration;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TrainingSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.symbol = const Value.absent(),
    this.marketCode = const Value.absent(),
    this.period = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.initialCapital = const Value.absent(),
    this.currentCapital = const Value.absent(),
    this.totalProfit = const Value.absent(),
    this.profitRate = const Value.absent(),
    this.tradeCount = const Value.absent(),
    this.winCount = const Value.absent(),
    this.winRate = const Value.absent(),
    this.maxDrawdown = const Value.absent(),
    this.avgHoldDuration = const Value.absent(),
    this.profitLossRatio = const Value.absent(),
    this.conditionOrderCount = const Value.absent(),
    this.conditionOrderTriggered = const Value.absent(),
    this.strategyUsed = const Value.absent(),
    this.status = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TrainingSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String symbol,
    required String marketCode,
    required String period,
    required DateTime startDate,
    required DateTime endDate,
    this.initialCapital = const Value.absent(),
    this.currentCapital = const Value.absent(),
    this.totalProfit = const Value.absent(),
    this.profitRate = const Value.absent(),
    this.tradeCount = const Value.absent(),
    this.winCount = const Value.absent(),
    this.winRate = const Value.absent(),
    this.maxDrawdown = const Value.absent(),
    this.avgHoldDuration = const Value.absent(),
    this.profitLossRatio = const Value.absent(),
    this.conditionOrderCount = const Value.absent(),
    this.conditionOrderTriggered = const Value.absent(),
    this.strategyUsed = const Value.absent(),
    required String status,
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : userId = Value(userId),
        symbol = Value(symbol),
        marketCode = Value(marketCode),
        period = Value(period),
        startDate = Value(startDate),
        endDate = Value(endDate),
        status = Value(status);
  static Insertable<TrainingSession> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? symbol,
    Expression<String>? marketCode,
    Expression<String>? period,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<double>? initialCapital,
    Expression<double>? currentCapital,
    Expression<double>? totalProfit,
    Expression<double>? profitRate,
    Expression<int>? tradeCount,
    Expression<int>? winCount,
    Expression<double>? winRate,
    Expression<double>? maxDrawdown,
    Expression<double>? avgHoldDuration,
    Expression<double>? profitLossRatio,
    Expression<int>? conditionOrderCount,
    Expression<int>? conditionOrderTriggered,
    Expression<String>? strategyUsed,
    Expression<String>? status,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? duration,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (symbol != null) 'symbol': symbol,
      if (marketCode != null) 'market_code': marketCode,
      if (period != null) 'period': period,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (initialCapital != null) 'initial_capital': initialCapital,
      if (currentCapital != null) 'current_capital': currentCapital,
      if (totalProfit != null) 'total_profit': totalProfit,
      if (profitRate != null) 'profit_rate': profitRate,
      if (tradeCount != null) 'trade_count': tradeCount,
      if (winCount != null) 'win_count': winCount,
      if (winRate != null) 'win_rate': winRate,
      if (maxDrawdown != null) 'max_drawdown': maxDrawdown,
      if (avgHoldDuration != null) 'avg_hold_duration': avgHoldDuration,
      if (profitLossRatio != null) 'profit_loss_ratio': profitLossRatio,
      if (conditionOrderCount != null)
        'condition_order_count': conditionOrderCount,
      if (conditionOrderTriggered != null)
        'condition_order_triggered': conditionOrderTriggered,
      if (strategyUsed != null) 'strategy_used': strategyUsed,
      if (status != null) 'status': status,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (duration != null) 'duration': duration,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TrainingSessionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<String>? symbol,
      Value<String>? marketCode,
      Value<String>? period,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<double>? initialCapital,
      Value<double>? currentCapital,
      Value<double>? totalProfit,
      Value<double>? profitRate,
      Value<int>? tradeCount,
      Value<int>? winCount,
      Value<double>? winRate,
      Value<double>? maxDrawdown,
      Value<double>? avgHoldDuration,
      Value<double>? profitLossRatio,
      Value<int>? conditionOrderCount,
      Value<int>? conditionOrderTriggered,
      Value<String?>? strategyUsed,
      Value<String>? status,
      Value<DateTime?>? startTime,
      Value<DateTime?>? endTime,
      Value<int>? duration,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return TrainingSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      symbol: symbol ?? this.symbol,
      marketCode: marketCode ?? this.marketCode,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      initialCapital: initialCapital ?? this.initialCapital,
      currentCapital: currentCapital ?? this.currentCapital,
      totalProfit: totalProfit ?? this.totalProfit,
      profitRate: profitRate ?? this.profitRate,
      tradeCount: tradeCount ?? this.tradeCount,
      winCount: winCount ?? this.winCount,
      winRate: winRate ?? this.winRate,
      maxDrawdown: maxDrawdown ?? this.maxDrawdown,
      avgHoldDuration: avgHoldDuration ?? this.avgHoldDuration,
      profitLossRatio: profitLossRatio ?? this.profitLossRatio,
      conditionOrderCount: conditionOrderCount ?? this.conditionOrderCount,
      conditionOrderTriggered:
          conditionOrderTriggered ?? this.conditionOrderTriggered,
      strategyUsed: strategyUsed ?? this.strategyUsed,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (marketCode.present) {
      map['market_code'] = Variable<String>(marketCode.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (initialCapital.present) {
      map['initial_capital'] = Variable<double>(initialCapital.value);
    }
    if (currentCapital.present) {
      map['current_capital'] = Variable<double>(currentCapital.value);
    }
    if (totalProfit.present) {
      map['total_profit'] = Variable<double>(totalProfit.value);
    }
    if (profitRate.present) {
      map['profit_rate'] = Variable<double>(profitRate.value);
    }
    if (tradeCount.present) {
      map['trade_count'] = Variable<int>(tradeCount.value);
    }
    if (winCount.present) {
      map['win_count'] = Variable<int>(winCount.value);
    }
    if (winRate.present) {
      map['win_rate'] = Variable<double>(winRate.value);
    }
    if (maxDrawdown.present) {
      map['max_drawdown'] = Variable<double>(maxDrawdown.value);
    }
    if (avgHoldDuration.present) {
      map['avg_hold_duration'] = Variable<double>(avgHoldDuration.value);
    }
    if (profitLossRatio.present) {
      map['profit_loss_ratio'] = Variable<double>(profitLossRatio.value);
    }
    if (conditionOrderCount.present) {
      map['condition_order_count'] = Variable<int>(conditionOrderCount.value);
    }
    if (conditionOrderTriggered.present) {
      map['condition_order_triggered'] =
          Variable<int>(conditionOrderTriggered.value);
    }
    if (strategyUsed.present) {
      map['strategy_used'] = Variable<String>(strategyUsed.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('period: $period, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('initialCapital: $initialCapital, ')
          ..write('currentCapital: $currentCapital, ')
          ..write('totalProfit: $totalProfit, ')
          ..write('profitRate: $profitRate, ')
          ..write('tradeCount: $tradeCount, ')
          ..write('winCount: $winCount, ')
          ..write('winRate: $winRate, ')
          ..write('maxDrawdown: $maxDrawdown, ')
          ..write('avgHoldDuration: $avgHoldDuration, ')
          ..write('profitLossRatio: $profitLossRatio, ')
          ..write('conditionOrderCount: $conditionOrderCount, ')
          ..write('conditionOrderTriggered: $conditionOrderTriggered, ')
          ..write('strategyUsed: $strategyUsed, ')
          ..write('status: $status, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('duration: $duration, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PositionsTable extends Positions
    with TableInfo<$PositionsTable, Position> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PositionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES training_sessions (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _marketCodeMeta =
      const VerificationMeta('marketCode');
  @override
  late final GeneratedColumn<String> marketCode = GeneratedColumn<String>(
      'market_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _avgCostMeta =
      const VerificationMeta('avgCost');
  @override
  late final GeneratedColumn<double> avgCost = GeneratedColumn<double>(
      'avg_cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currentPriceMeta =
      const VerificationMeta('currentPrice');
  @override
  late final GeneratedColumn<double> currentPrice = GeneratedColumn<double>(
      'current_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _profitLossMeta =
      const VerificationMeta('profitLoss');
  @override
  late final GeneratedColumn<double> profitLoss = GeneratedColumn<double>(
      'profit_loss', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _profitLossRateMeta =
      const VerificationMeta('profitLossRate');
  @override
  late final GeneratedColumn<double> profitLossRate = GeneratedColumn<double>(
      'profit_loss_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _openTimeMeta =
      const VerificationMeta('openTime');
  @override
  late final GeneratedColumn<DateTime> openTime = GeneratedColumn<DateTime>(
      'open_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _closeTimeMeta =
      const VerificationMeta('closeTime');
  @override
  late final GeneratedColumn<DateTime> closeTime = GeneratedColumn<DateTime>(
      'close_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        userId,
        symbol,
        marketCode,
        quantity,
        avgCost,
        currentPrice,
        profitLoss,
        profitLossRate,
        openTime,
        closeTime,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'positions';
  @override
  VerificationContext validateIntegrity(Insertable<Position> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('market_code')) {
      context.handle(
          _marketCodeMeta,
          marketCode.isAcceptableOrUnknown(
              data['market_code']!, _marketCodeMeta));
    } else if (isInserting) {
      context.missing(_marketCodeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('avg_cost')) {
      context.handle(_avgCostMeta,
          avgCost.isAcceptableOrUnknown(data['avg_cost']!, _avgCostMeta));
    } else if (isInserting) {
      context.missing(_avgCostMeta);
    }
    if (data.containsKey('current_price')) {
      context.handle(
          _currentPriceMeta,
          currentPrice.isAcceptableOrUnknown(
              data['current_price']!, _currentPriceMeta));
    } else if (isInserting) {
      context.missing(_currentPriceMeta);
    }
    if (data.containsKey('profit_loss')) {
      context.handle(
          _profitLossMeta,
          profitLoss.isAcceptableOrUnknown(
              data['profit_loss']!, _profitLossMeta));
    } else if (isInserting) {
      context.missing(_profitLossMeta);
    }
    if (data.containsKey('profit_loss_rate')) {
      context.handle(
          _profitLossRateMeta,
          profitLossRate.isAcceptableOrUnknown(
              data['profit_loss_rate']!, _profitLossRateMeta));
    } else if (isInserting) {
      context.missing(_profitLossRateMeta);
    }
    if (data.containsKey('open_time')) {
      context.handle(_openTimeMeta,
          openTime.isAcceptableOrUnknown(data['open_time']!, _openTimeMeta));
    } else if (isInserting) {
      context.missing(_openTimeMeta);
    }
    if (data.containsKey('close_time')) {
      context.handle(_closeTimeMeta,
          closeTime.isAcceptableOrUnknown(data['close_time']!, _closeTimeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Position map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Position(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      marketCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market_code'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      avgCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_cost'])!,
      currentPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_price'])!,
      profitLoss: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}profit_loss'])!,
      profitLossRate: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}profit_loss_rate'])!,
      openTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}open_time'])!,
      closeTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}close_time']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PositionsTable createAlias(String alias) {
    return $PositionsTable(attachedDatabase, alias);
  }
}

class Position extends DataClass implements Insertable<Position> {
  /// 持仓ID
  final int id;

  /// 会话ID
  final int sessionId;

  /// 用户ID
  final int userId;

  /// 标的代码
  final String symbol;

  /// 市场代码
  final String marketCode;

  /// 持仓数量
  final int quantity;

  /// 平均成本
  final double avgCost;

  /// 当前价格
  final double currentPrice;

  /// 浮动盈亏
  final double profitLoss;

  /// 浮动盈亏率
  final double profitLossRate;

  /// 开仓时间
  final DateTime openTime;

  /// 平仓时间
  final DateTime? closeTime;

  /// 状态: open/closed/forced_close
  final String status;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const Position(
      {required this.id,
      required this.sessionId,
      required this.userId,
      required this.symbol,
      required this.marketCode,
      required this.quantity,
      required this.avgCost,
      required this.currentPrice,
      required this.profitLoss,
      required this.profitLossRate,
      required this.openTime,
      this.closeTime,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['user_id'] = Variable<int>(userId);
    map['symbol'] = Variable<String>(symbol);
    map['market_code'] = Variable<String>(marketCode);
    map['quantity'] = Variable<int>(quantity);
    map['avg_cost'] = Variable<double>(avgCost);
    map['current_price'] = Variable<double>(currentPrice);
    map['profit_loss'] = Variable<double>(profitLoss);
    map['profit_loss_rate'] = Variable<double>(profitLossRate);
    map['open_time'] = Variable<DateTime>(openTime);
    if (!nullToAbsent || closeTime != null) {
      map['close_time'] = Variable<DateTime>(closeTime);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PositionsCompanion toCompanion(bool nullToAbsent) {
    return PositionsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      userId: Value(userId),
      symbol: Value(symbol),
      marketCode: Value(marketCode),
      quantity: Value(quantity),
      avgCost: Value(avgCost),
      currentPrice: Value(currentPrice),
      profitLoss: Value(profitLoss),
      profitLossRate: Value(profitLossRate),
      openTime: Value(openTime),
      closeTime: closeTime == null && nullToAbsent
          ? const Value.absent()
          : Value(closeTime),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Position.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Position(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      userId: serializer.fromJson<int>(json['userId']),
      symbol: serializer.fromJson<String>(json['symbol']),
      marketCode: serializer.fromJson<String>(json['marketCode']),
      quantity: serializer.fromJson<int>(json['quantity']),
      avgCost: serializer.fromJson<double>(json['avgCost']),
      currentPrice: serializer.fromJson<double>(json['currentPrice']),
      profitLoss: serializer.fromJson<double>(json['profitLoss']),
      profitLossRate: serializer.fromJson<double>(json['profitLossRate']),
      openTime: serializer.fromJson<DateTime>(json['openTime']),
      closeTime: serializer.fromJson<DateTime?>(json['closeTime']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'userId': serializer.toJson<int>(userId),
      'symbol': serializer.toJson<String>(symbol),
      'marketCode': serializer.toJson<String>(marketCode),
      'quantity': serializer.toJson<int>(quantity),
      'avgCost': serializer.toJson<double>(avgCost),
      'currentPrice': serializer.toJson<double>(currentPrice),
      'profitLoss': serializer.toJson<double>(profitLoss),
      'profitLossRate': serializer.toJson<double>(profitLossRate),
      'openTime': serializer.toJson<DateTime>(openTime),
      'closeTime': serializer.toJson<DateTime?>(closeTime),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Position copyWith(
          {int? id,
          int? sessionId,
          int? userId,
          String? symbol,
          String? marketCode,
          int? quantity,
          double? avgCost,
          double? currentPrice,
          double? profitLoss,
          double? profitLossRate,
          DateTime? openTime,
          Value<DateTime?> closeTime = const Value.absent(),
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Position(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        userId: userId ?? this.userId,
        symbol: symbol ?? this.symbol,
        marketCode: marketCode ?? this.marketCode,
        quantity: quantity ?? this.quantity,
        avgCost: avgCost ?? this.avgCost,
        currentPrice: currentPrice ?? this.currentPrice,
        profitLoss: profitLoss ?? this.profitLoss,
        profitLossRate: profitLossRate ?? this.profitLossRate,
        openTime: openTime ?? this.openTime,
        closeTime: closeTime.present ? closeTime.value : this.closeTime,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Position copyWithCompanion(PositionsCompanion data) {
    return Position(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      userId: data.userId.present ? data.userId.value : this.userId,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      marketCode:
          data.marketCode.present ? data.marketCode.value : this.marketCode,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      avgCost: data.avgCost.present ? data.avgCost.value : this.avgCost,
      currentPrice: data.currentPrice.present
          ? data.currentPrice.value
          : this.currentPrice,
      profitLoss:
          data.profitLoss.present ? data.profitLoss.value : this.profitLoss,
      profitLossRate: data.profitLossRate.present
          ? data.profitLossRate.value
          : this.profitLossRate,
      openTime: data.openTime.present ? data.openTime.value : this.openTime,
      closeTime: data.closeTime.present ? data.closeTime.value : this.closeTime,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Position(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('quantity: $quantity, ')
          ..write('avgCost: $avgCost, ')
          ..write('currentPrice: $currentPrice, ')
          ..write('profitLoss: $profitLoss, ')
          ..write('profitLossRate: $profitLossRate, ')
          ..write('openTime: $openTime, ')
          ..write('closeTime: $closeTime, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      sessionId,
      userId,
      symbol,
      marketCode,
      quantity,
      avgCost,
      currentPrice,
      profitLoss,
      profitLossRate,
      openTime,
      closeTime,
      status,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Position &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.userId == this.userId &&
          other.symbol == this.symbol &&
          other.marketCode == this.marketCode &&
          other.quantity == this.quantity &&
          other.avgCost == this.avgCost &&
          other.currentPrice == this.currentPrice &&
          other.profitLoss == this.profitLoss &&
          other.profitLossRate == this.profitLossRate &&
          other.openTime == this.openTime &&
          other.closeTime == this.closeTime &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PositionsCompanion extends UpdateCompanion<Position> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> userId;
  final Value<String> symbol;
  final Value<String> marketCode;
  final Value<int> quantity;
  final Value<double> avgCost;
  final Value<double> currentPrice;
  final Value<double> profitLoss;
  final Value<double> profitLossRate;
  final Value<DateTime> openTime;
  final Value<DateTime?> closeTime;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PositionsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.userId = const Value.absent(),
    this.symbol = const Value.absent(),
    this.marketCode = const Value.absent(),
    this.quantity = const Value.absent(),
    this.avgCost = const Value.absent(),
    this.currentPrice = const Value.absent(),
    this.profitLoss = const Value.absent(),
    this.profitLossRate = const Value.absent(),
    this.openTime = const Value.absent(),
    this.closeTime = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PositionsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int userId,
    required String symbol,
    required String marketCode,
    required int quantity,
    required double avgCost,
    required double currentPrice,
    required double profitLoss,
    required double profitLossRate,
    required DateTime openTime,
    this.closeTime = const Value.absent(),
    required String status,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : sessionId = Value(sessionId),
        userId = Value(userId),
        symbol = Value(symbol),
        marketCode = Value(marketCode),
        quantity = Value(quantity),
        avgCost = Value(avgCost),
        currentPrice = Value(currentPrice),
        profitLoss = Value(profitLoss),
        profitLossRate = Value(profitLossRate),
        openTime = Value(openTime),
        status = Value(status);
  static Insertable<Position> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? userId,
    Expression<String>? symbol,
    Expression<String>? marketCode,
    Expression<int>? quantity,
    Expression<double>? avgCost,
    Expression<double>? currentPrice,
    Expression<double>? profitLoss,
    Expression<double>? profitLossRate,
    Expression<DateTime>? openTime,
    Expression<DateTime>? closeTime,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (userId != null) 'user_id': userId,
      if (symbol != null) 'symbol': symbol,
      if (marketCode != null) 'market_code': marketCode,
      if (quantity != null) 'quantity': quantity,
      if (avgCost != null) 'avg_cost': avgCost,
      if (currentPrice != null) 'current_price': currentPrice,
      if (profitLoss != null) 'profit_loss': profitLoss,
      if (profitLossRate != null) 'profit_loss_rate': profitLossRate,
      if (openTime != null) 'open_time': openTime,
      if (closeTime != null) 'close_time': closeTime,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PositionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<int>? userId,
      Value<String>? symbol,
      Value<String>? marketCode,
      Value<int>? quantity,
      Value<double>? avgCost,
      Value<double>? currentPrice,
      Value<double>? profitLoss,
      Value<double>? profitLossRate,
      Value<DateTime>? openTime,
      Value<DateTime?>? closeTime,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return PositionsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      symbol: symbol ?? this.symbol,
      marketCode: marketCode ?? this.marketCode,
      quantity: quantity ?? this.quantity,
      avgCost: avgCost ?? this.avgCost,
      currentPrice: currentPrice ?? this.currentPrice,
      profitLoss: profitLoss ?? this.profitLoss,
      profitLossRate: profitLossRate ?? this.profitLossRate,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (marketCode.present) {
      map['market_code'] = Variable<String>(marketCode.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (avgCost.present) {
      map['avg_cost'] = Variable<double>(avgCost.value);
    }
    if (currentPrice.present) {
      map['current_price'] = Variable<double>(currentPrice.value);
    }
    if (profitLoss.present) {
      map['profit_loss'] = Variable<double>(profitLoss.value);
    }
    if (profitLossRate.present) {
      map['profit_loss_rate'] = Variable<double>(profitLossRate.value);
    }
    if (openTime.present) {
      map['open_time'] = Variable<DateTime>(openTime.value);
    }
    if (closeTime.present) {
      map['close_time'] = Variable<DateTime>(closeTime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PositionsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('quantity: $quantity, ')
          ..write('avgCost: $avgCost, ')
          ..write('currentPrice: $currentPrice, ')
          ..write('profitLoss: $profitLoss, ')
          ..write('profitLossRate: $profitLossRate, ')
          ..write('openTime: $openTime, ')
          ..write('closeTime: $closeTime, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TradesTable extends Trades with TableInfo<$TradesTable, Trade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TradesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES training_sessions (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _marketCodeMeta =
      const VerificationMeta('marketCode');
  @override
  late final GeneratedColumn<String> marketCode = GeneratedColumn<String>(
      'market_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderTypeMeta =
      const VerificationMeta('orderType');
  @override
  late final GeneratedColumn<String> orderType = GeneratedColumn<String>(
      'order_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('market'));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _feeMeta = const VerificationMeta('fee');
  @override
  late final GeneratedColumn<double> fee = GeneratedColumn<double>(
      'fee', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _profitMeta = const VerificationMeta('profit');
  @override
  late final GeneratedColumn<double> profit = GeneratedColumn<double>(
      'profit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _profitRateMeta =
      const VerificationMeta('profitRate');
  @override
  late final GeneratedColumn<double> profitRate = GeneratedColumn<double>(
      'profit_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _positionIdMeta =
      const VerificationMeta('positionId');
  @override
  late final GeneratedColumn<int> positionId = GeneratedColumn<int>(
      'position_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES positions (id)'));
  static const VerificationMeta _tradeDateMeta =
      const VerificationMeta('tradeDate');
  @override
  late final GeneratedColumn<String> tradeDate = GeneratedColumn<String>(
      'trade_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _triggerSourceMeta =
      const VerificationMeta('triggerSource');
  @override
  late final GeneratedColumn<String> triggerSource = GeneratedColumn<String>(
      'trigger_source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        userId,
        symbol,
        marketCode,
        type,
        orderType,
        price,
        quantity,
        amount,
        fee,
        profit,
        profitRate,
        positionId,
        tradeDate,
        triggerSource,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trades';
  @override
  VerificationContext validateIntegrity(Insertable<Trade> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('market_code')) {
      context.handle(
          _marketCodeMeta,
          marketCode.isAcceptableOrUnknown(
              data['market_code']!, _marketCodeMeta));
    } else if (isInserting) {
      context.missing(_marketCodeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('order_type')) {
      context.handle(_orderTypeMeta,
          orderType.isAcceptableOrUnknown(data['order_type']!, _orderTypeMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('fee')) {
      context.handle(
          _feeMeta, fee.isAcceptableOrUnknown(data['fee']!, _feeMeta));
    }
    if (data.containsKey('profit')) {
      context.handle(_profitMeta,
          profit.isAcceptableOrUnknown(data['profit']!, _profitMeta));
    }
    if (data.containsKey('profit_rate')) {
      context.handle(
          _profitRateMeta,
          profitRate.isAcceptableOrUnknown(
              data['profit_rate']!, _profitRateMeta));
    }
    if (data.containsKey('position_id')) {
      context.handle(
          _positionIdMeta,
          positionId.isAcceptableOrUnknown(
              data['position_id']!, _positionIdMeta));
    }
    if (data.containsKey('trade_date')) {
      context.handle(_tradeDateMeta,
          tradeDate.isAcceptableOrUnknown(data['trade_date']!, _tradeDateMeta));
    } else if (isInserting) {
      context.missing(_tradeDateMeta);
    }
    if (data.containsKey('trigger_source')) {
      context.handle(
          _triggerSourceMeta,
          triggerSource.isAcceptableOrUnknown(
              data['trigger_source']!, _triggerSourceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trade(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      marketCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market_code'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      orderType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_type'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      fee: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fee'])!,
      profit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}profit'])!,
      profitRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}profit_rate'])!,
      positionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position_id']),
      tradeDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trade_date'])!,
      triggerSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trigger_source']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TradesTable createAlias(String alias) {
    return $TradesTable(attachedDatabase, alias);
  }
}

class Trade extends DataClass implements Insertable<Trade> {
  /// 交易ID
  final int id;

  /// 会话ID
  final int sessionId;

  /// 用户ID
  final int userId;

  /// 标的代码
  final String symbol;

  /// 市场代码
  final String marketCode;

  /// 类型: buy/sell
  final String type;

  /// 订单类型: market/limit/stop
  final String orderType;

  /// 成交价格
  final double price;

  /// 成交数量
  final int quantity;

  /// 成交金额
  final double amount;

  /// 手续费
  final double fee;

  /// 单笔盈亏
  final double profit;

  /// 单笔收益率
  final double profitRate;

  /// 持仓ID
  final int? positionId;

  /// K线日期标识
  final String tradeDate;

  /// 触发来源: manual/condition/grid/system
  final String? triggerSource;

  /// 创建时间
  final DateTime createdAt;
  const Trade(
      {required this.id,
      required this.sessionId,
      required this.userId,
      required this.symbol,
      required this.marketCode,
      required this.type,
      required this.orderType,
      required this.price,
      required this.quantity,
      required this.amount,
      required this.fee,
      required this.profit,
      required this.profitRate,
      this.positionId,
      required this.tradeDate,
      this.triggerSource,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['user_id'] = Variable<int>(userId);
    map['symbol'] = Variable<String>(symbol);
    map['market_code'] = Variable<String>(marketCode);
    map['type'] = Variable<String>(type);
    map['order_type'] = Variable<String>(orderType);
    map['price'] = Variable<double>(price);
    map['quantity'] = Variable<int>(quantity);
    map['amount'] = Variable<double>(amount);
    map['fee'] = Variable<double>(fee);
    map['profit'] = Variable<double>(profit);
    map['profit_rate'] = Variable<double>(profitRate);
    if (!nullToAbsent || positionId != null) {
      map['position_id'] = Variable<int>(positionId);
    }
    map['trade_date'] = Variable<String>(tradeDate);
    if (!nullToAbsent || triggerSource != null) {
      map['trigger_source'] = Variable<String>(triggerSource);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TradesCompanion toCompanion(bool nullToAbsent) {
    return TradesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      userId: Value(userId),
      symbol: Value(symbol),
      marketCode: Value(marketCode),
      type: Value(type),
      orderType: Value(orderType),
      price: Value(price),
      quantity: Value(quantity),
      amount: Value(amount),
      fee: Value(fee),
      profit: Value(profit),
      profitRate: Value(profitRate),
      positionId: positionId == null && nullToAbsent
          ? const Value.absent()
          : Value(positionId),
      tradeDate: Value(tradeDate),
      triggerSource: triggerSource == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerSource),
      createdAt: Value(createdAt),
    );
  }

  factory Trade.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trade(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      userId: serializer.fromJson<int>(json['userId']),
      symbol: serializer.fromJson<String>(json['symbol']),
      marketCode: serializer.fromJson<String>(json['marketCode']),
      type: serializer.fromJson<String>(json['type']),
      orderType: serializer.fromJson<String>(json['orderType']),
      price: serializer.fromJson<double>(json['price']),
      quantity: serializer.fromJson<int>(json['quantity']),
      amount: serializer.fromJson<double>(json['amount']),
      fee: serializer.fromJson<double>(json['fee']),
      profit: serializer.fromJson<double>(json['profit']),
      profitRate: serializer.fromJson<double>(json['profitRate']),
      positionId: serializer.fromJson<int?>(json['positionId']),
      tradeDate: serializer.fromJson<String>(json['tradeDate']),
      triggerSource: serializer.fromJson<String?>(json['triggerSource']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'userId': serializer.toJson<int>(userId),
      'symbol': serializer.toJson<String>(symbol),
      'marketCode': serializer.toJson<String>(marketCode),
      'type': serializer.toJson<String>(type),
      'orderType': serializer.toJson<String>(orderType),
      'price': serializer.toJson<double>(price),
      'quantity': serializer.toJson<int>(quantity),
      'amount': serializer.toJson<double>(amount),
      'fee': serializer.toJson<double>(fee),
      'profit': serializer.toJson<double>(profit),
      'profitRate': serializer.toJson<double>(profitRate),
      'positionId': serializer.toJson<int?>(positionId),
      'tradeDate': serializer.toJson<String>(tradeDate),
      'triggerSource': serializer.toJson<String?>(triggerSource),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Trade copyWith(
          {int? id,
          int? sessionId,
          int? userId,
          String? symbol,
          String? marketCode,
          String? type,
          String? orderType,
          double? price,
          int? quantity,
          double? amount,
          double? fee,
          double? profit,
          double? profitRate,
          Value<int?> positionId = const Value.absent(),
          String? tradeDate,
          Value<String?> triggerSource = const Value.absent(),
          DateTime? createdAt}) =>
      Trade(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        userId: userId ?? this.userId,
        symbol: symbol ?? this.symbol,
        marketCode: marketCode ?? this.marketCode,
        type: type ?? this.type,
        orderType: orderType ?? this.orderType,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        amount: amount ?? this.amount,
        fee: fee ?? this.fee,
        profit: profit ?? this.profit,
        profitRate: profitRate ?? this.profitRate,
        positionId: positionId.present ? positionId.value : this.positionId,
        tradeDate: tradeDate ?? this.tradeDate,
        triggerSource:
            triggerSource.present ? triggerSource.value : this.triggerSource,
        createdAt: createdAt ?? this.createdAt,
      );
  Trade copyWithCompanion(TradesCompanion data) {
    return Trade(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      userId: data.userId.present ? data.userId.value : this.userId,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      marketCode:
          data.marketCode.present ? data.marketCode.value : this.marketCode,
      type: data.type.present ? data.type.value : this.type,
      orderType: data.orderType.present ? data.orderType.value : this.orderType,
      price: data.price.present ? data.price.value : this.price,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      amount: data.amount.present ? data.amount.value : this.amount,
      fee: data.fee.present ? data.fee.value : this.fee,
      profit: data.profit.present ? data.profit.value : this.profit,
      profitRate:
          data.profitRate.present ? data.profitRate.value : this.profitRate,
      positionId:
          data.positionId.present ? data.positionId.value : this.positionId,
      tradeDate: data.tradeDate.present ? data.tradeDate.value : this.tradeDate,
      triggerSource: data.triggerSource.present
          ? data.triggerSource.value
          : this.triggerSource,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trade(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('type: $type, ')
          ..write('orderType: $orderType, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('amount: $amount, ')
          ..write('fee: $fee, ')
          ..write('profit: $profit, ')
          ..write('profitRate: $profitRate, ')
          ..write('positionId: $positionId, ')
          ..write('tradeDate: $tradeDate, ')
          ..write('triggerSource: $triggerSource, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      sessionId,
      userId,
      symbol,
      marketCode,
      type,
      orderType,
      price,
      quantity,
      amount,
      fee,
      profit,
      profitRate,
      positionId,
      tradeDate,
      triggerSource,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trade &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.userId == this.userId &&
          other.symbol == this.symbol &&
          other.marketCode == this.marketCode &&
          other.type == this.type &&
          other.orderType == this.orderType &&
          other.price == this.price &&
          other.quantity == this.quantity &&
          other.amount == this.amount &&
          other.fee == this.fee &&
          other.profit == this.profit &&
          other.profitRate == this.profitRate &&
          other.positionId == this.positionId &&
          other.tradeDate == this.tradeDate &&
          other.triggerSource == this.triggerSource &&
          other.createdAt == this.createdAt);
}

class TradesCompanion extends UpdateCompanion<Trade> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> userId;
  final Value<String> symbol;
  final Value<String> marketCode;
  final Value<String> type;
  final Value<String> orderType;
  final Value<double> price;
  final Value<int> quantity;
  final Value<double> amount;
  final Value<double> fee;
  final Value<double> profit;
  final Value<double> profitRate;
  final Value<int?> positionId;
  final Value<String> tradeDate;
  final Value<String?> triggerSource;
  final Value<DateTime> createdAt;
  const TradesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.userId = const Value.absent(),
    this.symbol = const Value.absent(),
    this.marketCode = const Value.absent(),
    this.type = const Value.absent(),
    this.orderType = const Value.absent(),
    this.price = const Value.absent(),
    this.quantity = const Value.absent(),
    this.amount = const Value.absent(),
    this.fee = const Value.absent(),
    this.profit = const Value.absent(),
    this.profitRate = const Value.absent(),
    this.positionId = const Value.absent(),
    this.tradeDate = const Value.absent(),
    this.triggerSource = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TradesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int userId,
    required String symbol,
    required String marketCode,
    required String type,
    this.orderType = const Value.absent(),
    required double price,
    required int quantity,
    required double amount,
    this.fee = const Value.absent(),
    this.profit = const Value.absent(),
    this.profitRate = const Value.absent(),
    this.positionId = const Value.absent(),
    required String tradeDate,
    this.triggerSource = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : sessionId = Value(sessionId),
        userId = Value(userId),
        symbol = Value(symbol),
        marketCode = Value(marketCode),
        type = Value(type),
        price = Value(price),
        quantity = Value(quantity),
        amount = Value(amount),
        tradeDate = Value(tradeDate);
  static Insertable<Trade> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? userId,
    Expression<String>? symbol,
    Expression<String>? marketCode,
    Expression<String>? type,
    Expression<String>? orderType,
    Expression<double>? price,
    Expression<int>? quantity,
    Expression<double>? amount,
    Expression<double>? fee,
    Expression<double>? profit,
    Expression<double>? profitRate,
    Expression<int>? positionId,
    Expression<String>? tradeDate,
    Expression<String>? triggerSource,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (userId != null) 'user_id': userId,
      if (symbol != null) 'symbol': symbol,
      if (marketCode != null) 'market_code': marketCode,
      if (type != null) 'type': type,
      if (orderType != null) 'order_type': orderType,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
      if (amount != null) 'amount': amount,
      if (fee != null) 'fee': fee,
      if (profit != null) 'profit': profit,
      if (profitRate != null) 'profit_rate': profitRate,
      if (positionId != null) 'position_id': positionId,
      if (tradeDate != null) 'trade_date': tradeDate,
      if (triggerSource != null) 'trigger_source': triggerSource,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TradesCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<int>? userId,
      Value<String>? symbol,
      Value<String>? marketCode,
      Value<String>? type,
      Value<String>? orderType,
      Value<double>? price,
      Value<int>? quantity,
      Value<double>? amount,
      Value<double>? fee,
      Value<double>? profit,
      Value<double>? profitRate,
      Value<int?>? positionId,
      Value<String>? tradeDate,
      Value<String?>? triggerSource,
      Value<DateTime>? createdAt}) {
    return TradesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      symbol: symbol ?? this.symbol,
      marketCode: marketCode ?? this.marketCode,
      type: type ?? this.type,
      orderType: orderType ?? this.orderType,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      fee: fee ?? this.fee,
      profit: profit ?? this.profit,
      profitRate: profitRate ?? this.profitRate,
      positionId: positionId ?? this.positionId,
      tradeDate: tradeDate ?? this.tradeDate,
      triggerSource: triggerSource ?? this.triggerSource,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (marketCode.present) {
      map['market_code'] = Variable<String>(marketCode.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (orderType.present) {
      map['order_type'] = Variable<String>(orderType.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (fee.present) {
      map['fee'] = Variable<double>(fee.value);
    }
    if (profit.present) {
      map['profit'] = Variable<double>(profit.value);
    }
    if (profitRate.present) {
      map['profit_rate'] = Variable<double>(profitRate.value);
    }
    if (positionId.present) {
      map['position_id'] = Variable<int>(positionId.value);
    }
    if (tradeDate.present) {
      map['trade_date'] = Variable<String>(tradeDate.value);
    }
    if (triggerSource.present) {
      map['trigger_source'] = Variable<String>(triggerSource.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TradesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('type: $type, ')
          ..write('orderType: $orderType, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('amount: $amount, ')
          ..write('fee: $fee, ')
          ..write('profit: $profit, ')
          ..write('profitRate: $profitRate, ')
          ..write('positionId: $positionId, ')
          ..write('tradeDate: $tradeDate, ')
          ..write('triggerSource: $triggerSource, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ConditionalOrdersTable extends ConditionalOrders
    with TableInfo<$ConditionalOrdersTable, ConditionalOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConditionalOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES training_sessions (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _marketCodeMeta =
      const VerificationMeta('marketCode');
  @override
  late final GeneratedColumn<String> marketCode = GeneratedColumn<String>(
      'market_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _triggerTypeMeta =
      const VerificationMeta('triggerType');
  @override
  late final GeneratedColumn<String> triggerType = GeneratedColumn<String>(
      'trigger_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetPriceMeta =
      const VerificationMeta('targetPrice');
  @override
  late final GeneratedColumn<double> targetPrice = GeneratedColumn<double>(
      'target_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _stopPriceMeta =
      const VerificationMeta('stopPrice');
  @override
  late final GeneratedColumn<double> stopPrice = GeneratedColumn<double>(
      'stop_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _upperPriceMeta =
      const VerificationMeta('upperPrice');
  @override
  late final GeneratedColumn<double> upperPrice = GeneratedColumn<double>(
      'upper_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lowerPriceMeta =
      const VerificationMeta('lowerPrice');
  @override
  late final GeneratedColumn<double> lowerPrice = GeneratedColumn<double>(
      'lower_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _gridCountMeta =
      const VerificationMeta('gridCount');
  @override
  late final GeneratedColumn<int> gridCount = GeneratedColumn<int>(
      'grid_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _gridStepMeta =
      const VerificationMeta('gridStep');
  @override
  late final GeneratedColumn<double> gridStep = GeneratedColumn<double>(
      'grid_step', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _gridFilledMeta =
      const VerificationMeta('gridFilled');
  @override
  late final GeneratedColumn<int> gridFilled = GeneratedColumn<int>(
      'grid_filled', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _triggerTimeMeta =
      const VerificationMeta('triggerTime');
  @override
  late final GeneratedColumn<DateTime> triggerTime = GeneratedColumn<DateTime>(
      'trigger_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _expireTimeMeta =
      const VerificationMeta('expireTime');
  @override
  late final GeneratedColumn<DateTime> expireTime = GeneratedColumn<DateTime>(
      'expire_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        userId,
        symbol,
        marketCode,
        type,
        triggerType,
        targetPrice,
        stopPrice,
        upperPrice,
        lowerPrice,
        gridCount,
        gridStep,
        gridFilled,
        quantity,
        status,
        triggerTime,
        expireTime,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conditional_orders';
  @override
  VerificationContext validateIntegrity(Insertable<ConditionalOrder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('market_code')) {
      context.handle(
          _marketCodeMeta,
          marketCode.isAcceptableOrUnknown(
              data['market_code']!, _marketCodeMeta));
    } else if (isInserting) {
      context.missing(_marketCodeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('trigger_type')) {
      context.handle(
          _triggerTypeMeta,
          triggerType.isAcceptableOrUnknown(
              data['trigger_type']!, _triggerTypeMeta));
    } else if (isInserting) {
      context.missing(_triggerTypeMeta);
    }
    if (data.containsKey('target_price')) {
      context.handle(
          _targetPriceMeta,
          targetPrice.isAcceptableOrUnknown(
              data['target_price']!, _targetPriceMeta));
    }
    if (data.containsKey('stop_price')) {
      context.handle(_stopPriceMeta,
          stopPrice.isAcceptableOrUnknown(data['stop_price']!, _stopPriceMeta));
    }
    if (data.containsKey('upper_price')) {
      context.handle(
          _upperPriceMeta,
          upperPrice.isAcceptableOrUnknown(
              data['upper_price']!, _upperPriceMeta));
    }
    if (data.containsKey('lower_price')) {
      context.handle(
          _lowerPriceMeta,
          lowerPrice.isAcceptableOrUnknown(
              data['lower_price']!, _lowerPriceMeta));
    }
    if (data.containsKey('grid_count')) {
      context.handle(_gridCountMeta,
          gridCount.isAcceptableOrUnknown(data['grid_count']!, _gridCountMeta));
    }
    if (data.containsKey('grid_step')) {
      context.handle(_gridStepMeta,
          gridStep.isAcceptableOrUnknown(data['grid_step']!, _gridStepMeta));
    }
    if (data.containsKey('grid_filled')) {
      context.handle(
          _gridFilledMeta,
          gridFilled.isAcceptableOrUnknown(
              data['grid_filled']!, _gridFilledMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('trigger_time')) {
      context.handle(
          _triggerTimeMeta,
          triggerTime.isAcceptableOrUnknown(
              data['trigger_time']!, _triggerTimeMeta));
    }
    if (data.containsKey('expire_time')) {
      context.handle(
          _expireTimeMeta,
          expireTime.isAcceptableOrUnknown(
              data['expire_time']!, _expireTimeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConditionalOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConditionalOrder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      marketCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market_code'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      triggerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trigger_type'])!,
      targetPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_price']),
      stopPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stop_price']),
      upperPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}upper_price']),
      lowerPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lower_price']),
      gridCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grid_count']),
      gridStep: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}grid_step']),
      gridFilled: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grid_filled'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      triggerTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}trigger_time']),
      expireTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expire_time']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ConditionalOrdersTable createAlias(String alias) {
    return $ConditionalOrdersTable(attachedDatabase, alias);
  }
}

class ConditionalOrder extends DataClass
    implements Insertable<ConditionalOrder> {
  /// 条件单ID
  final int id;

  /// 会话ID
  final int sessionId;

  /// 用户ID
  final int userId;

  /// 标的代码
  final String symbol;

  /// 市场代码
  final String marketCode;

  /// 类型: take_profit/stop_loss/condition/buy_limit/sell_limit/grid
  final String type;

  /// 触发类型: price/reach/cross
  final String triggerType;

  /// 目标价格
  final double? targetPrice;

  /// 止损价格
  final double? stopPrice;

  /// 网格上限
  final double? upperPrice;

  /// 网格下限
  final double? lowerPrice;

  /// 网格数量
  final int? gridCount;

  /// 网格步长
  final double? gridStep;

  /// 已触发网格
  final int gridFilled;

  /// 委托数量
  final int quantity;

  /// 状态: active/triggered/cancelled/expired
  final String status;

  /// 触发时间
  final DateTime? triggerTime;

  /// 过期时间
  final DateTime? expireTime;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const ConditionalOrder(
      {required this.id,
      required this.sessionId,
      required this.userId,
      required this.symbol,
      required this.marketCode,
      required this.type,
      required this.triggerType,
      this.targetPrice,
      this.stopPrice,
      this.upperPrice,
      this.lowerPrice,
      this.gridCount,
      this.gridStep,
      required this.gridFilled,
      required this.quantity,
      required this.status,
      this.triggerTime,
      this.expireTime,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['user_id'] = Variable<int>(userId);
    map['symbol'] = Variable<String>(symbol);
    map['market_code'] = Variable<String>(marketCode);
    map['type'] = Variable<String>(type);
    map['trigger_type'] = Variable<String>(triggerType);
    if (!nullToAbsent || targetPrice != null) {
      map['target_price'] = Variable<double>(targetPrice);
    }
    if (!nullToAbsent || stopPrice != null) {
      map['stop_price'] = Variable<double>(stopPrice);
    }
    if (!nullToAbsent || upperPrice != null) {
      map['upper_price'] = Variable<double>(upperPrice);
    }
    if (!nullToAbsent || lowerPrice != null) {
      map['lower_price'] = Variable<double>(lowerPrice);
    }
    if (!nullToAbsent || gridCount != null) {
      map['grid_count'] = Variable<int>(gridCount);
    }
    if (!nullToAbsent || gridStep != null) {
      map['grid_step'] = Variable<double>(gridStep);
    }
    map['grid_filled'] = Variable<int>(gridFilled);
    map['quantity'] = Variable<int>(quantity);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || triggerTime != null) {
      map['trigger_time'] = Variable<DateTime>(triggerTime);
    }
    if (!nullToAbsent || expireTime != null) {
      map['expire_time'] = Variable<DateTime>(expireTime);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ConditionalOrdersCompanion toCompanion(bool nullToAbsent) {
    return ConditionalOrdersCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      userId: Value(userId),
      symbol: Value(symbol),
      marketCode: Value(marketCode),
      type: Value(type),
      triggerType: Value(triggerType),
      targetPrice: targetPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(targetPrice),
      stopPrice: stopPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(stopPrice),
      upperPrice: upperPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(upperPrice),
      lowerPrice: lowerPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(lowerPrice),
      gridCount: gridCount == null && nullToAbsent
          ? const Value.absent()
          : Value(gridCount),
      gridStep: gridStep == null && nullToAbsent
          ? const Value.absent()
          : Value(gridStep),
      gridFilled: Value(gridFilled),
      quantity: Value(quantity),
      status: Value(status),
      triggerTime: triggerTime == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerTime),
      expireTime: expireTime == null && nullToAbsent
          ? const Value.absent()
          : Value(expireTime),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ConditionalOrder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConditionalOrder(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      userId: serializer.fromJson<int>(json['userId']),
      symbol: serializer.fromJson<String>(json['symbol']),
      marketCode: serializer.fromJson<String>(json['marketCode']),
      type: serializer.fromJson<String>(json['type']),
      triggerType: serializer.fromJson<String>(json['triggerType']),
      targetPrice: serializer.fromJson<double?>(json['targetPrice']),
      stopPrice: serializer.fromJson<double?>(json['stopPrice']),
      upperPrice: serializer.fromJson<double?>(json['upperPrice']),
      lowerPrice: serializer.fromJson<double?>(json['lowerPrice']),
      gridCount: serializer.fromJson<int?>(json['gridCount']),
      gridStep: serializer.fromJson<double?>(json['gridStep']),
      gridFilled: serializer.fromJson<int>(json['gridFilled']),
      quantity: serializer.fromJson<int>(json['quantity']),
      status: serializer.fromJson<String>(json['status']),
      triggerTime: serializer.fromJson<DateTime?>(json['triggerTime']),
      expireTime: serializer.fromJson<DateTime?>(json['expireTime']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'userId': serializer.toJson<int>(userId),
      'symbol': serializer.toJson<String>(symbol),
      'marketCode': serializer.toJson<String>(marketCode),
      'type': serializer.toJson<String>(type),
      'triggerType': serializer.toJson<String>(triggerType),
      'targetPrice': serializer.toJson<double?>(targetPrice),
      'stopPrice': serializer.toJson<double?>(stopPrice),
      'upperPrice': serializer.toJson<double?>(upperPrice),
      'lowerPrice': serializer.toJson<double?>(lowerPrice),
      'gridCount': serializer.toJson<int?>(gridCount),
      'gridStep': serializer.toJson<double?>(gridStep),
      'gridFilled': serializer.toJson<int>(gridFilled),
      'quantity': serializer.toJson<int>(quantity),
      'status': serializer.toJson<String>(status),
      'triggerTime': serializer.toJson<DateTime?>(triggerTime),
      'expireTime': serializer.toJson<DateTime?>(expireTime),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ConditionalOrder copyWith(
          {int? id,
          int? sessionId,
          int? userId,
          String? symbol,
          String? marketCode,
          String? type,
          String? triggerType,
          Value<double?> targetPrice = const Value.absent(),
          Value<double?> stopPrice = const Value.absent(),
          Value<double?> upperPrice = const Value.absent(),
          Value<double?> lowerPrice = const Value.absent(),
          Value<int?> gridCount = const Value.absent(),
          Value<double?> gridStep = const Value.absent(),
          int? gridFilled,
          int? quantity,
          String? status,
          Value<DateTime?> triggerTime = const Value.absent(),
          Value<DateTime?> expireTime = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ConditionalOrder(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        userId: userId ?? this.userId,
        symbol: symbol ?? this.symbol,
        marketCode: marketCode ?? this.marketCode,
        type: type ?? this.type,
        triggerType: triggerType ?? this.triggerType,
        targetPrice: targetPrice.present ? targetPrice.value : this.targetPrice,
        stopPrice: stopPrice.present ? stopPrice.value : this.stopPrice,
        upperPrice: upperPrice.present ? upperPrice.value : this.upperPrice,
        lowerPrice: lowerPrice.present ? lowerPrice.value : this.lowerPrice,
        gridCount: gridCount.present ? gridCount.value : this.gridCount,
        gridStep: gridStep.present ? gridStep.value : this.gridStep,
        gridFilled: gridFilled ?? this.gridFilled,
        quantity: quantity ?? this.quantity,
        status: status ?? this.status,
        triggerTime: triggerTime.present ? triggerTime.value : this.triggerTime,
        expireTime: expireTime.present ? expireTime.value : this.expireTime,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ConditionalOrder copyWithCompanion(ConditionalOrdersCompanion data) {
    return ConditionalOrder(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      userId: data.userId.present ? data.userId.value : this.userId,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      marketCode:
          data.marketCode.present ? data.marketCode.value : this.marketCode,
      type: data.type.present ? data.type.value : this.type,
      triggerType:
          data.triggerType.present ? data.triggerType.value : this.triggerType,
      targetPrice:
          data.targetPrice.present ? data.targetPrice.value : this.targetPrice,
      stopPrice: data.stopPrice.present ? data.stopPrice.value : this.stopPrice,
      upperPrice:
          data.upperPrice.present ? data.upperPrice.value : this.upperPrice,
      lowerPrice:
          data.lowerPrice.present ? data.lowerPrice.value : this.lowerPrice,
      gridCount: data.gridCount.present ? data.gridCount.value : this.gridCount,
      gridStep: data.gridStep.present ? data.gridStep.value : this.gridStep,
      gridFilled:
          data.gridFilled.present ? data.gridFilled.value : this.gridFilled,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      status: data.status.present ? data.status.value : this.status,
      triggerTime:
          data.triggerTime.present ? data.triggerTime.value : this.triggerTime,
      expireTime:
          data.expireTime.present ? data.expireTime.value : this.expireTime,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConditionalOrder(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('type: $type, ')
          ..write('triggerType: $triggerType, ')
          ..write('targetPrice: $targetPrice, ')
          ..write('stopPrice: $stopPrice, ')
          ..write('upperPrice: $upperPrice, ')
          ..write('lowerPrice: $lowerPrice, ')
          ..write('gridCount: $gridCount, ')
          ..write('gridStep: $gridStep, ')
          ..write('gridFilled: $gridFilled, ')
          ..write('quantity: $quantity, ')
          ..write('status: $status, ')
          ..write('triggerTime: $triggerTime, ')
          ..write('expireTime: $expireTime, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      sessionId,
      userId,
      symbol,
      marketCode,
      type,
      triggerType,
      targetPrice,
      stopPrice,
      upperPrice,
      lowerPrice,
      gridCount,
      gridStep,
      gridFilled,
      quantity,
      status,
      triggerTime,
      expireTime,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConditionalOrder &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.userId == this.userId &&
          other.symbol == this.symbol &&
          other.marketCode == this.marketCode &&
          other.type == this.type &&
          other.triggerType == this.triggerType &&
          other.targetPrice == this.targetPrice &&
          other.stopPrice == this.stopPrice &&
          other.upperPrice == this.upperPrice &&
          other.lowerPrice == this.lowerPrice &&
          other.gridCount == this.gridCount &&
          other.gridStep == this.gridStep &&
          other.gridFilled == this.gridFilled &&
          other.quantity == this.quantity &&
          other.status == this.status &&
          other.triggerTime == this.triggerTime &&
          other.expireTime == this.expireTime &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ConditionalOrdersCompanion extends UpdateCompanion<ConditionalOrder> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> userId;
  final Value<String> symbol;
  final Value<String> marketCode;
  final Value<String> type;
  final Value<String> triggerType;
  final Value<double?> targetPrice;
  final Value<double?> stopPrice;
  final Value<double?> upperPrice;
  final Value<double?> lowerPrice;
  final Value<int?> gridCount;
  final Value<double?> gridStep;
  final Value<int> gridFilled;
  final Value<int> quantity;
  final Value<String> status;
  final Value<DateTime?> triggerTime;
  final Value<DateTime?> expireTime;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ConditionalOrdersCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.userId = const Value.absent(),
    this.symbol = const Value.absent(),
    this.marketCode = const Value.absent(),
    this.type = const Value.absent(),
    this.triggerType = const Value.absent(),
    this.targetPrice = const Value.absent(),
    this.stopPrice = const Value.absent(),
    this.upperPrice = const Value.absent(),
    this.lowerPrice = const Value.absent(),
    this.gridCount = const Value.absent(),
    this.gridStep = const Value.absent(),
    this.gridFilled = const Value.absent(),
    this.quantity = const Value.absent(),
    this.status = const Value.absent(),
    this.triggerTime = const Value.absent(),
    this.expireTime = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ConditionalOrdersCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int userId,
    required String symbol,
    required String marketCode,
    required String type,
    required String triggerType,
    this.targetPrice = const Value.absent(),
    this.stopPrice = const Value.absent(),
    this.upperPrice = const Value.absent(),
    this.lowerPrice = const Value.absent(),
    this.gridCount = const Value.absent(),
    this.gridStep = const Value.absent(),
    this.gridFilled = const Value.absent(),
    required int quantity,
    required String status,
    this.triggerTime = const Value.absent(),
    this.expireTime = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : sessionId = Value(sessionId),
        userId = Value(userId),
        symbol = Value(symbol),
        marketCode = Value(marketCode),
        type = Value(type),
        triggerType = Value(triggerType),
        quantity = Value(quantity),
        status = Value(status);
  static Insertable<ConditionalOrder> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? userId,
    Expression<String>? symbol,
    Expression<String>? marketCode,
    Expression<String>? type,
    Expression<String>? triggerType,
    Expression<double>? targetPrice,
    Expression<double>? stopPrice,
    Expression<double>? upperPrice,
    Expression<double>? lowerPrice,
    Expression<int>? gridCount,
    Expression<double>? gridStep,
    Expression<int>? gridFilled,
    Expression<int>? quantity,
    Expression<String>? status,
    Expression<DateTime>? triggerTime,
    Expression<DateTime>? expireTime,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (userId != null) 'user_id': userId,
      if (symbol != null) 'symbol': symbol,
      if (marketCode != null) 'market_code': marketCode,
      if (type != null) 'type': type,
      if (triggerType != null) 'trigger_type': triggerType,
      if (targetPrice != null) 'target_price': targetPrice,
      if (stopPrice != null) 'stop_price': stopPrice,
      if (upperPrice != null) 'upper_price': upperPrice,
      if (lowerPrice != null) 'lower_price': lowerPrice,
      if (gridCount != null) 'grid_count': gridCount,
      if (gridStep != null) 'grid_step': gridStep,
      if (gridFilled != null) 'grid_filled': gridFilled,
      if (quantity != null) 'quantity': quantity,
      if (status != null) 'status': status,
      if (triggerTime != null) 'trigger_time': triggerTime,
      if (expireTime != null) 'expire_time': expireTime,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ConditionalOrdersCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<int>? userId,
      Value<String>? symbol,
      Value<String>? marketCode,
      Value<String>? type,
      Value<String>? triggerType,
      Value<double?>? targetPrice,
      Value<double?>? stopPrice,
      Value<double?>? upperPrice,
      Value<double?>? lowerPrice,
      Value<int?>? gridCount,
      Value<double?>? gridStep,
      Value<int>? gridFilled,
      Value<int>? quantity,
      Value<String>? status,
      Value<DateTime?>? triggerTime,
      Value<DateTime?>? expireTime,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ConditionalOrdersCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      symbol: symbol ?? this.symbol,
      marketCode: marketCode ?? this.marketCode,
      type: type ?? this.type,
      triggerType: triggerType ?? this.triggerType,
      targetPrice: targetPrice ?? this.targetPrice,
      stopPrice: stopPrice ?? this.stopPrice,
      upperPrice: upperPrice ?? this.upperPrice,
      lowerPrice: lowerPrice ?? this.lowerPrice,
      gridCount: gridCount ?? this.gridCount,
      gridStep: gridStep ?? this.gridStep,
      gridFilled: gridFilled ?? this.gridFilled,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      triggerTime: triggerTime ?? this.triggerTime,
      expireTime: expireTime ?? this.expireTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (marketCode.present) {
      map['market_code'] = Variable<String>(marketCode.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (triggerType.present) {
      map['trigger_type'] = Variable<String>(triggerType.value);
    }
    if (targetPrice.present) {
      map['target_price'] = Variable<double>(targetPrice.value);
    }
    if (stopPrice.present) {
      map['stop_price'] = Variable<double>(stopPrice.value);
    }
    if (upperPrice.present) {
      map['upper_price'] = Variable<double>(upperPrice.value);
    }
    if (lowerPrice.present) {
      map['lower_price'] = Variable<double>(lowerPrice.value);
    }
    if (gridCount.present) {
      map['grid_count'] = Variable<int>(gridCount.value);
    }
    if (gridStep.present) {
      map['grid_step'] = Variable<double>(gridStep.value);
    }
    if (gridFilled.present) {
      map['grid_filled'] = Variable<int>(gridFilled.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (triggerTime.present) {
      map['trigger_time'] = Variable<DateTime>(triggerTime.value);
    }
    if (expireTime.present) {
      map['expire_time'] = Variable<DateTime>(expireTime.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConditionalOrdersCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('symbol: $symbol, ')
          ..write('marketCode: $marketCode, ')
          ..write('type: $type, ')
          ..write('triggerType: $triggerType, ')
          ..write('targetPrice: $targetPrice, ')
          ..write('stopPrice: $stopPrice, ')
          ..write('upperPrice: $upperPrice, ')
          ..write('lowerPrice: $lowerPrice, ')
          ..write('gridCount: $gridCount, ')
          ..write('gridStep: $gridStep, ')
          ..write('gridFilled: $gridFilled, ')
          ..write('quantity: $quantity, ')
          ..write('status: $status, ')
          ..write('triggerTime: $triggerTime, ')
          ..write('expireTime: $expireTime, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $OperationLogsTable extends OperationLogs
    with TableInfo<$OperationLogsTable, OperationLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OperationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES training_sessions (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
      'detail', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tradeDateMeta =
      const VerificationMeta('tradeDate');
  @override
  late final GeneratedColumn<String> tradeDate = GeneratedColumn<String>(
      'trade_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sessionId, userId, action, detail, tradeDate, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'operation_logs';
  @override
  VerificationContext validateIntegrity(Insertable<OperationLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(_detailMeta,
          detail.isAcceptableOrUnknown(data['detail']!, _detailMeta));
    }
    if (data.containsKey('trade_date')) {
      context.handle(_tradeDateMeta,
          tradeDate.isAcceptableOrUnknown(data['trade_date']!, _tradeDateMeta));
    } else if (isInserting) {
      context.missing(_tradeDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OperationLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OperationLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      detail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}detail']),
      tradeDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trade_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $OperationLogsTable createAlias(String alias) {
    return $OperationLogsTable(attachedDatabase, alias);
  }
}

class OperationLog extends DataClass implements Insertable<OperationLog> {
  /// 日志ID
  final int id;

  /// 会话ID
  final int sessionId;

  /// 用户ID
  final int userId;

  /// 动作类型: reveal_kline/buy/sell/set_order/cancel_order/next_period/skip
  final String action;

  /// 详细信息 (JSON)
  final String? detail;

  /// K线日期
  final String tradeDate;

  /// 创建时间
  final DateTime createdAt;
  const OperationLog(
      {required this.id,
      required this.sessionId,
      required this.userId,
      required this.action,
      this.detail,
      required this.tradeDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['user_id'] = Variable<int>(userId);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || detail != null) {
      map['detail'] = Variable<String>(detail);
    }
    map['trade_date'] = Variable<String>(tradeDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OperationLogsCompanion toCompanion(bool nullToAbsent) {
    return OperationLogsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      userId: Value(userId),
      action: Value(action),
      detail:
          detail == null && nullToAbsent ? const Value.absent() : Value(detail),
      tradeDate: Value(tradeDate),
      createdAt: Value(createdAt),
    );
  }

  factory OperationLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OperationLog(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      userId: serializer.fromJson<int>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      detail: serializer.fromJson<String?>(json['detail']),
      tradeDate: serializer.fromJson<String>(json['tradeDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'userId': serializer.toJson<int>(userId),
      'action': serializer.toJson<String>(action),
      'detail': serializer.toJson<String?>(detail),
      'tradeDate': serializer.toJson<String>(tradeDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OperationLog copyWith(
          {int? id,
          int? sessionId,
          int? userId,
          String? action,
          Value<String?> detail = const Value.absent(),
          String? tradeDate,
          DateTime? createdAt}) =>
      OperationLog(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        userId: userId ?? this.userId,
        action: action ?? this.action,
        detail: detail.present ? detail.value : this.detail,
        tradeDate: tradeDate ?? this.tradeDate,
        createdAt: createdAt ?? this.createdAt,
      );
  OperationLog copyWithCompanion(OperationLogsCompanion data) {
    return OperationLog(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      detail: data.detail.present ? data.detail.value : this.detail,
      tradeDate: data.tradeDate.present ? data.tradeDate.value : this.tradeDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OperationLog(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('detail: $detail, ')
          ..write('tradeDate: $tradeDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, userId, action, detail, tradeDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OperationLog &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.detail == this.detail &&
          other.tradeDate == this.tradeDate &&
          other.createdAt == this.createdAt);
}

class OperationLogsCompanion extends UpdateCompanion<OperationLog> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> userId;
  final Value<String> action;
  final Value<String?> detail;
  final Value<String> tradeDate;
  final Value<DateTime> createdAt;
  const OperationLogsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.detail = const Value.absent(),
    this.tradeDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OperationLogsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int userId,
    required String action,
    this.detail = const Value.absent(),
    required String tradeDate,
    this.createdAt = const Value.absent(),
  })  : sessionId = Value(sessionId),
        userId = Value(userId),
        action = Value(action),
        tradeDate = Value(tradeDate);
  static Insertable<OperationLog> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? userId,
    Expression<String>? action,
    Expression<String>? detail,
    Expression<String>? tradeDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (detail != null) 'detail': detail,
      if (tradeDate != null) 'trade_date': tradeDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OperationLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<int>? userId,
      Value<String>? action,
      Value<String?>? detail,
      Value<String>? tradeDate,
      Value<DateTime>? createdAt}) {
    return OperationLogsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      detail: detail ?? this.detail,
      tradeDate: tradeDate ?? this.tradeDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (tradeDate.present) {
      map['trade_date'] = Variable<String>(tradeDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OperationLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('detail: $detail, ')
          ..write('tradeDate: $tradeDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TrainingReportsTable extends TrainingReports
    with TableInfo<$TrainingReportsTable, TrainingReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES training_sessions (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _totalProfitMeta =
      const VerificationMeta('totalProfit');
  @override
  late final GeneratedColumn<double> totalProfit = GeneratedColumn<double>(
      'total_profit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _profitRateMeta =
      const VerificationMeta('profitRate');
  @override
  late final GeneratedColumn<double> profitRate = GeneratedColumn<double>(
      'profit_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tradeCountMeta =
      const VerificationMeta('tradeCount');
  @override
  late final GeneratedColumn<int> tradeCount = GeneratedColumn<int>(
      'trade_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _winCountMeta =
      const VerificationMeta('winCount');
  @override
  late final GeneratedColumn<int> winCount = GeneratedColumn<int>(
      'win_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _winRateMeta =
      const VerificationMeta('winRate');
  @override
  late final GeneratedColumn<double> winRate = GeneratedColumn<double>(
      'win_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _maxProfitMeta =
      const VerificationMeta('maxProfit');
  @override
  late final GeneratedColumn<double> maxProfit = GeneratedColumn<double>(
      'max_profit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _maxLossMeta =
      const VerificationMeta('maxLoss');
  @override
  late final GeneratedColumn<double> maxLoss = GeneratedColumn<double>(
      'max_loss', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _avgProfitMeta =
      const VerificationMeta('avgProfit');
  @override
  late final GeneratedColumn<double> avgProfit = GeneratedColumn<double>(
      'avg_profit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _avgLossMeta =
      const VerificationMeta('avgLoss');
  @override
  late final GeneratedColumn<double> avgLoss = GeneratedColumn<double>(
      'avg_loss', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _profitLossRatioMeta =
      const VerificationMeta('profitLossRatio');
  @override
  late final GeneratedColumn<double> profitLossRatio = GeneratedColumn<double>(
      'profit_loss_ratio', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _maxDrawdownMeta =
      const VerificationMeta('maxDrawdown');
  @override
  late final GeneratedColumn<double> maxDrawdown = GeneratedColumn<double>(
      'max_drawdown', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sharpeRatioMeta =
      const VerificationMeta('sharpeRatio');
  @override
  late final GeneratedColumn<double> sharpeRatio = GeneratedColumn<double>(
      'sharpe_ratio', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longestWinStreakMeta =
      const VerificationMeta('longestWinStreak');
  @override
  late final GeneratedColumn<int> longestWinStreak = GeneratedColumn<int>(
      'longest_win_streak', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _longestLoseStreakMeta =
      const VerificationMeta('longestLoseStreak');
  @override
  late final GeneratedColumn<int> longestLoseStreak = GeneratedColumn<int>(
      'longest_lose_streak', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _avgHoldDaysMeta =
      const VerificationMeta('avgHoldDays');
  @override
  late final GeneratedColumn<double> avgHoldDays = GeneratedColumn<double>(
      'avg_hold_days', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _conditionOrdersUsedMeta =
      const VerificationMeta('conditionOrdersUsed');
  @override
  late final GeneratedColumn<int> conditionOrdersUsed = GeneratedColumn<int>(
      'condition_orders_used', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _conditionOrdersTriggeredMeta =
      const VerificationMeta('conditionOrdersTriggered');
  @override
  late final GeneratedColumn<int> conditionOrdersTriggered =
      GeneratedColumn<int>('condition_orders_triggered', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _analysisMeta =
      const VerificationMeta('analysis');
  @override
  late final GeneratedColumn<String> analysis = GeneratedColumn<String>(
      'analysis', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _suggestionsMeta =
      const VerificationMeta('suggestions');
  @override
  late final GeneratedColumn<String> suggestions = GeneratedColumn<String>(
      'suggestions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        userId,
        totalProfit,
        profitRate,
        tradeCount,
        winCount,
        winRate,
        maxProfit,
        maxLoss,
        avgProfit,
        avgLoss,
        profitLossRatio,
        maxDrawdown,
        sharpeRatio,
        longestWinStreak,
        longestLoseStreak,
        avgHoldDays,
        conditionOrdersUsed,
        conditionOrdersTriggered,
        analysis,
        suggestions,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_reports';
  @override
  VerificationContext validateIntegrity(Insertable<TrainingReport> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('total_profit')) {
      context.handle(
          _totalProfitMeta,
          totalProfit.isAcceptableOrUnknown(
              data['total_profit']!, _totalProfitMeta));
    } else if (isInserting) {
      context.missing(_totalProfitMeta);
    }
    if (data.containsKey('profit_rate')) {
      context.handle(
          _profitRateMeta,
          profitRate.isAcceptableOrUnknown(
              data['profit_rate']!, _profitRateMeta));
    } else if (isInserting) {
      context.missing(_profitRateMeta);
    }
    if (data.containsKey('trade_count')) {
      context.handle(
          _tradeCountMeta,
          tradeCount.isAcceptableOrUnknown(
              data['trade_count']!, _tradeCountMeta));
    } else if (isInserting) {
      context.missing(_tradeCountMeta);
    }
    if (data.containsKey('win_count')) {
      context.handle(_winCountMeta,
          winCount.isAcceptableOrUnknown(data['win_count']!, _winCountMeta));
    } else if (isInserting) {
      context.missing(_winCountMeta);
    }
    if (data.containsKey('win_rate')) {
      context.handle(_winRateMeta,
          winRate.isAcceptableOrUnknown(data['win_rate']!, _winRateMeta));
    } else if (isInserting) {
      context.missing(_winRateMeta);
    }
    if (data.containsKey('max_profit')) {
      context.handle(_maxProfitMeta,
          maxProfit.isAcceptableOrUnknown(data['max_profit']!, _maxProfitMeta));
    } else if (isInserting) {
      context.missing(_maxProfitMeta);
    }
    if (data.containsKey('max_loss')) {
      context.handle(_maxLossMeta,
          maxLoss.isAcceptableOrUnknown(data['max_loss']!, _maxLossMeta));
    } else if (isInserting) {
      context.missing(_maxLossMeta);
    }
    if (data.containsKey('avg_profit')) {
      context.handle(_avgProfitMeta,
          avgProfit.isAcceptableOrUnknown(data['avg_profit']!, _avgProfitMeta));
    } else if (isInserting) {
      context.missing(_avgProfitMeta);
    }
    if (data.containsKey('avg_loss')) {
      context.handle(_avgLossMeta,
          avgLoss.isAcceptableOrUnknown(data['avg_loss']!, _avgLossMeta));
    } else if (isInserting) {
      context.missing(_avgLossMeta);
    }
    if (data.containsKey('profit_loss_ratio')) {
      context.handle(
          _profitLossRatioMeta,
          profitLossRatio.isAcceptableOrUnknown(
              data['profit_loss_ratio']!, _profitLossRatioMeta));
    } else if (isInserting) {
      context.missing(_profitLossRatioMeta);
    }
    if (data.containsKey('max_drawdown')) {
      context.handle(
          _maxDrawdownMeta,
          maxDrawdown.isAcceptableOrUnknown(
              data['max_drawdown']!, _maxDrawdownMeta));
    } else if (isInserting) {
      context.missing(_maxDrawdownMeta);
    }
    if (data.containsKey('sharpe_ratio')) {
      context.handle(
          _sharpeRatioMeta,
          sharpeRatio.isAcceptableOrUnknown(
              data['sharpe_ratio']!, _sharpeRatioMeta));
    }
    if (data.containsKey('longest_win_streak')) {
      context.handle(
          _longestWinStreakMeta,
          longestWinStreak.isAcceptableOrUnknown(
              data['longest_win_streak']!, _longestWinStreakMeta));
    } else if (isInserting) {
      context.missing(_longestWinStreakMeta);
    }
    if (data.containsKey('longest_lose_streak')) {
      context.handle(
          _longestLoseStreakMeta,
          longestLoseStreak.isAcceptableOrUnknown(
              data['longest_lose_streak']!, _longestLoseStreakMeta));
    } else if (isInserting) {
      context.missing(_longestLoseStreakMeta);
    }
    if (data.containsKey('avg_hold_days')) {
      context.handle(
          _avgHoldDaysMeta,
          avgHoldDays.isAcceptableOrUnknown(
              data['avg_hold_days']!, _avgHoldDaysMeta));
    } else if (isInserting) {
      context.missing(_avgHoldDaysMeta);
    }
    if (data.containsKey('condition_orders_used')) {
      context.handle(
          _conditionOrdersUsedMeta,
          conditionOrdersUsed.isAcceptableOrUnknown(
              data['condition_orders_used']!, _conditionOrdersUsedMeta));
    } else if (isInserting) {
      context.missing(_conditionOrdersUsedMeta);
    }
    if (data.containsKey('condition_orders_triggered')) {
      context.handle(
          _conditionOrdersTriggeredMeta,
          conditionOrdersTriggered.isAcceptableOrUnknown(
              data['condition_orders_triggered']!,
              _conditionOrdersTriggeredMeta));
    } else if (isInserting) {
      context.missing(_conditionOrdersTriggeredMeta);
    }
    if (data.containsKey('analysis')) {
      context.handle(_analysisMeta,
          analysis.isAcceptableOrUnknown(data['analysis']!, _analysisMeta));
    }
    if (data.containsKey('suggestions')) {
      context.handle(
          _suggestionsMeta,
          suggestions.isAcceptableOrUnknown(
              data['suggestions']!, _suggestionsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingReport(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      totalProfit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_profit'])!,
      profitRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}profit_rate'])!,
      tradeCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trade_count'])!,
      winCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}win_count'])!,
      winRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}win_rate'])!,
      maxProfit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_profit'])!,
      maxLoss: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_loss'])!,
      avgProfit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_profit'])!,
      avgLoss: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_loss'])!,
      profitLossRatio: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}profit_loss_ratio'])!,
      maxDrawdown: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_drawdown'])!,
      sharpeRatio: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sharpe_ratio']),
      longestWinStreak: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}longest_win_streak'])!,
      longestLoseStreak: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}longest_lose_streak'])!,
      avgHoldDays: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_hold_days'])!,
      conditionOrdersUsed: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}condition_orders_used'])!,
      conditionOrdersTriggered: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}condition_orders_triggered'])!,
      analysis: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}analysis']),
      suggestions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}suggestions']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TrainingReportsTable createAlias(String alias) {
    return $TrainingReportsTable(attachedDatabase, alias);
  }
}

class TrainingReport extends DataClass implements Insertable<TrainingReport> {
  /// 报告ID
  final int id;

  /// 会话ID (唯一)
  final int sessionId;

  /// 用户ID
  final int userId;

  /// 总盈亏
  final double totalProfit;

  /// 总收益率
  final double profitRate;

  /// 交易次数
  final int tradeCount;

  /// 盈利次数
  final int winCount;

  /// 胜率
  final double winRate;

  /// 最大单笔盈利
  final double maxProfit;

  /// 最大单笔亏损
  final double maxLoss;

  /// 平均盈利
  final double avgProfit;

  /// 平均亏损
  final double avgLoss;

  /// 盈亏比
  final double profitLossRatio;

  /// 最大回撤
  final double maxDrawdown;

  /// 夏普比率
  final double? sharpeRatio;

  /// 最长连胜
  final int longestWinStreak;

  /// 最长连败
  final int longestLoseStreak;

  /// 平均持仓天数
  final double avgHoldDays;

  /// 条件单数
  final int conditionOrdersUsed;

  /// 触发条件单数
  final int conditionOrdersTriggered;

  /// AI分析报告 (JSON)
  final String? analysis;

  /// 改进建议 (JSON)
  final String? suggestions;

  /// 创建时间
  final DateTime createdAt;
  const TrainingReport(
      {required this.id,
      required this.sessionId,
      required this.userId,
      required this.totalProfit,
      required this.profitRate,
      required this.tradeCount,
      required this.winCount,
      required this.winRate,
      required this.maxProfit,
      required this.maxLoss,
      required this.avgProfit,
      required this.avgLoss,
      required this.profitLossRatio,
      required this.maxDrawdown,
      this.sharpeRatio,
      required this.longestWinStreak,
      required this.longestLoseStreak,
      required this.avgHoldDays,
      required this.conditionOrdersUsed,
      required this.conditionOrdersTriggered,
      this.analysis,
      this.suggestions,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['user_id'] = Variable<int>(userId);
    map['total_profit'] = Variable<double>(totalProfit);
    map['profit_rate'] = Variable<double>(profitRate);
    map['trade_count'] = Variable<int>(tradeCount);
    map['win_count'] = Variable<int>(winCount);
    map['win_rate'] = Variable<double>(winRate);
    map['max_profit'] = Variable<double>(maxProfit);
    map['max_loss'] = Variable<double>(maxLoss);
    map['avg_profit'] = Variable<double>(avgProfit);
    map['avg_loss'] = Variable<double>(avgLoss);
    map['profit_loss_ratio'] = Variable<double>(profitLossRatio);
    map['max_drawdown'] = Variable<double>(maxDrawdown);
    if (!nullToAbsent || sharpeRatio != null) {
      map['sharpe_ratio'] = Variable<double>(sharpeRatio);
    }
    map['longest_win_streak'] = Variable<int>(longestWinStreak);
    map['longest_lose_streak'] = Variable<int>(longestLoseStreak);
    map['avg_hold_days'] = Variable<double>(avgHoldDays);
    map['condition_orders_used'] = Variable<int>(conditionOrdersUsed);
    map['condition_orders_triggered'] = Variable<int>(conditionOrdersTriggered);
    if (!nullToAbsent || analysis != null) {
      map['analysis'] = Variable<String>(analysis);
    }
    if (!nullToAbsent || suggestions != null) {
      map['suggestions'] = Variable<String>(suggestions);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TrainingReportsCompanion toCompanion(bool nullToAbsent) {
    return TrainingReportsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      userId: Value(userId),
      totalProfit: Value(totalProfit),
      profitRate: Value(profitRate),
      tradeCount: Value(tradeCount),
      winCount: Value(winCount),
      winRate: Value(winRate),
      maxProfit: Value(maxProfit),
      maxLoss: Value(maxLoss),
      avgProfit: Value(avgProfit),
      avgLoss: Value(avgLoss),
      profitLossRatio: Value(profitLossRatio),
      maxDrawdown: Value(maxDrawdown),
      sharpeRatio: sharpeRatio == null && nullToAbsent
          ? const Value.absent()
          : Value(sharpeRatio),
      longestWinStreak: Value(longestWinStreak),
      longestLoseStreak: Value(longestLoseStreak),
      avgHoldDays: Value(avgHoldDays),
      conditionOrdersUsed: Value(conditionOrdersUsed),
      conditionOrdersTriggered: Value(conditionOrdersTriggered),
      analysis: analysis == null && nullToAbsent
          ? const Value.absent()
          : Value(analysis),
      suggestions: suggestions == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestions),
      createdAt: Value(createdAt),
    );
  }

  factory TrainingReport.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingReport(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      userId: serializer.fromJson<int>(json['userId']),
      totalProfit: serializer.fromJson<double>(json['totalProfit']),
      profitRate: serializer.fromJson<double>(json['profitRate']),
      tradeCount: serializer.fromJson<int>(json['tradeCount']),
      winCount: serializer.fromJson<int>(json['winCount']),
      winRate: serializer.fromJson<double>(json['winRate']),
      maxProfit: serializer.fromJson<double>(json['maxProfit']),
      maxLoss: serializer.fromJson<double>(json['maxLoss']),
      avgProfit: serializer.fromJson<double>(json['avgProfit']),
      avgLoss: serializer.fromJson<double>(json['avgLoss']),
      profitLossRatio: serializer.fromJson<double>(json['profitLossRatio']),
      maxDrawdown: serializer.fromJson<double>(json['maxDrawdown']),
      sharpeRatio: serializer.fromJson<double?>(json['sharpeRatio']),
      longestWinStreak: serializer.fromJson<int>(json['longestWinStreak']),
      longestLoseStreak: serializer.fromJson<int>(json['longestLoseStreak']),
      avgHoldDays: serializer.fromJson<double>(json['avgHoldDays']),
      conditionOrdersUsed:
          serializer.fromJson<int>(json['conditionOrdersUsed']),
      conditionOrdersTriggered:
          serializer.fromJson<int>(json['conditionOrdersTriggered']),
      analysis: serializer.fromJson<String?>(json['analysis']),
      suggestions: serializer.fromJson<String?>(json['suggestions']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'userId': serializer.toJson<int>(userId),
      'totalProfit': serializer.toJson<double>(totalProfit),
      'profitRate': serializer.toJson<double>(profitRate),
      'tradeCount': serializer.toJson<int>(tradeCount),
      'winCount': serializer.toJson<int>(winCount),
      'winRate': serializer.toJson<double>(winRate),
      'maxProfit': serializer.toJson<double>(maxProfit),
      'maxLoss': serializer.toJson<double>(maxLoss),
      'avgProfit': serializer.toJson<double>(avgProfit),
      'avgLoss': serializer.toJson<double>(avgLoss),
      'profitLossRatio': serializer.toJson<double>(profitLossRatio),
      'maxDrawdown': serializer.toJson<double>(maxDrawdown),
      'sharpeRatio': serializer.toJson<double?>(sharpeRatio),
      'longestWinStreak': serializer.toJson<int>(longestWinStreak),
      'longestLoseStreak': serializer.toJson<int>(longestLoseStreak),
      'avgHoldDays': serializer.toJson<double>(avgHoldDays),
      'conditionOrdersUsed': serializer.toJson<int>(conditionOrdersUsed),
      'conditionOrdersTriggered':
          serializer.toJson<int>(conditionOrdersTriggered),
      'analysis': serializer.toJson<String?>(analysis),
      'suggestions': serializer.toJson<String?>(suggestions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TrainingReport copyWith(
          {int? id,
          int? sessionId,
          int? userId,
          double? totalProfit,
          double? profitRate,
          int? tradeCount,
          int? winCount,
          double? winRate,
          double? maxProfit,
          double? maxLoss,
          double? avgProfit,
          double? avgLoss,
          double? profitLossRatio,
          double? maxDrawdown,
          Value<double?> sharpeRatio = const Value.absent(),
          int? longestWinStreak,
          int? longestLoseStreak,
          double? avgHoldDays,
          int? conditionOrdersUsed,
          int? conditionOrdersTriggered,
          Value<String?> analysis = const Value.absent(),
          Value<String?> suggestions = const Value.absent(),
          DateTime? createdAt}) =>
      TrainingReport(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        userId: userId ?? this.userId,
        totalProfit: totalProfit ?? this.totalProfit,
        profitRate: profitRate ?? this.profitRate,
        tradeCount: tradeCount ?? this.tradeCount,
        winCount: winCount ?? this.winCount,
        winRate: winRate ?? this.winRate,
        maxProfit: maxProfit ?? this.maxProfit,
        maxLoss: maxLoss ?? this.maxLoss,
        avgProfit: avgProfit ?? this.avgProfit,
        avgLoss: avgLoss ?? this.avgLoss,
        profitLossRatio: profitLossRatio ?? this.profitLossRatio,
        maxDrawdown: maxDrawdown ?? this.maxDrawdown,
        sharpeRatio: sharpeRatio.present ? sharpeRatio.value : this.sharpeRatio,
        longestWinStreak: longestWinStreak ?? this.longestWinStreak,
        longestLoseStreak: longestLoseStreak ?? this.longestLoseStreak,
        avgHoldDays: avgHoldDays ?? this.avgHoldDays,
        conditionOrdersUsed: conditionOrdersUsed ?? this.conditionOrdersUsed,
        conditionOrdersTriggered:
            conditionOrdersTriggered ?? this.conditionOrdersTriggered,
        analysis: analysis.present ? analysis.value : this.analysis,
        suggestions: suggestions.present ? suggestions.value : this.suggestions,
        createdAt: createdAt ?? this.createdAt,
      );
  TrainingReport copyWithCompanion(TrainingReportsCompanion data) {
    return TrainingReport(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      userId: data.userId.present ? data.userId.value : this.userId,
      totalProfit:
          data.totalProfit.present ? data.totalProfit.value : this.totalProfit,
      profitRate:
          data.profitRate.present ? data.profitRate.value : this.profitRate,
      tradeCount:
          data.tradeCount.present ? data.tradeCount.value : this.tradeCount,
      winCount: data.winCount.present ? data.winCount.value : this.winCount,
      winRate: data.winRate.present ? data.winRate.value : this.winRate,
      maxProfit: data.maxProfit.present ? data.maxProfit.value : this.maxProfit,
      maxLoss: data.maxLoss.present ? data.maxLoss.value : this.maxLoss,
      avgProfit: data.avgProfit.present ? data.avgProfit.value : this.avgProfit,
      avgLoss: data.avgLoss.present ? data.avgLoss.value : this.avgLoss,
      profitLossRatio: data.profitLossRatio.present
          ? data.profitLossRatio.value
          : this.profitLossRatio,
      maxDrawdown:
          data.maxDrawdown.present ? data.maxDrawdown.value : this.maxDrawdown,
      sharpeRatio:
          data.sharpeRatio.present ? data.sharpeRatio.value : this.sharpeRatio,
      longestWinStreak: data.longestWinStreak.present
          ? data.longestWinStreak.value
          : this.longestWinStreak,
      longestLoseStreak: data.longestLoseStreak.present
          ? data.longestLoseStreak.value
          : this.longestLoseStreak,
      avgHoldDays:
          data.avgHoldDays.present ? data.avgHoldDays.value : this.avgHoldDays,
      conditionOrdersUsed: data.conditionOrdersUsed.present
          ? data.conditionOrdersUsed.value
          : this.conditionOrdersUsed,
      conditionOrdersTriggered: data.conditionOrdersTriggered.present
          ? data.conditionOrdersTriggered.value
          : this.conditionOrdersTriggered,
      analysis: data.analysis.present ? data.analysis.value : this.analysis,
      suggestions:
          data.suggestions.present ? data.suggestions.value : this.suggestions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingReport(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('totalProfit: $totalProfit, ')
          ..write('profitRate: $profitRate, ')
          ..write('tradeCount: $tradeCount, ')
          ..write('winCount: $winCount, ')
          ..write('winRate: $winRate, ')
          ..write('maxProfit: $maxProfit, ')
          ..write('maxLoss: $maxLoss, ')
          ..write('avgProfit: $avgProfit, ')
          ..write('avgLoss: $avgLoss, ')
          ..write('profitLossRatio: $profitLossRatio, ')
          ..write('maxDrawdown: $maxDrawdown, ')
          ..write('sharpeRatio: $sharpeRatio, ')
          ..write('longestWinStreak: $longestWinStreak, ')
          ..write('longestLoseStreak: $longestLoseStreak, ')
          ..write('avgHoldDays: $avgHoldDays, ')
          ..write('conditionOrdersUsed: $conditionOrdersUsed, ')
          ..write('conditionOrdersTriggered: $conditionOrdersTriggered, ')
          ..write('analysis: $analysis, ')
          ..write('suggestions: $suggestions, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        sessionId,
        userId,
        totalProfit,
        profitRate,
        tradeCount,
        winCount,
        winRate,
        maxProfit,
        maxLoss,
        avgProfit,
        avgLoss,
        profitLossRatio,
        maxDrawdown,
        sharpeRatio,
        longestWinStreak,
        longestLoseStreak,
        avgHoldDays,
        conditionOrdersUsed,
        conditionOrdersTriggered,
        analysis,
        suggestions,
        createdAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingReport &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.userId == this.userId &&
          other.totalProfit == this.totalProfit &&
          other.profitRate == this.profitRate &&
          other.tradeCount == this.tradeCount &&
          other.winCount == this.winCount &&
          other.winRate == this.winRate &&
          other.maxProfit == this.maxProfit &&
          other.maxLoss == this.maxLoss &&
          other.avgProfit == this.avgProfit &&
          other.avgLoss == this.avgLoss &&
          other.profitLossRatio == this.profitLossRatio &&
          other.maxDrawdown == this.maxDrawdown &&
          other.sharpeRatio == this.sharpeRatio &&
          other.longestWinStreak == this.longestWinStreak &&
          other.longestLoseStreak == this.longestLoseStreak &&
          other.avgHoldDays == this.avgHoldDays &&
          other.conditionOrdersUsed == this.conditionOrdersUsed &&
          other.conditionOrdersTriggered == this.conditionOrdersTriggered &&
          other.analysis == this.analysis &&
          other.suggestions == this.suggestions &&
          other.createdAt == this.createdAt);
}

class TrainingReportsCompanion extends UpdateCompanion<TrainingReport> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> userId;
  final Value<double> totalProfit;
  final Value<double> profitRate;
  final Value<int> tradeCount;
  final Value<int> winCount;
  final Value<double> winRate;
  final Value<double> maxProfit;
  final Value<double> maxLoss;
  final Value<double> avgProfit;
  final Value<double> avgLoss;
  final Value<double> profitLossRatio;
  final Value<double> maxDrawdown;
  final Value<double?> sharpeRatio;
  final Value<int> longestWinStreak;
  final Value<int> longestLoseStreak;
  final Value<double> avgHoldDays;
  final Value<int> conditionOrdersUsed;
  final Value<int> conditionOrdersTriggered;
  final Value<String?> analysis;
  final Value<String?> suggestions;
  final Value<DateTime> createdAt;
  const TrainingReportsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.userId = const Value.absent(),
    this.totalProfit = const Value.absent(),
    this.profitRate = const Value.absent(),
    this.tradeCount = const Value.absent(),
    this.winCount = const Value.absent(),
    this.winRate = const Value.absent(),
    this.maxProfit = const Value.absent(),
    this.maxLoss = const Value.absent(),
    this.avgProfit = const Value.absent(),
    this.avgLoss = const Value.absent(),
    this.profitLossRatio = const Value.absent(),
    this.maxDrawdown = const Value.absent(),
    this.sharpeRatio = const Value.absent(),
    this.longestWinStreak = const Value.absent(),
    this.longestLoseStreak = const Value.absent(),
    this.avgHoldDays = const Value.absent(),
    this.conditionOrdersUsed = const Value.absent(),
    this.conditionOrdersTriggered = const Value.absent(),
    this.analysis = const Value.absent(),
    this.suggestions = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TrainingReportsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int userId,
    required double totalProfit,
    required double profitRate,
    required int tradeCount,
    required int winCount,
    required double winRate,
    required double maxProfit,
    required double maxLoss,
    required double avgProfit,
    required double avgLoss,
    required double profitLossRatio,
    required double maxDrawdown,
    this.sharpeRatio = const Value.absent(),
    required int longestWinStreak,
    required int longestLoseStreak,
    required double avgHoldDays,
    required int conditionOrdersUsed,
    required int conditionOrdersTriggered,
    this.analysis = const Value.absent(),
    this.suggestions = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : sessionId = Value(sessionId),
        userId = Value(userId),
        totalProfit = Value(totalProfit),
        profitRate = Value(profitRate),
        tradeCount = Value(tradeCount),
        winCount = Value(winCount),
        winRate = Value(winRate),
        maxProfit = Value(maxProfit),
        maxLoss = Value(maxLoss),
        avgProfit = Value(avgProfit),
        avgLoss = Value(avgLoss),
        profitLossRatio = Value(profitLossRatio),
        maxDrawdown = Value(maxDrawdown),
        longestWinStreak = Value(longestWinStreak),
        longestLoseStreak = Value(longestLoseStreak),
        avgHoldDays = Value(avgHoldDays),
        conditionOrdersUsed = Value(conditionOrdersUsed),
        conditionOrdersTriggered = Value(conditionOrdersTriggered);
  static Insertable<TrainingReport> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? userId,
    Expression<double>? totalProfit,
    Expression<double>? profitRate,
    Expression<int>? tradeCount,
    Expression<int>? winCount,
    Expression<double>? winRate,
    Expression<double>? maxProfit,
    Expression<double>? maxLoss,
    Expression<double>? avgProfit,
    Expression<double>? avgLoss,
    Expression<double>? profitLossRatio,
    Expression<double>? maxDrawdown,
    Expression<double>? sharpeRatio,
    Expression<int>? longestWinStreak,
    Expression<int>? longestLoseStreak,
    Expression<double>? avgHoldDays,
    Expression<int>? conditionOrdersUsed,
    Expression<int>? conditionOrdersTriggered,
    Expression<String>? analysis,
    Expression<String>? suggestions,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (userId != null) 'user_id': userId,
      if (totalProfit != null) 'total_profit': totalProfit,
      if (profitRate != null) 'profit_rate': profitRate,
      if (tradeCount != null) 'trade_count': tradeCount,
      if (winCount != null) 'win_count': winCount,
      if (winRate != null) 'win_rate': winRate,
      if (maxProfit != null) 'max_profit': maxProfit,
      if (maxLoss != null) 'max_loss': maxLoss,
      if (avgProfit != null) 'avg_profit': avgProfit,
      if (avgLoss != null) 'avg_loss': avgLoss,
      if (profitLossRatio != null) 'profit_loss_ratio': profitLossRatio,
      if (maxDrawdown != null) 'max_drawdown': maxDrawdown,
      if (sharpeRatio != null) 'sharpe_ratio': sharpeRatio,
      if (longestWinStreak != null) 'longest_win_streak': longestWinStreak,
      if (longestLoseStreak != null) 'longest_lose_streak': longestLoseStreak,
      if (avgHoldDays != null) 'avg_hold_days': avgHoldDays,
      if (conditionOrdersUsed != null)
        'condition_orders_used': conditionOrdersUsed,
      if (conditionOrdersTriggered != null)
        'condition_orders_triggered': conditionOrdersTriggered,
      if (analysis != null) 'analysis': analysis,
      if (suggestions != null) 'suggestions': suggestions,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TrainingReportsCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<int>? userId,
      Value<double>? totalProfit,
      Value<double>? profitRate,
      Value<int>? tradeCount,
      Value<int>? winCount,
      Value<double>? winRate,
      Value<double>? maxProfit,
      Value<double>? maxLoss,
      Value<double>? avgProfit,
      Value<double>? avgLoss,
      Value<double>? profitLossRatio,
      Value<double>? maxDrawdown,
      Value<double?>? sharpeRatio,
      Value<int>? longestWinStreak,
      Value<int>? longestLoseStreak,
      Value<double>? avgHoldDays,
      Value<int>? conditionOrdersUsed,
      Value<int>? conditionOrdersTriggered,
      Value<String?>? analysis,
      Value<String?>? suggestions,
      Value<DateTime>? createdAt}) {
    return TrainingReportsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      totalProfit: totalProfit ?? this.totalProfit,
      profitRate: profitRate ?? this.profitRate,
      tradeCount: tradeCount ?? this.tradeCount,
      winCount: winCount ?? this.winCount,
      winRate: winRate ?? this.winRate,
      maxProfit: maxProfit ?? this.maxProfit,
      maxLoss: maxLoss ?? this.maxLoss,
      avgProfit: avgProfit ?? this.avgProfit,
      avgLoss: avgLoss ?? this.avgLoss,
      profitLossRatio: profitLossRatio ?? this.profitLossRatio,
      maxDrawdown: maxDrawdown ?? this.maxDrawdown,
      sharpeRatio: sharpeRatio ?? this.sharpeRatio,
      longestWinStreak: longestWinStreak ?? this.longestWinStreak,
      longestLoseStreak: longestLoseStreak ?? this.longestLoseStreak,
      avgHoldDays: avgHoldDays ?? this.avgHoldDays,
      conditionOrdersUsed: conditionOrdersUsed ?? this.conditionOrdersUsed,
      conditionOrdersTriggered:
          conditionOrdersTriggered ?? this.conditionOrdersTriggered,
      analysis: analysis ?? this.analysis,
      suggestions: suggestions ?? this.suggestions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (totalProfit.present) {
      map['total_profit'] = Variable<double>(totalProfit.value);
    }
    if (profitRate.present) {
      map['profit_rate'] = Variable<double>(profitRate.value);
    }
    if (tradeCount.present) {
      map['trade_count'] = Variable<int>(tradeCount.value);
    }
    if (winCount.present) {
      map['win_count'] = Variable<int>(winCount.value);
    }
    if (winRate.present) {
      map['win_rate'] = Variable<double>(winRate.value);
    }
    if (maxProfit.present) {
      map['max_profit'] = Variable<double>(maxProfit.value);
    }
    if (maxLoss.present) {
      map['max_loss'] = Variable<double>(maxLoss.value);
    }
    if (avgProfit.present) {
      map['avg_profit'] = Variable<double>(avgProfit.value);
    }
    if (avgLoss.present) {
      map['avg_loss'] = Variable<double>(avgLoss.value);
    }
    if (profitLossRatio.present) {
      map['profit_loss_ratio'] = Variable<double>(profitLossRatio.value);
    }
    if (maxDrawdown.present) {
      map['max_drawdown'] = Variable<double>(maxDrawdown.value);
    }
    if (sharpeRatio.present) {
      map['sharpe_ratio'] = Variable<double>(sharpeRatio.value);
    }
    if (longestWinStreak.present) {
      map['longest_win_streak'] = Variable<int>(longestWinStreak.value);
    }
    if (longestLoseStreak.present) {
      map['longest_lose_streak'] = Variable<int>(longestLoseStreak.value);
    }
    if (avgHoldDays.present) {
      map['avg_hold_days'] = Variable<double>(avgHoldDays.value);
    }
    if (conditionOrdersUsed.present) {
      map['condition_orders_used'] = Variable<int>(conditionOrdersUsed.value);
    }
    if (conditionOrdersTriggered.present) {
      map['condition_orders_triggered'] =
          Variable<int>(conditionOrdersTriggered.value);
    }
    if (analysis.present) {
      map['analysis'] = Variable<String>(analysis.value);
    }
    if (suggestions.present) {
      map['suggestions'] = Variable<String>(suggestions.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingReportsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('totalProfit: $totalProfit, ')
          ..write('profitRate: $profitRate, ')
          ..write('tradeCount: $tradeCount, ')
          ..write('winCount: $winCount, ')
          ..write('winRate: $winRate, ')
          ..write('maxProfit: $maxProfit, ')
          ..write('maxLoss: $maxLoss, ')
          ..write('avgProfit: $avgProfit, ')
          ..write('avgLoss: $avgLoss, ')
          ..write('profitLossRatio: $profitLossRatio, ')
          ..write('maxDrawdown: $maxDrawdown, ')
          ..write('sharpeRatio: $sharpeRatio, ')
          ..write('longestWinStreak: $longestWinStreak, ')
          ..write('longestLoseStreak: $longestLoseStreak, ')
          ..write('avgHoldDays: $avgHoldDays, ')
          ..write('conditionOrdersUsed: $conditionOrdersUsed, ')
          ..write('conditionOrdersTriggered: $conditionOrdersTriggered, ')
          ..write('analysis: $analysis, ')
          ..write('suggestions: $suggestions, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserHabitsTable extends UserHabits
    with TableInfo<$UserHabitsTable, UserHabit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserHabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES users (id) ON DELETE CASCADE'));
  static const VerificationMeta _habitTypeMeta =
      const VerificationMeta('habitType');
  @override
  late final GeneratedColumn<String> habitType = GeneratedColumn<String>(
      'habit_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sampleSizeMeta =
      const VerificationMeta('sampleSize');
  @override
  late final GeneratedColumn<int> sampleSize = GeneratedColumn<int>(
      'sample_size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        habitType,
        value,
        confidence,
        sampleSize,
        lastUpdated,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_habits';
  @override
  VerificationContext validateIntegrity(Insertable<UserHabit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('habit_type')) {
      context.handle(_habitTypeMeta,
          habitType.isAcceptableOrUnknown(data['habit_type']!, _habitTypeMeta));
    } else if (isInserting) {
      context.missing(_habitTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('sample_size')) {
      context.handle(
          _sampleSizeMeta,
          sampleSize.isAcceptableOrUnknown(
              data['sample_size']!, _sampleSizeMeta));
    } else if (isInserting) {
      context.missing(_sampleSizeMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, habitType};
  @override
  UserHabit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserHabit(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      habitType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}habit_type'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      sampleSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sample_size'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UserHabitsTable createAlias(String alias) {
    return $UserHabitsTable(attachedDatabase, alias);
  }
}

class UserHabit extends DataClass implements Insertable<UserHabit> {
  /// 用户ID
  final int userId;

  /// 习惯类型: trading_time/preferred_market/preferred_period/trading_style/risk_behavior
  final String habitType;

  /// 习惯值 (JSON或字符串)
  final String value;

  /// 置信度 (0-1)
  final double confidence;

  /// 样本数量
  final int sampleSize;

  /// 最后更新时间
  final DateTime lastUpdated;

  /// 创建时间
  final DateTime createdAt;
  const UserHabit(
      {required this.userId,
      required this.habitType,
      required this.value,
      required this.confidence,
      required this.sampleSize,
      required this.lastUpdated,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    map['habit_type'] = Variable<String>(habitType);
    map['value'] = Variable<String>(value);
    map['confidence'] = Variable<double>(confidence);
    map['sample_size'] = Variable<int>(sampleSize);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserHabitsCompanion toCompanion(bool nullToAbsent) {
    return UserHabitsCompanion(
      userId: Value(userId),
      habitType: Value(habitType),
      value: Value(value),
      confidence: Value(confidence),
      sampleSize: Value(sampleSize),
      lastUpdated: Value(lastUpdated),
      createdAt: Value(createdAt),
    );
  }

  factory UserHabit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserHabit(
      userId: serializer.fromJson<int>(json['userId']),
      habitType: serializer.fromJson<String>(json['habitType']),
      value: serializer.fromJson<String>(json['value']),
      confidence: serializer.fromJson<double>(json['confidence']),
      sampleSize: serializer.fromJson<int>(json['sampleSize']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'habitType': serializer.toJson<String>(habitType),
      'value': serializer.toJson<String>(value),
      'confidence': serializer.toJson<double>(confidence),
      'sampleSize': serializer.toJson<int>(sampleSize),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserHabit copyWith(
          {int? userId,
          String? habitType,
          String? value,
          double? confidence,
          int? sampleSize,
          DateTime? lastUpdated,
          DateTime? createdAt}) =>
      UserHabit(
        userId: userId ?? this.userId,
        habitType: habitType ?? this.habitType,
        value: value ?? this.value,
        confidence: confidence ?? this.confidence,
        sampleSize: sampleSize ?? this.sampleSize,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        createdAt: createdAt ?? this.createdAt,
      );
  UserHabit copyWithCompanion(UserHabitsCompanion data) {
    return UserHabit(
      userId: data.userId.present ? data.userId.value : this.userId,
      habitType: data.habitType.present ? data.habitType.value : this.habitType,
      value: data.value.present ? data.value.value : this.value,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      sampleSize:
          data.sampleSize.present ? data.sampleSize.value : this.sampleSize,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserHabit(')
          ..write('userId: $userId, ')
          ..write('habitType: $habitType, ')
          ..write('value: $value, ')
          ..write('confidence: $confidence, ')
          ..write('sampleSize: $sampleSize, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId, habitType, value, confidence, sampleSize, lastUpdated, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserHabit &&
          other.userId == this.userId &&
          other.habitType == this.habitType &&
          other.value == this.value &&
          other.confidence == this.confidence &&
          other.sampleSize == this.sampleSize &&
          other.lastUpdated == this.lastUpdated &&
          other.createdAt == this.createdAt);
}

class UserHabitsCompanion extends UpdateCompanion<UserHabit> {
  final Value<int> userId;
  final Value<String> habitType;
  final Value<String> value;
  final Value<double> confidence;
  final Value<int> sampleSize;
  final Value<DateTime> lastUpdated;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UserHabitsCompanion({
    this.userId = const Value.absent(),
    this.habitType = const Value.absent(),
    this.value = const Value.absent(),
    this.confidence = const Value.absent(),
    this.sampleSize = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserHabitsCompanion.insert({
    required int userId,
    required String habitType,
    required String value,
    required double confidence,
    required int sampleSize,
    this.lastUpdated = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        habitType = Value(habitType),
        value = Value(value),
        confidence = Value(confidence),
        sampleSize = Value(sampleSize);
  static Insertable<UserHabit> custom({
    Expression<int>? userId,
    Expression<String>? habitType,
    Expression<String>? value,
    Expression<double>? confidence,
    Expression<int>? sampleSize,
    Expression<DateTime>? lastUpdated,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (habitType != null) 'habit_type': habitType,
      if (value != null) 'value': value,
      if (confidence != null) 'confidence': confidence,
      if (sampleSize != null) 'sample_size': sampleSize,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserHabitsCompanion copyWith(
      {Value<int>? userId,
      Value<String>? habitType,
      Value<String>? value,
      Value<double>? confidence,
      Value<int>? sampleSize,
      Value<DateTime>? lastUpdated,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return UserHabitsCompanion(
      userId: userId ?? this.userId,
      habitType: habitType ?? this.habitType,
      value: value ?? this.value,
      confidence: confidence ?? this.confidence,
      sampleSize: sampleSize ?? this.sampleSize,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (habitType.present) {
      map['habit_type'] = Variable<String>(habitType.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (sampleSize.present) {
      map['sample_size'] = Variable<int>(sampleSize.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserHabitsCompanion(')
          ..write('userId: $userId, ')
          ..write('habitType: $habitType, ')
          ..write('value: $value, ')
          ..write('confidence: $confidence, ')
          ..write('sampleSize: $sampleSize, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TradingPatternsTable extends TradingPatterns
    with TableInfo<$TradingPatternsTable, TradingPattern> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TradingPatternsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _patternTypeMeta =
      const VerificationMeta('patternType');
  @override
  late final GeneratedColumn<String> patternType = GeneratedColumn<String>(
      'pattern_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _occurrenceRateMeta =
      const VerificationMeta('occurrenceRate');
  @override
  late final GeneratedColumn<double> occurrenceRate = GeneratedColumn<double>(
      'occurrence_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _successRateMeta =
      const VerificationMeta('successRate');
  @override
  late final GeneratedColumn<double> successRate = GeneratedColumn<double>(
      'success_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _avgProfitRateMeta =
      const VerificationMeta('avgProfitRate');
  @override
  late final GeneratedColumn<double> avgProfitRate = GeneratedColumn<double>(
      'avg_profit_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sampleCountMeta =
      const VerificationMeta('sampleCount');
  @override
  late final GeneratedColumn<int> sampleCount = GeneratedColumn<int>(
      'sample_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _conditionsMeta =
      const VerificationMeta('conditions');
  @override
  late final GeneratedColumn<String> conditions = GeneratedColumn<String>(
      'conditions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parametersMeta =
      const VerificationMeta('parameters');
  @override
  late final GeneratedColumn<String> parameters = GeneratedColumn<String>(
      'parameters', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        patternType,
        occurrenceRate,
        successRate,
        avgProfitRate,
        sampleCount,
        conditions,
        parameters,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trading_patterns';
  @override
  VerificationContext validateIntegrity(Insertable<TradingPattern> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('pattern_type')) {
      context.handle(
          _patternTypeMeta,
          patternType.isAcceptableOrUnknown(
              data['pattern_type']!, _patternTypeMeta));
    } else if (isInserting) {
      context.missing(_patternTypeMeta);
    }
    if (data.containsKey('occurrence_rate')) {
      context.handle(
          _occurrenceRateMeta,
          occurrenceRate.isAcceptableOrUnknown(
              data['occurrence_rate']!, _occurrenceRateMeta));
    } else if (isInserting) {
      context.missing(_occurrenceRateMeta);
    }
    if (data.containsKey('success_rate')) {
      context.handle(
          _successRateMeta,
          successRate.isAcceptableOrUnknown(
              data['success_rate']!, _successRateMeta));
    } else if (isInserting) {
      context.missing(_successRateMeta);
    }
    if (data.containsKey('avg_profit_rate')) {
      context.handle(
          _avgProfitRateMeta,
          avgProfitRate.isAcceptableOrUnknown(
              data['avg_profit_rate']!, _avgProfitRateMeta));
    } else if (isInserting) {
      context.missing(_avgProfitRateMeta);
    }
    if (data.containsKey('sample_count')) {
      context.handle(
          _sampleCountMeta,
          sampleCount.isAcceptableOrUnknown(
              data['sample_count']!, _sampleCountMeta));
    } else if (isInserting) {
      context.missing(_sampleCountMeta);
    }
    if (data.containsKey('conditions')) {
      context.handle(
          _conditionsMeta,
          conditions.isAcceptableOrUnknown(
              data['conditions']!, _conditionsMeta));
    }
    if (data.containsKey('parameters')) {
      context.handle(
          _parametersMeta,
          parameters.isAcceptableOrUnknown(
              data['parameters']!, _parametersMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TradingPattern map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TradingPattern(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      patternType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pattern_type'])!,
      occurrenceRate: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}occurrence_rate'])!,
      successRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}success_rate'])!,
      avgProfitRate: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}avg_profit_rate'])!,
      sampleCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sample_count'])!,
      conditions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conditions']),
      parameters: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parameters']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TradingPatternsTable createAlias(String alias) {
    return $TradingPatternsTable(attachedDatabase, alias);
  }
}

class TradingPattern extends DataClass implements Insertable<TradingPattern> {
  /// 模式ID
  final int id;

  /// 用户ID
  final int userId;

  /// 模式类型: breakout/reversal/trend_following/range_trading/mean_reversion
  final String patternType;

  /// 出现频率
  final double occurrenceRate;

  /// 成功率
  final double successRate;

  /// 平均收益率
  final double avgProfitRate;

  /// 样本数量
  final int sampleCount;

  /// 触发条件 (JSON)
  final String? conditions;

  /// 参数配置 (JSON)
  final String? parameters;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const TradingPattern(
      {required this.id,
      required this.userId,
      required this.patternType,
      required this.occurrenceRate,
      required this.successRate,
      required this.avgProfitRate,
      required this.sampleCount,
      this.conditions,
      this.parameters,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['pattern_type'] = Variable<String>(patternType);
    map['occurrence_rate'] = Variable<double>(occurrenceRate);
    map['success_rate'] = Variable<double>(successRate);
    map['avg_profit_rate'] = Variable<double>(avgProfitRate);
    map['sample_count'] = Variable<int>(sampleCount);
    if (!nullToAbsent || conditions != null) {
      map['conditions'] = Variable<String>(conditions);
    }
    if (!nullToAbsent || parameters != null) {
      map['parameters'] = Variable<String>(parameters);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TradingPatternsCompanion toCompanion(bool nullToAbsent) {
    return TradingPatternsCompanion(
      id: Value(id),
      userId: Value(userId),
      patternType: Value(patternType),
      occurrenceRate: Value(occurrenceRate),
      successRate: Value(successRate),
      avgProfitRate: Value(avgProfitRate),
      sampleCount: Value(sampleCount),
      conditions: conditions == null && nullToAbsent
          ? const Value.absent()
          : Value(conditions),
      parameters: parameters == null && nullToAbsent
          ? const Value.absent()
          : Value(parameters),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TradingPattern.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TradingPattern(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      patternType: serializer.fromJson<String>(json['patternType']),
      occurrenceRate: serializer.fromJson<double>(json['occurrenceRate']),
      successRate: serializer.fromJson<double>(json['successRate']),
      avgProfitRate: serializer.fromJson<double>(json['avgProfitRate']),
      sampleCount: serializer.fromJson<int>(json['sampleCount']),
      conditions: serializer.fromJson<String?>(json['conditions']),
      parameters: serializer.fromJson<String?>(json['parameters']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'patternType': serializer.toJson<String>(patternType),
      'occurrenceRate': serializer.toJson<double>(occurrenceRate),
      'successRate': serializer.toJson<double>(successRate),
      'avgProfitRate': serializer.toJson<double>(avgProfitRate),
      'sampleCount': serializer.toJson<int>(sampleCount),
      'conditions': serializer.toJson<String?>(conditions),
      'parameters': serializer.toJson<String?>(parameters),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TradingPattern copyWith(
          {int? id,
          int? userId,
          String? patternType,
          double? occurrenceRate,
          double? successRate,
          double? avgProfitRate,
          int? sampleCount,
          Value<String?> conditions = const Value.absent(),
          Value<String?> parameters = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TradingPattern(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        patternType: patternType ?? this.patternType,
        occurrenceRate: occurrenceRate ?? this.occurrenceRate,
        successRate: successRate ?? this.successRate,
        avgProfitRate: avgProfitRate ?? this.avgProfitRate,
        sampleCount: sampleCount ?? this.sampleCount,
        conditions: conditions.present ? conditions.value : this.conditions,
        parameters: parameters.present ? parameters.value : this.parameters,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TradingPattern copyWithCompanion(TradingPatternsCompanion data) {
    return TradingPattern(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      patternType:
          data.patternType.present ? data.patternType.value : this.patternType,
      occurrenceRate: data.occurrenceRate.present
          ? data.occurrenceRate.value
          : this.occurrenceRate,
      successRate:
          data.successRate.present ? data.successRate.value : this.successRate,
      avgProfitRate: data.avgProfitRate.present
          ? data.avgProfitRate.value
          : this.avgProfitRate,
      sampleCount:
          data.sampleCount.present ? data.sampleCount.value : this.sampleCount,
      conditions:
          data.conditions.present ? data.conditions.value : this.conditions,
      parameters:
          data.parameters.present ? data.parameters.value : this.parameters,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TradingPattern(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('patternType: $patternType, ')
          ..write('occurrenceRate: $occurrenceRate, ')
          ..write('successRate: $successRate, ')
          ..write('avgProfitRate: $avgProfitRate, ')
          ..write('sampleCount: $sampleCount, ')
          ..write('conditions: $conditions, ')
          ..write('parameters: $parameters, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      patternType,
      occurrenceRate,
      successRate,
      avgProfitRate,
      sampleCount,
      conditions,
      parameters,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TradingPattern &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.patternType == this.patternType &&
          other.occurrenceRate == this.occurrenceRate &&
          other.successRate == this.successRate &&
          other.avgProfitRate == this.avgProfitRate &&
          other.sampleCount == this.sampleCount &&
          other.conditions == this.conditions &&
          other.parameters == this.parameters &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TradingPatternsCompanion extends UpdateCompanion<TradingPattern> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> patternType;
  final Value<double> occurrenceRate;
  final Value<double> successRate;
  final Value<double> avgProfitRate;
  final Value<int> sampleCount;
  final Value<String?> conditions;
  final Value<String?> parameters;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TradingPatternsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.patternType = const Value.absent(),
    this.occurrenceRate = const Value.absent(),
    this.successRate = const Value.absent(),
    this.avgProfitRate = const Value.absent(),
    this.sampleCount = const Value.absent(),
    this.conditions = const Value.absent(),
    this.parameters = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TradingPatternsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String patternType,
    required double occurrenceRate,
    required double successRate,
    required double avgProfitRate,
    required int sampleCount,
    this.conditions = const Value.absent(),
    this.parameters = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : userId = Value(userId),
        patternType = Value(patternType),
        occurrenceRate = Value(occurrenceRate),
        successRate = Value(successRate),
        avgProfitRate = Value(avgProfitRate),
        sampleCount = Value(sampleCount);
  static Insertable<TradingPattern> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? patternType,
    Expression<double>? occurrenceRate,
    Expression<double>? successRate,
    Expression<double>? avgProfitRate,
    Expression<int>? sampleCount,
    Expression<String>? conditions,
    Expression<String>? parameters,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (patternType != null) 'pattern_type': patternType,
      if (occurrenceRate != null) 'occurrence_rate': occurrenceRate,
      if (successRate != null) 'success_rate': successRate,
      if (avgProfitRate != null) 'avg_profit_rate': avgProfitRate,
      if (sampleCount != null) 'sample_count': sampleCount,
      if (conditions != null) 'conditions': conditions,
      if (parameters != null) 'parameters': parameters,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TradingPatternsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<String>? patternType,
      Value<double>? occurrenceRate,
      Value<double>? successRate,
      Value<double>? avgProfitRate,
      Value<int>? sampleCount,
      Value<String?>? conditions,
      Value<String?>? parameters,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return TradingPatternsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      patternType: patternType ?? this.patternType,
      occurrenceRate: occurrenceRate ?? this.occurrenceRate,
      successRate: successRate ?? this.successRate,
      avgProfitRate: avgProfitRate ?? this.avgProfitRate,
      sampleCount: sampleCount ?? this.sampleCount,
      conditions: conditions ?? this.conditions,
      parameters: parameters ?? this.parameters,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (patternType.present) {
      map['pattern_type'] = Variable<String>(patternType.value);
    }
    if (occurrenceRate.present) {
      map['occurrence_rate'] = Variable<double>(occurrenceRate.value);
    }
    if (successRate.present) {
      map['success_rate'] = Variable<double>(successRate.value);
    }
    if (avgProfitRate.present) {
      map['avg_profit_rate'] = Variable<double>(avgProfitRate.value);
    }
    if (sampleCount.present) {
      map['sample_count'] = Variable<int>(sampleCount.value);
    }
    if (conditions.present) {
      map['conditions'] = Variable<String>(conditions.value);
    }
    if (parameters.present) {
      map['parameters'] = Variable<String>(parameters.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TradingPatternsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('patternType: $patternType, ')
          ..write('occurrenceRate: $occurrenceRate, ')
          ..write('successRate: $successRate, ')
          ..write('avgProfitRate: $avgProfitRate, ')
          ..write('sampleCount: $sampleCount, ')
          ..write('conditions: $conditions, ')
          ..write('parameters: $parameters, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StrategyTipsTable extends StrategyTips
    with TableInfo<$StrategyTipsTable, StrategyTip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StrategyTipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _effectivenessMeta =
      const VerificationMeta('effectiveness');
  @override
  late final GeneratedColumn<double> effectiveness = GeneratedColumn<double>(
      'effectiveness', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _verifiedUsersMeta =
      const VerificationMeta('verifiedUsers');
  @override
  late final GeneratedColumn<int> verifiedUsers = GeneratedColumn<int>(
      'verified_users', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _conditionsMeta =
      const VerificationMeta('conditions');
  @override
  late final GeneratedColumn<String> conditions = GeneratedColumn<String>(
      'conditions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rulesMeta = const VerificationMeta('rules');
  @override
  late final GeneratedColumn<String> rules = GeneratedColumn<String>(
      'rules', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _examplesMeta =
      const VerificationMeta('examples');
  @override
  late final GeneratedColumn<String> examples = GeneratedColumn<String>(
      'examples', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        code,
        title,
        description,
        category,
        effectiveness,
        verifiedUsers,
        conditions,
        rules,
        examples,
        notes,
        enabled,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'strategy_tips';
  @override
  VerificationContext validateIntegrity(Insertable<StrategyTip> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('effectiveness')) {
      context.handle(
          _effectivenessMeta,
          effectiveness.isAcceptableOrUnknown(
              data['effectiveness']!, _effectivenessMeta));
    } else if (isInserting) {
      context.missing(_effectivenessMeta);
    }
    if (data.containsKey('verified_users')) {
      context.handle(
          _verifiedUsersMeta,
          verifiedUsers.isAcceptableOrUnknown(
              data['verified_users']!, _verifiedUsersMeta));
    } else if (isInserting) {
      context.missing(_verifiedUsersMeta);
    }
    if (data.containsKey('conditions')) {
      context.handle(
          _conditionsMeta,
          conditions.isAcceptableOrUnknown(
              data['conditions']!, _conditionsMeta));
    } else if (isInserting) {
      context.missing(_conditionsMeta);
    }
    if (data.containsKey('rules')) {
      context.handle(
          _rulesMeta, rules.isAcceptableOrUnknown(data['rules']!, _rulesMeta));
    } else if (isInserting) {
      context.missing(_rulesMeta);
    }
    if (data.containsKey('examples')) {
      context.handle(_examplesMeta,
          examples.isAcceptableOrUnknown(data['examples']!, _examplesMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StrategyTip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StrategyTip(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      effectiveness: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}effectiveness'])!,
      verifiedUsers: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verified_users'])!,
      conditions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conditions'])!,
      rules: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rules'])!,
      examples: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}examples']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $StrategyTipsTable createAlias(String alias) {
    return $StrategyTipsTable(attachedDatabase, alias);
  }
}

class StrategyTip extends DataClass implements Insertable<StrategyTip> {
  /// 技巧ID
  final int id;

  /// 技巧代码 (唯一)
  final String code;

  /// 策略名称
  final String title;

  /// 策略描述
  final String description;

  /// 分类: entry/exit/risk_management/position_sizing
  final String category;

  /// 有效性评分 (0-1)
  final double effectiveness;

  /// 验证用户数
  final int verifiedUsers;

  /// 使用条件 (JSON)
  final String conditions;

  /// 策略规则 (JSON)
  final String rules;

  /// 使用示例 (JSON)
  final String? examples;

  /// 注意事项
  final String? notes;

  /// 是否启用
  final bool enabled;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const StrategyTip(
      {required this.id,
      required this.code,
      required this.title,
      required this.description,
      required this.category,
      required this.effectiveness,
      required this.verifiedUsers,
      required this.conditions,
      required this.rules,
      this.examples,
      this.notes,
      required this.enabled,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['effectiveness'] = Variable<double>(effectiveness);
    map['verified_users'] = Variable<int>(verifiedUsers);
    map['conditions'] = Variable<String>(conditions);
    map['rules'] = Variable<String>(rules);
    if (!nullToAbsent || examples != null) {
      map['examples'] = Variable<String>(examples);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StrategyTipsCompanion toCompanion(bool nullToAbsent) {
    return StrategyTipsCompanion(
      id: Value(id),
      code: Value(code),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      effectiveness: Value(effectiveness),
      verifiedUsers: Value(verifiedUsers),
      conditions: Value(conditions),
      rules: Value(rules),
      examples: examples == null && nullToAbsent
          ? const Value.absent()
          : Value(examples),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StrategyTip.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StrategyTip(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      effectiveness: serializer.fromJson<double>(json['effectiveness']),
      verifiedUsers: serializer.fromJson<int>(json['verifiedUsers']),
      conditions: serializer.fromJson<String>(json['conditions']),
      rules: serializer.fromJson<String>(json['rules']),
      examples: serializer.fromJson<String?>(json['examples']),
      notes: serializer.fromJson<String?>(json['notes']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'effectiveness': serializer.toJson<double>(effectiveness),
      'verifiedUsers': serializer.toJson<int>(verifiedUsers),
      'conditions': serializer.toJson<String>(conditions),
      'rules': serializer.toJson<String>(rules),
      'examples': serializer.toJson<String?>(examples),
      'notes': serializer.toJson<String?>(notes),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StrategyTip copyWith(
          {int? id,
          String? code,
          String? title,
          String? description,
          String? category,
          double? effectiveness,
          int? verifiedUsers,
          String? conditions,
          String? rules,
          Value<String?> examples = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? enabled,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      StrategyTip(
        id: id ?? this.id,
        code: code ?? this.code,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        effectiveness: effectiveness ?? this.effectiveness,
        verifiedUsers: verifiedUsers ?? this.verifiedUsers,
        conditions: conditions ?? this.conditions,
        rules: rules ?? this.rules,
        examples: examples.present ? examples.value : this.examples,
        notes: notes.present ? notes.value : this.notes,
        enabled: enabled ?? this.enabled,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  StrategyTip copyWithCompanion(StrategyTipsCompanion data) {
    return StrategyTip(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      effectiveness: data.effectiveness.present
          ? data.effectiveness.value
          : this.effectiveness,
      verifiedUsers: data.verifiedUsers.present
          ? data.verifiedUsers.value
          : this.verifiedUsers,
      conditions:
          data.conditions.present ? data.conditions.value : this.conditions,
      rules: data.rules.present ? data.rules.value : this.rules,
      examples: data.examples.present ? data.examples.value : this.examples,
      notes: data.notes.present ? data.notes.value : this.notes,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StrategyTip(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('effectiveness: $effectiveness, ')
          ..write('verifiedUsers: $verifiedUsers, ')
          ..write('conditions: $conditions, ')
          ..write('rules: $rules, ')
          ..write('examples: $examples, ')
          ..write('notes: $notes, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      code,
      title,
      description,
      category,
      effectiveness,
      verifiedUsers,
      conditions,
      rules,
      examples,
      notes,
      enabled,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StrategyTip &&
          other.id == this.id &&
          other.code == this.code &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.effectiveness == this.effectiveness &&
          other.verifiedUsers == this.verifiedUsers &&
          other.conditions == this.conditions &&
          other.rules == this.rules &&
          other.examples == this.examples &&
          other.notes == this.notes &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StrategyTipsCompanion extends UpdateCompanion<StrategyTip> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> title;
  final Value<String> description;
  final Value<String> category;
  final Value<double> effectiveness;
  final Value<int> verifiedUsers;
  final Value<String> conditions;
  final Value<String> rules;
  final Value<String?> examples;
  final Value<String?> notes;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const StrategyTipsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.effectiveness = const Value.absent(),
    this.verifiedUsers = const Value.absent(),
    this.conditions = const Value.absent(),
    this.rules = const Value.absent(),
    this.examples = const Value.absent(),
    this.notes = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  StrategyTipsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String title,
    required String description,
    required String category,
    required double effectiveness,
    required int verifiedUsers,
    required String conditions,
    required String rules,
    this.examples = const Value.absent(),
    this.notes = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : code = Value(code),
        title = Value(title),
        description = Value(description),
        category = Value(category),
        effectiveness = Value(effectiveness),
        verifiedUsers = Value(verifiedUsers),
        conditions = Value(conditions),
        rules = Value(rules);
  static Insertable<StrategyTip> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<double>? effectiveness,
    Expression<int>? verifiedUsers,
    Expression<String>? conditions,
    Expression<String>? rules,
    Expression<String>? examples,
    Expression<String>? notes,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (effectiveness != null) 'effectiveness': effectiveness,
      if (verifiedUsers != null) 'verified_users': verifiedUsers,
      if (conditions != null) 'conditions': conditions,
      if (rules != null) 'rules': rules,
      if (examples != null) 'examples': examples,
      if (notes != null) 'notes': notes,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  StrategyTipsCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? title,
      Value<String>? description,
      Value<String>? category,
      Value<double>? effectiveness,
      Value<int>? verifiedUsers,
      Value<String>? conditions,
      Value<String>? rules,
      Value<String?>? examples,
      Value<String?>? notes,
      Value<bool>? enabled,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return StrategyTipsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      effectiveness: effectiveness ?? this.effectiveness,
      verifiedUsers: verifiedUsers ?? this.verifiedUsers,
      conditions: conditions ?? this.conditions,
      rules: rules ?? this.rules,
      examples: examples ?? this.examples,
      notes: notes ?? this.notes,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (effectiveness.present) {
      map['effectiveness'] = Variable<double>(effectiveness.value);
    }
    if (verifiedUsers.present) {
      map['verified_users'] = Variable<int>(verifiedUsers.value);
    }
    if (conditions.present) {
      map['conditions'] = Variable<String>(conditions.value);
    }
    if (rules.present) {
      map['rules'] = Variable<String>(rules.value);
    }
    if (examples.present) {
      map['examples'] = Variable<String>(examples.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StrategyTipsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('effectiveness: $effectiveness, ')
          ..write('verifiedUsers: $verifiedUsers, ')
          ..write('conditions: $conditions, ')
          ..write('rules: $rules, ')
          ..write('examples: $examples, ')
          ..write('notes: $notes, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SystemConfigsTable extends SystemConfigs
    with TableInfo<$SystemConfigsTable, SystemConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SystemConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('general'));
  static const VerificationMeta _isPublicMeta =
      const VerificationMeta('isPublic');
  @override
  late final GeneratedColumn<bool> isPublic = GeneratedColumn<bool>(
      'is_public', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_public" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [key, value, description, category, isPublic, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'system_configs';
  @override
  VerificationContext validateIntegrity(Insertable<SystemConfig> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('is_public')) {
      context.handle(_isPublicMeta,
          isPublic.isAcceptableOrUnknown(data['is_public']!, _isPublicMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SystemConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SystemConfig(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      isPublic: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_public'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SystemConfigsTable createAlias(String alias) {
    return $SystemConfigsTable(attachedDatabase, alias);
  }
}

class SystemConfig extends DataClass implements Insertable<SystemConfig> {
  /// 配置键 (主键)
  final String key;

  /// 配置值
  final String value;

  /// 配置描述
  final String? description;

  /// 分类
  final String category;

  /// 是否公开
  final bool isPublic;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const SystemConfig(
      {required this.key,
      required this.value,
      this.description,
      required this.category,
      required this.isPublic,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['category'] = Variable<String>(category);
    map['is_public'] = Variable<bool>(isPublic);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SystemConfigsCompanion toCompanion(bool nullToAbsent) {
    return SystemConfigsCompanion(
      key: Value(key),
      value: Value(value),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: Value(category),
      isPublic: Value(isPublic),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SystemConfig.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SystemConfig(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      isPublic: serializer.fromJson<bool>(json['isPublic']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String>(category),
      'isPublic': serializer.toJson<bool>(isPublic),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SystemConfig copyWith(
          {String? key,
          String? value,
          Value<String?> description = const Value.absent(),
          String? category,
          bool? isPublic,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SystemConfig(
        key: key ?? this.key,
        value: value ?? this.value,
        description: description.present ? description.value : this.description,
        category: category ?? this.category,
        isPublic: isPublic ?? this.isPublic,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SystemConfig copyWithCompanion(SystemConfigsCompanion data) {
    return SystemConfig(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      isPublic: data.isPublic.present ? data.isPublic.value : this.isPublic,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SystemConfig(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('isPublic: $isPublic, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      key, value, description, category, isPublic, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SystemConfig &&
          other.key == this.key &&
          other.value == this.value &&
          other.description == this.description &&
          other.category == this.category &&
          other.isPublic == this.isPublic &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SystemConfigsCompanion extends UpdateCompanion<SystemConfig> {
  final Value<String> key;
  final Value<String> value;
  final Value<String?> description;
  final Value<String> category;
  final Value<bool> isPublic;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SystemConfigsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SystemConfigsCompanion.insert({
    required String key,
    required String value,
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<SystemConfig> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<String>? description,
    Expression<String>? category,
    Expression<bool>? isPublic,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (isPublic != null) 'is_public': isPublic,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SystemConfigsCompanion copyWith(
      {Value<String>? key,
      Value<String>? value,
      Value<String?>? description,
      Value<String>? category,
      Value<bool>? isPublic,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SystemConfigsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      description: description ?? this.description,
      category: category ?? this.category,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isPublic.present) {
      map['is_public'] = Variable<bool>(isPublic.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('SystemConfigsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('isPublic: $isPublic, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VersionHistoryTable extends VersionHistory
    with TableInfo<$VersionHistoryTable, VersionHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VersionHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _changesMeta =
      const VerificationMeta('changes');
  @override
  late final GeneratedColumn<String> changes = GeneratedColumn<String>(
      'changes', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isMajorMeta =
      const VerificationMeta('isMajor');
  @override
  late final GeneratedColumn<bool> isMajor = GeneratedColumn<bool>(
      'is_major', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_major" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _releaseDateMeta =
      const VerificationMeta('releaseDate');
  @override
  late final GeneratedColumn<DateTime> releaseDate = GeneratedColumn<DateTime>(
      'release_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, version, title, changes, isMajor, releaseDate, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'version_history';
  @override
  VerificationContext validateIntegrity(Insertable<VersionHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('changes')) {
      context.handle(_changesMeta,
          changes.isAcceptableOrUnknown(data['changes']!, _changesMeta));
    } else if (isInserting) {
      context.missing(_changesMeta);
    }
    if (data.containsKey('is_major')) {
      context.handle(_isMajorMeta,
          isMajor.isAcceptableOrUnknown(data['is_major']!, _isMajorMeta));
    }
    if (data.containsKey('release_date')) {
      context.handle(
          _releaseDateMeta,
          releaseDate.isAcceptableOrUnknown(
              data['release_date']!, _releaseDateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VersionHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VersionHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      changes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}changes'])!,
      isMajor: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_major'])!,
      releaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}release_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $VersionHistoryTable createAlias(String alias) {
    return $VersionHistoryTable(attachedDatabase, alias);
  }
}

class VersionHistoryData extends DataClass
    implements Insertable<VersionHistoryData> {
  /// 版本ID
  final int id;

  /// 版本号
  final String version;

  /// 更新标题
  final String title;

  /// 更新内容 (JSON)
  final String changes;

  /// 是否重大更新
  final bool isMajor;

  /// 发布日期
  final DateTime releaseDate;

  /// 创建时间
  final DateTime createdAt;
  const VersionHistoryData(
      {required this.id,
      required this.version,
      required this.title,
      required this.changes,
      required this.isMajor,
      required this.releaseDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['version'] = Variable<String>(version);
    map['title'] = Variable<String>(title);
    map['changes'] = Variable<String>(changes);
    map['is_major'] = Variable<bool>(isMajor);
    map['release_date'] = Variable<DateTime>(releaseDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VersionHistoryCompanion toCompanion(bool nullToAbsent) {
    return VersionHistoryCompanion(
      id: Value(id),
      version: Value(version),
      title: Value(title),
      changes: Value(changes),
      isMajor: Value(isMajor),
      releaseDate: Value(releaseDate),
      createdAt: Value(createdAt),
    );
  }

  factory VersionHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VersionHistoryData(
      id: serializer.fromJson<int>(json['id']),
      version: serializer.fromJson<String>(json['version']),
      title: serializer.fromJson<String>(json['title']),
      changes: serializer.fromJson<String>(json['changes']),
      isMajor: serializer.fromJson<bool>(json['isMajor']),
      releaseDate: serializer.fromJson<DateTime>(json['releaseDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'version': serializer.toJson<String>(version),
      'title': serializer.toJson<String>(title),
      'changes': serializer.toJson<String>(changes),
      'isMajor': serializer.toJson<bool>(isMajor),
      'releaseDate': serializer.toJson<DateTime>(releaseDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VersionHistoryData copyWith(
          {int? id,
          String? version,
          String? title,
          String? changes,
          bool? isMajor,
          DateTime? releaseDate,
          DateTime? createdAt}) =>
      VersionHistoryData(
        id: id ?? this.id,
        version: version ?? this.version,
        title: title ?? this.title,
        changes: changes ?? this.changes,
        isMajor: isMajor ?? this.isMajor,
        releaseDate: releaseDate ?? this.releaseDate,
        createdAt: createdAt ?? this.createdAt,
      );
  VersionHistoryData copyWithCompanion(VersionHistoryCompanion data) {
    return VersionHistoryData(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      title: data.title.present ? data.title.value : this.title,
      changes: data.changes.present ? data.changes.value : this.changes,
      isMajor: data.isMajor.present ? data.isMajor.value : this.isMajor,
      releaseDate:
          data.releaseDate.present ? data.releaseDate.value : this.releaseDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VersionHistoryData(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('title: $title, ')
          ..write('changes: $changes, ')
          ..write('isMajor: $isMajor, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, version, title, changes, isMajor, releaseDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VersionHistoryData &&
          other.id == this.id &&
          other.version == this.version &&
          other.title == this.title &&
          other.changes == this.changes &&
          other.isMajor == this.isMajor &&
          other.releaseDate == this.releaseDate &&
          other.createdAt == this.createdAt);
}

class VersionHistoryCompanion extends UpdateCompanion<VersionHistoryData> {
  final Value<int> id;
  final Value<String> version;
  final Value<String> title;
  final Value<String> changes;
  final Value<bool> isMajor;
  final Value<DateTime> releaseDate;
  final Value<DateTime> createdAt;
  const VersionHistoryCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.title = const Value.absent(),
    this.changes = const Value.absent(),
    this.isMajor = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VersionHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String version,
    required String title,
    required String changes,
    this.isMajor = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : version = Value(version),
        title = Value(title),
        changes = Value(changes);
  static Insertable<VersionHistoryData> custom({
    Expression<int>? id,
    Expression<String>? version,
    Expression<String>? title,
    Expression<String>? changes,
    Expression<bool>? isMajor,
    Expression<DateTime>? releaseDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (title != null) 'title': title,
      if (changes != null) 'changes': changes,
      if (isMajor != null) 'is_major': isMajor,
      if (releaseDate != null) 'release_date': releaseDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VersionHistoryCompanion copyWith(
      {Value<int>? id,
      Value<String>? version,
      Value<String>? title,
      Value<String>? changes,
      Value<bool>? isMajor,
      Value<DateTime>? releaseDate,
      Value<DateTime>? createdAt}) {
    return VersionHistoryCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      title: title ?? this.title,
      changes: changes ?? this.changes,
      isMajor: isMajor ?? this.isMajor,
      releaseDate: releaseDate ?? this.releaseDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (changes.present) {
      map['changes'] = Variable<String>(changes.value);
    }
    if (isMajor.present) {
      map['is_major'] = Variable<bool>(isMajor.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<DateTime>(releaseDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VersionHistoryCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('title: $title, ')
          ..write('changes: $changes, ')
          ..write('isMajor: $isMajor, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $UserPreferencesTable userPreferences =
      $UserPreferencesTable(this);
  late final $MarketsTable markets = $MarketsTable(this);
  late final $SymbolsTable symbols = $SymbolsTable(this);
  late final $KlineDataTable klineData = $KlineDataTable(this);
  late final $StockFilterResultsTable stockFilterResults =
      $StockFilterResultsTable(this);
  late final $DailyStockStatsTable dailyStockStats =
      $DailyStockStatsTable(this);
  late final $TrainingSessionsTable trainingSessions =
      $TrainingSessionsTable(this);
  late final $PositionsTable positions = $PositionsTable(this);
  late final $TradesTable trades = $TradesTable(this);
  late final $ConditionalOrdersTable conditionalOrders =
      $ConditionalOrdersTable(this);
  late final $OperationLogsTable operationLogs = $OperationLogsTable(this);
  late final $TrainingReportsTable trainingReports =
      $TrainingReportsTable(this);
  late final $UserHabitsTable userHabits = $UserHabitsTable(this);
  late final $TradingPatternsTable tradingPatterns =
      $TradingPatternsTable(this);
  late final $StrategyTipsTable strategyTips = $StrategyTipsTable(this);
  late final $SystemConfigsTable systemConfigs = $SystemConfigsTable(this);
  late final $VersionHistoryTable versionHistory = $VersionHistoryTable(this);
  late final UserDao userDao = UserDao(this as AppDatabase);
  late final KlineDao klineDao = KlineDao(this as AppDatabase);
  late final MarketDao marketDao = MarketDao(this as AppDatabase);
  late final TrainingDao trainingDao = TrainingDao(this as AppDatabase);
  late final TradeDao tradeDao = TradeDao(this as AppDatabase);
  late final AnalysisDao analysisDao = AnalysisDao(this as AppDatabase);
  late final ConfigDao configDao = ConfigDao(this as AppDatabase);
  late final StockFilterDao stockFilterDao =
      StockFilterDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        userProfiles,
        userPreferences,
        markets,
        symbols,
        klineData,
        stockFilterResults,
        dailyStockStats,
        trainingSessions,
        positions,
        trades,
        conditionalOrders,
        operationLogs,
        trainingReports,
        userHabits,
        tradingPatterns,
        strategyTips,
        systemConfigs,
        versionHistory
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('users',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('user_profiles', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('users',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('user_preferences', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('users',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('user_habits', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String phone,
  Value<String?> password,
  Value<String?> salt,
  Value<String?> nickname,
  Value<String?> avatar,
  Value<String?> email,
  Value<int> memberLevel,
  Value<int> experience,
  Value<double> totalProfit,
  Value<int> totalTrainingDays,
  Value<double> avgDailyDuration,
  Value<double> overallWinRate,
  Value<double> avgProfitRate,
  Value<String> status,
  Value<DateTime?> lastLoginAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> phone,
  Value<String?> password,
  Value<String?> salt,
  Value<String?> nickname,
  Value<String?> avatar,
  Value<String?> email,
  Value<int> memberLevel,
  Value<int> experience,
  Value<double> totalProfit,
  Value<int> totalTrainingDays,
  Value<double> avgDailyDuration,
  Value<double> overallWinRate,
  Value<double> avgProfitRate,
  Value<String> status,
  Value<DateTime?> lastLoginAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserProfilesTable, List<UserProfile>>
      _userProfilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.userProfiles,
          aliasName: $_aliasNameGenerator(db.users.id, db.userProfiles.userId));

  $$UserProfilesTableProcessedTableManager get userProfilesRefs {
    final manager = $$UserProfilesTableTableManager($_db, $_db.userProfiles)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userProfilesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$UserPreferencesTable, List<UserPreference>>
      _userPreferencesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.userPreferences,
              aliasName:
                  $_aliasNameGenerator(db.users.id, db.userPreferences.userId));

  $$UserPreferencesTableProcessedTableManager get userPreferencesRefs {
    final manager =
        $$UserPreferencesTableTableManager($_db, $_db.userPreferences)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_userPreferencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TrainingSessionsTable, List<TrainingSession>>
      _trainingSessionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.trainingSessions,
              aliasName: $_aliasNameGenerator(
                  db.users.id, db.trainingSessions.userId));

  $$TrainingSessionsTableProcessedTableManager get trainingSessionsRefs {
    final manager =
        $$TrainingSessionsTableTableManager($_db, $_db.trainingSessions)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_trainingSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PositionsTable, List<Position>>
      _positionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.positions,
          aliasName: $_aliasNameGenerator(db.users.id, db.positions.userId));

  $$PositionsTableProcessedTableManager get positionsRefs {
    final manager = $$PositionsTableTableManager($_db, $_db.positions)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_positionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TradesTable, List<Trade>> _tradesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.trades,
          aliasName: $_aliasNameGenerator(db.users.id, db.trades.userId));

  $$TradesTableProcessedTableManager get tradesRefs {
    final manager = $$TradesTableTableManager($_db, $_db.trades)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tradesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ConditionalOrdersTable, List<ConditionalOrder>>
      _conditionalOrdersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.conditionalOrders,
              aliasName: $_aliasNameGenerator(
                  db.users.id, db.conditionalOrders.userId));

  $$ConditionalOrdersTableProcessedTableManager get conditionalOrdersRefs {
    final manager =
        $$ConditionalOrdersTableTableManager($_db, $_db.conditionalOrders)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_conditionalOrdersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OperationLogsTable, List<OperationLog>>
      _operationLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.operationLogs,
              aliasName:
                  $_aliasNameGenerator(db.users.id, db.operationLogs.userId));

  $$OperationLogsTableProcessedTableManager get operationLogsRefs {
    final manager = $$OperationLogsTableTableManager($_db, $_db.operationLogs)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_operationLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TrainingReportsTable, List<TrainingReport>>
      _trainingReportsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.trainingReports,
              aliasName:
                  $_aliasNameGenerator(db.users.id, db.trainingReports.userId));

  $$TrainingReportsTableProcessedTableManager get trainingReportsRefs {
    final manager =
        $$TrainingReportsTableTableManager($_db, $_db.trainingReports)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_trainingReportsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$UserHabitsTable, List<UserHabit>>
      _userHabitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.userHabits,
          aliasName: $_aliasNameGenerator(db.users.id, db.userHabits.userId));

  $$UserHabitsTableProcessedTableManager get userHabitsRefs {
    final manager = $$UserHabitsTableTableManager($_db, $_db.userHabits)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userHabitsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TradingPatternsTable, List<TradingPattern>>
      _tradingPatternsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.tradingPatterns,
              aliasName:
                  $_aliasNameGenerator(db.users.id, db.tradingPatterns.userId));

  $$TradingPatternsTableProcessedTableManager get tradingPatternsRefs {
    final manager =
        $$TradingPatternsTableTableManager($_db, $_db.tradingPatterns)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_tradingPatternsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get memberLevel => $composableBuilder(
      column: $table.memberLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get experience => $composableBuilder(
      column: $table.experience, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalProfit => $composableBuilder(
      column: $table.totalProfit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalTrainingDays => $composableBuilder(
      column: $table.totalTrainingDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgDailyDuration => $composableBuilder(
      column: $table.avgDailyDuration,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get overallWinRate => $composableBuilder(
      column: $table.overallWinRate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgProfitRate => $composableBuilder(
      column: $table.avgProfitRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> userProfilesRefs(
      Expression<bool> Function($$UserProfilesTableFilterComposer f) f) {
    final $$UserProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userProfiles,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserProfilesTableFilterComposer(
              $db: $db,
              $table: $db.userProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> userPreferencesRefs(
      Expression<bool> Function($$UserPreferencesTableFilterComposer f) f) {
    final $$UserPreferencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userPreferences,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserPreferencesTableFilterComposer(
              $db: $db,
              $table: $db.userPreferences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> trainingSessionsRefs(
      Expression<bool> Function($$TrainingSessionsTableFilterComposer f) f) {
    final $$TrainingSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableFilterComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> positionsRefs(
      Expression<bool> Function($$PositionsTableFilterComposer f) f) {
    final $$PositionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.positions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PositionsTableFilterComposer(
              $db: $db,
              $table: $db.positions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> tradesRefs(
      Expression<bool> Function($$TradesTableFilterComposer f) f) {
    final $$TradesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trades,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TradesTableFilterComposer(
              $db: $db,
              $table: $db.trades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> conditionalOrdersRefs(
      Expression<bool> Function($$ConditionalOrdersTableFilterComposer f) f) {
    final $$ConditionalOrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.conditionalOrders,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConditionalOrdersTableFilterComposer(
              $db: $db,
              $table: $db.conditionalOrders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> operationLogsRefs(
      Expression<bool> Function($$OperationLogsTableFilterComposer f) f) {
    final $$OperationLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.operationLogs,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OperationLogsTableFilterComposer(
              $db: $db,
              $table: $db.operationLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> trainingReportsRefs(
      Expression<bool> Function($$TrainingReportsTableFilterComposer f) f) {
    final $$TrainingReportsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trainingReports,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingReportsTableFilterComposer(
              $db: $db,
              $table: $db.trainingReports,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> userHabitsRefs(
      Expression<bool> Function($$UserHabitsTableFilterComposer f) f) {
    final $$UserHabitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userHabits,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserHabitsTableFilterComposer(
              $db: $db,
              $table: $db.userHabits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> tradingPatternsRefs(
      Expression<bool> Function($$TradingPatternsTableFilterComposer f) f) {
    final $$TradingPatternsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tradingPatterns,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TradingPatternsTableFilterComposer(
              $db: $db,
              $table: $db.tradingPatterns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get memberLevel => $composableBuilder(
      column: $table.memberLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get experience => $composableBuilder(
      column: $table.experience, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalProfit => $composableBuilder(
      column: $table.totalProfit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalTrainingDays => $composableBuilder(
      column: $table.totalTrainingDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgDailyDuration => $composableBuilder(
      column: $table.avgDailyDuration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get overallWinRate => $composableBuilder(
      column: $table.overallWinRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgProfitRate => $composableBuilder(
      column: $table.avgProfitRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get memberLevel => $composableBuilder(
      column: $table.memberLevel, builder: (column) => column);

  GeneratedColumn<int> get experience => $composableBuilder(
      column: $table.experience, builder: (column) => column);

  GeneratedColumn<double> get totalProfit => $composableBuilder(
      column: $table.totalProfit, builder: (column) => column);

  GeneratedColumn<int> get totalTrainingDays => $composableBuilder(
      column: $table.totalTrainingDays, builder: (column) => column);

  GeneratedColumn<double> get avgDailyDuration => $composableBuilder(
      column: $table.avgDailyDuration, builder: (column) => column);

  GeneratedColumn<double> get overallWinRate => $composableBuilder(
      column: $table.overallWinRate, builder: (column) => column);

  GeneratedColumn<double> get avgProfitRate => $composableBuilder(
      column: $table.avgProfitRate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> userProfilesRefs<T extends Object>(
      Expression<T> Function($$UserProfilesTableAnnotationComposer a) f) {
    final $$UserProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userProfiles,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.userProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> userPreferencesRefs<T extends Object>(
      Expression<T> Function($$UserPreferencesTableAnnotationComposer a) f) {
    final $$UserPreferencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userPreferences,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserPreferencesTableAnnotationComposer(
              $db: $db,
              $table: $db.userPreferences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> trainingSessionsRefs<T extends Object>(
      Expression<T> Function($$TrainingSessionsTableAnnotationComposer a) f) {
    final $$TrainingSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> positionsRefs<T extends Object>(
      Expression<T> Function($$PositionsTableAnnotationComposer a) f) {
    final $$PositionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.positions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PositionsTableAnnotationComposer(
              $db: $db,
              $table: $db.positions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> tradesRefs<T extends Object>(
      Expression<T> Function($$TradesTableAnnotationComposer a) f) {
    final $$TradesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trades,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TradesTableAnnotationComposer(
              $db: $db,
              $table: $db.trades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> conditionalOrdersRefs<T extends Object>(
      Expression<T> Function($$ConditionalOrdersTableAnnotationComposer a) f) {
    final $$ConditionalOrdersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.conditionalOrders,
            getReferencedColumn: (t) => t.userId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ConditionalOrdersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.conditionalOrders,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> operationLogsRefs<T extends Object>(
      Expression<T> Function($$OperationLogsTableAnnotationComposer a) f) {
    final $$OperationLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.operationLogs,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OperationLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.operationLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> trainingReportsRefs<T extends Object>(
      Expression<T> Function($$TrainingReportsTableAnnotationComposer a) f) {
    final $$TrainingReportsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trainingReports,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingReportsTableAnnotationComposer(
              $db: $db,
              $table: $db.trainingReports,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> userHabitsRefs<T extends Object>(
      Expression<T> Function($$UserHabitsTableAnnotationComposer a) f) {
    final $$UserHabitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userHabits,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserHabitsTableAnnotationComposer(
              $db: $db,
              $table: $db.userHabits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> tradingPatternsRefs<T extends Object>(
      Expression<T> Function($$TradingPatternsTableAnnotationComposer a) f) {
    final $$TradingPatternsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tradingPatterns,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TradingPatternsTableAnnotationComposer(
              $db: $db,
              $table: $db.tradingPatterns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool userProfilesRefs,
        bool userPreferencesRefs,
        bool trainingSessionsRefs,
        bool positionsRefs,
        bool tradesRefs,
        bool conditionalOrdersRefs,
        bool operationLogsRefs,
        bool trainingReportsRefs,
        bool userHabitsRefs,
        bool tradingPatternsRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String?> password = const Value.absent(),
            Value<String?> salt = const Value.absent(),
            Value<String?> nickname = const Value.absent(),
            Value<String?> avatar = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<int> memberLevel = const Value.absent(),
            Value<int> experience = const Value.absent(),
            Value<double> totalProfit = const Value.absent(),
            Value<int> totalTrainingDays = const Value.absent(),
            Value<double> avgDailyDuration = const Value.absent(),
            Value<double> overallWinRate = const Value.absent(),
            Value<double> avgProfitRate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            phone: phone,
            password: password,
            salt: salt,
            nickname: nickname,
            avatar: avatar,
            email: email,
            memberLevel: memberLevel,
            experience: experience,
            totalProfit: totalProfit,
            totalTrainingDays: totalTrainingDays,
            avgDailyDuration: avgDailyDuration,
            overallWinRate: overallWinRate,
            avgProfitRate: avgProfitRate,
            status: status,
            lastLoginAt: lastLoginAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String phone,
            Value<String?> password = const Value.absent(),
            Value<String?> salt = const Value.absent(),
            Value<String?> nickname = const Value.absent(),
            Value<String?> avatar = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<int> memberLevel = const Value.absent(),
            Value<int> experience = const Value.absent(),
            Value<double> totalProfit = const Value.absent(),
            Value<int> totalTrainingDays = const Value.absent(),
            Value<double> avgDailyDuration = const Value.absent(),
            Value<double> overallWinRate = const Value.absent(),
            Value<double> avgProfitRate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            phone: phone,
            password: password,
            salt: salt,
            nickname: nickname,
            avatar: avatar,
            email: email,
            memberLevel: memberLevel,
            experience: experience,
            totalProfit: totalProfit,
            totalTrainingDays: totalTrainingDays,
            avgDailyDuration: avgDailyDuration,
            overallWinRate: overallWinRate,
            avgProfitRate: avgProfitRate,
            status: status,
            lastLoginAt: lastLoginAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {userProfilesRefs = false,
              userPreferencesRefs = false,
              trainingSessionsRefs = false,
              positionsRefs = false,
              tradesRefs = false,
              conditionalOrdersRefs = false,
              operationLogsRefs = false,
              trainingReportsRefs = false,
              userHabitsRefs = false,
              tradingPatternsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (userProfilesRefs) db.userProfiles,
                if (userPreferencesRefs) db.userPreferences,
                if (trainingSessionsRefs) db.trainingSessions,
                if (positionsRefs) db.positions,
                if (tradesRefs) db.trades,
                if (conditionalOrdersRefs) db.conditionalOrders,
                if (operationLogsRefs) db.operationLogs,
                if (trainingReportsRefs) db.trainingReports,
                if (userHabitsRefs) db.userHabits,
                if (tradingPatternsRefs) db.tradingPatterns
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userProfilesRefs)
                    await $_getPrefetchedData<User, $UsersTable, UserProfile>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._userProfilesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .userProfilesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (userPreferencesRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            UserPreference>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._userPreferencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .userPreferencesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (trainingSessionsRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            TrainingSession>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._trainingSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .trainingSessionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (positionsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Position>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._positionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).positionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (tradesRefs)
                    await $_getPrefetchedData<User, $UsersTable, Trade>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._tradesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).tradesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (conditionalOrdersRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            ConditionalOrder>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._conditionalOrdersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .conditionalOrdersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (operationLogsRefs)
                    await $_getPrefetchedData<User, $UsersTable, OperationLog>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._operationLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .operationLogsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (trainingReportsRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            TrainingReport>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._trainingReportsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .trainingReportsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (userHabitsRefs)
                    await $_getPrefetchedData<User, $UsersTable, UserHabit>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._userHabitsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .userHabitsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (tradingPatternsRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            TradingPattern>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._tradingPatternsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .tradingPatternsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool userProfilesRefs,
        bool userPreferencesRefs,
        bool trainingSessionsRefs,
        bool positionsRefs,
        bool tradesRefs,
        bool conditionalOrdersRefs,
        bool operationLogsRefs,
        bool trainingReportsRefs,
        bool userHabitsRefs,
        bool tradingPatternsRefs})>;
typedef $$UserProfilesTableCreateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> userId,
  Value<String?> realName,
  Value<String?> idCard,
  Value<String?> gender,
  Value<DateTime?> birthday,
  Value<String?> region,
  Value<String?> tradingExperience,
  Value<String?> investmentGoal,
  Value<String?> riskTolerance,
  Value<String?> favoriteMarkets,
  Value<String?> bio,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UserProfilesTableUpdateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> userId,
  Value<String?> realName,
  Value<String?> idCard,
  Value<String?> gender,
  Value<DateTime?> birthday,
  Value<String?> region,
  Value<String?> tradingExperience,
  Value<String?> investmentGoal,
  Value<String?> riskTolerance,
  Value<String?> favoriteMarkets,
  Value<String?> bio,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$UserProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile> {
  $$UserProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.userProfiles.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get realName => $composableBuilder(
      column: $table.realName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idCard => $composableBuilder(
      column: $table.idCard, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get birthday => $composableBuilder(
      column: $table.birthday, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get region => $composableBuilder(
      column: $table.region, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tradingExperience => $composableBuilder(
      column: $table.tradingExperience,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get investmentGoal => $composableBuilder(
      column: $table.investmentGoal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get riskTolerance => $composableBuilder(
      column: $table.riskTolerance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get favoriteMarkets => $composableBuilder(
      column: $table.favoriteMarkets,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bio => $composableBuilder(
      column: $table.bio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get realName => $composableBuilder(
      column: $table.realName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idCard => $composableBuilder(
      column: $table.idCard, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get birthday => $composableBuilder(
      column: $table.birthday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get region => $composableBuilder(
      column: $table.region, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tradingExperience => $composableBuilder(
      column: $table.tradingExperience,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get investmentGoal => $composableBuilder(
      column: $table.investmentGoal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get riskTolerance => $composableBuilder(
      column: $table.riskTolerance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get favoriteMarkets => $composableBuilder(
      column: $table.favoriteMarkets,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bio => $composableBuilder(
      column: $table.bio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get realName =>
      $composableBuilder(column: $table.realName, builder: (column) => column);

  GeneratedColumn<String> get idCard =>
      $composableBuilder(column: $table.idCard, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<DateTime> get birthday =>
      $composableBuilder(column: $table.birthday, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get tradingExperience => $composableBuilder(
      column: $table.tradingExperience, builder: (column) => column);

  GeneratedColumn<String> get investmentGoal => $composableBuilder(
      column: $table.investmentGoal, builder: (column) => column);

  GeneratedColumn<String> get riskTolerance => $composableBuilder(
      column: $table.riskTolerance, builder: (column) => column);

  GeneratedColumn<String> get favoriteMarkets => $composableBuilder(
      column: $table.favoriteMarkets, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfile,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (UserProfile, $$UserProfilesTableReferences),
    UserProfile,
    PrefetchHooks Function({bool userId})> {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> userId = const Value.absent(),
            Value<String?> realName = const Value.absent(),
            Value<String?> idCard = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<DateTime?> birthday = const Value.absent(),
            Value<String?> region = const Value.absent(),
            Value<String?> tradingExperience = const Value.absent(),
            Value<String?> investmentGoal = const Value.absent(),
            Value<String?> riskTolerance = const Value.absent(),
            Value<String?> favoriteMarkets = const Value.absent(),
            Value<String?> bio = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserProfilesCompanion(
            userId: userId,
            realName: realName,
            idCard: idCard,
            gender: gender,
            birthday: birthday,
            region: region,
            tradingExperience: tradingExperience,
            investmentGoal: investmentGoal,
            riskTolerance: riskTolerance,
            favoriteMarkets: favoriteMarkets,
            bio: bio,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> userId = const Value.absent(),
            Value<String?> realName = const Value.absent(),
            Value<String?> idCard = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<DateTime?> birthday = const Value.absent(),
            Value<String?> region = const Value.absent(),
            Value<String?> tradingExperience = const Value.absent(),
            Value<String?> investmentGoal = const Value.absent(),
            Value<String?> riskTolerance = const Value.absent(),
            Value<String?> favoriteMarkets = const Value.absent(),
            Value<String?> bio = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserProfilesCompanion.insert(
            userId: userId,
            realName: realName,
            idCard: idCard,
            gender: gender,
            birthday: birthday,
            region: region,
            tradingExperience: tradingExperience,
            investmentGoal: investmentGoal,
            riskTolerance: riskTolerance,
            favoriteMarkets: favoriteMarkets,
            bio: bio,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UserProfilesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$UserProfilesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$UserProfilesTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UserProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfile,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (UserProfile, $$UserProfilesTableReferences),
    UserProfile,
    PrefetchHooks Function({bool userId})>;
typedef $$UserPreferencesTableCreateCompanionBuilder = UserPreferencesCompanion
    Function({
  Value<int> userId,
  Value<String> themeMode,
  Value<String> language,
  Value<double> textScale,
  Value<bool> soundEnabled,
  Value<bool> notificationEnabled,
  Value<bool> autoRefresh,
  Value<int> refreshInterval,
  Value<String> defaultMarket,
  Value<String> defaultPeriod,
  Value<String?> indicators,
  Value<bool> showGridLines,
  Value<bool> showVolume,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UserPreferencesTableUpdateCompanionBuilder = UserPreferencesCompanion
    Function({
  Value<int> userId,
  Value<String> themeMode,
  Value<String> language,
  Value<double> textScale,
  Value<bool> soundEnabled,
  Value<bool> notificationEnabled,
  Value<bool> autoRefresh,
  Value<int> refreshInterval,
  Value<String> defaultMarket,
  Value<String> defaultPeriod,
  Value<String?> indicators,
  Value<bool> showGridLines,
  Value<bool> showVolume,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$UserPreferencesTableReferences extends BaseReferences<
    _$AppDatabase, $UserPreferencesTable, UserPreference> {
  $$UserPreferencesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.userPreferences.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UserPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get textScale => $composableBuilder(
      column: $table.textScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get soundEnabled => $composableBuilder(
      column: $table.soundEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notificationEnabled => $composableBuilder(
      column: $table.notificationEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get autoRefresh => $composableBuilder(
      column: $table.autoRefresh, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get refreshInterval => $composableBuilder(
      column: $table.refreshInterval,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultMarket => $composableBuilder(
      column: $table.defaultMarket, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultPeriod => $composableBuilder(
      column: $table.defaultPeriod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get indicators => $composableBuilder(
      column: $table.indicators, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showGridLines => $composableBuilder(
      column: $table.showGridLines, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showVolume => $composableBuilder(
      column: $table.showVolume, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get textScale => $composableBuilder(
      column: $table.textScale, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get soundEnabled => $composableBuilder(
      column: $table.soundEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notificationEnabled => $composableBuilder(
      column: $table.notificationEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get autoRefresh => $composableBuilder(
      column: $table.autoRefresh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get refreshInterval => $composableBuilder(
      column: $table.refreshInterval,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultMarket => $composableBuilder(
      column: $table.defaultMarket,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultPeriod => $composableBuilder(
      column: $table.defaultPeriod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get indicators => $composableBuilder(
      column: $table.indicators, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showGridLines => $composableBuilder(
      column: $table.showGridLines,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showVolume => $composableBuilder(
      column: $table.showVolume, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<double> get textScale =>
      $composableBuilder(column: $table.textScale, builder: (column) => column);

  GeneratedColumn<bool> get soundEnabled => $composableBuilder(
      column: $table.soundEnabled, builder: (column) => column);

  GeneratedColumn<bool> get notificationEnabled => $composableBuilder(
      column: $table.notificationEnabled, builder: (column) => column);

  GeneratedColumn<bool> get autoRefresh => $composableBuilder(
      column: $table.autoRefresh, builder: (column) => column);

  GeneratedColumn<int> get refreshInterval => $composableBuilder(
      column: $table.refreshInterval, builder: (column) => column);

  GeneratedColumn<String> get defaultMarket => $composableBuilder(
      column: $table.defaultMarket, builder: (column) => column);

  GeneratedColumn<String> get defaultPeriod => $composableBuilder(
      column: $table.defaultPeriod, builder: (column) => column);

  GeneratedColumn<String> get indicators => $composableBuilder(
      column: $table.indicators, builder: (column) => column);

  GeneratedColumn<bool> get showGridLines => $composableBuilder(
      column: $table.showGridLines, builder: (column) => column);

  GeneratedColumn<bool> get showVolume => $composableBuilder(
      column: $table.showVolume, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserPreferencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserPreferencesTable,
    UserPreference,
    $$UserPreferencesTableFilterComposer,
    $$UserPreferencesTableOrderingComposer,
    $$UserPreferencesTableAnnotationComposer,
    $$UserPreferencesTableCreateCompanionBuilder,
    $$UserPreferencesTableUpdateCompanionBuilder,
    (UserPreference, $$UserPreferencesTableReferences),
    UserPreference,
    PrefetchHooks Function({bool userId})> {
  $$UserPreferencesTableTableManager(
      _$AppDatabase db, $UserPreferencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> userId = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<double> textScale = const Value.absent(),
            Value<bool> soundEnabled = const Value.absent(),
            Value<bool> notificationEnabled = const Value.absent(),
            Value<bool> autoRefresh = const Value.absent(),
            Value<int> refreshInterval = const Value.absent(),
            Value<String> defaultMarket = const Value.absent(),
            Value<String> defaultPeriod = const Value.absent(),
            Value<String?> indicators = const Value.absent(),
            Value<bool> showGridLines = const Value.absent(),
            Value<bool> showVolume = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserPreferencesCompanion(
            userId: userId,
            themeMode: themeMode,
            language: language,
            textScale: textScale,
            soundEnabled: soundEnabled,
            notificationEnabled: notificationEnabled,
            autoRefresh: autoRefresh,
            refreshInterval: refreshInterval,
            defaultMarket: defaultMarket,
            defaultPeriod: defaultPeriod,
            indicators: indicators,
            showGridLines: showGridLines,
            showVolume: showVolume,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> userId = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<double> textScale = const Value.absent(),
            Value<bool> soundEnabled = const Value.absent(),
            Value<bool> notificationEnabled = const Value.absent(),
            Value<bool> autoRefresh = const Value.absent(),
            Value<int> refreshInterval = const Value.absent(),
            Value<String> defaultMarket = const Value.absent(),
            Value<String> defaultPeriod = const Value.absent(),
            Value<String?> indicators = const Value.absent(),
            Value<bool> showGridLines = const Value.absent(),
            Value<bool> showVolume = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserPreferencesCompanion.insert(
            userId: userId,
            themeMode: themeMode,
            language: language,
            textScale: textScale,
            soundEnabled: soundEnabled,
            notificationEnabled: notificationEnabled,
            autoRefresh: autoRefresh,
            refreshInterval: refreshInterval,
            defaultMarket: defaultMarket,
            defaultPeriod: defaultPeriod,
            indicators: indicators,
            showGridLines: showGridLines,
            showVolume: showVolume,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UserPreferencesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$UserPreferencesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$UserPreferencesTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UserPreferencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserPreferencesTable,
    UserPreference,
    $$UserPreferencesTableFilterComposer,
    $$UserPreferencesTableOrderingComposer,
    $$UserPreferencesTableAnnotationComposer,
    $$UserPreferencesTableCreateCompanionBuilder,
    $$UserPreferencesTableUpdateCompanionBuilder,
    (UserPreference, $$UserPreferencesTableReferences),
    UserPreference,
    PrefetchHooks Function({bool userId})>;
typedef $$MarketsTableCreateCompanionBuilder = MarketsCompanion Function({
  Value<int> id,
  required String code,
  required String name,
  Value<String?> description,
  required String currency,
  Value<bool> enabled,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$MarketsTableUpdateCompanionBuilder = MarketsCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<String> name,
  Value<String?> description,
  Value<String> currency,
  Value<bool> enabled,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$MarketsTableReferences
    extends BaseReferences<_$AppDatabase, $MarketsTable, Market> {
  $$MarketsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SymbolsTable, List<Symbol>> _symbolsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.symbols,
          aliasName:
              $_aliasNameGenerator(db.markets.code, db.symbols.marketCode));

  $$SymbolsTableProcessedTableManager get symbolsRefs {
    final manager = $$SymbolsTableTableManager($_db, $_db.symbols).filter(
        (f) => f.marketCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_symbolsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MarketsTableFilterComposer
    extends Composer<_$AppDatabase, $MarketsTable> {
  $$MarketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> symbolsRefs(
      Expression<bool> Function($$SymbolsTableFilterComposer f) f) {
    final $$SymbolsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.symbols,
        getReferencedColumn: (t) => t.marketCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SymbolsTableFilterComposer(
              $db: $db,
              $table: $db.symbols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MarketsTableOrderingComposer
    extends Composer<_$AppDatabase, $MarketsTable> {
  $$MarketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MarketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MarketsTable> {
  $$MarketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> symbolsRefs<T extends Object>(
      Expression<T> Function($$SymbolsTableAnnotationComposer a) f) {
    final $$SymbolsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.symbols,
        getReferencedColumn: (t) => t.marketCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SymbolsTableAnnotationComposer(
              $db: $db,
              $table: $db.symbols,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MarketsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MarketsTable,
    Market,
    $$MarketsTableFilterComposer,
    $$MarketsTableOrderingComposer,
    $$MarketsTableAnnotationComposer,
    $$MarketsTableCreateCompanionBuilder,
    $$MarketsTableUpdateCompanionBuilder,
    (Market, $$MarketsTableReferences),
    Market,
    PrefetchHooks Function({bool symbolsRefs})> {
  $$MarketsTableTableManager(_$AppDatabase db, $MarketsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MarketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MarketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MarketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MarketsCompanion(
            id: id,
            code: code,
            name: name,
            description: description,
            currency: currency,
            enabled: enabled,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String name,
            Value<String?> description = const Value.absent(),
            required String currency,
            Value<bool> enabled = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MarketsCompanion.insert(
            id: id,
            code: code,
            name: name,
            description: description,
            currency: currency,
            enabled: enabled,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MarketsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({symbolsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (symbolsRefs) db.symbols],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (symbolsRefs)
                    await $_getPrefetchedData<Market, $MarketsTable, Symbol>(
                        currentTable: table,
                        referencedTable:
                            $$MarketsTableReferences._symbolsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MarketsTableReferences(db, table, p0).symbolsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.marketCode == item.code),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MarketsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MarketsTable,
    Market,
    $$MarketsTableFilterComposer,
    $$MarketsTableOrderingComposer,
    $$MarketsTableAnnotationComposer,
    $$MarketsTableCreateCompanionBuilder,
    $$MarketsTableUpdateCompanionBuilder,
    (Market, $$MarketsTableReferences),
    Market,
    PrefetchHooks Function({bool symbolsRefs})>;
typedef $$SymbolsTableCreateCompanionBuilder = SymbolsCompanion Function({
  Value<int> id,
  required String symbol,
  required String name,
  required String marketCode,
  Value<String?> industry,
  Value<String?> sector,
  Value<double?> lastPrice,
  Value<double?> change,
  Value<int?> lotSize,
  Value<double?> minTick,
  Value<bool> enabled,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});
typedef $$SymbolsTableUpdateCompanionBuilder = SymbolsCompanion Function({
  Value<int> id,
  Value<String> symbol,
  Value<String> name,
  Value<String> marketCode,
  Value<String?> industry,
  Value<String?> sector,
  Value<double?> lastPrice,
  Value<double?> change,
  Value<int?> lotSize,
  Value<double?> minTick,
  Value<bool> enabled,
  Value<String?> createdAt,
  Value<String?> updatedAt,
});

final class $$SymbolsTableReferences
    extends BaseReferences<_$AppDatabase, $SymbolsTable, Symbol> {
  $$SymbolsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MarketsTable _marketCodeTable(_$AppDatabase db) =>
      db.markets.createAlias(
          $_aliasNameGenerator(db.symbols.marketCode, db.markets.code));

  $$MarketsTableProcessedTableManager get marketCode {
    final $_column = $_itemColumn<String>('market_code')!;

    final manager = $$MarketsTableTableManager($_db, $_db.markets)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_marketCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SymbolsTableFilterComposer
    extends Composer<_$AppDatabase, $SymbolsTable> {
  $$SymbolsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get industry => $composableBuilder(
      column: $table.industry, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sector => $composableBuilder(
      column: $table.sector, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lastPrice => $composableBuilder(
      column: $table.lastPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get change => $composableBuilder(
      column: $table.change, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lotSize => $composableBuilder(
      column: $table.lotSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get minTick => $composableBuilder(
      column: $table.minTick, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$MarketsTableFilterComposer get marketCode {
    final $$MarketsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.marketCode,
        referencedTable: $db.markets,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MarketsTableFilterComposer(
              $db: $db,
              $table: $db.markets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SymbolsTableOrderingComposer
    extends Composer<_$AppDatabase, $SymbolsTable> {
  $$SymbolsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get industry => $composableBuilder(
      column: $table.industry, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sector => $composableBuilder(
      column: $table.sector, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lastPrice => $composableBuilder(
      column: $table.lastPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get change => $composableBuilder(
      column: $table.change, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lotSize => $composableBuilder(
      column: $table.lotSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get minTick => $composableBuilder(
      column: $table.minTick, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$MarketsTableOrderingComposer get marketCode {
    final $$MarketsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.marketCode,
        referencedTable: $db.markets,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MarketsTableOrderingComposer(
              $db: $db,
              $table: $db.markets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SymbolsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymbolsTable> {
  $$SymbolsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get industry =>
      $composableBuilder(column: $table.industry, builder: (column) => column);

  GeneratedColumn<String> get sector =>
      $composableBuilder(column: $table.sector, builder: (column) => column);

  GeneratedColumn<double> get lastPrice =>
      $composableBuilder(column: $table.lastPrice, builder: (column) => column);

  GeneratedColumn<double> get change =>
      $composableBuilder(column: $table.change, builder: (column) => column);

  GeneratedColumn<int> get lotSize =>
      $composableBuilder(column: $table.lotSize, builder: (column) => column);

  GeneratedColumn<double> get minTick =>
      $composableBuilder(column: $table.minTick, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MarketsTableAnnotationComposer get marketCode {
    final $$MarketsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.marketCode,
        referencedTable: $db.markets,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MarketsTableAnnotationComposer(
              $db: $db,
              $table: $db.markets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SymbolsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SymbolsTable,
    Symbol,
    $$SymbolsTableFilterComposer,
    $$SymbolsTableOrderingComposer,
    $$SymbolsTableAnnotationComposer,
    $$SymbolsTableCreateCompanionBuilder,
    $$SymbolsTableUpdateCompanionBuilder,
    (Symbol, $$SymbolsTableReferences),
    Symbol,
    PrefetchHooks Function({bool marketCode})> {
  $$SymbolsTableTableManager(_$AppDatabase db, $SymbolsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymbolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymbolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymbolsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> marketCode = const Value.absent(),
            Value<String?> industry = const Value.absent(),
            Value<String?> sector = const Value.absent(),
            Value<double?> lastPrice = const Value.absent(),
            Value<double?> change = const Value.absent(),
            Value<int?> lotSize = const Value.absent(),
            Value<double?> minTick = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              SymbolsCompanion(
            id: id,
            symbol: symbol,
            name: name,
            marketCode: marketCode,
            industry: industry,
            sector: sector,
            lastPrice: lastPrice,
            change: change,
            lotSize: lotSize,
            minTick: minTick,
            enabled: enabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String symbol,
            required String name,
            required String marketCode,
            Value<String?> industry = const Value.absent(),
            Value<String?> sector = const Value.absent(),
            Value<double?> lastPrice = const Value.absent(),
            Value<double?> change = const Value.absent(),
            Value<int?> lotSize = const Value.absent(),
            Value<double?> minTick = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> updatedAt = const Value.absent(),
          }) =>
              SymbolsCompanion.insert(
            id: id,
            symbol: symbol,
            name: name,
            marketCode: marketCode,
            industry: industry,
            sector: sector,
            lastPrice: lastPrice,
            change: change,
            lotSize: lotSize,
            minTick: minTick,
            enabled: enabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SymbolsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({marketCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (marketCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.marketCode,
                    referencedTable:
                        $$SymbolsTableReferences._marketCodeTable(db),
                    referencedColumn:
                        $$SymbolsTableReferences._marketCodeTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SymbolsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SymbolsTable,
    Symbol,
    $$SymbolsTableFilterComposer,
    $$SymbolsTableOrderingComposer,
    $$SymbolsTableAnnotationComposer,
    $$SymbolsTableCreateCompanionBuilder,
    $$SymbolsTableUpdateCompanionBuilder,
    (Symbol, $$SymbolsTableReferences),
    Symbol,
    PrefetchHooks Function({bool marketCode})>;
typedef $$KlineDataTableCreateCompanionBuilder = KlineDataCompanion Function({
  required String symbol,
  required String marketCode,
  required String period,
  required DateTime tradeDate,
  required double open,
  required double close,
  required double high,
  required double low,
  required double volume,
  required double amount,
  Value<double?> turnoverRate,
  Value<double?> pe,
  Value<double?> pb,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$KlineDataTableUpdateCompanionBuilder = KlineDataCompanion Function({
  Value<String> symbol,
  Value<String> marketCode,
  Value<String> period,
  Value<DateTime> tradeDate,
  Value<double> open,
  Value<double> close,
  Value<double> high,
  Value<double> low,
  Value<double> volume,
  Value<double> amount,
  Value<double?> turnoverRate,
  Value<double?> pe,
  Value<double?> pb,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$KlineDataTableFilterComposer
    extends Composer<_$AppDatabase, $KlineDataTable> {
  $$KlineDataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get period => $composableBuilder(
      column: $table.period, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get tradeDate => $composableBuilder(
      column: $table.tradeDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get open => $composableBuilder(
      column: $table.open, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get close => $composableBuilder(
      column: $table.close, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get high => $composableBuilder(
      column: $table.high, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get low => $composableBuilder(
      column: $table.low, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get volume => $composableBuilder(
      column: $table.volume, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get turnoverRate => $composableBuilder(
      column: $table.turnoverRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pe => $composableBuilder(
      column: $table.pe, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pb => $composableBuilder(
      column: $table.pb, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$KlineDataTableOrderingComposer
    extends Composer<_$AppDatabase, $KlineDataTable> {
  $$KlineDataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get period => $composableBuilder(
      column: $table.period, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get tradeDate => $composableBuilder(
      column: $table.tradeDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get open => $composableBuilder(
      column: $table.open, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get close => $composableBuilder(
      column: $table.close, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get high => $composableBuilder(
      column: $table.high, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get low => $composableBuilder(
      column: $table.low, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get volume => $composableBuilder(
      column: $table.volume, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get turnoverRate => $composableBuilder(
      column: $table.turnoverRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pe => $composableBuilder(
      column: $table.pe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pb => $composableBuilder(
      column: $table.pb, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$KlineDataTableAnnotationComposer
    extends Composer<_$AppDatabase, $KlineDataTable> {
  $$KlineDataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<DateTime> get tradeDate =>
      $composableBuilder(column: $table.tradeDate, builder: (column) => column);

  GeneratedColumn<double> get open =>
      $composableBuilder(column: $table.open, builder: (column) => column);

  GeneratedColumn<double> get close =>
      $composableBuilder(column: $table.close, builder: (column) => column);

  GeneratedColumn<double> get high =>
      $composableBuilder(column: $table.high, builder: (column) => column);

  GeneratedColumn<double> get low =>
      $composableBuilder(column: $table.low, builder: (column) => column);

  GeneratedColumn<double> get volume =>
      $composableBuilder(column: $table.volume, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get turnoverRate => $composableBuilder(
      column: $table.turnoverRate, builder: (column) => column);

  GeneratedColumn<double> get pe =>
      $composableBuilder(column: $table.pe, builder: (column) => column);

  GeneratedColumn<double> get pb =>
      $composableBuilder(column: $table.pb, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$KlineDataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KlineDataTable,
    KlineDataData,
    $$KlineDataTableFilterComposer,
    $$KlineDataTableOrderingComposer,
    $$KlineDataTableAnnotationComposer,
    $$KlineDataTableCreateCompanionBuilder,
    $$KlineDataTableUpdateCompanionBuilder,
    (
      KlineDataData,
      BaseReferences<_$AppDatabase, $KlineDataTable, KlineDataData>
    ),
    KlineDataData,
    PrefetchHooks Function()> {
  $$KlineDataTableTableManager(_$AppDatabase db, $KlineDataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KlineDataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KlineDataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KlineDataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> symbol = const Value.absent(),
            Value<String> marketCode = const Value.absent(),
            Value<String> period = const Value.absent(),
            Value<DateTime> tradeDate = const Value.absent(),
            Value<double> open = const Value.absent(),
            Value<double> close = const Value.absent(),
            Value<double> high = const Value.absent(),
            Value<double> low = const Value.absent(),
            Value<double> volume = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double?> turnoverRate = const Value.absent(),
            Value<double?> pe = const Value.absent(),
            Value<double?> pb = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KlineDataCompanion(
            symbol: symbol,
            marketCode: marketCode,
            period: period,
            tradeDate: tradeDate,
            open: open,
            close: close,
            high: high,
            low: low,
            volume: volume,
            amount: amount,
            turnoverRate: turnoverRate,
            pe: pe,
            pb: pb,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String symbol,
            required String marketCode,
            required String period,
            required DateTime tradeDate,
            required double open,
            required double close,
            required double high,
            required double low,
            required double volume,
            required double amount,
            Value<double?> turnoverRate = const Value.absent(),
            Value<double?> pe = const Value.absent(),
            Value<double?> pb = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KlineDataCompanion.insert(
            symbol: symbol,
            marketCode: marketCode,
            period: period,
            tradeDate: tradeDate,
            open: open,
            close: close,
            high: high,
            low: low,
            volume: volume,
            amount: amount,
            turnoverRate: turnoverRate,
            pe: pe,
            pb: pb,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KlineDataTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KlineDataTable,
    KlineDataData,
    $$KlineDataTableFilterComposer,
    $$KlineDataTableOrderingComposer,
    $$KlineDataTableAnnotationComposer,
    $$KlineDataTableCreateCompanionBuilder,
    $$KlineDataTableUpdateCompanionBuilder,
    (
      KlineDataData,
      BaseReferences<_$AppDatabase, $KlineDataTable, KlineDataData>
    ),
    KlineDataData,
    PrefetchHooks Function()>;
typedef $$StockFilterResultsTableCreateCompanionBuilder
    = StockFilterResultsCompanion Function({
  Value<int> id,
  required DateTime filterDate,
  required String conditionType,
  required String symbol,
  required String marketCode,
  required String symbolName,
  required double closePrice,
  required double changePercent,
  Value<String?> extraData,
  Value<DateTime> createdAt,
});
typedef $$StockFilterResultsTableUpdateCompanionBuilder
    = StockFilterResultsCompanion Function({
  Value<int> id,
  Value<DateTime> filterDate,
  Value<String> conditionType,
  Value<String> symbol,
  Value<String> marketCode,
  Value<String> symbolName,
  Value<double> closePrice,
  Value<double> changePercent,
  Value<String?> extraData,
  Value<DateTime> createdAt,
});

class $$StockFilterResultsTableFilterComposer
    extends Composer<_$AppDatabase, $StockFilterResultsTable> {
  $$StockFilterResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get filterDate => $composableBuilder(
      column: $table.filterDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conditionType => $composableBuilder(
      column: $table.conditionType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbolName => $composableBuilder(
      column: $table.symbolName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get closePrice => $composableBuilder(
      column: $table.closePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get changePercent => $composableBuilder(
      column: $table.changePercent, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extraData => $composableBuilder(
      column: $table.extraData, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$StockFilterResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockFilterResultsTable> {
  $$StockFilterResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get filterDate => $composableBuilder(
      column: $table.filterDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conditionType => $composableBuilder(
      column: $table.conditionType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbolName => $composableBuilder(
      column: $table.symbolName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get closePrice => $composableBuilder(
      column: $table.closePrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get changePercent => $composableBuilder(
      column: $table.changePercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extraData => $composableBuilder(
      column: $table.extraData, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$StockFilterResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockFilterResultsTable> {
  $$StockFilterResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get filterDate => $composableBuilder(
      column: $table.filterDate, builder: (column) => column);

  GeneratedColumn<String> get conditionType => $composableBuilder(
      column: $table.conditionType, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => column);

  GeneratedColumn<String> get symbolName => $composableBuilder(
      column: $table.symbolName, builder: (column) => column);

  GeneratedColumn<double> get closePrice => $composableBuilder(
      column: $table.closePrice, builder: (column) => column);

  GeneratedColumn<double> get changePercent => $composableBuilder(
      column: $table.changePercent, builder: (column) => column);

  GeneratedColumn<String> get extraData =>
      $composableBuilder(column: $table.extraData, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StockFilterResultsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockFilterResultsTable,
    StockFilterResult,
    $$StockFilterResultsTableFilterComposer,
    $$StockFilterResultsTableOrderingComposer,
    $$StockFilterResultsTableAnnotationComposer,
    $$StockFilterResultsTableCreateCompanionBuilder,
    $$StockFilterResultsTableUpdateCompanionBuilder,
    (
      StockFilterResult,
      BaseReferences<_$AppDatabase, $StockFilterResultsTable, StockFilterResult>
    ),
    StockFilterResult,
    PrefetchHooks Function()> {
  $$StockFilterResultsTableTableManager(
      _$AppDatabase db, $StockFilterResultsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockFilterResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockFilterResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockFilterResultsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> filterDate = const Value.absent(),
            Value<String> conditionType = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> marketCode = const Value.absent(),
            Value<String> symbolName = const Value.absent(),
            Value<double> closePrice = const Value.absent(),
            Value<double> changePercent = const Value.absent(),
            Value<String?> extraData = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              StockFilterResultsCompanion(
            id: id,
            filterDate: filterDate,
            conditionType: conditionType,
            symbol: symbol,
            marketCode: marketCode,
            symbolName: symbolName,
            closePrice: closePrice,
            changePercent: changePercent,
            extraData: extraData,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime filterDate,
            required String conditionType,
            required String symbol,
            required String marketCode,
            required String symbolName,
            required double closePrice,
            required double changePercent,
            Value<String?> extraData = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              StockFilterResultsCompanion.insert(
            id: id,
            filterDate: filterDate,
            conditionType: conditionType,
            symbol: symbol,
            marketCode: marketCode,
            symbolName: symbolName,
            closePrice: closePrice,
            changePercent: changePercent,
            extraData: extraData,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StockFilterResultsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockFilterResultsTable,
    StockFilterResult,
    $$StockFilterResultsTableFilterComposer,
    $$StockFilterResultsTableOrderingComposer,
    $$StockFilterResultsTableAnnotationComposer,
    $$StockFilterResultsTableCreateCompanionBuilder,
    $$StockFilterResultsTableUpdateCompanionBuilder,
    (
      StockFilterResult,
      BaseReferences<_$AppDatabase, $StockFilterResultsTable, StockFilterResult>
    ),
    StockFilterResult,
    PrefetchHooks Function()>;
typedef $$DailyStockStatsTableCreateCompanionBuilder = DailyStockStatsCompanion
    Function({
  Value<int> id,
  required DateTime tradeDate,
  required String symbol,
  required String marketCode,
  required double closePrice,
  required double openPrice,
  required double highPrice,
  required double lowPrice,
  required double volume,
  Value<double?> return15d,
  Value<double?> return30d,
  Value<double?> ma10,
  Value<double?> ma20,
  Value<double?> ma50,
  Value<double?> ma200,
  Value<double?> historicalHigh,
  Value<double?> historicalLow,
  Value<double?> yearHigh,
  Value<double?> yearLow,
  Value<bool> isLimitUp,
  Value<bool> isLimitDown,
  Value<int> listingDays,
  Value<bool> isSuspended,
  Value<DateTime> createdAt,
});
typedef $$DailyStockStatsTableUpdateCompanionBuilder = DailyStockStatsCompanion
    Function({
  Value<int> id,
  Value<DateTime> tradeDate,
  Value<String> symbol,
  Value<String> marketCode,
  Value<double> closePrice,
  Value<double> openPrice,
  Value<double> highPrice,
  Value<double> lowPrice,
  Value<double> volume,
  Value<double?> return15d,
  Value<double?> return30d,
  Value<double?> ma10,
  Value<double?> ma20,
  Value<double?> ma50,
  Value<double?> ma200,
  Value<double?> historicalHigh,
  Value<double?> historicalLow,
  Value<double?> yearHigh,
  Value<double?> yearLow,
  Value<bool> isLimitUp,
  Value<bool> isLimitDown,
  Value<int> listingDays,
  Value<bool> isSuspended,
  Value<DateTime> createdAt,
});

class $$DailyStockStatsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyStockStatsTable> {
  $$DailyStockStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get tradeDate => $composableBuilder(
      column: $table.tradeDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get closePrice => $composableBuilder(
      column: $table.closePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get openPrice => $composableBuilder(
      column: $table.openPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get highPrice => $composableBuilder(
      column: $table.highPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lowPrice => $composableBuilder(
      column: $table.lowPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get volume => $composableBuilder(
      column: $table.volume, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get return15d => $composableBuilder(
      column: $table.return15d, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get return30d => $composableBuilder(
      column: $table.return30d, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ma10 => $composableBuilder(
      column: $table.ma10, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ma20 => $composableBuilder(
      column: $table.ma20, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ma50 => $composableBuilder(
      column: $table.ma50, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ma200 => $composableBuilder(
      column: $table.ma200, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get historicalHigh => $composableBuilder(
      column: $table.historicalHigh,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get historicalLow => $composableBuilder(
      column: $table.historicalLow, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get yearHigh => $composableBuilder(
      column: $table.yearHigh, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get yearLow => $composableBuilder(
      column: $table.yearLow, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLimitUp => $composableBuilder(
      column: $table.isLimitUp, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLimitDown => $composableBuilder(
      column: $table.isLimitDown, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get listingDays => $composableBuilder(
      column: $table.listingDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSuspended => $composableBuilder(
      column: $table.isSuspended, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DailyStockStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyStockStatsTable> {
  $$DailyStockStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get tradeDate => $composableBuilder(
      column: $table.tradeDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get closePrice => $composableBuilder(
      column: $table.closePrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get openPrice => $composableBuilder(
      column: $table.openPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get highPrice => $composableBuilder(
      column: $table.highPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lowPrice => $composableBuilder(
      column: $table.lowPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get volume => $composableBuilder(
      column: $table.volume, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get return15d => $composableBuilder(
      column: $table.return15d, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get return30d => $composableBuilder(
      column: $table.return30d, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ma10 => $composableBuilder(
      column: $table.ma10, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ma20 => $composableBuilder(
      column: $table.ma20, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ma50 => $composableBuilder(
      column: $table.ma50, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ma200 => $composableBuilder(
      column: $table.ma200, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get historicalHigh => $composableBuilder(
      column: $table.historicalHigh,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get historicalLow => $composableBuilder(
      column: $table.historicalLow,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get yearHigh => $composableBuilder(
      column: $table.yearHigh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get yearLow => $composableBuilder(
      column: $table.yearLow, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLimitUp => $composableBuilder(
      column: $table.isLimitUp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLimitDown => $composableBuilder(
      column: $table.isLimitDown, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get listingDays => $composableBuilder(
      column: $table.listingDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSuspended => $composableBuilder(
      column: $table.isSuspended, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DailyStockStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyStockStatsTable> {
  $$DailyStockStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get tradeDate =>
      $composableBuilder(column: $table.tradeDate, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => column);

  GeneratedColumn<double> get closePrice => $composableBuilder(
      column: $table.closePrice, builder: (column) => column);

  GeneratedColumn<double> get openPrice =>
      $composableBuilder(column: $table.openPrice, builder: (column) => column);

  GeneratedColumn<double> get highPrice =>
      $composableBuilder(column: $table.highPrice, builder: (column) => column);

  GeneratedColumn<double> get lowPrice =>
      $composableBuilder(column: $table.lowPrice, builder: (column) => column);

  GeneratedColumn<double> get volume =>
      $composableBuilder(column: $table.volume, builder: (column) => column);

  GeneratedColumn<double> get return15d =>
      $composableBuilder(column: $table.return15d, builder: (column) => column);

  GeneratedColumn<double> get return30d =>
      $composableBuilder(column: $table.return30d, builder: (column) => column);

  GeneratedColumn<double> get ma10 =>
      $composableBuilder(column: $table.ma10, builder: (column) => column);

  GeneratedColumn<double> get ma20 =>
      $composableBuilder(column: $table.ma20, builder: (column) => column);

  GeneratedColumn<double> get ma50 =>
      $composableBuilder(column: $table.ma50, builder: (column) => column);

  GeneratedColumn<double> get ma200 =>
      $composableBuilder(column: $table.ma200, builder: (column) => column);

  GeneratedColumn<double> get historicalHigh => $composableBuilder(
      column: $table.historicalHigh, builder: (column) => column);

  GeneratedColumn<double> get historicalLow => $composableBuilder(
      column: $table.historicalLow, builder: (column) => column);

  GeneratedColumn<double> get yearHigh =>
      $composableBuilder(column: $table.yearHigh, builder: (column) => column);

  GeneratedColumn<double> get yearLow =>
      $composableBuilder(column: $table.yearLow, builder: (column) => column);

  GeneratedColumn<bool> get isLimitUp =>
      $composableBuilder(column: $table.isLimitUp, builder: (column) => column);

  GeneratedColumn<bool> get isLimitDown => $composableBuilder(
      column: $table.isLimitDown, builder: (column) => column);

  GeneratedColumn<int> get listingDays => $composableBuilder(
      column: $table.listingDays, builder: (column) => column);

  GeneratedColumn<bool> get isSuspended => $composableBuilder(
      column: $table.isSuspended, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DailyStockStatsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyStockStatsTable,
    DailyStockStat,
    $$DailyStockStatsTableFilterComposer,
    $$DailyStockStatsTableOrderingComposer,
    $$DailyStockStatsTableAnnotationComposer,
    $$DailyStockStatsTableCreateCompanionBuilder,
    $$DailyStockStatsTableUpdateCompanionBuilder,
    (
      DailyStockStat,
      BaseReferences<_$AppDatabase, $DailyStockStatsTable, DailyStockStat>
    ),
    DailyStockStat,
    PrefetchHooks Function()> {
  $$DailyStockStatsTableTableManager(
      _$AppDatabase db, $DailyStockStatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyStockStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyStockStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyStockStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> tradeDate = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> marketCode = const Value.absent(),
            Value<double> closePrice = const Value.absent(),
            Value<double> openPrice = const Value.absent(),
            Value<double> highPrice = const Value.absent(),
            Value<double> lowPrice = const Value.absent(),
            Value<double> volume = const Value.absent(),
            Value<double?> return15d = const Value.absent(),
            Value<double?> return30d = const Value.absent(),
            Value<double?> ma10 = const Value.absent(),
            Value<double?> ma20 = const Value.absent(),
            Value<double?> ma50 = const Value.absent(),
            Value<double?> ma200 = const Value.absent(),
            Value<double?> historicalHigh = const Value.absent(),
            Value<double?> historicalLow = const Value.absent(),
            Value<double?> yearHigh = const Value.absent(),
            Value<double?> yearLow = const Value.absent(),
            Value<bool> isLimitUp = const Value.absent(),
            Value<bool> isLimitDown = const Value.absent(),
            Value<int> listingDays = const Value.absent(),
            Value<bool> isSuspended = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DailyStockStatsCompanion(
            id: id,
            tradeDate: tradeDate,
            symbol: symbol,
            marketCode: marketCode,
            closePrice: closePrice,
            openPrice: openPrice,
            highPrice: highPrice,
            lowPrice: lowPrice,
            volume: volume,
            return15d: return15d,
            return30d: return30d,
            ma10: ma10,
            ma20: ma20,
            ma50: ma50,
            ma200: ma200,
            historicalHigh: historicalHigh,
            historicalLow: historicalLow,
            yearHigh: yearHigh,
            yearLow: yearLow,
            isLimitUp: isLimitUp,
            isLimitDown: isLimitDown,
            listingDays: listingDays,
            isSuspended: isSuspended,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime tradeDate,
            required String symbol,
            required String marketCode,
            required double closePrice,
            required double openPrice,
            required double highPrice,
            required double lowPrice,
            required double volume,
            Value<double?> return15d = const Value.absent(),
            Value<double?> return30d = const Value.absent(),
            Value<double?> ma10 = const Value.absent(),
            Value<double?> ma20 = const Value.absent(),
            Value<double?> ma50 = const Value.absent(),
            Value<double?> ma200 = const Value.absent(),
            Value<double?> historicalHigh = const Value.absent(),
            Value<double?> historicalLow = const Value.absent(),
            Value<double?> yearHigh = const Value.absent(),
            Value<double?> yearLow = const Value.absent(),
            Value<bool> isLimitUp = const Value.absent(),
            Value<bool> isLimitDown = const Value.absent(),
            Value<int> listingDays = const Value.absent(),
            Value<bool> isSuspended = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DailyStockStatsCompanion.insert(
            id: id,
            tradeDate: tradeDate,
            symbol: symbol,
            marketCode: marketCode,
            closePrice: closePrice,
            openPrice: openPrice,
            highPrice: highPrice,
            lowPrice: lowPrice,
            volume: volume,
            return15d: return15d,
            return30d: return30d,
            ma10: ma10,
            ma20: ma20,
            ma50: ma50,
            ma200: ma200,
            historicalHigh: historicalHigh,
            historicalLow: historicalLow,
            yearHigh: yearHigh,
            yearLow: yearLow,
            isLimitUp: isLimitUp,
            isLimitDown: isLimitDown,
            listingDays: listingDays,
            isSuspended: isSuspended,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyStockStatsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyStockStatsTable,
    DailyStockStat,
    $$DailyStockStatsTableFilterComposer,
    $$DailyStockStatsTableOrderingComposer,
    $$DailyStockStatsTableAnnotationComposer,
    $$DailyStockStatsTableCreateCompanionBuilder,
    $$DailyStockStatsTableUpdateCompanionBuilder,
    (
      DailyStockStat,
      BaseReferences<_$AppDatabase, $DailyStockStatsTable, DailyStockStat>
    ),
    DailyStockStat,
    PrefetchHooks Function()>;
typedef $$TrainingSessionsTableCreateCompanionBuilder
    = TrainingSessionsCompanion Function({
  Value<int> id,
  required int userId,
  required String symbol,
  required String marketCode,
  required String period,
  required DateTime startDate,
  required DateTime endDate,
  Value<double> initialCapital,
  Value<double> currentCapital,
  Value<double> totalProfit,
  Value<double> profitRate,
  Value<int> tradeCount,
  Value<int> winCount,
  Value<double> winRate,
  Value<double> maxDrawdown,
  Value<double> avgHoldDuration,
  Value<double> profitLossRatio,
  Value<int> conditionOrderCount,
  Value<int> conditionOrderTriggered,
  Value<String?> strategyUsed,
  required String status,
  Value<DateTime?> startTime,
  Value<DateTime?> endTime,
  Value<int> duration,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$TrainingSessionsTableUpdateCompanionBuilder
    = TrainingSessionsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<String> symbol,
  Value<String> marketCode,
  Value<String> period,
  Value<DateTime> startDate,
  Value<DateTime> endDate,
  Value<double> initialCapital,
  Value<double> currentCapital,
  Value<double> totalProfit,
  Value<double> profitRate,
  Value<int> tradeCount,
  Value<int> winCount,
  Value<double> winRate,
  Value<double> maxDrawdown,
  Value<double> avgHoldDuration,
  Value<double> profitLossRatio,
  Value<int> conditionOrderCount,
  Value<int> conditionOrderTriggered,
  Value<String?> strategyUsed,
  Value<String> status,
  Value<DateTime?> startTime,
  Value<DateTime?> endTime,
  Value<int> duration,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$TrainingSessionsTableReferences extends BaseReferences<
    _$AppDatabase, $TrainingSessionsTable, TrainingSession> {
  $$TrainingSessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.trainingSessions.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PositionsTable, List<Position>>
      _positionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.positions,
              aliasName: $_aliasNameGenerator(
                  db.trainingSessions.id, db.positions.sessionId));

  $$PositionsTableProcessedTableManager get positionsRefs {
    final manager = $$PositionsTableTableManager($_db, $_db.positions)
        .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_positionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TradesTable, List<Trade>> _tradesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.trades,
          aliasName: $_aliasNameGenerator(
              db.trainingSessions.id, db.trades.sessionId));

  $$TradesTableProcessedTableManager get tradesRefs {
    final manager = $$TradesTableTableManager($_db, $_db.trades)
        .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tradesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ConditionalOrdersTable, List<ConditionalOrder>>
      _conditionalOrdersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.conditionalOrders,
              aliasName: $_aliasNameGenerator(
                  db.trainingSessions.id, db.conditionalOrders.sessionId));

  $$ConditionalOrdersTableProcessedTableManager get conditionalOrdersRefs {
    final manager =
        $$ConditionalOrdersTableTableManager($_db, $_db.conditionalOrders)
            .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_conditionalOrdersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OperationLogsTable, List<OperationLog>>
      _operationLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.operationLogs,
              aliasName: $_aliasNameGenerator(
                  db.trainingSessions.id, db.operationLogs.sessionId));

  $$OperationLogsTableProcessedTableManager get operationLogsRefs {
    final manager = $$OperationLogsTableTableManager($_db, $_db.operationLogs)
        .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_operationLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TrainingReportsTable, List<TrainingReport>>
      _trainingReportsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.trainingReports,
              aliasName: $_aliasNameGenerator(
                  db.trainingSessions.id, db.trainingReports.sessionId));

  $$TrainingReportsTableProcessedTableManager get trainingReportsRefs {
    final manager =
        $$TrainingReportsTableTableManager($_db, $_db.trainingReports)
            .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_trainingReportsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TrainingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $TrainingSessionsTable> {
  $$TrainingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get period => $composableBuilder(
      column: $table.period, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get initialCapital => $composableBuilder(
      column: $table.initialCapital,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentCapital => $composableBuilder(
      column: $table.currentCapital,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalProfit => $composableBuilder(
      column: $table.totalProfit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get profitRate => $composableBuilder(
      column: $table.profitRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tradeCount => $composableBuilder(
      column: $table.tradeCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get winCount => $composableBuilder(
      column: $table.winCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get winRate => $composableBuilder(
      column: $table.winRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxDrawdown => $composableBuilder(
      column: $table.maxDrawdown, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgHoldDuration => $composableBuilder(
      column: $table.avgHoldDuration,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get profitLossRatio => $composableBuilder(
      column: $table.profitLossRatio,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get conditionOrderCount => $composableBuilder(
      column: $table.conditionOrderCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get conditionOrderTriggered => $composableBuilder(
      column: $table.conditionOrderTriggered,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get strategyUsed => $composableBuilder(
      column: $table.strategyUsed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> positionsRefs(
      Expression<bool> Function($$PositionsTableFilterComposer f) f) {
    final $$PositionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.positions,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PositionsTableFilterComposer(
              $db: $db,
              $table: $db.positions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> tradesRefs(
      Expression<bool> Function($$TradesTableFilterComposer f) f) {
    final $$TradesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trades,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TradesTableFilterComposer(
              $db: $db,
              $table: $db.trades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> conditionalOrdersRefs(
      Expression<bool> Function($$ConditionalOrdersTableFilterComposer f) f) {
    final $$ConditionalOrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.conditionalOrders,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConditionalOrdersTableFilterComposer(
              $db: $db,
              $table: $db.conditionalOrders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> operationLogsRefs(
      Expression<bool> Function($$OperationLogsTableFilterComposer f) f) {
    final $$OperationLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.operationLogs,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OperationLogsTableFilterComposer(
              $db: $db,
              $table: $db.operationLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> trainingReportsRefs(
      Expression<bool> Function($$TrainingReportsTableFilterComposer f) f) {
    final $$TrainingReportsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trainingReports,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingReportsTableFilterComposer(
              $db: $db,
              $table: $db.trainingReports,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TrainingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainingSessionsTable> {
  $$TrainingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get period => $composableBuilder(
      column: $table.period, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get initialCapital => $composableBuilder(
      column: $table.initialCapital,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentCapital => $composableBuilder(
      column: $table.currentCapital,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalProfit => $composableBuilder(
      column: $table.totalProfit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get profitRate => $composableBuilder(
      column: $table.profitRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tradeCount => $composableBuilder(
      column: $table.tradeCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get winCount => $composableBuilder(
      column: $table.winCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get winRate => $composableBuilder(
      column: $table.winRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxDrawdown => $composableBuilder(
      column: $table.maxDrawdown, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgHoldDuration => $composableBuilder(
      column: $table.avgHoldDuration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get profitLossRatio => $composableBuilder(
      column: $table.profitLossRatio,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get conditionOrderCount => $composableBuilder(
      column: $table.conditionOrderCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get conditionOrderTriggered => $composableBuilder(
      column: $table.conditionOrderTriggered,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get strategyUsed => $composableBuilder(
      column: $table.strategyUsed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TrainingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainingSessionsTable> {
  $$TrainingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<double> get initialCapital => $composableBuilder(
      column: $table.initialCapital, builder: (column) => column);

  GeneratedColumn<double> get currentCapital => $composableBuilder(
      column: $table.currentCapital, builder: (column) => column);

  GeneratedColumn<double> get totalProfit => $composableBuilder(
      column: $table.totalProfit, builder: (column) => column);

  GeneratedColumn<double> get profitRate => $composableBuilder(
      column: $table.profitRate, builder: (column) => column);

  GeneratedColumn<int> get tradeCount => $composableBuilder(
      column: $table.tradeCount, builder: (column) => column);

  GeneratedColumn<int> get winCount =>
      $composableBuilder(column: $table.winCount, builder: (column) => column);

  GeneratedColumn<double> get winRate =>
      $composableBuilder(column: $table.winRate, builder: (column) => column);

  GeneratedColumn<double> get maxDrawdown => $composableBuilder(
      column: $table.maxDrawdown, builder: (column) => column);

  GeneratedColumn<double> get avgHoldDuration => $composableBuilder(
      column: $table.avgHoldDuration, builder: (column) => column);

  GeneratedColumn<double> get profitLossRatio => $composableBuilder(
      column: $table.profitLossRatio, builder: (column) => column);

  GeneratedColumn<int> get conditionOrderCount => $composableBuilder(
      column: $table.conditionOrderCount, builder: (column) => column);

  GeneratedColumn<int> get conditionOrderTriggered => $composableBuilder(
      column: $table.conditionOrderTriggered, builder: (column) => column);

  GeneratedColumn<String> get strategyUsed => $composableBuilder(
      column: $table.strategyUsed, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> positionsRefs<T extends Object>(
      Expression<T> Function($$PositionsTableAnnotationComposer a) f) {
    final $$PositionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.positions,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PositionsTableAnnotationComposer(
              $db: $db,
              $table: $db.positions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> tradesRefs<T extends Object>(
      Expression<T> Function($$TradesTableAnnotationComposer a) f) {
    final $$TradesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trades,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TradesTableAnnotationComposer(
              $db: $db,
              $table: $db.trades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> conditionalOrdersRefs<T extends Object>(
      Expression<T> Function($$ConditionalOrdersTableAnnotationComposer a) f) {
    final $$ConditionalOrdersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.conditionalOrders,
            getReferencedColumn: (t) => t.sessionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ConditionalOrdersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.conditionalOrders,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> operationLogsRefs<T extends Object>(
      Expression<T> Function($$OperationLogsTableAnnotationComposer a) f) {
    final $$OperationLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.operationLogs,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OperationLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.operationLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> trainingReportsRefs<T extends Object>(
      Expression<T> Function($$TrainingReportsTableAnnotationComposer a) f) {
    final $$TrainingReportsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trainingReports,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingReportsTableAnnotationComposer(
              $db: $db,
              $table: $db.trainingReports,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TrainingSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrainingSessionsTable,
    TrainingSession,
    $$TrainingSessionsTableFilterComposer,
    $$TrainingSessionsTableOrderingComposer,
    $$TrainingSessionsTableAnnotationComposer,
    $$TrainingSessionsTableCreateCompanionBuilder,
    $$TrainingSessionsTableUpdateCompanionBuilder,
    (TrainingSession, $$TrainingSessionsTableReferences),
    TrainingSession,
    PrefetchHooks Function(
        {bool userId,
        bool positionsRefs,
        bool tradesRefs,
        bool conditionalOrdersRefs,
        bool operationLogsRefs,
        bool trainingReportsRefs})> {
  $$TrainingSessionsTableTableManager(
      _$AppDatabase db, $TrainingSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> marketCode = const Value.absent(),
            Value<String> period = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> endDate = const Value.absent(),
            Value<double> initialCapital = const Value.absent(),
            Value<double> currentCapital = const Value.absent(),
            Value<double> totalProfit = const Value.absent(),
            Value<double> profitRate = const Value.absent(),
            Value<int> tradeCount = const Value.absent(),
            Value<int> winCount = const Value.absent(),
            Value<double> winRate = const Value.absent(),
            Value<double> maxDrawdown = const Value.absent(),
            Value<double> avgHoldDuration = const Value.absent(),
            Value<double> profitLossRatio = const Value.absent(),
            Value<int> conditionOrderCount = const Value.absent(),
            Value<int> conditionOrderTriggered = const Value.absent(),
            Value<String?> strategyUsed = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<int> duration = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TrainingSessionsCompanion(
            id: id,
            userId: userId,
            symbol: symbol,
            marketCode: marketCode,
            period: period,
            startDate: startDate,
            endDate: endDate,
            initialCapital: initialCapital,
            currentCapital: currentCapital,
            totalProfit: totalProfit,
            profitRate: profitRate,
            tradeCount: tradeCount,
            winCount: winCount,
            winRate: winRate,
            maxDrawdown: maxDrawdown,
            avgHoldDuration: avgHoldDuration,
            profitLossRatio: profitLossRatio,
            conditionOrderCount: conditionOrderCount,
            conditionOrderTriggered: conditionOrderTriggered,
            strategyUsed: strategyUsed,
            status: status,
            startTime: startTime,
            endTime: endTime,
            duration: duration,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required String symbol,
            required String marketCode,
            required String period,
            required DateTime startDate,
            required DateTime endDate,
            Value<double> initialCapital = const Value.absent(),
            Value<double> currentCapital = const Value.absent(),
            Value<double> totalProfit = const Value.absent(),
            Value<double> profitRate = const Value.absent(),
            Value<int> tradeCount = const Value.absent(),
            Value<int> winCount = const Value.absent(),
            Value<double> winRate = const Value.absent(),
            Value<double> maxDrawdown = const Value.absent(),
            Value<double> avgHoldDuration = const Value.absent(),
            Value<double> profitLossRatio = const Value.absent(),
            Value<int> conditionOrderCount = const Value.absent(),
            Value<int> conditionOrderTriggered = const Value.absent(),
            Value<String?> strategyUsed = const Value.absent(),
            required String status,
            Value<DateTime?> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<int> duration = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TrainingSessionsCompanion.insert(
            id: id,
            userId: userId,
            symbol: symbol,
            marketCode: marketCode,
            period: period,
            startDate: startDate,
            endDate: endDate,
            initialCapital: initialCapital,
            currentCapital: currentCapital,
            totalProfit: totalProfit,
            profitRate: profitRate,
            tradeCount: tradeCount,
            winCount: winCount,
            winRate: winRate,
            maxDrawdown: maxDrawdown,
            avgHoldDuration: avgHoldDuration,
            profitLossRatio: profitLossRatio,
            conditionOrderCount: conditionOrderCount,
            conditionOrderTriggered: conditionOrderTriggered,
            strategyUsed: strategyUsed,
            status: status,
            startTime: startTime,
            endTime: endTime,
            duration: duration,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TrainingSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {userId = false,
              positionsRefs = false,
              tradesRefs = false,
              conditionalOrdersRefs = false,
              operationLogsRefs = false,
              trainingReportsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (positionsRefs) db.positions,
                if (tradesRefs) db.trades,
                if (conditionalOrdersRefs) db.conditionalOrders,
                if (operationLogsRefs) db.operationLogs,
                if (trainingReportsRefs) db.trainingReports
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$TrainingSessionsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$TrainingSessionsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (positionsRefs)
                    await $_getPrefetchedData<TrainingSession, $TrainingSessionsTable,
                            Position>(
                        currentTable: table,
                        referencedTable: $$TrainingSessionsTableReferences
                            ._positionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TrainingSessionsTableReferences(db, table, p0)
                                .positionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items),
                  if (tradesRefs)
                    await $_getPrefetchedData<TrainingSession,
                            $TrainingSessionsTable, Trade>(
                        currentTable: table,
                        referencedTable: $$TrainingSessionsTableReferences
                            ._tradesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TrainingSessionsTableReferences(db, table, p0)
                                .tradesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items),
                  if (conditionalOrdersRefs)
                    await $_getPrefetchedData<TrainingSession,
                            $TrainingSessionsTable, ConditionalOrder>(
                        currentTable: table,
                        referencedTable: $$TrainingSessionsTableReferences
                            ._conditionalOrdersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TrainingSessionsTableReferences(db, table, p0)
                                .conditionalOrdersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items),
                  if (operationLogsRefs)
                    await $_getPrefetchedData<TrainingSession,
                            $TrainingSessionsTable, OperationLog>(
                        currentTable: table,
                        referencedTable: $$TrainingSessionsTableReferences
                            ._operationLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TrainingSessionsTableReferences(db, table, p0)
                                .operationLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items),
                  if (trainingReportsRefs)
                    await $_getPrefetchedData<TrainingSession,
                            $TrainingSessionsTable, TrainingReport>(
                        currentTable: table,
                        referencedTable: $$TrainingSessionsTableReferences
                            ._trainingReportsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TrainingSessionsTableReferences(db, table, p0)
                                .trainingReportsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TrainingSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TrainingSessionsTable,
    TrainingSession,
    $$TrainingSessionsTableFilterComposer,
    $$TrainingSessionsTableOrderingComposer,
    $$TrainingSessionsTableAnnotationComposer,
    $$TrainingSessionsTableCreateCompanionBuilder,
    $$TrainingSessionsTableUpdateCompanionBuilder,
    (TrainingSession, $$TrainingSessionsTableReferences),
    TrainingSession,
    PrefetchHooks Function(
        {bool userId,
        bool positionsRefs,
        bool tradesRefs,
        bool conditionalOrdersRefs,
        bool operationLogsRefs,
        bool trainingReportsRefs})>;
typedef $$PositionsTableCreateCompanionBuilder = PositionsCompanion Function({
  Value<int> id,
  required int sessionId,
  required int userId,
  required String symbol,
  required String marketCode,
  required int quantity,
  required double avgCost,
  required double currentPrice,
  required double profitLoss,
  required double profitLossRate,
  required DateTime openTime,
  Value<DateTime?> closeTime,
  required String status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$PositionsTableUpdateCompanionBuilder = PositionsCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<int> userId,
  Value<String> symbol,
  Value<String> marketCode,
  Value<int> quantity,
  Value<double> avgCost,
  Value<double> currentPrice,
  Value<double> profitLoss,
  Value<double> profitLossRate,
  Value<DateTime> openTime,
  Value<DateTime?> closeTime,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$PositionsTableReferences
    extends BaseReferences<_$AppDatabase, $PositionsTable, Position> {
  $$PositionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TrainingSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.trainingSessions.createAlias(
          $_aliasNameGenerator(db.positions.sessionId, db.trainingSessions.id));

  $$TrainingSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager =
        $$TrainingSessionsTableTableManager($_db, $_db.trainingSessions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.positions.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TradesTable, List<Trade>> _tradesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.trades,
          aliasName:
              $_aliasNameGenerator(db.positions.id, db.trades.positionId));

  $$TradesTableProcessedTableManager get tradesRefs {
    final manager = $$TradesTableTableManager($_db, $_db.trades)
        .filter((f) => f.positionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tradesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PositionsTableFilterComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgCost => $composableBuilder(
      column: $table.avgCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentPrice => $composableBuilder(
      column: $table.currentPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get profitLoss => $composableBuilder(
      column: $table.profitLoss, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get profitLossRate => $composableBuilder(
      column: $table.profitLossRate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get openTime => $composableBuilder(
      column: $table.openTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get closeTime => $composableBuilder(
      column: $table.closeTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$TrainingSessionsTableFilterComposer get sessionId {
    final $$TrainingSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableFilterComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> tradesRefs(
      Expression<bool> Function($$TradesTableFilterComposer f) f) {
    final $$TradesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trades,
        getReferencedColumn: (t) => t.positionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TradesTableFilterComposer(
              $db: $db,
              $table: $db.trades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PositionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgCost => $composableBuilder(
      column: $table.avgCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentPrice => $composableBuilder(
      column: $table.currentPrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get profitLoss => $composableBuilder(
      column: $table.profitLoss, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get profitLossRate => $composableBuilder(
      column: $table.profitLossRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get openTime => $composableBuilder(
      column: $table.openTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get closeTime => $composableBuilder(
      column: $table.closeTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$TrainingSessionsTableOrderingComposer get sessionId {
    final $$TrainingSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PositionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get avgCost =>
      $composableBuilder(column: $table.avgCost, builder: (column) => column);

  GeneratedColumn<double> get currentPrice => $composableBuilder(
      column: $table.currentPrice, builder: (column) => column);

  GeneratedColumn<double> get profitLoss => $composableBuilder(
      column: $table.profitLoss, builder: (column) => column);

  GeneratedColumn<double> get profitLossRate => $composableBuilder(
      column: $table.profitLossRate, builder: (column) => column);

  GeneratedColumn<DateTime> get openTime =>
      $composableBuilder(column: $table.openTime, builder: (column) => column);

  GeneratedColumn<DateTime> get closeTime =>
      $composableBuilder(column: $table.closeTime, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TrainingSessionsTableAnnotationComposer get sessionId {
    final $$TrainingSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> tradesRefs<T extends Object>(
      Expression<T> Function($$TradesTableAnnotationComposer a) f) {
    final $$TradesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trades,
        getReferencedColumn: (t) => t.positionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TradesTableAnnotationComposer(
              $db: $db,
              $table: $db.trades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PositionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PositionsTable,
    Position,
    $$PositionsTableFilterComposer,
    $$PositionsTableOrderingComposer,
    $$PositionsTableAnnotationComposer,
    $$PositionsTableCreateCompanionBuilder,
    $$PositionsTableUpdateCompanionBuilder,
    (Position, $$PositionsTableReferences),
    Position,
    PrefetchHooks Function({bool sessionId, bool userId, bool tradesRefs})> {
  $$PositionsTableTableManager(_$AppDatabase db, $PositionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> marketCode = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> avgCost = const Value.absent(),
            Value<double> currentPrice = const Value.absent(),
            Value<double> profitLoss = const Value.absent(),
            Value<double> profitLossRate = const Value.absent(),
            Value<DateTime> openTime = const Value.absent(),
            Value<DateTime?> closeTime = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PositionsCompanion(
            id: id,
            sessionId: sessionId,
            userId: userId,
            symbol: symbol,
            marketCode: marketCode,
            quantity: quantity,
            avgCost: avgCost,
            currentPrice: currentPrice,
            profitLoss: profitLoss,
            profitLossRate: profitLossRate,
            openTime: openTime,
            closeTime: closeTime,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required int userId,
            required String symbol,
            required String marketCode,
            required int quantity,
            required double avgCost,
            required double currentPrice,
            required double profitLoss,
            required double profitLossRate,
            required DateTime openTime,
            Value<DateTime?> closeTime = const Value.absent(),
            required String status,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PositionsCompanion.insert(
            id: id,
            sessionId: sessionId,
            userId: userId,
            symbol: symbol,
            marketCode: marketCode,
            quantity: quantity,
            avgCost: avgCost,
            currentPrice: currentPrice,
            profitLoss: profitLoss,
            profitLossRate: profitLossRate,
            openTime: openTime,
            closeTime: closeTime,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PositionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {sessionId = false, userId = false, tradesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tradesRefs) db.trades],
              addJoins: <
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
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$PositionsTableReferences._sessionIdTable(db),
                    referencedColumn:
                        $$PositionsTableReferences._sessionIdTable(db).id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$PositionsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$PositionsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tradesRefs)
                    await $_getPrefetchedData<Position, $PositionsTable, Trade>(
                        currentTable: table,
                        referencedTable:
                            $$PositionsTableReferences._tradesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PositionsTableReferences(db, table, p0)
                                .tradesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.positionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PositionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PositionsTable,
    Position,
    $$PositionsTableFilterComposer,
    $$PositionsTableOrderingComposer,
    $$PositionsTableAnnotationComposer,
    $$PositionsTableCreateCompanionBuilder,
    $$PositionsTableUpdateCompanionBuilder,
    (Position, $$PositionsTableReferences),
    Position,
    PrefetchHooks Function({bool sessionId, bool userId, bool tradesRefs})>;
typedef $$TradesTableCreateCompanionBuilder = TradesCompanion Function({
  Value<int> id,
  required int sessionId,
  required int userId,
  required String symbol,
  required String marketCode,
  required String type,
  Value<String> orderType,
  required double price,
  required int quantity,
  required double amount,
  Value<double> fee,
  Value<double> profit,
  Value<double> profitRate,
  Value<int?> positionId,
  required String tradeDate,
  Value<String?> triggerSource,
  Value<DateTime> createdAt,
});
typedef $$TradesTableUpdateCompanionBuilder = TradesCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<int> userId,
  Value<String> symbol,
  Value<String> marketCode,
  Value<String> type,
  Value<String> orderType,
  Value<double> price,
  Value<int> quantity,
  Value<double> amount,
  Value<double> fee,
  Value<double> profit,
  Value<double> profitRate,
  Value<int?> positionId,
  Value<String> tradeDate,
  Value<String?> triggerSource,
  Value<DateTime> createdAt,
});

final class $$TradesTableReferences
    extends BaseReferences<_$AppDatabase, $TradesTable, Trade> {
  $$TradesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TrainingSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.trainingSessions.createAlias(
          $_aliasNameGenerator(db.trades.sessionId, db.trainingSessions.id));

  $$TrainingSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager =
        $$TrainingSessionsTableTableManager($_db, $_db.trainingSessions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias($_aliasNameGenerator(db.trades.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PositionsTable _positionIdTable(_$AppDatabase db) => db.positions
      .createAlias($_aliasNameGenerator(db.trades.positionId, db.positions.id));

  $$PositionsTableProcessedTableManager? get positionId {
    final $_column = $_itemColumn<int>('position_id');
    if ($_column == null) return null;
    final manager = $$PositionsTableTableManager($_db, $_db.positions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_positionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TradesTableFilterComposer
    extends Composer<_$AppDatabase, $TradesTable> {
  $$TradesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fee => $composableBuilder(
      column: $table.fee, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get profit => $composableBuilder(
      column: $table.profit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get profitRate => $composableBuilder(
      column: $table.profitRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tradeDate => $composableBuilder(
      column: $table.tradeDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get triggerSource => $composableBuilder(
      column: $table.triggerSource, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$TrainingSessionsTableFilterComposer get sessionId {
    final $$TrainingSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableFilterComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PositionsTableFilterComposer get positionId {
    final $$PositionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.positionId,
        referencedTable: $db.positions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PositionsTableFilterComposer(
              $db: $db,
              $table: $db.positions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TradesTableOrderingComposer
    extends Composer<_$AppDatabase, $TradesTable> {
  $$TradesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fee => $composableBuilder(
      column: $table.fee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get profit => $composableBuilder(
      column: $table.profit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get profitRate => $composableBuilder(
      column: $table.profitRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tradeDate => $composableBuilder(
      column: $table.tradeDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get triggerSource => $composableBuilder(
      column: $table.triggerSource,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$TrainingSessionsTableOrderingComposer get sessionId {
    final $$TrainingSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PositionsTableOrderingComposer get positionId {
    final $$PositionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.positionId,
        referencedTable: $db.positions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PositionsTableOrderingComposer(
              $db: $db,
              $table: $db.positions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TradesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TradesTable> {
  $$TradesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get orderType =>
      $composableBuilder(column: $table.orderType, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get fee =>
      $composableBuilder(column: $table.fee, builder: (column) => column);

  GeneratedColumn<double> get profit =>
      $composableBuilder(column: $table.profit, builder: (column) => column);

  GeneratedColumn<double> get profitRate => $composableBuilder(
      column: $table.profitRate, builder: (column) => column);

  GeneratedColumn<String> get tradeDate =>
      $composableBuilder(column: $table.tradeDate, builder: (column) => column);

  GeneratedColumn<String> get triggerSource => $composableBuilder(
      column: $table.triggerSource, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TrainingSessionsTableAnnotationComposer get sessionId {
    final $$TrainingSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PositionsTableAnnotationComposer get positionId {
    final $$PositionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.positionId,
        referencedTable: $db.positions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PositionsTableAnnotationComposer(
              $db: $db,
              $table: $db.positions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TradesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TradesTable,
    Trade,
    $$TradesTableFilterComposer,
    $$TradesTableOrderingComposer,
    $$TradesTableAnnotationComposer,
    $$TradesTableCreateCompanionBuilder,
    $$TradesTableUpdateCompanionBuilder,
    (Trade, $$TradesTableReferences),
    Trade,
    PrefetchHooks Function({bool sessionId, bool userId, bool positionId})> {
  $$TradesTableTableManager(_$AppDatabase db, $TradesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TradesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TradesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TradesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> marketCode = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> orderType = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double> fee = const Value.absent(),
            Value<double> profit = const Value.absent(),
            Value<double> profitRate = const Value.absent(),
            Value<int?> positionId = const Value.absent(),
            Value<String> tradeDate = const Value.absent(),
            Value<String?> triggerSource = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TradesCompanion(
            id: id,
            sessionId: sessionId,
            userId: userId,
            symbol: symbol,
            marketCode: marketCode,
            type: type,
            orderType: orderType,
            price: price,
            quantity: quantity,
            amount: amount,
            fee: fee,
            profit: profit,
            profitRate: profitRate,
            positionId: positionId,
            tradeDate: tradeDate,
            triggerSource: triggerSource,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required int userId,
            required String symbol,
            required String marketCode,
            required String type,
            Value<String> orderType = const Value.absent(),
            required double price,
            required int quantity,
            required double amount,
            Value<double> fee = const Value.absent(),
            Value<double> profit = const Value.absent(),
            Value<double> profitRate = const Value.absent(),
            Value<int?> positionId = const Value.absent(),
            required String tradeDate,
            Value<String?> triggerSource = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TradesCompanion.insert(
            id: id,
            sessionId: sessionId,
            userId: userId,
            symbol: symbol,
            marketCode: marketCode,
            type: type,
            orderType: orderType,
            price: price,
            quantity: quantity,
            amount: amount,
            fee: fee,
            profit: profit,
            profitRate: profitRate,
            positionId: positionId,
            tradeDate: tradeDate,
            triggerSource: triggerSource,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TradesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {sessionId = false, userId = false, positionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$TradesTableReferences._sessionIdTable(db),
                    referencedColumn:
                        $$TradesTableReferences._sessionIdTable(db).id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable: $$TradesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$TradesTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (positionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.positionId,
                    referencedTable:
                        $$TradesTableReferences._positionIdTable(db),
                    referencedColumn:
                        $$TradesTableReferences._positionIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TradesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TradesTable,
    Trade,
    $$TradesTableFilterComposer,
    $$TradesTableOrderingComposer,
    $$TradesTableAnnotationComposer,
    $$TradesTableCreateCompanionBuilder,
    $$TradesTableUpdateCompanionBuilder,
    (Trade, $$TradesTableReferences),
    Trade,
    PrefetchHooks Function({bool sessionId, bool userId, bool positionId})>;
typedef $$ConditionalOrdersTableCreateCompanionBuilder
    = ConditionalOrdersCompanion Function({
  Value<int> id,
  required int sessionId,
  required int userId,
  required String symbol,
  required String marketCode,
  required String type,
  required String triggerType,
  Value<double?> targetPrice,
  Value<double?> stopPrice,
  Value<double?> upperPrice,
  Value<double?> lowerPrice,
  Value<int?> gridCount,
  Value<double?> gridStep,
  Value<int> gridFilled,
  required int quantity,
  required String status,
  Value<DateTime?> triggerTime,
  Value<DateTime?> expireTime,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ConditionalOrdersTableUpdateCompanionBuilder
    = ConditionalOrdersCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<int> userId,
  Value<String> symbol,
  Value<String> marketCode,
  Value<String> type,
  Value<String> triggerType,
  Value<double?> targetPrice,
  Value<double?> stopPrice,
  Value<double?> upperPrice,
  Value<double?> lowerPrice,
  Value<int?> gridCount,
  Value<double?> gridStep,
  Value<int> gridFilled,
  Value<int> quantity,
  Value<String> status,
  Value<DateTime?> triggerTime,
  Value<DateTime?> expireTime,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ConditionalOrdersTableReferences extends BaseReferences<
    _$AppDatabase, $ConditionalOrdersTable, ConditionalOrder> {
  $$ConditionalOrdersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TrainingSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.trainingSessions.createAlias($_aliasNameGenerator(
          db.conditionalOrders.sessionId, db.trainingSessions.id));

  $$TrainingSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager =
        $$TrainingSessionsTableTableManager($_db, $_db.trainingSessions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.conditionalOrders.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ConditionalOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $ConditionalOrdersTable> {
  $$ConditionalOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get triggerType => $composableBuilder(
      column: $table.triggerType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetPrice => $composableBuilder(
      column: $table.targetPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stopPrice => $composableBuilder(
      column: $table.stopPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get upperPrice => $composableBuilder(
      column: $table.upperPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lowerPrice => $composableBuilder(
      column: $table.lowerPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gridCount => $composableBuilder(
      column: $table.gridCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gridStep => $composableBuilder(
      column: $table.gridStep, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gridFilled => $composableBuilder(
      column: $table.gridFilled, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get triggerTime => $composableBuilder(
      column: $table.triggerTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expireTime => $composableBuilder(
      column: $table.expireTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$TrainingSessionsTableFilterComposer get sessionId {
    final $$TrainingSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableFilterComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ConditionalOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $ConditionalOrdersTable> {
  $$ConditionalOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get triggerType => $composableBuilder(
      column: $table.triggerType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetPrice => $composableBuilder(
      column: $table.targetPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stopPrice => $composableBuilder(
      column: $table.stopPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get upperPrice => $composableBuilder(
      column: $table.upperPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lowerPrice => $composableBuilder(
      column: $table.lowerPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gridCount => $composableBuilder(
      column: $table.gridCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gridStep => $composableBuilder(
      column: $table.gridStep, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gridFilled => $composableBuilder(
      column: $table.gridFilled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get triggerTime => $composableBuilder(
      column: $table.triggerTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expireTime => $composableBuilder(
      column: $table.expireTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$TrainingSessionsTableOrderingComposer get sessionId {
    final $$TrainingSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ConditionalOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConditionalOrdersTable> {
  $$ConditionalOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get marketCode => $composableBuilder(
      column: $table.marketCode, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get triggerType => $composableBuilder(
      column: $table.triggerType, builder: (column) => column);

  GeneratedColumn<double> get targetPrice => $composableBuilder(
      column: $table.targetPrice, builder: (column) => column);

  GeneratedColumn<double> get stopPrice =>
      $composableBuilder(column: $table.stopPrice, builder: (column) => column);

  GeneratedColumn<double> get upperPrice => $composableBuilder(
      column: $table.upperPrice, builder: (column) => column);

  GeneratedColumn<double> get lowerPrice => $composableBuilder(
      column: $table.lowerPrice, builder: (column) => column);

  GeneratedColumn<int> get gridCount =>
      $composableBuilder(column: $table.gridCount, builder: (column) => column);

  GeneratedColumn<double> get gridStep =>
      $composableBuilder(column: $table.gridStep, builder: (column) => column);

  GeneratedColumn<int> get gridFilled => $composableBuilder(
      column: $table.gridFilled, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get triggerTime => $composableBuilder(
      column: $table.triggerTime, builder: (column) => column);

  GeneratedColumn<DateTime> get expireTime => $composableBuilder(
      column: $table.expireTime, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TrainingSessionsTableAnnotationComposer get sessionId {
    final $$TrainingSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ConditionalOrdersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConditionalOrdersTable,
    ConditionalOrder,
    $$ConditionalOrdersTableFilterComposer,
    $$ConditionalOrdersTableOrderingComposer,
    $$ConditionalOrdersTableAnnotationComposer,
    $$ConditionalOrdersTableCreateCompanionBuilder,
    $$ConditionalOrdersTableUpdateCompanionBuilder,
    (ConditionalOrder, $$ConditionalOrdersTableReferences),
    ConditionalOrder,
    PrefetchHooks Function({bool sessionId, bool userId})> {
  $$ConditionalOrdersTableTableManager(
      _$AppDatabase db, $ConditionalOrdersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConditionalOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConditionalOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConditionalOrdersTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> marketCode = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> triggerType = const Value.absent(),
            Value<double?> targetPrice = const Value.absent(),
            Value<double?> stopPrice = const Value.absent(),
            Value<double?> upperPrice = const Value.absent(),
            Value<double?> lowerPrice = const Value.absent(),
            Value<int?> gridCount = const Value.absent(),
            Value<double?> gridStep = const Value.absent(),
            Value<int> gridFilled = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> triggerTime = const Value.absent(),
            Value<DateTime?> expireTime = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ConditionalOrdersCompanion(
            id: id,
            sessionId: sessionId,
            userId: userId,
            symbol: symbol,
            marketCode: marketCode,
            type: type,
            triggerType: triggerType,
            targetPrice: targetPrice,
            stopPrice: stopPrice,
            upperPrice: upperPrice,
            lowerPrice: lowerPrice,
            gridCount: gridCount,
            gridStep: gridStep,
            gridFilled: gridFilled,
            quantity: quantity,
            status: status,
            triggerTime: triggerTime,
            expireTime: expireTime,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required int userId,
            required String symbol,
            required String marketCode,
            required String type,
            required String triggerType,
            Value<double?> targetPrice = const Value.absent(),
            Value<double?> stopPrice = const Value.absent(),
            Value<double?> upperPrice = const Value.absent(),
            Value<double?> lowerPrice = const Value.absent(),
            Value<int?> gridCount = const Value.absent(),
            Value<double?> gridStep = const Value.absent(),
            Value<int> gridFilled = const Value.absent(),
            required int quantity,
            required String status,
            Value<DateTime?> triggerTime = const Value.absent(),
            Value<DateTime?> expireTime = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ConditionalOrdersCompanion.insert(
            id: id,
            sessionId: sessionId,
            userId: userId,
            symbol: symbol,
            marketCode: marketCode,
            type: type,
            triggerType: triggerType,
            targetPrice: targetPrice,
            stopPrice: stopPrice,
            upperPrice: upperPrice,
            lowerPrice: lowerPrice,
            gridCount: gridCount,
            gridStep: gridStep,
            gridFilled: gridFilled,
            quantity: quantity,
            status: status,
            triggerTime: triggerTime,
            expireTime: expireTime,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ConditionalOrdersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$ConditionalOrdersTableReferences._sessionIdTable(db),
                    referencedColumn: $$ConditionalOrdersTableReferences
                        ._sessionIdTable(db)
                        .id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$ConditionalOrdersTableReferences._userIdTable(db),
                    referencedColumn:
                        $$ConditionalOrdersTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ConditionalOrdersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConditionalOrdersTable,
    ConditionalOrder,
    $$ConditionalOrdersTableFilterComposer,
    $$ConditionalOrdersTableOrderingComposer,
    $$ConditionalOrdersTableAnnotationComposer,
    $$ConditionalOrdersTableCreateCompanionBuilder,
    $$ConditionalOrdersTableUpdateCompanionBuilder,
    (ConditionalOrder, $$ConditionalOrdersTableReferences),
    ConditionalOrder,
    PrefetchHooks Function({bool sessionId, bool userId})>;
typedef $$OperationLogsTableCreateCompanionBuilder = OperationLogsCompanion
    Function({
  Value<int> id,
  required int sessionId,
  required int userId,
  required String action,
  Value<String?> detail,
  required String tradeDate,
  Value<DateTime> createdAt,
});
typedef $$OperationLogsTableUpdateCompanionBuilder = OperationLogsCompanion
    Function({
  Value<int> id,
  Value<int> sessionId,
  Value<int> userId,
  Value<String> action,
  Value<String?> detail,
  Value<String> tradeDate,
  Value<DateTime> createdAt,
});

final class $$OperationLogsTableReferences
    extends BaseReferences<_$AppDatabase, $OperationLogsTable, OperationLog> {
  $$OperationLogsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TrainingSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.trainingSessions.createAlias($_aliasNameGenerator(
          db.operationLogs.sessionId, db.trainingSessions.id));

  $$TrainingSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager =
        $$TrainingSessionsTableTableManager($_db, $_db.trainingSessions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.operationLogs.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OperationLogsTableFilterComposer
    extends Composer<_$AppDatabase, $OperationLogsTable> {
  $$OperationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detail => $composableBuilder(
      column: $table.detail, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tradeDate => $composableBuilder(
      column: $table.tradeDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$TrainingSessionsTableFilterComposer get sessionId {
    final $$TrainingSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableFilterComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OperationLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $OperationLogsTable> {
  $$OperationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detail => $composableBuilder(
      column: $table.detail, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tradeDate => $composableBuilder(
      column: $table.tradeDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$TrainingSessionsTableOrderingComposer get sessionId {
    final $$TrainingSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OperationLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OperationLogsTable> {
  $$OperationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<String> get tradeDate =>
      $composableBuilder(column: $table.tradeDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TrainingSessionsTableAnnotationComposer get sessionId {
    final $$TrainingSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OperationLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OperationLogsTable,
    OperationLog,
    $$OperationLogsTableFilterComposer,
    $$OperationLogsTableOrderingComposer,
    $$OperationLogsTableAnnotationComposer,
    $$OperationLogsTableCreateCompanionBuilder,
    $$OperationLogsTableUpdateCompanionBuilder,
    (OperationLog, $$OperationLogsTableReferences),
    OperationLog,
    PrefetchHooks Function({bool sessionId, bool userId})> {
  $$OperationLogsTableTableManager(_$AppDatabase db, $OperationLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OperationLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OperationLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OperationLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String?> detail = const Value.absent(),
            Value<String> tradeDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              OperationLogsCompanion(
            id: id,
            sessionId: sessionId,
            userId: userId,
            action: action,
            detail: detail,
            tradeDate: tradeDate,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required int userId,
            required String action,
            Value<String?> detail = const Value.absent(),
            required String tradeDate,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              OperationLogsCompanion.insert(
            id: id,
            sessionId: sessionId,
            userId: userId,
            action: action,
            detail: detail,
            tradeDate: tradeDate,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OperationLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$OperationLogsTableReferences._sessionIdTable(db),
                    referencedColumn:
                        $$OperationLogsTableReferences._sessionIdTable(db).id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$OperationLogsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$OperationLogsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OperationLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OperationLogsTable,
    OperationLog,
    $$OperationLogsTableFilterComposer,
    $$OperationLogsTableOrderingComposer,
    $$OperationLogsTableAnnotationComposer,
    $$OperationLogsTableCreateCompanionBuilder,
    $$OperationLogsTableUpdateCompanionBuilder,
    (OperationLog, $$OperationLogsTableReferences),
    OperationLog,
    PrefetchHooks Function({bool sessionId, bool userId})>;
typedef $$TrainingReportsTableCreateCompanionBuilder = TrainingReportsCompanion
    Function({
  Value<int> id,
  required int sessionId,
  required int userId,
  required double totalProfit,
  required double profitRate,
  required int tradeCount,
  required int winCount,
  required double winRate,
  required double maxProfit,
  required double maxLoss,
  required double avgProfit,
  required double avgLoss,
  required double profitLossRatio,
  required double maxDrawdown,
  Value<double?> sharpeRatio,
  required int longestWinStreak,
  required int longestLoseStreak,
  required double avgHoldDays,
  required int conditionOrdersUsed,
  required int conditionOrdersTriggered,
  Value<String?> analysis,
  Value<String?> suggestions,
  Value<DateTime> createdAt,
});
typedef $$TrainingReportsTableUpdateCompanionBuilder = TrainingReportsCompanion
    Function({
  Value<int> id,
  Value<int> sessionId,
  Value<int> userId,
  Value<double> totalProfit,
  Value<double> profitRate,
  Value<int> tradeCount,
  Value<int> winCount,
  Value<double> winRate,
  Value<double> maxProfit,
  Value<double> maxLoss,
  Value<double> avgProfit,
  Value<double> avgLoss,
  Value<double> profitLossRatio,
  Value<double> maxDrawdown,
  Value<double?> sharpeRatio,
  Value<int> longestWinStreak,
  Value<int> longestLoseStreak,
  Value<double> avgHoldDays,
  Value<int> conditionOrdersUsed,
  Value<int> conditionOrdersTriggered,
  Value<String?> analysis,
  Value<String?> suggestions,
  Value<DateTime> createdAt,
});

final class $$TrainingReportsTableReferences extends BaseReferences<
    _$AppDatabase, $TrainingReportsTable, TrainingReport> {
  $$TrainingReportsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TrainingSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.trainingSessions.createAlias($_aliasNameGenerator(
          db.trainingReports.sessionId, db.trainingSessions.id));

  $$TrainingSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager =
        $$TrainingSessionsTableTableManager($_db, $_db.trainingSessions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.trainingReports.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TrainingReportsTableFilterComposer
    extends Composer<_$AppDatabase, $TrainingReportsTable> {
  $$TrainingReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalProfit => $composableBuilder(
      column: $table.totalProfit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get profitRate => $composableBuilder(
      column: $table.profitRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tradeCount => $composableBuilder(
      column: $table.tradeCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get winCount => $composableBuilder(
      column: $table.winCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get winRate => $composableBuilder(
      column: $table.winRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxProfit => $composableBuilder(
      column: $table.maxProfit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxLoss => $composableBuilder(
      column: $table.maxLoss, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgProfit => $composableBuilder(
      column: $table.avgProfit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgLoss => $composableBuilder(
      column: $table.avgLoss, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get profitLossRatio => $composableBuilder(
      column: $table.profitLossRatio,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxDrawdown => $composableBuilder(
      column: $table.maxDrawdown, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sharpeRatio => $composableBuilder(
      column: $table.sharpeRatio, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get longestWinStreak => $composableBuilder(
      column: $table.longestWinStreak,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get longestLoseStreak => $composableBuilder(
      column: $table.longestLoseStreak,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgHoldDays => $composableBuilder(
      column: $table.avgHoldDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get conditionOrdersUsed => $composableBuilder(
      column: $table.conditionOrdersUsed,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get conditionOrdersTriggered => $composableBuilder(
      column: $table.conditionOrdersTriggered,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get analysis => $composableBuilder(
      column: $table.analysis, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get suggestions => $composableBuilder(
      column: $table.suggestions, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$TrainingSessionsTableFilterComposer get sessionId {
    final $$TrainingSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableFilterComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TrainingReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainingReportsTable> {
  $$TrainingReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalProfit => $composableBuilder(
      column: $table.totalProfit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get profitRate => $composableBuilder(
      column: $table.profitRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tradeCount => $composableBuilder(
      column: $table.tradeCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get winCount => $composableBuilder(
      column: $table.winCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get winRate => $composableBuilder(
      column: $table.winRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxProfit => $composableBuilder(
      column: $table.maxProfit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxLoss => $composableBuilder(
      column: $table.maxLoss, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgProfit => $composableBuilder(
      column: $table.avgProfit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgLoss => $composableBuilder(
      column: $table.avgLoss, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get profitLossRatio => $composableBuilder(
      column: $table.profitLossRatio,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxDrawdown => $composableBuilder(
      column: $table.maxDrawdown, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sharpeRatio => $composableBuilder(
      column: $table.sharpeRatio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get longestWinStreak => $composableBuilder(
      column: $table.longestWinStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get longestLoseStreak => $composableBuilder(
      column: $table.longestLoseStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgHoldDays => $composableBuilder(
      column: $table.avgHoldDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get conditionOrdersUsed => $composableBuilder(
      column: $table.conditionOrdersUsed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get conditionOrdersTriggered => $composableBuilder(
      column: $table.conditionOrdersTriggered,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get analysis => $composableBuilder(
      column: $table.analysis, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get suggestions => $composableBuilder(
      column: $table.suggestions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$TrainingSessionsTableOrderingComposer get sessionId {
    final $$TrainingSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TrainingReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainingReportsTable> {
  $$TrainingReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get totalProfit => $composableBuilder(
      column: $table.totalProfit, builder: (column) => column);

  GeneratedColumn<double> get profitRate => $composableBuilder(
      column: $table.profitRate, builder: (column) => column);

  GeneratedColumn<int> get tradeCount => $composableBuilder(
      column: $table.tradeCount, builder: (column) => column);

  GeneratedColumn<int> get winCount =>
      $composableBuilder(column: $table.winCount, builder: (column) => column);

  GeneratedColumn<double> get winRate =>
      $composableBuilder(column: $table.winRate, builder: (column) => column);

  GeneratedColumn<double> get maxProfit =>
      $composableBuilder(column: $table.maxProfit, builder: (column) => column);

  GeneratedColumn<double> get maxLoss =>
      $composableBuilder(column: $table.maxLoss, builder: (column) => column);

  GeneratedColumn<double> get avgProfit =>
      $composableBuilder(column: $table.avgProfit, builder: (column) => column);

  GeneratedColumn<double> get avgLoss =>
      $composableBuilder(column: $table.avgLoss, builder: (column) => column);

  GeneratedColumn<double> get profitLossRatio => $composableBuilder(
      column: $table.profitLossRatio, builder: (column) => column);

  GeneratedColumn<double> get maxDrawdown => $composableBuilder(
      column: $table.maxDrawdown, builder: (column) => column);

  GeneratedColumn<double> get sharpeRatio => $composableBuilder(
      column: $table.sharpeRatio, builder: (column) => column);

  GeneratedColumn<int> get longestWinStreak => $composableBuilder(
      column: $table.longestWinStreak, builder: (column) => column);

  GeneratedColumn<int> get longestLoseStreak => $composableBuilder(
      column: $table.longestLoseStreak, builder: (column) => column);

  GeneratedColumn<double> get avgHoldDays => $composableBuilder(
      column: $table.avgHoldDays, builder: (column) => column);

  GeneratedColumn<int> get conditionOrdersUsed => $composableBuilder(
      column: $table.conditionOrdersUsed, builder: (column) => column);

  GeneratedColumn<int> get conditionOrdersTriggered => $composableBuilder(
      column: $table.conditionOrdersTriggered, builder: (column) => column);

  GeneratedColumn<String> get analysis =>
      $composableBuilder(column: $table.analysis, builder: (column) => column);

  GeneratedColumn<String> get suggestions => $composableBuilder(
      column: $table.suggestions, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TrainingSessionsTableAnnotationComposer get sessionId {
    final $$TrainingSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.trainingSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrainingSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.trainingSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TrainingReportsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrainingReportsTable,
    TrainingReport,
    $$TrainingReportsTableFilterComposer,
    $$TrainingReportsTableOrderingComposer,
    $$TrainingReportsTableAnnotationComposer,
    $$TrainingReportsTableCreateCompanionBuilder,
    $$TrainingReportsTableUpdateCompanionBuilder,
    (TrainingReport, $$TrainingReportsTableReferences),
    TrainingReport,
    PrefetchHooks Function({bool sessionId, bool userId})> {
  $$TrainingReportsTableTableManager(
      _$AppDatabase db, $TrainingReportsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainingReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<double> totalProfit = const Value.absent(),
            Value<double> profitRate = const Value.absent(),
            Value<int> tradeCount = const Value.absent(),
            Value<int> winCount = const Value.absent(),
            Value<double> winRate = const Value.absent(),
            Value<double> maxProfit = const Value.absent(),
            Value<double> maxLoss = const Value.absent(),
            Value<double> avgProfit = const Value.absent(),
            Value<double> avgLoss = const Value.absent(),
            Value<double> profitLossRatio = const Value.absent(),
            Value<double> maxDrawdown = const Value.absent(),
            Value<double?> sharpeRatio = const Value.absent(),
            Value<int> longestWinStreak = const Value.absent(),
            Value<int> longestLoseStreak = const Value.absent(),
            Value<double> avgHoldDays = const Value.absent(),
            Value<int> conditionOrdersUsed = const Value.absent(),
            Value<int> conditionOrdersTriggered = const Value.absent(),
            Value<String?> analysis = const Value.absent(),
            Value<String?> suggestions = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TrainingReportsCompanion(
            id: id,
            sessionId: sessionId,
            userId: userId,
            totalProfit: totalProfit,
            profitRate: profitRate,
            tradeCount: tradeCount,
            winCount: winCount,
            winRate: winRate,
            maxProfit: maxProfit,
            maxLoss: maxLoss,
            avgProfit: avgProfit,
            avgLoss: avgLoss,
            profitLossRatio: profitLossRatio,
            maxDrawdown: maxDrawdown,
            sharpeRatio: sharpeRatio,
            longestWinStreak: longestWinStreak,
            longestLoseStreak: longestLoseStreak,
            avgHoldDays: avgHoldDays,
            conditionOrdersUsed: conditionOrdersUsed,
            conditionOrdersTriggered: conditionOrdersTriggered,
            analysis: analysis,
            suggestions: suggestions,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required int userId,
            required double totalProfit,
            required double profitRate,
            required int tradeCount,
            required int winCount,
            required double winRate,
            required double maxProfit,
            required double maxLoss,
            required double avgProfit,
            required double avgLoss,
            required double profitLossRatio,
            required double maxDrawdown,
            Value<double?> sharpeRatio = const Value.absent(),
            required int longestWinStreak,
            required int longestLoseStreak,
            required double avgHoldDays,
            required int conditionOrdersUsed,
            required int conditionOrdersTriggered,
            Value<String?> analysis = const Value.absent(),
            Value<String?> suggestions = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TrainingReportsCompanion.insert(
            id: id,
            sessionId: sessionId,
            userId: userId,
            totalProfit: totalProfit,
            profitRate: profitRate,
            tradeCount: tradeCount,
            winCount: winCount,
            winRate: winRate,
            maxProfit: maxProfit,
            maxLoss: maxLoss,
            avgProfit: avgProfit,
            avgLoss: avgLoss,
            profitLossRatio: profitLossRatio,
            maxDrawdown: maxDrawdown,
            sharpeRatio: sharpeRatio,
            longestWinStreak: longestWinStreak,
            longestLoseStreak: longestLoseStreak,
            avgHoldDays: avgHoldDays,
            conditionOrdersUsed: conditionOrdersUsed,
            conditionOrdersTriggered: conditionOrdersTriggered,
            analysis: analysis,
            suggestions: suggestions,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TrainingReportsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$TrainingReportsTableReferences._sessionIdTable(db),
                    referencedColumn:
                        $$TrainingReportsTableReferences._sessionIdTable(db).id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$TrainingReportsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$TrainingReportsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TrainingReportsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TrainingReportsTable,
    TrainingReport,
    $$TrainingReportsTableFilterComposer,
    $$TrainingReportsTableOrderingComposer,
    $$TrainingReportsTableAnnotationComposer,
    $$TrainingReportsTableCreateCompanionBuilder,
    $$TrainingReportsTableUpdateCompanionBuilder,
    (TrainingReport, $$TrainingReportsTableReferences),
    TrainingReport,
    PrefetchHooks Function({bool sessionId, bool userId})>;
typedef $$UserHabitsTableCreateCompanionBuilder = UserHabitsCompanion Function({
  required int userId,
  required String habitType,
  required String value,
  required double confidence,
  required int sampleSize,
  Value<DateTime> lastUpdated,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$UserHabitsTableUpdateCompanionBuilder = UserHabitsCompanion Function({
  Value<int> userId,
  Value<String> habitType,
  Value<String> value,
  Value<double> confidence,
  Value<int> sampleSize,
  Value<DateTime> lastUpdated,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$UserHabitsTableReferences
    extends BaseReferences<_$AppDatabase, $UserHabitsTable, UserHabit> {
  $$UserHabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.userHabits.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UserHabitsTableFilterComposer
    extends Composer<_$AppDatabase, $UserHabitsTable> {
  $$UserHabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get habitType => $composableBuilder(
      column: $table.habitType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sampleSize => $composableBuilder(
      column: $table.sampleSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserHabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserHabitsTable> {
  $$UserHabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get habitType => $composableBuilder(
      column: $table.habitType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sampleSize => $composableBuilder(
      column: $table.sampleSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserHabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserHabitsTable> {
  $$UserHabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get habitType =>
      $composableBuilder(column: $table.habitType, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<int> get sampleSize => $composableBuilder(
      column: $table.sampleSize, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserHabitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserHabitsTable,
    UserHabit,
    $$UserHabitsTableFilterComposer,
    $$UserHabitsTableOrderingComposer,
    $$UserHabitsTableAnnotationComposer,
    $$UserHabitsTableCreateCompanionBuilder,
    $$UserHabitsTableUpdateCompanionBuilder,
    (UserHabit, $$UserHabitsTableReferences),
    UserHabit,
    PrefetchHooks Function({bool userId})> {
  $$UserHabitsTableTableManager(_$AppDatabase db, $UserHabitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserHabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserHabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserHabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> userId = const Value.absent(),
            Value<String> habitType = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<int> sampleSize = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserHabitsCompanion(
            userId: userId,
            habitType: habitType,
            value: value,
            confidence: confidence,
            sampleSize: sampleSize,
            lastUpdated: lastUpdated,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int userId,
            required String habitType,
            required String value,
            required double confidence,
            required int sampleSize,
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserHabitsCompanion.insert(
            userId: userId,
            habitType: habitType,
            value: value,
            confidence: confidence,
            sampleSize: sampleSize,
            lastUpdated: lastUpdated,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UserHabitsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$UserHabitsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$UserHabitsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UserHabitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserHabitsTable,
    UserHabit,
    $$UserHabitsTableFilterComposer,
    $$UserHabitsTableOrderingComposer,
    $$UserHabitsTableAnnotationComposer,
    $$UserHabitsTableCreateCompanionBuilder,
    $$UserHabitsTableUpdateCompanionBuilder,
    (UserHabit, $$UserHabitsTableReferences),
    UserHabit,
    PrefetchHooks Function({bool userId})>;
typedef $$TradingPatternsTableCreateCompanionBuilder = TradingPatternsCompanion
    Function({
  Value<int> id,
  required int userId,
  required String patternType,
  required double occurrenceRate,
  required double successRate,
  required double avgProfitRate,
  required int sampleCount,
  Value<String?> conditions,
  Value<String?> parameters,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$TradingPatternsTableUpdateCompanionBuilder = TradingPatternsCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<String> patternType,
  Value<double> occurrenceRate,
  Value<double> successRate,
  Value<double> avgProfitRate,
  Value<int> sampleCount,
  Value<String?> conditions,
  Value<String?> parameters,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$TradingPatternsTableReferences extends BaseReferences<
    _$AppDatabase, $TradingPatternsTable, TradingPattern> {
  $$TradingPatternsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.tradingPatterns.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TradingPatternsTableFilterComposer
    extends Composer<_$AppDatabase, $TradingPatternsTable> {
  $$TradingPatternsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patternType => $composableBuilder(
      column: $table.patternType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get occurrenceRate => $composableBuilder(
      column: $table.occurrenceRate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get successRate => $composableBuilder(
      column: $table.successRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgProfitRate => $composableBuilder(
      column: $table.avgProfitRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sampleCount => $composableBuilder(
      column: $table.sampleCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parameters => $composableBuilder(
      column: $table.parameters, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TradingPatternsTableOrderingComposer
    extends Composer<_$AppDatabase, $TradingPatternsTable> {
  $$TradingPatternsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patternType => $composableBuilder(
      column: $table.patternType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get occurrenceRate => $composableBuilder(
      column: $table.occurrenceRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get successRate => $composableBuilder(
      column: $table.successRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgProfitRate => $composableBuilder(
      column: $table.avgProfitRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sampleCount => $composableBuilder(
      column: $table.sampleCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parameters => $composableBuilder(
      column: $table.parameters, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TradingPatternsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TradingPatternsTable> {
  $$TradingPatternsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patternType => $composableBuilder(
      column: $table.patternType, builder: (column) => column);

  GeneratedColumn<double> get occurrenceRate => $composableBuilder(
      column: $table.occurrenceRate, builder: (column) => column);

  GeneratedColumn<double> get successRate => $composableBuilder(
      column: $table.successRate, builder: (column) => column);

  GeneratedColumn<double> get avgProfitRate => $composableBuilder(
      column: $table.avgProfitRate, builder: (column) => column);

  GeneratedColumn<int> get sampleCount => $composableBuilder(
      column: $table.sampleCount, builder: (column) => column);

  GeneratedColumn<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => column);

  GeneratedColumn<String> get parameters => $composableBuilder(
      column: $table.parameters, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TradingPatternsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TradingPatternsTable,
    TradingPattern,
    $$TradingPatternsTableFilterComposer,
    $$TradingPatternsTableOrderingComposer,
    $$TradingPatternsTableAnnotationComposer,
    $$TradingPatternsTableCreateCompanionBuilder,
    $$TradingPatternsTableUpdateCompanionBuilder,
    (TradingPattern, $$TradingPatternsTableReferences),
    TradingPattern,
    PrefetchHooks Function({bool userId})> {
  $$TradingPatternsTableTableManager(
      _$AppDatabase db, $TradingPatternsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TradingPatternsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TradingPatternsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TradingPatternsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> patternType = const Value.absent(),
            Value<double> occurrenceRate = const Value.absent(),
            Value<double> successRate = const Value.absent(),
            Value<double> avgProfitRate = const Value.absent(),
            Value<int> sampleCount = const Value.absent(),
            Value<String?> conditions = const Value.absent(),
            Value<String?> parameters = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TradingPatternsCompanion(
            id: id,
            userId: userId,
            patternType: patternType,
            occurrenceRate: occurrenceRate,
            successRate: successRate,
            avgProfitRate: avgProfitRate,
            sampleCount: sampleCount,
            conditions: conditions,
            parameters: parameters,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required String patternType,
            required double occurrenceRate,
            required double successRate,
            required double avgProfitRate,
            required int sampleCount,
            Value<String?> conditions = const Value.absent(),
            Value<String?> parameters = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TradingPatternsCompanion.insert(
            id: id,
            userId: userId,
            patternType: patternType,
            occurrenceRate: occurrenceRate,
            successRate: successRate,
            avgProfitRate: avgProfitRate,
            sampleCount: sampleCount,
            conditions: conditions,
            parameters: parameters,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TradingPatternsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$TradingPatternsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$TradingPatternsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TradingPatternsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TradingPatternsTable,
    TradingPattern,
    $$TradingPatternsTableFilterComposer,
    $$TradingPatternsTableOrderingComposer,
    $$TradingPatternsTableAnnotationComposer,
    $$TradingPatternsTableCreateCompanionBuilder,
    $$TradingPatternsTableUpdateCompanionBuilder,
    (TradingPattern, $$TradingPatternsTableReferences),
    TradingPattern,
    PrefetchHooks Function({bool userId})>;
typedef $$StrategyTipsTableCreateCompanionBuilder = StrategyTipsCompanion
    Function({
  Value<int> id,
  required String code,
  required String title,
  required String description,
  required String category,
  required double effectiveness,
  required int verifiedUsers,
  required String conditions,
  required String rules,
  Value<String?> examples,
  Value<String?> notes,
  Value<bool> enabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$StrategyTipsTableUpdateCompanionBuilder = StrategyTipsCompanion
    Function({
  Value<int> id,
  Value<String> code,
  Value<String> title,
  Value<String> description,
  Value<String> category,
  Value<double> effectiveness,
  Value<int> verifiedUsers,
  Value<String> conditions,
  Value<String> rules,
  Value<String?> examples,
  Value<String?> notes,
  Value<bool> enabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$StrategyTipsTableFilterComposer
    extends Composer<_$AppDatabase, $StrategyTipsTable> {
  $$StrategyTipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get effectiveness => $composableBuilder(
      column: $table.effectiveness, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get verifiedUsers => $composableBuilder(
      column: $table.verifiedUsers, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rules => $composableBuilder(
      column: $table.rules, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get examples => $composableBuilder(
      column: $table.examples, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$StrategyTipsTableOrderingComposer
    extends Composer<_$AppDatabase, $StrategyTipsTable> {
  $$StrategyTipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get effectiveness => $composableBuilder(
      column: $table.effectiveness,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get verifiedUsers => $composableBuilder(
      column: $table.verifiedUsers,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rules => $composableBuilder(
      column: $table.rules, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get examples => $composableBuilder(
      column: $table.examples, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$StrategyTipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StrategyTipsTable> {
  $$StrategyTipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get effectiveness => $composableBuilder(
      column: $table.effectiveness, builder: (column) => column);

  GeneratedColumn<int> get verifiedUsers => $composableBuilder(
      column: $table.verifiedUsers, builder: (column) => column);

  GeneratedColumn<String> get conditions => $composableBuilder(
      column: $table.conditions, builder: (column) => column);

  GeneratedColumn<String> get rules =>
      $composableBuilder(column: $table.rules, builder: (column) => column);

  GeneratedColumn<String> get examples =>
      $composableBuilder(column: $table.examples, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StrategyTipsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StrategyTipsTable,
    StrategyTip,
    $$StrategyTipsTableFilterComposer,
    $$StrategyTipsTableOrderingComposer,
    $$StrategyTipsTableAnnotationComposer,
    $$StrategyTipsTableCreateCompanionBuilder,
    $$StrategyTipsTableUpdateCompanionBuilder,
    (
      StrategyTip,
      BaseReferences<_$AppDatabase, $StrategyTipsTable, StrategyTip>
    ),
    StrategyTip,
    PrefetchHooks Function()> {
  $$StrategyTipsTableTableManager(_$AppDatabase db, $StrategyTipsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StrategyTipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StrategyTipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StrategyTipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> effectiveness = const Value.absent(),
            Value<int> verifiedUsers = const Value.absent(),
            Value<String> conditions = const Value.absent(),
            Value<String> rules = const Value.absent(),
            Value<String?> examples = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              StrategyTipsCompanion(
            id: id,
            code: code,
            title: title,
            description: description,
            category: category,
            effectiveness: effectiveness,
            verifiedUsers: verifiedUsers,
            conditions: conditions,
            rules: rules,
            examples: examples,
            notes: notes,
            enabled: enabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String title,
            required String description,
            required String category,
            required double effectiveness,
            required int verifiedUsers,
            required String conditions,
            required String rules,
            Value<String?> examples = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              StrategyTipsCompanion.insert(
            id: id,
            code: code,
            title: title,
            description: description,
            category: category,
            effectiveness: effectiveness,
            verifiedUsers: verifiedUsers,
            conditions: conditions,
            rules: rules,
            examples: examples,
            notes: notes,
            enabled: enabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StrategyTipsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StrategyTipsTable,
    StrategyTip,
    $$StrategyTipsTableFilterComposer,
    $$StrategyTipsTableOrderingComposer,
    $$StrategyTipsTableAnnotationComposer,
    $$StrategyTipsTableCreateCompanionBuilder,
    $$StrategyTipsTableUpdateCompanionBuilder,
    (
      StrategyTip,
      BaseReferences<_$AppDatabase, $StrategyTipsTable, StrategyTip>
    ),
    StrategyTip,
    PrefetchHooks Function()>;
typedef $$SystemConfigsTableCreateCompanionBuilder = SystemConfigsCompanion
    Function({
  required String key,
  required String value,
  Value<String?> description,
  Value<String> category,
  Value<bool> isPublic,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$SystemConfigsTableUpdateCompanionBuilder = SystemConfigsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<String?> description,
  Value<String> category,
  Value<bool> isPublic,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SystemConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $SystemConfigsTable> {
  $$SystemConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPublic => $composableBuilder(
      column: $table.isPublic, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SystemConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $SystemConfigsTable> {
  $$SystemConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPublic => $composableBuilder(
      column: $table.isPublic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SystemConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SystemConfigsTable> {
  $$SystemConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isPublic =>
      $composableBuilder(column: $table.isPublic, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SystemConfigsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SystemConfigsTable,
    SystemConfig,
    $$SystemConfigsTableFilterComposer,
    $$SystemConfigsTableOrderingComposer,
    $$SystemConfigsTableAnnotationComposer,
    $$SystemConfigsTableCreateCompanionBuilder,
    $$SystemConfigsTableUpdateCompanionBuilder,
    (
      SystemConfig,
      BaseReferences<_$AppDatabase, $SystemConfigsTable, SystemConfig>
    ),
    SystemConfig,
    PrefetchHooks Function()> {
  $$SystemConfigsTableTableManager(_$AppDatabase db, $SystemConfigsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SystemConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SystemConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SystemConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<bool> isPublic = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SystemConfigsCompanion(
            key: key,
            value: value,
            description: description,
            category: category,
            isPublic: isPublic,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<String?> description = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<bool> isPublic = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SystemConfigsCompanion.insert(
            key: key,
            value: value,
            description: description,
            category: category,
            isPublic: isPublic,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SystemConfigsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SystemConfigsTable,
    SystemConfig,
    $$SystemConfigsTableFilterComposer,
    $$SystemConfigsTableOrderingComposer,
    $$SystemConfigsTableAnnotationComposer,
    $$SystemConfigsTableCreateCompanionBuilder,
    $$SystemConfigsTableUpdateCompanionBuilder,
    (
      SystemConfig,
      BaseReferences<_$AppDatabase, $SystemConfigsTable, SystemConfig>
    ),
    SystemConfig,
    PrefetchHooks Function()>;
typedef $$VersionHistoryTableCreateCompanionBuilder = VersionHistoryCompanion
    Function({
  Value<int> id,
  required String version,
  required String title,
  required String changes,
  Value<bool> isMajor,
  Value<DateTime> releaseDate,
  Value<DateTime> createdAt,
});
typedef $$VersionHistoryTableUpdateCompanionBuilder = VersionHistoryCompanion
    Function({
  Value<int> id,
  Value<String> version,
  Value<String> title,
  Value<String> changes,
  Value<bool> isMajor,
  Value<DateTime> releaseDate,
  Value<DateTime> createdAt,
});

class $$VersionHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $VersionHistoryTable> {
  $$VersionHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get changes => $composableBuilder(
      column: $table.changes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isMajor => $composableBuilder(
      column: $table.isMajor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$VersionHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $VersionHistoryTable> {
  $$VersionHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get changes => $composableBuilder(
      column: $table.changes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMajor => $composableBuilder(
      column: $table.isMajor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$VersionHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $VersionHistoryTable> {
  $$VersionHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get changes =>
      $composableBuilder(column: $table.changes, builder: (column) => column);

  GeneratedColumn<bool> get isMajor =>
      $composableBuilder(column: $table.isMajor, builder: (column) => column);

  GeneratedColumn<DateTime> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VersionHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VersionHistoryTable,
    VersionHistoryData,
    $$VersionHistoryTableFilterComposer,
    $$VersionHistoryTableOrderingComposer,
    $$VersionHistoryTableAnnotationComposer,
    $$VersionHistoryTableCreateCompanionBuilder,
    $$VersionHistoryTableUpdateCompanionBuilder,
    (
      VersionHistoryData,
      BaseReferences<_$AppDatabase, $VersionHistoryTable, VersionHistoryData>
    ),
    VersionHistoryData,
    PrefetchHooks Function()> {
  $$VersionHistoryTableTableManager(
      _$AppDatabase db, $VersionHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VersionHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VersionHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VersionHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> version = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> changes = const Value.absent(),
            Value<bool> isMajor = const Value.absent(),
            Value<DateTime> releaseDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              VersionHistoryCompanion(
            id: id,
            version: version,
            title: title,
            changes: changes,
            isMajor: isMajor,
            releaseDate: releaseDate,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String version,
            required String title,
            required String changes,
            Value<bool> isMajor = const Value.absent(),
            Value<DateTime> releaseDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              VersionHistoryCompanion.insert(
            id: id,
            version: version,
            title: title,
            changes: changes,
            isMajor: isMajor,
            releaseDate: releaseDate,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VersionHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VersionHistoryTable,
    VersionHistoryData,
    $$VersionHistoryTableFilterComposer,
    $$VersionHistoryTableOrderingComposer,
    $$VersionHistoryTableAnnotationComposer,
    $$VersionHistoryTableCreateCompanionBuilder,
    $$VersionHistoryTableUpdateCompanionBuilder,
    (
      VersionHistoryData,
      BaseReferences<_$AppDatabase, $VersionHistoryTable, VersionHistoryData>
    ),
    VersionHistoryData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$UserPreferencesTableTableManager get userPreferences =>
      $$UserPreferencesTableTableManager(_db, _db.userPreferences);
  $$MarketsTableTableManager get markets =>
      $$MarketsTableTableManager(_db, _db.markets);
  $$SymbolsTableTableManager get symbols =>
      $$SymbolsTableTableManager(_db, _db.symbols);
  $$KlineDataTableTableManager get klineData =>
      $$KlineDataTableTableManager(_db, _db.klineData);
  $$StockFilterResultsTableTableManager get stockFilterResults =>
      $$StockFilterResultsTableTableManager(_db, _db.stockFilterResults);
  $$DailyStockStatsTableTableManager get dailyStockStats =>
      $$DailyStockStatsTableTableManager(_db, _db.dailyStockStats);
  $$TrainingSessionsTableTableManager get trainingSessions =>
      $$TrainingSessionsTableTableManager(_db, _db.trainingSessions);
  $$PositionsTableTableManager get positions =>
      $$PositionsTableTableManager(_db, _db.positions);
  $$TradesTableTableManager get trades =>
      $$TradesTableTableManager(_db, _db.trades);
  $$ConditionalOrdersTableTableManager get conditionalOrders =>
      $$ConditionalOrdersTableTableManager(_db, _db.conditionalOrders);
  $$OperationLogsTableTableManager get operationLogs =>
      $$OperationLogsTableTableManager(_db, _db.operationLogs);
  $$TrainingReportsTableTableManager get trainingReports =>
      $$TrainingReportsTableTableManager(_db, _db.trainingReports);
  $$UserHabitsTableTableManager get userHabits =>
      $$UserHabitsTableTableManager(_db, _db.userHabits);
  $$TradingPatternsTableTableManager get tradingPatterns =>
      $$TradingPatternsTableTableManager(_db, _db.tradingPatterns);
  $$StrategyTipsTableTableManager get strategyTips =>
      $$StrategyTipsTableTableManager(_db, _db.strategyTips);
  $$SystemConfigsTableTableManager get systemConfigs =>
      $$SystemConfigsTableTableManager(_db, _db.systemConfigs);
  $$VersionHistoryTableTableManager get versionHistory =>
      $$VersionHistoryTableTableManager(_db, _db.versionHistory);
}
