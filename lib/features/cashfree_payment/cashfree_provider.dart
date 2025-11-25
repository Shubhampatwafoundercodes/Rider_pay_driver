
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart' show CFPaymentGatewayService;
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/core/utils/utils.dart';
import 'package:rider_pay_driver/features/cashfree_payment/data/repo_impl/create_paying_repo_impl.dart' show createPayingRepoProvider, CreatePayingRepoImpl;
import 'package:rider_pay_driver/features/cashfree_payment/domain/repo/create_paying_repo.dart';

import 'package:rider_pay_driver/share_pref/user_provider.dart';

import 'data/repo_impl/create_paying_repo_impl.dart' show createPayingRepoProvider;

/// Provider for AdminPayment
///
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
//
// final adminPaymentProvider = StateNotifierProvider<AdminPaymentNotifier, AdminPaymentState>((ref) {
//   return AdminPaymentNotifier(CreatePayingRepoImpl(NetworkApiServicesDio(ref)));
// });
//
// class AdminPaymentState {
//   final bool isLoading;
//   final String? error;
//   final bool paymentSuccess;
//   final String? orderId;
//
//   AdminPaymentState({
//     this.isLoading = false,
//     this.error,
//     this.paymentSuccess = false,
//     this.orderId,
//   });
//
//   AdminPaymentState copyWith({
//     bool? isLoading,
//     String? error,
//     bool? paymentSuccess,
//     String? orderId,
//   }) {
//     return AdminPaymentState(
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//       paymentSuccess: paymentSuccess ?? this.paymentSuccess,
//       orderId: orderId ?? this.orderId,
//     );
//   }
// }







// class AdminPaymentNotifier extends StateNotifier<AdminPaymentState> {
//   final CreatePayingRepo repo;
//
//   AdminPaymentNotifier(this.repo) : super(AdminPaymentState());
//
//   final CFPaymentGatewayService _cfService = CFPaymentGatewayService();
//   final String _clientId = "TEST430329ae80e0f32e41a393d78b923034";
//   final String _clientSecret = "TESTaf195616268bd6202eeb3bf8dc458956e7192a85";
//   final CFEnvironment _environment = CFEnvironment.SANDBOX;
//
//   // Generate unique order ID
//   String _generateOrderId() {
//     return 'admin_due_${DateTime.now().millisecondsSinceEpoch}_${_getRandomString(6)}';
//   }
//
//   String _getRandomString(int length) {
//     const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
//     final random = DateTime.now().microsecondsSinceEpoch;
//     final result = StringBuffer();
//
//     for (var i = 0; i < length; i++) {
//       result.write(chars[random % chars.length]);
//     }
//
//     return result.toString();
//   }
//
//   // Initialize Payment Gateway with proper callbacks
//   void _initializePaymentGateway() {
//     _cfService.setCallback(_onPaymentSuccess, _onPaymentError);
//   }
//
//   Future<void> payAdminDue({required double amount}) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//
//       // Initialize payment gateway
//       _initializePaymentGateway();
//
//       // Create payment session
//       final session = await _createPaymentSession(amount: amount);
//       if (session == null) {
//         state = state.copyWith(
//             isLoading: false,
//             error: "Failed to create payment session"
//         );
//         return;
//       }
//
//       // Use Web Checkout for all payment methods
//       final payment = CFWebCheckoutPaymentBuilder()
//           .setSession(session)
//           .build();
//
//       // Trigger payment
//       _cfService.doPayment(payment);
//
//     } catch (e) {
//       state = state.copyWith(
//           isLoading: false,
//           error: "Payment initialization failed: $e"
//       );
//       Fluttertoast.showToast(msg: "Error: $e");
//     }
//   }
//
//   Future<CFSession?> _createPaymentSession({required double amount}) async {
//     try {
//       final String orderId = _generateOrderId();
//
//       final url = Uri.parse("https://sandbox.cashfree.com/pg/orders");
//
//       final headers = {
//         'accept': 'application/json',
//         'content-type': 'application/json',
//         'x-api-version': '2025-01-01',
//         'x-client-id': _clientId,
//         'x-client-secret': _clientSecret,
//       };
//
//       final body = jsonEncode({
//         "order_amount": amount,
//         "order_currency": "INR",
//         "order_id": orderId,
//         "customer_details": {
//           "customer_id": "driver_${DateTime.now().millisecondsSinceEpoch}",
//           "customer_name": "Driver User",
//           "customer_email": "driver@shubhapp.com",
//           "customer_phone": "9999999999"
//         },
//         "order_meta": {
//           "return_url": "https://www.cashfree.com/devstudio/preview/pg/web/checkout?order_id={order_id}"
//         },
//       });
//
//       print("Creating payment session for order: $orderId");
//       print("Request Body: $body");
//
//       final response = await http.post(url, headers: headers, body: body);
//
//       print("Payment Session Response: ${response.statusCode}");
//       print("Payment Session Body: ${response.body}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         final paymentSessionId = data['payment_session_id'];
//         final orderId = data['order_id'];
//
//         state = state.copyWith(orderId: orderId);
//
//         print("Session created successfully: $orderId");
//
//         return CFSessionBuilder()
//             .setEnvironment(_environment)
//             .setOrderId(orderId)
//             .setPaymentSessionId(paymentSessionId)
//             .build();
//       } else {
//         throw Exception("HTTP ${response.statusCode}: ${response.body}");
//       }
//     } catch (e) {
//       print("Session Creation Error: $e");
//       rethrow;
//     }
//   }
//
//   void _onPaymentSuccess(String orderId) {
//     print("Payment Success: $orderId");
//
//     state = state.copyWith(
//       isLoading: false,
//       paymentSuccess: true,
//       error: null,
//     );
//
//     Fluttertoast.showToast(
//       msg: "Payment Successful! Order ID: $orderId",
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//       fontSize: 16.0,
//       toastLength: Toast.LENGTH_LONG,
//     );
//
//     // Update backend about successful payment
//     _updatePaymentStatus(orderId, "SUCCESS");
//   }
//
//   void _onPaymentError(CFErrorResponse errorResponse, String orderId) {
//     print("Payment Error: ${errorResponse.getMessage()} for order: $orderId");
//
//     state = state.copyWith(
//       isLoading: false,
//       paymentSuccess: false,
//       error: errorResponse.getMessage(),
//     );
//
//     Fluttertoast.showToast(
//       msg: "Payment Failed: ${errorResponse.getMessage()}",
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0,
//       toastLength: Toast.LENGTH_LONG,
//     );
//
//     _updatePaymentStatus(orderId, "FAILED");
//   }
//
//   void _updatePaymentStatus(String orderId, String status) async {
//     // Implement your API call to update payment status
//     print("Payment $status for order: $orderId");
//
//     // Example API call (uncomment and modify as per your backend)
//     /*
//     try {
//       final response = await http.post(
//         Uri.parse('https://your-api.com/update-payment-status'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'order_id': orderId,
//           'status': status,
//           'type': 'ADMIN_DUE',
//           'amount': amount // you might need to store this
//         }),
//       );
//     } catch (e) {
//       print("Failed to update payment status: $e");
//     }
//     */
//   }
//
//   void resetState() {
//     state = AdminPaymentState();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfcard/cfcardlistener.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfcard/cfcardwidget.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfupi/cfupiutils.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shubh_ride/utils/utils.dart';
// import 'package:shubh_ride/view/payment_section/%20data/repo_impl/create_paying_repo_impl.dart';
// import 'package:shubh_ride/view/share_pref/user_provider.dart';

/// -------------------- ENUM + STATE --------------------

enum PaymentStatus { idle, loading, success, failed }

class PaymentState {
  final PaymentStatus status;
  final String? message;
  final String? orderId;
  final String? paymentSessionId;

  const PaymentState({
    this.status = PaymentStatus.idle,
    this.message,
    this.orderId,
    this.paymentSessionId,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    String? message,
    String? orderId,
    String? paymentSessionId,
  }) {
    return PaymentState(
      status: status ?? this.status,
      message: message ?? this.message,
      orderId: orderId ?? this.orderId,
      paymentSessionId: paymentSessionId ?? this.paymentSessionId,
    );
  }
}


/// -------------------- PROVIDER --------------------

final paymentProvider =
StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(ref);
});

/// -------------------- PAYMENT NOTIFIER --------------------

class PaymentNotifier extends StateNotifier<PaymentState> {
  final Ref ref;
  PaymentNotifier(this.ref) : super(const PaymentState());

  final cfPaymentGatewayService = CFPaymentGatewayService();
  final CFEnvironment environment = CFEnvironment.SANDBOX;

  String selectedUpiId = "";
  CFCardWidget? cfCardWidget;

  /// 🔥 Main function to handle full payment flow
  Future<void> startPayment(double amount) async {
    try {
      toastMsg("🚀 Creating payment session...");
      state = state.copyWith(status: PaymentStatus.loading);
      final userId = ref.read(userProvider.notifier).userId;
      final repo = ref.read(createPayingRepoProvider);

      final response = await repo.createPayingSession(userId.toString(), amount);
      debugPrint("✅ Backend response: $response");

      if (response["code"] != 200 || response["data"] == null) {
        throw Exception(response["msg"] ?? "Failed to create payment session");
      }
      final data = response["data"];
      final orderId = data["orderId"];
      final sessionId = data["sessionId"];
      final amountStr = data["amount"].toString();

      state = state.copyWith(
        status: PaymentStatus.idle,
        orderId: orderId,
        paymentSessionId: sessionId,
      );

      // toastMsg("✅ Payment session created successfully");
      _initCashfree(sessionId, orderId, amountStr);

    } catch (e, st) {
      debugPrint("❌ startPayment error: $e\n$st");
      toastMsg("Payment setup failed: $e");
      state = state.copyWith(
        status: PaymentStatus.failed,
        message: e.toString(),
      );
    }
  }


  void _initCashfree(String sessionId, String orderId, String amount) async {
    try {
      cfPaymentGatewayService.setCallback(_onPaymentSuccess, _onPaymentError);

      final session = _createSession(sessionId, orderId);
      if (session == null) {
        toastMsg("❌ Session creation failed");
        return;
      }

      CFUPIUtils().getUPIApps().then((value) {
        for (var i = 0; i < (value?.length ?? 0); i++) {
          var a = value?[i]["id"] as String;
          if (a.contains("cashfree")) {
            selectedUpiId = value?[i]["id"];
          }
        }
      }).catchError((e) {
        debugPrint("Error fetching UPI apps: $e");
      });

      // toastMsg("💳 Launching Cashfree Web Checkout...");

      final payment = CFWebCheckoutPaymentBuilder()
          .setSession(session)
          .build();

      cfPaymentGatewayService.doPayment(payment);

      state = state.copyWith(status: PaymentStatus.loading);
    } catch (e) {
      debugPrint("CFException during init: $e");
      toastMsg(" Cashfree init failed: $e");
    }
  }

  CFSession? _createSession(String sessionId, String orderId) {
    try {
      var session = CFSessionBuilder()
          .setEnvironment(environment)
          .setOrderId(orderId)
          .setPaymentSessionId(sessionId)
          .build();
      return session;
    } on CFException catch (e) {
      debugPrint("CFException createSession: ${e.message}");
    }
    return null;
  }

  void _onPaymentSuccess(String orderId) {
    debugPrint("✅ Payment success for orderId: $orderId");
    toastMsg("🎉 Payment Successful for Order: $orderId");
    state = state.copyWith(
      status: PaymentStatus.success,
      message: "Payment Successful!",
    );

    // 🪙 Optional: Call API to credit wallet here
    // ref.read(walletRepoProvider).addMoney(orderId, state.paymentSessionId!, "SUCCESS");
  }

  /// ❌ Payment Error callback
  void _onPaymentError(CFErrorResponse errorResponse, String orderId) {
    final msg = errorResponse.getMessage();
    debugPrint("❌ Payment failed: $msg");
    toastMsg("Payment not complete");
    state = state.copyWith(
      status: PaymentStatus.failed,
      message: msg,
    );
  }

  /// Optional card listener (if you use card widget)
  void cardListener(CFCardListener listener) {
    debugPrint("Card listener event: ${listener.getType()}");
  }
}
