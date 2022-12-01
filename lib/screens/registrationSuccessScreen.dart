// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:page_transition/page_transition.dart';

class RegistrationSuccessScreen extends BaseRoute {
  RegistrationSuccessScreen({@required a, @required o}) : super(a: a, o: o, r: 'RegistrationSuccessScreen');
  @override
  _RegistrationSuccessScreenState createState() => _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends BaseRouteState {
  var _key = GlobalKey<ScaffoldState>();

  _RegistrationSuccessScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Text(
                  global.appLocaleValues['lbl_registration_done'],
                  style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 200,
                  width: 200,
                  child: Icon(
                    Icons.done,
                    size: 150,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    border: Border.all(
                      color: Theme.of(context).primaryColorLight,
                      width: 4.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  global.appLocaleValues['lbl_wlc_msg'],
                  style: Theme.of(context).primaryTextTheme.headline5,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              child: Text(
                global.appLocaleValues['btn_lets_start'],
                style: Theme.of(context).primaryTextTheme.headline2,
              ),
              onPressed: () async {
                //  global.isLockScreen = false;
                global.isUnlocked = true;

                Navigator.of(context).push(PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: DashboardScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // _init();
  }

  // Future _init() async {
  //   try {
  //     if (br.getSystemFlagValue(global.systemFlagNameList.enableGoogleBackupRestore) == 'true') {
  //       bool isConnected = await checkConnectivity();
  //       if (isConnected) {
  //         // _backUpData();
  //       } else {
  //         Navigator.of(context).push(PageTransition(
  //             type: PageTransitionType.rightToLeft,
  //             child: NetWorkErrorScreen(
  //               a: widget.analytics,
  //               o: widget.observer,
  //             )));
  //       }
  //     }
  //   } catch (e) {
  //     print("Exception - dashboardScreen.dart - _init():" + e.toString());
  //   }
  // }

  // _backUpData() async {
  //   try {
  //     // global.backupResult =  MethodResult();
  //     global.backupResult.statusMessage = '${global.appLocaleValues['txt_taking_init_backup']}';
  //     // global.backupResult = await backUp(true);
  //   } catch (e) {
  //     print("Exception - dashboardScreen.dart - _backUpData():" + e.toString());
  //   }
  // }
}
