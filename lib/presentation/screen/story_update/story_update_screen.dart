import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/aplication.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_admin/presentation/screen/stories/bloc/stories_bloc.dart';
import 'package:stories_admin/presentation/screen/story_update/bloc/story_update_bloc.dart';
import 'package:stories_admin/presentation/widgets/app_button.dart';
import 'package:stories_admin/presentation/widgets/app_text_field.dart';
import 'package:stories_admin/presentation/widgets/select_image_storage.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/repositories/story_repository.dart';

class StoryUpdateScreen extends StatelessWidget {
  const StoryUpdateScreen({super.key, required this.storyId});
  final String storyId;
  @override
  Widget build(BuildContext context) {
    final storyRepository = diStoriesData<StoryRepository>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Обновить сказку'),
      ),
      body: BlocProvider(
        create: (context) => StoryUpdateBloc(storyRepository)
          ..add(
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
                SnackBar(
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
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case StoryUpdateStatus.success:
                return StoryUpdateScreenBody();
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
    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        SelectImageStory(),
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
        ButtonStoryCreate(),
      ],
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
                    StoryUpdate(),
                  ),
          child: state.isSubmitting
              ? CircularProgressIndicator()
              : Text(
                  'Обновить',
                  style: AppTextStyles.s16hFFFFFFn,
                ),
        );
      },
    );
  }
}
