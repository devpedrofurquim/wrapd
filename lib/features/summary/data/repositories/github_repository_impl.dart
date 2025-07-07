import 'package:dio/dio.dart';
import '../../domain/entities/github_user.dart';
import '../../domain/repositories/github_repository.dart';

class GitHubRepositoryImpl implements GitHubRepository {
  final Dio dio;

  GitHubRepositoryImpl(this.dio);

  @override
  Future<GitHubUser> getCurrentUser(String token) async {
    try {
      print('🌐 GitHubRepository: Making API call to /user');
      print('🔑 GitHubRepository: Token: ${token.substring(0, 10)}...');

      final response = await dio.get(
        'https://api.github.com/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('📡 GitHubRepository: Response status: ${response.statusCode}');
      print('📦 GitHubRepository: Response data: ${response.data}');

      if (response.statusCode == 200) {
        final user = GitHubUser.fromJson(response.data);
        print('✅ GitHubRepository: User parsed successfully: ${user.login}');
        return user;
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ GitHubRepository: Dio error: ${e.message}');
      print('📍 GitHubRepository: Error type: ${e.type}');
      if (e.response != null) {
        print(
          '📍 GitHubRepository: Response status: ${e.response?.statusCode}',
        );
        print('📍 GitHubRepository: Response data: ${e.response?.data}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('❌ GitHubRepository: Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
