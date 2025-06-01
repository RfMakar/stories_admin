part of 'stories_bloc.dart';

@immutable
sealed class StoriesEvent {
  const StoriesEvent();
}

final class StoriesInitial extends StoriesEvent {
  const StoriesInitial();
}

final class StoriesDelete extends StoriesEvent {
  const StoriesDelete({required this.storyId});
  final String storyId;
}

final class StoriesDeleteAll extends StoriesEvent {
  const StoriesDeleteAll();
}

final class StoriesAdd extends StoriesEvent {
  const StoriesAdd({required this.storyModel});
  final StoryModel storyModel;
}

final class StoriesUpdate extends StoriesEvent {
  const StoriesUpdate({required this.storyModel});
  final StoryModel storyModel;
}
