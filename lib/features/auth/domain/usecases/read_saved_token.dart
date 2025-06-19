import '../repositories/auth_repository.dart';

class ReadSavedToken {
  final AuthRepository repository;

  ReadSavedToken(this.repository);

  Future<String?> call() async {
    return repository.readToken();
  }
}
