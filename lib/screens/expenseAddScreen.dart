// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals
import 'dart:io';

import 'package:accounting_app/dialogs/expenseCategorySelectDialog.dart';
import 'package:accounting_app/dialogs/expensePaymentAddDialog.dart';
import 'package:accounting_app/dialogs/paymentMethodSelectDialog.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/decimalTextInputFormatter.dart';
import 'package:accounting_app/models/expenseCategoryModel.dart';
import 'package:accounting_app/models/expenseModel.dart';
import 'package:accounting_app/models/expensePaymentsModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/screens/expenseScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart' as path;

class ExpenseAddScreen extends BaseRoute {
  final Expense expense;
  final int returnScreenId;
  ExpenseAddScreen({a, o, this.expense, this.returnScreenId}) : super(a: a, o: o, r: 'ExpenseAddScreen');
  @override
  _ExpenseAddScreenState createState() => _ExpenseAddScreenState(this.expense, this.returnScreenId);
}

class _ExpenseAddScreenState extends BaseRouteState {
  TextEditingController _cExpenseCategoryId = TextEditingController();
  TextEditingController _cAmount = TextEditingController();
  TextEditingController _cTransactionDate = TextEditingController();
  Payment payment = Payment();
  TextEditingController _cPaymentMode = TextEditingController();
  TextEditingController _cExpenseName = TextEditingController();
  TextEditingController _cBillerName = TextEditingController();
  TextEditingController _cBillNumber = TextEditingController();

  final _fExpenseCategoryId = FocusNode();
  final _fExpenseName = FocusNode();
  final _fAmount = FocusNode();
  final _fTransactionDate = FocusNode();
  final _fRemark = FocusNode();
  final _fPaymentMode = FocusNode();
  final _fBillerName = FocusNode();
  final _fBillNumber = FocusNode();
  var _key = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String _transactionDate2;
  Expense expense;
  ExpenseCategory _expenseCategory;
  bool _autovalidate = false;
  int returnScreenId;

  double _totalDue = 0;
  double _totalPaid = 0;
  _ExpenseAddScreenState(this.expense, this.returnScreenId) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: expense.id == null
              ? Text(
                  '${global.appLocaleValues['tle_add_expense']}',
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                )
              : Text(
                  '${global.appLocaleValues['tle_update_expense']}',
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (expense.isSplitPayment && expense.paymentList[0].paymentDetailList.length < 1) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(global.appLocaleValues['txt_payment_err'])));
                } else {
                  await _onSubmit();
                }
              },
              child: Text(global.appLocaleValues['btn_save'], style: TextStyle(color: Colors.white, fontSize: 18)),
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Form(
                key: _key,
                autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(global.appLocaleValues['lbl_expense_category'], style: Theme.of(context).primaryTextTheme.headline3),
                      ),
                      TextFormField(
                        controller: _cExpenseCategoryId,
                        readOnly: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: '${global.appLocaleValues['lbl_expense_category']}',
                          // labelText: '${global.appLocaleValues['lbl_expense_category']}',
                          suffixIcon: Icon(
                            Icons.star,
                            size: 9,
                            color: Colors.red,
                          ),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        focusNode: _fExpenseCategoryId,
                        onTap: () async {
                          await _selectExpenseCategory();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '${global.appLocaleValues['lbl_select_expense_cat_err_vel']}';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 10),
                        child: Text(global.appLocaleValues['lbl_amount'], style: Theme.of(context).primaryTextTheme.headline3),
                      ),
                      TextFormField(
                        focusNode: _fAmount,
                        controller: _cAmount,
                        textInputAction: TextInputAction.next,
                        maxLength: 5,
                        inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '${global.appLocaleValues['lbl_amount']}',
                          // labelText: '${global.appLocaleValues['lbl_amount']}',
                          suffixIcon: Icon(
                            Icons.star,
                            size: 9,
                            color: Colors.red,
                          ),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          expense.amount = double.parse(value);
                          _calculate();
                        },
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(_fPaymentMode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '${global.appLocaleValues['lbl_enter_amount']}';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Card(
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.only(left: 10),
                            title: Text('${global.appLocaleValues['lbl_split_payment']}'),
                            value: expense.isSplitPayment,
                            onChanged: (value) {
                              if (!value) {
                                expense.paymentList.forEach((element) {
                                  element.paymentDetailList.clear();
                                });
                                for (int i = 0; i < expense.paymentList.length; i++) {
                                  if (expense.paymentList[i].id != null) {
                                    expense.paymentList.removeAt(i);
                                  }
                                }
                              }

                              setState(() {
                                expense.isSplitPayment = value;
                              });
                            },
                          ),
                        ),
                      ),
                      (!expense.isSplitPayment)
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 10),
                              child: Text(global.appLocaleValues['lbl_payment_mode'], style: Theme.of(context).primaryTextTheme.headline3),
                            )
                          : SizedBox(),
                      (!expense.isSplitPayment)
                          ? TextFormField(
                              controller: _cPaymentMode,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: '${global.appLocaleValues['lbl_payment_mode']}',
                                // labelText: '${global.appLocaleValues['lbl_payment_mode']}',
                                suffixIcon: Icon(
                                  Icons.star,
                                  size: 9,
                                  color: Colors.red,
                                ),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                              focusNode: _fPaymentMode,
                              readOnly: true,
                              validator: (v) {
                                if (v.isEmpty) {
                                  return '${global.appLocaleValues['lbl_err_req_payment_mode']}';
                                }
                                return null;
                              },
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 10),
                        child: Text(global.appLocaleValues['lbl_transaction_date'], style: Theme.of(context).primaryTextTheme.headline3),
                      ),
                      TextFormField(
                        controller: _cTransactionDate,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: '${global.appLocaleValues['lbl_transaction_date']}',
                          // labelText: '${global.appLocaleValues['lbl_transaction_date']}',
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        focusNode: _fTransactionDate,
                        readOnly: true,
                        validator: (v) {
                          if (v.isEmpty) {
                            return '${global.appLocaleValues['lbl_transaction_err_req']}';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 10),
                        child: Text('${global.appLocaleValues['lbl_expense_name']}/${global.appLocaleValues['lbl_desc']}', style: Theme.of(context).primaryTextTheme.headline3),
                      ),
                      TextFormField(
                        controller: _cExpenseName,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: '${global.appLocaleValues['lbl_expense_name']}/${global.appLocaleValues['lbl_desc']}',
                          // labelText: '${global.appLocaleValues['lbl_expense_name']}/${global.appLocaleValues['lbl_desc']}',
                        ),
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.text,
                        focusNode: _fExpenseName,
                        onChanged: (val) {
                          if (val != null) {
                            expense.expenseName = val.trim();
                          }
                        },
                      ),
                      (expense.isSplitPayment)
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: <Widget>[
                                  TextButton(
                                    child: Text(
                                      '${global.appLocaleValues['btn_add_payment']}',
                                      style: Theme.of(context).primaryTextTheme.headline2,
                                    ),
                                    onPressed: () async {
                                      payment.transactionDate = DateTime.now();

                                      _calculate();

                                      await _addPaymentMethod(payment);
                                    },
                                  ),
                                  _paymentList(),
                                  expense.paymentList.isNotEmpty && expense.paymentList.length > 0 && expense.paymentList[0].paymentDetailList.isNotEmpty
                                      ? Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Card(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 40,
                                                  child: ListTile(
                                                      title: Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Text(
                                                          '${global.appLocaleValues['lbl_total_paid']}',
                                                          style: TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 17),
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                        '${global.currency.symbol} ${_totalPaid.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                        style: TextStyle(fontSize: 17),
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                  child: ListTile(
                                                      title: Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Text(
                                                          (_totalDue >= 0) ? '${global.appLocaleValues['lbl_net_payable_due']}' : '${global.appLocaleValues['lbl_total_credit']}',
                                                          style: TextStyle(color: Colors.black54, fontSize: 17),
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                          (_totalDue >= 0)
                                                              ? ' ${global.currency.symbol} ${_totalDue.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'
                                                              : ' ${global.currency.symbol} ${(_totalDue * -1).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                          style: TextStyle(fontSize: 17))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Card(
                          child: SwitchListTile(
                            value: expense.isPaid,
                            title: Text('${global.appLocaleValues['lbl_mark_as_paid']}'),
                            onChanged: (value) {
                              setState(() {
                                expense.isPaid = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 10),
                        child: Text(global.appLocaleValues['tle_biller_name'], style: Theme.of(context).primaryTextTheme.headline3),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: _cBillerName,
                          focusNode: _fBillerName,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: '${global.appLocaleValues['tle_biller_name']}',
                            // labelText: '${global.appLocaleValues['tle_biller_name']}'
                          ),
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          onChanged: (val) {
                            if (val.isNotEmpty) {
                              expense.billerName = val.trim();
                            } else {
                              expense.billerName = null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 10),
                        child: Text(global.appLocaleValues['tle_bill_number'], style: Theme.of(context).primaryTextTheme.headline3),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: _cBillNumber,
                          focusNode: _fBillNumber,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: '${global.appLocaleValues['tle_bill_number']}',
                            // labelText: '${global.appLocaleValues['tle_bill_number']}',
                          ),
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          onChanged: (val) {
                            if (val.isNotEmpty) {
                              expense.billNumber = val.trim();
                            } else {
                              expense.billNumber = null;
                            }
                          },
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 190,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(color: Colors.grey[200]),
                                image: expense.tempFilePath != null && expense.tempFilePath.contains('.png')
                                    ? DecorationImage(fit: BoxFit.cover, image: FileImage(File(expense.tempFilePath)))
                                    : expense.filePath != null && expense.filePath.contains('.png')
                                        ? DecorationImage(fit: BoxFit.cover, image: FileImage(File(expense.filePath)))
                                        : null),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 90,
                                ),
                                expense.filePath != null || expense.tempFilePath != null
                                    ? (expense.filePath != null && expense.filePath.contains('.pdf')) || (expense.tempFilePath != null && expense.tempFilePath.contains('.pdf'))
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 25.0,
                                            ),
                                            child: Text(
                                              "bill.pdf",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 25.0,
                                            ),
                                            child: Text(
                                              "",
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 25.0,
                                        ),
                                        child: Text(
                                          "${global.appLocaleValues['txt_no_bill_copy_uploaded']}",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                Expanded(
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          await _optionsDialogBoxToUploadFile();
                                        },
                                        child: Text("${(expense.filePath != null && expense.tempFilePath != null) ? global.appLocaleValues['btn_change'] : global.appLocaleValues['btn_upload']}", style: Theme.of(context).primaryTextTheme.headline2),
                                      ),
                                      expense.filePath != null || expense.tempFilePath != null
                                          ? SizedBox(
                                              width: 8,
                                            )
                                          : SizedBox(),
                                      expense.filePath != null || expense.tempFilePath != null
                                          ? TextButton(
                                              onPressed: () async {
                                                expense.oldFilePath = expense.filePath;
                                                expense.tempFilePath = null;
                                                expense.filePath = null;
                                                setState(() {});
                                              },
                                              child: Text(
                                                "${global.appLocaleValues['btn_remove']}",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 70,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _fPaymentMode.removeListener(_selectMode);
    _fTransactionDate.removeListener(_selectdateListener);
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _addPaymentMethod(Payment payment) async {
    try {
      if (expense.amount > 0) {
        //   //   _remainAmount = (invoice.payment.paymentDetailList.length != 0) ? invoice.netAmount - invoice.payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount) : invoice.netAmount;
        //   if (_totalDue > 0) {
        await showDialog(
            context: context,
            builder: (_) {
              return ExpensePaymentAddDialog(
                paymentTransactiondate: payment.transactionDate,
                remainAmountToPay: double.parse(_totalDue.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))),
                paymentDetail: (object) {
                  payment.paymentDetailList.add(object);

                  payment.paymentDetailList[payment.paymentDetailList.length - 1].isRecentlyAdded = (expense.id != null) ? true : false;

                  _calculate();

                  if (_totalDue == 0) {
                    expense.isPaid = true;
                  }
                  setState(() {});
                },
              );
            });
        // }
        //   else {
        //     expense.isPaid = true;
        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['lbl_err_vld_payment']}')));
        //   }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${global.appLocaleValues['lbl_amount_err_req']}'),
        ));
      }
    } catch (e) {
      print('Exception - expenseAddScreen.dart - _addPaymentMethod(): ' + e.toString());
    }
  }

  void _amountListener() {
    try {
      if (_fAmount.hasFocus) {
        if (_cAmount.text == '${0.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}') {
          _cAmount.clear();
        }
      } else {
        if (_cAmount.text == '') {
          _cAmount.text = '${0.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}';
        }
      }
      setState(() {});
    } catch (e) {
      print('Exception - expenseAddScreen.dart - _amountListener(): ' + e.toString());
    }
  }

  void _calculate() {
    double _paid = 0;
    expense.paymentList.forEach((e) {
      e.paymentDetailList.forEach((element) {
        if (!element.deletedFromScreen) {
          _paid += element.amount;
        }
      });
    });

    _totalPaid = _paid;
    _totalDue = expense.amount - _totalPaid;
  }

  Future _fillData() async {
    try {
      _cExpenseCategoryId.text = expense.expenseCategoryName;
      _cAmount.text = expense.amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))).toString();
      _cExpenseName.text = expense.expenseName;
      _cPaymentMode.text = expense.paymentMode;
      _transactionDate2 = expense.transactionDate.toString();
      _cTransactionDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(expense.transactionDate.toString()));
      _cBillNumber.text = expense.billNumber;
      _cBillerName.text = expense.billerName;
      List<ExpensePayments> _tExpensePaymentList = await dbHelper.expensePaymentsGetList(expenseId: expense.id);
      if (_tExpensePaymentList.isNotEmpty && _tExpensePaymentList.length > 0) {
        expense.paymentList = await dbHelper.paymentGetList(paymentIdList: _tExpensePaymentList.map((e) => e.paymentId).toList());

        if (expense.paymentList.isNotEmpty && expense.paymentList.length > 0) {
          for (int i = 0; i < expense.paymentList.length; i++) {
            expense.paymentList[i].paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: [expense.paymentList[i].id]);
          }
        }
      }

      _calculate();
      setState(() {});
    } catch (e) {
      print('Exception - expenseAddScreen.dart - _fillData(): ' + e.toString());
    }
  }

  Future _getData() async {
    try {
      _fPaymentMode.addListener(_selectMode);
      _fTransactionDate.addListener(_selectdateListener);
      _fAmount.addListener(_amountListener);
      if (expense == null) {
        expense = Expense();
        expense.amount = 0;
        expense.paymentMode = 'Cash';
        _cPaymentMode.text = expense.paymentMode;
        expense.amount = 0;
        _cAmount.text = expense.amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        _cTransactionDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
        _transactionDate2 = DateTime.now().toString().substring(0, 10);
        payment.transactionDate = DateTime.parse(_transactionDate2);
      } else {
        await _fillData();
      }
      expense.paymentList.add(payment);
    } catch (e) {
      print('Exception - expenseAddScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    int result = 0;
    try {
      if (_key.currentState.validate()) {
        showLoader(global.appLocaleValues['txt_wait']);
        setState(() {});
        expense.expenseCategoryId = (_expenseCategory != null) ? _expenseCategory.id : expense.expenseCategoryId;
        expense.amount = double.parse(_cAmount.text.trim());
        expense.transactionDate = DateTime.parse(_transactionDate2);

        expense.paymentMode = _cPaymentMode.text.trim();
        expense.expenseName = _cExpenseName.text.trim();

        if (expense.tempFilePath != null) {
          expense.oldFilePath = expense.filePath;
          expense.filePath = global.expenseBillsDirectoryPath + '/' + path.basename(expense.tempFilePath);
        } else if (expense.oldFilePath != null) {
          expense.filePath = null;
        }
        if (expense.id == null) {
          result = await dbHelper.expenseInsert(expense);
          expense.id = result;
          hideLoader();
          setState(() {});
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => ExpenseScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )));
        } else {
          result = await dbHelper.expenseUpdate(expense);
          if (returnScreenId != null && returnScreenId == 1) {
            List<ExpensePayments> _tExpensePaymentList = await dbHelper.expensePaymentsGetList(expenseId: expense.id);
            if (_tExpensePaymentList.isNotEmpty && _tExpensePaymentList.length > 0) {
              expense.paymentList = await dbHelper.paymentGetList(paymentIdList: _tExpensePaymentList.map((e) => e.paymentId).toList());

              if (expense.paymentList.isNotEmpty && expense.paymentList.length > 0) {
                for (int i = 0; i < expense.paymentList.length; i++) {
                  expense.paymentList[i].paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: [expense.paymentList[i].id]);
                }
              }
            }
          }
        }
        if (result > 0) {
          if (expense.filePath != null && expense.tempFilePath != null) {
            bool _isSaved = await br.saveFile(expense.tempFilePath, expense.filePath);
            if (_isSaved) {
              await br.deleteFile(expense.tempFilePath);
              expense.tempFilePath = null;
            }
          }
          if (expense.oldFilePath != null) {
            await br.deleteFile(expense.oldFilePath);
            expense.oldFilePath = null;
          }
          hideLoader();
          setState(() {});
          if (returnScreenId != null && returnScreenId == 1) {
            Navigator.of(context).pop(expense);
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => ExpenseScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          }
        }
      } else {
        setState(() {
          _autovalidate = true;
        });
      }
    } catch (e) {
      print('Exception - expenseAddScreen.dart - _onSubmit(): ' + e.toString());
    }
  }

  Future<void> _optionsDialogBoxToUploadFile() {
    try {
      return showModalBottomSheet(
          context: context,
          builder: (context) {
            return Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        "${global.appLocaleValues['txt_camera']}",
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        global.isAppOperation = true;
                        showLoader('${global.appLocaleValues['txt_wait']}');
                        setState(() {});
                        expense.tempFilePath = await br.openCamera(global.expenseBillsDirectoryPath, Theme.of(context).primaryColor);
                        hideLoader();
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        "${global.appLocaleValues['txt_gallery']}",
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        global.isAppOperation = true;
                        showLoader('${global.appLocaleValues['txt_wait']}');
                        setState(() {});
                        expense.tempFilePath = await br.openGallery(global.expenseBillsDirectoryPath, Theme.of(context).primaryColor);
                        hideLoader();
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        MdiIcons.filePdfBox,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        "${global.appLocaleValues['txt_pdf']}",
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        global.isAppOperation = true;
                        expense.tempFilePath = await br.openFileExplorer(global.expenseBillsDirectoryPath);
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.picture_as_pdf,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        "${global.appLocaleValues['btn_generate_pdf']}",
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        global.isAppOperation = true;
                        showLoader('${global.appLocaleValues['txt_wait']}');
                        setState(() {});
                        expense.tempFilePath = await br.generatePdf(global.expenseBillsDirectoryPath);
                        hideLoader();
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.cancel,
                      ),
                      title: Text(
                        "${global.appLocaleValues['txt_cancel']}",
                      ),
                      onTap: () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ],
                ),
              ],
            );
          });
    } catch (e) {
      print("Exception - expenseAddScreen.dart - _optionsDialogBoxToUploadFile():" + e.toString());
    }
    return null;
  }

  Widget _paymentDetailList(Payment payment) {
    try {
      List<Widget> _widgetList = [];
      if (payment != null) {
        for (int i = 0; i < payment.paymentDetailList.length; i++) {
          _widgetList.add(Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                    child: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        try {
                          payment.paymentDetailList.removeAt(i);
                          if (payment.paymentDetailList.length == 0) {
                            if (payment.id != null) {
                              expense.paymentList.removeWhere((e) => e.id == payment.id);
                            }
                          }
                          _calculate();

                          setState(() {});
                        } catch (e) {
                          print('Exception - expenseAddScreen.dart - _onDeletePayment(): ' + e.toString());
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ListTile(
                          onTap: () async {
                            try {
                              payment.paymentDetailList[i].isEdited = true;
                              await showDialog(
                                  context: context,
                                  builder: (_) {
                                    return ExpensePaymentAddDialog(
                                      paymentTransactiondate: payment.transactionDate,
                                      remainAmountToPay: double.parse((_totalDue + payment.paymentDetailList[i].amount).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))),
                                      paymentDetailEdit: payment.paymentDetailList[i],
                                    );
                                  }).then((value) {
                                if (value != null) {
                                  payment.paymentDetailList.insert(i, value);
                                  payment.paymentDetailList.removeAt(i + 1);

                                  _calculate();
                                  // _calculate(payment);
                                  if (_totalDue == 0) {
                                    expense.isPaid = true;
                                  }
                                  setState(() {});
                                }
                              });
                            } catch (e) {
                              print('Exception - expenseAddScreen.dart - _onEditPayment(): ' + e.toString());
                            }
                          },
                          title: Text(
                            '${payment.paymentDetailList[i].paymentMode}',
                            style: TextStyle(color: Colors.grey, fontSize: 17),
                          ),
                          subtitle: (payment.paymentDetailList[i].remark != null) ? Text('${payment.paymentDetailList[i].remark}') : null,
                          trailing: Text(
                            '${global.currency.symbol} ${payment.paymentDetailList[i].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                            style: TextStyle(fontSize: 17),
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ));
        }
      }

      return Column(
        children: _widgetList,
      );
    } catch (e) {
      print("Exception - expenseAddScreen - _paymentDetailList():" + e.toString());
      return SizedBox();
    }
  }

  Widget _paymentList() {
    try {
      List<Widget> _widgetList = [];
      if (expense.paymentList.isNotEmpty && expense.paymentList.length > 0) {
        for (int i = 0; i < expense.paymentList.length; i++) {
          if (expense.paymentList[i].paymentDetailList.isNotEmpty) {
            _widgetList.add(Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Text("${expense.paymentList[i].transactionDate != null ? DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(expense.paymentList[i].transactionDate.toString())) : ''}"),
                      trailing: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          expense.paymentList[i].paymentDetailList.clear();
                          if (expense.paymentList[i].id != null) {
                            expense.paymentList.removeAt(i);
                          }
                          _calculate();
                          setState(() {});
                        },
                      ),
                    ),
                    _paymentDetailList(expense.paymentList[i])
                  ],
                ),
              ),
            ));
          }
        }
      }

      return Column(
        children: _widgetList,
      );
    } catch (e) {
      print("Exception - expenseAddScreen - _paymentList():" + e.toString());
      return SizedBox();
    }
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
          _cTransactionDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
          _transactionDate2 = picked.toString().substring(0, 10);
        });
      }
      FocusScope.of(context).requestFocus(_fRemark);
    } catch (e) {
      print('Exception - expenseAddScreen.dart - _selectDate(): ' + e.toString());
    }
  }

  Future<Null> _selectdateListener() async {
    try {
      if (_fTransactionDate.hasFocus) {
        _selectDate(context);
      }
    } catch (e) {
      print('Exception - expenseAddScreen.dart - _selectdateListener(): ' + e.toString());
    }
  }

  Future<Null> _selectExpenseCategory() async {
    try {
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return ExpenseCategorySelectDialog(
              a: widget.analytics,
              o: widget.observer,
              returnScreenId: 0,
              selectedExpense: (obj) {
                _expenseCategory = obj;
              },
            );
          }).then((v) {
        if (_expenseCategory == null) {
          _expenseCategory = v;
        }
      });
      setState(() {
        expense.expenseCategoryId = (_expenseCategory != null) ? _expenseCategory.id : expense.expenseCategoryId;
        _cExpenseCategoryId.text = (_expenseCategory != null) ? _expenseCategory.name : '';
        expense.expenseCategoryName = _expenseCategory.name;
      });
      FocusScope.of(context).requestFocus(_fAmount);
    } catch (e) {
      print('Exception - expenseAddScreen.dart - _selectExpenseCategory(): ' + e.toString());
    }
  }

  Future<Null> _selectMode() async {
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
          FocusScope.of(context).requestFocus(_fRemark);
        });
      }
    } catch (e) {
      print('Exception - expenseAddScreen.dart - _selectMode(): ' + e.toString());
    }
  }
}
