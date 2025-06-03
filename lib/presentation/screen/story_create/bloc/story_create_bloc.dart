import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/models/index.dart';
import 'package:stories_data/models/story_model.dart';
import 'package:stories_data/repositories/index.dart';

part 'story_create_event.dart';
part 'story_create_state.dart';

class StoryCreateBloc extends Bloc<StoryCreateEvent, StoryCreateState> {
  StoryCreateBloc(
    this._storyRepository,
    this._categoryRepository,
    this._storyCategoriesRepository,
  ) : super(StoryCreateState()) {
    on<StoryCreateInitial>(_initial);
    on<StoryCreateImage>(_createImage);
    on<StoryCreateTitle>(_createTitle);
    on<StoryCreateDescription>(_createDescription);
    on<StoryCreateContent>(_createContent);
    on<StoryCreateAddCategory>(_addCategory);
    on<StoryCreateRemoveCategory>(_removeCategory);
    on<StoryCreate>(_createStory);
  }
  final StoryRepository _storyRepository;
  final CategoryRepository _categoryRepository;
  final StoryCategoriesRepository _storyCategoriesRepository;

  Future<void> _initial(
    StoryCreateInitial event,
    Emitter<StoryCreateState> emit,
  ) async {
    try {
      final data = await _categoryRepository.getCategories();
      emit(state.copyWith(
        categories: List.of(data),
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: StoryCreateStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _createImage(
    StoryCreateImage event,
    Emitter<StoryCreateState> emit,
  ) async {
    emit(state.copyWith(image: event.image));
  }

  Future<void> _createTitle(
    StoryCreateTitle event,
    Emitter<StoryCreateState> emit,
  ) async {
    if (event.title.trim() == '') {
      emit(state.copyWith(title: null));
    } else {
      emit(state.copyWith(title: event.title));
    }
  }

  Future<void> _createDescription(
    StoryCreateDescription event,
    Emitter<StoryCreateState> emit,
  ) async {
    if (event.description.trim() == '') {
      emit(state.copyWith(description: null));
    } else {
      emit(state.copyWith(description: event.description));
    }
  }

  Future<void> _createContent(
    StoryCreateContent event,
    Emitter<StoryCreateState> emit,
  ) async {
    if (event.content.trim() == '') {
      emit(state.copyWith(content: null));
    } else {
      emit(state.copyWith(content: event.content));
    }
  }

  Future<void> _addCategory(
    StoryCreateAddCategory event,
    Emitter<StoryCreateState> emit,
  ) async {
    final updatedSelectCategories = [
      ...state.selectCategoriesId,
      event.categoryId,
    ];
    emit(state.copyWith(
      selectCategoriesId: updatedSelectCategories,
    ));
  }

  Future<void> _removeCategory(
    StoryCreateRemoveCategory event,
    Emitter<StoryCreateState> emit,
  ) async {
    final updatedSelectCategories = state.selectCategoriesId
        .where(
          (categoryId) => categoryId != event.categoryId,
        )
        .toList();
    emit(state.copyWith(
      selectCategoriesId: updatedSelectCategories,
    ));
  }

  Future<void> _createStory(
    StoryCreate event,
    Emitter<StoryCreateState> emit,
  ) async {
    final isFalidate = state.image == null ||
        state.title == null ||
        state.description == null ||
        state.content == null ||
        state.selectCategoriesId.isEmpty;

    if (isFalidate) {
      emit(state.copyWith(isValidateData: true));
      //сброс валидации
      emit(state.copyWith(isValidateData: false));
      return;
    }
    emit(state.copyWith(isSubmitting: true));

    try {
      //создает сказку без категорий
      final data = await _storyRepository.createStory(
        title: state.title!,
        description: state.description!,
        content: state.content!,
        image: state.image!,
      );
      //создаем категории у сказки
      for (var categoryId in state.selectCategoriesId) {
        await _storyCategoriesRepository.createCategoryToStory(
          storyId: data.id,
          categoryId: categoryId,
        );
      }
      //загружает сказку с категориями
      final story = await _storyRepository.getStory(
        id: data.id,
      );
      emit(state.copyWith(
        status: StoryCreateStatus.success,
        storyModel: story,
      ));
    } on DioException catch (exception) {
      //Чтобы показовалось один раз ошибка
      emit(state.copyWith(
        status: StoryCreateStatus.failure,
        isSubmitting: false,
        exception: exception,
      ));
      //Сбрасываем стейт
      emit(state.copyWith(
        status: StoryCreateStatus.initial,
        exception: null,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
