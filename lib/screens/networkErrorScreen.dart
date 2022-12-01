// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

class NetWorkErrorScreen extends BaseRoute {
  NetWorkErrorScreen({@required a, @required o}) : super(a: a, o: o, r: 'NetworkErrorScreen');

  @override
  _NetWorkErrorScreenState createState() => _NetWorkErrorScreenState();
}

class _NetWorkErrorScreenState extends BaseRouteState {
  //double sizeContainer, logoWidth, logoHeight, textSizeAB, logoNative, textSizePB, iconSize, sizeboxTop;
  _NetWorkErrorScreenState() : super();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Padding(padding: const EdgeInsets.only(top: 80)),
        Text(
          global.appName,
          style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
        ),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 100),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.signal_wifi_off,
                  color: Colors.grey,
                  size: 180,
                ),
                SizedBox(
                  height: 10,
                ),
                FittedBox(
                  child: Text(
                    '${global.appLocaleValues['txt_net_err']}',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                )
              ],
            ))),
      ]),
      bottomSheet: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                  height: 50,
                  color: Theme.of(context).primaryColorLight,
                  onPressed: () {
                    exitAppDialog(1);
                  },
                  child: Text(
                    global.appLocaleValues['btn_exit'],
                  )),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: MaterialButton(
                  height: 50,
                  color: Theme.of(context).primaryColor,
                  child: Text(global.appLocaleValues['btn_retry']),
                  onPressed: () async {
                    // bool isConnected = await checkConnectivity();
                    // if (isConnected) {
                    //   Navigator.of(context).pop();
                    // } else {
                    //   showToast('${global.appLocaleValues['lbl_offline']}');
                    // }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
