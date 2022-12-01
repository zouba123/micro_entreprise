// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables

import 'dart:core';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/Theme/nativeTheme.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/accountSearchModel.dart';
import 'package:accounting_app/models/businessLayer/baseroute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/accountScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AccountAddScreen extends BaseRoute {
  final Account account;
  final int returnScreenId;
  final bool isAddAsCustomer;

  AccountAddScreen({@required a, @required o, this.account, this.returnScreenId, this.isAddAsCustomer}) : super(a: a, o: o, r: 'AccountAddScreen');

  @override
  _AccountAddScreenState createState() => _AccountAddScreenState(this.returnScreenId, this.account, this.isAddAsCustomer);
}

class _AccountAddScreenState extends BaseRouteState {
  File _image;
  Account account;
  final bool isAddAsCustomer;
  final _fLastName = FocusNode();
  final _fMiddleName = FocusNode();
  final _fMobile = FocusNode();
  final _fPhone = FocusNode();
  // final _fMobileCountryCode =  FocusNode();
  // final _fPhoneCountryCode =  FocusNode();
  final _fEmail = FocusNode();
  final _fAddressLine1 = FocusNode();
  final _fAddressLine2 = FocusNode();
  final _fCity = FocusNode();
  final _fState = FocusNode();
  final _fCountry = FocusNode();
  final _fPincode = FocusNode();
  final _fBusinessName = FocusNode();
  final _fNamePrefix = FocusNode();
  final _fNameSuffix = FocusNode();
  final _fFirstName = FocusNode();
  final _fGstNo = FocusNode();
  bool _autovalidate = false;
  TextEditingController _cGstNo = TextEditingController();
  TextEditingController _cAddressLine1 = TextEditingController();
  TextEditingController _cAddressLine2 = TextEditingController();
  TextEditingController _cCity = TextEditingController();
  TextEditingController _cMobile = TextEditingController();
//  TextEditingController _cMobileCountryCode =  TextEditingController();
  TextEditingController _cCountry = TextEditingController();
  TextEditingController _cBirthdate = TextEditingController();
  TextEditingController _cAnniversary = TextEditingController();
  TextEditingController _cEmail = TextEditingController();
  TextEditingController _cFirstName = TextEditingController();
  TextEditingController _cMiddleName = TextEditingController();
  TextEditingController _cPhone = TextEditingController();
//  TextEditingController _cPhoneCountryCode =  TextEditingController();
  TextEditingController _cNamePrefix = TextEditingController();
  TextEditingController _cNameSuffix = TextEditingController();
  TextEditingController _cBusinessName = TextEditingController();
  FocusNode _fBirthdate = FocusNode();
  FocusNode _fAnniversary = FocusNode();
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String _gender = 'Male';
  bool _isMobileExist = false;
  bool _isEmailExist = false;
  String _photopath = '';
  String _accountType = 'Customer';
  String _birthDate;
  String _anniversary;
  bool _isActive = true;
  TextEditingController _cLastName = TextEditingController();
  TextEditingController _cPincode = TextEditingController();
  int _selected = 0;
  TextEditingController _cState = TextEditingController();
  var _year;
  bool _isCustomer = true;
  bool _isSupplier = false;
  String _generatedAccountCode;

  int returnScreenId;
  bool _moreFields = false;
  List<CountryCode> _countryCodeList;
  CountryCode _mobileCountryCode;
  CountryCode _phoneCountryCode;
  DateTime _oldBirthday;
  DateTime _oldAnniversary;
  bool _isbirthDaySelection = true;

  _AccountAddScreenState(this.returnScreenId, this.account, this.isAddAsCustomer) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          account.id == null ? global.appLocaleValues['tle_add_ac'] : global.appLocaleValues['tle_update_ac'],
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        //  : Text(global.appLocaleValues['tle_update_ac']),
        actions: <Widget>[
          TextButton(
              child: Text(global.appLocaleValues['btn_save'], style: Theme.of(context).primaryTextTheme.headline2),
              onPressed: () async {
                await _onSubmit();
              }),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                // Text(
                //   'Account code:  $_generatedAccountCode',
                //   style: TextStyle(fontSize: 17),
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColorDark,
                              radius: 71,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                // foregroundColor: Theme.of(context).primaryColorLight,
                                radius: 69,
                                child: ClipOval(
                                    child: (_photopath != '')
                                        ? Image.file(File(_photopath))
                                        : Icon(
                                            Icons.person,
                                            size: 110,
                                            color: Theme.of(context).primaryColor,
                                          )),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 100, top: 80),
                              child: FloatingActionButton(
                                backgroundColor: Colors.grey[50],
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 25,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                onPressed: () async {
                                  await _openUploadPicOptions(context);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    (_moreFields)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 10, top: 20),
                            child: Text(
                              global.appLocaleValues['tle_persoanal_info'],
                              style: Theme.of(context).primaryTextTheme.headline5,
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(Icons.person),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(global.appLocaleValues['lbl_name_pre'], style: Theme.of(context).primaryTextTheme.headline3),
                              ],
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: TextFormField(
                              focusNode: _fNamePrefix,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.sentences,
                              // inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Za-z]'))],
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))],
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fFirstName);
                              },
                              decoration: InputDecoration(
                                // icon: Icon(Icons.person),
                                border: nativeTheme().inputDecorationTheme.border,
                                hintText: global.appLocaleValues['lbl_name_pre'],
                                counterText: '',
                              ),
                              controller: _cNamePrefix,
                              maxLength: 25,
                            ),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.person,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(global.appLocaleValues['txt_firstName'], style: Theme.of(context).primaryTextTheme.headline3),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(
                        cursorColor: Theme.of(context).primaryColorDark,
                        focusNode: _fFirstName,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        //  inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Za-z]'))],
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))],
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus((_moreFields) ? _fMiddleName : _fLastName);
                        },
                        decoration: InputDecoration(
                          hintText: global.appLocaleValues['txt_firstName'],
                          border: nativeTheme().inputDecorationTheme.border,

                          //suffixText: '*',
                          suffixIcon: Icon(
                            Icons.star,
                            size: 9,
                            color: Colors.red,
                          ),

                          counterText: '',
                        ),
                        controller: _cFirstName,
                        maxLength: 25,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return global.appLocaleValues['vel_firstName'];
                          } else if (value.contains(RegExp('[0-9]'))) {
                            return global.appLocaleValues['vel_character_only'];
                          }
                          return null;
                        },
                      ),
                    ),
                    (_moreFields)
                        ? Padding(
                            padding: EdgeInsets.only(left: 8, right: 8, top: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _cMiddleName,
                              textCapitalization: TextCapitalization.sentences,
                              focusNode: _fMiddleName,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fLastName);
                              },
                              textInputAction: TextInputAction.next,
                              //  inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Za-z]'))],
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))],

                              maxLength: 25,
                              decoration: InputDecoration(
                                border: nativeTheme().inputDecorationTheme.border,
                                // icon: Icon(
                                //   Icons.people,
                                //   color: Colors.white,
                                // ),
                                counterText: '',
                                hintText: global.appLocaleValues['lbl_middle_name'],
                              ),
                              validator: (String value) {
                                if (value.isNotEmpty) {
                                  if (value.contains(RegExp('[0-9]'))) {
                                    return global.appLocaleValues['vel_character_only'];
                                  }
                                }
                                return null;
                              },
                            ),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(Icons.person),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            global.appLocaleValues['txt_lastName'],
                            style: Theme.of(context).primaryTextTheme.headline3,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _cLastName,
                        textCapitalization: TextCapitalization.sentences,
                        focusNode: _fLastName,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus((_moreFields) ? _fNameSuffix : _fMobile);
                        },
                        textInputAction: TextInputAction.next,
                        //  inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Za-z]'))],
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))],

                        maxLength: 25,
                        decoration: InputDecoration(
                          // icon: Icon(
                          //   Icons.people,
                          //   color: Colors.white,
                          // ),
                          suffixIcon: Icon(
                            Icons.star,
                            size: 9,
                            color: Colors.red,
                          ),
                          border: nativeTheme().inputDecorationTheme.border,
                          counterText: '',
                          hintText: global.appLocaleValues['txt_lastName'],
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return global.appLocaleValues['hnt_lastName'];
                          } else if (value.isNotEmpty) {
                            if (value.contains(RegExp('[0-9]'))) {
                              return global.appLocaleValues['vel_character_only'];
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    (_moreFields)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(MdiIcons.tie),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(global.appLocaleValues['lbl_name_suf'], style: Theme.of(context).primaryTextTheme.headline3),
                              ],
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _cNameSuffix,
                              textCapitalization: TextCapitalization.sentences,
                              focusNode: _fNameSuffix,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fBirthdate);
                              },
                              textInputAction: TextInputAction.next,
                              //   inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Za-z]'))],
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))],

                              maxLength: 25,
                              decoration: InputDecoration(
                                // icon: Icon(
                                //   Icons.people,
                                //   color: Colors.white,
                                // ),
                                counterText: '',
                                hintText: global.appLocaleValues['lbl_name_suf'],
                                border: nativeTheme().inputDecorationTheme.border,
                              ),
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(global.appLocaleValues['lbl_dob'], style: Theme.of(context).primaryTextTheme.headline3),
                              ],
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                // icon: Icon(Icons.calendar_today),
                                hintText: global.appLocaleValues['lbl_dob'],
                                border: nativeTheme().inputDecorationTheme.border,
                              ),
                              focusNode: _fBirthdate,
                              controller: _cBirthdate,
                              keyboardType: null,
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("${global.appLocaleValues['lbl_anniversary']} (${global.appLocaleValues['lbl_optional']})", style: Theme.of(context).primaryTextTheme.headline3),
                              ],
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                // icon: Icon(Icons.calendar_today, color: Colors.white),
                                hintText: '${global.appLocaleValues['lbl_anniversary']} (${global.appLocaleValues['lbl_optional']})',
                                border: nativeTheme().inputDecorationTheme.border,
                              ),
                              focusNode: _fAnniversary,
                              controller: _cAnniversary,
                              keyboardType: null,
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
                (_moreFields)
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(MdiIcons.genderMaleFemale),
                            SizedBox(
                              width: 5,
                            ),
                            Text(global.appLocaleValues['lbl_gender'], style: Theme.of(context).primaryTextTheme.headline3),
                          ],
                        ),
                      )
                    : SizedBox(),
                (_moreFields)
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]), borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: RadioListTile(
                                  dense: false,
                                  value: 0,
                                  groupValue: _selected,
                                  title: Text(global.appLocaleValues['lbl_male']),
                                  onChanged: (int value) {
                                    _onChangeRBytton(value);
                                  },
                                ),
                              ),
                              Flexible(
                                child: RadioListTile(
                                  dense: false,
                                  value: 1,
                                  groupValue: _selected,
                                  title: Text(global.appLocaleValues['lbl_female']),
                                  onChanged: (int value) {
                                    _onChangeRBytton(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                (_moreFields) ? Divider() : SizedBox(),
                (_moreFields)
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                          child: Text(
                            global.appLocaleValues['tle_contact_info'],
                            style: Theme.of(context).primaryTextTheme.headline5,
                          ),
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.phone),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        global.appLocaleValues['lbl_contact'],
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: (_moreFields) ? EdgeInsets.only(left: 8, right: 8) : EdgeInsets.only(left: 8, right: 8, top: 0),
                  child: Row(
                    children: <Widget>[
                      _dropDownWCountryCodeWidget(0, context),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          controller: _cMobile,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          focusNode: _fMobile,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus((_moreFields) ? _fPhone : _fEmail);
                          },
                          textInputAction: TextInputAction.next,
                          maxLength: 10,
                          decoration: InputDecoration(
                              counterText: '',
                              //  icon: Icon(Icons.phone),
                              border: nativeTheme().inputDecorationTheme.border,
                              // labelText: global.appLocaleValues['lbl_contact'],
                              hintText: global.appLocaleValues['hnt_contactno'],
                              errorText: _isMobileExist ? global.appLocaleValues['vel_contactno_exist'] : null),
                          validator: (value) {
                            if (value.isNotEmpty) {
                              if (value.contains(RegExp('[a-zA-Z]'))) {
                                return global.appLocaleValues['vel_enter_number_only'];
                              } else if (value.length != 10) {
                                return global.appLocaleValues['vel_contactno'];
                              } else if (_isMobileExist) {
                                return global.appLocaleValues['vel_contactno_exist'];
                              }
                            }
                            return null;
                          },
                          onChanged: (String value) async {
                            if (account.id != null && _cMobile.text == account.mobile) {
                              return null;
                            } else {
                              await _checkMobileExist(value);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                (_moreFields)
                    ? Padding(
                        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                        child: Row(
                          children: <Widget>[
                            _dropDownWCountryCodeWidget(1, context),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                controller: _cPhone,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                focusNode: _fPhone,
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context).requestFocus(_fEmail);
                                },
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isNotEmpty) {
                                    if (value.contains(RegExp('[a-zA-Z]'))) {
                                      return global.appLocaleValues['vel_enter_number_only'];
                                    } else if (value.length != 10) {
                                      return global.appLocaleValues['vel_contactno'];
                                    } else if (_isMobileExist) {
                                      return global.appLocaleValues['vel_contactno_exist'];
                                    }
                                  }
                                  return null;
                                },
                                maxLength: 10,
                                decoration: InputDecoration(
                                  counterText: '',
                                  hintText: global.appLocaleValues['lbl_alt_contactno'],
                                  // hintText: global.appLocaleValues['hnt_contactno'],
                                  border: nativeTheme().inputDecorationTheme.border,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.email),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        global.appLocaleValues['lbl_email'],
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: TextFormField(
                    controller: _cEmail,
                    focusNode: _fEmail,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus((_moreFields) ? _fBusinessName : _fBusinessName);
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        // labelText: global.appLocaleValues['lbl_email'],
                        border: nativeTheme().inputDecorationTheme.border,
                        // icon: Icon(Icons.email),
                        hintText: global.appLocaleValues['vel_email'],
                        errorText: _isEmailExist ? global.appLocaleValues['vel_err_email'] : null),
                    validator: (value) {
                      if (value.isNotEmpty) {
                        if (EmailValidator.validate(value) != true) {
                          return global.appLocaleValues['vel_valid_email'];
                        } else if (_isEmailExist) {
                          return global.appLocaleValues['vel_err_email'];
                        }
                      }
                      return null;
                    },
                    onChanged: (String value) async {
                      if (account.id != null && _cMobile.text == account.email) {
                        return null;
                      } else {
                        _checkEmailExist(value);
                      }
                    },
                  ),
                ),
                (_moreFields)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Divider(),
                      )
                    : SizedBox(),
                (_moreFields)
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                          child: Text(
                            global.appLocaleValues['tle_business_info'],
                            style: Theme.of(context).primaryTextTheme.headline5,
                          ),
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.business),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        global.appLocaleValues['lbl_business'],
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        // icon: Icon(Icons.business),
                        // labelText: global.appLocaleValues['lbl_business'],
                        border: nativeTheme().inputDecorationTheme.border,
                        hintText: global.appLocaleValues['lbl_business']),
                    textInputAction: TextInputAction.next,
                    controller: _cBusinessName,
                    focusNode: _fBusinessName,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_fGstNo);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(MdiIcons.filePercentOutline),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${global.appLocaleValues['lbl_gst_no_']} (${global.appLocaleValues['lbl_optional']})',
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus((_moreFields) ? _fAddressLine1 : _fCity);
                    },
                    focusNode: _fGstNo,
                    controller: _cGstNo,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v.isNotEmpty) {
                        if (v.trim().indexOf('-') == 0 || v.trim().indexOf('-') == (v.length - 1)) {
                          return global.appLocaleValues['lbl_gst_no_err_vld'];
                        }
                      }
                      return null;
                    },
                    //  inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Z0-9,-]'))],
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Z0-9,-]'))],

                    decoration: InputDecoration(
                        // icon: Icon(
                        //   Icons.business,
                        //   color: Colors.white,
                        // ),
                        hintText: '${global.appLocaleValues['lbl_gst_no_']} (${global.appLocaleValues['lbl_optional']})',
                        // labelText: '${global.appLocaleValues['lbl_gst_no_']} (${global.appLocaleValues['lbl_optional']})',
                        border: OutlineInputBorder()),
                  ),
                ),

                (_moreFields)
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(Icons.redeem),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              global.appLocaleValues['lbl_ac_type'],
                              style: Theme.of(context).primaryTextTheme.headline3,
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                (_moreFields)
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.grey[200])),
                          child: Column(
                            children: <Widget>[
                              CheckboxListTile(
                                title: Text(global.appLocaleValues['lbl_customer']),
                                value: _isCustomer,
                                onChanged: (bool val) {
                                  setState(() {
                                    _isCustomer = val;
                                    print(_isCustomer);
                                  });
                                },
                              ),
                              (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) != 'Service' && br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true')
                                  ? CheckboxListTile(
                                      title: Text(global.appLocaleValues['lbl_supplier']),
                                      value: _isSupplier,
                                      onChanged: (bool val) {
                                        setState(() {
                                          _isSupplier = val;
                                          print(_isSupplier);
                                        });
                                      },
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                (_moreFields) ? Divider() : SizedBox(),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 2,
                    ),
                    (_moreFields)
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                              child: Text(
                                global.appLocaleValues['tle_address_info'],
                                style: Theme.of(context).primaryTextTheme.headline5,
                              ),
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(Icons.home_outlined),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  global.appLocaleValues['lbl_address_line1'],
                                  style: Theme.of(context).primaryTextTheme.headline3,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: TextFormField(
                              controller: _cAddressLine1,
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 2,
                              focusNode: _fAddressLine1,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fAddressLine2);
                              },
                              textInputAction: (_moreFields) ? TextInputAction.next : TextInputAction.done,
                              decoration: InputDecoration(
                                  // labelText: global.appLocaleValues['lbl_address_line1'],
                                  // icon: Icon(
                                  //   Icons.location_city,
                                  // ),
                                  border: nativeTheme().inputDecorationTheme.border,
                                  hintText: global.appLocaleValues['hnt_address_line1']),
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(Icons.home_outlined),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  global.appLocaleValues['lbl_address_line2'],
                                  style: Theme.of(context).primaryTextTheme.headline3,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: TextFormField(
                              controller: _cAddressLine2,
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 2,
                              focusNode: _fAddressLine2,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fCity);
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  // labelText: global.appLocaleValues['lbl_address_line2'],
                                  // icon: Icon(
                                  //   Icons.location_city,
                                  //   color: Colors.white,
                                  // ),
                                  border: nativeTheme().inputDecorationTheme.border,
                                  hintText: global.appLocaleValues['hnt_address_line1']),
                            ),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            global.appLocaleValues['lbl_city'],
                            style: Theme.of(context).primaryTextTheme.headline3,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, bottom: !_moreFields ? 70 : 0),
                      child: TextFormField(
                        controller: _cCity,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        focusNode: _fCity,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(_fState);
                        },
                        textInputAction: TextInputAction.next,
                        //  inputFormatters: [FilteringTextInputFormatter(RegExp('[a-zA-Z]'))],
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z ]'))],

                        maxLength: 25,
                        decoration: InputDecoration(
                          // icon: (!_moreFields)
                          //     ? Icon(
                          //         Icons.location_city,
                          //       )
                          //     : Icon(
                          //         Icons.location_city,
                          //         color: Colors.white,
                          //       ),
                          counterText: '',
                          // labelText: global.appLocaleValues['lbl_city'],
                          hintText: global.appLocaleValues['hnt_city'],
                          border: nativeTheme().inputDecorationTheme.border,
                        ),
                      ),
                    ),
                    (_moreFields)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(Icons.location_city),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  global.appLocaleValues['lbl_state'],
                                  style: Theme.of(context).primaryTextTheme.headline3,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: TextFormField(
                              controller: _cState,
                              maxLength: 25,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              //     inputFormatters: [FilteringTextInputFormatter(RegExp('[a-zA-Z]'))],
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))],

                              focusNode: _fState,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fCountry);
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                // icon: Icon(
                                //   Icons.location_city,
                                //   color: Colors.white,
                                // ),
                                counterText: '',
                                // labelText: global.appLocaleValues['lbl_state'],
                                hintText: global.appLocaleValues['hnt_state'],
                                border: nativeTheme().inputDecorationTheme.border,
                              ),
                            ))
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(MdiIcons.earth),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  global.appLocaleValues['lbl_country'],
                                  style: Theme.of(context).primaryTextTheme.headline3,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: TextFormField(
                              controller: _cCountry,
                              maxLength: 25,
                              keyboardType: TextInputType.text,
                              // inputFormatters: [FilteringTextInputFormatter(RegExp('[a-zA-Z]'))],
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))],

                              focusNode: _fCountry,
                              textCapitalization: TextCapitalization.sentences,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fPincode);
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                // icon: Icon(
                                //   Icons.location_city,
                                //   color: Colors.white,
                                // ),
                                // counterText: '',
                                // labelText: global.appLocaleValues['lbl_country'],
                                hintText: global.appLocaleValues['hnt_country'],
                                border: nativeTheme().inputDecorationTheme.border,
                              ),
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 5, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(Icons.location_city),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  global.appLocaleValues['lbl_pincode'],
                                  style: Theme.of(context).primaryTextTheme.headline3,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    (_moreFields)
                        ? Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: TextFormField(
                              controller: _cPincode,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              maxLength: 6,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              focusNode: _fPincode,
                              decoration: InputDecoration(
                                // icon: Icon(
                                //   Icons.location_city,
                                //   color: Colors.white,
                                // ),
                                // counterText: '',
                                // labelText: global.appLocaleValues['lbl_pincode'],
                                hintText: global.appLocaleValues['hnt_pinocde'],
                                border: nativeTheme().inputDecorationTheme.border,
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
                (_moreFields)
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Column(
                          children: <Widget>[
                            Divider(),
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 8, right: 8),
                              minVerticalPadding: 0,
                              leading: Text(
                                global.appLocaleValues['lbl_active'],
                                style: Theme.of(context).primaryTextTheme.headline3,
                              ),
                              trailing: Switch(
                                value: _isActive,
                                onChanged: (value) {
                                  setState(() {
                                    _isActive = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListTile(
          title: Text(
            (!_moreFields) ? global.appLocaleValues['btn_show_more'] : global.appLocaleValues['btn_show_less'],
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onTap: () => setState(() {
            _moreFields = !_moreFields;
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _fBirthdate.removeListener(_focusListener);
    _fAnniversary.removeListener(_focusListener);
  }

  @override
  void initState() {
    super.initState();
    _fBirthdate.addListener(_focusListener);
    _fAnniversary.addListener(_focusListener);
    initCountryCode();
    if (account != null) {
      _fillData();
    } else {
      account = Account();
      _mobileCountryCode = _countryCodeList.elementAt(_countryCodeList.indexWhere((element) => element.code == '${global.country.isoCode.substring(1)}'));
      _phoneCountryCode = _countryCodeList.elementAt(_countryCodeList.indexWhere((element) => element.code == '${global.country.isoCode.substring(1)}'));
      account.phoneCountryCode = '${global.country.isoCode.substring(1)}';
      account.mobileCountryCode = '${global.country.isoCode.substring(1)}';
      _generateAccountCode();
      if (isAddAsCustomer != null && isAddAsCustomer) {
        _isCustomer = true;
      } else if (isAddAsCustomer != null && !isAddAsCustomer) {
        _isCustomer = false;
        _isSupplier = true;
      }
    }
    _getDateTime(DateTime.now());
  }

  Future<void> _checkEmailExist(String value) async {
    try {
      _isEmailExist = false;
      if (EmailValidator.validate(value)) {
        _isEmailExist = await dbHelper.accountCheckEmailExist(value);
      }
      setState(() {});
    } catch (e) {
      print('Exception - accountAddScreen.dart - _checkEmailExist(): ' + e.toString());
    }
  }

  Future _checkMobileExist(String value) async {
    try {
      _isMobileExist = false;
      if (value.contains(RegExp('[0-9]')) && value.length == 10) {
        _isMobileExist = await dbHelper.accountCheckMobileExist(value);
      }
      setState(() {});
    } catch (e) {
      print('Exception - accountAddScreen.dart - _checkMobileExist(): ' + e.toString());
    }
  }

  Future _fillData() async {
    try {
      _generatedAccountCode =
          '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + account.accountCode.toString().length))}${account.accountCode}';
      _cNamePrefix.text = account.namePrefix;
      _cFirstName.text = account.firstName;
      _cMiddleName.text = account.middleName;
      _cLastName.text = account.lastName;
      _cNameSuffix.text = account.nameSuffix;
      _cBusinessName.text = account.businessName;
      _cGstNo.text = account.gstNo;
      _mobileCountryCode = _countryCodeList.elementAt(_countryCodeList.indexWhere((element) => element.code == account.mobileCountryCode));
      _phoneCountryCode = _countryCodeList.elementAt(_countryCodeList.indexWhere((element) => element.code == account.phoneCountryCode));
      //   _cMobileCountryCode.text = account.mobileCountryCode;
      //  _cPhoneCountryCode.text = account.phoneCountryCode;
      _cMobile.text = account.mobile.toString();
      _cEmail.text = account.email;
      if (account.birthdate != null) {
        _cBirthdate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(account.birthdate);
      }
      if (account.anniversary != null) {
        _cAnniversary.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(account.anniversary);
      }
      _cAddressLine1.text = account.addressLine1;
      _cCity.text = account.city;
      _cState.text = account.state;
      _cCountry.text = account.country;
      _cPincode.text = (account.pincode != null) ? account.pincode.toString() : '';
      _cPhone.text = (account.phone != null) ? account.phone.toString() : '';
      _photopath = account.imagePath;
      _cAddressLine2.text = account.addressLine2;
      if (account.gender == 'Male') {
        _selected = 0;
      } else {
        _selected = 1;
      }
      if (account.accountType == 'Customer') {
        _isCustomer = true;
        _isSupplier = false;
      } else if (account.accountType == 'Supplier') {
        _isCustomer = false;
        _isSupplier = true;
      } else if (account.accountType == ',Customer,Supplier,') {
        _isCustomer = true;
        _isSupplier = true;
      }
      // if (account.type == 'Customer') {
      //   _acSelected = 0;
      // } else {
      //   _acSelected = 1;
      // }
      if (account.isActive == true) {
        _isActive = true;
      } else {
        _isActive = false;
      }
      _oldAnniversary = account.anniversary;
      _oldBirthday = account.birthdate;
    } catch (e) {
      print('Exception - accountAddScreen.dart - _filldata(): ' + e.toString());
    }
  }

  Future<Null> _focusListener() async {
    try {
      if (_fBirthdate.hasFocus || _fAnniversary.hasFocus) {
        if (_fBirthdate.hasFocus) {
          _isbirthDaySelection = true;
        } else {
          _isbirthDaySelection = false;
        }
        _selectDate(context);
      }
    } catch (e) {
      print('Exception - accountAddScreen.dart - _focusListener(): ' + e.toString());
    }
  }

  Future _generateAccountCode() async {
    try {
      ///generate account code
      account.accountCode = await dbHelper.accountGetNewAccountCode();
      _generatedAccountCode = '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${account.accountCode}';
      _generatedAccountCode = '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}' + '${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - _generatedAccountCode.length)}' + '${account.accountCode}';
      setState(() {});

      ///
    } catch (e) {
      print('Exception - accountAddScreen.dart - _generateAccountCode(): ' + e.toString());
    }
  }

  void _getDateTime(DateTime _noww) {
    try {
      // set end date before 14 years
      _noww = DateTime.now();
      _year = _noww.year;
      _year = _year - 14;
      //  print('year: $year');
    } catch (e) {
      print('Exception - accountAddScreen.dart - _getDateTime(): ' + e.toString());
    }
  }

  Future _getPath() async {
    try {
      _photopath = global.accountImagesDirectoryPath;
      print(_photopath);
    } catch (e) {
      print('Exception - accountAddScreen.dart - _getPath(): ' + e.toString());
    }
  }

  void _onChangeRBytton(int value) {
    try {
      setState(() {
        _selected = value;
      });
      if (_selected == 0) {
        _gender = 'Male';
      } else {
        _gender = 'Female';
      }
    } catch (e) {
      print('Exception - accountAddScreen.dart - _onChangeRBytton(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    try {
      int _result = 0;
      if (_formKey.currentState.validate()) {
        if (_isSupplier == false && _isCustomer == false) {
          showToast(global.appLocaleValues['vel_select_ac_type']);
        } else {
          // showLoader(global.appLocaleValues['txt_wait']);
          setState(() {});
          if (_isCustomer == true && _isSupplier == false) {
            _accountType = 'Customer';
          } else if (_isCustomer == false && _isSupplier == true) {
            _accountType = 'Supplier';
          } else if (_isCustomer == true && _isSupplier == true) {
            _accountType = ',Customer,Supplier,';
          }
          account.accountType = _accountType;
          account.firstName = _cFirstName.text.trim();
          account.lastName = _cLastName.text.trim();
          account.middleName = _cMiddleName.text.trim();
          account.mobile = _cMobile.text.trim();
          //    account.mobileCountryCode = _cMobileCountryCode.text.trim();
          //    account.phoneCountryCode = _cPhoneCountryCode.text.trim();
          account.phone = _cPhone.text.trim();
          account.email = _cEmail.text.trim();
          if (_birthDate != null) {
            account.birthdate = DateTime.parse(_birthDate);
          }
          if (_anniversary != null) {
            account.anniversary = DateTime.parse(_anniversary);
          }
          account.gender = _gender;
          account.imagePath = _photopath;
          // print('imagePath: ${account.imagePath}');
          account.addressLine1 = _cAddressLine1.text.trim();
          account.addressLine2 = _cAddressLine2.text.trim();
          account.city = _cCity.text.trim();
          account.state = _cState.text.trim();
          account.country = _cCountry.text.trim();
          account.namePrefix = _cNamePrefix.text.trim();
          account.nameSuffix = _cNameSuffix.text.trim();
          account.businessName = _cBusinessName.text.trim();
          account.gstNo = _cGstNo.text.trim();
          if (_cPincode.text.isNotEmpty) {
            account.pincode = int.parse(_cPincode.text.trim());
          }
          account.isActive = _isActive;
          account.isDelete = false;
          if (account.id == null) {
            // add account
            _result = await dbHelper.accountInsert(account);
            account.id = _result;
            //  hideLoader();

          } else {
            // update account
            _result = await dbHelper.accountUpdate(account);
            //hideLoader();
            // AccountSearch accountSearch =  AccountSearch();
            // Navigator.of(context).pushReplacement(MaterialPageRoute(
            //     builder: (BuildContext context) =>  AccountScreen(
            //           redirectToCustomersTab: (isAddAsCustomer) ? true : false,
            //           a: widget.analytics,
            //           o: widget.observer,
            //           accountSearch: accountSearch,
            //         )));
          }

          if (_result > 0) {
            String _notificationTime = br.getSystemFlagValue(global.systemFlagNameList.notificationTime);
            TimeOfDay tod = br.stringToTimeOfDay(_notificationTime);

            int notificationId = int.parse(global.moduleIds['Account'].toString() + '01' + account.id.toString());
            if (account.birthdate != null && account.anniversary != null && account.birthdate.month == account.anniversary.month && account.birthdate.day == account.anniversary.day && (_oldBirthday != account.birthdate || _oldAnniversary != account.anniversary)) {
              await br.scheduleNotification(
                  notificationId, br.getNextEventDate(account.birthdate).add(Duration(hours: tod.hour, minutes: tod.minute)), '${br.generateAccountName(account)}\'s Birthday & Anniversary', 'on ${DateFormat('MMMM dd').format(account.birthdate)}', '{"module":"Account","id":"${account.id}"}',
                  setNextDate: true);
            } else {
              if (account.birthdate != null && _oldBirthday != account.birthdate) {
                int notificationId = int.parse(global.moduleIds['Account'].toString() + '02' + account.id.toString());
                await br.scheduleNotification(
                    notificationId, br.getNextEventDate(account.birthdate).add(Duration(hours: tod.hour, minutes: tod.minute)), '${br.generateAccountName(account)}\'s Birthday', 'on ${DateFormat('MMMM dd').format(account.birthdate)}', '{"module":"Account","id":"${account.id}"}',
                    setNextDate: true);
              }
              if (account.anniversary != null && _oldAnniversary != account.anniversary) {
                int notificationId = int.parse(global.moduleIds['Account'].toString() + '03' + account.id.toString());
                await br.scheduleNotification(
                    notificationId, br.getNextEventDate(account.anniversary).add(Duration(hours: tod.hour, minutes: tod.minute)), '${br.generateAccountName(account)}\'s Anniversary', 'on ${DateFormat('MMMM dd').format(account.anniversary)}', '{"module":"Account","id":"${account.id}"}',
                    setNextDate: true);
              }
            }
            // hideLoader();
            setState(() {});
            if (returnScreenId == 0) {
              AccountSearch accountSearch = AccountSearch();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => AccountScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        accountSearch: accountSearch,
                         redirectToCustomersTab: (isAddAsCustomer) ? true : false,
                      )));
            } else if (returnScreenId == 1) {
              Navigator.of(context).pop(account);
            }
            // else {
            //   // Navigator.of(context).pushReplacement(MaterialPageRoute(
            //   //     builder: (BuildContext context) =>  InvoiceAddSreen(
            //   //           analytics: analytics,
            //   //           observer: observer,
            //   //           routeName: routeName,
            //   //         )));
            // }
          }
        }
      } else {
        _autovalidate = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - accountAddScreen.dart - _onSubmit(): ' + e.toString());
    }
  }

  Future _openUploadPicOptions(context) async {
    try {
      //choose options for upload pic
      await showModalBottomSheet(
          context: context,
          builder: (BuildContext bcon) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(global.appLocaleValues['txt_camera'], style: Theme.of(context).primaryTextTheme.headline3),
                    onTap: () async {
                      await _picImageCamera();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.photo_album,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(global.appLocaleValues['txt_gallery'], style: Theme.of(context).primaryTextTheme.headline3),
                    onTap: () async {
                      await _picImageGallery();
                      Navigator.pop(context);
                    },
                  ),
                  (_photopath != '')
                      ? ListTile(
                          leading: Icon(
                            Icons.cancel,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(global.appLocaleValues['txt_remove_profile'], style: Theme.of(context).primaryTextTheme.headline3),
                          onTap: () {
                            setState(() {
                              _photopath = '';
                            });
                            Navigator.pop(context);
                          },
                        )
                      : SizedBox(),
                  ListTile(
                    leading: Icon(
                      Icons.cancel,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    title: Text(global.appLocaleValues['txt_cancel']),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print('Exception - accountAddScreen.dart - _openUploadPicOptions(): ' + e.toString());
    }
  }

  Future _picImageCamera() async {
    try {
      // when user select camera for upload pic
      global.isAppOperation = true;
      XFile _img = await ImagePicker().pickImage(source: ImageSource.camera);
      if (_img != null) {
        _getPath();
        global.isAppOperation = true;
        File croppedFile = await ImageCropper.cropImage(
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          sourcePath: _img.path,
          maxWidth: 512,
          maxHeight: 512,
        );
        if (croppedFile != null) {
          setState(() {
            _image = croppedFile;
          });
          String imgTime = DateTime.now().toString();
          print(imgTime);
          final File newImage = await _image.copy('$_photopath/img$imgTime.png');
          //   print('path: ${newImage.path}');
          _photopath = newImage.path;
        }
      }
    } catch (e) {
      print('Exception - accountAddScreen.dart - _picImageCamera(): ' + e.toString());
    }
  }

  Future _picImageGallery() async {
    try {
      global.isAppOperation = true;

      XFile img = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (img != null) {
        _getPath();
        global.isAppOperation = true;
        File croppedFile = await ImageCropper.cropImage(
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          sourcePath: img.path,
          maxWidth: 512,
          maxHeight: 512,
        );
        if (croppedFile != null) {
          print(img.path);
          setState(() {
            _image = croppedFile;
          });
          String imgTime = DateTime.now().toString();
          final File newImage = await _image.copy('$_photopath/img$imgTime.png');
          //   print('path: ${newImage.path}');
          _photopath = newImage.path;
        }
      }
    } catch (e) {
      print('Exception - accountAddScreen.dart - _picImageGallery(): ' + e.toString());
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    try {
      DateTime _date = DateTime(2000);
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1940),
        lastDate: (_isbirthDaySelection) ? DateTime(_year) : DateTime.now(),
      );
      if (picked != null && picked != _date) {
        setState(() {
          //   _date=picked;
          if (_isbirthDaySelection) {
            _cBirthdate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
            _birthDate = picked.toString().substring(0, 10);
          } else {
            _cAnniversary.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
            _anniversary = picked.toString().substring(0, 10);
          }
        });
      }

      FocusScope.of(context).requestFocus(_fMobile);
    } catch (e) {
      print('Exception - accountAddScreen.dart - _selectDate(): ' + e.toString());
    }
  }

  Widget _dropDownWCountryCodeWidget(int widgetId, context) {
    try {
      return SizedBox(
        height: 58,
        width: 150,
        child: DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
            // labelText: global.appLocaleValues['txt_country'],
            // icon: (widgetId == 0) ? Icon(Icons.phone) : Icon(Icons.phone, color: Colors.white),
            border: nativeTheme().inputDecorationTheme.border,
          ),
          value: (widgetId == 0) ? _mobileCountryCode : _phoneCountryCode,
          items: _countryCodeList.map((CountryCode countryCode) {
            return DropdownMenuItem<CountryCode>(
              value: countryCode,
              child: Container(
                width: 100,
                child: Text(
                  '${countryCode.name} +${countryCode.code}',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          }).toList(),
          hint: Text('${global.appLocaleValues['ctyr_code']}'),
          // hint:  Text(global.appLocaleValues['txt_hnt_country']),
          onChanged: (CountryCode newValue) {
            // setState(() {
            //   if (widgetId == 0) {
            //     account.mobileCountryCode = '${newValue.code}';
            //     //  _mobileCountryCode = newValue;
            //   } else {
            //     account.phoneCountryCode = '${newValue.code}';
            //     //  _phoneCountryCode = newValue;
            //   }
            // });
          },
          validator: (val) {
            if (val == null) {
              return global.appLocaleValues['txt_hnt_country'];
            }
            return null;
          },
        ),
      );
    } catch (e) {
      print('Exception - accountAddScreen.dart - _dropDownCountryCode(): ' + e.toString());
      return null;
    }
  }

  void initCountryCode() {
    try {
      _countryCodeList = [
        CountryCode('Afghanistan', '93'),
        CountryCode('Albania', '355'),
        CountryCode('Algeria', '213'),
        CountryCode('American Samoa', '1-684'),
        CountryCode('Andorra', '376'),
        CountryCode('Angola', '244'),
        CountryCode('Anguilla', '1-264'),
        CountryCode('Antarctica', '672'),
        CountryCode('Antigua and Barbuda', '1-268'),
        CountryCode('Argentina', '54'),
        CountryCode('Armenia', '374'),
        CountryCode('Aruba', '297'),
        CountryCode('Australia', '61'),
        CountryCode('Austria', '43'),
        CountryCode('Azerbaijan', '994'),
        CountryCode('Bahamas', '1-242'),
        CountryCode('Bahrain', '973'),
        CountryCode('Bangladesh', '880'),
        CountryCode('Barbados', '1-246'),
        CountryCode('Belarus', '375'),
        CountryCode('Belgium', '32'),
        CountryCode('Belize', '501'),
        CountryCode('Benin', '229'),
        CountryCode('Bermuda', '1-441'),
        CountryCode('Bhutan', '975'),
        CountryCode('Bolivia', '591'),
        CountryCode('Bosnia and Herzegovina', '387'),
        CountryCode('Botswana', '267'),
        CountryCode('Brazil', '55'),
        CountryCode('British Indian Ocean Territory', '246'),
        CountryCode('British Virgin Islands', '1-284'),
        CountryCode('Brunei', '673'),
        CountryCode('Bulgaria', '359'),
        CountryCode('Burkina Faso', '226'),
        CountryCode('Burundi', '257'),
        CountryCode('Cambodia', '855'),
        CountryCode('Cameroon', '237'),
        CountryCode('Canada', '1'),
        CountryCode('Cape Verde', '238'),
        CountryCode('Cayman Islands', '1-345'),
        CountryCode('Central African Republic', '236'),
        CountryCode('Chad', '235'),
        CountryCode('Chile', '56'),
        CountryCode('China', '86'),
        CountryCode('Christmas Island', '61'),
        CountryCode('Cocos Islands', '61'),
        CountryCode('Colombia', '57'),
        CountryCode('Comoros', '269'),
        CountryCode('Cook Islands', '682'),
        CountryCode('Costa Rica', '506'),
        CountryCode('Croatia', '385'),
        CountryCode('Cuba', '53'),
        CountryCode('Curacao', '599'),
        CountryCode('Cyprus', '357'),
        CountryCode('Czech Republic', '420'),
        CountryCode('Democratic Republic of the Congo', '243'),
        CountryCode('Denmark', '45'),
        CountryCode('Djibouti', '253'),
        CountryCode('Dominica', '1-767'),
        CountryCode('Dominican Republic', '1-809'),
        CountryCode('East Timor', '670'),
        CountryCode('Ecuador', '593'),
        CountryCode('Egypt', '20'),
        CountryCode('El Salvador', '503'),
        CountryCode('Equatorial Guinea', '240'),
        CountryCode('Eritrea', '291'),
        CountryCode('Estonia', '372'),
        CountryCode('Ethiopia', '251'),
        CountryCode('Falkland Islands', '500'),
        CountryCode('Faroe Islands', '298'),
        CountryCode('Fiji', '679'),
        CountryCode('Finland', '358'),
        CountryCode('France', '33'),
        CountryCode('French Polynesia', '689'),
        CountryCode('Gabon', '241'),
        CountryCode('Gambia', '220'),
        CountryCode('Georgia', '995'),
        CountryCode('Germany', '49'),
        CountryCode('Ghana', '233'),
        CountryCode('Gibraltar', '350'),
        CountryCode('Greece', '30'),
        CountryCode('Greenland', '299'),
        CountryCode('Grenada', '1-473'),
        CountryCode('Guam', '1-671'),
        CountryCode('Guatemala', '502'),
        CountryCode('Guernsey', '44-1481'),
        CountryCode('Guinea', '224'),
        CountryCode('Guinea-Bissau', '245'),
        CountryCode('Guyana', '592'),
        CountryCode('Haiti', '509'),
        CountryCode('Honduras', '504'),
        CountryCode('Hong Kong', '852'),
        CountryCode('Hungary', '36'),
        CountryCode('Iceland', '354'),
        CountryCode('India', '91'),
        CountryCode('Indonesia', '62'),
        CountryCode('Iran', '98'),
        CountryCode('Iraq', '964'),
        CountryCode('Ireland', '353'),
        CountryCode('Isle of Man', '44-1624'),
        CountryCode('Israel', '972'),
        CountryCode('Italy', '39'),
        CountryCode('Ivory Coast', '225'),
        CountryCode('Jamaica', '1-876'),
        CountryCode('Japan', '81'),
        CountryCode('Jersey', '44-1534'),
        CountryCode('Jordan', '962'),
        CountryCode('Kazakhstan', '7'),
        CountryCode('Kenya', '254'),
        CountryCode('Kiribati', '686'),
        CountryCode('Kosovo', '383'),
        CountryCode('Kuwait', '965'),
        CountryCode('Kyrgyzstan', '996'),
        CountryCode('Laos', '856'),
        CountryCode('Latvia', '371'),
        CountryCode('Lebanon', '961'),
        CountryCode('Lesotho', '266'),
        CountryCode('Liberia', '231	'),
        CountryCode('Libya', '218'),
        CountryCode('Liechtenstein', '423'),
        CountryCode('Lithuania', '370'),
        CountryCode('Luxembourg', '352'),
        CountryCode('Macau', '853'),
        CountryCode('Macedonia', '389'),
        CountryCode('Madagascar', '261'),
        CountryCode('Malawi', '265'),
        CountryCode('Malaysia', '60'),
        CountryCode('Maldives', '960'),
        CountryCode('Mali', '223'),
        CountryCode('Malta', '356'),
        CountryCode('Marshall Islands', '692'),
        CountryCode('Mauritania', '222'),
        CountryCode('Mauritius', '230'),
        CountryCode('Mayotte', '262'),
        CountryCode('Mexico', '52'),
        CountryCode('Micronesia', '691'),
        CountryCode('Moldova', '373'),
        CountryCode('Monaco', '377'),
        CountryCode('Mongolia', '976'),
        CountryCode('Montenegro', '382'),
        CountryCode('Montserrat', '1-664'),
        CountryCode('Morocco', '212'),
        CountryCode('Mozambique', '258'),
        CountryCode('Myanmar', '95'),
        CountryCode('Namibia', '264'),
        CountryCode('Nauru', '674'),
        CountryCode('Nepal', '977'),
        CountryCode('Netherlands', '31'),
        CountryCode('Netherlands Antilles', '599'),
        CountryCode('New Caledonia', '687'),
        CountryCode('New Zealand', '64'),
        CountryCode('Nicaragua', '505'),
        CountryCode('Niger', '227'),
        CountryCode('Nigeria', '234'),
        CountryCode('Niue', '683'),
        CountryCode('North Korea', '850'),
        CountryCode('Northern Mariana Islands', '1-670'),
        CountryCode('Norway', '47'),
        CountryCode('Oman', '968'),
        CountryCode('Pakistan', '92'),
        CountryCode('Palau', '680'),
        CountryCode('Palestine', '970'),
        CountryCode('Panama', '507'),
        CountryCode('Papua New Guinea', '675'),
        CountryCode('Paraguay', '595'),
        CountryCode('Peru', '51'),
        CountryCode('Philippines', '63'),
        CountryCode('Pitcairn', '64'),
        CountryCode('Poland', '48'),
        CountryCode('Portugal', '351'),
        CountryCode('Puerto Rico', '1-787'),
        CountryCode('Qatar', '974'),
        CountryCode('Republic of the Congo', '242'),
        CountryCode('Reunion', '262'),
        CountryCode('Romania', '40'),
        CountryCode('Russia', '7'),
        CountryCode('Rwanda', '250'),
        CountryCode('Saint Barthelemy', '590'),
        CountryCode('Saint Helena', '290'),
        CountryCode('Saint Kitts and Nevis', '1-869'),
        CountryCode('Saint Lucia', '1-758'),
        CountryCode('Saint Martin', '590'),
        CountryCode('Saint Pierre and Miquelon', '508'),
        CountryCode('Saint Vincent and the Grenadines', '	1-784'),
        CountryCode('Samoa', '685'),
        CountryCode('San Marino', '378'),
        CountryCode('Sao Tome and Principe', '239'),
        CountryCode('Saudi Arabia', '966'),
        CountryCode('Senegal', '221'),
        CountryCode('Serbia', '381'),
        CountryCode('Seychelles', '248'),
        CountryCode('Sierra Leone', '232'),
        CountryCode('Singapore', '65'),
        CountryCode('Sint Maarten', '1-721'),
        CountryCode('Slovakia', '421'),
        CountryCode('Slovenia', '386'),
        CountryCode('Solomon Islands', '677'),
        CountryCode('Somalia', '252'),
        CountryCode('South Africa', '27'),
        CountryCode('South Korea', '82'),
        CountryCode('South Sudan', '211'),
        CountryCode('Spain', '34'),
        CountryCode('Sri Lanka', '94'),
        CountryCode('Sudan', '249'),
        CountryCode('Suriname', '597'),
        CountryCode('Svalbard and Jan Mayen', '47'),
        CountryCode('Swaziland', '268'),
        CountryCode('Sweden', '46'),
        CountryCode('Switzerland', '41'),
        CountryCode('Syria', '963'),
        CountryCode('Taiwan', '886'),
        CountryCode('Tajikistan', '992'),
        CountryCode('Tanzania', '255'),
        CountryCode('Thailand', '66'),
        CountryCode('Togo', '228'),
        CountryCode('Tokelau', '690'),
        CountryCode('Tonga', '676'),
        CountryCode('Trinidad and Tobago', '1-868'),
        CountryCode('Tunisia', '216'),
        CountryCode('Turkey', '90'),
        CountryCode('Turkey', '993'),
        CountryCode('Turks and Caicos Islands', '1-649'),
        CountryCode('Tuvalu', '688'),
        CountryCode('U.S. Virgin Islands', '1-340'),
        CountryCode('Uganda', '256'),
        CountryCode('Ukraine', '380'),
        CountryCode('United Arab Emirates', '971'),
        CountryCode('United Kingdom', '44'),
        CountryCode('United States', '1'),
        CountryCode('Uruguay', '598'),
        CountryCode('Uzbekistan', '998'),
        CountryCode('Vanuatu', '678'),
        CountryCode('Vatican', '379'),
        CountryCode('Venezuela', '58'),
        CountryCode('Vietnam', '84'),
        CountryCode('Wallis and Futuna', '681'),
        CountryCode('Western Sahara', '212'),
        CountryCode('Yemen', '967'),
        CountryCode('Zambia', '260'),
        CountryCode('Zimbabwe', '263')
      ];

      // print("len: ${_countryCodeList.length}");
    } catch (e) {
      print('Exception - accountAddScreen.dart - initCountryCode(): ' + e.toString());
    }
  }
}

class CountryCode {
  String name;
  String code;

  CountryCode(this.name, this.code);
}
