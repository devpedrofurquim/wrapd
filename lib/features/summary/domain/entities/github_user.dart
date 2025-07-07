class GitHubUser {
  final String login;
  final String name;
  final String? avatarUrl;
  final String? bio;
  final int publicRepos;
  final int followers;
  final int following;

  GitHubUser({
    required this.login,
    required this.name,
    this.avatarUrl,
    this.bio,
    required this.publicRepos,
    required this.followers,
    required this.following,
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    try {
      print('🔄 GitHubUser: Parsing JSON: $json');

      final user = GitHubUser(
        login: json['login']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        avatarUrl: json['avatar_url']?.toString(),
        bio: json['bio']?.toString(),
        publicRepos: json['public_repos'] as int? ?? 0,
        followers: json['followers'] as int? ?? 0,
        following: json['following'] as int? ?? 0,
      );

      print('✅ GitHubUser: Parsed successfully: ${user.login}');
      return user;
    } catch (e) {
      print('❌ GitHubUser: Error parsing JSON: $e');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'GitHubUser(login: $login, name: $name, avatarUrl: $avatarUrl)';
  }
}
