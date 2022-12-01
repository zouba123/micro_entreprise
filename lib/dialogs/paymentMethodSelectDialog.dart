// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

enum mode { Cash, Cheque, Card, NetBanking, eWallet }

class PaymentMethodSelectDialog extends Base {
  final ValueChanged<String> onChanged;

  PaymentMethodSelectDialog({@required this.onChanged}) : super();
  @override
  _PaymentMethodSelectDialogState createState() => _PaymentMethodSelectDialogState(this.onChanged);
}

class _PaymentMethodSelectDialogState extends BaseState {
  int _selected;
  ValueChanged<String> onChanged;

  _PaymentMethodSelectDialogState(this.onChanged) : super();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: nativeTheme().dialogTheme.shape,
      title: Text(
        global.appLocaleValues['tle_payment_select_method'],
        style: Theme.of(context).primaryTextTheme.headline1,
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width - 40,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: mode.values.length,
          itemBuilder: (context, ind) {
            return RadioListTile(
              value: ind,
              groupValue: _selected,
              title: ((mode.values.length - 1) != ind)
                  ? Text('${mode.values[ind].toString().substring(mode.values[ind].toString().indexOf(".") + 1)}')
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('${mode.values[ind].toString().substring(mode.values[ind].toString().indexOf(".") + 1)}', style: Theme.of(context).primaryTextTheme.headline3,),
                        Text(
                          ' ex.(paytm)',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
              onChanged: (v) {
                setState(() {
                  _selected = v;
                  onChanged(mode.values[ind].toString().substring(mode.values[ind].toString().indexOf(".") + 1));
                  //  print(mode.values[ind].toString().substring(mode.values[ind].toString().indexOf(".") + 1));
                });
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
        //  textColor: Colors.blue,
          child: Text(global.appLocaleValues['btn_cancel']),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
}
