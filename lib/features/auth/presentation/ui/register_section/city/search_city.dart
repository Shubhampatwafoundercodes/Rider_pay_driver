import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:rider_pay_driver/features/auth/presentation/notifier/service_city_notifier.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';

class SearchCity extends ConsumerStatefulWidget {
  const SearchCity({super.key});

  @override
  ConsumerState<SearchCity> createState() => _SearchCityState();
}

class _SearchCityState extends ConsumerState<SearchCity> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(serviceCityProvider.notifier).fetchCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr=AppLocalizations.of(context)!;
    final state = ref.watch(serviceCityProvider);
    final cities = state.cityModel?.data?.cities ?? [];

    final filteredCities = cities
        .where((c) =>
        c.name!.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: context.background,
      body: Column(
        children: [
          AppSizes.spaceH(30),
          CommonTopBar(
            child: Row(
              children: [
                const ConstAppBackBtn(),
                const Spacer(),
                CommonIconTextButton(
                  text: tr.help,
                  imagePath: Assets.iconHelpIc,
                  imageColor: context.black,
                  onTap: () {},
                ),
              ],
            ),
          ),

          /// Search Field
          AppSizes.spaceH(15),
          Padding(
            padding: AppPadding.screenPaddingH,
            child: AppTextField(
              controller: _searchController,
              hintText: tr.searchCityHint,
              showClearButton: true,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          Padding(
            padding: AppPadding.screenPadding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstText(
                text: tr.nearestServiceableCities,
                fontWeight: AppConstant.semiBold,
                color: context.textPrimary,
                fontSize: AppConstant.fontSizeThree,
              ),
            ),
          ),

          /// Loader + List
          if (state.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (filteredCities.isNotEmpty)
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                itemCount: filteredCities.length,
                itemBuilder: (context, index) {
                  final city = filteredCities[index];
                  final isSelected = state.selectedCityName == city.name;

                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(serviceCityProvider.notifier)
                          .selectCity(city.name ?? "");
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      padding: AppPadding.screenPaddingV,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.primary.withAlpha(10)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          /// Radio
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? context.primary
                                    : Colors.grey,
                                width: 1.5,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: context.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                                : null,
                          ),
                          SizedBox(width: 12.w),
                          ConstText(
                            text: city.name ?? "",
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
            )
          else
             Expanded(
              child: Center(child: ConstText(text:tr.noCitiesFound)),
            ),
        ],
      ),

      /// Confirm Button
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: AppBtn(
            title: tr.confirmCity,
            height: 50.h,
            borderRadius: 7,
            fontSize: AppConstant.fontSizeThree,
            onTap: state.selectedCityName != null
                ? () {
              context.pop(state.selectedCityName);
            }
                : null,
          ),
        ),
      ),
    );
  }
}
