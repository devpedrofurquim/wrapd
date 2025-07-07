import 'package:equatable/equatable.dart';

abstract class SessionState extends Equatable {
  const SessionState(); // Add const constructor to parent class

  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {
  const SessionInitial(); // Add const constructor
}

class SessionLoading extends SessionState {
  const SessionLoading(); // Add const constructor
}

class SessionAuthenticated extends SessionState {
  final String token;
  final String? userId;
  final String? username;
  final String? avatarUrl;

  const SessionAuthenticated({
    // Add const here
    required this.token,
    this.userId,
    this.username,
    this.avatarUrl,
  });

  SessionAuthenticated copyWith({
    String? token,
    String? userId,
    String? username,
    String? avatarUrl,
  }) {
    return SessionAuthenticated(
      token: token ?? this.token,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [token, userId, username, avatarUrl];
}

class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated(); // Add const constructor
}
