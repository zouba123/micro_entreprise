// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/saleQuoteDetailModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/screens/AccountDetailScreen.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/forgotPinScreen.dart';
import 'package:accounting_app/screens/salesQuoteDetailScreen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockScreen extends BaseRoute {
  final int returnScreenId;
  final String payload;

  LockScreen({a, o, this.returnScreenId, this.payload}) : super(a: a, o: o, r: 'LockScreen');
  @override
  LockScreenState createState() => LockScreenState(this.returnScreenId, this.payload);
}

class LockScreenState extends BaseRouteState {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  final int returnScreenId;
  var auth = LocalAuthentication();
  String payload;
  bool _isPinVisible = false;
  List<String> _securityPin = [];
  TextStyle keyboardTextStyle = TextStyle(fontSize: 22);
  LockScreenState(this.returnScreenId, this.payload) : super();
  //
  int temp;
  _checkSecurityPin() async {
    try {
      if (_securityPin.length == 4) {
        String securePin = '';
        _securityPin.forEach((e) {
          securePin += e;
        });
        if (securePin == global.user.loginPin.toString()) {
          global.isLockScreen = false;
          global.isUnlocked = true;
          if (global.payload != null) {
            Map obj = json.decode(global.payload);
            global.payload = null;
            if (obj['module'] == 'Account') {
              Account account = (await dbHelper.accountGetList(accountId: int.parse(obj['id'])))[0];
              bool _isAccount = account.accountType.contains('Customer');
              if (!_isAccount) {
                _isAccount = account.accountType.contains('Supplier');
              }
              if (_isAccount) {
                // if cutstomer or supplier
                List<Payment> _paymentList = await dbHelper.paymentGetList(accountId: account.id);
                double returnSaleInvoiceAmount = (_paymentList.length > 0)
                    ? (account.accountType.contains('Customer'))
                        ? await dbHelper.paymentSaleInvoiceReturnGetSumOfAmount(paymentIdList: _paymentList.map((f) => f.id).toList())
                        : await dbHelper.paymentPurchaseInvoiceReturnGetSumOfAmount(paymentIdList: _paymentList.map((f) => f.id).toList())
                    : 0;
                account.totalPaid -= returnSaleInvoiceAmount;
                account.totalDue = account.totalSpent - account.totalPaid;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AccountDetailScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          account: account,
                          screenId: 1,
                        )));
              }
              // else {
              //   // if employee or worker
              //   List<EmployeeSalaryPayment> _employeSalaryPayment = await dbHelper.employeeSalaryPaymentGetList(accountId: [account.id], isAdvance: "true");
              //   _employeSalaryPayment.forEach((element) {
              //     account.totalAdvanced = _employeSalaryPayment.map((f) => f.salaryAmount).reduce((sum, amt) => sum + amt);
              //   });
              //   List<EmployeeSalary> _employeeSalary = await dbHelper.employeeSalaryAmountGetList(accountId: [account.id], status: 'Due', withoutPaid: 'Paid');
              //   _employeeSalary.forEach((element) {
              //     account.totalDue = _employeeSalary.map((f) => f.salaryAmount).reduce((sum, amt) => sum + amt);
              //   });
              //   Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => EmployeeDetailScreen(
              //             a: widget.analytics,
              //             o: widget.observer,
              //             account: account,
              //             screenId: 1,
              //           )));
              // }
            } else if (obj['module'] == 'SaleOrder') {
              SaleQuote _saleQuote = (await dbHelper.saleQuoteGetList(orderIdList: [int.parse(obj['id'])]))[0];
              if (_saleQuote != null) {
                List<SaleQuoteDetail> _saleQuoteDetailList = await dbHelper.saleQuoteDetailGetList(orderIdList: [_saleQuote.id]);
                _saleQuote.totalProducts = _saleQuoteDetailList.length;

                // _saleQuote.isEditable = await dbHelper.saleQuoteisUsed(_saleQuote.id);
                // _saleQuote.isEditable = !_saleQuote.isEditable;
              }
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SalesQuoteDetailScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        quote: _saleQuote,
                      )));
            }
          } else if (returnScreenId == null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>  DashboardScreen(
                      o: widget.observer,
                      a: widget.analytics,
                    )));
          } else {
            Navigator.of(context).pop();
          }
        } else {
          _securityPin.clear();
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${global.appLocaleValues['vel_err_invalid_pin']}', textAlign: TextAlign.center),
          ));
        }
      }
    } catch (e) {
      print("Exception - lockScreen.dart - _checkSecurityPin() : " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await exitAppDialog(1);
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  //height: 180,
                ),
                SizedBox(
                  height: 50,
                ),
                Text('${global.appLocaleValues['lbl_lock_desc']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black54, letterSpacing: 0.5)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.grey[50],
                        child: _securityPin.length > 0 && _securityPin[0].isNotEmpty
                            ? _isPinVisible
                                ? Center(
                                    child: Text(
                                      "${_securityPin[0]}",
                                      textAlign: TextAlign.center,
                                      style: keyboardTextStyle,
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(borderRadius:  BorderRadius.circular(10), color: Colors.black87),
                                    ),
                                  )
                            : Center(
                                child: SizedBox(),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.grey[50],
                        child: _securityPin.length > 1 && _securityPin[1].isNotEmpty
                            ? _isPinVisible
                                ? Center(
                                    child: Text(
                                      "${_securityPin[1]}",
                                      textAlign: TextAlign.center,
                                      style: keyboardTextStyle,
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(borderRadius:  BorderRadius.circular(10), color: Colors.black87),
                                    ),
                                  )
                            : Center(
                                child: SizedBox(),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.grey[50],
                        child: _securityPin.length > 2 && _securityPin[2].isNotEmpty
                            ? _isPinVisible
                                ? Center(
                                    child: Text(
                                      "${_securityPin[2]}",
                                      textAlign: TextAlign.center,
                                      style: keyboardTextStyle,
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(borderRadius:  BorderRadius.circular(10), color: Colors.black87),
                                    ),
                                  )
                            : Center(
                                child: SizedBox(),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.grey[50],
                        child: _securityPin.length > 3 && _securityPin[3].isNotEmpty
                            ? _isPinVisible
                                ? Center(
                                    child: Text(
                                      "${_securityPin[3]}",
                                      textAlign: TextAlign.center,
                                      style: keyboardTextStyle,
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(borderRadius:  BorderRadius.circular(10), color: Colors.black87),
                                    ),
                                  )
                            : Center(
                                child: SizedBox(),
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${global.appLocaleValues['btn_forgot_pin']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onTap: () {
                    global.isLockScreen = false;
                    global.isUnlocked = true;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgotPinScreen(
                              a: widget.analytics,
                              o: widget.observer,
                            )));
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height - (627)),
                _keyBoard(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (br.getSystemFlagValue(global.systemFlagNameList.enableFingerPrint) == 'true' && global.availableBiometrics) {
      _getData();
    }
    global.isLockScreen = true;
    _getTempValue();
  }

  Future _getTempValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    temp = pref.getInt('temp');
    print('tempvalue: $temp');
  }

  Widget _keyBoard() {
    try {
      // Color textColor = Theme.of(context).primaryColor;
      // Color buttonColor = Colors.white;
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  _securityPin.add('1');

                  setState(() {});
                  Timer(Duration(milliseconds: 40), () {
                    _checkSecurityPin();
                    setState(() {});
                  });
                },
                child: Text(
                  '1',
                  style: keyboardTextStyle,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  _securityPin.add('2');
                  setState(() {});

                  Timer(Duration(milliseconds: 40), () {
                    _checkSecurityPin();
                    setState(() {});
                  });
                },
                child: Text(
                  '2',
                  style: keyboardTextStyle,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  _securityPin.add('3');
                  setState(() {});
                  Timer(Duration(milliseconds: 40), () {
                    _checkSecurityPin();
                    setState(() {});
                  });
                },
                child: Text(
                  '3',
                  style: keyboardTextStyle,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  _securityPin.add('4');
                  setState(() {});
                  _checkSecurityPin();
                },
                child: Text(
                  '4',
                  style: keyboardTextStyle,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  _securityPin.add('5');
                  setState(() {});
                  Timer(Duration(milliseconds: 40), () {
                    _checkSecurityPin();
                    setState(() {});
                  });
                },
                child: Text(
                  '5',
                  style: keyboardTextStyle,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  _securityPin.add('6');
                  setState(() {});
                  Timer(Duration(milliseconds: 40), () {
                    _checkSecurityPin();
                    setState(() {});
                  });
                },
                child: Text(
                  '6',
                  style: keyboardTextStyle,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  _securityPin.add('7');
                  setState(() {});
                  Timer(Duration(milliseconds: 40), () {
                    _checkSecurityPin();
                    setState(() {});
                  });
                },
                child: Text(
                  '7',
                  style: keyboardTextStyle,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  _securityPin.add('8');
                  setState(() {});
                  Timer(Duration(milliseconds: 40), () {
                    _checkSecurityPin();
                    setState(() {});
                  });
                },
                child: Text(
                  '8',
                  style: keyboardTextStyle,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  _securityPin.add('9');

                  setState(() {});
                  Timer(Duration(milliseconds: 40), () {
                    _checkSecurityPin();
                    setState(() {});
                  });
                },
                child: Text(
                  '9',
                  style: keyboardTextStyle,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  if (_securityPin.length > 0) {
                    _securityPin.removeLast();
                  }
                  setState(() {});
                },
                child: Icon(Icons.backspace),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  _securityPin.add('0');
                  setState(() {});
                  Timer(Duration(milliseconds: 40), () {
                    _checkSecurityPin();
                    setState(() {});
                  });
                },
                child: Text(
                  '0',
                  style: keyboardTextStyle,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  _isPinVisible = !_isPinVisible;
                  setState(() {});
                },
                child: (_isPinVisible)
                    ? Icon(
                        Icons.visibility_off,
                      )
                    : Icon(
                        Icons.visibility,
                      ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );
    } catch (e) {
      print("Exception -  lockScreen.dart - _keyBoard() -  Widget " + e.toString());
    }
    return SizedBox();
  }

  Future<void> _authenticate() async {
    try {
      bool _isAuthenticated = await auth.authenticateWithBiometrics(localizedReason: 'Scan your fingerprint to authenticate', useErrorDialogs: true, stickyAuth: true);
      setState(() {
        if (_isAuthenticated) {
          (returnScreenId == null)
              ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>  DashboardScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      )))
              : Navigator.of(context).pop();
        } else {
          print('not authenticated');
        }
      });
    } on PlatformException catch (e) {
      print('Exception - lockScreen.dart - _authenticate(): ' + e.toString());
    }
    if (!mounted) return;
  }

  Future _getData() async {
    await _authenticate();
  }
}
