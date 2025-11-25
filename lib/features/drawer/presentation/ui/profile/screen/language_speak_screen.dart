import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/app_text_field.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/core/utils/utils.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/features/drawer/presentation/notifier/get_language_notifier.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';

class LanguageSpeakScreen extends ConsumerStatefulWidget {
  const LanguageSpeakScreen({super.key});

  @override
  ConsumerState<LanguageSpeakScreen> createState() => _LanguageSpeakScreenState();
}

class _LanguageSpeakScreenState extends ConsumerState<LanguageSpeakScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Set<String> _selectedLanguages = {};

  @override
  void initState() {
    super.initState();

    /// API Call in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(userProvider)?.id.toString() ?? "";
      ref.read(getLanguageProvider.notifier).getLanguageApi(driverId: userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getLanguageProvider);
final tr=AppLocalizations.of(context)!;
    /// Handle Data Safely
    final allLanguages = state.data?.data ?? [];
    final isLoading = state.isLoading;
    final hasError = state.data == null && !isLoading;

    /// Filter Search
    final filteredLanguages = allLanguages
        .where((lang) => lang.language
        ?.toLowerCase()
        .contains(_searchController.text.toLowerCase()) ??
        false)
        .toList();

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          CommonTopBar(
            child: Row(
              children: [
                const ConstAppBackBtn(),
                AppSizes.spaceW(15),
                ConstText(
                  text: tr.languagesSpeak,
                  fontSize: AppConstant.fontSizeThree,
                  fontWeight: AppConstant.semiBold,
                ),
                const Spacer(),
                CommonIconTextButton(
                  text:tr.help,
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

      /// BODY SECTION
      body: Padding(
        padding: AppPadding.screenPaddingH,
        child: Column(
          children: [
            AppSizes.spaceH(15),

            /// Search Field
            AppTextField(
              controller: _searchController,
              hintText:tr.searchHint,
              showClearButton: true,
              onChanged: (value) => setState(() {}),
            ),

            AppSizes.spaceH(10),
            Align(
              alignment: Alignment.centerLeft,
              child: ConstText(
                text: tr.selectLanguages,
                fontWeight: AppConstant.semiBold,
                color: context.textPrimary,
                fontSize: AppConstant.fontSizeThree,
              ),
            ),
            AppSizes.spaceH(10),

            /// Language List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : hasError
                  ?  Center(
                child: ConstText(
                  text: tr.loadingError,
                  fontWeight: FontWeight.w500,
                ),
              )
                  : filteredLanguages.isEmpty
                  ?  Center(
                child: ConstText(
                  text:tr.noLanguages,
                  fontWeight: FontWeight.w500,
                ),
              )
                  : Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 5,
                radius: const Radius.circular(8),
                child: ListView.builder(

                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: filteredLanguages.length,
                  itemBuilder: (context, index) {
                    final lang = filteredLanguages[index];
                    final langName = lang.language ?? "Unknown";
                    final isSelected = _selectedLanguages.contains(langName);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedLanguages.remove(langName);
                          } else {
                            _selectedLanguages.add(langName);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.primary.withAlpha(15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isSelected,
                              activeColor: context.primary,
                              shape: const CircleBorder(),
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedLanguages.add(langName);
                                  } else {
                                    _selectedLanguages.remove(langName);
                                  }
                                });
                              },
                            ),
                            SizedBox(width: 8.w),
                            ConstText(
                              text: langName,
                              fontSize: AppConstant.fontSizeTwo,
                              fontWeight: isSelected
                                  ? AppConstant.semiBold
                                  : FontWeight.normal,
                              color: context.textPrimary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      /// Bottom Confirm Button
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: AppBtn(
            title:tr.confirmButton,
            height: 50.h,
            borderRadius: 7,
            fontSize: AppConstant.fontSizeThree,
            onTap: () {
              if (_selectedLanguages.isNotEmpty) {
                context.pop(_selectedLanguages.toList());
              } else {
                toastMsg(tr.selectAtLeastOne);
              }
            },
          ),
        ),
      ),
    );
  }
}
