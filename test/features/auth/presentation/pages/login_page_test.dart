// Standard Flutter UI library
import 'package:flutter/material.dart';

// Flutter's testing framework
import 'package:flutter_test/flutter_test.dart';

// Bloc dependency to inject the AuthBloc into the widget tree
import 'package:flutter_bloc/flutter_bloc.dart';

// Mocktail lets us fake/mock classes for unit and widget tests
import 'package:mocktail/mocktail.dart';

// Your actual AuthBloc, event, and state classes
import 'package:wrapd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wrapd/features/auth/presentation/bloc/auth_event.dart';
import 'package:wrapd/features/auth/presentation/bloc/auth_state.dart';

// The LoginPage you want to test
import 'package:wrapd/features/auth/presentation/pages/login_page.dart';

/// Step 1: Create a mocked version of AuthBloc.
/// This will simulate the real bloc during the test.
class MockAuthBloc extends Mock implements AuthBloc {}

/// Step 2: Create fake versions of AuthState and AuthEvent.
/// mocktail requires these fallback values to safely handle type checks.
class FakeAuthState extends Fake implements AuthState {}

class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  // Declare the mocked bloc instance
  late MockAuthBloc mockAuthBloc;

  // Runs once before all tests
  setUpAll(() {
    // Register fake types so mocktail can use them internally
    registerFallbackValue(FakeAuthState());
    registerFallbackValue(FakeAuthEvent());
  });

  // Runs before every individual test
  setUp(() {
    // Create a new instance of the mocked bloc
    mockAuthBloc = MockAuthBloc();
  });

  /// Test #1: Show loading spinner when the bloc emits AuthLoading
  testWidgets('shows loading when AuthLoading is emitted', (tester) async {
    // Arrange
    when(() => mockAuthBloc.state).thenReturn(AuthLoading());

    // 👇 This is the critical fix — mock the stream too!
    when(
      () => mockAuthBloc.stream,
    ).thenAnswer((_) => Stream.value(AuthLoading()));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  /// Test #2
  testWidgets('shows error message on AuthFailure', (tester) async {
    when(() => mockAuthBloc.state).thenReturn(AuthFailure('invalid code'));
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      ),
    );

    expect(find.textContaining('Login failed: invalid code'), findsOneWidget);
  });

  /// Test #3
  testWidgets('shows login button when not loading', (tester) async {
    when(() => mockAuthBloc.state).thenReturn(AuthInital());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      ),
    );

    expect(find.text('Continue with GitHub'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
