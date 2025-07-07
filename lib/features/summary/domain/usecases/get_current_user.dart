import '../entities/github_user.dart';
import '../repositories/github_repository.dart';

class GetCurrentUser {
  final GitHubRepository repository;

  GetCurrentUser(this.repository);

  Future<GitHubUser> call(String token) async {
    return await repository.getCurrentUser(token);
  }
}