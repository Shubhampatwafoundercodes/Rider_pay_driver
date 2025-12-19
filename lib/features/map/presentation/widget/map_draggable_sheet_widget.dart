import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/data/model/ride_booking_model.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/main.dart';

class MapDraggableSheetWidget extends ConsumerStatefulWidget {
  const MapDraggableSheetWidget({super.key});

  @override
  ConsumerState<MapDraggableSheetWidget> createState() => _MapDraggableSheetWidgetState();
}

class _MapDraggableSheetWidgetState extends ConsumerState<MapDraggableSheetWidget> {
  double _sheetExtent = 0.3;
  // Example statuses list
  final List<Map<String, dynamic>> rideStatuses = [
    {"title": "Accepted", "icon": Icons.check, "active": true},
    {"title": "On Way", "icon": Icons.motorcycle, "active": false},
    {"title": "Arrived", "icon": Icons.location_on, "active": false},
    {"title": "In Progress", "icon": Icons.directions_car, "active": false},
    {"title": "Completed", "icon": Icons.flag, "active": false},
  ];

  @override
  Widget build(BuildContext context) {
    final tr=AppLocalizations.of(context)!;
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.3,
      maxChildSize: 0.4,
      builder: (context, scrollController) {
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            setState(() => _sheetExtent = notification.extent);
            return true;
          },
          child: Container(
            // padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.popupBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(08.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              controller: scrollController,
              children: [
                /// Drag Handle Arrow
                AppSizes.spaceH(5),
                Center(
                  child: Image.asset(
                    _sheetExtent < 0.35
                        ? Assets.iconUpArrow
                        : Assets.iconDownArrow,
                    height: 30,
                    color: Colors.grey.shade500,
                  ),
                ),
                 Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: screenHeight * 0.12,
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     padding: const EdgeInsets.symmetric(horizontal: 16),
                //     itemCount: rideStatuses.length,
                //     itemBuilder: (context, index) {
                //       final status = rideStatuses[index];
                //       final isActive = status["active"] as bool;
                //
                //       return GestureDetector(
                //         onTap: () {},
                //         child: Container(
                //           margin: const EdgeInsets.only(right: 12),
                //           child: Column(
                //             children: [
                //               Container(
                //                 alignment: AlignmentGeometry.center,
                //                 padding: EdgeInsets.all(08),
                //                 width: 60,
                //                 height: 60,
                //                 decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   border: Border.all(
                //                     color: isActive
                //                         ? Colors.blue
                //                         : Colors.grey.shade300,
                //                     width: 2,
                //                   ),
                //                   color: Colors.white,
                //                 ),
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                     image: DecorationImage(
                //                       image: AssetImage(
                //                         Assets.imagesDlImage,
                //                       ),
                //                       fit: BoxFit.fill,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               AppSizes.spaceH(5),
                //               ConstText(
                //                 text: status["title"] as String,
                //                 fontSize: 12,
                //                 color: isActive
                //                     ? Colors.blue
                //                     : Colors.black54,
                //                 maxLine: 1,
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                //
                // // Divider below
                // Divider(
                //   thickness: 0.3,
                //   color: context.hintTextColor,
                //   height: 20.h,
                // ),
                AppSizes.spaceH(20),
                Center(
                  child: ConstText(
                    text: tr.proudlyMade,
                    fontSize: AppConstant.fontSizeSmall,
                    fontWeight: AppConstant.semiBold,
                    letterHeight: 0,
                  ),
                ),
                Center(
                  child: ConstText(
                    text: tr.inIndia,
                    letterHeight: 0,
                    color: context.textPrimary,
                    fontSize: AppConstant.fontSizeLarge,
                    fontWeight: AppConstant.semiBold,
                  ),
                ),
                AppSizes.spaceH(10),
                // Spacer(),
                Image.asset(
                  Assets.imagesDragableSheetImage,
                  height: screenHeight * 0.15,
                  width: screenWidth,
                  fit: BoxFit.fill,
                ),
              ],
            ),


              ],
            ),
          ),




        );
      },
    );
  }


}
