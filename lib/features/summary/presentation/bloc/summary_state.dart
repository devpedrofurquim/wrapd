import 'package:equatable/equatable.dart';
import '../../domain/entities/github_user.dart';

abstract class SummaryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SummaryInitial extends SummaryState {}

class SummaryLoading extends SummaryState {}

class SummaryLoaded extends SummaryState {
  final GitHubUser user;

  SummaryLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class SummaryError extends SummaryState {
  final String message;

  SummaryError(this.message);

  @override
  List<Object> get props => [message];
}