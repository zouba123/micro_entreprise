// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators
import 'package:contacts_service/contacts_service.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

class Account {
  int id;
  int accountCode;
  String accountType;
  String firstName;
  String lastName;
  String middleName;
  String mobile;
  String phone;
  String email;
  DateTime birthdate;
  DateTime anniversary;
  String gender;
  String imagePath;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String country;
  String namePrefix;
  String nameSuffix;
  String businessName;
  int pincode;
  bool isActive;
  bool isDelete;
  String gstNo;
  DateTime createdAt;
  DateTime modifiedAt;
  double totalSpent;
  double totalPaid;
  double totalDue;
  double totaInvoiceReturnAmount;
  List<Payment> paymentList = [];
  int businessId;
  String mobileCountryCode;
  String phoneCountryCode;
  double totalAdvanced;

  Account();

  Account.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    accountCode = int.parse(map['accountCode']);
    accountType = map['accountType'];
    firstName = map['firstName'] != null ? map['firstName'] : '';
    lastName = map['lastName'] != null ? map['lastName'] : '';
    middleName = map['middleName'] != null ? map['middleName'] : '';
    namePrefix = map['namePrefix'] != null ? map['namePrefix'] : '';
    nameSuffix = map['nameSuffix'] != null ? map['nameSuffix'] : '';
    businessName = map['businessName'] != null ? map['businessName'] : '';
    gstNo = map['gstNo'] != null ? map['gstNo'] : '';
    mobile = map['mobile'] != null ? map['mobile'] : '';
    phone = map['phone'] != null ? map['phone'] : '';
    mobileCountryCode = map['mobileCountryCode'] != null ? map['mobileCountryCode'] : '';
    phoneCountryCode = map['phoneCountryCode'] != null ? map['phoneCountryCode'] : '';
    email = map['email'] != null ? map['email'] : '';
    if (map['birthdate'] != '') {
      birthdate = DateTime.parse(map['birthdate']);
    }
    if (map['anniversary'] != '') {
      anniversary = DateTime.parse(map['anniversary']);
    }
    gender = map['gender'] != null ? map['gender'] : '';
    imagePath = map['imagePath'] != null ? map['imagePath'] : '';
    addressLine1 = map['addressLine1'] != null ? map['addressLine1'] : '';
    addressLine2 = map['addressLine2'] != null ? map['addressLine2'] : '';
    city = map['city'] != null ? map['city'] : '';
    state = map['state'] != null ? map['state'] : '';
    country = map['country'] != null ? map['country'] : '';
    pincode = (map['pincode'] != null && map['pincode'] != '') ? int.parse(map['pincode']) : null;
    isActive = map['isActive'] == 'true' ? true : false;
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];
    totalSpent = map['totalSpent'] != null ? double.parse(map['totalSpent'].toString()) : 0.0;
    totalPaid = map['totalPaid'] != null ? double.parse(map['totalPaid'].toString()) : 0.0;
    totaInvoiceReturnAmount = map['totaInvoiceReturnAmount'] != null ? double.parse(map['totaInvoiceReturnAmount'].toString()) : 0.0;
    totalSpent -= totaInvoiceReturnAmount;
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj = {
      'id': id,
      'accountCode': accountCode.toString(),
      'accountType': accountType,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'namePrefix': namePrefix,
      'nameSuffix': nameSuffix,
      'businessName': businessName,
      'gstNo': gstNo,
      'mobile': mobile.toString(),
      'phone': (phone != null) ? phone.toString() : '',
      'mobileCountryCode': mobileCountryCode,
      'phoneCountryCode': phoneCountryCode,
      'email': email,
      'birthdate': (birthdate != null) ? birthdate.toString() : '',
      'anniversary': (anniversary != null) ? anniversary.toString() : '',
      'gender': gender,
      'imagePath': imagePath,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'country': country,
      'pincode': (pincode != null) ? pincode.toString() : '',
      'isActive': isActive.toString(),
      'isDelete': isDelete.toString(),
      'modifiedAt': modifiedAt.toString(),
      'businessId ': businessId
    };

    if (_isInsert) {
      _obj['createdAt'] = createdAt.toString();
    }
    return _obj;
  }

  Account.fromContactMap(Contact contact, String _accountType, int _accountCode) {
    accountCode = _accountCode;
    createdAt = DateTime.now();
    modifiedAt = DateTime.now();
    isActive = true;
    isDelete = false;
    gender = 'Male';
    namePrefix = contact.prefix;
    nameSuffix = contact.suffix;
    firstName = (contact.givenName != null) ? contact.givenName : contact.displayName;
    lastName = (contact.familyName != null) ? contact.familyName : '';
    middleName = (contact.middleName != null) ? contact.middleName : '';
    email = contact.emails != null && contact.emails.length > 0 ? contact.emails.first.value : null;
    imagePath = "";
    mobileCountryCode = '${global.country.isoCode.substring(1)}';
    phoneCountryCode = '${global.country.isoCode.substring(1)}';

    // getting contacts start
    List<String> _mobileNumberList = [];

    for (int i = 0; i < contact.phones.length; i++) {
      _mobileNumberList.add(contact.phones.elementAt(i).value);
    }
    try {
      for (int i = 0; i < _mobileNumberList.length; i++) {
        if (_mobileNumberList[i].contains(' ')) {
          _mobileNumberList[i] = _mobileNumberList[i].replaceAll(' ', '');
        }

        if (_mobileNumberList[i].contains('-')) {
          _mobileNumberList[i] = _mobileNumberList[i].replaceAll('-', '');
        }
        if (_mobileNumberList[i].contains('(')) {
          _mobileNumberList[i] = _mobileNumberList[i].replaceAll('(', '');
        }
        if (_mobileNumberList[i].contains(')')) {
          _mobileNumberList[i] = _mobileNumberList[i].replaceAll(')', '');
        }
        _mobileNumberList[i] = _mobileNumberList[i].substring(_mobileNumberList[i].length - 10);
      }
    } catch (e) {
      print('exception(1): accountModel.dart ' + e.toString());
    }
    mobile = (_mobileNumberList.length > 0) ? _mobileNumberList[0] : null;
    try {
      // check and assign phone number start
      for (int i = 0; i < _mobileNumberList.length; i++) {
        if (i > 0 && phone == null) {
          if (_mobileNumberList[i] != mobile) {
            phone = _mobileNumberList[i];
          }
        }
      }
      // check and assign phone number end
    } catch (e) {
      print('exception(2): accountModel.dart ' + e.toString());
    }
    // getting contacts end
    city = contact.postalAddresses != null && contact.postalAddresses.length > 0 ? contact.postalAddresses.first.city : '';
    birthdate = contact.birthday != null ? DateTime(contact.birthday.year, contact.birthday.month, contact.birthday.day) : null;
    accountType = _accountType;
    addressLine1 = contact.postalAddresses != null && contact.postalAddresses.length > 0
        ? contact.postalAddresses.first.street != null
            ? contact.postalAddresses.first.street
            : null
        : null;
    pincode = contact.postalAddresses != null && contact.postalAddresses.length > 0
        ? contact.postalAddresses.first.postcode != null
            ? int.parse(contact.postalAddresses.first.postcode)
            : null
        : null;
    addressLine2 = "";
    country = contact.postalAddresses != null && contact.postalAddresses.length > 0
        ? contact.postalAddresses.first.country != null
            ? contact.postalAddresses.first.country
            : ''
        : '';
  }
}
