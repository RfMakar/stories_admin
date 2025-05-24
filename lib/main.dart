import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stories_admin/aplication.dart';
import 'package:stories_admin/core/functions/di_stories_admin.dart';
import 'package:stories_data/index.dart';

Future<void> main() async {
  await dotenv.load();
  final apiKey = dotenv.env['API_KEY'] ?? '';
  await StoriesData.init(apiKey: apiKey);

  await setupDiStoriesAdmin();

  runApp(const Aplication());
}
