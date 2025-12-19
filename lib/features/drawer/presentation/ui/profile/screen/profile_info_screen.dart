
  import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:go_router/go_router.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:intl/intl.dart';
  import 'package:rider_pay_driver/core/res/app_btn.dart';
  import 'package:rider_pay_driver/core/res/app_color.dart';
  import 'package:rider_pay_driver/core/res/app_constant.dart';
  import 'package:rider_pay_driver/core/res/app_size.dart';
  import 'package:rider_pay_driver/core/res/constant/common_bottom_sheet.dart';
  import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
  import 'package:rider_pay_driver/core/res/constant/common_network_img.dart';
  import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
  import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
  import 'package:rider_pay_driver/core/res/constant/const_text.dart';
  import 'package:rider_pay_driver/core/res/constant/custom_slider_dialog.dart';
import 'package:rider_pay_driver/core/res/validator/app_input_formatters.dart' show AppInputFormatters;
import 'package:rider_pay_driver/core/res/validator/app_validator.dart';
  import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
  import 'package:rider_pay_driver/core/widget/success_reject_popup.dart';
  import 'package:rider_pay_driver/features/drawer/presentation/notifier/update_profile_notifier.dart';
  import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
  import 'package:rider_pay_driver/generated/assets.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:go_router/go_router.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:intl/intl.dart';
  import 'package:rider_pay_driver/core/res/app_btn.dart';
  import 'package:rider_pay_driver/core/res/app_color.dart';
  import 'package:rider_pay_driver/core/res/app_constant.dart';
  import 'package:rider_pay_driver/core/res/app_size.dart';
  import 'package:rider_pay_driver/core/res/constant/common_bottom_sheet.dart';
  import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
  import 'package:rider_pay_driver/core/res/constant/common_network_img.dart';
  import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
  import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
  import 'package:rider_pay_driver/core/res/constant/const_text.dart';
  import 'package:rider_pay_driver/core/res/constant/custom_slider_dialog.dart';
  import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
  import 'package:rider_pay_driver/core/widget/success_reject_popup.dart';
  import 'package:rider_pay_driver/features/drawer/presentation/notifier/update_profile_notifier.dart';
  import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
  import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';

  class ProfileInfoScreen extends ConsumerStatefulWidget {
    const ProfileInfoScreen({super.key});

    @override
    ConsumerState<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
  }
  class _ProfileInfoScreenState extends ConsumerState<ProfileInfoScreen> {
    List<String> selectedLanguages = ["English", "Hindi"];

    @override
    Widget build(BuildContext context) {

      final tr=AppLocalizations.of(context)!;
      final profileState = ref.watch(profileProvider);
      final updateN = ref.watch(updateProfileProvider.notifier);
      final driver = profileState.profile?.data?.driver;
      final documents = profileState.profile?.data?.documents ?? [];

      final name = driver?.name ?? "";
      final phone = driver?.phone ?? "";
      final gender = driver?.gender ?? "";
      final address = driver?.address ?? "";
      final dob = driver?.dob ?? "";
      final img = driver?.img ?? "";

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
                      text: tr.profileInfo,
                      fontSize: AppConstant.fontSizeThree,
                      fontWeight: AppConstant.semiBold,
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
          body: profileState.isLoadingProfile
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
            onRefresh: () async {
              await ref.read(profileProvider.notifier).getProfile();
            },
            color: context.primary,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              children: [
                /// Profile photo
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        height: 100.h,
                        width: 100.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: context.primary, width: 2),
                        ),
                        child: ClipOval(
                          child: img.isNotEmpty
                              ? CommonNetworkImage(
                            imageUrl: img ,
                            fit: BoxFit.cover,
                          )
                              : const Icon(Icons.person, size: 60),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _showImagePickerDialog( updateN, ref,tr),
                          child: Container(
                            height: 30.w,
                            width: 30.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.primary,
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                AppSizes.spaceH(25),

                /// Editable fields
                _buildEditableField(tr, tr.name, name, ref, "name"),

                /// Phone number (non-editable)
                _buildField(context, label: tr.phone, value: phone, editable: false,t: tr),

                /// Gender editable text (dropdown add later)
                _buildGenderField(tr, gender, ref),
                // _buildAddressField(context, address, ref),

                /// DOB picker
                _buildDOBField(tr, dob, ref),

                /// Languages section
                GestureDetector(
                  onTap: () async {
                    final result = await context.push<List<String>>(
                        RoutesName.languageSpeakScreen);
                    if (result != null && result.isNotEmpty) {
                      setState(() {
                        selectedLanguages = result;
                      });
                    }
                  },
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      _buildField(
                        context,
                        label: tr.languagesSpeak,
                        value: selectedLanguages.join(", "),
                        editable: false,
                        t: tr
                      ),
                      Icon(Icons.arrow_forward_ios_rounded,
                          color: context.hintTextColor, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    /// 📸 Camera / Gallery chooser dialog
    void _showImagePickerDialog(
        UpdateProfileNotifier updateN, WidgetRef ref,AppLocalizations tr) async
    {
      final picker = ImagePicker();

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading:  Icon(Icons.camera_alt),
                title:  ConstText(text: tr.takePhoto),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? file = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                    preferredCameraDevice: CameraDevice.front,
                  );
                  if (file != null) {
                    _updateProfileImage(file.path, updateN, ref,tr);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title:  ConstText(text: tr.chooseGallery),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? file =
                  await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                  if (file != null) {
                    _updateProfileImage(file.path, updateN, ref, tr);
                  }
                },
              ),
            ],
          ),
        ),
      );
    }



    Future<void> _updateProfileImage(String path,
        UpdateProfileNotifier updateN, WidgetRef ref, AppLocalizations tr) async {
      final success = await updateN.updateProfile(field: "img", value: path);
      if (success) {
        CustomSlideDialog.show(
          // dismissible: false,
          context: context,
          child: SuccessRejectPopup(
            isReject: false,
            title: tr.profileUpdated,
            subtitle: tr.profileImageUpdated,
            onAction: () {
              context.pop();
              // ref.read(profileProvider.notifier).getProfile();
            },
          ),
        );
      }
    }

    Widget _buildEditableField(AppLocalizations tr, String label, String value,
        WidgetRef ref, String fieldKey)
    {
      final updateNotifier = ref.read(updateProfileProvider.notifier);

      return _buildField(
        context,
        label: label,
        value: value,
        editable: true,
        t: tr,
        onEdit: () => _showEditBottomSheet(
          tr,
          title: "${tr.edit} $label",
          initialValue: value,
          onSave: (val) async {
            final success =
            await updateNotifier.updateProfile(field: fieldKey, value: val);
            if (success) {
              CustomSlideDialog.show(
                dismissible: false,
                context: context,
                child: SuccessRejectPopup(
                  isReject: false,
                  title: tr.profileUpdated,
                  subtitle: "$label has been successfully updated.",
                  onAction: () {
                    context.pop();
                    // ref.read(profileProvider.notifier).getProfile();
                  },
                ),
              );
            }
          },
        ),
      );
    }

    Widget _buildGenderField(AppLocalizations tr, String gender, WidgetRef ref) {
      final updateNotifier = ref.read(updateProfileProvider.notifier);
      final genders = ["Select your gender", "Male", "Female", "Other"];

      String selectedGender = gender.isNotEmpty ? gender : genders.first;

      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizes.spaceH(5),
              ConstText(
                text:tr.gender,
                fontSize: AppConstant.fontSizeSmall,
                color: context.hintTextColor,
              ),
              AppSizes.spaceH(8),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedGender,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down), // normal dropdown icon
                  items: genders.map((g) {
                    return DropdownMenuItem(
                      value: g,
                      child: Text(
                        g,
                        style: TextStyle(
                          fontSize: AppConstant.fontSizeThree,
                          fontWeight: AppConstant.medium,
                          color: context.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) async {
                    if (val != null) {
                      setState(() => selectedGender = val);

                      final success = await updateNotifier.updateProfile(
                        field: "gender",
                        value: val,
                      );

                      if (success) {
                        CustomSlideDialog.show(
                          dismissible: false,
                          context: context,
                          child: SuccessRejectPopup(
                            isReject: false,
                            title: tr.profileUpdated,
                            subtitle: tr.genderUpdated,
                            onAction: () {
                              context.pop();
                              // ref.read(profileProvider.notifier).getProfile();
                            },
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              Divider(color: context.hintTextColor, thickness: 0.3, height: 25),
            ],
          );
        },
      );
    }
    Widget _buildDOBField(AppLocalizations tr, String dob, WidgetRef ref) {
      final updateNotifier = ref.read(updateProfileProvider.notifier);

      // 🔹 Nicely formatted DOB for display
      String formattedDob = "";
      if (dob.isNotEmpty) {
        try {
          final parsedDate = DateTime.parse(dob);
          formattedDob = DateFormat("dd MMM yyyy").format(parsedDate);
        } catch (e) {
          formattedDob = dob; // fallback if parse fails
        }
      }

      return _buildField(
        context,
        label: tr.dob,
        value: formattedDob.isEmpty ? "Select DOB" : formattedDob,
        editable: true,
        t:tr,
        onEdit: () async {
          // 🔹 Default initial date
          DateTime initialDate;
          if (dob.isNotEmpty) {
            initialDate = DateTime.parse(dob);
          } else {
            // Default to 18 years ago
            final today = DateTime.now();
            initialDate = DateTime(today.year - 18, today.month, today.day);
          }

          // 🔹 Max date (to enforce 18+)
          final maxDate = DateTime.now().subtract(const Duration(days: 365 * 18));

          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(1900),
            lastDate: maxDate,
          );

          if (picked != null) {
            final formatted = DateFormat("yyyy-MM-dd").format(picked);

            final success = await updateNotifier.updateProfile(
              field: "dob",
              value: formatted,
            );

            if (success) {
              CustomSlideDialog.show(
                dismissible: false,
                context: context,
                child: SuccessRejectPopup(
                  isReject: false,
                  title: tr.profileUpdated,
                  subtitle:
                  tr.dobUpdated,
                  onAction: () {
                    context.pop();
                    // ref.read(profileProvider.notifier).getProfile();
                  },
                ),
              );
            }
          }
        },
      );
    }

    Widget _buildField(BuildContext context,
        {required String label,
          required String value,
        required AppLocalizations t,
        bool editable = true,
          VoidCallback? onEdit,
        }



        )
    {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSizes.spaceH(5),
          ConstText(
            text: label,
            fontSize: AppConstant.fontSizeSmall,
            color: context.hintTextColor,
          ),
          AppSizes.spaceH(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ConstText(
                  text: value.isNotEmpty ? value : "-",
                  fontSize: AppConstant.fontSizeThree,
                  fontWeight: AppConstant.medium,
                  color: context.textPrimary,
                ),
              ),
              if (editable)
                GestureDetector(
                  onTap: onEdit,
                  child: ConstText(
                    text: "${t.edit}",
                    fontSize: AppConstant.fontSizeTwo,
                    color: context.primary,
                    fontWeight: AppConstant.semiBold,
                    decoration: TextDecoration.underline,
                    decorationColor: context.primary,
                  ),
                ),
            ],
          ),
          Divider(color: context.hintTextColor, thickness: 0.3, height: 25),
        ],
      );
    }

    void _showEditBottomSheet(
      AppLocalizations tr, {
          required String title,
          String? initialValue,
          required Function(String) onSave,
          String? fieldKey,
        })
    {
      final controller = TextEditingController(text: initialValue ?? '');
      final formKey = GlobalKey<FormState>();

      // Determine validator and formatter
      String? Function(String?)? validator;
      List<TextInputFormatter>? formatters;

      switch (fieldKey) {
        case 'name':
          validator = AppValidator.validateName;
          formatters = AppInputFormatters.nameOnly;
          break;
        case 'email':
          validator = AppValidator.validateEmail;
          formatters = AppInputFormatters.email;
          break;
        case 'phone':
          validator = AppValidator.validateMobile;
          formatters = AppInputFormatters.digitsOnly;
          break;
        default:
          validator = (v) => v == null || v.trim().isEmpty ? 'This field is required' : null;
          formatters = [];
      }

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => CommonBottomSheet(
          title: title,
          content: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: controller,
                  inputFormatters: formatters,
                  decoration: InputDecoration(
                    hintText: "${tr.enter} $title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  validator: validator,
                ),
                AppSizes.spaceH(20),
                AppBtn(
                  title: tr.continueLabel,
                  onTap: () {
                    if (formKey.currentState?.validate() ?? false) {
                      onSave(controller.text.trim());
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }



  }
