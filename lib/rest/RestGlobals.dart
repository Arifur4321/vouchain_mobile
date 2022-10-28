import 'dart:convert';

///Classe di utiliy per memorizzare variabili utili per i servizi REST

//URL del server
const String BASE_URL = 'https://test.vouchain.it/VouChain';

//const String BASE_URL = 'https://vouchain.it:8085/VouChain';

//URI User
//GET
const String support = BASE_URL + '/api/user/assistance';
const String faq = BASE_URL + '/api/user/faq/'; //{profile}

//POST
const String passwordRecovery =
    BASE_URL + '/api/users/changePassword/'; //{profile}
const String passwordChange = BASE_URL + '/api/users/replacePassword';
const String passwordReset =
    BASE_URL + '/api/users/modifyPassword/'; //{resetCode}

const String verifySession = BASE_URL + '/api/session/verifySession';
const String resetSession = BASE_URL + '/api/session/resetSession';
const String checkSession = BASE_URL + '/api/session/checkSession';

const String transactionList = BASE_URL + '/api/transactions/transactionsList';
const String transactionExport =
    BASE_URL + '/api/transactions/exportTransaction';
const String allocateVoucher = BASE_URL + '/api/vouchers/voucherAllocation';

//URI Employee
//GET
const String checkInvitationCode =
    BASE_URL + '/api/employees/checkInvitationCode/'; //{p_invitation_code}
const String empVoucherListAll =
    BASE_URL + '/api/vouchers/getExpendableVouchersList/'; //{userId}

const String empVoucherList =
    BASE_URL + '/api/vouchers/getExpendableVouchersListnotExpired/'; //{userId}

    
const String getEmpProfile =
    BASE_URL + '/api/employees/showEmployeeProfile/'; //{usrId}

//POST
const String empLogin = BASE_URL + '/api/employees/employeeLogin';
const String empSignup = BASE_URL + '/api/employees/employeeConfirmation';
const String modEmpProfile = BASE_URL + '/api/employees/modEmployeeProfile';

//URI Merchant
//GET
const String mrcVoucherList =
    BASE_URL + '/api/vouchers/getExpendedVoucherList/';
const String getMrcProfile =
    BASE_URL + '/api/merchants/showMerchantProfile/'; //{usrId}

//POST
const String mrcLogin = BASE_URL + '/api/merchants/merchantLogin';
const String mrcGISList = BASE_URL + '/api/merchants/searchMerchantGIS';
const String modMrcProfile = BASE_URL + '/api/merchants/modMerchantProfile';

//ALTRO
//GET
const String getAllProvinces = BASE_URL + '/api/geographic/getAllProvinces';
const String getCitiesByProvince =
    BASE_URL + '/api/geographic/getAllCitiesByProvince/'; //{idProvince}
const String getQrList = BASE_URL + '/api/qrcode/listQRCode/'; //{usrId}

//POST
const String getMerchantFromQrCode = BASE_URL + '/api/qrcode/inspectQRCode/';
const String manageQrCode =
    BASE_URL + '/api/qrcode/manageQRCode/'; //{operation}

//HTTP Headers
final usrHeader = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  'Access-Control-Allow-Origin': '*',
  'Authorization': 'Basic ' + base64.encode(utf8.encode('user:123456'))
};

final empHeader = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  'Access-Control-Allow-Origin': '*',
  'Authorization': 'Basic ' + base64.encode(utf8.encode('employee:123456'))
};

final mrcHeader = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  'Access-Control-Allow-Origin': '*',
  'Authorization': 'Basic ' + base64.encode(utf8.encode('merchant:123456'))
};

final cpyHeader = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  'Access-Control-Allow-Origin': '*',
  'Authorization': 'Basic ' + base64.encode(utf8.encode('company:123456'))
};

final vchHeader = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  'Access-Control-Allow-Origin': '*',
  'Authorization': 'Basic ' + base64.encode(utf8.encode('voucher:123456'))
};

final trcHeader = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  'Access-Control-Allow-Origin': '*',
  'Authorization': 'Basic ' + base64.encode(utf8.encode('transaction:123456'))
};

final qrHeader = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  'Access-Control-Allow-Origin': '*',
  'Authorization': 'Basic ' + base64.encode(utf8.encode('qrcode:123456'))
};
