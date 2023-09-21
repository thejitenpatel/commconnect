// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authProvidersHash() => r'ae6cefe8190c6d4e0c24eed661e7889031bfabda';

/// See also [authProviders].
@ProviderFor(authProviders)
final authProvidersProvider =
    Provider<List<AuthProvider<AuthListener, AuthCredential>>>.internal(
  authProviders,
  name: r'authProvidersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authProvidersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthProvidersRef
    = ProviderRef<List<AuthProvider<AuthListener, AuthCredential>>>;
String _$stepIndexHash() => r'630a81e99e0e28a56a78c49953ddb30f1018d940';

/// See also [StepIndex].
@ProviderFor(StepIndex)
final stepIndexProvider = AutoDisposeNotifierProvider<StepIndex, int>.internal(
  StepIndex.new,
  name: r'stepIndexProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$stepIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StepIndex = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
