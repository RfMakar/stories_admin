part of 'story_update_bloc.dart';

sealed class StoryUpdateEvent {
  const StoryUpdateEvent();
}

final class StoryUpdateInitial extends StoryUpdateEvent {
  const StoryUpdateInitial({required this.storyId});
  final String storyId;
}

final class StoryUpdateTitle extends StoryUpdateEvent {
  const StoryUpdateTitle({required this.title});
  final String title;
}

final class StoryUpdateDescription extends StoryUpdateEvent {
  const StoryUpdateDescription({required this.description});
  final String description;
}

final class StoryUpdateContent extends StoryUpdateEvent {
  const StoryUpdateContent({required this.content});
  final String content;
}

final class StoryUpdateImage extends StoryUpdateEvent {
  const StoryUpdateImage({required this.image});
  final File image;
}

final class StoryUpdate extends StoryUpdateEvent {
  const StoryUpdate();
}
