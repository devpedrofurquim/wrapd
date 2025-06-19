// Equatable makes value comparison easy and clean.
// It helps Bloc to know when events have changed
import 'package:equatable/equatable.dart';


// Base class for all auth events.
// Every event extends from this class
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  // This is required by Equatable, it tells
  // which fields should be used
  // to compare if two instances are equal
  @override
  List<Object?> get props => [];
}

// Later it can be used to trigger initial checks (check if token is stored)
// Made to load persisted auth state
class AuthStarted extends AuthEvent {}

// Main event I will use when Github OAuth process send back
// a code. This code is dispatched when the user is redirected back to the app
// it comes as ?code on the url link
class AuthCodeReceived extends AuthEvent {
  final String code;

  // Constructor to set the code from the OAuth Callback
  const AuthCodeReceived(this.code);

  // Tells Equatable to compare events based on the code field
  // So if code changes, state changes too.
  @override
  List<Object?> get props => [code];
}