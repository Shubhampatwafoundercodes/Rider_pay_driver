import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifier, StateNotifierProvider;
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/features/auth/data/model/vehicle_type_model.dart';
import 'package:rider_pay_driver/features/auth/data/repo_impl/vehicle_type_repo_impl.dart';
import 'package:rider_pay_driver/features/auth/domain/repo/vehicle_type_repo.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';

class VehicleTypeState {
  final bool isLoading;
  final VehicleTypeModel? vehicleTypeModelData;
  final int? selectedId;
  final bool isUploadLoading;
  VehicleTypeState({
    required this.isLoading,
    required this.isUploadLoading,
    this.vehicleTypeModelData,
    this.selectedId,
  });

  factory VehicleTypeState.initial() => VehicleTypeState(
    isLoading: false,
    isUploadLoading: false,
    vehicleTypeModelData: null,
    selectedId: null,
  );

  VehicleTypeState copyWith({
    bool? isLoading,
    bool? isUploadLoading,
    VehicleTypeModel? vehicleTypeModelData,
    int? selectedId,
  }) {
    return VehicleTypeState(
      isLoading: isLoading ?? this.isLoading,
      isUploadLoading: isUploadLoading ?? this.isUploadLoading,
      vehicleTypeModelData: vehicleTypeModelData ?? this.vehicleTypeModelData,
      selectedId: selectedId ?? this.selectedId,
    );
  }
}

/// vehicle type provider

final vehicleTypeProvider = StateNotifierProvider<VehicleTypeNotifier, VehicleTypeState>((ref) {
  return VehicleTypeNotifier(VehicleTypeRepoImpl((NetworkApiServicesDio(ref))),ref);
});

class VehicleTypeNotifier extends StateNotifier<VehicleTypeState> {
  final VehicleTypeRepo repo;
  final Ref ref;
  VehicleTypeNotifier(this.repo,this.ref) : super(VehicleTypeState.initial());

  Future<void> fetchVehicleTypes() async {
    state = state.copyWith(isLoading: true, );
    try {
      final result = await repo.vehicleTypeApi();
      if (result.code == 200) {
        state = state.copyWith(isLoading: false, vehicleTypeModelData: result);
      } else {
        state = state.copyWith(isLoading: false, vehicleTypeModelData: null);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, );
    }
  }

  void selectVehicle(int id) {

    state = state.copyWith(selectedId: id);
  }

  /// upload vehicle Api

  Future<bool> uploadVehicleApi(String vehicleId) async{
    state = state.copyWith(isUploadLoading: true, );
    final driverId= ref.read(userProvider)?.id??0;
    try {
      final result = await repo.selectedVehicleUpload(vehicleId, driverId.toString());
      if (result["code"] == 200) {
        state = state.copyWith(isUploadLoading: false,);
        return true;

      } else {
        state = state.copyWith(isUploadLoading: false,);
        return false;

      }
    } catch (e) {
      state = state.copyWith(isUploadLoading: false,);
      return false;


    }


}
}
