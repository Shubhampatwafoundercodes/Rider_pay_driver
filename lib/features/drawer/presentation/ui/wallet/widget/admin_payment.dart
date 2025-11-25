import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/format/date_time_formater.dart';
import 'package:rider_pay_driver/features/cashfree_payment/admin_transaction_notifier.dart';
import 'package:rider_pay_driver/features/cashfree_payment/cashfree_provider.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/wallet/widget/wallet_tab.dart' show TransactionTile;
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';



/// UI
class AdminPayment extends ConsumerWidget {
  final double adminDue = 850.50;

  // Static Admin Payment History
  // final List<Map<String, dynamic>> adminTransactions = [
  //   {
  //     "description": "Admin Commission Payment",
  //     "amount": 500,
  //     "datetime": "2025-10-10 14:35:00",
  //     "status": "SUCCESS",
  //     "type": "ADMIN",
  //   },
  //   {
  //     "description": "Admin Commission Payment",
  //     "amount": 300,
  //     "datetime": "2025-09-30 11:20:00",
  //     "status": "SUCCESS",
  //     "type": "ADMIN",
  //   },
  //   {
  //     "description": "Admin Commission Payment",
  //     "amount": 250,
  //     "datetime": "2025-09-15 09:10:00",
  //     "status": "FAILED",
  //     "type": "ADMIN",
  //   },
  // ];

  const AdminPayment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr=AppLocalizations.of(context)!;
    final state = ref.watch(paymentProvider);
    final adminSate = ref.watch(adminTransactionProvider);
    final adminDueRaw = ref.read(profileProvider.notifier).adminDue;
    print(adminDueRaw);
    final double adminDue = _parseToDouble(adminDueRaw);
    final history = adminSate.history?.data?.payinHistory ?? [];


    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            // Admin Due Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ConstText(
                    text: tr.yourAdminDue,
                    fontSize: AppConstant.fontSizeTwo,
                    fontWeight: AppConstant.semiBold,
                  ),
                  AppSizes.spaceH(10),
                  ConstText(
                    text: "₹${adminDue.toStringAsFixed(2)}",
                    fontSize: 30.sp,
                    fontWeight: AppConstant.bold,
                    color: adminDue > 0 ? Colors.orange : Colors.green,
                  ),
                  AppSizes.spaceH(10),
                  ElevatedButton.icon(
                    onPressed: adminDue > 0
                        ? () async {

                      await ref.read(paymentProvider.notifier).startPayment(adminDue);

                    }
                        : null,
                    icon: const Icon(Icons.payment),
                    label: ConstText(
                      text: adminDue > 0 ? tr.payAdminDue : tr.noDueRemaining,
                      color: context.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: adminDue > 0
                          ? context.docBlue
                          : context.greyLight,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 10.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSizes.spaceH(20),

            // Admin Payment History
            ConstText(
              text: tr.adminPaymentHistory,
              fontSize: AppConstant.fontSizeTwo,
              fontWeight: AppConstant.semiBold,
            ),
            AppSizes.spaceH(10),
            if (history.isEmpty)
               Center(
                child: ConstText(text: tr.noAdminPaymentsFound),
              )
            else
              Column(
                children: history.map((t) {
                  return TransactionTile(
                    title: "Admin Commission Payment",
                    amount: "₹${t.amount}",
                    time: DateTimeFormat.formatFullDateTime(t.datetime),
                    status: t.status.toString().toUpperCase(),
                    type: "ADMIN",
                  );
                }).toList(),
              ),
          ],
        ),
        if (state.status == PaymentStatus.loading)
          AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 200),
            child: Container(
              color: Colors.white.withAlpha(90),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 50.w,
                      width: 50.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 4,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(width: 20.h),
                    const Text(
                      "Processing Payment...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
  double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.trim()) ?? 0.0;
    }
    return 0.0;
  }
}
