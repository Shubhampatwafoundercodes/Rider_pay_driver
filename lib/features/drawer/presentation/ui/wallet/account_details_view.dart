import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/utils.dart';
import 'package:rider_pay_driver/features/drawer/data/model/get_bank_details_model.dart';
import 'package:rider_pay_driver/features/drawer/presentation/notifier/bank_details_notifier.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';

class PaymentDetailsScreen extends ConsumerWidget {
  final BankDetailsOnlyOneData method;
  const PaymentDetailsScreen({super.key, required this.method});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr=AppLocalizations.of(context)!;
    final isUPI = method.upiId != null;
    final bankS=ref.watch(bankDetailsNotifierProvider);

    return Scaffold(
      backgroundColor: context.greyLightest,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          CommonTopBar(
            child: Row(
              children: [
                const ConstAppBackBtn(),
                AppSizes.spaceW(15),
                ConstText(
                  text: tr.paymentDetails,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
      body:
       Padding(
        padding: EdgeInsets.all(16.w),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: context.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),

          child: isUPI
              ? _buildUpiDetails(context, ref,tr)
              : _buildBankDetails(context, ref,tr),
        ),
      ),
    );
  }

  /// 🧾 --- UPI DETAILS VIEW
  Widget _buildUpiDetails(BuildContext context, WidgetRef ref,AppLocalizations tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _detailItem(tr.upiId, "UPI ID"),
        _detailItem(tr.upiId, method.upiId ?? "-"),
        _detailItem(tr.accountHolder, method.accountHolder ?? "-"),
        AppSizes.spaceH(20),
        // _confirmButton(context),
        AppSizes.spaceH(12),
        _deleteButton(context, ref,tr),
      ],
    );
  }

  /// 🧾 --- BANK DETAILS VIEW
  Widget _buildBankDetails(BuildContext context, WidgetRef ref,AppLocalizations tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _detailItem(tr.type, "Bank Account"),
        _detailItem(tr.accountHolder, method.accountHolder ?? "-"),
        _detailItem(tr.accountNumber, method.accountNumber ?? "-"),
        _detailItem(tr.ifscCode, method.ifsc ?? "-"),
        _detailItem(tr.bankName, method.bankName ?? "-"),
        _detailItem(tr.upiId, method.upiId ?? "-"),
        AppSizes.spaceH(20),
        _deleteButton(context, ref,tr),

      ],
    );
  }

  Widget _detailItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstText(
            text: title,
            fontSize: 12,
            color: Colors.grey,
          ),
          ConstText(
            text: value,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  /// 🗑️ DELETE BUTTON — calls deleteAccountApi with popup loader
  Widget _deleteButton(BuildContext context, WidgetRef ref,AppLocalizations tr) {
    return AppBtn(
      onTap: () async {
        final driverId = ref.read(userProvider.notifier).userId;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     CircularProgressIndicator(strokeWidth: 2.5),
                    SizedBox(width: 16.w),
                    ConstText(text: tr.deleting,fontSize: AppConstant.fontSizeThree,)
                  ],
                ),
              ),
            );
          },
        );
        final result = await ref
            .read(bankDetailsNotifierProvider.notifier)
            .deleteAccountApi(method.id.toString(), driverId.toString());
        Navigator.pop(context);
        if (result) {
          context.pop();
        } else {
          toastMsg(tr.failedToDelete);
        }
      },
      color: Colors.transparent,
      border: Border.all(color: Colors.red, width: 1),
      title: tr.delete,
      titleColor: Colors.red,
    );
  }

}
