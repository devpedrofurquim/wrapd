import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wrapd/features/auth/domain/usecases/read_saved_token.dart';
import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final ReadSavedToken readSavedToken;

  SessionBloc(this.readSavedToken) : super(SessionInitial()) {
    on<SessionStarted>(_onSessionStarted);
    on<SessionTokenReceived>(_onSessionTokenReceived);
    on<SessionUserInfoUpdated>(_onSessionUserInfoUpdated);
    on<SessionEnded>(_onSessionEnded);
  }

  Future<void> _onSessionStarted(
    SessionStarted event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    try {
      final token = await readSavedToken();
      if (token != null && token.isNotEmpty) {  // Add empty check
        emit(SessionAuthenticated(token: token));
      } else {
        emit(SessionUnauthenticated());
      }
    } catch (e) {
      print('❌ SessionBloc error: $e');  // Add logging
      emit(SessionUnauthenticated());
    }
  }

  void _onSessionTokenReceived(
    SessionTokenReceived event,
    Emitter<SessionState> emit,
  ) {
    emit(SessionAuthenticated(token: event.token));
  }

  void _onSessionUserInfoUpdated(
    SessionUserInfoUpdated event,
    Emitter<SessionState> emit,
  ) {
    if (state is SessionAuthenticated) {
      final currentState = state as SessionAuthenticated;
      emit(currentState.copyWith(
        userId: event.userId,
        username: event.username,
        avatarUrl: event.avatarUrl,
      ));
    }
  }

  void _onSessionEnded(
    SessionEnded event,
    Emitter<SessionState> emit,
  ) {
    emit(SessionUnauthenticated());
  }
}