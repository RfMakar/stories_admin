import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/models/story_model.dart';
import 'package:stories_data/repositories/story_repository.dart';

part 'story_update_event.dart';
part 'story_update_state.dart';

class StoryUpdateBloc extends Bloc<StoryUpdateEvent, StoryUpdateState> {
  StoryUpdateBloc(this._storyRepository) : super(StoryUpdateState()) {
    on<StoryUpdateInitial>(_initial);
    on<StoryUpdateTitle>(_updateTitle);
    on<StoryUpdateDescription>(_updateDescription);
    on<StoryUpdateContent>(_updateContent);
    on<StoryUpdateImage>(_updateImage);
    on<StoryUpdate>(_update);
  }

  final StoryRepository _storyRepository;

  Future<void> _initial(
    StoryUpdateInitial event,
    Emitter<StoryUpdateState> emit,
  ) async {
    try {
      final data = await _storyRepository.getStory(
        id: event.storyId,
      );
      emit(state.copyWith(
        status: StoryUpdateStatus.success,
        storyModel: data,
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

  Future<void> _update(
    StoryUpdate event,
    Emitter<StoryUpdateState> emit,
  ) async {
    if (state.image == null &&
        state.title == null &&
        state.description == null &&
        state.content == null) {
      emit(state.copyWith(isValidateData: true));
      //сброс валидации
      emit(state.copyWith(isValidateData: false));
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      final data = await _storyRepository.updateStory(
        id: state.storyModel!.id,
        title: state.title,
        description: state.description,
        content: state.content,
        image: state.image,
      );
      emit(state.copyWith(
        status: StoryUpdateStatus.update,
        updateStoryModel: data,
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
