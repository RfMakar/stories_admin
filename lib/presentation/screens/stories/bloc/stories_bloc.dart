import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/models/index.dart';
import 'package:stories_data/repositories/story_repository.dart';

part 'stories_event.dart';
part 'stories_state.dart';

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  StoriesBloc(this._storyRepository) : super(const StoriesState()) {
    on<StoriesInitial>(_initial);
    on<StoriesDelete>(_deleteStory);
    on<StoriesDeleteAll>(_deleteAll);
    on<StoriesAdd>(_addStory);
    on<StoriesUpdate>(_updateStory);
  }

  final StoryRepository _storyRepository;

  Future<void> _initial(
    StoriesInitial event,
    Emitter<StoriesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: StoriesStatus.initial));
      final data = await _storyRepository.getStories();
      emit(state.copyWith(
        status: StoriesStatus.success,
        stories: List.of(data),
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: StoriesStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _deleteStory(
    StoriesDelete event,
    Emitter<StoriesState> emit,
  ) async {
    if (event.storyId.trim().isEmpty) {
      return;
    }
    try {
      await _storyRepository.deleteStory(
        id: event.storyId,
      );
      final updatedStories = state.stories
          .where(
            (story) => story.id != event.storyId,
          )
          .toList();

      emit(state.copyWith(
        status: StoriesStatus.success,
        stories: updatedStories,
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: StoriesStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _deleteAll(
    StoriesDeleteAll event,
    Emitter<StoriesState> emit,
  ) async {
    try {
      await _storyRepository.deleteStories();
      emit(state.copyWith(
        status: StoriesStatus.success,
        stories: [],
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: StoriesStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _addStory(
    StoriesAdd event,
    Emitter<StoriesState> emit,
  ) async {
    final updatedStories = [
      ...state.stories,
      event.storyModel,
    ];
    emit(
      state.copyWith(stories: updatedStories),
    );
  }

  Future<void> _updateStory(
    StoriesUpdate event,
    Emitter<StoriesState> emit,
  ) async {
    final updatedStories = state.stories.map((story) {
      if (story.id == event.storyModel.id) {
        return event.storyModel; // заменяем на обновлённую категорию
      }
      return story; // оставляем без изменений
    }).toList();

    emit(
      state.copyWith(
        stories: updatedStories,
      ),
    );
  }
}
