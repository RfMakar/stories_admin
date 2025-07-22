import 'dart:io';

import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stories_admin/config/UI/app_colors.dart';
import 'package:stories_admin/core/functions/di_stories_admin.dart';
import 'package:stories_admin/data/services/permission_service.dart';

class SelectAudioStorageWidget extends StatefulWidget {
  const SelectAudioStorageWidget({
    super.key,
    this.audio,
    required this.onPatchAudio,
  });
  final String? audio;
  final ValueChanged<File?> onPatchAudio;

  @override
  State<SelectAudioStorageWidget> createState() =>
      _SelectAudioStorageWidgetState();
}

class _SelectAudioStorageWidgetState extends State<SelectAudioStorageWidget> {
  final permissionService = diStoriesAdmin<PermissionService>();
  File? audio;
  File? newAudio;

  @override
  void initState() {
    if (widget.audio != null) {
      audio = File(widget.audio!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (newAudio != null) {
      return _audioFile();
    } else if (audio != null) {
      return _audioNetwork();
    } else {
      return _audioButton();
    }
  }

  Widget _audioFile() {
    return InkWell(
      onTap: _audioStorage,
      child: Container(
         height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.hexE7E7E7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: Text(basename(newAudio?.path ?? 'Ошибка'))),
      ),
    );
  }

  Widget _audioNetwork() {
    return InkWell(
      onTap: _audioStorage,
      child: Container(
         height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.hexE7E7E7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: Text(basename(audio?.path ?? 'Ошибка'))),
      ),
    );
  }

  Widget _audioButton() {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _audioStorage,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.hexE7E7E7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text('Audio'),
          ),
        ),
      ),
    );
  }

  Future<void> _audioStorage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'm4a', 'aac', 'wav', 'ogg', 'flac'],
    );

    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.single.path!);
      setState(() {
        newAudio = file;
        widget.onPatchAudio(file);
      });
    }
  }
}
