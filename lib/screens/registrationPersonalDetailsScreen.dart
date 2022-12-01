// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/userModel.dart';
import 'package:accounting_app/screens/registrationBusinessDetailsScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:page_transition/page_transition.dart';

class RegistrationPersonalDetailsScreen extends BaseRoute {
  RegistrationPersonalDetailsScreen({@required a, @required o}) : super(a: a, o: o, r: 'RegistrationPersonalDetailsScreen');

  @override
  _RegistrationPersonalDetailsScreenState createState() => _RegistrationPersonalDetailsScreenState();
}

class _RegistrationPersonalDetailsScreenState extends BaseRouteState {
  User _user = User();
  var _cEmail = TextEditingController();
  var _cFirstName = TextEditingController();
  var _cLastName = TextEditingController();
  var _cMobile = TextEditingController();
  var _fEmail = FocusNode();
  var _fFirstName = FocusNode();
  var _fLastName = FocusNode();
  var _fMobile = FocusNode();
  var _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  _RegistrationPersonalDetailsScreenState() : super();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getInit();
  }

  Future _getInit() async {
    try {
      if (global.user == null) {
        if (global.isAndroidPlatform) {
          await initMobileNumberState();
        }
      } else {
        _user = global.user;
        _cFirstName.text = global.user.firstName;
        _cLastName.text = global.user.lastName;
        _cMobile.text = global.user.mobile.toString();
        _cEmail.text = global.user.email;
      }
    } catch (e) {
      print('Exception: registrationPersonalDetailScreen.dart - _getInit()' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          return null;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 7.5,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     CircleAvatar(
                    //       backgroundColor: Theme.of(context).primaryColorLight,
                    //       child: Text(
                    //         '1',
                    //         style: TextStyle(color: Colors.white, fontSize: 15),
                    //       ),
                    //       radius: 13,
                    //     ),
                    //     Container(
                    //         width: 10,
                    //         child: Divider(
                    //           thickness: 2,
                    //         )),
                    //     CircleAvatar(
                    //       backgroundColor: Colors.grey,
                    //       child: Text(
                    //         '2',
                    //         style: TextStyle(color: Colors.white, fontSize: 15),
                    //       ),
                    //       radius: 13,
                    //     ),
                    //     Container(
                    //         width: 10,
                    //         child: Divider(
                    //           thickness: 2,
                    //         )),
                    //     CircleAvatar(
                    //       backgroundColor: Colors.grey,
                    //       child: Text(
                    //         '3',
                    //         style: TextStyle(color: Colors.white, fontSize: 15),
                    //       ),
                    //       radius: 13,
                    //     ),
                    //     Container(
                    //         width: 10,
                    //         child: Divider(
                    //           thickness: 2,
                    //         )),
                    //     CircleAvatar(
                    //       backgroundColor: Colors.grey,
                    //       child: Text(
                    //         '4',
                    //         style: TextStyle(color: Colors.white, fontSize: 15),
                    //       ),
                    //       radius: 13,
                    //     ),
                    //     Container(
                    //         width: 10,
                    //         child: Divider(
                    //           thickness: 2,
                    //         )),
                    //     CircleAvatar(
                    //       backgroundColor: Colors.grey,
                    //       child: Text(
                    //         '5',
                    //         style: TextStyle(color: Colors.white, fontSize: 15),
                    //       ),
                    //       radius: 13,
                    //     ),
                    //     Container(
                    //         width: 10,
                    //         child: Divider(
                    //           thickness: 2,
                    //         )),
                    //     CircleAvatar(
                    //       backgroundColor: Colors.grey,
                    //       child: Text(
                    //         '6',
                    //         style: TextStyle(color: Colors.white, fontSize: 15),
                    //       ),
                    //       radius: 13,
                    //     ),
                    //   ],
                    // ),

                    // SizedBox(
                    //   height: 30,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   width: 60,
                        // ),
                        Expanded(
                          child: Center(
                            child: Text(
                              global.appLocaleValues['tle_personal_detail'],
                              style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        // ChangeLanguageButtonWidget(a: widget.analytics, o: widget.observer)
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(global.appLocaleValues['tle_personal_detail_desc'], style: Theme.of(context).primaryTextTheme.headline6),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Scrollbar(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: Text(global.appLocaleValues['txt_firstName'], style: Theme.of(context).primaryTextTheme.headline3),
                                      ),
                                      TextFormField(
                                        textCapitalization: TextCapitalization.words,
                                        focusNode: _fFirstName,
                                        controller: _cFirstName,
                                        // inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Za-z]'))],
                                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))],

                                        textInputAction: TextInputAction.next,
                                        validator: (v) {
                                          if (v.isEmpty) {
                                            return global.appLocaleValues['vel_firstName'];
                                          } else if (v.contains(RegExp('[0-9]'))) {
                                            return global.appLocaleValues['vel_character_only'];
                                          }
                                          return null;
                                        },
                                        onChanged: (v) {
                                          _user.firstName = v;
                                        },
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context).requestFocus(_fLastName);
                                        },
                                        decoration: InputDecoration(
                                          border: nativeTheme().inputDecorationTheme.border,
                                          suffixIcon: Icon(
                                            Icons.star,
                                            size: 9,
                                            color: Colors.red,
                                          ),
                                          hintText: global.appLocaleValues['txt_firstName'],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: Text(global.appLocaleValues['txt_lastName'], style: Theme.of(context).primaryTextTheme.headline3),
                                      ),
                                      TextFormField(
                                        controller: _cLastName,

                                        textCapitalization: TextCapitalization.words,
                                        focusNode: _fLastName,
                                        textInputAction: TextInputAction.next,
                                        // inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Za-z]'))],
                                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))],

                                        validator: (v) {
                                          if (v.isEmpty) {
                                            return global.appLocaleValues['hnt_lastName'];
                                          } else if (v.contains(RegExp('[0-9]'))) {
                                            return global.appLocaleValues['vel_character_only'];
                                          }
                                          return null;
                                        },
                                        onChanged: (v) {
                                          _user.lastName = v;
                                        },
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context).requestFocus(_fMobile);
                                        },
                                        decoration: InputDecoration(
                                          hintText: global.appLocaleValues['txt_lastName'],
                                          border: nativeTheme().inputDecorationTheme.border,
                                          suffixIcon: Icon(
                                            Icons.star,
                                            size: 9,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(global.appLocaleValues['txt_mobile_no'], style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                            ),
                            TextFormField(
                              focusNode: _fMobile,
                              textInputAction: TextInputAction.next,
                              controller: _cMobile,
                              maxLength: 10,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              validator: (v) {
                                if (v.isEmpty) {
                                  return global.appLocaleValues['vel_mobile_no'];
                                } else if (v.length != 10) {
                                  return global.appLocaleValues['lbl_err_vld_mobile_no'];
                                }
                                return null;
                              },
                              onChanged: (v) {
                                _user.mobile = int.parse(v);
                                setState(() {});
                              },
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fEmail);
                              },
                              onTap: () {},
                              decoration: InputDecoration(
                                hintText: 'ex.(9991239910)',
                                border: nativeTheme().inputDecorationTheme.border,
                                suffixIcon: Icon(
                                  Icons.star,
                                  size: 9,
                                  color: Colors.red,
                                ),
                                counterText: '',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(global.appLocaleValues['txt_email_address'], style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 70),
                              child: TextFormField(
                                focusNode: _fEmail,
                                textCapitalization: TextCapitalization.sentences,
                                controller: _cEmail,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                validator: (v) {
                                  if (v.isEmpty) {
                                    // return global.appLocaleValues['hnt_email_address'];
                                  } else if (EmailValidator.validate(v) != true) {
                                    return global.appLocaleValues['lbl_err_vld_email_id'];
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'ex.(joseph@gmail.com)',
                                  border: nativeTheme().inputDecorationTheme.border,
                                  // suffixIcon: Icon(
                                  //   Icons.star,
                                  //   size: 9,
                                  //   color: Colors.red,
                                  // ),
                                  counterText: '',
                                ),
                                onChanged: (v) {
                                  _user.email = v;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: TextButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  global.appLocaleValues['btn_save_and_next'],
                  style: Theme.of(context).primaryTextTheme.headline2,
                ),
              ],
            ),
            onPressed: () async {
              await _onSave();
            },
          ),
        ),
      ),
    );
  }

  Future _onSave() async {
    try {
      if (_formKey.currentState.validate()) {
        showLoader(global.appLocaleValues['txt_wait']);
        setState(() {});
        if (global.user == null || global.user.id == null) {
          _user.email = _cEmail.text;
          _user.firstName = _cFirstName.text;
          _user.lastName = _cLastName.text;
          _user.mobile = int.parse(_cMobile.text);
          _user.isLogin = true;
          _user.id = await dbHelper.userInsert(_user);
          if (_user.id != null) {
            global.user = _user;
            hideLoader();
            setState(() {});
            Navigator.of(context).push(PageTransition(
                type: PageTransitionType.rightToLeft,
                child: RegistrationBusinessDetailsScreen(
                  a: widget.analytics,
                  o: widget.observer,
                )));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong.')));
            hideLoader();
            setState(() {});
          }
        } else {
          int _a = await dbHelper.userUpdate(_user);
          if (_a == 1) {
            global.user = _user;
            Navigator.of(context).push(PageTransition(
                type: PageTransitionType.rightToLeft,
                child: RegistrationBusinessDetailsScreen(
                  a: widget.analytics,
                  o: widget.observer,
                )));
          }
        }
      } else {
        _autovalidate = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - registrationPersonalDetailsScreen.dart - _onSave(): ' + e.toString());
    }
  }

  Future<int> initMobileNumberState() async {
    try {
      List<SimCard> simCardList = await MobileNumber.getSimCards;
      if (simCardList.where((e) => e.number != null).length == simCardList.length) {
        if (simCardList.length > 1) {
          await _selectMobileNumber(simCardList);
          return simCardList.length;
        } else if (simCardList.length == 1) {
          _cMobile.text = simCardList[0].number.length > 10 ? simCardList[0].number.substring(simCardList[0].number.length - 10) : simCardList[0].number;
          _user.mobile = int.parse(_cMobile.text);
          return 1;
        }
      }
    } on PlatformException catch (e) {
      print("Exception - registrationStepScreen.dart - PlatformException - initMobileNumberState()" + e.toString());
    } catch (e) {
      print("Exception - registrationStepScreen.dart - initMobileNumberState():" + e.toString());
    }
    return 0;
  }

  Future _selectMobileNumber(List<SimCard> simCardList) async {
    try {
      AlertDialog dialog = AlertDialog(
        title: Text(
          '${global.appLocaleValues['tle_choose_phone_number']}',
        ),
        content: Container(
          //height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: simCardList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Card(
                  child: ListTile(
                    title: Text(
                      '${simCardList[index].countryPhonePrefix.isNotEmpty ? '+' + simCardList[index].countryPhonePrefix : ''} ${simCardList[index].number}',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () async {
                      _user.mobile = int.parse(simCardList[index].number);
                      _cMobile.text = simCardList[index].number;
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
      await showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
    } catch (e) {
      print('Exception - registrationStepScreen.dart - _selectMobileNumber(): ' + e.toString());
      return null;
    }
  }
}
