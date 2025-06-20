// Import Flutter's built-in test framework
import 'package:flutter_test/flutter_test.dart';
// Import your domain layer's repository interface and use case
import 'package:wrapd/features/auth/domain/repositories/auth_repository.dart';
import 'package:wrapd/features/auth/domain/usecases/login_w_github.dart';

/// A fake implementation of `AuthRepository`
/// This avoids real API calls and secure storage writes
/// Useful for fast and isolated unit testing
class FakeAuthRepository implements AuthRepository {
  String? savedToken; // Used to simulate token persistence

  @override
  Future<String> loginWithCode(String code) async {
    // Simulate exchanging a GitHub code for an access token
    return 'token_from_$code';
  }

  @override
  Future<void> saveToken(String token) async {
    // Simulate saving the token securely
    savedToken = token;
  }

  @override
  String getLoginUrl() => 'https://example.com'; // Not tested here

  @override
  Future<String?> readToken() async => savedToken; // Optional helper

  @override
  Future<void> logout() async {
    savedToken = null;
  }
}

void main() {
  // Define a test using Flutter's `test()` function
  test('LoginWithGithub stores token after login', () async {
    // Arrange: Create a fake repo and inject it into the use case
    final repo = FakeAuthRepository();
    final useCase = LoginWithGithub(repo);

    // Act: Run the use case with a sample code
    final token = await useCase('abc123');

    // Assert: The returned token should match the fake token logic
    expect(token, 'token_from_abc123');
    // Assert: The token should have been saved inside the repository
    expect(repo.savedToken, 'token_from_abc123');
  });
}
