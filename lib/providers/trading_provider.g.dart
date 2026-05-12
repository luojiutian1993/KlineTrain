// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trading_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountHash() => r'4df846ea96858d581530bff62bad44c3658a0199';

/// See also [Account].
@ProviderFor(Account)
final accountProvider =
    AutoDisposeAsyncNotifierProvider<Account, AccountModel>.internal(
  Account.new,
  name: r'accountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Account = AutoDisposeAsyncNotifier<AccountModel>;
String _$positionsHash() => r'c280a0397770fe4762a18e185f881a0d61d5a389';

/// See also [Positions].
@ProviderFor(Positions)
final positionsProvider =
    AutoDisposeAsyncNotifierProvider<Positions, List<PositionModel>>.internal(
  Positions.new,
  name: r'positionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$positionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Positions = AutoDisposeAsyncNotifier<List<PositionModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
