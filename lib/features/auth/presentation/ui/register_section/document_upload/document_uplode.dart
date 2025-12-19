import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart' show AppBtn;
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart' show AppConstant;
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/app_text_field.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/constant/custom_slider_dialog.dart';
import 'package:rider_pay_driver/core/res/validator/app_input_formatters.dart';
import 'package:rider_pay_driver/core/res/validator/app_validator.dart';
import 'package:rider_pay_driver/core/services/image_picker_helper.dart';
import 'package:rider_pay_driver/core/utils/navigation_helper.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/core/widget/success_reject_popup.dart';
import 'package:rider_pay_driver/features/auth/presentation/notifier/upload_document_notifier.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';



class DocumentUploadScreen extends StatefulWidget {
  final String docType;

  const DocumentUploadScreen({super.key, required this.docType});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final TextEditingController _textController = TextEditingController();
  File? _selectedFile;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _textController.removeListener(_checkFormValidity);
    _textController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    final docNumber = _textController.text.trim();
    final isValidNumber = AppValidator.validateDocument(docNumber, widget.docType) == null;
    final hasFile = _selectedFile != null;

    setState(() {
      isFormValid = isValidNumber && hasFile;
    });
  }

  Map<String, dynamic> getDocumentDetails(AppLocalizations tr) {
    final docType = (widget.docType).toLowerCase();
    switch (docType) {
      case "license":
        return {
          'title': tr.drivingLicense,
          'subtitle':tr.uploadDrivingLicense,
          'hintText': tr.enterDrivingLicenseNumber,
          'instructions':tr.drivingLicenseInstructions,
          // "1. Upload back side of Driving Licence first if some information is present on back side before the front side upload\n\n"
          //     "2. Make sure that your driver license validates the class of vehicle you are choosing to drive\n\n"
          //     "3. Make sure License number, Driving License Type, your Address, Father's Name, D.O.B, Expiration Date and Govt logo on the License are clearly visible and the photo is not blurred",
          'image': Assets.imagesDlImage,
          'captureHint': tr.captureDrivingLicense,
        };
      case "aadhar":
        return {
          'title': tr.aadhaarCard,
          'subtitle': tr.uploadAadhaar,
          'hintText': tr.enterAadhaarNumber,
          'instructions': tr.aadhaarInstructions,
          'image': Assets.imagesAadhaarCard,
          'captureHint': tr.captureAadhaar,
        };
      case "vehicle":
        return {
          'title': tr.vehicleRegistration,
          'subtitle': tr.enterVehicleDetails,
          'hintText': tr.enterVehicleNumber,
          'instructions': tr.vehicleInstructions,
          'image': Assets.imagesRcImage,
          'captureHint': tr.captureVehicle,
        };
      default:
        return {
          'title': tr.documentUpload,
          'subtitle': tr.uploadDocument,
          'hintText': tr.enterDrivingLicenseNumber,
          'instructions': "",
          'image': null,
          'captureHint': tr.tapToUpload,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final documentDetails = getDocumentDetails(tr);

    return Scaffold(
      backgroundColor: context.surface,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Top Bar
            CommonTopBar(
              background: context.surface,
              child: Row(
                children: [
                  const ConstAppBackBtn(),
                  AppSizes.spaceW(12),
                  Expanded(
                    child: ConstText(
                      text: documentDetails["title"],
                      fontWeight: AppConstant.semiBold,
                      color: context.textPrimary,
                      fontSize: AppConstant.fontSizeThree,
                    ),
                  ),
                  AppSizes.spaceW(10),
                  CommonIconTextButton(
                    text: tr.help,
                    imagePath: Assets.iconHelpIc,
                    imageColor: context.black,
                    onTap: () => context.pushNamed(RoutesName.supportScreen),
                  ),
                ],
              ),
            ),

            /// 🔹 Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title & Instructions
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstText(
                          text: documentDetails['subtitle'],
                          fontSize: AppConstant.fontSizeLarge,
                          fontWeight: AppConstant.bold,
                          color: context.textPrimary,
                        ),
                        AppSizes.spaceH(8),
                        if (documentDetails['instructions'] != null)
                          ConstText(
                            text: documentDetails['instructions'],
                            fontSize: AppConstant.fontSizeOne,
                            color: context.hintTextColor,
                          ),
                      ],
                    ),

                    AppSizes.spaceH(24),

                    /// Example Image
                    if (documentDetails['image'] != null)
                      Container(
                        height: 120.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: context.white,
                          boxShadow: [
                            BoxShadow(
                              color: context.black.withAlpha(10),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            documentDetails['image'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                    AppSizes.spaceH(24),

                    /// Text Input Field
                    AppTextField(
                      labelText: documentDetails['hintText'] ?? "",
                      showClearButton: false,
                      controller: _textController,
                      validator: (value) => AppValidator.validateDocument(value, widget.docType),
                      keyboardType: widget.docType.toLowerCase() == 'aadhar'
                          ? TextInputType.number
                          : TextInputType.text,
                      textCapitalization: widget.docType.toLowerCase() == 'vehicle' || widget.docType.toLowerCase() == 'license'
                          ? TextCapitalization.characters
                          : TextCapitalization.none,
                      inputFormatters: AppInputFormatters.getFormatter(widget.docType),

                    ),

                    AppSizes.spaceH(24),

                    /// Upload Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ConstText(
                              text:tr.uploadDocument,
                              fontSize: AppConstant.fontSizeTwo,
                              fontWeight: AppConstant.semiBold,
                              color: context.textPrimary,
                            ),
                            AppSizes.spaceW(6),
                            ConstText(
                              text: "*",
                              fontSize: AppConstant.fontSizeTwo,
                              fontWeight: AppConstant.semiBold,
                              color: context.error,
                            ),
                          ],
                        ),
                        AppSizes.spaceH(8),
                        ConstText(
                          text: tr.takeClearPhoto,
                          fontSize: AppConstant.fontSizeZero,
                          color: context.hintTextColor,
                        ),
                        AppSizes.spaceH(12),

                        /// Upload Box
                        _buildUploadBox(tr),

                        /// File Info
                        if (_selectedFile != null) ...[
                          AppSizes.spaceH(8),
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: context.success,
                              ),
                              AppSizes.spaceW(6),
                              Expanded(
                                child: ConstText(
                                  text: _selectedFile!.path.split('/').last,
                                  fontSize: AppConstant.fontSizeZero,
                                  color: context.success,
                                  maxLine: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),

                    AppSizes.spaceH(32),

                    /// Submit Button
                    Consumer(
                      builder: (context, ref, _) {
                        final state = ref.watch(documentUploadProvider);
                        final provider = ref.read(documentUploadProvider.notifier);
                        final userId = ref.read(userProvider)?.id ?? 0;

                        return AppBtn(
                          loading: state.isLoading,
                          isDisabled: !isFormValid || state.isLoading,
                          onTap: isFormValid
                              ? () async {
                            final isDocumentUpload = await provider.uploadDocument(
                              driverId: userId.toString(),
                              docType: widget.docType,
                              docNumber: _textController.text.toString(),
                              frontImgPath: _selectedFile!.path,
                            );

                            if (!context.mounted) return;

                            if (isDocumentUpload) {

                              CustomSlideDialog.show(
                                dismissible: false,
                                context: context,
                                child: SuccessRejectPopup(
                                  isReject: false,
                                  onAction: () {
                                    context.pop();
                                  },
                                  title: tr.documentUploaded,
                                  subtitle: tr.documentUploadedSuccessfully(widget.docType)

                                  ,
                                ),
                              );

                              await Future.delayed(Duration(seconds: 1));
                              await NextRouteDecider.goNextAfterProfileCheck(context, ref);
                            }
                          }
                              : null,
                          title:tr.submitDocument,
                        );
                      },
                    ),
                    AppSizes.spaceH(15),

                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  /// 🔹 Build Upload Box with Better UI
  Widget _buildUploadBox(AppLocalizations tr) {
    return GestureDetector(
      onTap: () async {
        final file = await ImagePickerHelper.pickImage(context);
        if (file != null && mounted) {
          setState(() => _selectedFile = file);
          _checkFormValidity(); // check after file pick
        }
      },
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedFile != null
                ? context.success
                : context.hintTextColor.withAlpha(40),
            width: _selectedFile != null ? 2 : 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          color: _selectedFile != null
              ? context.success.withAlpha(50)
              : context.white,
        ),
        child: _selectedFile == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 40,
              color: context.hintTextColor,
            ),
            AppSizes.spaceH(8),
            ConstText(
              text:tr.tapToUpload,
              fontWeight: AppConstant.medium,
              color: context.hintTextColor,
            ),
            AppSizes.spaceH(4),
            ConstText(
              text:tr.fileFormatInfo,
              fontSize: AppConstant.fontSizeZero,
              color: context.hintTextColor.withAlpha(70),
            ),
          ],
        )
            : Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                _selectedFile!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedFile = null);
                  _checkFormValidity();
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: context.error.withAlpha(90),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: context.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
