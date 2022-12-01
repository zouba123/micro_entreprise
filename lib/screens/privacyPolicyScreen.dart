// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'dart:async';

import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

class PrivacyPolicyScreen extends BaseRoute {
  PrivacyPolicyScreen({@required a, @required o}) : super(a: a, o: o, r: 'PrivacyPolicyScreen');

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends BaseRouteState {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  num _stackToView = 1;
  final _key = UniqueKey();
  Widget progressPrivacy =  Center(
    child: Container(
      child: CircularProgressIndicator(
        backgroundColor: Color(0xff0d46a0),
        valueColor:  AlwaysStoppedAnimation<Color>(Color(0xff0d46a0)),
        strokeWidth: 2,
      ),
    ),
  );

  _PrivacyPolicyScreenState() : super();

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: _checkBackPress,
        child: Scaffold(
          appBar:  AppBar(
            title: Text(
              global.appLocaleValues['tle_privacy_policy'],style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          body: IndexedStack(
            index: _stackToView,
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    child: WebView(
                      key: _key,
                      userAgent: 'FlutterWebView',
                      initialUrl: 'https://www.linkedin.com/in/hermi-zied/',
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController controller) {
                        _controller.complete(controller);
                      },
                      onPageFinished: _handleLoad,
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Future<bool> _checkBackPress() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardScreen(
                  a: widget.analytics,
                  o: widget.observer,
                )));
    return false;
  }

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }
}
