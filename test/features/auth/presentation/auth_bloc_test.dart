import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// These are your real use case classes
import 'package:wrapd/features/auth/domain/usecases/login_w_github.dart';
import 'package:wrapd/features/auth/domain/usecases/read_saved_token.dart';

// Your real AuthBloc and related event/state classes
import 'package:wrapd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wrapd/features/auth/presentation/bloc/auth_event.dart';
import 'package:wrapd/features/auth/presentation/bloc/auth_state.dart';

/// Mocks for the use cases:
/// These classes override the real ones during tests, so we can control the behavior
class MockLoginWithGithub extends Mock implements LoginWithGithub {}
class MockReadSavedToken extends Mock implements ReadSavedToken {}

void main() {
  // Declare the mocks
  late MockLoginWithGithub loginWithGithub;
  late MockReadSavedToken readSavedToken;

  // Before each test, create new mock instances
  setUp(() {
    loginWithGithub = MockLoginWithGithub();
    readSavedToken = MockReadSavedToken();
  });

  // Group of tests for AuthBloc
  group('AuthBloc', () {
    
    /// Test case 1:
    /// When AuthCodeReceived is added, and login succeeds,
    /// we expect: [AuthLoading, AuthSucess]
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSucess] when AuthCodeReceived succeeds',
      
      // build the bloc with mocked dependencies
      build: () {
        // Set up the fake behavior: when called with 'code123', return 'fake_token'
        when(() => loginWithGithub.call('code123')).thenAnswer((_) async => 'fake_token');
        return AuthBloc(loginWithGithub, readSavedToken);
      },

      // Trigger the event
      act: (bloc) => bloc.add(AuthCodeReceived('code123')),

      // Expect the following states to be emitted in order
      expect: () => [
        AuthLoading(),
        AuthSucess('fake_token'),
      ],
    );

    /// Test case 2:
    /// When login fails (exception), we expect [AuthLoading, AuthFailure]
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when AuthCodeReceived throws',
      build: () {
        // Simulate a login failure
        when(() => loginWithGithub.call('invalid')).thenThrow(Exception('login failed'));
        return AuthBloc(loginWithGithub, readSavedToken);
      },
      act: (bloc) => bloc.add(AuthCodeReceived('invalid')),
      expect: () => [
        AuthLoading(),
        // Check that an AuthFailure was emitted and contains the expected error message
        isA<AuthFailure>().having((f) => f.message, 'message', contains('login failed')),
      ],
    );

    /// Test case 3:
    /// When AuthStarted is added and saved token exists, expect [AuthLoading, AuthSucess]
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSucess] when AuthStarted finds saved token',
      build: () {
        when(() => readSavedToken.call()).thenAnswer((_) async => 'saved_token');
        return AuthBloc(loginWithGithub, readSavedToken);
      },
      act: (bloc) => bloc.add(AuthStarted()),
      expect: () => [
        AuthLoading(),
        AuthSucess('saved_token'),
      ],
    );

    /// Test case 4:
    /// When AuthStarted finds no token, expect [AuthLoading, AuthInital]
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthInital] when AuthStarted finds no token',
      build: () {
        when(() => readSavedToken.call()).thenAnswer((_) async => null);
        return AuthBloc(loginWithGithub, readSavedToken);
      },
      act: (bloc) => bloc.add(AuthStarted()),
      expect: () => [
        AuthLoading(),
        AuthInital(),
      ],
    );

    /// Test case 5:
    /// When AuthStarted throws an exception, expect [AuthLoading, AuthFailure]
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when AuthStarted throws',
      build: () {
        when(() => readSavedToken.call()).thenThrow(Exception('storage error'));
        return AuthBloc(loginWithGithub, readSavedToken);
      },
      act: (bloc) => bloc.add(AuthStarted()),
      expect: () => [
        AuthLoading(),
        isA<AuthFailure>().having((f) => f.message, 'message', contains('storage error')),
      ],
    );
  });
}
