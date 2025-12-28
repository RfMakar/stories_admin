import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/stories_data.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc(this._statsRepository) : super(const StatsState()) {
    on<StatsInitial>(_initial);
  }

  final StatsRepository _statsRepository;

  Future<void> _initial(
    StatsInitial event,
    Emitter<StatsState> emit,
  ) async {
    try {
      final data = await _statsRepository.getReadsStats();
      emit(state.copyWith(
        readsStats: data,
        status: StatsStatus.success,
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        exception: exception,
        status: StatsStatus.failure,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
