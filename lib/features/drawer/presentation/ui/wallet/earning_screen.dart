// earnings_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/features/cashfree_payment/admin_transaction_notifier.dart';
import 'package:rider_pay_driver/features/drawer/presentation/notifier/credit_withdraw_history_notifier.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/wallet/widget/admin_payment.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/wallet/widget/all_earning_tab.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/wallet/widget/wallet_tab.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/complete_ride_notifier.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/l10n/app_localizations_en.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';



class EarningsPage extends ConsumerStatefulWidget {
  const EarningsPage({super.key});

  @override
  ConsumerState<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends ConsumerState<EarningsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAllData();

      // final driverId= ref.read(userProvider.notifier).userId;
      // ref.read(completeRideProvider.notifier).getDriverEarningApi(driverId.toString());
      // ref.read(creditWithdrawHistoryProvider.notifier).fetchCreditWithdrawHistory(driverId.toString());
      // ref.read(adminTransactionProvider.notifier).adminTransactionApi(driverId.toString());

    });
    super.initState();
  }

  Future<void> _fetchAllData() async {
    final driverId = ref.read(userProvider.notifier).userId.toString();

    await Future.wait([
      ref.read(completeRideProvider.notifier).getDriverEarningApi(driverId),
      ref.read(profileProvider.notifier).getProfile(),
      ref.read(creditWithdrawHistoryProvider.notifier).fetchCreditWithdrawHistory(driverId),
      ref.read(adminTransactionProvider.notifier).adminTransactionApi(driverId),
    ]);
  }


  @override
  Widget build(BuildContext context) {
    final tr= AppLocalizations.of(context)!;
    return SafeArea(
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
                    text: tr.earnings,
                    fontSize: AppConstant.fontSizeThree,
                    fontWeight: AppConstant.semiBold,
                    color: context.textPrimary,
                  ),
                  const Spacer(),
                  CommonIconTextButton(
                    text:tr.help,
                    imagePath: Assets.iconHelpIc,
                    imageColor: context.black,
                    onTap: () {
                      context.push(RoutesName.supportScreen);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            AppSizes.spaceH(15),
            TabBar(
              controller: _tabController,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    width: 5, color: context.primary,



                ),

                borderRadius: BorderRadius.circular(8),
                insets: EdgeInsets.symmetric(horizontal: 24.w),
              ),
              dividerColor: Colors.transparent,
              labelColor: context.docBlue,
              unselectedLabelColor: context.hintTextColor,
              labelStyle:  TextStyle(fontWeight:AppConstant.semiBold),
              unselectedLabelStyle: const TextStyle(fontWeight: AppConstant.medium),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs:  [
                Tab(child: ConstText(text:tr.allEarnings,fontSize: AppConstant.fontSizeThree,color: context.textPrimary,)),
                Tab(child: ConstText(text:tr.wallet,fontSize: AppConstant.fontSizeThree,color: context.textPrimary,)),
                Tab(child: ConstText(text:tr.adminDue,fontSize: AppConstant.fontSizeThree,color: context.textPrimary,))
              ],
            ),
            AppSizes.spaceH(15),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  RefreshIndicator(
                    onRefresh: _fetchAllData,
                    color: context.primary,
                    child: const AllEarningsTab(),
                  ),
                  RefreshIndicator(
                    onRefresh: _fetchAllData,
                    color: context.primary,
                    child: const EarningWalletTab(),
                  ),
                  RefreshIndicator(
                    onRefresh: _fetchAllData,
                    color: context.primary,
                    child: AdminPayment(),
                  ),
                ],
              ),
            ),            ],
        ),
      ),
    );
  }
}







