// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/baseroute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/lockScreen.dart';
import 'package:accounting_app/screens/registrationAskPermissionsScreen.dart';
import 'package:accounting_app/screens/registrationBusinessDetailsScreen.dart';
import 'package:accounting_app/screens/registrationIntroSlidesScreen.dart';
import 'package:accounting_app/screens/registrationPersonalDetailsScreen.dart';
import 'package:accounting_app/screens/registrationSetSecurityPinScreen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends BaseRoute {
  SplashScreen({@required a, @required o}) : super(a: a, o: o, r: 'SplashScreen');
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseRouteState {
  final LocalAuthentication auth = LocalAuthentication();
  // List<String> _businessInventoryValueList;
  // int _selectedValue = 0;
  // var _logoPath;
  // bool _autovalidate = false;
  // String _businessInventory;
  _SplashScreenState() : super();
  @override
  Widget build(BuildContext context) {
    _basicSetup();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/logo.png',
                        width: 800.0,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        global.appName,
                        style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        global.appVersion,
                        style: TextStyle(fontSize: 12.0, color: Theme.of(context).primaryColorLight),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _basicSetup() {
    try {
      if (Theme.of(context).platform != TargetPlatform.android) {
        global.isAndroidPlatform = false;
      }
    } catch (e) {
      print('Exception - splashScreen.dart - _basicSetup(): ' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future _checkBiometrics() async {
    try {
      bool _isAvailableBiometric = await auth.canCheckBiometrics;

      if (_isAvailableBiometric) {
        List<BiometricType> _availableBiometrics = await auth.getAvailableBiometrics();

        global.availableBiometrics = _availableBiometrics.contains(BiometricType.fingerprint);
      }
    } catch (e) {
      print('Exception - splashScreen.dart - _checkBiometrics(): ' + e.toString());
    }
  }

  Future<List<dynamic>> _getLanguageList() async {
    try {
      return await br.systemLanguageGetList();
    } catch (e) {
      print("Exception - selectLanguageScreen.dart - _getLanguageList():");
      return null;
    }
  }

  Future _initData() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      global.appVersion = packageInfo.version;
      setState(() {});
      await loadsystemDirectoryPath();
      await br.getSharedPreferences();
      global.user = await dbHelper.userGetList();
      global.business = await dbHelper.businessGetList();
      await _checkBiometrics();
      await initializeSystemFlags();
      // WidgetsBinding.instance.addObserver(this);
      global.isAppStarted = true;
      if (br.getSystemFlagValue(global.systemFlagNameList.appLanguageCode) != '') {
        global.appLanguages = await _getLanguageList();
        List<dynamic> appLanguages = global.appLanguages.where((e) => e['languageCode'] == br.getSystemFlagValue(global.systemFlagNameList.appLanguageCode)).toList();
        if (appLanguages.length > 0) {
          global.appLanguage = appLanguages.first;
        } else {
          global.appLanguage = global.appLanguages.where((e) => e['languageCode'] == 'en').first;
        }
        await br.setSystemLanguage();
      }

      Timer(Duration(seconds: 2), () async {
        if (br.getSystemFlagValue(global.systemFlagNameList.appLanguageCode) == '') {
          global.appLanguages = await _getLanguageList();
          List<dynamic> appLanguages = global.appLanguages.where((e) => e['languageCode'] == Platform.localeName.split('_').first).toList();
          if (appLanguages.length > 0) {
            global.appLanguage = appLanguages.first;
          } else {
            global.appLanguage = global.appLanguages.where((e) => e['languageCode'] == 'en').first;
          }
          await br.setSystemLanguage();

          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (BuildContext context) =>  SelectLanguageScreen(
          //           a: widget.analytics,
          //           o: widget.observer,
          //         )));
        }
        if (br.getSystemFlagValue(global.systemFlagNameList.introductionDone) == 'false') {
          //true if first app launch
          Navigator.of(context).push(PageTransition(
              type: PageTransitionType.rightToLeft,
              child: RegistrationIntroSlidesScreen(
                a: widget.analytics,
                o: widget.observer,
              )));
        } else if (br.getSystemFlagValue(global.systemFlagNameList.permissionsGranted) == 'false') {
          //true if permissions is not given during registration
          Navigator.of(context).push(PageTransition(
              type: PageTransitionType.rightToLeft,
              child: RegistrationAskPermissionsScreen(
                a: widget.analytics,
                o: widget.observer,
              )));
        } else if (global.user == null) {
          //true if registration of Personal Details is pending
          Navigator.of(context).push(PageTransition(
              type: PageTransitionType.rightToLeft,
              child: RegistrationPersonalDetailsScreen(
                a: widget.analytics,
                o: widget.observer,
              )));
        } else if (global.business == null) {
          //true if registration of business Details is pending
          Navigator.of(context).push(PageTransition(
              type: PageTransitionType.rightToLeft,
              child: RegistrationBusinessDetailsScreen(
                a: widget.analytics,
                o: widget.observer,
              )));
        }
        //  else if (br.getSystemFlagValue(global.systemFlagNameList.enableTax) == null) {
        //   //true if registration of configuration is pending
        //   Navigator.of(context).push(PageTransition(
        //       type: PageTransitionType.rightToLeft,
        //       child: RegistrationTaxDetailsScreen(
        //         a: widget.analytics,
        //         o: widget.observer,
        //       )));
        // } else if (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength) == null) {
        //   //true if registration of configuration is pending
        //   Navigator.of(context).push(PageTransition(
        //       type: PageTransitionType.rightToLeft,
        //       child: RegistrationConfigurationScreen(
        //         a: widget.analytics,
        //         o: widget.observer,
        //       )));
        // } else if (br.getSystemFlagValue(global.systemFlagNameList.enableGoogleBackupRestore) == null) {
        //   //true if registration of set login pin is pending
        //   Navigator.of(context).push(PageTransition(
        //       type: PageTransitionType.rightToLeft,
        //       child: RegistrationBackupAndRestoreScreen(
        //         a: widget.analytics,
        //         o: widget.observer,
        //       )));
        // }
        else if (global.user != null && global.user.loginPin == null) {
          // if set login pin is pending
          Navigator.of(context).push(PageTransition(
              type: PageTransitionType.rightToLeft,
              child: RegistrationSetSecurityPinScreen(
                a: widget.analytics,
                o: widget.observer,
              )));
        } else {
          if (global.user.isLogin) {
            //true if registration of set login pin is pending
            Navigator.of(context).push(PageTransition(
                type: PageTransitionType.rightToLeft,
                child: LockScreen(
                  a: widget.analytics,
                  o: widget.observer,
                )));
          } else {
            // Navigator.of(context).push(PageTransition(
            //     type: PageTransitionType.rightToLeft,
            //     child: LoginScreen(
            //       a: widget.analytics,
            //       o: widget.observer,
            //     )));
          }
        }
        //Create  user if the user is not available
        // User _user =  User();
        // _user.firstName = "Admin";
        // _user.lastName = "User";
        // _user.email = "adminuser@invoices.com";
        // _user.mobile = 9999999999;
        // _user.birthdate = DateTime.now();
        // _user.id = await dbHelper.userInsert(_user);
        // if (_user.id != null) {
        //   global.user = _user;
        // }
      });
    } catch (e) {
      print('Exception - splashScreen.dart - _getdata(): ' + e.toString());
    }
  }
}
