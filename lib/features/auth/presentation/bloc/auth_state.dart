import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInital extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSucess extends AuthState {
  final String accessToken;

  const AuthSucess(this.accessToken);

  @override
  List<Object?> get props => [accessToken];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

    @override
  List<Object?> get props => [message];
}
