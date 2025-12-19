import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/onboarding/app_url_notifer.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/main.dart';

import '../splash/app_start_notifier.dart' show AppStartNotifier;

class OnBoardItem {
  final String imagePath;
  final String title;
  final String subtitle;

  OnBoardItem({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}

class OnBoardSlider extends StatefulWidget {
  const OnBoardSlider({super.key});

  @override
  State<OnBoardSlider> createState() => _OnBoardSliderState();
}

class _OnBoardSliderState extends State<OnBoardSlider> {
  int _current = 0;

  final List<OnBoardItem> items = [
    OnBoardItem(
      imagePath: Assets.imagesOnboarding1,
      title: "Drive & Earn",
      subtitle: "Upto ₹30,000/ month",
    ),
    OnBoardItem(
      imagePath: Assets.imagesOnboarding2,
      title: "Flexible Timings & Service",
      subtitle: "Book Ride with one tap",
    ),
    OnBoardItem(
      imagePath: Assets.imagesOnboarding3,
      title: "Safe & Reliable",
      subtitle: "Ride with trusted captains",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Slider
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            CarouselSlider.builder(
              itemCount: items.length,
              itemBuilder: (context, index, realIndex) {
                final item = items[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    // height: screenHeight * 0.63,
                  ),
                );
              },
              options: CarouselOptions(
                height: screenHeight * 0.76,
                viewportFraction: 1,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 1500),
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() => _current = index); // text updates immediately
                },
              ),
            ),
            Positioned(
              top: 20,
              left: 5,
              child: Image.asset(
               AppConstant.appLogoLightMode,
                height: 100.h,
                width: 120,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              width: screenWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.1, 1.0],
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ConstText(
                    text: items[_current].title,
                    color: AppColor.white,
                    fontSize: AppConstant.fontSizeLargeHeading,
                    fontWeight: AppConstant.bold,
                    letterHeight: 1,
                  ),
                  SizedBox(height: 7.h),
                  ConstText(
                    text: items[_current].subtitle,
                    fontSize: AppConstant.fontSizeThree,
                    color: Colors.white70,
                  ),


                  // Gradient + Text + Button overlay
                  Consumer(
                    builder: (context,ref,_) {
                      return AppBtn(
                        title: "Start Driving",
                        titleColor: Colors.black,
                        margin: AppPadding.screenPaddingV,
                        onTap: ()async{
                          await AppStartNotifier.setOnboardDone();
                          // ref.read(userAppUrlNotifierProvider.notifier).openInBrowser();
                          context.pushNamed(RoutesName.language,extra: true);
                        },
                      );
                    }
                  ),
                  // Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      items.length,
                      (index) => Container(
                        width: _current == index ? 8 : 6,
                        height: _current == index ? 8 : 6,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Colors.white
                              : AppColor.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
