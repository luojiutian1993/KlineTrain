import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.g.dart';

enum MemberLevel {
  @JsonValue('bronze')
  bronze('青铜', 1),
  @JsonValue('silver')
  silver('白银', 2),
  @JsonValue('gold')
  gold('黄金', 3),
  @JsonValue('platinum')
  platinum('铂金', 4),
  @JsonValue('diamond')
  diamond('钻石', 5);

  const MemberLevel(this.label, this.value);
  final String label;
  final int value;
}

@JsonSerializable()
class UserModel {
  final String userId;
  final String phone;
  final String nickname;
  final String avatarUrl;
  final MemberLevel level;
  final int trainingCount;
  final double totalReturnPercent;
  final int winCount;
  final int totalTrades;
  final int learningProgress;
  final bool hasPassword;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.phone,
    this.nickname = '',
    this.avatarUrl = '',
    required this.level,
    this.trainingCount = 0,
    this.totalReturnPercent = 0.0,
    this.winCount = 0,
    this.totalTrades = 0,
    this.learningProgress = 0,
    this.hasPassword = false,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? userId,
    String? phone,
    String? nickname,
    String? avatarUrl,
    MemberLevel? level,
    int? trainingCount,
    double? totalReturnPercent,
    int? winCount,
    int? totalTrades,
    int? learningProgress,
    bool? hasPassword,
    DateTime? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      phone: phone ?? this.phone,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      trainingCount: trainingCount ?? this.trainingCount,
      totalReturnPercent: totalReturnPercent ?? this.totalReturnPercent,
      winCount: winCount ?? this.winCount,
      totalTrades: totalTrades ?? this.totalTrades,
      learningProgress: learningProgress ?? this.learningProgress,
      hasPassword: hasPassword ?? this.hasPassword,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
