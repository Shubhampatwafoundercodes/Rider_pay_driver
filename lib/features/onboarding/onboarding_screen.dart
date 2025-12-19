import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_border.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/features/onboarding/app_url_notifer.dart';
import 'package:rider_pay_driver/features/onboarding/widget/onboard_slider_widget.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/main.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {

  @override
  void initState() {
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_){
     ref.read(userAppUrlNotifierProvider.notifier).fetchUserAppUrl();

    });

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              OnBoardSlider(),
              AppSizes.spaceH(10),
              ConstText(
                text: "OR",
                fontWeight: AppConstant.semiBold,
                fontSize: AppConstant.fontSizeThree,
              ),
              GestureDetector(
                onTap: ()async{
               await ref.read(userAppUrlNotifierProvider.notifier).openInBrowser();

                },
                child: Container(
                  // height: screenHeight * 0.1,
                  margin: AppPadding.screenPadding,
                  decoration: BoxDecoration(
                    borderRadius: AppBorders.mediumRadius,
                    border: Border.all(
                      color: Colors.lightBlue.withAlpha(100),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ConstText(
                              text: "Customer?",
                              color: context.textSecondary,
                              fontWeight: AppConstant.bold,
                              fontSize: AppConstant.fontSizeLarge,
                            ),
                            ConstText(
                              text: "Book Ride",
                              color: Colors.blue,
                              fontSize: AppConstant.fontSizeOne,
                              fontWeight: AppConstant.semiBold,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                              size: 17.h,
                              weight: 30,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>MapBookingDetails()));
                        },
                        child: Container(
                          height: screenHeight * 0.12,
                          width: screenWidth * 0.36,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.imagesOnboarding1),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(18.r),
                              bottomRight: Radius.circular(18.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
