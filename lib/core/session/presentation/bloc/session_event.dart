import 'package:equatable/equatable.dart';

abstract class SessionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SessionStarted extends SessionEvent {}

class SessionTokenReceived extends SessionEvent {
  final String token;

  SessionTokenReceived(this.token);

  @override
  List<Object> get props => [token];
}

class SessionUserInfoUpdated extends SessionEvent {
  final String? userId;
  final String? username;
  final String? avatarUrl;

  SessionUserInfoUpdated({
    this.userId,
    this.username,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [userId, username, avatarUrl];
}

class SessionEnded extends SessionEvent {}