// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/lockScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeLoginPinScreen extends BaseRoute {
  final bool isForgotPinAction;
  ChangeLoginPinScreen({@required a, @required o, this.isForgotPinAction}) : super(a: a, o: o, r: 'ChangeLoginPinScreen');
  @override
  _ChangeLoginPinScreenState createState() => _ChangeLoginPinScreenState(this.isForgotPinAction);
}

class _ChangeLoginPinScreenState extends BaseRouteState {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _cPin = TextEditingController();
  var _cCurrentPin = TextEditingController();
  var _cConfirmPin = TextEditingController();
  var _fPinFocus = FocusNode();
  var _focusNode = FocusNode();
  var _fCurrentPinFocus = FocusNode();
  var _fConfirmPinFocus = FocusNode();
  bool _pinVisible = true;
  bool _confirmPinVisible = true;
  bool _pinMatched = true;
  bool _currentPinValid = true;
  var _formKey = GlobalKey<FormState>();
  final bool isForgotPinAction;
  bool _autovalidate = false;
  _ChangeLoginPinScreenState(this.isForgotPinAction) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: (isForgotPinAction == null)
            ? AppBar(
                title: Text(
                  global.appLocaleValues['tel_change_pin'],
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
              )
            : null,
        drawer: (isForgotPinAction == null)
            ? SizedBox(
                width: MediaQuery.of(context).size.width - 90,
                child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
              )
            : null,
        body: (isForgotPinAction == null)
            ? WillPopScope(
                onWillPop: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DashboardScreen(
                            a: widget.analytics,
                            o: widget.observer,
                          )));
                  return null;
                },
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(global.appLocaleValues['lbl_current_pin'], style: Theme.of(context).primaryTextTheme.headline3),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: _cCurrentPin,
                              focusNode: _fCurrentPinFocus,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              maxLength: 4,
                              textInputAction: TextInputAction.next,
                              obscureText: true,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (v) {
                                setState(() {
                                  _currentPinValid = true;
                                });
                                if (v.length == 4) {
                                  if (v != global.user.loginPin.toString()) {
                                    _currentPinValid = false;
                                  } else {
                                    FocusScope.of(context).requestFocus(_fPinFocus);
                                  }
                                }
                              },
                              validator: (v) {
                                if (v.isEmpty) {
                                  return global.appLocaleValues['vel_current_pin'];
                                } else if (v.length != 4) {
                                  return global.appLocaleValues['vel_enter_4digit_login_pin'];
                                } else if (_currentPinValid != true) {
                                  return global.appLocaleValues['vel_err_invalid_pin'];
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: global.appLocaleValues['lbl_current_pin'],
                                // labelText: global.appLocaleValues['lbl_current_pin'],
                                errorText: (_currentPinValid) ? null : global.appLocaleValues['vel_err_invalid_pin'],
                                border: nativeTheme().inputDecorationTheme.border,
                                counterText: '',
                                // icon: Icon(
                                //   Icons.lock,
                                //   color: Colors.blue,
                                // )
                              ),
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fPinFocus);
                              },
                            ),
                          ),

                          //  SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(global.appLocaleValues['lbl_set_new_pin'], style: Theme.of(context).primaryTextTheme.headline3),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: _cPin,
                              focusNode: _fPinFocus,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              maxLength: 4,
                              textInputAction: TextInputAction.next,
                              obscureText: _pinVisible,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fConfirmPinFocus);
                              },
                              validator: (v) {
                                if (v.isEmpty) {
                                  return global.appLocaleValues['vel_set_new_pin'];
                                } else if (v.length != 4) {
                                  return global.appLocaleValues['vel_enter_4digit_login_pin'];
                                }
                                return null;
                              },
                              onChanged: (v) {
                                if (v.length == 4) {
                                  if (v == _cConfirmPin.text) {
                                    _pinMatched = true;
                                    setState(() {});
                                  }
                                  FocusScope.of(context).requestFocus(_fConfirmPinFocus);
                                }
                              },
                              decoration: InputDecoration(
                                border: nativeTheme().inputDecorationTheme.border,
                                suffixIcon: IconButton(
                                  icon: (_pinVisible)
                                      ? Icon(
                                          Icons.visibility_off,
                                          //   color: (_fPinFocus.hasFocus) ? Theme.of(context).primaryColorLight : Colors.grey,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          //   color: (_fPinFocus.hasFocus) ? Theme.of(context).primaryColorLight : Colors.grey,
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
                                hintText: global.appLocaleValues['lbl_set_new_pin'],
                                // labelText: global.appLocaleValues['lbl_set_new_pin'],
                                counterText: '',
                                // icon: Icon(
                                //   Icons.lock,
                                //   color: Colors.blue,
                                // )
                              ),
                            ),
                          ),
                          //  SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(global.appLocaleValues['lbl_confirm_pin'], style: Theme.of(context).primaryTextTheme.headline3),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 60),
                            child: TextFormField(
                              controller: _cConfirmPin,
                              focusNode: _fConfirmPinFocus,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              maxLength: 4,
                              obscureText: _confirmPinVisible,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (v) {
                                setState(() {
                                  _pinMatched = true;
                                });
                                if (v.length == 4) {
                                  if (v != _cPin.text) {
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
                                  return global.appLocaleValues['lbl_err_req_pin'];
                                } else if (_pinMatched != true) {
                                  return global.appLocaleValues['lbl_err_vld_pin'];
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: nativeTheme().inputDecorationTheme.border,
                                suffixIcon: IconButton(
                                  icon: (_confirmPinVisible)
                                      ? Icon(
                                          Icons.visibility_off,
                                          //    color: (_fConfirmPinFocus.hasFocus) ? Theme.of(context).primaryColorLight : Colors.grey,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          //     color: (_fConfirmPinFocus.hasFocus) ? Theme.of(context).primaryColorLight : Colors.grey,
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
                                hintText: global.appLocaleValues['lbl_confirm_pin'],
                                // labelText: global.appLocaleValues['lbl_confirm_pin'],
                                errorText: (_pinMatched) ? null : global.appLocaleValues['lbl_err_vld_pin'],
                                counterText: '',
                                // icon: Icon(
                                //   Icons.lock,
                                //   color: Colors.blue,
                                // )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : WillPopScope(
                onWillPop: () {
                  return null;
                },
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),

                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                global.appLocaleValues['tle_reset_pin'],
                                style: TextStyle(fontSize: 40, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              global.appLocaleValues['lbl_reset_pin_desc'],
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text('${global.appLocaleValues['ent_pin']}', style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                            ),
                            TextFormField(
                              controller: _cPin,
                              focusNode: _fPinFocus,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              maxLength: 4,
                              textInputAction: TextInputAction.next,
                              obscureText: _pinVisible,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_fConfirmPinFocus);
                              },
                              validator: (v) {
                                if (v.isEmpty) {
                                  return global.appLocaleValues['vel_set_new_pin'];
                                } else if (v.length != 4) {
                                  return global.appLocaleValues['vel_enter_4digit_login_pin'];
                                }
                                return null;
                              },
                              onChanged: (v) {
                                if (v.length == 4) {
                                  if (v == _cConfirmPin.text) {
                                    _pinMatched = true;
                                    setState(() {});
                                  }
                                  FocusScope.of(context).requestFocus(_fConfirmPinFocus);
                                }
                              },
                              decoration: InputDecoration(
                                border: nativeTheme().inputDecorationTheme.border,
                                suffixIcon: IconButton(
                                  icon: (_pinVisible)
                                      ? Icon(
                                          Icons.visibility_off,
                                          //   color: (_fPinFocus.hasFocus) ? Theme.of(context).primaryColor : Colors.grey,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          //      color: (_fPinFocus.hasFocus) ? Theme.of(context).primaryColor : Colors.grey,
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
                                hintText: global.appLocaleValues['lbl_set_new_pin'],
                                // labelText: global.appLocaleValues['lbl_set_new_pin'],
                                counterText: '',
                              ),
                            ),
                            //  SizedBox(height: 10,),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text('${global.appLocaleValues['lbl_err_req_pin']}', style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5, bottom: 60),
                              child: TextFormField(
                                controller: _cConfirmPin,
                                focusNode: _fConfirmPinFocus,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                maxLength: 4,
                                obscureText: _confirmPinVisible,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChanged: (v) {
                                  setState(() {
                                    _pinMatched = true;
                                  });
                                  if (v.length == 4) {
                                    if (v != _cPin.text.trim()) {
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
                                    return global.appLocaleValues['lbl_err_req_pin'];
                                  } else if (_pinMatched != true) {
                                    return global.appLocaleValues['lbl_err_vld_pin'];
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: nativeTheme().inputDecorationTheme.border,
                                  suffixIcon: IconButton(
                                    icon: (_confirmPinVisible)
                                        ? Icon(
                                            Icons.visibility_off,
                                            //   color: (_fConfirmPinFocus.hasFocus) ? Theme.of(context).primaryColor : Colors.grey,
                                          )
                                        : Icon(
                                            Icons.visibility,
                                            //     color: (_fConfirmPinFocus.hasFocus) ? Theme.of(context).primaryColor : Colors.grey,
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
                                  hintText: global.appLocaleValues['lbl_confirm_pin'],
                                  // labelText: global.appLocaleValues['lbl_confirm_pin'],
                                  errorText: (_pinMatched) ? null : global.appLocaleValues['lbl_err_vld_pin'],
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
        bottomSheet: (isForgotPinAction == null)
            ? Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.cancel,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              Text(
                                ' ${global.appLocaleValues['btn_cancel']}',
                                style: Theme.of(context).primaryTextTheme.headline3,
                              )
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => DashboardScreen(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.save,
                                color: Colors.white,
                              ),
                              Text(
                                ' ${global.appLocaleValues['btn_save_small']}',
                                style: Theme.of(context).primaryTextTheme.headline2,
                              ),
                            ],
                          ),
                          onPressed: () async {
                            await _changePin();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        global.appLocaleValues['btn_change'],
                      ),
                    ],
                  ),
                  onPressed: () async {
                    await _changePin();
                  },
                ),
              ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _changePin() async {
    try {
      if (isForgotPinAction == null) {
        if (_formKey.currentState.validate()) {
          if (_cCurrentPin.text == global.user.loginPin.toString()) {
            global.user.loginPin = int.parse(_cConfirmPin.text.trim());
            await dbHelper.userUpdate(global.user);

            // Navigator.of(context).pop();
            // showToast(global.appLocaleValues['lbl_change_pin_success']);

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LockScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          }
        } else {
          _autovalidate = true;
          setState(() {});
        }
      } else {
        if (_pinMatched) {
          global.user.loginPin = int.parse(_cConfirmPin.text.trim());
          await dbHelper.userUpdate(global.user);

          // Navigator.of(context).pop();

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => LockScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )));
        }
      }
    } catch (e) {
      print('Exception - changeLoginPinscreen.dart - _changePin(): ' + e.toString());
    }
  }
}
