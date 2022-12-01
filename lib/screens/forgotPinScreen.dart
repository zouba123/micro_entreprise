// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable, unused_field
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/changeLoginPinScreen.dart';

class ForgotPinScreen extends BaseRoute {
  ForgotPinScreen({@required a, @required o}) : super(a: a, o: o, r: 'ForgotPinScreen');

  @override
  _ForgotPinScreenState createState() => _ForgotPinScreenState();
}

class _ForgotPinScreenState extends BaseRouteState {
  String _verificationId;
  int _seconds = 60;
  bool _countDownStarted = false;
  Timer _countDown;
  bool showResendOtp = false;
  Timer timer;
  bool showOtpTextBox = false;
  bool _isPhoneValidated = false;
  FocusNode _focusNode = FocusNode();

  var _cOtp = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  _ForgotPinScreenState() : super();

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
      await Firebase.initializeApp();
      await _getOTP();
    } catch (e) {
      print('Exception: registrationPersonalDetailScreen.dart - _getInit()' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop();
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
                              '${global.appLocaleValues['ent_otp']}',
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
                    Text('${global.appLocaleValues['otp_desc']}'.replaceAll("[MOBNO]", "${global.country.isoCode} ${global.user.mobile}"), style: Theme.of(context).primaryTextTheme.headline6),
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
                                        child: Text('${global.appLocaleValues['ent_otp_']}', style: Theme.of(context).primaryTextTheme.headline3),
                                      ),
                                      TextFormField(
                                        textInputAction: TextInputAction.done,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                        maxLength: 6,
                                        style: TextStyle(letterSpacing: 30, fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          counterText: '',
                                          hintStyle: TextStyle(wordSpacing: 8, letterSpacing: -0.1, fontWeight: FontWeight.bold),
                                          hintText: "__  __  __  __  __  __  ",
                                        ),
                                        onChanged: (val) async {
                                          if (val.length == 6) {
                                            FocusScope.of(context).requestFocus(_focusNode);
                                          }
                                        },
                                        controller: _cOtp,
                                        onFieldSubmitted: (f) {
                                          FocusScope.of(context).requestFocus(_focusNode);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            _countDownStarted && !_isPhoneValidated
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${global.appLocaleValues['hvnt_rec_opt']}"),
                                            _seconds != 0
                                                ? Text('${global.appLocaleValues['wait']} 00:${_seconds.toString().padLeft(2, '0')}')
                                                : InkWell(
                                                    child: Text(
                                                      '${global.appLocaleValues['resend_otp']}',
                                                      style: TextStyle(color: Colors.blue),
                                                    ),
                                                    onTap: () async {
                                                      _cOtp.clear();
                                                      //showOnlyLoaderDialog();
                                                      await _getOTP();
                                                      _countDownStarted = false;
                                                      setState(() {});
                                                    },
                                                  ),
                                          ],
                                        )),
                                  )
                                : SizedBox(),
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
                  '${global.appLocaleValues['vrfy']}',
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

  Future _getOTP() async {
    try {
       FirebaseAuth _auth = FirebaseAuth.instance;
       await _auth.verifyPhoneNumber(
         phoneNumber: '${global.country.isoCode}' + '${global.user.mobile}', //
         timeout: Duration(seconds: 60),
         verificationCompleted: (AuthCredential authCredential) async {
           // var a = authCredential.providerId;
           // print('token: $a');
           // setState(() {
           //   _isPhoneValidated = true;
           // });
         },
         verificationFailed: (authException) {
           print(authException.message);
           print('failed');
         },
         codeSent: (String verificationId, [int forceResendingToken]) async {
           _verificationId = verificationId;
           _seconds = 60;
           _countDownStarted = true;
           showOtpTextBox = true;
           startTimer();
           setState(() {});
         },
         codeAutoRetrievalTimeout: (String verificationId) {
           verificationId = verificationId;
           print(verificationId);
         },
       );
       _countDownStarted = false;
       setState(() {});
    } catch (e) {
      print("Exception - forgotPinScreen.dart - _getOTP():" + e.toString());
      return null;
    }
  }

  Future _onSave() async {
    try {
      if (_cOtp.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['otp_vld']}')));
      } else if (_cOtp.text.trim().length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['vld_otp_vld']}')));
      } else {
        await _checkOTP();
      }
    } catch (e) {
      print("Exception - forgotPinScreen.dart - _onSave():" + e.toString());
      return null;
    }
  }

  Future startTimer() async {
    const oneSec = const Duration(seconds: 1);
    _countDown = Timer.periodic(
      oneSec,
      (timer) {
        if (_seconds == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _seconds--;
          });
        }
      },
    );
  }

  Future _checkOTP() async {
    try {
       FirebaseAuth auth = FirebaseAuth.instance;
       var _credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: _cOtp.text.trim());
       await auth.signInWithCredential(_credential).then((result) async {
         print('success');
         setState(() {
           _isPhoneValidated = true;
         });
         Navigator.of(context).push(MaterialPageRoute(
             builder: (context) => ChangeLoginPinScreen(
                   isForgotPinAction: true,
                   a: widget.analytics,
                   o: widget.observer,
                 )));
       }).catchError((e) {
         print('failed: ${e.toString()}');
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter valid otp.')));
       });
    } catch (e) {
      print("Exception - forgotPinScreen.dart - _checkOTP():" + e.toString());
      return null;
    }
  }
}
