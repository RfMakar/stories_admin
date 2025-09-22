part of 'story_update_bloc.dart';

enum StoryUpdateStatus { initial, success, update, failure }

final class StoryUpdateState {
  const StoryUpdateState({
    this.status = StoryUpdateStatus.initial,
    this.title,
    this.description,
    this.content,
    this.image,
    this.audio,
    this.storyModel,
    this.updateStoryModel,
    this.categoriesTypesModel = const [],
    this.selectedCategoriesIds = const {},
    this.isSubmitting = false,
    this.isValidateData = false,
    this.exception,
  });
  final StoryUpdateStatus status;
  final String? title;
  final String? description;
  final String? content;
  final File? image;
  final File? audio;
  final StoryModel? storyModel; //текущая сказка
  final StoryModel? updateStoryModel; //обновленная сказка
  final List<CategoryTypeModel> categoriesTypesModel; //все категории
  final Set<String> selectedCategoriesIds; //выбранные категории
  final bool isSubmitting;
  final bool isValidateData;
  final DioException? exception;

  StoryUpdateState copyWith({
    StoryUpdateStatus? status,
    String? title,
    String? description,
    String? content,
    File? image,
    File? audio,
    StoryModel? storyModel,
    StoryModel? updateStoryModel,
    List<CategoryTypeModel>? categoriesTypesModel,
    Set<String>? selectedCategoriesIds,
    bool? isSubmitting,
    bool? isValidateData,
    DioException? exception,
  }) {
    return StoryUpdateState(
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      image: image ?? this.image,
      audio: audio ?? this.audio,
      storyModel: storyModel ?? this.storyModel,
      categoriesTypesModel: categoriesTypesModel ?? this.categoriesTypesModel,
      updateStoryModel: updateStoryModel ?? this.updateStoryModel,
      selectedCategoriesIds:
          selectedCategoriesIds ?? this.selectedCategoriesIds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValidateData: isValidateData ?? this.isValidateData,
      exception: exception ?? this.exception,
    );
  }
}
