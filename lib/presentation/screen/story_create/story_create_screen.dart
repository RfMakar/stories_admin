import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/aplication.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_admin/presentation/screen/stories/bloc/stories_bloc.dart';
import 'package:stories_admin/presentation/screen/story_create/bloc/story_create_bloc.dart';
import 'package:stories_admin/presentation/widgets/app_button.dart';
import 'package:stories_admin/presentation/widgets/app_text_field.dart';
import 'package:stories_admin/presentation/widgets/select_image_storage.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/repositories/story_repository.dart';

class StoryCreateScreen extends StatelessWidget {
  const StoryCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storyRepository = diStoriesData<StoryRepository>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать сказку'),
      ),
      body: BlocProvider(
        create: (context) => StoryCreateBloc(storyRepository),
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
                SnackBar(
                  content: Text('Заполните все данные'),
                ),
              );
            }
          },
          buildWhen: (previous, current) => false,
          builder: (context, state) {
            return StoryCreateScreenBody();
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
    return ListView(
      children: [
        SelectImageStory(),
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
        ButtonStoryCreate(),
      ],
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
                    StoryCreate(),
                  ),
          child: state.isSubmitting
              ? CircularProgressIndicator()
              : Text(
                  'Создать',
                  style: AppTextStyles.s16hFFFFFFn,
                ),
        );
      },
    );
  }
}
