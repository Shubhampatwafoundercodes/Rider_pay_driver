import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart' show AppSizes;
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/format/date_time_formater.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart' show AppSizes;
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/drawer/presentation/notifier/credit_withdraw_history_notifier.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';

class EarningWalletTab extends ConsumerStatefulWidget {
  const EarningWalletTab({super.key});

  @override
  ConsumerState<EarningWalletTab> createState() => _EarningWalletTabState();
}

class _EarningWalletTabState extends ConsumerState<EarningWalletTab> {
  String selectedTab = "credit";


  @override
  Widget build(BuildContext context) {
    final tr=AppLocalizations.of(context)!;

    final state = ref.watch(creditWithdrawHistoryProvider);
    final transactions = state.history?.data ?? [];
    final walletAmount =ref.read(profileProvider.notifier).wallet;

    // Filter based on tab selection
    final filteredList = transactions
        .where((e) =>
    selectedTab == "credit"
        ? e.type?.toUpperCase() == "CR"
        : e.type?.toUpperCase() == "DR")
        .toList();

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        /// 🔹 Wallet Balance
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ConstText(
                text: tr.walletBalanceTitle,
                fontSize: AppConstant.fontSizeTwo,
                fontWeight: AppConstant.semiBold,
              ),
              AppSizes.spaceH(10),
              ConstText(
                text: "₹${walletAmount ?? 0}",
                fontSize: 30.sp,
                fontWeight: AppConstant.bold,
                color: (walletAmount == null || walletAmount == 0)
                    ? Colors.red
                    : Colors.green,
              ),
              AppSizes.spaceH(10),
              ElevatedButton.icon(
                onPressed: () {
                  context.push(RoutesName.moneyTransferScreen);
                },
                icon: const Icon(Icons.account_balance),
                label: ConstText(text: tr.walletTransferButton, color: context.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              AppSizes.spaceH(6),
              ConstText(
                text: "You have ${transactions.length} transfers left",
                fontSize: AppConstant.fontSizeSmall,
                color: context.textSecondary,
              ),
              AppSizes.spaceH(8),
              ConstText(
                text: tr.walletTransferRenew,
                fontSize: AppConstant.fontSizeSmall,
                color: context.hintTextColor,
              ),
            ],
          ),
        ),

        AppSizes.spaceH(20),

        /// 🔹 Tabs
        Row(
          children: [
            Expanded(child: _tabButton("credit", tr.walletTabCredit)),
            AppSizes.spaceW(12),
            Expanded(child: _tabButton("withdraw", tr.walletTabWithdraw)),
          ],
        ),

        AppSizes.spaceH(20),

        /// 🔹 Show Loading or Data
        if (state.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (filteredList.isEmpty)
          Center(child: ConstText(text: tr.walletNoTransactions))
        else
          Column(
            children: filteredList.map((t) {
              return TransactionTile(
                title: t.description ?? '',
                amount: "₹${t.amount ?? 0}",
                time: t.datetime.toString(),
                status: t.status ?? '',
                type: t.type ?? '',
              );
            }).toList(),
          ),
      ],
    );
  }

  /// 🔹 Tab Button Widget
  Widget _tabButton(String key, String label) {
    final bool active = selectedTab == key;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = key),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? context.docBlue : context.greyLightest,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: ConstText(
          text: label,
          color: active ? Colors.white : context.textSecondary,
          fontWeight: AppConstant.semiBold,
        ),
      ),
    );
  }
}

/// 🔹 Transaction Tile
class TransactionTile extends StatelessWidget {
  final String title;
  final String amount;
  final String time;
  final String status;
  final String type;

  const TransactionTile({
    super.key,
    required this.title,
    required this.amount,
    required this.time,
    required this.status,
    required this.type,
  });

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case "SUCCESS":
        return Colors.green;
      case "FAILED":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {

    final color = _getStatusColor(status);
    final isCredit = type.toUpperCase() == "CR";

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: context.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: isCredit ? Colors.green : Colors.red,
          ),
          AppSizes.spaceW(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstText(
                  text: title,
                  fontWeight: AppConstant.semiBold,
                ),
                AppSizes.spaceH(4),
                ConstText(
                  text: DateTimeFormat.formatFullDateTime(time),
                  fontSize: AppConstant.fontSizeSmall,
                  color: context.hintTextColor,
                ),

              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ConstText(
                text: isCredit ? "+ $amount" : "- $amount",
                fontWeight: AppConstant.semiBold,
                color: color,
              ),
              AppSizes.spaceH(4),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ConstText(text:
                    status,
                    fontWeight: FontWeight.w600,
                    color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
