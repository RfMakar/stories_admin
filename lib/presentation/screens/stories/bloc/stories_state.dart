part of 'stories_bloc.dart';


enum StoriesStatus { initial, success, failure }

final class StoriesState extends Equatable{
  const StoriesState({
    this.status = StoriesStatus.initial,
    this.stories = const [],
    this.exception,
  });
  final StoriesStatus status;
  final List<StoryModel> stories;
  final DioException? exception;

  StoriesState copyWith({
    StoriesStatus? status,
    List<StoryModel>? stories,
    DioException? exception,
  }) {
    return StoriesState(
      status: status ?? this.status,
      stories: stories ?? this.stories,
      exception: exception ?? this.exception,
    );
  }
  
  @override
  List<Object?> get props => [status, stories, exception];
}