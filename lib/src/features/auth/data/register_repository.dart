import 'package:commconnect/src/core/local/local_storage_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_repository.g.dart';

@riverpod
RegisterRepository registerRepository(RegisterRepositoryRef ref) {
  return RegisterRepository(
      localStorageManager: ref.watch(localStorageManagerProvider));
}

class RegisterRepository {
  final LocalStorageManager _localStorageManager;

  RegisterRepository({required LocalStorageManager localStorageManager})
      : _localStorageManager = localStorageManager;

  void saveRegistrationDetails({
    required firstName,
    required middleName,
    required surname,
  }) async {
    _localStorageManager.add("registrationDetails", "");
  }
}
