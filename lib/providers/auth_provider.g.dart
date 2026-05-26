// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'c4cb08b6778df99e1f274881e5acd743b01c79e3';

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeNotifierProvider<AuthNotifier, bool>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AutoDisposeNotifier<bool>;
String _$currentUserNotifierHash() =>
    r'022b1540088f7593957c40341854b51815a13774';

/// See also [CurrentUserNotifier].
@ProviderFor(CurrentUserNotifier)
final currentUserNotifierProvider =
    NotifierProvider<CurrentUserNotifier, UserModel?>.internal(
  CurrentUserNotifier.new,
  name: r'currentUserNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentUserNotifier = Notifier<UserModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
