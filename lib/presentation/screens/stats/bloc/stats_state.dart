part of 'stats_bloc.dart';

enum StatsStatus { initial, success, failure }

final class StatsState extends Equatable {
  const StatsState({
    this.status = StatsStatus.initial,
    this.readsStats,
    this.exception,
  });
  final StatsStatus status;
  final ReadsStatsModel? readsStats;
  final DioException? exception;

  StatsState copyWith({
    StatsStatus? status,
    ReadsStatsModel? readsStats,
    DioException? exception,
  }) {
    return StatsState(
      status: status ?? this.status,
      readsStats: readsStats ?? this.readsStats,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, readsStats, exception];
}
