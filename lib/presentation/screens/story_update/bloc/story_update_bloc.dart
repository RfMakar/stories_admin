import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/models/category_model.dart';
import 'package:stories_data/models/story_model.dart';
import 'package:stories_data/repositories/category_repository.dart';
import 'package:stories_data/repositories/story_categories_repository.dart';
import 'package:stories_data/repositories/story_repository.dart';

part 'story_update_event.dart';
part 'story_update_state.dart';

class StoryUpdateBloc extends Bloc<StoryUpdateEvent, StoryUpdateState> {
  StoryUpdateBloc(
    this._storyRepository,
    this._categoryRepository,
    this._storyCategoriesRepository,
  ) : super(const StoryUpdateState()) {
    on<StoryUpdateInitial>(_initial);
    on<StoryUpdateTitle>(_updateTitle);
    on<StoryUpdateDescription>(_updateDescription);
    on<StoryUpdateContent>(_updateContent);
    on<StoryUpdateImage>(_updateImage);
    on<StoryUpdateAudio>(_updateAudio);
    on<StoryUpdateCategoryToggle>(_updateCategoryToggle);
    on<StoryUpdate>(_update);
  }

  final StoryRepository _storyRepository;
  final CategoryRepository _categoryRepository;
  final StoryCategoriesRepository _storyCategoriesRepository;

  Future<void> _initial(
    StoryUpdateInitial event,
    Emitter<StoryUpdateState> emit,
  ) async {
    try {
      //загрузка сказки
      final storyData = await _storyRepository.getStory(
        id: event.storyId,
      );
      //Загрузка всех категорий
      final categoriesData = await _categoryRepository.getCategories();
      //Выбранные категории сказки to set
      final selectedCategoriesIds = storyData.categories
          .map(
            (c) => c.id,
          )
          .toSet();
      //Обновление данных
      emit(state.copyWith(
        status: StoryUpdateStatus.success,
        storyModel: storyData,
        categories: categoriesData,
        selectedCategoriesIds: selectedCategoriesIds,
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: StoryUpdateStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _updateTitle(
    StoryUpdateTitle event,
    Emitter<StoryUpdateState> emit,
  ) async {
    if (event.title.trim() == '') {
      emit(state.copyWith(title: null));
    } else {
      emit(state.copyWith(title: event.title));
    }
  }

  Future<void> _updateDescription(
    StoryUpdateDescription event,
    Emitter<StoryUpdateState> emit,
  ) async {
    if (event.description.trim() == '') {
      emit(state.copyWith(description: null));
    } else {
      emit(state.copyWith(description: event.description));
    }
  }

  Future<void> _updateContent(
    StoryUpdateContent event,
    Emitter<StoryUpdateState> emit,
  ) async {
    if (event.content.trim() == '') {
      emit(state.copyWith(content: null));
    } else {
      emit(state.copyWith(content: event.content));
    }
  }

  Future<void> _updateImage(
    StoryUpdateImage event,
    Emitter<StoryUpdateState> emit,
  ) async {
    emit(state.copyWith(image: event.image));
  }

  Future<void> _updateAudio(
    StoryUpdateAudio event,
    Emitter<StoryUpdateState> emit,
  ) async {
    emit(state.copyWith(audio: event.audio));
  }

  Future<void> _updateCategoryToggle(
    StoryUpdateCategoryToggle event,
    Emitter<StoryUpdateState> emit,
  ) async {
    final updateSelectedCategoriesIds = Set<String>.from(
      state.selectedCategoriesIds,
    );

    if (updateSelectedCategoriesIds.contains(event.categoryId)) {
      updateSelectedCategoriesIds.remove(event.categoryId);
    } else {
      updateSelectedCategoriesIds.add(event.categoryId);
    }

    emit(state.copyWith(
      selectedCategoriesIds: updateSelectedCategoriesIds,
    ));
  }

  Future<void> _update(
    StoryUpdate event,
    Emitter<StoryUpdateState> emit,
  ) async {
    //Текущие категории сказки
    final categoriesIds = state.storyModel?.categories
            .map(
              (c) => c.id,
            )
            .toSet() ??
        {};
    //Для добавления
    final toAdd = state.selectedCategoriesIds.difference(categoriesIds);
    //Для удаления
    final toRemove = categoriesIds.difference(state.selectedCategoriesIds);
    //Валидация
    final isValidate = state.image == null &&
        state.audio == null &&
        state.title == null &&
        state.description == null &&
        state.content == null &&
        toAdd.isEmpty &&
        toRemove.isEmpty;

    if (isValidate) {
      emit(state.copyWith(isValidateData: true));
      //сброс валидации
      emit(state.copyWith(isValidateData: false));
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      //Обновление сказки без категорий
      if (state.image != null ||
          state.title != null ||
          state.description != null ||
          state.content != null) {
        await _storyRepository.updateStory(
          id: state.storyModel!.id,
          title: state.title,
          description: state.description,
          content: state.content,
          image: state.image,
          audio: state.audio,
        );
      }

      //Добавление категорий
      for (var categoryId in toAdd) {
        await _storyCategoriesRepository.createCategoryToStory(
          storyId: state.storyModel!.id,
          categoryId: categoryId,
        );
      }
      //Удаление категорий
      for (var categoryId in toRemove) {
        await _storyCategoriesRepository.deleteCategoryToStory(
          storyId: state.storyModel!.id,
          categoryId: categoryId,
        );
      }
      //Загрузка новой сказки со всеми категориями
      final story = await _storyRepository.getStory(
        id: state.storyModel!.id,
      );
      //Обновление состояния
      emit(state.copyWith(
        status: StoryUpdateStatus.update,
        updateStoryModel: story,
      ));
    } on DioException catch (exception) {
      //Чтобы показовалось один раз ошибка
      emit(state.copyWith(
        status: StoryUpdateStatus.failure,
        isSubmitting: false,
        exception: exception,
      ));
      //Сбрасываем стейт
      emit(state.copyWith(
        status: StoryUpdateStatus.success,
        exception: null,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
