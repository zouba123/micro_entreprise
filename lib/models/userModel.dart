// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators
class User {
  int id;
  String firstName;
  String lastName;
  int mobile;
  String email;
  DateTime birthdate;
  String imagePath;
  bool isTermAgreed;
  int loginPin;
  bool isLogin;
  bool isActive;
  bool isDelete;
  DateTime createdAt;
  DateTime modifiedAt;
  int businessId;

  User();

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    mobile = int.parse(map['mobile']);
    email = map['email'];
    if (map['birthdate'] != '') {
      birthdate = DateTime.parse(map['birthdate']);
    }
    imagePath = map['imagePath'];
    isTermAgreed = map['isTermAgreed'] == 'true' ? true : false;
  
    if (map['loginPin'] != null) {
      loginPin = int.parse(map['loginPin']);
    }
    isLogin = map['isLogin'] == 'true' ? true : false;
    isActive = map['isActive'] == 'true' ? true : false;
    isDelete = map['isDelete'] == 'true' ? true : false;
    createdAt = DateTime.parse(map['createdAt']);
    modifiedAt = DateTime.parse(map['modifiedAt']);
    businessId = map['businessId'];
  
  }

  Map<String, dynamic> toMap(bool _isInsert) {
    var _obj =  {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
      'email': email,
      'birthdate': (birthdate != null) ? birthdate.toString() : '',
      'imagePath': imagePath,
      'isTermAgreed': isTermAgreed.toString(),
      'loginPin': loginPin,
      'isLogin': isLogin.toString(),
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
}
