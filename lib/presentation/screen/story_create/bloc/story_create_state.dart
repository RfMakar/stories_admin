part of 'story_create_bloc.dart';

enum StoryCreateStatus { initial, success, failure }

final class StoryCreateState {
  const StoryCreateState({
    this.status = StoryCreateStatus.initial,
    this.title,
    this.description,
    this.content,
    this.image,
    this.storyModel,
    this.isSubmitting = false,
    this.isValidateData = false,
    this.exception,
  });
  final StoryCreateStatus status;
  final String? title;
  final String? description;
  final String? content;
  final File? image;

  final StoryModel? storyModel;
  final bool isSubmitting;
  final bool isValidateData;
  final DioException? exception;

  StoryCreateState copyWith({
    StoryCreateStatus? status,
    String? title,
    String? description,
    String? content,
    File? image,
    StoryModel? storyModel,
    bool? isSubmitting,
    bool? isValidateData,
    DioException? exception,
  }) {
    return StoryCreateState(
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      image: image ?? this.image,
      storyModel: storyModel ?? this.storyModel,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValidateData: isValidateData ?? this.isValidateData,
      exception: exception ?? this.exception,
    );
  }
}
