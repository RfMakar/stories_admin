import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/application.dart';
import 'package:stories_admin/config/UI/app_assets.dart';
import 'package:stories_admin/config/UI/app_colors.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_admin/config/router/routers.dart';
import 'package:stories_admin/presentation/bottom_sheet/sheet_delete.dart';
import 'package:stories_admin/presentation/screens/stories/bloc/stories_bloc.dart';
import 'package:stories_admin/presentation/widgets/app_button.dart';
import 'package:stories_data/stories_data.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сказки'),
        // actions: [
        //   IconButton(
        //     // onPressed: null,
        //     onPressed: () => context.read<StoriesBloc>().add(
        //           StoriesDeleteAll(),
        //         ),
        //     icon: SvgPicture.asset(AppAssets.iconDelete),
        //   ),
        //   IconButton(
        //     onPressed: null,
        //     icon: SvgPicture.asset(AppAssets.iconSearch),
        //   ),
        // ],
      ),
      body: BlocConsumer<StoriesBloc, StoriesState>(
        listener: (context, state) {
          if (state.status == StoriesStatus.failure) {
            rootScaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text(state.exception?.message ?? ""),
              ),
            );
          }
        },
        buildWhen: (previous, current) {
          if (current.status == StoriesStatus.failure) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          switch (state.status) {
            case StoriesStatus.initial:
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            case StoriesStatus.success:
              return const StoriesScreenBody();
            case StoriesStatus.failure:
              return Center(
                child: Text(
                  state.exception?.message ?? "",
                ),
              );
          }
        },
      ),
    );
  }
}

class StoriesScreenBody extends StatelessWidget {
  const StoriesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StoriesBloc, StoriesState, List<StoryModel>>(
      selector: (state) {
        return state.stories;
      },
      builder: (context, stories) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            RefreshIndicator(
              onRefresh: () async {
                context.read<StoriesBloc>().add(const StoriesInitial());
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return StoryWidget(
                    key: ValueKey(story.id),
                    story: story,
                  );
                },
              ),
            ),
            const ButtonAddStory(),
          ],
        );
      },
    );
  }
}

class ButtonAddStory extends StatelessWidget {
  const ButtonAddStory({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      child: Text(
        'Создать сказку',
        style: AppTextStyles.s16hFFFFFFn,
      ),
      onTap: () => context.pushNamed(
        Routers.pathStoryCreateScreen,
      ),
    );
  }
}

class StoryWidget extends StatelessWidget {
  const StoryWidget({super.key, required this.story});
  final StoryModel story;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.hexE7E7E7,
        ),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                  imageUrl: story.imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              story.title,
              style: AppTextStyles.s14h000000n,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              story.description,
              style: AppTextStyles.s12h000000n,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 22,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: story.categories.length,
              itemBuilder: (context, index) {
                final category = story.categories[index];
                return CategoryCardStory(category: category);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: null,
                    icon: SvgPicture.asset(AppAssets.iconShow),
                  ),
                  Text(
                    story.readCount.toString(),
                    style: AppTextStyles.s14h000000n,
                  ),
                  story.audio != null
                      ? IconButton(
                          onPressed: null,
                          icon: Icon(Icons.headphones_outlined, color: AppColors.hex000000,),
                        )
                      : Container(),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.pushNamed(
                        Routers.pathStoryUpdateScreen,
                        extra: story.id,
                      );
                    },
                    icon: SvgPicture.asset(
                      AppAssets.iconEdit,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      deleteAction() {
                        context.read<StoriesBloc>().add(
                              StoriesDelete(
                                storyId: story.id,
                              ),
                            );
                      }

                      final isResult =
                          await showDeleteBottomSheet(context: context);

                      if (isResult == true) {
                        deleteAction();
                      }
                    },
                    icon: SvgPicture.asset(
                      AppAssets.iconDelete,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class CategoryCardStory extends StatelessWidget {
  const CategoryCardStory({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.hexE7E7E7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category.name,
      ),
    );
  }
}
