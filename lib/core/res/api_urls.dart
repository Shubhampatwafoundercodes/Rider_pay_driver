class ApiUrls {
  static const baseUrl='https://riderpay.codescarts.com/api';
  static const loginUrl='$baseUrl/driver/login';
  static const registerUrl='$baseUrl/driver/register';
  static const sendOtpUrl = 'https://otp.fctechteam.org/send_otp.php?mode=live&digit=6&mobile=';
  static const verifyOtpUrl = 'https://otp.fctechteam.org/verifyotp.php?mobile=';
  static const vehicleTypeUrl ="$baseUrl/system/vehicleType";
  static const vehicleTypeUpload ="$baseUrl/driver/selectVehicle?";
  static const getServiceCityUrl ="$baseUrl/driver/getCities";
  static const getProfile ="$baseUrl/driver/getDriverProfile?driver_id=";
  static const driverUploadUrl ="$baseUrl/driver/uploadDocument";
  static const getPerformanceUrl ="$baseUrl/driver/getPerformance?driver_id=";
  static const getLanguageSpeakUrl ="$baseUrl/driver/getlanguage";
  static const supportFqUrl ="$baseUrl/driver/getDriverFaq";
  static const updateProfileUrl ="$baseUrl/driver/update-profile";
  static const driverOnOfStatusUrl ="$baseUrl/driver/updateDriverStatus";
  static const notificationUrl ="$baseUrl/user/getNotifications?userId=";
  static const deleteProfile ="$baseUrl/driver/deleteProfile?driverId=";
  static const addBankAccUrl ="$baseUrl/driver/addDriverBankDetails";
  static const getBankDetailsUrl ="$baseUrl/driver/getDriverBankDetails?driverId=";
  static const deleteBankDetailsUrl ="$baseUrl/driver/deleteDriverBankDetails?id=";
  static const rideBookingHistoryUrl ="$baseUrl/booking/getBookingHistoryByDriverId?driverId=";
  static const creditWithdrawHistory ="$baseUrl/driver/getTransactionHistory?driverId=";
  static const completeBookingRide ="$baseUrl/booking/completeBooking?ride_id=";
  static const completePaymentRide ="$baseUrl/booking/updatePaymentDetails";
  static const getDriverEarningUrl ="$baseUrl/driver/getDriverEarnings?driver_id=";
  static const createPaying ="$baseUrl/driver/createAdminSettelment";
  static const adminTransaction ="$baseUrl/driver/getDriverSettelmentHistory?userId=";
  static const userAppUrl ="$baseUrl/driver/getSystemData";
  static const withdrawUrl ="$baseUrl/driver/driverWithdrawal";















// static const getAppInfo ="$baseUrl/system/systemApi";
  // static const addressType ="$baseUrl/system/addressType";
  // static const updateProfile ="$baseUrl/user/updateProfile";
  //
  // static const getVoucherUrl ="$baseUrl/user/getUserVouchers?userId=";
  // static const getCmsUrl ="$baseUrl/system/getCmsPages";
  // static const rideBookingUrl ="$baseUrl/booking/createBooking";
  // static const cancelBookingUrl ="$baseUrl/booking/cancelBooking";
  // static const rideBookingHistoryUrl ="$baseUrl/booking/getBookingHistoryByUserId?userId=";
  // static const reasonOfCancel ="$baseUrl/system/reasonOfCancel";


}



class MapUrls{
  static const baseUrl='https://maps.googleapis.com/';
  // static const mapKey="AIzaSyCOqfJTgg1Blp1GIeh7o8W8PC1w5dDyhWI";
  static const mapKey="AIzaSyATBUdpLdjn6rjEHIsnah_ZSVr7p5LnyQ4";
  static const  searchPlaceUrl = 'maps/api/place/autocomplete/json';
  static const  placeDetailsUrl = 'maps/api/place/details/json';
  static const  drawRouteUrl = 'maps/api/directions/json';
  static const  distanceUrl = 'maps/api/distancematrix/json';


}