import '../repositories/auth_repository.dart';

class GetLoginUrl {
  final AuthRepository repository;

  GetLoginUrl(this.repository);

  String call() {
    return repository.getLoginUrl();
  }
}
