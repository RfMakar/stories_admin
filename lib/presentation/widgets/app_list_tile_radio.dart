import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stories_admin/config/UI/app_assets.dart';

class AppListTileRadio extends StatelessWidget {
  const AppListTileRadio({
    super.key,
    required this.title,
    required this.isValue,
    required this.onChanged,
  });

  final String title;
  final bool isValue;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isValue),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title)),
            isValue
                ? SvgPicture.asset(AppAssets.iconChecboxActive)
                : SvgPicture.asset(AppAssets.iconChecboxNoActive),
          ],
        ),
      ),
    );
  }
}