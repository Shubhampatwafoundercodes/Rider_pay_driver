import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/drawer/presentation/notifier/support_fq_notifier.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(supportFqProvider.notifier).supportFqApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final state = ref.watch(supportFqProvider);

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: context.greyLight,
        body: Column(
          children: [
            AppSizes.spaceH(30),
            CommonTopBar(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(Icons.arrow_back, color: context.textPrimary),
                  ),
                  const Spacer(),
                  ConstText(
                    text: tr.support,
                    color: context.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: AppConstant.fontSizeThree,
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            /// 🔹 Loader + Empty + List UI
            if (state.isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.data == null || state.data!.data.isEmpty)
              const Expanded(
                child: Center(
                  child: ConstText(text: "No FAQs available"),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  padding: AppPadding.screenPadding,
                  itemCount: state.data!.data.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final item = state.data!.data[index];
                    return GestureDetector(
                      onTap: () {
                        // ✅ Pass full model object
                        context.pushNamed(
                          RoutesName.supportDetailsScreen,
                          extra: item,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        decoration: BoxDecoration(
                          color: context.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ConstText(
                                text: item.question ?? '',
                                fontSize: AppConstant.fontSizeTwo,
                                fontWeight: FontWeight.w500,
                                color: context.textSecondary,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16.h,
                              color: context.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
