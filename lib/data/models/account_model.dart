import 'package:json_annotation/json_annotation.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  final String userId;
  final double balance;
  final double availableBalance;
  final double usedMargin;
  final double frozenBalance;
  final double totalProfit;
  final double todayProfit;

  AccountModel({
    required this.userId,
    required this.balance,
    required this.availableBalance,
    required this.usedMargin,
    required this.frozenBalance,
    required this.totalProfit,
    required this.todayProfit,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
