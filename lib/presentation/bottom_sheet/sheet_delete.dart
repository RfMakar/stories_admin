import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_admin/presentation/widgets/app_button.dart';

Future<bool?> showDeleteBottomSheet({required BuildContext context}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            'Удалить?',
            style: AppTextStyles.s18h000000n,
          ),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  child: Text(
                    'Нет',
                    style: AppTextStyles.s16hFFFFFFn,
                  ),
                  onTap: () {
                    context.pop(false);
                  },
                ),
              ),
              Expanded(
                child: AppButton(
                  child: Text(
                    'Да',
                    style: AppTextStyles.s16hFFFFFFn,
                  ),
                  onTap: () {
                    context.pop(true);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
