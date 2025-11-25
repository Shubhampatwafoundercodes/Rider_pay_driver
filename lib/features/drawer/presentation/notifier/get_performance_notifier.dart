import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider, StateNotifier;
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/features/drawer/data/model/get_performace_model.dart';
import 'package:rider_pay_driver/features/drawer/data/repo_impl/get_performance_repo_impl.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/get_performance_repo.dart';


/// 🔹 STATE CLASS
class GetPerformanceState {
  final bool isLoading;
  final GetPerformanceModel? data;

  GetPerformanceState({required this.isLoading, this.data});

  factory GetPerformanceState.initial() =>
      GetPerformanceState(isLoading: false, data: null);

  GetPerformanceState copyWith({
    bool? isLoading,
    GetPerformanceModel? data,
  }) {
    return GetPerformanceState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
    );
  }
}

/// 🔹 PROVIDER
final getPerformanceProvider =
StateNotifierProvider<GetPerformanceNotifier, GetPerformanceState>((ref) {
  return GetPerformanceNotifier(
    GetPerformanceRepoImpl(NetworkApiServicesDio(ref)),
  );
});

/// 🔹 NOTIFIER CLASS
class GetPerformanceNotifier extends StateNotifier<GetPerformanceState> {
  final GetPerformanceRepo repo;

  GetPerformanceNotifier(this.repo) : super(GetPerformanceState.initial());

  /// API CALL FUNCTION
  Future<void> getPerformanceApi({required String driverId}) async {
    state = state.copyWith(isLoading: true);
    try {
      final res = await repo.getPerformanceApi(driverId);

      if (res.code == 200) {
        // 🟢 Safely parsed performance data
        final parsedData = GetPerformanceModel(
          code: res.code,
          msg: res.msg,
          data: Data(
            performance: Performance(
              driverId: res.data?.performance?.driverId ?? "",
              totalBookings: _parseInt(res.data?.performance?.totalBookings),
              completedBookings:
              _parseInt(res.data?.performance?.completedBookings),
              cancelledBookings:
              _parseInt(res.data?.performance?.cancelledBookings),
              ongoingBookings:
              _parseInt(res.data?.performance?.ongoingBookings),
            ),
          ),
        );

        state = state.copyWith(isLoading: false, data: parsedData);
      } else {
        state = state.copyWith(isLoading: false, data: null);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 🧩 Safe integer parser (handles string, null, dynamic)
  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
