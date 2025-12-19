import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_box.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/drawer/presentation/notifier/get_performance_notifier.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';

class PerformanceScreen extends ConsumerStatefulWidget {
  const PerformanceScreen({super.key});

  @override
  ConsumerState<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends ConsumerState<PerformanceScreen> {
  @override
  void initState() {
    super.initState();
    /// 🔹 Call the API here
    WidgetsBinding.instance.addPostFrameCallback((_){
      final userId= ref.read(userProvider)?.id.toString()??"";
      if(userId.isNotEmpty){
        ref.read(getPerformanceProvider.notifier).getPerformanceApi(driverId:userId.toString());

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getPerformanceProvider);
    final tr =AppLocalizations.of(context)!;

    final performance = state.data?.data?.performance;
    final total = performance?.totalBookings ?? 0;
    final completed = performance?.completedBookings ?? 0;
    final cancelled = performance?.cancelledBookings ?? 0;
    final ongoing = performance?.ongoingBookings ?? 0;

    double percent = total == 0 ? 0 : completed / total;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            CommonTopBar(
              child: Row(
                children: [
                  const ConstAppBackBtn(),
                  AppSizes.spaceW(15),
                  ConstText(
                    text: tr.myPerformance,
                    fontSize: AppConstant.fontSizeThree,
                    fontWeight: AppConstant.semiBold,
                    color: context.textPrimary,
                  ),
                  const Spacer(),
                  CommonIconTextButton(
                    text: tr.help,
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
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            /// 🔹 Progress Card
            CommonBox(
              child: Column(
                children: [
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: CustomCircularIndicator(
                      percent: percent,
                      current: completed.toDouble(),
                      total: total.toDouble(),
                    ),
                  ),
                  AppSizes.spaceH(12),
                  ConstText(
                    text: tr.acceptOrders(total.toString()),
                    fontSize: AppConstant.fontSizeThree,
                    fontWeight: AppConstant.bold,
                    color: context.textPrimary,
                  ),
                  ConstText(
                    text: tr.youHaveCompletedOrders(completed.toString()),
                    fontSize: AppConstant.fontSizeOne,
                    color: context.textSecondary,
                  ),
                  AppSizes.spaceH(8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    color: context.primary.withAlpha(40),
                    child: ConstText(
                      text: tr.bikeLiteText,
                      fontSize: AppConstant.fontSizeSmall,
                      color: context.textPrimary,
                      fontWeight: AppConstant.semiBold,
                    ),
                  ),
                ],
              ),
            ),

            AppSizes.spaceH(16),

            /// 🔹 Accepted & Cancelled Orders
            CommonBox(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildStat(
                          completed.toString(),
                          tr.acceptedOrders,
                          context,
                          context.textPrimary,
                        ),
                      ),
                      AppSizes.spaceW(15),
                      Expanded(
                        child: _buildStat(
                          cancelled.toString(),
                          tr.cancelledOrders,
                          context,
                          context.error,
                        ),
                      ),
                    ],
                  ),
                  AppSizes.spaceH(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstText(
                        text: tr.completedOrders,
                        fontSize: AppConstant.fontSizeThree,
                        fontWeight: AppConstant.semiBold,
                        color: context.textPrimary,
                      ),
                      ConstText(
                        text: completed.toString(),
                        fontSize: AppConstant.fontSizeThree,
                        fontWeight: AppConstant.semiBold,
                        color: context.success,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppSizes.spaceH(16),

            /// 🔹 Performance Tips

            CommonBox(
              borderColor: context.docBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstText(
                    text: tr.goodPerformanceTitle,
                    fontSize: AppConstant.fontSizeTwo,
                    fontWeight: AppConstant.medium,
                  ),
                  AppSizes.spaceH(12),
                  Row(
                    children: [
                      const Icon(Icons.cancel, color: Colors.red),
                      AppSizes.spaceW(10),
                      ConstText(
                        text: tr.tipNoCancel,
                        fontSize: AppConstant.fontSizeTwo,
                        color: context.textPrimary,
                        fontWeight: AppConstant.semiBold,
                      ),
                    ],
                  ),
                  AppSizes.spaceH(8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      AppSizes.spaceW(10),
                      ConstText(
                        text: tr.tipFiveStar,
                        fontSize: AppConstant.fontSizeTwo,
                        color: context.textPrimary,
                        fontWeight: AppConstant.semiBold,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppSizes.spaceH(16),

            /// 🔹 Training Video Placeholder
            CommonBox(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      Assets.imagesOnboarding3,
                      fit: BoxFit.cover,
                      height: 200.h,
                      width: double.infinity,
                    ),
                  ),
                  AppSizes.spaceH(12),
                  ConstText(
                    text: tr.earnMoreTitle,
                    fontSize: AppConstant.fontSizeTwo,
                    color: context.textPrimary,
                    fontWeight: AppConstant.semiBold,
                  ),
                  AppSizes.spaceH(12),
                  // AppBtn(
                  //   height: 40.h,
                  //   color: Colors.transparent,
                  //   border: Border.all(color: context.docBlue, width: 1),
                  //   titleColor: context.docBlue,
                  //   title: tr.knowMore,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
      String value, String label, BuildContext context, Color color) {
    return Container(
      padding: AppPadding.screenPadding,
      color: context.surface,
      child: Column(
        children: [
          ConstText(
            text: value,
            fontSize: AppConstant.fontSizeHeading,
            fontWeight: AppConstant.semiBold,
            color: color,
          ),
          ConstText(
            text: label,
            fontSize: AppConstant.fontSizeSmall,
            color: color,
          ),
        ],
      ),
    );
  }
}
class CustomCircularIndicator extends StatelessWidget {
  final double percent;
  final double current;
  final double total;

  const CustomCircularIndicator({
    super.key,
    required this.percent,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(120, 120),
            painter: _CirclePainter(
              percent: percent,
              bgColor: context.primary.withAlpha(50),
              progressColor: context.primary,
              strokeWidth: 12,
            ),
          ),

          // Center Text
          ConstText(
            text: "${current.toInt()}/${total.toInt()}",
            fontSize: AppConstant.fontSizeThree,
            fontWeight: AppConstant.semiBold,
            color: context.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double percent;
  final Color bgColor;
  final Color progressColor;
  final double strokeWidth;

  _CirclePainter({
    required this.percent,
    required this.bgColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;

    final backgroundPaint = Paint()
      ..color = bgColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Full circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final sweepAngle = 2 * 3.1415926535 * percent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.1415926535 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
