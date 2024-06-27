import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/extension/widget.dart';
import '../../shared/components/app_text_theme.dart';
import '../../theme/config/app_color.dart';
import 'app_loader.dart';
import 'search_widget.dart';

class DropDownSearchWidget<T> extends ConsumerWidget {
  const DropDownSearchWidget({
    super.key,
    required this.searchCtrl,
    required this.data,
    required this.title,
    required this.loading,
    required this.onSelect,
  });
  final TextEditingController searchCtrl;
  final List<T> data;
  final String Function(T item) title;
  final bool loading;
  final void Function(T item) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 800,
          minHeight: 400,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Search Hanger',
                      style: AppTextTheme.label16.copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.popRoute();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Gap(15),
              SearchWidget(
                ctrl: searchCtrl,
              ),
              const Gap(10),
              if (loading)
                const AppLoader()
              else if (data.isEmpty)
                Center(
                  child: Text(
                    'No data found',
                    style:
                        AppTextTheme.label12.copyWith(color: AppColor.primary),
                  ).pad(top: 130),
                )
              else
                ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 1,
                      color: AppColor.lightGrey,
                    );
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        onSelect.call(data[index]);
                        context.popRoute();
                      },
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      title: Text(
                        title.call(
                          data[index],
                        ),
                        style: AppTextTheme.label13
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    );
                  },
                ),
            ],
          ).padAll(20),
        ),
      ),
    );
  }
}
