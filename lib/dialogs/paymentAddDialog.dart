// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void
import 'package:accounting_app/dialogs/paymentMethodSelectDialog.dart';
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/decimalTextInputFormatter.dart';
import 'package:accounting_app/models/paymentDetailModel.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

class PaymentAddDialog extends Base {
  final ValueChanged<PaymentDetail> paymentDetail;
  final double remainAmountToPay;
  final PaymentDetail paymentDetailEdit;

  PaymentAddDialog({this.paymentDetail, this.remainAmountToPay, this.paymentDetailEdit}) : super();

  @override
  _PaymentAddDialogState createState() => _PaymentAddDialogState(this.paymentDetail, this.remainAmountToPay, this.paymentDetailEdit);
}

class _PaymentAddDialogState extends BaseState {
  final ValueChanged<PaymentDetail> paymentDetail;
  final double remainAmountToPay;
  TextEditingController _cAmount = TextEditingController();
  TextEditingController _cRemark = TextEditingController();
  TextEditingController _cPaymentMode = TextEditingController();
  final _fPaymentMode = FocusNode();
  final _focusNode = FocusNode();
  bool _isValid = true;
  bool _autovalidate = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PaymentDetail paymentDetailEdit;

  _PaymentAddDialogState(this.paymentDetail, this.remainAmountToPay, this.paymentDetailEdit) : super();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: nativeTheme().dialogTheme.shape,
      title: Text((paymentDetailEdit == null) ? '${global.appLocaleValues['lbl_add_payment']}' : global.appLocaleValues['lbl_update_payment'], style: Theme.of(context).primaryTextTheme.headline1),
      content: SingleChildScrollView(
        child: Form(
          autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
          key: _formKey,
          child: Column(
            children: <Widget>[
              (remainAmountToPay != null)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '${global.appLocaleValues['lbl_net_payable_due']}: ',
                          style: TextStyle(color: Colors.green),
                        ),
                        Text('${global.currency.symbol} ${remainAmountToPay.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}')
                      ],
                    )
                  : SizedBox(),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 8),
                  child: Text('${global.appLocaleValues['lbl_amount']}', style: Theme.of(context).primaryTextTheme.headline3),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _cAmount,
                onChanged: (value) {
                  _isValid = true;
                  if (value == '0') {
                    _isValid = false;
                  } else if (remainAmountToPay != null && value.isNotEmpty) {
                    if (remainAmountToPay < double.parse(value)) {
                      _isValid = false;
                    }
                  }
                  setState(() {});
                },
                inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value.isNotEmpty) {
                    if (value.contains(RegExp('[a-zA-Z]'))) {
                      return global.appLocaleValues['vel_enter_number_only'];
                    } else if (_isValid != true) {
                      return global.appLocaleValues['txt_amount_err_vld'];
                    }
                  } else {
                    return global.appLocaleValues['lbl_enter_amount'];
                  }
                  return null;
                },
                decoration: InputDecoration(
                  errorText: (_isValid) ? null : global.appLocaleValues['txt_amount_err_vld'],
                  border: nativeTheme().inputDecorationTheme.border,
                  hintText: '${global.appLocaleValues['lbl_amount']}',
                  prefixIcon: Icon(
                    Icons.payment,
                  ),
                  suffixIcon: Icon(
                    Icons.star,
                    size: 9,
                    color: Colors.red,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 8),
                  child: Text(global.appLocaleValues['lbl_payment_method'], style: Theme.of(context).primaryTextTheme.headline3),
                ),
              ),
              TextFormField(
                readOnly: true,
                controller: _cPaymentMode,
                focusNode: _fPaymentMode,
                decoration: InputDecoration(
                  border: nativeTheme().inputDecorationTheme.border,
                  hintText: global.appLocaleValues['lbl_payment_method'],
                  prefixIcon: Icon(
                    Icons.chrome_reader_mode,
                  ),
                  suffixIcon: Icon(
                    Icons.star,
                    size: 9,
                    color: Colors.red,
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return global.appLocaleValues['lbl_payment_mode_err_vel'];
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 8),
                  child: Text('${global.appLocaleValues['lbl_note_remark']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3),
                ),
              ),
              TextFormField(
                maxLines: 4,
                controller: _cRemark,
                decoration: InputDecoration(
                  border: nativeTheme().inputDecorationTheme.border,
                  prefixIcon: Icon(
                    Icons.info,
                  ),
                  hintText: global.appLocaleValues['lbl_add_note_remark'],
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        SizedBox(
          width: 80,
          child: TextButton(
            //  textColor: Colors.blue,
            child: Text(
              global.appLocaleValues['btn_cancel'],
              style: Theme.of(context).primaryTextTheme.headline3,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        SizedBox(
          width: 80,
          child: TextButton(
              //  textColor: Colors.blue,
              child: Text((paymentDetailEdit == null) ? global.appLocaleValues['btn_add'] : global.appLocaleValues['btn_update'], style: Theme.of(context).primaryTextTheme.headline2),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (paymentDetailEdit == null) {
                    paymentDetail(PaymentDetail(null, null, double.parse(_cAmount.text), _cPaymentMode.text, _cRemark.text, false, null, null));
                    Navigator.of(context).pop();
                  } else {
                    paymentDetailEdit.amount = double.parse(_cAmount.text);
                    paymentDetailEdit.paymentMode = _cPaymentMode.text;
                    paymentDetailEdit.remark = _cRemark.text;
                    Navigator.of(context).pop(paymentDetailEdit);
                  }
                } else {
                  _autovalidate = true;
                  setState(() {});
                }
              }),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _fPaymentMode.removeListener(selectMode);
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    try {
      if (paymentDetailEdit == null) {
        _cPaymentMode.text = 'Cash';
      } else {
        _cAmount.text = paymentDetailEdit.amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        _cPaymentMode.text = paymentDetailEdit.paymentMode;
        _cRemark.text = paymentDetailEdit.remark;
      }
      _fPaymentMode.addListener(selectMode);
      setState(() {});
    } catch (e) {
      print('Exception - paymentAddDialog.dart - _getData(): ' + e.toString());
      return null;
    }
  }

  Future<Null> selectMode() async {
    try {
      if (_fPaymentMode.hasFocus) {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return PaymentMethodSelectDialog(
                onChanged: (value) {
                  _cPaymentMode.text = value;
                },
              );
            });
        setState(() {
          FocusScope.of(context).requestFocus(_focusNode);
        });
      }
    } catch (e) {
      print('Exception - paymentAddDialog.dart - selectMode(): ' + e.toString());
      return null;
    }
  }
}
