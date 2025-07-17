import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:stories_data/stories_data.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc(this._categoryRepository) : super(const CategoriesState()) {
    on<CategoriesInitial>(_initial);
    on<CategoriesDelete>(_deleteCategory);
    on<CategoriesDeleteAll>(_deleteAll);
    on<CategoriesAdd>(_addCategory);
    on<CategoriesUpdate>(_updateCategory);
  }

  final CategoryRepository _categoryRepository;

  Future<void> _initial(
    CategoriesInitial event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      final data = await _categoryRepository.getCategories();
      emit(state.copyWith(
        status: CategoriesStatus.success,
        categories: List.of(data),
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: CategoriesStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _deleteCategory(
    CategoriesDelete event,
    Emitter<CategoriesState> emit,
  ) async {
    if (event.categoryId.trim().isEmpty) {
      return;
    }
    try {
      await _categoryRepository.deleteCategory(
        id: event.categoryId,
      );
      final updatedCategories = state.categories
          .where(
            (category) => category.id != event.categoryId,
          )
          .toList();

      emit(state.copyWith(
        status: CategoriesStatus.success,
        categories: updatedCategories,
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: CategoriesStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _deleteAll(
    CategoriesDeleteAll event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      await _categoryRepository.deleteCategories();
      emit(state.copyWith(
        status: CategoriesStatus.success,
        categories: [],
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: CategoriesStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _addCategory(
    CategoriesAdd event,
    Emitter<CategoriesState> emit,
  ) async {
    final updatedCategories = [
      ...state.categories,
      event.categoryModel,
    ];
    emit(
      state.copyWith(categories: updatedCategories),
    );
  }

  Future<void> _updateCategory(
    CategoriesUpdate event,
    Emitter<CategoriesState> emit,
  ) async {
    final updatedCategories = state.categories.map((category) {
      if (category.id == event.categoryModel.id) {
        return event.categoryModel; // заменяем на обновлённую категорию
      }
      return category; // оставляем без изменений
    }).toList();

    emit(
      state.copyWith(
        // status: CategoriesStatus.success,
        categories: updatedCategories,
      ),
    );
  }
}
