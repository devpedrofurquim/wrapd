import 'package:wrapd/features/auth/domain/repositories/auth_repository.dart';

class LoginWithGithub {
  final AuthRepository repository;

  LoginWithGithub(this.repository);

  Future<String> call(String code) async {
    final token = await repository.loginWithCode(code);
    await repository.saveToken(token);
    return token;
  }
}
