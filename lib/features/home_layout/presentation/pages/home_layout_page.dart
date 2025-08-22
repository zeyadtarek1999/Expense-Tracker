 import 'package:expense_tracker/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

  import '../../../../config/routes/app_routes.dart';
import '../../../currancy_conversion/presentation/pages/currancy_conversion.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../setting/presentation/pages/setting_page.dart';
import '../manager/home_layout_bloc.dart';
import '../manager/home_layout_event.dart';
import '../manager/home_layout_state.dart';
import '../widgets/nav_icon_widget.dart';

class HomeLayoutPage extends StatelessWidget {
  const HomeLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeLayoutBloc()..add(InitLayoutEvent()),
      child: BlocBuilder<HomeLayoutBloc, HomeLayoutState>(
        builder: (context, state) {
          final bloc = context.read<HomeLayoutBloc>();

          return Column(
            children: [
              // Main content
              Expanded(
                child: IndexedStack(
                  index: state.currentIndex,
                  children: const [
                    DashboardPage(),
                    CurrencyConversionPage(),
                    CurrencyConversionPage(),
                    SettingsPage(),
                  ],
                ),
              ),

              // Bottom navigation
              Container(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 12.h,
                  bottom: 25.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    NavIcon(
                      icon: Icons.home_filled,
                      selected: state.currentIndex == 0,
                      onTap: () => bloc.add(ChangeTabEvent(0)),
                    ),
                    NavIcon(
                      icon: Icons.stacked_bar_chart_rounded,
                      selected: state.currentIndex == 1,
                      onTap: () => bloc.add(ChangeTabEvent(1)),
                    ),
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          onTap: () =>  context.push(AppRoutes.addExpense),
                          child: Container(
                            width: 45.r,
                            height: 45.r,
                            decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2C63FF).withOpacity(.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                )
                              ],
                            ),
                            child: Icon(Icons.add, color: Colors.white, size: 28.r),
                          ),
                        ),
                      ),
                    ),
                    NavIcon(
                      icon: Icons.account_balance_wallet_rounded,
                      selected: state.currentIndex == 2,
                      onTap: () => bloc.add(ChangeTabEvent(2)),
                    ),
                    NavIcon(
                      icon: Icons.settings_rounded,
                      selected: state.currentIndex == 3,
                      onTap: () => bloc.add(ChangeTabEvent(3)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
