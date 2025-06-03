import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stories_admin/config/UI/app_assets.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';

class AppListTile extends StatefulWidget {
  const AppListTile({
    super.key,
    required this.title,
    required this.isValue,
    required this.onChanged,
  });
  final String title;
  final bool isValue;
  final Function(bool) onChanged;

  @override
  State<AppListTile> createState() => _AppListTileState();
}

class _AppListTileState extends State<AppListTile> {
  late bool _isValue;
  @override
  void initState() {
    _isValue = widget.isValue;
    super.initState();
  }

  void _onPressed() {
    setState(() {
      _isValue = !_isValue;
      widget.onChanged(_isValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: AppTextStyles.s12h000000n,
                softWrap: true,
              ),
            ),
            _isValue
                ? SvgPicture.asset(AppAssets.iconChecboxActive)
                : SvgPicture.asset(AppAssets.iconChecboxNoActive)
          ],
        ),
      ),
    );
  }
}
