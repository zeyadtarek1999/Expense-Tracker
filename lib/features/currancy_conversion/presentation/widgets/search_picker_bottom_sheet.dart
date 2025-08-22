 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class SearchPickerBottomSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? initial;
  final List<String>? quickPicks;

  const SearchPickerBottomSheet({
    super.key,
    required this.title,
    required this.items,
    this.initial,
    this.quickPicks,
  });

  static Future<String?> show(
      BuildContext context, {
        required String title,
        required List<String> items,
        String? initial,
        List<String>? quickPicks,
      }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (_) => SearchPickerBottomSheet(
        title: title,
        items: items,
        initial: initial,
        quickPicks: quickPicks,
      ),
    );
  }

  @override
  State<SearchPickerBottomSheet> createState() => _SearchPickerBottomSheetState();
}

class _SearchPickerBottomSheetState extends State<SearchPickerBottomSheet> {
  late final TextEditingController _controller;
  late List<String> _filtered;
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
    _controller = TextEditingController();
    _filtered = List<String>.from(widget.items)..sort();
    _controller.addListener(_filter);
  }

  void _filter() {
    final q = _controller.text.trim().toLowerCase();
    setState(() {
      _filtered = widget.items
          .where((e) => e.toLowerCase().contains(q))
          .toList()
        ..sort();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_filter);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final safeInsets = MediaQuery.of(context).viewPadding;
    final maxH = (MediaQuery.of(context).size.height * 0.85).clamp(420.h, 720.h);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: maxH.toDouble(),
          child: Column(
            children: [
              SizedBox(height: safeInsets.top > 0 ? 6 : 12),
              Container(
                width: 44.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              12.h.verticalSpace,

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: const Icon(Icons.tune_rounded, color: AppColors.primaryBlue, size: 20),
                    ),
                    10.w.horizontalSpace,
                    Expanded(
                      child: Text(
                        'Select ${widget.title}',
                        style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: AppColors.textDark),
                    ),
                  ],
                ),
              ),

              // Search
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 10.h),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search currency',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: AppColors.lightBackground,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.2),
                    ),
                  ),
                ),
              ),

              // Quick picks
              if ((widget.quickPicks ?? const []).isNotEmpty) ...[
                SizedBox(
                  height: 42.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.quickPicks!.length,
                    separatorBuilder: (_, __) => 8.w.horizontalSpace,
                    itemBuilder: (context, i) {
                      final code = widget.quickPicks![i];
                      final selected = _selected == code;
                      return ChoiceChip(
                        label: Text(
                          code,
                          style: t.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: selected ? AppColors.white : AppColors.textDark,
                          ),
                        ),
                        selected: selected,
                        onSelected: (_) => _select(code),
                        selectedColor: AppColors.primaryBlue,
                        backgroundColor: AppColors.lightBackground,
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: selected ? AppColors.primaryBlue : AppColors.border,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                8.h.verticalSpace,
              ],

              // List
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                  child: Text(
                    'No matches',
                    style: t.bodyMedium?.copyWith(color: AppColors.textMedium),
                  ),
                )
                    : ListView.separated(
                  padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 12.h),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => 8.h.verticalSpace,
                  itemBuilder: (context, i) {
                    final code = _filtered[i];
                    final selected = _selected == code;
                    return _PickerTile(
                      code: code,
                      selected: selected,
                      onTap: () => _select(code),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _select(String code) {
    setState(() => _selected = code);
    Navigator.pop(context, code);
  }
}

class _PickerTile extends StatelessWidget {
  final String code;
  final bool selected;
  final VoidCallback onTap;

  const _PickerTile({
    required this.code,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Material(
      color: selected ? AppColors.primaryBlue.withOpacity(0.08) : AppColors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected ? AppColors.primaryBlue : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              _CircleMonogram(text: code),
              12.w.horizontalSpace,
              Expanded(
                child: Text(
                  code,
                  style: t.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              if (selected)
                const Icon(Icons.check_rounded, color: AppColors.green),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleMonogram extends StatelessWidget {
  final String text;
  const _CircleMonogram({required this.text});

  @override
  Widget build(BuildContext context) {
    final firstTwo = text.length >= 2 ? text.substring(0, 2) : text;
    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
        color: AppColors.secondaryBlue.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.secondaryBlue.withOpacity(0.35)),
      ),
      alignment: Alignment.center,
      child: Text(
        firstTwo,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }
}
