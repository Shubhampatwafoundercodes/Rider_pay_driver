import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/format/date_time_formater.dart';
import 'package:rider_pay_driver/features/drawer/presentation/notifier/notification_api_notifer.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/main.dart';


class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationApiProvider.notifier).notificationApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final state = ref.watch(notificationApiProvider);
    final notifications = state.notificationModelData?.data ?? [];

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: context.greyLightest,
        appBar: AppBar(
          leading: CommonTopBar(
            background: context.white,
            showShadow: true,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstAppBackBtn(),
                SizedBox(width: 15.w),
                ConstText(
                  text: t.notifications,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                  fontSize: AppConstant.fontSizeThree,
                ),
              ],
            ),
          ),
          leadingWidth: screenWidth,
        ),

        body: Builder(
          builder: (context) {
            /// Condition handling cleanly
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (notifications.isEmpty) {
              return const Center(
                child: ConstText(text: "No notifications found."),
              );
            }

            /// Notifications List
            return ListView.builder(
              padding: AppPadding.screenPaddingH,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Circle Dot
                      Container(
                        margin: EdgeInsets.only(top: 6.h, right: 12.w),
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent,
                        ),
                      ),

                      /// Notification Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstText(
                              text: item.title ?? "No title",
                              fontWeight: AppConstant.semiBold,
                              fontSize: AppConstant.fontSizeTwo,
                            ),
                            SizedBox(height: 4.h),
                            ConstText(
                              text: item.description ?? "",
                              fontSize: AppConstant.fontSizeTwo,
                              color: context.textSecondary,
                            ),
                            SizedBox(height: 6.h),
                            ConstText(
                              text: DateTimeFormat.formatFullDateTime(
                                item.datetime.toString(),
                              ),
                              fontSize: AppConstant.fontSizeZero,
                              color: context.hintTextColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
