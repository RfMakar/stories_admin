import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stories_admin/config/UI/app_colors.dart';
import 'package:stories_admin/core/functions/di_stories_admin.dart';
import 'package:stories_admin/data/services/permission_service.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageStorageWidget extends StatefulWidget {
  const SelectImageStorageWidget({
    super.key,
    this.image,
    required this.onPatchImage,
  });
  final String? image;
  final ValueChanged<File?> onPatchImage;

  @override
  State<SelectImageStorageWidget> createState() =>
      _SelectImageStorageWidgetState();
}

class _SelectImageStorageWidgetState extends State<SelectImageStorageWidget> {
  final permissionService = diStoriesAdmin<PermissionService>();
  File? image;
  File? newImage;

  @override
  void initState() {
    if (widget.image != null) {
      image = File(widget.image!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (newImage != null) {
      return _imageFile();
    } else if (image != null) {
      return _imageNetwork();
    } else {
      return _imageButton();
    }
  }

  Widget _imageFile() {
    return Center(
      child: InkWell(
        onTap: _imageStorage,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.file(
              newImage!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageNetwork() {
    return Center(
      child: InkWell(
        onTap: _imageStorage,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: widget.image!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageButton() {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _imageStorage,
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.hexE7E7E7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text('Image'),
          ),
        ),
      ),
    );
  }

  Future<void> _imageStorage() async {
    final isRes = await permissionService.requestPhotoOrStorage();
    if (isRes) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          final file = File(pickedFile.path);
          newImage = file;
          widget.onPatchImage(file);
        });
      }
    } else {
      openAppSettings();
    }
  }
}
