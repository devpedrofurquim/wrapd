import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wrapd/core/session/presentation/bloc/session_bloc.dart';
import 'package:wrapd/core/session/presentation/bloc/session_event.dart';
import 'package:wrapd/features/auth/domain/usecases/login_w_github.dart';
import 'package:wrapd/features/auth/domain/usecases/read_saved_token.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithGithub loginWithGithub;
  final ReadSavedToken readSavedToken;
  final SessionBloc? sessionBloc; // Add this

  AuthBloc(this.loginWithGithub, this.readSavedToken, this.sessionBloc)
    : super(AuthInital()) {
    on<AuthCodeReceived>(_onAuthCodeReceived);
    on<AuthStarted>(_onAuthStarted);
  }

  Future<void> _onAuthCodeReceived(
    AuthCodeReceived event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = await loginWithGithub(event.code);
      emit(AuthSucess(token));
      // Notify session bloc
      sessionBloc?.add(SessionTokenReceived(token));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final token = await readSavedToken(); // ✅ correct usage
      if (token != null) {
        emit(AuthSucess(token));
        // Notify session bloc
        sessionBloc?.add(SessionTokenReceived(token));
      } else {
        emit(AuthInital());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
