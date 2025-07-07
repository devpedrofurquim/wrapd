import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user.dart';
import 'summary_event.dart';
import 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final GetCurrentUser getCurrentUser;

  SummaryBloc(this.getCurrentUser) : super(SummaryInitial()) {
    on<LoadUserData>(_onLoadUserData);
  }

  Future<void> _onLoadUserData(
    LoadUserData event,
    Emitter<SummaryState> emit,
  ) async {
    print('🔄 SummaryBloc: Starting to load user data...');
    emit(SummaryLoading());
    try {
      print('🔑 SummaryBloc: Using token: ${event.token.substring(0, 10)}...');
      final user = await getCurrentUser(event.token);
      print('✅ SummaryBloc: User loaded successfully: ${user.login}');
      emit(SummaryLoaded(user));
    } catch (e, stackTrace) {
      print('❌ SummaryBloc: Error loading user data: $e');
      print('📍 Stack trace: $stackTrace');
      emit(SummaryError(e.toString()));
    }
  }
}
