import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/models/category_type_model.dart';
import 'package:stories_data/repositories/category_type_repository.dart';

part 'categories_types_event.dart';
part 'categories_types_state.dart';

class CategoriesTypesBloc
    extends Bloc<CategoriesTypesEvent, CategoriesTypesState> {
  CategoriesTypesBloc(this._categoryTypeRepository)
      : super(const CategoriesTypesState()) {
    on<CategoriesTypesInitial>(_initial);
    on<CategoriesTypesDelete>(_deleteCategoryType);
    on<CategoriesTypesDeleteAll>(_deleteAll);
    on<CategoriesTypesAdd>(_addCategoryType);
    on<CategoriesTypesUpdate>(_updateCategoryType);
  }

  final CategoryTypeRepository _categoryTypeRepository;

  Future<void> _initial(
    CategoriesTypesInitial event,
    Emitter<CategoriesTypesState> emit,
  ) async {
    try {
      final data = await _categoryTypeRepository.getCategoriesTypes();
      emit(state.copyWith(
        status: CategoriesTypesStatus.success,
        categoriesTypes: List.of(data),
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: CategoriesTypesStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _deleteCategoryType(
    CategoriesTypesDelete event,
    Emitter<CategoriesTypesState> emit,
  ) async {
    if (event.typeId.trim().isEmpty) {
      return;
    }
    try {
      await _categoryTypeRepository.deleteCategoryType(
        id: event.typeId,
      );
      final updatedCategoriesTypes = state.categoriesTypes
          .where(
            (categoryType) => categoryType.id != event.typeId,
          )
          .toList();

      emit(state.copyWith(
        status: CategoriesTypesStatus.success,
        categoriesTypes: updatedCategoriesTypes,
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: CategoriesTypesStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _deleteAll(
    CategoriesTypesDeleteAll event,
    Emitter<CategoriesTypesState> emit,
  ) async {
    try {
      await _categoryTypeRepository.deleteCategoriesTypes();
      emit(state.copyWith(
        status: CategoriesTypesStatus.success,
        categoriesTypes: [],
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: CategoriesTypesStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _addCategoryType(
    CategoriesTypesAdd event,
    Emitter<CategoriesTypesState> emit,
  ) async {
    final updatedCategoriesTypes = [
      ...state.categoriesTypes,
      event.categoryTypeModel,
    ];
    emit(
      state.copyWith(categoriesTypes: updatedCategoriesTypes),
    );
  }

  Future<void> _updateCategoryType(
    CategoriesTypesUpdate event,
    Emitter<CategoriesTypesState> emit,
  ) async {
    final updatedCategoriesTypes = state.categoriesTypes.map((categoryType) {
      if (categoryType.id == event.categoryTypeModel.id) {
        return event.categoryTypeModel; // заменяем на обновлённую категорию
      }
      return categoryType; // оставляем без изменений
    }).toList();

    emit(
      state.copyWith(
        // status: CategoriesStatus.success,
        categoriesTypes: updatedCategoriesTypes,
      ),
    );
  }
}
