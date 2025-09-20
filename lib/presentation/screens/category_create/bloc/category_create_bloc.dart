import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/models/category_model.dart';
import 'package:stories_data/repositories/category_repository.dart';

part 'category_create_event.dart';
part 'category_create_state.dart';

class CategoryCreateBloc
    extends Bloc<CategoryCreateEvent, CategoryCreateState> {
  CategoryCreateBloc(this._categoryRepository) : super(const CategoryCreateState()) {
    on<CategoryCreateName>(_createName);
    on<CategoryCreateIcon>(_createIcon);
    on<CategoryCreate>(_createCategory);
  }
  final CategoryRepository _categoryRepository;

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

  Future<void> _createCategory(
    CategoryCreate event,
    Emitter<CategoryCreateState> emit,
  ) async {
    if (state.icon == null || state.name == null || state.name == '') {
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
        typeId: '',
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
