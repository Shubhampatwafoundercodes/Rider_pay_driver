// money_transfer_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/core/utils/utils.dart';
import 'package:rider_pay_driver/features/drawer/data/model/get_bank_details_model.dart';
import 'package:rider_pay_driver/features/drawer/presentation/notifier/bank_details_notifier.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';

class MoneyTransferPage extends ConsumerStatefulWidget {
  const MoneyTransferPage({super.key});

  @override
  ConsumerState<MoneyTransferPage> createState() => _MoneyTransferPageState();
}

class _MoneyTransferPageState extends ConsumerState<MoneyTransferPage> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final driverId = ref.read(userProvider.notifier).userId;
      ref.read(bankDetailsNotifierProvider.notifier).fetchBankDetails(driverId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr=AppLocalizations.of(context)!;
    final bankState = ref.watch(bankDetailsNotifierProvider);
    final bankDetails = bankState.bankDetails?.data ?? [];
    final methods = bankDetails.where((d) => d.accountNumber != null || d.upiId != null).toList();
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
                  text: tr.moneyTransfer,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
      body: bankState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
        Container(
        width: double.infinity,
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: context.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstText(
              text: tr.totalAmountToTransfer,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.hintTextColor,
            ),
            AppSizes.spaceH(8),
            ConstText(
              text: ref.read(profileProvider.notifier).wallet.toString(),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
            ),
          ],
        ),
      ),
          Container(height: 8, color: context.greyLight),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstText(
                    text: tr.automaticMoneyTransfer,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                  AppSizes.spaceH(16),
                  ConstText(
                    text: tr.depositTo,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.hintTextColor,
                  ),
                  AppSizes.spaceH(12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: methods.length,
                    separatorBuilder: (context, index) => AppSizes.spaceH(12),
                    itemBuilder: (context, index) => _buildPaymentMethodCard(
                      methods[index],
                      index,tr,
                      isSelected: _selectedIndex == index,
                    ),
                  ),
                  AppSizes.spaceH(24),
                  _buildAddPaymentMethodButton(tr),
                  AppSizes.spaceH(32),
                ],
              ),
            ),
          ),
          _buildTransferButton(methods,tr),
          AppSizes.spaceH(15),
        ],
      ),
    );
  }


  Widget _buildPaymentMethodCard(BankDetailsOnlyOneData method, int index,AppLocalizations tr, {required bool isSelected}) {
    final isUPI = method.upiId != null;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index), // <-- select card
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: context.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? context.primary : context.greyLight,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: context.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUPI ? Icons.account_balance_wallet : Icons.account_balance,
                color: context.primary,
                size: 20.w,
              ),
            ),
            AppSizes.spaceW(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstText(
                    text: isUPI ? tr.upiId : tr.bankAccount,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                  AppSizes.spaceH(4),
                  ConstText(
                    text: isUPI ? method.upiId! : method.accountNumber!,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: context.hintTextColor,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _handleViewMethod(method),
              style: TextButton.styleFrom(
                foregroundColor: context.primary,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              ),
              child: ConstText(
                text: tr.view,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPaymentMethodButton(AppLocalizations tr) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstText(
            text: tr.addNewPaymentMethod,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
          AppSizes.spaceH(16),
          _buildPaymentOption(
            title:tr.bankAccount,
            subtitle:tr.addYourBankAccount,
            onTap: () => _handleAddPaymentMethod(isBankAccount: true),
          ),
          AppSizes.spaceH(12),
          _buildPaymentOption(
            title:tr.upiId,
            subtitle: tr.addYourUpiId,
            onTap: () => _handleAddPaymentMethod(isBankAccount: false),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: context.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.account_balance, color: context.primary, size: 20.w),
      ),
      title: ConstText(
        text: title,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: context.textPrimary,
      ),
      subtitle: ConstText(
        text: subtitle,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: context.hintTextColor,
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: context.hintTextColor, size: 16.w),
    );
  }

  Widget _buildTransferButton(List<BankDetailsOnlyOneData> methods,AppLocalizations tr) {
    final isEnabled = _selectedIndex != null && methods.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(16.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isEnabled ? () async{
            final driverId = ref.read(userProvider.notifier).userId.toString();
            final profileN = ref.read(profileProvider.notifier);
               final amount= profileN.wallet.toString();

            final selectedMethod = methods[_selectedIndex!];
            final type = selectedMethod.upiId != null ? "upi" : "bank";
            final accountRefId = selectedMethod.id.toString();
            final notifier = ref.read(bankDetailsNotifierProvider.notifier);
            final success = await notifier.withdrawAmount(
              driverId: driverId,
              amount: amount,
              type: type,
              accountRefId: accountRefId,
            );
            print("$success");
            Navigator.pop(context); // close loader
            if (success) {
              profileN.getProfile();
              toastMsg("Transfer successful!");
            } else {
              toastMsg("Transfer failed!");
            }

            // _handleTransfer(methods[_selectedIndex!],tr)

          }  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? context.primary : context.greyLight,
            foregroundColor: context.white,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: ConstText(
            text: tr.transfer,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: context.white,
          ),
        ),
      ),
    );
  }

  void _handleViewMethod(BankDetailsOnlyOneData method) {
    context.push(RoutesName.paymentDetailsScreen, extra: method);
  }

  void _handleAddPaymentMethod({required bool isBankAccount}) {
    context.push(RoutesName.addBankAccountScreen, extra: {'isBankAccount': isBankAccount});
  }

}
