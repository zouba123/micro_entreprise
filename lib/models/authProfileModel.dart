// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators
class AuthProfile {
  String id;
  String oAuthProviderName;
  // ignore: non_constant_identifier_names
  String access_Token;
  String oAuthUserName; 
  String oAuthPicUrl;
  String emailId;

  AuthProfile(this.id, this.oAuthProviderName, this.access_Token, this.oAuthUserName, this.oAuthPicUrl, this.emailId);

  AuthProfile.fromMap(Map<String, dynamic> map, oAuthProviderName) {
    id = map['id'];
    oAuthProviderName = oAuthProviderName;
    access_Token = map['access_Token'];
    oAuthUserName = map['oAuthUserName'];
    oAuthPicUrl = map['oAuthPicUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'oAuthProviderName': oAuthProviderName,
      'access_Token': access_Token,
      'oAuthUserName': oAuthUserName,
      'oAuthPicUrl': oAuthPicUrl,
    };
  }
}
