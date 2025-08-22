import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'total_expenses_card.dart';
import 'total_income_card.dart';

class StatsSlider extends StatefulWidget {
  final double totalExpenses;
  final int expenseCount;
  final double totalIncome;
  final int incomeCount;

  const StatsSlider({
    super.key,
    required this.totalExpenses,
    required this.expenseCount,
    required this.totalIncome,
    required this.incomeCount,
  });

  @override
  State<StatsSlider> createState() => _StatsSliderState();
}

class _StatsSliderState extends State<StatsSlider> {
  late PageController _controller;
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _index = (_index + 1) % 2;
      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(

      height: 90.h,
      child: PageView(
        controller: _controller,
        padEnds: false,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: TotalIncomeCard(
              total: widget.totalIncome,
              count: widget.incomeCount,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: TotalExpensesCard(
              total: widget.totalExpenses,
              count: widget.expenseCount,
            ),
          ),
        ],
      ),
    );
  }

}
