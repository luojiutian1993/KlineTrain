// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      userId: json['userId'] as String,
      balance: (json['balance'] as num).toDouble(),
      availableBalance: (json['availableBalance'] as num).toDouble(),
      usedMargin: (json['usedMargin'] as num).toDouble(),
      frozenBalance: (json['frozenBalance'] as num).toDouble(),
      totalProfit: (json['totalProfit'] as num).toDouble(),
      todayProfit: (json['todayProfit'] as num).toDouble(),
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'balance': instance.balance,
      'availableBalance': instance.availableBalance,
      'usedMargin': instance.usedMargin,
      'frozenBalance': instance.frozenBalance,
      'totalProfit': instance.totalProfit,
      'todayProfit': instance.todayProfit,
    };
