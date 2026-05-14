// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userId: json['userId'] as String,
      phone: json['phone'] as String,
      nickname: json['nickname'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      level: $enumDecode(_$MemberLevelEnumMap, json['level']),
      trainingCount: (json['trainingCount'] as num?)?.toInt() ?? 0,
      totalReturnPercent:
          (json['totalReturnPercent'] as num?)?.toDouble() ?? 0.0,
      winCount: (json['winCount'] as num?)?.toInt() ?? 0,
      totalTrades: (json['totalTrades'] as num?)?.toInt() ?? 0,
      learningProgress: (json['learningProgress'] as num?)?.toInt() ?? 0,
      hasPassword: json['hasPassword'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'phone': instance.phone,
      'nickname': instance.nickname,
      'avatarUrl': instance.avatarUrl,
      'level': _$MemberLevelEnumMap[instance.level]!,
      'trainingCount': instance.trainingCount,
      'totalReturnPercent': instance.totalReturnPercent,
      'winCount': instance.winCount,
      'totalTrades': instance.totalTrades,
      'learningProgress': instance.learningProgress,
      'hasPassword': instance.hasPassword,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$MemberLevelEnumMap = {
  MemberLevel.bronze: 'bronze',
  MemberLevel.silver: 'silver',
  MemberLevel.gold: 'gold',
  MemberLevel.platinum: 'platinum',
  MemberLevel.diamond: 'diamond',
};
