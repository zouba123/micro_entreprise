// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/registrationBusinessDetailsScreen.dart';
import 'package:accounting_app/screens/registrationSuccessScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:page_transition/page_transition.dart';

class RegistrationSetSecurityPinScreen extends BaseRoute {
  RegistrationSetSecurityPinScreen({@required a, @required o}) : super(a: a, o: o, r: 'RegistrationSetSecurityPinScreen');
  @override
  _RegistrationSetSecurityPinScreenState createState() => _RegistrationSetSecurityPinScreenState();
}

class _RegistrationSetSecurityPinScreenState extends BaseRouteState {
  var _formKey = GlobalKey<FormState>();
  var _fLoginPin = FocusNode();
  var _fConfirmLoginPin = FocusNode();
  var _focusNode = FocusNode();
  var _cLoginPin = TextEditingController();
  var _cConfirmLoginPin = TextEditingController();
  bool _pinVisible = true;
  bool _confirmPinVisible = true;
  bool _pinMatched = true;
  bool _isEnableAskPin = true;
  bool _isFringerPrintOn = false;
  bool _autovalidate = false;

  _RegistrationSetSecurityPinScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          // Navigator.of(context).push(PageTransition(
          //     type: PageTransitionType.leftToRight,
          //     child: RegistrationBackupAndRestoreScreen(
          //       a: widget.analytics,
          //       o: widget.observer,
          //     )));
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
                    //       backgroundColor: Theme.of(context).primaryColor,
                    //       child: Text(
                    //         '1',
                    //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    //       ),
                    //       radius: 13,
                    //     ),
                    //     Container(width: 10, child: Divider(thickness: 2, color: Theme.of(context).primaryColor)),
                    //     CircleAvatar(
                    //       backgroundColor: Theme.of(context).primaryColor,
                    //       child: Text(
                    //         '2',
                    //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    //       ),
                    //       radius: 13,
                    //     ),
                    //     Container(width: 10, child: Divider(thickness: 2, color: Theme.of(context).primaryColor)),
                    //     CircleAvatar(
                    //       backgroundColor: Theme.of(context).primaryColor,
                    //       child: Text(
                    //         '3',
                    //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    //       ),
                    //       radius: 13,
                    //     ),
                    //     Container(width: 10, child: Divider(thickness: 2, color: Theme.of(context).primaryColor)),
                    //     CircleAvatar(
                    //       backgroundColor: Theme.of(context).primaryColor,
                    //       child: Text(
                    //         '4',
                    //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    //       ),
                    //       radius: 13,
                    //     ),
                    //     Container(width: 10, child: Divider(thickness: 2, color: Theme.of(context).primaryColor)),
                    //     CircleAvatar(
                    //       backgroundColor: Theme.of(context).primaryColor,
                    //       child: Text(
                    //         '5',
                    //         style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    //       ),
                    //       radius: 13,
                    //     ),
                    //     Container(width: 10, child: Divider(thickness: 2, color: Theme.of(context).primaryColor)),
                    //     CircleAvatar(
                    //       backgroundColor: Theme.of(context).primaryColorLight,
                    //       child: Text(
                    //         '6',
                    //         style: TextStyle(color: Colors.white, fontSize: 15),
                    //       ),
                    //       radius: 13,
                    //     ),
                    //   ],
                    // ),

                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        global.appLocaleValues['tle_set_login_pin'],
                        style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      global.appLocaleValues['lbl_loginPinSet'],
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            global.appLocaleValues['lbl_login_pin'],
                            style: Theme.of(context).primaryTextTheme.headline3,
                          ),
                        )),
                    TextFormField(
                      focusNode: _fLoginPin,
                      controller: _cLoginPin,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      maxLength: 4,
                      textInputAction: TextInputAction.next,
                      obscureText: _pinVisible,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(_fConfirmLoginPin);
                      },
                      onChanged: (v) {
                        if (v.length == 4) {
                          if (v == _cConfirmLoginPin.text) {
                            _pinMatched = true;
                            setState(() {});
                          }
                          FocusScope.of(context).requestFocus(_fConfirmLoginPin);
                        }
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return global.appLocaleValues['vel_err_req_login_pin'];
                        } else if (v.length != 4) {
                          return global.appLocaleValues['vel_enter_4digit_login_pin'];
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: global.appLocaleValues['lbl_login_pin'],
                        suffixIcon: IconButton(
                          icon: (_pinVisible)
                              ? Icon(
                                  Icons.visibility_off,
                                )
                              : Icon(
                                  Icons.visibility,
                                ),
                          onPressed: () {
                            setState(() {
                              if (_pinVisible) {
                                _pinVisible = false;
                              } else {
                                _pinVisible = true;
                              }
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                        // labelText: global.appLocaleValues['lbl_login_pin'],
                        counterText: '',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(global.appLocaleValues['lbl_re_enter_login_pin'], style: Theme.of(context).primaryTextTheme.headline3),
                        )),
                    TextFormField(
                      focusNode: _fConfirmLoginPin,
                      controller: _cConfirmLoginPin,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      maxLength: 4,
                      textInputAction: TextInputAction.done,
                      obscureText: _confirmPinVisible,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) {
                        setState(() {
                          _pinMatched = true;
                        });
                        if (v.length == 4) {
                          if (v != _cLoginPin.text) {
                            setState(() {
                              _pinMatched = false;
                            });
                          } else {
                            FocusScope.of(context).requestFocus(_focusNode);
                          }
                        }
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return global.appLocaleValues['lbl_re_enter_login_pin'];
                        } else if (_pinMatched != true) {
                          return global.appLocaleValues['lbl_err_loginpin_not_match'];
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: global.appLocaleValues['lbl_re_enter_login_pin'],
                        // labelText: global.appLocaleValues['lbl_re_enter_login_pin'],
                        suffixIcon: IconButton(
                          icon: (_confirmPinVisible)
                              ? Icon(
                                  Icons.visibility_off,
                                )
                              : Icon(
                                  Icons.visibility,
                                ),
                          onPressed: () {
                            setState(() {
                              if (_confirmPinVisible) {
                                _confirmPinVisible = false;
                              } else {
                                _confirmPinVisible = true;
                              }
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                        errorText: (_pinMatched) ? null : global.appLocaleValues['lbl_err_loginpin_not_match'],
                        counterText: '',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Card(
                        shape: nativeTheme().cardTheme.shape,
                        child: ListTile(
                          contentPadding: EdgeInsets.only(left: 8),
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('${global.appLocaleValues['always_ask_auth']}', style: Theme.of(context).primaryTextTheme.headline3),
                              IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.info,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  //  showDesc(global.systemFlagNameList.askPinAlways, global.appLocaleValues['lbl_always_ask_pin']);
                                  showInfoMessage(
                                      global.appLocaleValues['lbl_always_ask_pin'],
                                      global.systemFlagNameList.askPinAlways,
                                      Icon(
                                        Icons.info,
                                        color: Theme.of(context).primaryColor,
                                      ));
                                },
                              )
                            ],
                          ),
                          trailing: Switch(
                            value: _isEnableAskPin,
                            onChanged: (value) {
                              setState(() {
                                _isEnableAskPin = value;
                              });
                            },
                          ),
                        )),
                    (global.availableBiometrics)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Card(
                                shape: nativeTheme().cardTheme.shape,
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        '${global.appLocaleValues['enab_finfd']}',
                                        style: Theme.of(context).primaryTextTheme.headline3,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.info,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          //  showDesc(global.systemFlagNameList.enableFingerPrint, global.appLocaleValues['lbl_enable_fingrprint']);
                                          showInfoMessage(
                                              global.appLocaleValues['lbl_enable_fingrprint'],
                                              global.systemFlagNameList.enableFingerPrint,
                                              Icon(
                                                Icons.info,
                                                color: Theme.of(context).primaryColor,
                                              ));
                                        },
                                      )
                                    ],
                                  ),
                                  trailing: Switch(
                                    value: _isFringerPrintOn,
                                    onChanged: (value) async {
                                      bool _verified = await br.authenticate();
                                      if (_verified) {
                                        _isFringerPrintOn = value;
                                      }

                                      setState(() {});
                                    },
                                  ),
                                )),
                          )
                        : SizedBox(),
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
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      child: Text(
                        global.appLocaleValues['btn_back'],
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: RegistrationBusinessDetailsScreen(
                              a: widget.analytics,
                              o: widget.observer,
                            )));
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextButton(
                      child: Text(
                        global.appLocaleValues['btn_finish'],
                        style: Theme.of(context).primaryTextTheme.headline2,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          showLoader(global.appLocaleValues['txt_wait']);
                          setState(() {});
                          global.user.loginPin = int.parse(_cConfirmLoginPin.text.trim());
                          await _updateAskPin(_isEnableAskPin.toString());
                          await _updateEnableFingerPrint(_isFringerPrintOn.toString());
                          await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableFingerPrint, _isFringerPrintOn.toString());
                          if (_isFringerPrintOn) {
                            _setSharedPreferences(true);
                          } else {
                            _setSharedPreferences(false);
                          }
                          await dbHelper.userUpdate(global.user);
                          hideLoader();
                          setState(() {});
                          Navigator.of(context).push(PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: RegistrationSuccessScreen(
                                a: widget.analytics,
                                o: widget.observer,
                              )));
                        } else {
                          _autovalidate = true;
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              // Padding(
              //   padding: EdgeInsets.only(bottom: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       Text(
              //         global.appLocaleValues['lbl_already_user'],
              //         style: Theme.of(context).primaryTextTheme.headline6,
              //       ),
              //       InkWell(
              //           child: Text(
              //             global.appLocaleValues['btn_login'],
              //             style: Theme.of(context).primaryTextTheme.headline1,
              //           ),
              //           onTap: () async {
              //             // await br.discardRegistrationProcess(context, widget.observer, widget.analytics);
              //           })
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future _updateAskPin(String value) async {
    try {
      await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.askPinAlways, value);
    } catch (e) {
      print('Exception - registrationSetLoginScreenScreen.dart - _updateAskPin(): ' + e.toString());
    }
  }

  Future _updateEnableFingerPrint(String value) async {
    try {
      int result = await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableFingerPrint, value);
      if (result == 1) {
        br.updateSystemFlagValue(global.systemFlagNameList.enableFingerPrint, value);
      }
    } catch (e) {
      print('Exception - registrationSetLoginScreenScreen.dart - _updateEnableFingerPrint(): ' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    if (global.user.loginPin != null) {
      _cLoginPin.text = global.user.loginPin.toString();
      _cConfirmLoginPin.text = global.user.loginPin.toString();
    }
  }

  Future _setSharedPreferences(bool value) async {
    global.prefs.setBool('fingerprintSetup', value);
  }
}
