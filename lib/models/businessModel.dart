// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators
class Business {
  int id;
  String name;
  int contact1;
  int contact2;
  String email;
  String website;
  String registrationNo;
  String gstNo;
  DateTime startDate;
  int businessTypeId;
  String logoPath;
  String googleMapUrl;
  String latitude;
  String longitude;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String country;
  int pincode;
  bool isActive;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;

  Business();

  Business.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    if (map['contact1'] != null) {
      contact1 = int.parse(map['contact1']);
    }
    if (map['contact2'] != null) {
      contact2 = int.parse(map['contact2']);
    }
    email = map['email'];
    website = map['website'];
    registrationNo = map['registrationNo'];
    gstNo = (map['gstNo'] != null) ? map['gstNo'] : '';
    if (map['startDate'] != '') {
      startDate = DateTime.parse(map['startDate']);
    }
    businessTypeId = map['businessTypeId'];
    logoPath = map['logoPath'];
    googleMapUrl = map['googleMapUrl'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    addressLine1 = map['addressLine1'];
    addressLine2 = map['addressLine2'];
    city = map['city'];
    state = map['state'];
    country = map['country'];
    pincode = map['pincode'];
    isActive = map['isActive'] == 'true' ? true : false;
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact1': contact1,
      'contact2': contact2,
      'email': email,
      'website': website,
      'registrationNo': registrationNo,
      'gstNo': gstNo,
      'startDate': (startDate != null) ? startDate.toString() : '',
      'businessTypeId': businessTypeId,
      'logoPath': logoPath,
      'googleMapUrl': googleMapUrl,
      'latitude': latitude,
      'longitude': longitude,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'isActive': isActive,
      'isDelete': isDelete,
      'createdAt': createdAt.toString(),
      'modifiedAt': modifiedAt.toString(),
    };
  }
}

class FinancialYear {
  int start;
  int end;
  bool isSelected = false;
  FinancialYear(this.start, this.end);
}
