part of 'story_create_bloc.dart';

@immutable
sealed class StoryCreateEvent {
  const StoryCreateEvent();
}

final class StoryCreateInitial extends StoryCreateEvent {
  const StoryCreateInitial();
}

final class StoryCreateTitle extends StoryCreateEvent {
  const StoryCreateTitle({required this.title});
  final String title;
}

final class StoryCreateDescription extends StoryCreateEvent {
  const StoryCreateDescription({required this.description});
  final String description;
}

final class StoryCreateContent extends StoryCreateEvent {
  const StoryCreateContent({required this.content});
  final String content;
}

final class StoryCreateImage extends StoryCreateEvent {
  const StoryCreateImage({required this.image});
  final File image;
}

final class StoryCreateAddCategory extends StoryCreateEvent {
  const StoryCreateAddCategory({required this.categoryId});
  final String categoryId;
}
final class StoryCreateRemoveCategory extends StoryCreateEvent {
  const StoryCreateRemoveCategory({required this.categoryId});
  final String categoryId;
}

final class StoryCreate extends StoryCreateEvent {
  const StoryCreate();
}
