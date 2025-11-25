import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Shubh Driver'**
  String get appTitle;

  /// No description provided for @selectYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Hi Captain, Select your language'**
  String get selectYourLanguage;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @enterYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your Phone Number to Drive'**
  String get enterYourPhone;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get phoneHint;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'+91'**
  String get countryCode;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, Captain!'**
  String get welcomeBack;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again.'**
  String get somethingWentWrong;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @enterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get enterValidPhone;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @whichCityRide.
  ///
  /// In en, this message translates to:
  /// **'Which city do you want to ride?'**
  String get whichCityRide;

  /// No description provided for @youWillRideIn.
  ///
  /// In en, this message translates to:
  /// **'You will ride in'**
  String get youWillRideIn;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'CHANGE'**
  String get change;

  /// No description provided for @confirmCity.
  ///
  /// In en, this message translates to:
  /// **'Confirm City'**
  String get confirmCity;

  /// No description provided for @searchCityHint.
  ///
  /// In en, this message translates to:
  /// **'Search City'**
  String get searchCityHint;

  /// No description provided for @nearestServiceableCities.
  ///
  /// In en, this message translates to:
  /// **'Nearest serviceable cities:'**
  String get nearestServiceableCities;

  /// No description provided for @noCitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No cities found'**
  String get noCitiesFound;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello User'**
  String get helloUser;

  /// No description provided for @registerAsCaption.
  ///
  /// In en, this message translates to:
  /// **'Please register yourself as a Shubh Captain'**
  String get registerAsCaption;

  /// No description provided for @receiveAccountUpdateOn.
  ///
  /// In en, this message translates to:
  /// **'Receive account update on'**
  String get receiveAccountUpdateOn;

  /// No description provided for @haveReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Have a Referral Code?'**
  String get haveReferralCode;

  /// No description provided for @referralBonusText.
  ///
  /// In en, this message translates to:
  /// **'Get up to ₹500 as referral joining bonus'**
  String get referralBonusText;

  /// No description provided for @enterReferralCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter referral code'**
  String get enterReferralCodeHint;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register as a Captain'**
  String get registerTitle;

  /// No description provided for @getSupport.
  ///
  /// In en, this message translates to:
  /// **'Get Support'**
  String get getSupport;

  /// No description provided for @permissionCenter.
  ///
  /// In en, this message translates to:
  /// **'Permission Center'**
  String get permissionCenter;

  /// No description provided for @locationAccess.
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get locationAccess;

  /// No description provided for @locationAccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Required to fetch your location'**
  String get locationAccessDesc;

  /// No description provided for @backgroundLocation.
  ///
  /// In en, this message translates to:
  /// **'Background Location'**
  String get backgroundLocation;

  /// No description provided for @backgroundLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'Track location in background'**
  String get backgroundLocationDesc;

  /// No description provided for @batteryUsage.
  ///
  /// In en, this message translates to:
  /// **'Battery Usage'**
  String get batteryUsage;

  /// No description provided for @batteryUsageDesc.
  ///
  /// In en, this message translates to:
  /// **'Prevent battery optimization'**
  String get batteryUsageDesc;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive app updates'**
  String get notificationsDesc;

  /// No description provided for @grantAllOtherPermissions.
  ///
  /// In en, this message translates to:
  /// **'Grant All Other Permissions'**
  String get grantAllOtherPermissions;

  /// No description provided for @unknownPermission.
  ///
  /// In en, this message translates to:
  /// **'Unknown Permission'**
  String get unknownPermission;

  /// No description provided for @unknownPermissionDesc.
  ///
  /// In en, this message translates to:
  /// **'Permission details not available'**
  String get unknownPermissionDesc;

  /// No description provided for @documentCenter.
  ///
  /// In en, this message translates to:
  /// **'Document Center'**
  String get documentCenter;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not Selected'**
  String get notSelected;

  /// No description provided for @submited.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submited;

  /// No description provided for @tapToSelectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Tap to Select Vehicle'**
  String get tapToSelectVehicle;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @pleaseCompleteProfile.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Please complete your profile'**
  String get pleaseCompleteProfile;

  /// No description provided for @profileComplete.
  ///
  /// In en, this message translates to:
  /// **'Profile Complete ✅'**
  String get profileComplete;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @underVerification.
  ///
  /// In en, this message translates to:
  /// **'Under verification...'**
  String get underVerification;

  /// No description provided for @rejectedTapToReupload.
  ///
  /// In en, this message translates to:
  /// **'Rejected - Tap to Re Upload'**
  String get rejectedTapToReupload;

  /// No description provided for @notUploadedTapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Not Uploaded - Tap to Upload'**
  String get notUploadedTapToUpload;

  /// No description provided for @uploadDocumentsStart.
  ///
  /// In en, this message translates to:
  /// **'Upload documents to start earning'**
  String get uploadDocumentsStart;

  /// No description provided for @completeAllSteps.
  ///
  /// In en, this message translates to:
  /// **'Complete all steps to get activated'**
  String get completeAllSteps;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @tapToManagePermissions.
  ///
  /// In en, this message translates to:
  /// **'Tap to manage required permissions'**
  String get tapToManagePermissions;

  /// No description provided for @documentUpload.
  ///
  /// In en, this message translates to:
  /// **'Document Upload'**
  String get documentUpload;

  /// No description provided for @drivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get drivingLicense;

  /// No description provided for @uploadDrivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Upload your valid driving license'**
  String get uploadDrivingLicense;

  /// No description provided for @enterDrivingLicenseNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter driving license number'**
  String get enterDrivingLicenseNumber;

  /// No description provided for @drivingLicenseInstructions.
  ///
  /// In en, this message translates to:
  /// **'1. Upload back side of Driving Licence first if some information is present on back side before the front side upload\n\n2. Make sure that your driver license validates the class of vehicle you are choosing to drive\n\n3. Make sure License number, Driving License Type, your Address, Father\'s Name, D.O.B, Expiration Date and Govt logo on the License are clearly visible and the photo is not blurred'**
  String get drivingLicenseInstructions;

  /// No description provided for @captureDrivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of your Driving Licence'**
  String get captureDrivingLicense;

  /// No description provided for @aadhaarCard.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Card'**
  String get aadhaarCard;

  /// No description provided for @uploadAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Upload your Aadhaar details'**
  String get uploadAadhaar;

  /// No description provided for @enterAadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Aadhaar number'**
  String get enterAadhaarNumber;

  /// No description provided for @aadhaarInstructions.
  ///
  /// In en, this message translates to:
  /// **'By sharing your Aadhaar details, you hereby confirm that you have shared such details voluntarily.\n\nYou further confirm and consent that your Aadhaar details may be shared with relevant government authorities for verification purposes.'**
  String get aadhaarInstructions;

  /// No description provided for @captureAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of your Aadhaar card'**
  String get captureAadhaar;

  /// No description provided for @vehicleRegistration.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Registration'**
  String get vehicleRegistration;

  /// No description provided for @enterVehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter your vehicle registration details'**
  String get enterVehicleDetails;

  /// No description provided for @enterVehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter vehicle registration number'**
  String get enterVehicleNumber;

  /// No description provided for @vehicleInstructions.
  ///
  /// In en, this message translates to:
  /// **'Make sure your Vehicle Registration Number matches the RC you uploaded. Upload clear photos of your vehicle RC.'**
  String get vehicleInstructions;

  /// No description provided for @captureVehicle.
  ///
  /// In en, this message translates to:
  /// **'Upload vehicle number and RC'**
  String get captureVehicle;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload document'**
  String get tapToUpload;

  /// No description provided for @fileFormatInfo.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG • Max 5MB'**
  String get fileFormatInfo;

  /// No description provided for @submitDocument.
  ///
  /// In en, this message translates to:
  /// **'Submit Document'**
  String get submitDocument;

  /// No description provided for @documentUploaded.
  ///
  /// In en, this message translates to:
  /// **'Document Uploaded'**
  String get documentUploaded;

  /// No description provided for @documentUploadedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your {docType} document has been successfully uploaded.'**
  String documentUploadedSubtitle(Object docType);

  /// No description provided for @takeClearPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo of your document'**
  String get takeClearPhoto;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @earningsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer Money to Bank, History'**
  String get earningsSubtitle;

  /// No description provided for @helpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get support, Accident Insurance'**
  String get helpSubtitle;

  /// No description provided for @referFriend.
  ///
  /// In en, this message translates to:
  /// **'Refer your friend &'**
  String get referFriend;

  /// No description provided for @earnUpto.
  ///
  /// In en, this message translates to:
  /// **'Earn up to ₹1150'**
  String get earnUpto;

  /// No description provided for @referNow.
  ///
  /// In en, this message translates to:
  /// **'Refer Now'**
  String get referNow;

  /// No description provided for @moneyTransfer.
  ///
  /// In en, this message translates to:
  /// **'Money Transfer'**
  String get moneyTransfer;

  /// No description provided for @totalAmountToTransfer.
  ///
  /// In en, this message translates to:
  /// **'Total amount to be transferred'**
  String get totalAmountToTransfer;

  /// No description provided for @automaticMoneyTransfer.
  ///
  /// In en, this message translates to:
  /// **'Automatic Money Transfer'**
  String get automaticMoneyTransfer;

  /// No description provided for @depositTo.
  ///
  /// In en, this message translates to:
  /// **'Deposit to'**
  String get depositTo;

  /// No description provided for @upiId.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get upiId;

  /// No description provided for @bankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get bankAccount;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @addNewPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Add New Payment Method'**
  String get addNewPaymentMethod;

  /// No description provided for @addYourBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Add your bank account'**
  String get addYourBankAccount;

  /// No description provided for @addYourUpiId.
  ///
  /// In en, this message translates to:
  /// **'Add your UPI ID'**
  String get addYourUpiId;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'TRANSFER'**
  String get transfer;

  /// No description provided for @transferringToUpi.
  ///
  /// In en, this message translates to:
  /// **'Transferring to UPI ID:'**
  String get transferringToUpi;

  /// No description provided for @transferringToAccount.
  ///
  /// In en, this message translates to:
  /// **'Transferring to Account:'**
  String get transferringToAccount;

  /// No description provided for @allEarnings.
  ///
  /// In en, this message translates to:
  /// **'All Earnings'**
  String get allEarnings;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @adminDue.
  ///
  /// In en, this message translates to:
  /// **'Admin Due'**
  String get adminDue;

  /// No description provided for @yourAdminDue.
  ///
  /// In en, this message translates to:
  /// **'Your Admin Due'**
  String get yourAdminDue;

  /// No description provided for @payAdminDue.
  ///
  /// In en, this message translates to:
  /// **'Pay Admin Due'**
  String get payAdminDue;

  /// No description provided for @noDueRemaining.
  ///
  /// In en, this message translates to:
  /// **'No Due Remaining'**
  String get noDueRemaining;

  /// No description provided for @adminPaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Admin Payment History'**
  String get adminPaymentHistory;

  /// No description provided for @noAdminPaymentsFound.
  ///
  /// In en, this message translates to:
  /// **'No admin payments found.'**
  String get noAdminPaymentsFound;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @earningsTransferInfo.
  ///
  /// In en, this message translates to:
  /// **'Your earnings will be transferred to the account details you provide below:'**
  String get earningsTransferInfo;

  /// No description provided for @bankAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Bank account added successfully!'**
  String get bankAddedSuccess;

  /// No description provided for @upiAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'UPI ID added successfully!'**
  String get upiAddedSuccess;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get paymentDetails;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @accountHolder.
  ///
  /// In en, this message translates to:
  /// **'Account Holder'**
  String get accountHolder;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @ifscCode.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get ifscCode;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deleting;

  /// No description provided for @failedToDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account'**
  String get failedToDelete;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @bankFormFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name (Same as Bank Account)'**
  String get bankFormFullNameLabel;

  /// No description provided for @bankFormEnterNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get bankFormEnterNameHint;

  /// No description provided for @bankFormAccountNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get bankFormAccountNumberLabel;

  /// No description provided for @bankFormEnterAccountNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Account Number'**
  String get bankFormEnterAccountNumberHint;

  /// No description provided for @bankFormReEnterAccountNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Re-Enter account number'**
  String get bankFormReEnterAccountNumberHint;

  /// No description provided for @bankFormAccountNumberMismatch.
  ///
  /// In en, this message translates to:
  /// **'Account numbers do not match'**
  String get bankFormAccountNumberMismatch;

  /// No description provided for @bankFormIfscLabel.
  ///
  /// In en, this message translates to:
  /// **'IFSC code'**
  String get bankFormIfscLabel;

  /// No description provided for @bankFormEnterIfscHint.
  ///
  /// In en, this message translates to:
  /// **'Enter IFSC Code'**
  String get bankFormEnterIfscHint;

  /// No description provided for @bankFormBankNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name of Bank'**
  String get bankFormBankNameLabel;

  /// No description provided for @bankFormEnterBankNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Bank name'**
  String get bankFormEnterBankNameHint;

  /// No description provided for @upiFormEnterUpiIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter UPI ID'**
  String get upiFormEnterUpiIdHint;

  /// No description provided for @upiFormReEnterUpiIdHint.
  ///
  /// In en, this message translates to:
  /// **'Re-Enter UPI ID'**
  String get upiFormReEnterUpiIdHint;

  /// No description provided for @upiFormUpiInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid UPI ID'**
  String get upiFormUpiInvalid;

  /// No description provided for @upiFormUpiEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter UPI ID'**
  String get upiFormUpiEmpty;

  /// No description provided for @upiFormUpiMismatch.
  ///
  /// In en, this message translates to:
  /// **'UPI IDs do not match'**
  String get upiFormUpiMismatch;

  /// No description provided for @upiFormNote.
  ///
  /// In en, this message translates to:
  /// **'Make sure your UPI ID is correct. We will send money to this UPI ID.'**
  String get upiFormNote;

  /// No description provided for @walletBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Wallet Balance'**
  String get walletBalanceTitle;

  /// No description provided for @walletTransferButton.
  ///
  /// In en, this message translates to:
  /// **'Money transfer'**
  String get walletTransferButton;

  /// No description provided for @walletTransferCount.
  ///
  /// In en, this message translates to:
  /// **'You have {count} transfers left'**
  String walletTransferCount(Object count);

  /// No description provided for @walletTransferRenew.
  ///
  /// In en, this message translates to:
  /// **'Money transfer renews every Monday!'**
  String get walletTransferRenew;

  /// No description provided for @walletTabCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get walletTabCredit;

  /// No description provided for @walletTabWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get walletTabWithdraw;

  /// No description provided for @walletNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get walletNoTransactions;

  /// No description provided for @transactionStatusSuccess.
  ///
  /// In en, this message translates to:
  /// **'SUCCESS'**
  String get transactionStatusSuccess;

  /// No description provided for @transactionStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'FAILED'**
  String get transactionStatusFailed;

  /// No description provided for @transactionStatusPending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get transactionStatusPending;

  /// No description provided for @todayEarningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Earnings'**
  String get todayEarningsTitle;

  /// No description provided for @allOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'All Orders'**
  String get allOrdersTitle;

  /// No description provided for @allOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Order History and Order Earnings'**
  String get allOrdersSubtitle;

  /// No description provided for @viewRateCard.
  ///
  /// In en, this message translates to:
  /// **'View Rate Card'**
  String get viewRateCard;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'RATING >'**
  String get ratingLabel;

  /// No description provided for @ordersLabel.
  ///
  /// In en, this message translates to:
  /// **'ORDERS'**
  String get ordersLabel;

  /// No description provided for @daysLabel.
  ///
  /// In en, this message translates to:
  /// **'DAYS'**
  String get daysLabel;

  /// No description provided for @yearsLabel.
  ///
  /// In en, this message translates to:
  /// **'YEARS'**
  String get yearsLabel;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @profileInfo.
  ///
  /// In en, this message translates to:
  /// **'Profile Info'**
  String get profileInfo;

  /// No description provided for @driverIdCard.
  ///
  /// In en, this message translates to:
  /// **'Driver ID Card'**
  String get driverIdCard;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents (RC, DL, PAN)'**
  String get documents;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @logoutDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Logout / Delete Account'**
  String get logoutDeleteAccount;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountConfirm;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select your gender'**
  String get selectGender;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dob;

  /// No description provided for @selectDob.
  ///
  /// In en, this message translates to:
  /// **'Select DOB'**
  String get selectDob;

  /// No description provided for @languagesSpeak.
  ///
  /// In en, this message translates to:
  /// **'Languages I Speak'**
  String get languagesSpeak;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseGallery;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated'**
  String get profileUpdated;

  /// No description provided for @profileImageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your profile image has been successfully updated.'**
  String get profileImageUpdated;

  /// No description provided for @nameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Name has been successfully updated.'**
  String get nameUpdated;

  /// No description provided for @genderUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your gender has been successfully updated.'**
  String get genderUpdated;

  /// No description provided for @dobUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your Date of Birth has been successfully updated.'**
  String get dobUpdated;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @myPerformance.
  ///
  /// In en, this message translates to:
  /// **'My Performance'**
  String get myPerformance;

  /// No description provided for @bikeLiteText.
  ///
  /// In en, this message translates to:
  /// **'Bike Lite and Bike only'**
  String get bikeLiteText;

  /// No description provided for @acceptedOrders.
  ///
  /// In en, this message translates to:
  /// **'Accepted Orders'**
  String get acceptedOrders;

  /// No description provided for @cancelledOrders.
  ///
  /// In en, this message translates to:
  /// **'Cancelled Orders'**
  String get cancelledOrders;

  /// No description provided for @completedOrders.
  ///
  /// In en, this message translates to:
  /// **'Completed Orders'**
  String get completedOrders;

  /// No description provided for @goodPerformanceTitle.
  ///
  /// In en, this message translates to:
  /// **'To have a good performance'**
  String get goodPerformanceTitle;

  /// No description provided for @tipNoCancel.
  ///
  /// In en, this message translates to:
  /// **'Do not cancel orders after accepting'**
  String get tipNoCancel;

  /// No description provided for @tipFiveStar.
  ///
  /// In en, this message translates to:
  /// **'Get 5-star ratings from customers'**
  String get tipFiveStar;

  /// No description provided for @earnMoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Get More Earnings by becoming the Best Captain!'**
  String get earnMoreTitle;

  /// No description provided for @knowMore.
  ///
  /// In en, this message translates to:
  /// **'Know more'**
  String get knowMore;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No performance data found.'**
  String get noData;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search Language'**
  String get searchHint;

  /// No description provided for @selectLanguages.
  ///
  /// In en, this message translates to:
  /// **'Select the languages you speak:'**
  String get selectLanguages;

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load languages. Please try again.'**
  String get loadingError;

  /// No description provided for @noLanguages.
  ///
  /// In en, this message translates to:
  /// **'No languages found.'**
  String get noLanguages;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Languages'**
  String get confirmButton;

  /// No description provided for @selectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one language'**
  String get selectAtLeastOne;

  /// No description provided for @myIDCard.
  ///
  /// In en, this message translates to:
  /// **'My ID Card'**
  String get myIDCard;

  /// No description provided for @noProfileData.
  ///
  /// In en, this message translates to:
  /// **'No profile data found'**
  String get noProfileData;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @licenseNumber.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get licenseNumber;

  /// No description provided for @licenseValidity.
  ///
  /// In en, this message translates to:
  /// **'License Validity'**
  String get licenseValidity;

  /// No description provided for @shareButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareButton;

  /// No description provided for @documentType.
  ///
  /// In en, this message translates to:
  /// **'Document Type'**
  String get documentType;

  /// No description provided for @documentNumber.
  ///
  /// In en, this message translates to:
  /// **'Document Number'**
  String get documentNumber;

  /// No description provided for @verifiedStatus.
  ///
  /// In en, this message translates to:
  /// **'Verified Status'**
  String get verifiedStatus;

  /// No description provided for @uploadedDate.
  ///
  /// In en, this message translates to:
  /// **'Uploaded Date'**
  String get uploadedDate;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @ride_myRide.
  ///
  /// In en, this message translates to:
  /// **'My Ride'**
  String get ride_myRide;

  /// No description provided for @ride_rideDetails.
  ///
  /// In en, this message translates to:
  /// **'Ride Details'**
  String get ride_rideDetails;

  /// No description provided for @ride_totalEarning.
  ///
  /// In en, this message translates to:
  /// **'Total Earning'**
  String get ride_totalEarning;

  /// No description provided for @ride_dropLocation.
  ///
  /// In en, this message translates to:
  /// **'Drop Location'**
  String get ride_dropLocation;

  /// No description provided for @ride_pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get ride_pickupLocation;

  /// No description provided for @ride_pickupDropInfo.
  ///
  /// In en, this message translates to:
  /// **'Pickup and Drop info'**
  String get ride_pickupDropInfo;

  /// No description provided for @ride_yourEarning.
  ///
  /// In en, this message translates to:
  /// **'Your Earning'**
  String get ride_yourEarning;

  /// No description provided for @ride_paymentInfo.
  ///
  /// In en, this message translates to:
  /// **'Payment info'**
  String get ride_paymentInfo;

  /// No description provided for @ride_customerFare.
  ///
  /// In en, this message translates to:
  /// **'Customer Fare'**
  String get ride_customerFare;

  /// No description provided for @earnings_rapidoWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'Rapido Wallet Balance'**
  String get earnings_rapidoWalletBalance;

  /// No description provided for @earnings_todaysEarning.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Earnings'**
  String get earnings_todaysEarning;

  /// No description provided for @earnings_lastOrderEarning.
  ///
  /// In en, this message translates to:
  /// **'Last Order Earning'**
  String get earnings_lastOrderEarning;

  /// No description provided for @meet_customer.
  ///
  /// In en, this message translates to:
  /// **'Meet The Customer'**
  String get meet_customer;

  /// No description provided for @updating_status.
  ///
  /// In en, this message translates to:
  /// **'Updating status...'**
  String get updating_status;

  /// No description provided for @exit_app_title.
  ///
  /// In en, this message translates to:
  /// **'Exit Application?'**
  String get exit_app_title;

  /// No description provided for @exit_app_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close the app? Your current session will be lost.'**
  String get exit_app_message;

  /// No description provided for @cancel_button.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel_button;

  /// No description provided for @ok_exit_button.
  ///
  /// In en, this message translates to:
  /// **'OK, EXIT'**
  String get ok_exit_button;

  /// No description provided for @termsAndPolicy.
  ///
  /// In en, this message translates to:
  /// **' T&C and Privacy Policy'**
  String get termsAndPolicy;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @doNotAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get doNotAccount;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Book your ride quickly and easily'**
  String get welcomeSubTitle;

  /// No description provided for @changeLanguageHelp.
  ///
  /// In en, this message translates to:
  /// **'You can change your language on this screen or at any time in Help.'**
  String get changeLanguageHelp;

  /// No description provided for @whereAreYouGoing.
  ///
  /// In en, this message translates to:
  /// **'Where are you going?'**
  String get whereAreYouGoing;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @madeForIndia.
  ///
  /// In en, this message translates to:
  /// **'Made for India'**
  String get madeForIndia;

  /// No description provided for @craftedInLucknow.
  ///
  /// In en, this message translates to:
  /// **'Crafted in Lucknow'**
  String get craftedInLucknow;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed!'**
  String get paymentFailed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @phoneVerification.
  ///
  /// In en, this message translates to:
  /// **'Phone Verification'**
  String get phoneVerification;

  /// No description provided for @byContinuing.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to the'**
  String get byContinuing;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @verifyNow.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get verifyNow;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account to continue!'**
  String get createAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get emailOptional;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @goPlacesWithRiderPay.
  ///
  /// In en, this message translates to:
  /// **'Go Places with Rider Pay'**
  String get goPlacesWithRiderPay;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSince;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get wallets;

  /// No description provided for @riderWallet.
  ///
  /// In en, this message translates to:
  /// **'Rider Wallet'**
  String get riderWallet;

  /// No description provided for @lowBalance.
  ///
  /// In en, this message translates to:
  /// **'Low Balance'**
  String get lowBalance;

  /// No description provided for @addMoney.
  ///
  /// In en, this message translates to:
  /// **'Add Money'**
  String get addMoney;

  /// No description provided for @payByUpi.
  ///
  /// In en, this message translates to:
  /// **'Pay by any UPI app'**
  String get payByUpi;

  /// No description provided for @payLater.
  ///
  /// In en, this message translates to:
  /// **'Pay Later'**
  String get payLater;

  /// No description provided for @payAtDrop.
  ///
  /// In en, this message translates to:
  /// **'Pay at drop'**
  String get payAtDrop;

  /// No description provided for @goCashless.
  ///
  /// In en, this message translates to:
  /// **'Go cashless, pay after ride by scanning QR'**
  String get goCashless;

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// No description provided for @searchHelpTopics.
  ///
  /// In en, this message translates to:
  /// **'Search Help Topics'**
  String get searchHelpTopics;

  /// No description provided for @rideFareIssues.
  ///
  /// In en, this message translates to:
  /// **'Ride fare related Issues'**
  String get rideFareIssues;

  /// No description provided for @captainVehicleIssues.
  ///
  /// In en, this message translates to:
  /// **'Captain and Vehicle related issues'**
  String get captainVehicleIssues;

  /// No description provided for @paymentIssues.
  ///
  /// In en, this message translates to:
  /// **'Pass and Payment related Issues'**
  String get paymentIssues;

  /// No description provided for @parcelIssues.
  ///
  /// In en, this message translates to:
  /// **'Parcel Related Issues'**
  String get parcelIssues;

  /// No description provided for @otherTopics.
  ///
  /// In en, this message translates to:
  /// **'Other Topics'**
  String get otherTopics;

  /// No description provided for @myRewards.
  ///
  /// In en, this message translates to:
  /// **'My Rewards'**
  String get myRewards;

  /// No description provided for @rewardBalance.
  ///
  /// In en, this message translates to:
  /// **'Reward Balance'**
  String get rewardBalance;

  /// No description provided for @redeemYourRewards.
  ///
  /// In en, this message translates to:
  /// **'Redeem your rewards and enjoy benefits'**
  String get redeemYourRewards;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @referAndEarn.
  ///
  /// In en, this message translates to:
  /// **'Refer & Earn'**
  String get referAndEarn;

  /// No description provided for @inviteFriendsEarn.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends & Earn Rewards'**
  String get inviteFriendsEarn;

  /// No description provided for @referDescription.
  ///
  /// In en, this message translates to:
  /// **'Invite your friends to join and get rewards when they take their first ride.'**
  String get referDescription;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @inviteYourFriend.
  ///
  /// In en, this message translates to:
  /// **'Invite your Friend'**
  String get inviteYourFriend;

  /// No description provided for @sendInviteLink.
  ///
  /// In en, this message translates to:
  /// **'Send them your referral link'**
  String get sendInviteLink;

  /// No description provided for @friendSignsUp.
  ///
  /// In en, this message translates to:
  /// **'Friend Signs Up'**
  String get friendSignsUp;

  /// No description provided for @signupWithReferral.
  ///
  /// In en, this message translates to:
  /// **'They sign up using your referral code'**
  String get signupWithReferral;

  /// No description provided for @earnRewards.
  ///
  /// In en, this message translates to:
  /// **'Earn Rewards'**
  String get earnRewards;

  /// No description provided for @getCashbackOnFirstRide.
  ///
  /// In en, this message translates to:
  /// **'Get cashback when your friend completes their first ride'**
  String get getCashbackOnFirstRide;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @myRating.
  ///
  /// In en, this message translates to:
  /// **'My Rating'**
  String get myRating;

  /// No description provided for @parcelSendItems.
  ///
  /// In en, this message translates to:
  /// **'Parcel - Send Items'**
  String get parcelSendItems;

  /// No description provided for @myRides.
  ///
  /// In en, this message translates to:
  /// **'My Rides'**
  String get myRides;

  /// No description provided for @safety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get safety;

  /// No description provided for @referAndEarnSub.
  ///
  /// In en, this message translates to:
  /// **'Get ₹50'**
  String get referAndEarnSub;

  /// No description provided for @powerPass.
  ///
  /// In en, this message translates to:
  /// **'Power Pass'**
  String get powerPass;

  /// No description provided for @rapidoCoins.
  ///
  /// In en, this message translates to:
  /// **'Rapido Coins'**
  String get rapidoCoins;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @deleteAccountConfirmMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountConfirmMsg;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted successfully.'**
  String get accountDeleted;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logoutConfirmMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmMsg;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @safetyConcern.
  ///
  /// In en, this message translates to:
  /// **'Safety Concern'**
  String get safetyConcern;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @cancelRefund.
  ///
  /// In en, this message translates to:
  /// **'Cancel & Refund'**
  String get cancelRefund;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
