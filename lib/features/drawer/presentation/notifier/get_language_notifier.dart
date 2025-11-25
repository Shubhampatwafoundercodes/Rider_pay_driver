import 'package:flutter_riverpod/legacy.dart'
    show StateNotifierProvider, StateNotifier;
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/features/drawer/data/model/get_language_model.dart';
import 'package:rider_pay_driver/features/drawer/data/repo_impl/get_Language_repo_impl.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/get_language_repo.dart';

/// 🔹 STATE CLASS
class GetLanguageState {
  final bool isLoading;
  final GetLanguageModel? data;

  GetLanguageState({required this.isLoading, this.data});

  factory GetLanguageState.initial() =>
      GetLanguageState(isLoading: false, data: null);

  GetLanguageState copyWith({bool? isLoading, GetLanguageModel? data}) {
    return GetLanguageState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
    );
  }
}

/// 🔹 PROVIDER
final getLanguageProvider =
    StateNotifierProvider<GetLanguageNotifier, GetLanguageState>((ref) {
      return GetLanguageNotifier(
        GetLanguageRepoImpl(NetworkApiServicesDio(ref)),
      );
    });

/// 🔹 NOTIFIER CLASS
class GetLanguageNotifier extends StateNotifier<GetLanguageState> {
  final GetLanguageRepo repo;

  GetLanguageNotifier(this.repo) : super(GetLanguageState.initial());

  /// API CALL FUNCTION
  Future<void> getLanguageApi({required String driverId}) async {
    state = state.copyWith(isLoading: true);
    try {
      final res = await repo.getLanguageApi();
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
