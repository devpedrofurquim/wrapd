class GitHubUser {
  final String login;
  final String name;
  final String? avatarUrl;
  final String? bio;
  final int publicRepos;
  final int followers;
  final int following;
  final String email;
  final String company;
  final String location;
  final String blog;
  final String twitterUsername;
  final DateTime? createdAt;


  GitHubUser({
    required this.login,
    required this.name,
    this.avatarUrl,
    this.bio,
    required this.publicRepos,
    required this.followers,
    required this.following,
    required this.email,
    required this.company,
    required this.location,
    required this.blog,
    required this.twitterUsername,
    this.createdAt,
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
        email: json['email'].toString(),
        company: json['company'].toString(),
        location: json['location'].toString(),
        blog: json['blog'].toString(),
        twitterUsername: json['twitter_username'].toString(),
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'])
            : null,
      );

      print('✅ GitHubUser: Parsed successfully: ${user.login}');
      return user;
    } catch (e) {
      print('❌ GitHubUser: Error parsing JSON: $e');
      rethrow;
    }
  }

  // Helper method to get years on GitHub
  int get yearsOnGitHub {
    if (createdAt == null) return 0;
    final now = DateTime.now();
    return now.difference(createdAt!).inDays ~/ 365;
  }

  @override
  String toString() {
    return 'GitHubUser(login: $login, name: $name, avatarUrl: $avatarUrl)';
  }
}
