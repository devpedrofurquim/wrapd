import 'package:flutter_test/flutter_test.dart';
import 'package:wrapd/features/auth/domain/repositories/auth_repository.dart';
import 'package:wrapd/features/auth/domain/usecases/read_saved_token.dart';

class FakeAuthRepository implements AuthRepository {
  String? token = 'stored_token';

  @override
  Future<String?> readToken() async => token;
  @override
  Future<void> saveToken(String token) async {}
  @override
  Future<void> logout() async {}
  @override
  String getLoginUrl() => '';
  @override
  Future<String> loginWithCode(String code) async => '';
}

void main() {
  test('ReadSavedToken returns stored token', () async {
    final repo = FakeAuthRepository();
    final useCase = ReadSavedToken(repo);

    final result = await useCase();

    expect(result, 'stored_token');
  });
}
