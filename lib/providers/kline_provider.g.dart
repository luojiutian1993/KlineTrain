// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kline_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedSymbolHash() => r'92a6cc4c073e0c56b223677f8c3a325ce7bc343e';

/// See also [selectedSymbol].
@ProviderFor(selectedSymbol)
final selectedSymbolProvider = AutoDisposeProvider<String>.internal(
  selectedSymbol,
  name: r'selectedSymbolProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedSymbolHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedSymbolRef = AutoDisposeProviderRef<String>;
String _$timeFrameHash() => r'bfefe5dab7b95b0fedb5931ed68e0f117cdc228b';

/// See also [timeFrame].
@ProviderFor(timeFrame)
final timeFrameProvider = AutoDisposeProvider<String>.internal(
  timeFrame,
  name: r'timeFrameProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$timeFrameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TimeFrameRef = AutoDisposeProviderRef<String>;
String _$klineDataHash() => r'914e55f65d4e7ccf67debebff43f2d503126ecaa';

/// See also [KlineData].
@ProviderFor(KlineData)
final klineDataProvider =
    AutoDisposeAsyncNotifierProvider<KlineData, List<KlineModel>>.internal(
  KlineData.new,
  name: r'klineDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$klineDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$KlineData = AutoDisposeAsyncNotifier<List<KlineModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
