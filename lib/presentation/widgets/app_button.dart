import 'package:flutter/material.dart';
import 'package:stories_admin/config/UI/app_colors.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;

  const AppButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            AppColors.hex5F3430,
          ),
          minimumSize: WidgetStateProperty.all(
            const Size(double.infinity, 45),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        onPressed: onTap,
        child: child,
      ),
    );
  }
}
