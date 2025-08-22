 import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/utils/app_colors.dart';

import '../../../../core/utils/receipt_viewer_page.dart';
import '../../../../generated/locale_keys.g.dart';

class ReceiptPreview extends StatelessWidget {
  final String? receiptPath;
  final String heroTag;
  final double aspectRatio;
  final double placeholderHeight;
  final BorderRadius borderRadius;

  const ReceiptPreview({
    super.key,
    required this.receiptPath,
    required this.heroTag,
    this.aspectRatio = 16 / 10,
    this.placeholderHeight = 140,
    BorderRadius? borderRadius,
  }) : borderRadius = borderRadius ?? const BorderRadius.all(Radius.circular(16));

  bool get _isNetwork =>
      receiptPath != null &&
          receiptPath!.trim().isNotEmpty &&
          (receiptPath!.startsWith('http://') || receiptPath!.startsWith('https://'));

  bool get _isLocal =>
      receiptPath != null && receiptPath!.trim().isNotEmpty && !receiptPath!.startsWith('http');

  bool _localExists() {
    try {
      return File(receiptPath!).existsSync();
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isNetwork) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Image.network(
            receiptPath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _placeholder(context),
          ),
        ),
      );
    }

    if (_isLocal && _localExists()) {
      return GestureDetector(
        onTap: () => ReceiptViewerPage.open(
          context,
          imagePath: receiptPath!,
          heroTag: heroTag,
        ),
        child: Hero(
          tag: heroTag,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Image.file(
                File(receiptPath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(context),
              ),
            ),
          ),
        ),
      );
    }

    return _placeholder(context);
  }


  Widget _placeholder(BuildContext context) {
    return Container(
      height: placeholderHeight.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        border: Border.all(color: Colors.black12, width: 1),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            color: AppColors.textDark.withOpacity(.45),
            size: 26.r,
          ),
          8.h.verticalSpace,
          Text(
            LocaleKeys.no_receipt_attached.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textDark.withOpacity(.65),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }}
