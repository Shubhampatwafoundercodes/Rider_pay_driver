import 'package:flutter_riverpod/legacy.dart'
    show StateNotifierProvider, StateNotifier;
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/features/drawer/data/model/support_fq_model.dart';
import 'package:rider_pay_driver/features/drawer/data/repo_impl/support_fq_repo_impl.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/get_language_repo.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/support_fq_repo.dart';

/// 🔹 STATE CLASS
class SupportFqState {
  final bool isLoading;
  final SupportFQModel? data;

  SupportFqState({required this.isLoading, this.data});

  factory SupportFqState.initial() =>
      SupportFqState(isLoading: false, data: null);

  SupportFqState copyWith({bool? isLoading, SupportFQModel? data}) {
    return SupportFqState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
    );
  }
}

/// 🔹 PROVIDER
final supportFqProvider = StateNotifierProvider<SupportFqNotifier, SupportFqState>((ref) {
  return SupportFqNotifier(SupportFqRepoImpl(NetworkApiServicesDio(ref)));
});

/// 🔹 NOTIFIER CLASS
class SupportFqNotifier extends StateNotifier<SupportFqState> {
  final SupportFqRepo repo;

  SupportFqNotifier(this.repo) : super(SupportFqState.initial());

  /// API CALL FUNCTION
  Future<void> supportFqApi() async {
    state = state.copyWith(isLoading: true);
    try {
      final res = await repo.supportFQApi();
      if (res.code == 200) {
        state = state.copyWith(isLoading: false, data: res);
      } else {
        state = state.copyWith(isLoading: false, data: null);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}
