import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';

class ImagePickerHelper {
  /// 🔹 Pick image from Camera or Gallery with permission check
  static Future<File?> pickImage(BuildContext context) async {
    final source = await _showPickerBottomSheet(context);
    if (source == null) return null;
    //
    // final hasPermission = await _checkPermissions(source);
    // if (!hasPermission) return null;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
      maxHeight: 1200,
    );

    return pickedFile != null ? File(pickedFile.path) : null;
  }

  /// 🔹 Bottom Sheet (Camera/Gallery)
  static Future<String?> _showPickerBottomSheet(BuildContext context) async {
    return await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,

      builder: (context) => CommonBottomSheet(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              minTileHeight: 0,
              leading: const Icon(Icons.camera_alt),
              title:  ConstText(text: "Take Photo",fontSize: AppConstant.fontSizeThree,fontWeight: AppConstant.semiBold,),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            Divider(thickness: 0.3,color:AppColor.grey ,),
            ListTile(
              minTileHeight: 0,
              leading: const Icon(Icons.photo_library),
              title:  ConstText(text:"Choose from Gallery",fontSize: AppConstant.fontSizeThree,fontWeight: AppConstant.semiBold,),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Permission check
  static Future<bool> _checkPermissions(String source) async {
    if (source == 'camera') {
      // Camera Permission
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        status = await Permission.camera.request();
      }
      return status.isGranted;
    } else {
      // Gallery Permission
      if (Platform.isIOS) {
        // iOS → Photos
        var status = await Permission.photos.status;
        if (!status.isGranted) {
          status = await Permission.photos.request();
        }
        return status.isGranted;
      } else {
        // Android → First check READ_MEDIA_IMAGES (API 33+)
        if (await Permission.photos.isGranted) {
          return true;
        }
        var photoStatus = await Permission.photos.request();
        if (photoStatus.isGranted) {
          return true;
        }

        // Fallback → Android 12 और नीचे → Storage
        if (await Permission.storage.isGranted) {
          return true;
        }
        var storageStatus = await Permission.storage.request();
        return storageStatus.isGranted;
      }
    }
  }
}
