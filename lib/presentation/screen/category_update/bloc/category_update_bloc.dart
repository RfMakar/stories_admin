import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/models/category_model.dart';
import 'package:stories_data/repositories/category_repository.dart';

part 'category_update_event.dart';
part 'category_update_state.dart';

class CategoryUpdateBloc
    extends Bloc<CategoryUpdateEvent, CategoryUpdateState> {
  CategoryUpdateBloc(this._categoryRepository) : super(CategoryUpdateState()) {
    on<CategoryUpdateInitial>(_initial);
    on<CategoryUpdateName>(_updateName);
    on<CategoryUpdateIcon>(_updateIcon);
    on<CategoryUpdate>(_updateCategory);
  }

  final CategoryRepository _categoryRepository;

  Future<void> _initial(
    CategoryUpdateInitial event,
    Emitter<CategoryUpdateState> emit,
  ) async {
    try {
      final data = await _categoryRepository.getCategory(
        id: event.categoryId,
      );
      emit(state.copyWith(
        status: CategoryUpdateStatus.success,
        categoryModel: data,
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: CategoryUpdateStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _updateName(
    CategoryUpdateName event,
    Emitter<CategoryUpdateState> emit,
  ) async {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _updateIcon(
    CategoryUpdateIcon event,
    Emitter<CategoryUpdateState> emit,
  ) async {
    emit(state.copyWith(icon: event.icon));
  }

  Future<void> _updateCategory(
    CategoryUpdate event,
    Emitter<CategoryUpdateState> emit,
  ) async {
    if (state.icon == null && state.name == null || state.name == '') {
      emit(state.copyWith(isValidateData: true));
      //сброс валидации
      emit(state.copyWith(isValidateData: false));
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      final data = await _categoryRepository.updateCategory(
        id: state.categoryModel!.id,
        name: state.name,
        icon: state.icon,
      );
      emit(state.copyWith(
        status: CategoryUpdateStatus.update,
        updateCategoryModel: data,
      ));
    } on DioException catch (exception) {
      //Чтобы показовалось один раз ошибка
      emit(state.copyWith(
        status: CategoryUpdateStatus.failure,
        isSubmitting: false,
        exception: exception,
      ));
      //Сбрасываем стейт
      emit(state.copyWith(
        status: CategoryUpdateStatus.success,
        exception: null,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
