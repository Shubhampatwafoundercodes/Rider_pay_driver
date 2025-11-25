import 'package:flutter_riverpod/legacy.dart';
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/core/utils/utils.dart';
import 'package:rider_pay_driver/features/auth/data/model/get_service_city_model.dart';
import 'package:rider_pay_driver/features/auth/data/repo_impl/get_service_city_impl.dart';
import 'package:rider_pay_driver/features/auth/domain/repo/service_get_city_repo.dart';

class ServiceCityState {
  final bool isLoading;
  final GetServiceCityModel? cityModel;
  final String? selectedCityName;

  ServiceCityState({
    required this.isLoading,
    this.cityModel,
    this.selectedCityName,
  });

  factory ServiceCityState.initial() => ServiceCityState(isLoading: false);

  ServiceCityState copyWith({
    bool? isLoading,
    GetServiceCityModel? cityModel,
    String? selectedCityName,
  }) {
    return ServiceCityState(
      isLoading: isLoading ?? this.isLoading,
      cityModel: cityModel ?? this.cityModel,
      selectedCityName: selectedCityName ?? this.selectedCityName,
    );
  }
}

final serviceCityProvider =
StateNotifierProvider<ServiceCityNotifier, ServiceCityState>((ref) {
  final repo = GetServiceCityImpl(NetworkApiServicesDio(ref));
  return ServiceCityNotifier(repo);
});

class ServiceCityNotifier extends StateNotifier<ServiceCityState> {
  final ServiceGetCityRepo repo;

  ServiceCityNotifier(this.repo) : super(ServiceCityState.initial());

  Future<void> fetchCities() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await repo.getServiceCityApi();
      if(result.code==200){
        state = state.copyWith(isLoading: false, cityModel: result);

      }else{

        state = state.copyWith(isLoading: false, cityModel: null);

      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      toastMsg("Failed to fetch cities");
    }
  }

  void selectCity(String name) {
    state = state.copyWith(selectedCityName: name);
  }
}
