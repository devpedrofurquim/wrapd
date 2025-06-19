import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wrapd/core/storage/token_storage.dart';
import 'package:wrapd/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final TokenStorage storage;

  AuthRepositoryImpl(this.dio, this.storage);

  final String _clientId = dotenv.env['GITHUB_CLIENT_ID']!;
  final String _clientSecret = dotenv.env['GITHUB_CLIENT_SECRET']!;
  final String _redirectUri = dotenv.env['GITHUB_REDIRECT_URI']!;

  @override
  String getLoginUrl() {
    return 'https://github.com/login/oauth/authorize'
        '?client_id=$_clientId'
        '&redirect_uri=$_redirectUri'
        '&scope=read:user%20repo';
  }

  @override
  Future<String> loginWithCode(String code) async {
    final response = await dio.post(
      'https://github.com/login/oauth/access_token',
      data: {
        'client_id': _clientId,
        'client_secret': _clientSecret,
        'code': code,
        'redirect_uri': _redirectUri,
      },
      options: Options(headers: {'Accept': 'application/json'}),
    );

    if (response.statusCode == 200 && response.data['access_token'] != null) {
      return response.data['access_token'];
    } else {
      throw Exception('Failed to retrieve access token');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await storage.saveToken(token);
    print('✅ Token saved to secure storage: $token');
  }

  @override
Future<String?> readToken() async {
  final token = await storage.readToken();
  print('📦 Read token: $token');
  return token;
}

  @override
  Future<void> logout() async {
    await storage.clearToken();
  }
}
