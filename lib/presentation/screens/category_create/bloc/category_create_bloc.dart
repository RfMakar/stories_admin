import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/models/category_type_model.dart';
import 'package:stories_data/stories_data.dart';

part 'category_create_event.dart';
part 'category_create_state.dart';

class CategoryCreateBloc
    extends Bloc<CategoryCreateEvent, CategoryCreateState> {
  CategoryCreateBloc(this._categoryRepository, this._categoryTypeRepository)
      : super(const CategoryCreateState()) {
    on<CategoryCreateInitial>(_initial);
    on<CategoryCreateName>(_createName);
    on<CategoryCreateIcon>(_createIcon);
    on<CategoryCreateSelectedType>(_selectedCategoryType);
    on<CategoryCreate>(_createCategory);
  }
  final CategoryRepository _categoryRepository;
  final CategoryTypeRepository _categoryTypeRepository;

  Future<void> _initial(
    CategoryCreateInitial event,
    Emitter<CategoryCreateState> emit,
  ) async {
    try {
      final data = await _categoryTypeRepository.getCategoriesTypes();
      emit(state.copyWith(
        categoriesTypesModel: List.of(data),
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: CategoryCreateStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _createName(
    CategoryCreateName event,
    Emitter<CategoryCreateState> emit,
  ) async {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _createIcon(
    CategoryCreateIcon event,
    Emitter<CategoryCreateState> emit,
  ) async {
    emit(state.copyWith(icon: event.icon));
  }

  Future<void> _selectedCategoryType(
    CategoryCreateSelectedType event,
    Emitter<CategoryCreateState> emit,
  ) async {
    emit(state.copyWith(categoryTypeSelected: event.typeId));
  }

  Future<void> _createCategory(
    CategoryCreate event,
    Emitter<CategoryCreateState> emit,
  ) async {
    final isValidate = state.icon == null ||
        state.name == null ||
        state.name == '' ||
        state.categoryTypeSelected == null;
    if (isValidate) {
      emit(state.copyWith(isValidateData: true));
      //сброс валидации
      emit(state.copyWith(isValidateData: false));
      return;
    }
    emit(state.copyWith(isSubmitting: true));
    try {
      final data = await _categoryRepository.createCategory(
        name: state.name!,
        icon: state.icon!,
        typeId: state.categoryTypeSelected!,
      );
      emit(state.copyWith(
        status: CategoryCreateStatus.success,
        categoryModel: data,
      ));
    } on DioException catch (exception) {
      //Чтобы показовалось один раз ошибка
      emit(state.copyWith(
        status: CategoryCreateStatus.failure,
        isSubmitting: false,
        exception: exception,
      ));
      //Сбрасываем стейт
      emit(state.copyWith(
        status: CategoryCreateStatus.initial,
        exception: null,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
