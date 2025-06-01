import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stories_admin/config/UI/app_colors.dart';
import 'package:stories_admin/core/functions/di_stories_admin.dart';
import 'package:stories_admin/data/services/permission_service.dart';
import 'package:image_picker/image_picker.dart';

class SelectIconStorageWidget extends StatefulWidget {
  const SelectIconStorageWidget({
    super.key,
    this.icon,
    required this.onPatchIcon,
  });
  final String? icon;
  final ValueChanged<File?> onPatchIcon;

  @override
  State<SelectIconStorageWidget> createState() =>
      _SelectIconStorageWidgetState();
}

class _SelectIconStorageWidgetState extends State<SelectIconStorageWidget> {
  final permissionService = diStoriesAdmin<PermissionService>();
  File? icon;
  File? newIcon;

  @override
  void initState() {
    if (widget.icon != null) {
      icon = File(widget.icon!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (newIcon != null) {
      return _iconFile();
    } else if (icon != null) {
      return _iconNetwork();
    } else {
      return _iconButton();
    }
  }

  Widget _iconFile() {
    return Center(
      child: InkWell(
        onTap: _iconStorage,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(16),
          child: Image.file(
            height: 150,
            width: 150,
            newIcon!,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _iconNetwork() {
    return Center(
      child: InkWell(
        onTap: _iconStorage,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(16),
          child: Image.network(
            height: 150,
            width: 150,
            widget.icon!,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _iconButton() {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _iconStorage,
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.hexE7E7E7
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text('Icon'),
          ),
        ),
      ),
    );
  }

  Future<void> _iconStorage() async {
    final isRes = await permissionService.requestPhotoOrStorage();
    if (isRes) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          final file = File(pickedFile.path);
          newIcon = file;
          widget.onPatchIcon(file);
        });
      }
    } else {
      openAppSettings();
    }
  }
}
