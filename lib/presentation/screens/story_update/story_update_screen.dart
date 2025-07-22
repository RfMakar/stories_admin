import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/application.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_admin/presentation/screens/stories/bloc/stories_bloc.dart';
import 'package:stories_admin/presentation/screens/story_update/bloc/story_update_bloc.dart';
import 'package:stories_admin/presentation/widgets/app_button.dart';
import 'package:stories_admin/presentation/widgets/app_list_tile.dart';
import 'package:stories_admin/presentation/widgets/app_text_field.dart';
import 'package:stories_admin/presentation/widgets/select_audio_storage.dart';
import 'package:stories_admin/presentation/widgets/select_image_storage.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/models/category_model.dart';
import 'package:stories_data/repositories/category_repository.dart';
import 'package:stories_data/repositories/story_categories_repository.dart';
import 'package:stories_data/repositories/story_repository.dart';

class StoryUpdateScreen extends StatelessWidget {
  const StoryUpdateScreen({super.key, required this.storyId});
  final String storyId;
  @override
  Widget build(BuildContext context) {
    final storyRepository = diStoriesData<StoryRepository>();
    final categoryRepository = diStoriesData<CategoryRepository>();
    final storyCategoriesRepository =
        diStoriesData<StoryCategoriesRepository>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Обновить сказку'),
      ),
      body: BlocProvider(
        create: (context) => StoryUpdateBloc(
          storyRepository,
          categoryRepository,
          storyCategoriesRepository,
        )..add(
            StoryUpdateInitial(
              storyId: storyId,
            ),
          ),
        child: BlocConsumer<StoryUpdateBloc, StoryUpdateState>(
          listener: (context, state) {
            if (state.status == StoryUpdateStatus.update) {
              //Изменения в листе сказок
              context.read<StoriesBloc>().add(StoriesUpdate(
                    storyModel: state.updateStoryModel!,
                  ));
              context.pop();
            }
            if (state.status == StoryUpdateStatus.failure) {
              rootScaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(state.exception?.message ?? ""),
                ),
              );
            }
            if (state.isValidateData) {
              rootScaffoldMessengerKey.currentState?.showSnackBar(
                const SnackBar(
                  content: Text('Нет данных для обновления'),
                ),
              );
            }
          },
          buildWhen: (previous, current) {
            if (current.status == StoryUpdateStatus.update) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            switch (state.status) {
              case StoryUpdateStatus.initial:
              case StoryUpdateStatus.update:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case StoryUpdateStatus.success:
                return const StoryUpdateScreenBody();
              case StoryUpdateStatus.failure:
                return Center(
                  child: Text(
                    state.exception?.message ?? "",
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

class StoryUpdateScreenBody extends StatelessWidget {
  const StoryUpdateScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StoryUpdateBloc>();
    final story = bloc.state.storyModel;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SelectImageStory(),
          const SelectAudioStory(),
          AppTextField(
            initialValue: story?.title,
            name: 'Title',
            hintText: 'Название сказки',
            onChanged: (title) {
              bloc.add(StoryUpdateTitle(
                title: title,
              ));
            },
          ),
          AppTextField(
            initialValue: story?.description,
            name: 'Description',
            hintText: 'Описание сказки',
            maxLines: 5,
            onChanged: (description) {
              bloc.add(StoryUpdateDescription(
                description: description,
              ));
            },
          ),
          AppTextField(
            initialValue: story?.content,
            name: 'Content',
            hintText: 'Содержание сказки',
            maxLines: 10,
            onChanged: (content) {
              bloc.add(StoryUpdateContent(
                content: content,
              ));
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
    final bloc = context.read<StoryUpdateBloc>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SelectImageStorageWidget(
        image: bloc.state.storyModel?.imageUrl,
        onPatchImage: (image) {
          if (image != null) {
            bloc.add(StoryUpdateImage(
              image: image,
            ));
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
     final bloc = context.read<StoryUpdateBloc>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SelectAudioStorageWidget(
        audio: bloc.state.storyModel?.audioUrl,
        onPatchAudio: (audio) {
          if (audio != null) {
            context.read<StoryUpdateBloc>().add(
                  StoryUpdateAudio(
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
          BlocSelector<StoryUpdateBloc, StoryUpdateState, List<CategoryModel>>(
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
    final bloc = context.read<StoryUpdateBloc>();
    return AppListTile(
      title: category.name,
      isValue: bloc.state.selectedCategoriesIds.contains(category.id),
      onChanged: (isSelect) {
        context.read<StoryUpdateBloc>().add(
              StoryUpdateCategoryToggle(
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
    return BlocBuilder<StoryUpdateBloc, StoryUpdateState>(
      builder: (context, state) {
        return AppButton(
          onTap: state.isSubmitting
              ? null
              : () => context.read<StoryUpdateBloc>().add(
                    const StoryUpdate(),
                  ),
          child: state.isSubmitting
              ? const CircularProgressIndicator()
              : Text(
                  'Обновить',
                  style: AppTextStyles.s16hFFFFFFn,
                ),
        );
      },
    );
  }
}
