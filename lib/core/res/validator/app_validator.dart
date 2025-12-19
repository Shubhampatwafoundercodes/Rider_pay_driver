import 'package:rider_pay_driver/l10n/app_localizations.dart';

// class AppValidator {
//   /// ✅ Validate Mobile Number
//   static String? validateMobile(String? value) {
//     if (value == null || value.trim().isEmpty) return 'Enter mobile number';
//     final mobileRegex = RegExp(r'^[6-9]\d{9}$');
//     if (!mobileRegex.hasMatch(value)) return 'Enter valid mobile number';
//     return null;
//   }
//
//   /// ✅ Validate Name
//
//   static String? validateName(String? value) {
//     if (value == null || value.trim().isEmpty) return 'Enter name';
//     if (value.length > 30) return 'Name must be under 40 characters';
//     final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
//     if (!nameRegex.hasMatch(value)) return 'Only letters allowed';
//     return null;
//   }
//   /// ✅ Validate OTP
//   static String? validateOtp(String? value) {
//     if (value == null || value.trim().isEmpty) return 'Enter OTP';
//     final otpRegex = RegExp(r'^\d{4}$');
//     if (!otpRegex.hasMatch(value)) return 'Enter valid 4-digit OTP';
//     return null;
//   }
//   /// ✅ Validate Email
//   static String? validateEmail(String? value) {
//     if (value == null || value.trim().isEmpty) return 'Enter email';
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) return 'Enter valid email';
//     return null;
//   }
//
//   /// ✅ Validate Password
//   static String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) return 'Enter password';
//     if (value.length < 6) return 'Password must be at least 6 characters';
//     return null;
//   }
//
//   /// ✅ Validate Confirm Password
//   static String? validateConfirmPassword(String? value, String? originalPassword) {
//     if (value == null || value.isEmpty) return 'Enter confirm password';
//     if (value != originalPassword) return 'Passwords do not match';
//     return null;
//   }
//
//
//
//   /// ✅ Validate PAN Number
//   static String? validatePan(String? value) {
//     if (value == null || value.isEmpty) return 'Enter PAN number';
//     final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
//     if (!panRegex.hasMatch(value)) return 'Enter valid PAN (ABCDE1234F)';
//     return null;
//   }
//
//   /// ✅ Validate Aadhaar Number
//   static String? validateAadhaar(String? value) {
//     if (value == null || value.isEmpty) return 'Enter Aadhaar number';
//     final aadhaarRegex = RegExp(r'^\d{12}$');
//     if (!aadhaarRegex.hasMatch(value)) return 'Enter valid 12-digit Aadhaar number';
//     return null;
//   }
//
//   /// ✅ Validate Account Number
//   static String? validateAccount(String? value) {
//     if (value == null || value.isEmpty) return 'Enter account number';
//     final accountRegex = RegExp(r'^\d{9,18}$');
//     if (!accountRegex.hasMatch(value)) return 'Enter valid account number';
//     return null;
//   }
//
//   /// ✅ Validate IFSC Code
//   static String? validateIFSC(String? value) {
//     if (value == null || value.isEmpty) return 'Enter IFSC code';
//     final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
//     if (!ifscRegex.hasMatch(value)) return 'Enter valid IFSC code (e.g. SBIN0001234)';
//     return null;
//   }
//   /// ✅ Validate Amount
//   static String? validateAmount(String? value) {
//     if (value == null || value.trim().isEmpty) return 'Enter amount';
//     final amount = int.tryParse(value);
//     if (amount == null || amount <= 0) return 'Enter valid amount';
//     return null;
//   }
//   /// ✅ Bank Name
//   static String? validateBankName(String? value) {
//     if (value == null || value.trim().isEmpty) return 'Enter bank name';
//     if (value.length > 50) return 'Bank name must be under 50 characters';
//     final regex = RegExp(r'^[A-Z\s]+$');
//     if (!regex.hasMatch(value)) return 'Bank name must be in UPPERCASE letters only';
//     return null;
//   }
// /// transaction
//  static String? validateTransactionId(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Transaction ID is required';
//     }
//     if (value.length < 8) {
//       return 'Transaction ID is too short';
//     }
//     if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
//       return 'Only alphanumeric characters allowed';
//     }
//     return null;
//   }
//
//   static String? validateDocument(String? value, String docType) {
//     if (value == null || value.trim().isEmpty) {
//       return "Enter $docType number";
//     }
//
//     final v = value.trim().toUpperCase();
//
//     switch (docType.toLowerCase()) {
//       case "aadhar":
//         if (!RegExp(r'^\d{12}$').hasMatch(v)) {
//           return "Enter valid 12-digit Aadhaar number";
//         }
//         break;
//
//       case "license":
//         if (!RegExp(r'^[A-Z]{2}[0-9]{2}[0-9A-Z]{4,15}$').hasMatch(v)) {
//           return "Enter valid Driving License number";
//         }
//         break;
//
//       case "vehicle":
//         if (!RegExp(
//           r'^[A-Z]{2}\s?[0-9]{1,2}\s?[A-Z]{1,2}\s?[0-9]{4}$',
//         ).hasMatch(v)) {
//           return "Enter valid Vehicle number";
//         }
//         break;
//     }
//
//     return null;
//   }
//
// }

class AppValidator {

  static String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validator.mobileEmpty';
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return 'validator.mobileInvalid';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validator.nameEmpty';
    }
    if (value.length > 30) {
      return 'validator.nameTooLong';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'validator.nameInvalid';
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validator.otpEmpty';
    }
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'validator.otpInvalid';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validator.emailEmpty';
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'validator.emailInvalid';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'validator.passwordEmpty';
    }
    if (value.length < 6) {
      return 'validator.passwordShort';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? original) {
    if (value == null || value.isEmpty) {
      return 'validator.confirmPasswordEmpty';
    }
    if (value != original) {
      return 'validator.passwordMismatch';
    }
    return null;
  }

  static String? validatePan(String? value) {
    if (value == null || value.isEmpty) {
      return 'validator.panEmpty';
    }
    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(value)) {
      return 'validator.panInvalid';
    }
    return null;
  }

  static String? validateAadhaar(String? value) {
    if (value == null || value.isEmpty) {
      return 'validator.aadhaarEmpty';
    }
    if (!RegExp(r'^\d{12}$').hasMatch(value)) {
      return 'validator.aadhaarInvalid';
    }
    return null;
  }

  static String? validateAccount(String? value) {
    if (value == null || value.isEmpty) {
      return 'validator.accountEmpty';
    }
    if (!RegExp(r'^\d{9,18}$').hasMatch(value)) {
      return 'validator.accountInvalid';
    }
    return null;
  }

  static String? validateIFSC(String? value) {
    if (value == null || value.isEmpty) {
      return 'validator.ifscEmpty';
    }
    if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value)) {
      return 'validator.ifscInvalid';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validator.amountEmpty';
    }
    if (int.tryParse(value) == null || int.parse(value) <= 0) {
      return 'validator.amountInvalid';
    }
    return null;
  }

  static String? validateBankName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validator.bankNameEmpty';
    }
    if (value.length > 50) {
      return 'validator.bankNameTooLong';
    }
    if (!RegExp(r'^[A-Z\s]+$').hasMatch(value)) {
      return 'validator.bankNameUppercase';
    }
    return null;
  }

  static String? validateTransactionId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validator.transactionEmpty';
    }
    if (value.length < 8) {
      return 'validator.transactionShort';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'validator.transactionInvalid';
    }
    return null;
  }

  static String? validateDocument(String? value, String docType) {
    if (value == null || value.trim().isEmpty) {
      return 'validator.${docType}Empty';
    }

    final v = value.trim().toUpperCase();

    switch (docType.toLowerCase()) {
      case "aadhar":
        if (!RegExp(r'^\d{12}$').hasMatch(v)) {
          return 'validator.aadhaarInvalid';
        }
        break;
      case "license":
        if (!RegExp(r'^[A-Z]{2}[0-9]{2}[0-9A-Z]{4,15}$').hasMatch(v)) {
          return 'validator.licenseInvalid';
        }
        break;
      case "vehicle":
        if (!RegExp(r'^[A-Z]{2}\s?[0-9]{1,2}\s?[A-Z]{1,2}\s?[0-9]{4}$')
            .hasMatch(v)) {
          return 'validator.vehicleInvalid';
        }
        break;
    }
    return null;
  }
}


extension AppLocalizationTranslate on AppLocalizations {

  String translate(String key) {
    switch (key) {

      case 'validator.mobileEmpty':
        return mobileEmpty;
      case 'validator.mobileInvalid':
        return mobileInvalid;

      case 'validator.nameEmpty':
        return nameEmpty;
      case 'validator.nameTooLong':
        return nameTooLong;
      case 'validator.nameInvalid':
        return nameInvalid;

      case 'validator.otpEmpty':
        return otpEmpty;
      case 'validator.otpInvalid':
        return otpInvalid;

      case 'validator.emailEmpty':
        return emailEmpty;
      case 'validator.emailInvalid':
        return emailInvalid;

      case 'validator.passwordEmpty':
        return passwordEmpty;
      case 'validator.passwordShort':
        return passwordShort;

      case 'validator.confirmPasswordEmpty':
        return confirmPasswordEmpty;
      case 'validator.passwordMismatch':
        return passwordMismatch;

      case 'validator.panEmpty':
        return panEmpty;
      case 'validator.panInvalid':
        return panInvalid;

      case 'validator.aadhaarEmpty':
        return aadhaarEmpty;
      case 'validator.aadhaarInvalid':
        return aadhaarInvalid;

      case 'validator.accountEmpty':
        return accountEmpty;
      case 'validator.accountInvalid':
        return accountInvalid;

      case 'validator.ifscEmpty':
        return ifscEmpty;
      case 'validator.ifscInvalid':
        return ifscInvalid;

      case 'validator.amountEmpty':
        return amountEmpty;
      case 'validator.amountInvalid':
        return amountInvalid;

      case 'validator.bankNameEmpty':
        return bankNameEmpty;
      case 'validator.bankNameTooLong':
        return bankNameTooLong;
      case 'validator.bankNameUppercase':
        return bankNameUppercase;

      case 'validator.transactionEmpty':
        return transactionEmpty;
      case 'validator.transactionShort':
        return transactionShort;
      case 'validator.transactionInvalid':
        return transactionInvalid;

      case 'validator.licenseEmpty':
        return licenseEmpty;
      case 'validator.licenseInvalid':
        return licenseInvalid;

      case 'validator.vehicleEmpty':
        return vehicleEmpty;
      case 'validator.vehicleInvalid':
        return vehicleInvalid;

      default:
        return key;
    }
  }
}
