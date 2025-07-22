import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/application.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_admin/presentation/screens/stories/bloc/stories_bloc.dart';
import 'package:stories_admin/presentation/screens/story_create/bloc/story_create_bloc.dart';
import 'package:stories_admin/presentation/widgets/app_button.dart';
import 'package:stories_admin/presentation/widgets/app_list_tile.dart';
import 'package:stories_admin/presentation/widgets/app_text_field.dart';
import 'package:stories_admin/presentation/widgets/select_audio_storage.dart';
import 'package:stories_admin/presentation/widgets/select_image_storage.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/models/index.dart';
import 'package:stories_data/repositories/category_repository.dart';
import 'package:stories_data/repositories/story_categories_repository.dart';
import 'package:stories_data/repositories/story_repository.dart';

class StoryCreateScreen extends StatelessWidget {
  const StoryCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storyRepository = diStoriesData<StoryRepository>();
    final categoryRepository = diStoriesData<CategoryRepository>();
    final storyCategoriesRepository =
        diStoriesData<StoryCategoriesRepository>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать сказку'),
      ),
      body: BlocProvider(
        create: (context) => StoryCreateBloc(
          storyRepository,
          categoryRepository,
          storyCategoriesRepository,
        )..add(const StoryCreateInitial()),
        child: BlocConsumer<StoryCreateBloc, StoryCreateState>(
          listener: (context, state) {
            if (state.status == StoryCreateStatus.success) {
              //Добавление в лист сказок
              context.read<StoriesBloc>().add(StoriesAdd(
                    storyModel: state.storyModel!,
                  ));
              context.pop();
            }
            if (state.status == StoryCreateStatus.failure) {
              rootScaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(state.exception?.message ?? ""),
                ),
              );
            }
            if (state.isValidateData) {
              rootScaffoldMessengerKey.currentState?.showSnackBar(
                const SnackBar(
                  content: Text('Заполните все данные'),
                ),
              );
            }
          },
          buildWhen: (previous, current) => false,
          builder: (context, state) {
            return const StoryCreateScreenBody();
          },
        ),
      ),
    );
  }
}

class StoryCreateScreenBody extends StatelessWidget {
  const StoryCreateScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SelectImageStory(),
          const SelectAudioStory(),
          AppTextField(
            name: 'Title',
            hintText: 'Название сказки',
            onChanged: (title) {
              context.read<StoryCreateBloc>().add(
                    StoryCreateTitle(
                      title: title,
                    ),
                  );
            },
          ),
          AppTextField(
            name: 'Description',
            hintText: 'Описание сказки',
            maxLines: 5,
            onChanged: (description) {
              context.read<StoryCreateBloc>().add(
                    StoryCreateDescription(
                      description: description,
                    ),
                  );
            },
          ),
          AppTextField(
            name: 'Content',
            hintText: 'Содержание сказки',
            maxLines: 10,
            onChanged: (content) {
              context.read<StoryCreateBloc>().add(
                    StoryCreateContent(
                      content: content,
                    ),
                  );
            },
          ),
          const CategoriesList(),
          const ButtonStoryCreate(),
        ],
      ),
    );
  }
}

class SelectImageStory extends StatelessWidget {
  const SelectImageStory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SelectImageStorageWidget(
        image: null,
        onPatchImage: (image) {
          if (image != null) {
            context.read<StoryCreateBloc>().add(
                  StoryCreateImage(
                    image: image,
                  ),
                );
          }
        },
      ),
    );
  }
}

class SelectAudioStory extends StatelessWidget {
  const SelectAudioStory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SelectAudioStorageWidget(
        audio: null,
        onPatchAudio: (audio) {
          if (audio != null) {
            context.read<StoryCreateBloc>().add(
                  StoryCreateAudio(
                    audio: audio,
                  ),
                );
          }
        },
      ),
    );
  }
}

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Categories'),
          BlocSelector<StoryCreateBloc, StoryCreateState, List<CategoryModel>>(
            selector: (state) {
              return state.categories;
            },
            builder: (context, categories) {
              if (categories.isEmpty) {
                return const Center(
                  child: Text('Категорий нет'),
                );
              }
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategorySelectToStory(
                    category: category,
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}

class CategorySelectToStory extends StatelessWidget {
  const CategorySelectToStory({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return AppListTile(
      title: category.name,
      isValue: false,
      onChanged: (isSelect) {
        context.read<StoryCreateBloc>().add(
              StoryCreateCategoryToggle(
                categoryId: category.id,
              ),
            );
      },
    );
  }
}

class ButtonStoryCreate extends StatelessWidget {
  const ButtonStoryCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCreateBloc, StoryCreateState>(
      builder: (context, state) {
        return AppButton(
          onTap: state.isSubmitting
              ? null
              : () => context.read<StoryCreateBloc>().add(
                    const StoryCreate(),
                  ),
          child: state.isSubmitting
              ? const CircularProgressIndicator()
              : Text(
                  'Создать',
                  style: AppTextStyles.s16hFFFFFFn,
                ),
        );
      },
    );
  }
}
