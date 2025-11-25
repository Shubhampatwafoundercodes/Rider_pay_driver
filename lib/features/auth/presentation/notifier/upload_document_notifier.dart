  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:flutter_riverpod/legacy.dart';
  import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
  import 'package:rider_pay_driver/core/utils/utils.dart';
  import 'package:rider_pay_driver/features/auth/data/repo_impl/document_upload_impl.dart';
  import 'package:rider_pay_driver/features/auth/domain/repo/document_upload_repo.dart';

  class DocumentUploadSate {
    final bool isLoading;
    DocumentUploadSate({required this.isLoading});

    factory DocumentUploadSate.initial() => DocumentUploadSate(isLoading: false);

    DocumentUploadSate copyWith({bool? isLoading}) {
      return DocumentUploadSate(isLoading: isLoading ?? this.isLoading);
    }
  }

  final documentUploadProvider = StateNotifierProvider<DocumentUploadNotifier, DocumentUploadSate>((ref) {
    return DocumentUploadNotifier(DocumentUploadRepoImpl((NetworkApiServicesDio(ref))),ref);
  });





  class DocumentUploadNotifier extends StateNotifier<DocumentUploadSate> {
    final DocumentUploadRepo repo;
    final Ref ref;
    DocumentUploadNotifier(this.repo, this.ref)
      : super(DocumentUploadSate.initial());

    Future<bool> uploadDocument({
      required String driverId,
      required String docType,
      required String docNumber,
      required String frontImgPath,
      String? backImgPath,
    }) async {
      state = state.copyWith(isLoading: true,);
      try {
        final res = await repo.uploadDocument(
          driverId: driverId,
          docType: docType,
          docNumber: docNumber,
          frontImgPath: frontImgPath,
          backImgPath: backImgPath,
        );
        if (res["code"] == 200) {
          state = state.copyWith(isLoading: false,);
          toastMsg(res["msg"]);
          return true;
        } else {
          state = state.copyWith(isLoading: false,);
          return false;

        }
      } catch (e) {
        state = state.copyWith(isLoading: false);
        return false;

      }
    }

  }
