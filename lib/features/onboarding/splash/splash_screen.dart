import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/utils/navigation_helper.dart';
import 'package:rider_pay_driver/core/widget/location_on_popup.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/location_provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/utils/navigation_helper.dart';
import 'package:rider_pay_driver/core/widget/location_on_popup.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/location_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with WidgetsBindingObserver {
  bool _navigated = false;
  double _progress = 0.0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationProvider.notifier).initLocation();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(locationProvider.notifier).initLocation();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startProgressAnimation() {
    _progressTimer?.cancel();
    _progress = 0;
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_progress < 0.9) {
        setState(() => _progress += 0.05);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locState = ref.watch(locationProvider);
    ref.listen<LocationState>(locationProvider, (prev, next) {
      if (next.isFetching) {
        _startProgressAnimation();
      }

      if (!_navigated && next.isReady) {
        _navigated = true;

        // Complete loader animation smoothly
        setState(() => _progress = 1.0);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Future.delayed(const Duration(milliseconds: 400), () {
              NextRouteDecider.goNextAfterProfileCheck(context, ref);
            });
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: context.greyLightest,
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// 🔹 Main Column Layout
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// App Logo
              Padding(
                padding: AppPadding.screenPadding,
                child: Image.asset(
                  AppConstant.appLogoLightMode,
                  // height: 120, // optional size tweak
                ),
              ),

               // SizedBox(height: 60.h),

              /// Loader + Text
              if (locState.isFetching || locState.currentPosition == null)
                AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: _progress,
                              strokeWidth: 5,
                              valueColor:
                              AlwaysStoppedAnimation(context.primary),
                              backgroundColor:
                              context.greyLight.withOpacity(0.2),
                            ),
                            Text(
                              "${(_progress * 100).toInt()}%",
                              style: TextStyle(
                                color: context.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _progress < 0.5
                            ? "Checking permissions..."
                            : _progress < 0.9
                            ? "Fetching current location..."
                            : "Almost done...",
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: AppConstant.fontSizeTwo,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          /// 🔹 Location Popup (top priority)
          if (!locState.isServiceOn || !locState.isPermissionGranted)
            Center(
              child: LocationOnPopup(
                isBlocked: !locState.isPermissionGranted,
                isServiceOff: !locState.isServiceOn,
                onAction: () async {
                  _startProgressAnimation();
                  await Future.delayed(const Duration(milliseconds: 500));
                  await ref.read(locationProvider.notifier).initLocation();
                },
              ),
            ),
        ],
      ),
    );
  }
}

