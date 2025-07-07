import 'package:equatable/equatable.dart';

abstract class SummaryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserData extends SummaryEvent {
  final String token;

  LoadUserData(this.token);

  @override
  List<Object> get props => [token];
}