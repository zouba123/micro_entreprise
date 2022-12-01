// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void
import 'package:accounting_app/dialogs/paymentMethodSelectDialog.dart';
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/decimalTextInputFormatter.dart';
import 'package:accounting_app/models/expenseModel.dart';
import 'package:accounting_app/models/expensePaymentsModel.dart';
import 'package:accounting_app/models/paymentDetailModel.dart';
import 'package:accounting_app/models/paymentModel.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ExpensePaymentAddDialog extends Base {
  final ValueChanged<PaymentDetail> paymentDetail;
  final double remainAmountToPay;
  final PaymentDetail paymentDetailEdit;
  final DateTime paymentTransactiondate;
  final Expense expense;
  ExpensePaymentAddDialog({this.paymentDetail, this.remainAmountToPay, this.paymentDetailEdit, this.expense, this.paymentTransactiondate}) : super();

  @override
  _ExpensePaymentAddDialogState createState() => _ExpensePaymentAddDialogState(this.paymentDetail, this.remainAmountToPay, this.paymentDetailEdit, this.expense, this.paymentTransactiondate);
}

class _ExpensePaymentAddDialogState extends BaseState {
  final ValueChanged<PaymentDetail> paymentDetail;
  final double remainAmountToPay;
  DateTime paymentTransactiondate;
  TextEditingController _cAmount = TextEditingController();
  TextEditingController _cRemark = TextEditingController();
  TextEditingController _cPaymentMode = TextEditingController();
  TextEditingController _cTransactiondate = TextEditingController();
  final _fPaymentMode = FocusNode();
  final _focusNode = FocusNode();
  final _fTransactionDate = FocusNode();
  bool _isValid = true;
  bool _autovalidate = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PaymentDetail paymentDetailEdit;
  Expense expense;
  _ExpensePaymentAddDialogState(this.paymentDetail, this.remainAmountToPay, this.paymentDetailEdit, this.expense, this.paymentTransactiondate) : super();
  DateTime _transactionDate2;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        (paymentDetailEdit == null) ? '${global.appLocaleValues['lbl_add_payment']}' : '${global.appLocaleValues['lbl_update_payment']}',
        style: Theme.of(context).primaryTextTheme.headline1,
      ),
      content: SingleChildScrollView(
        child: Form(
          autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (remainAmountToPay != null)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '${global.appLocaleValues['lbl_net_payable_due']}: ',
                          style: Theme.of(context).primaryTextTheme.headline6,
                        ),
                        Text(
                          '${global.currency.symbol} ${remainAmountToPay.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                          style: Theme.of(context).primaryTextTheme.headline3,
                        )
                      ],
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 10),
                child: Text(global.appLocaleValues['lbl_amount'], style: Theme.of(context).primaryTextTheme.headline3),
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _cAmount,
                onChanged: (value) {
                  _isValid = true;
                  if (value == '0') {
                    _isValid = false;
                  } else if (remainAmountToPay != null) {
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
                  hintText: '${global.appLocaleValues['lbl_amount']}',
                  //  labelText: '${global.appLocaleValues['lbl_amount']}',
                  suffixIcon: Icon(
                    Icons.star,
                    size: 9,
                    color: Colors.red,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 10),
                child: Text(global.appLocaleValues['lbl_payment_method'], style: Theme.of(context).primaryTextTheme.headline3),
              ),
              TextFormField(
                readOnly: true,
                controller: _cPaymentMode,
                focusNode: _fPaymentMode,
                decoration: InputDecoration(
                  hintText: global.appLocaleValues['lbl_payment_method'],
                  //  labelText: global.appLocaleValues['lbl_payment_method'],
                  suffixIcon: Icon(
                    Icons.star,
                    size: 9,
                    color: Colors.red,
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return global.appLocaleValues['lbl_err_req_payment_mode'];
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 10),
                child: Text(global.appLocaleValues['lbl_transaction_date'], style: Theme.of(context).primaryTextTheme.headline3),
              ),
              TextFormField(
                readOnly: true,
                controller: _cTransactiondate,
                focusNode: _fTransactionDate,
                decoration: InputDecoration(
                  hintText: global.appLocaleValues['lbl_transaction_date'],
                  //  labelText: global.appLocaleValues['lbl_transaction_date'],
                  suffixIcon: Icon(
                    Icons.star,
                    size: 9,
                    color: Colors.red,
                  ),
                  //   hintText: global.appLocaleValues['lbl_err_req_transaction_date'],
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return global.appLocaleValues['tle_payment_select_method'];
                  }
                  return null;
                },
                onTap: () {
                  _selectDate(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 10),
                child: Text(global.appLocaleValues['lbl_add_note_remark'], style: Theme.of(context).primaryTextTheme.headline3),
              ),
              TextFormField(
                maxLines: 4,
                controller: _cRemark,
                decoration: InputDecoration(
                  hintText: global.appLocaleValues['lbl_add_note_remark'],
                  // labelText: global.appLocaleValues['lbl_add_note_remark'],
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
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
        TextButton(
            //  textColor: Colors.blue,
            child: Text((paymentDetailEdit == null) ? global.appLocaleValues['btn_add'] : global.appLocaleValues['btn_update']),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                if (expense != null) {
                  Payment payment = Payment();
                  payment.transactionDate = _transactionDate2;
                  payment.amount = double.parse(_cAmount.text);
                  payment.remark = _cRemark.text;
                  payment.paymentType = _cPaymentMode.text;
                  payment.paymentDetailList.clear();
                  payment.paymentDetailList.add(PaymentDetail(null, null, double.parse(_cAmount.text), _cPaymentMode.text, _cRemark.text, false, null, null));
                  Payment _tobj = await dbHelper.paymentInsert(payment);
                  ExpensePayments expensePayments = ExpensePayments();
                  expensePayments.expenseId = expense.id;
                  expensePayments.paymentId = _tobj.id;
                  await dbHelper.expensePaymentInsert(expensePayments);
                  Navigator.of(context).pop();
                } else if (paymentDetailEdit == null) {
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

  Future<Null> _selectDate(BuildContext context) async {
    try {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != DateTime(2000)) {
        setState(() {
          _cTransactiondate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
          _transactionDate2 = picked;
        });
      }
    } catch (e) {
      print('Exception - expensePaymentAdd.dart - _selectDate(): ' + e.toString());
    }
  }

  void _getData() {
    try {
      if (paymentDetailEdit == null) {
        _transactionDate2 = DateTime.now();
        _cTransactiondate.text = paymentTransactiondate != null ? DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(paymentTransactiondate) : DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.now());
        _cPaymentMode.text = 'Cash';
      } else {
        _cAmount.text = paymentDetailEdit.amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        _cPaymentMode.text = paymentDetailEdit.paymentMode;
        _cRemark.text = paymentDetailEdit.remark;
        _cTransactiondate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(paymentTransactiondate);
      }
      _fPaymentMode.addListener(selectMode);
      setState(() {});
    } catch (e) {
      print('Exception - expensePaymentAdd.dart - _getData(): ' + e.toString());
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
      print('Exception - expensePaymentAdd.dart - selectMode(): ' + e.toString());
      return null;
    }
  }
}
