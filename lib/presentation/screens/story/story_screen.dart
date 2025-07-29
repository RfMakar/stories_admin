import 'package:flutter/material.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_data/models/story_model.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key, required this.story});
  final StoryModel story;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(story.title),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Название', style: AppTextStyles.s16h5F3430n),
            Text(story.title),
            const SizedBox(
              height: 10,
            ),
            Text('Описание', style: AppTextStyles.s16h5F3430n),
            Text(story.description),
            const SizedBox(
              height: 10,
            ),
            Text('Сказка', style: AppTextStyles.s16h5F3430n),
            Text(story.content),
          ],
        ));
  }
}
