// add_bank_account_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/app_text_field.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';

// add_bank_account_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/app_text_field.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/validator/app_input_formatters.dart';
import 'package:rider_pay_driver/core/res/validator/app_validator.dart';
import 'package:rider_pay_driver/core/utils/utils.dart';
import 'package:rider_pay_driver/features/drawer/presentation/notifier/bank_details_notifier.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';

// add_bank_account_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/app_text_field.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/validator/app_validator.dart';
import 'package:rider_pay_driver/features/drawer/presentation/notifier/bank_details_notifier.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';

class AddBankAccountPage extends ConsumerStatefulWidget {
  final bool? isAddBankAcc;
  const AddBankAccountPage({super.key, this.isAddBankAcc = true});

  @override
  ConsumerState<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends ConsumerState<AddBankAccountPage> {
  // 🔹 BANK CONTROLLERS
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _reAccountNumberController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();

  // 🔹 UPI CONTROLLERS
  final TextEditingController _upiNameController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();
  final TextEditingController _reUpiIdController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool _isBankAccount;

  @override
  void initState() {
    super.initState();
    _isBankAccount = widget.isAddBankAcc ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final tr=AppLocalizations.of(context)!;
    final isLoading = ref.watch(bankDetailsNotifierProvider).isLoading;
    return isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : SafeArea(
            top: false,
            child: Scaffold(
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
                          text:tr.paymentMethod,
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
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Container(
                        width: double.infinity,
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
                            // _buildToggleButtons(tr),
                            AppSizes.spaceH(12),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: context.greyLightest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ConstText(
                                text:tr.earningsTransferInfo,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: context.hintTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      AppSizes.spaceH(24),

                      _isBankAccount
                          ? _buildBankAccountForm(tr)
                          : _buildUpiForm(tr),

                      AppSizes.spaceH(32),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                padding: EdgeInsets.all(16.w),
                child: SizedBox(
                  width: double.infinity,
                  child: AppBtn(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final driverId = ref.read(userProvider.notifier).userId;

                        final data = _isBankAccount
                            ? {
                                "driverId": driverId.toString(),
                                "accountHolder": _accountHolderController.text.trim(),
                                "accountNumber": _accountNumberController.text
                                    .trim(),
                                "ifsc": _ifscController.text.trim(),
                                "bankName": _bankNameController.text.trim(),
                              }
                            : {
                                "driverId": driverId.toString(),
                               "accountHolder": _upiNameController.text.trim(),
                                "upiId": _upiIdController.text.trim(),
                              };

                        try {
                          await ref
                              .read(bankDetailsNotifierProvider.notifier)
                              .addBankDetails(data, driverId.toString());
                         toastMsg(_isBankAccount
                             ? tr.bankAddedSuccess
                             : tr.upiAddedSuccess);

                          Navigator.pop(context);
                        } catch (e) {
                          toastMsg(tr.somethingWentWrong);
                        }
                      }
                    },
                    loading: isLoading,
                    child: ConstText(
                      text: tr.continueLabel,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.white,
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildToggleButtons(AppLocalizations tr) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: context.greyLightest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!_isBankAccount) {
                  setState(() {
                    _isBankAccount = true;
                    _upiNameController.clear();
                    _upiIdController.clear();
                    _reUpiIdController.clear();
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _isBankAccount ? context.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: ConstText(
                    text: tr.bankAccount,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _isBankAccount
                        ? context.white
                        : context.hintTextColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_isBankAccount) {
                  setState(() {
                    _isBankAccount = false;
                    _accountHolderController.clear();
                    _accountNumberController.clear();
                    _reAccountNumberController.clear();
                    _ifscController.clear();
                    _bankNameController.clear();
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: !_isBankAccount ? context.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: ConstText(
                    text: tr.upiId,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: !_isBankAccount
                        ? context.white
                        : context.hintTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountForm(AppLocalizations tr) {

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
          _buildSectionHeader(tr.fullName),
          AppSizes.spaceH(8),
          AppTextField(
            controller: _accountHolderController,
            hintText: tr.bankFormEnterNameHint,
            validator: AppValidator.validateName,
            inputFormatters: AppInputFormatters.nameOnly,

          ),
          AppSizes.spaceH(20),
          _buildSectionHeader(tr.bankFormAccountNumberLabel),
          AppSizes.spaceH(8),
          AppTextField(
            controller: _accountNumberController,
            hintText: tr.bankFormEnterAccountNumberHint,
            keyboardType: TextInputType.number,
            validator: AppValidator.validateAccount,
            inputFormatters: AppInputFormatters.accountNumber,

          ),
          AppSizes.spaceH(12),
          AppTextField(
            controller: _reAccountNumberController,
            hintText: tr.bankFormReEnterAccountNumberHint,
            keyboardType: TextInputType.number,
            inputFormatters: AppInputFormatters.accountNumber,
            validator: (value) {
              if (value != _accountNumberController.text) {
                return tr.bankFormAccountNumberMismatch;
              }
              return null;
            },
          ),
          AppSizes.spaceH(20),
          _buildSectionHeader(tr.bankFormIfscLabel),
          AppSizes.spaceH(8),
          AppTextField(
            controller: _ifscController,
            hintText: tr.bankFormEnterIfscHint,
            validator: AppValidator.validateIFSC,
            inputFormatters: AppInputFormatters.ifsc,
          ),
          AppSizes.spaceH(20),
          _buildSectionHeader(tr.bankFormBankNameLabel),
          AppSizes.spaceH(8),
          AppTextField(
            controller: _bankNameController,
            hintText: tr.bankFormEnterBankNameHint,
            validator: AppValidator.validateBankName,
            inputFormatters: AppInputFormatters.bankName,

          ),
        ],
      ),
    );
  }

  Widget _buildUpiForm(AppLocalizations tr) {
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
          _buildSectionHeader(tr.fullName),
          AppSizes.spaceH(8),
          AppTextField(
            controller: _upiNameController,
            hintText: tr.bankFormEnterNameHint,
            inputFormatters: AppInputFormatters.nameOnly,
            validator: AppValidator.validateName,
          ),
          AppSizes.spaceH(20),
          _buildSectionHeader(tr.upiId),
          AppSizes.spaceH(8),
          AppTextField(
            controller: _upiIdController,
            hintText: tr.upiFormEnterUpiIdHint,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return tr.upiFormUpiEmpty;
              if (!RegExp(
                r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$',
              ).hasMatch(value)) {
                return tr.upiFormUpiInvalid;
              }
              return null;
            },
          ),
          AppSizes.spaceH(12),
          AppTextField(
            controller: _reUpiIdController,
            hintText: tr.upiFormReEnterUpiIdHint,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != _upiIdController.text) return tr.upiFormUpiMismatch;
              return null;
            },
          ),
          AppSizes.spaceH(20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: context.greyLightest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ConstText(
              text: tr.upiFormNote,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: context.hintTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return ConstText(
      text: title,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: context.textPrimary,
    );
  }

  @override
  void dispose() {
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _reAccountNumberController.dispose();
    _ifscController.dispose();
    _bankNameController.dispose();
    _upiIdController.dispose();
    _reUpiIdController.dispose();
    super.dispose();
  }
}
