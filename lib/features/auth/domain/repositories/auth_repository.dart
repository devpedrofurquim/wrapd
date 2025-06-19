abstract class AuthRepository {
  Future<String> loginWithCode(String code);
  Future<void> saveToken(String token);
  Future<String?> readToken();
  Future<void> logout();
  String getLoginUrl();
}
