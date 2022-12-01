
// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print

import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

class EnableFingerprintDialog extends Base {
  EnableFingerprintDialog({@required a, @required o}) : super(analytics: a, observer: o);
  @override
  _EnableFingerprintDialogState createState() => _EnableFingerprintDialogState();
}

class _EnableFingerprintDialogState extends BaseState {
  bool _isFringerPrintOn = false;

  _EnableFingerprintDialogState() : super();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: nativeTheme().dialogTheme.shape,
      title: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.fingerprint,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          ),
          Text(
            global.appLocaleValues['tle_fingerprint_setup'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '${global.appLocaleValues['txt_fingerprint']}',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
              shape: nativeTheme().cardTheme.shape,
              child: ListTile(
                leading: Text(
                  global.appLocaleValues['lbl_enable_fingrprint'],
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Switch(
                  value: _isFringerPrintOn,
                  onChanged: (value) async {
                    _isFringerPrintOn = await br.authenticate();
                    setState(() {});
                  },
                ),
              ))
        ],
      ),
      actions: <Widget>[
        TextButton(
        //  textColor: Colors.blue,
          child: Text(global.appLocaleValues['btn_cancel']),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(false);
          },
        ),
        TextButton(
            child: Text(global.appLocaleValues['btn_ok']),
            onPressed: () async {
              await _updateEnableFingerPrint(_isFringerPrintOn.toString());
              Navigator.of(context, rootNavigator: true).pop(_isFringerPrintOn);
            }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _updateEnableFingerPrint(String value) async {
    try {
      await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.enableFingerPrint, value);
    } catch (e) {
      print('Exception - enableFingerprintDialog.dart - _updateEnableFingerPrint(): ' + e.toString());
    }
  }
}
