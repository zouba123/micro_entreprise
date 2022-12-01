// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/dialogs/paymentAddDialog.dart';
import 'package:accounting_app/models/EmployeeSalaryModel.dart';
import 'package:accounting_app/models/EmployeeSalaryPaymentModel.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/accountSearchModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/employeeScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeePaymentAddScreen extends BaseRoute {
  final Payment payment;
  final SaleInvoice saleInvoice;
  final PurchaseInvoice purchaseInvoice;
  final int returnScreenId;
  final Account account;
  final EmployeeSalaryPayment employeeSalaryPayment;
  final bool isAdvanced;

  EmployeePaymentAddScreen({@required a, @required o, @required this.returnScreenId, this.payment, this.saleInvoice, this.account, this.purchaseInvoice, this.employeeSalaryPayment, this.isAdvanced}) : super(a: a, o: o, r: 'PaymentAddScreen');
  @override
  _EmployeePaymentAddScreenState createState() => _EmployeePaymentAddScreenState(this.payment, this.saleInvoice, this.returnScreenId, this.account, this.purchaseInvoice, this.employeeSalaryPayment, this.isAdvanced);
}

class _EmployeePaymentAddScreenState extends BaseRouteState {
  Payment payment;
  final SaleInvoice saleInvoice;
  final PurchaseInvoice purchaseInvoice;
  final int returnScreenId;
  final Account account;
  EmployeeSalaryPayment employeeSalaryPayment;
  bool isAdvanced;

  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();
  final _fAccountId =  FocusNode();
  final _fTransactioDate =  FocusNode();
  final _focusNode =  FocusNode();
  TextEditingController _cAccountId =  TextEditingController();
  TextEditingController _cTransactionDate =  TextEditingController();
  TextEditingController _cRemark =  TextEditingController();
  var _formKey = GlobalKey<FormState>();
  String _paymentType = 'RECEIVED';
  double _totalAmount = 0;
  String _transactionDate2;
  Account _account;
  double _remainAmount = 0.0;
  bool _isDataLoaded = false;
  bool _isAdvanced = false;
  List<EmployeeSalary> _employeeSalary = [];

  _EmployeePaymentAddScreenState(this.payment, this.saleInvoice, this.returnScreenId, this.account, this.purchaseInvoice, this.employeeSalaryPayment, this.isAdvanced) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: (payment.id == null) ? Text(global.appLocaleValues['lbl_add_salary_payment']) : Text(global.appLocaleValues['lbl_update_salary_payment']),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await _onSave();
              },
              child: Text(global.appLocaleValues['btn_save'], style: TextStyle(color: Colors.white, fontSize: 18)),
            )
          ],
        ),
        body: (_isDataLoaded)
            ? Scrollbar(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                (payment.id == null || (payment.id != null && payment.accountId != null))
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: TextFormField(
                                          controller: _cAccountId,
                                          focusNode: _fAccountId,
                                          readOnly: true,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: '${global.appLocaleValues['lbl_choose_emp']}',
                                            labelText: '${global.appLocaleValues['lbl_choose_emp']}',
                                            border: nativeTheme().inputDecorationTheme.border,
                                            suffixIcon: Icon(
                                              Icons.star,
                                              size: 9,
                                              color: Colors.red,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return global.appLocaleValues['lbl_choose_emp'];
                                            }
                                            return null;
                                          },
                                          onFieldSubmitted: (v) {
                                            // FocusScope.of(context).requestFocus(_fEventTypeId);
                                          },
                                        ),
                                      )
                                    : SizedBox(),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: TextFormField(
                                    readOnly: true,
                                    focusNode: _fTransactioDate,
                                    decoration: InputDecoration(
                                      labelText: global.appLocaleValues['lbl_transaction_date'],
                                      suffixIcon: Icon(
                                        Icons.star,
                                        size: 9,
                                        color: Colors.red,
                                      ),
                                      border: nativeTheme().inputDecorationTheme.border,
                                    ),
                                    controller: _cTransactionDate,
                                    keyboardType: null,
                                    validator: (v) {
                                      if (v.isEmpty) {
                                        return global.appLocaleValues['lbl_transaction_err_req'];
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: TextFormField(
                                    controller: _cRemark,
                                    decoration: InputDecoration(
                                      hintText: global.appLocaleValues['lbl_salary'],
                                      labelText: '${global.appLocaleValues['lbl_salary']}',
                                      border: nativeTheme().inputDecorationTheme.border,
                                      alignLabelWithHint: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Divider(),
                          // Padding(
                          //   padding: EdgeInsets.only(left: 10, right: 10),
                          //   child: Column(
                          //     children: <Widget>[
                          //       Text(
                          //         global.appLocaleValues['lbl_payment_type'],
                          //         style: TextStyle(color: Colors.grey, fontSize: 15),
                          //       ),
                          //       Row(
                          //         children: <Widget>[
                          //           Flexible(
                          //             child: RadioListTile(
                          //               dense: false,
                          //               value: 0,
                          //               groupValue: _selectedType,
                          //               title: Text(
                          //                 global.appLocaleValues['lbl_received'],
                          //                 style: TextStyle(fontSize: 15),
                          //               ),
                          //               onChanged: (int value) {
                          //                 _onTypeChange(value);
                          //               },
                          //             ),
                          //           ),
                          //           Flexible(
                          //             child: RadioListTile(
                          //               dense: false,
                          //               value: 1,
                          //               groupValue: _selectedType,
                          //               title: Text(
                          //                 global.appLocaleValues['lbl_given'],
                          //                 style: TextStyle(fontSize: 15),
                          //               ),
                          //               onChanged: (int value) {
                          //                 _onTypeChange(value);
                          //               },
                          //             ),
                          //           ),
                          //         ],
                          //       )
                          //     ],
                          //   ),
                          // ),
                          Divider(),
                          ListTile(
                            title: Text(
                              '${global.appLocaleValues['lbl_tot_amount']}',
                              style: TextStyle(color: Colors.grey, fontSize: 17),
                            ),
                            trailing: Text(
                              '${global.currency.symbol} ${_totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: <Widget>[
                                (payment.id == null)
                                    ? MaterialButton(
                                        color: Theme.of(context).primaryColor,
                                        minWidth: MediaQuery.of(context).size.width,
                                        child: Text(global.appLocaleValues['btn_add_payment_detail']),
                                        onPressed: () async {
                                          await _addPaymentMethods();
                                        },
                                      )
                                    : Text(
                                        global.appLocaleValues['lbl_payment_methods'],
                                        style: TextStyle(color: Colors.grey, fontSize: 15),
                                      ),
                                ListView.builder(
                                  itemCount: payment.paymentDetailList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 20,
                                          child: (payment.id == null)
                                              ? IconButton(
                                                  icon: Icon(
                                                    Icons.cancel,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    _totalAmount -= payment.paymentDetailList[index].amount;
                                                    payment.paymentDetailList.removeAt(index);
                                                    setState(() {});
                                                  },
                                                )
                                              : SizedBox(),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 55,
                                            child: ListTile(
                                                title: Text(
                                                  '${payment.paymentDetailList[index].paymentMode}',
                                                  style: TextStyle(color: Colors.grey, fontSize: 17),
                                                ),
                                                //    title: Text('${payment.paymentDetailList[index].paymentMode} - ${global.currency.symbol} ${payment.paymentDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'),
                                                subtitle: (payment.paymentDetailList[index].remark != null) ? Text('${payment.paymentDetailList[index].remark}') : null,
                                                //   subtitle: Text('${payment.paymentDetailList[index].remark}'),
                                                trailing: Text(
                                                  '${global.currency.symbol} ${payment.paymentDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                  style: TextStyle(fontSize: 17),
                                                )),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Divider(),
                              ListTile(
                                leading: Text(global.appLocaleValues['lbl_advance']),
                                trailing: Switch(
                                  value: _isAdvanced,
                                  onChanged: (value) {
                                    setState(() {
                                      _isAdvanced = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ));
  }

  @override
  void dispose() {
    super.dispose();
    _fTransactioDate.removeListener(_dateListener);
    _fAccountId.removeListener(_accountListener);
  }

  @override
  void initState() {
    super.initState();
    _fTransactioDate.addListener(_dateListener);
    _fAccountId.addListener(_accountListener);
    if (employeeSalaryPayment == null) {
      employeeSalaryPayment =  EmployeeSalaryPayment();
    }
    if (isAdvanced != null) {
      _isAdvanced = isAdvanced;
    }
    _getEmployeeSalary();
    if (account != null) {
      _cAccountId.text = '${account.firstName} ${account.lastName}';
    }
    if (payment == null) {
      payment =  Payment();

      _cTransactionDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
      _transactionDate2 = DateTime.now().toString().substring(0, 10);

      _isDataLoaded = true;
    } else {
      _fetchDataForUpdate();
    }
  }

  Future _getEmployeeSalary() async {
    if (account != null) {
      _employeeSalary = await dbHelper.employeeSalaryAmountGetList(accountId: [account.id], status: 'Due', withoutPaid: 'Paid');
      _employeeSalary.forEach((element) {
        _cRemark.text = _employeeSalary.map((f) => f.salaryAmount).reduce((sum, amt) => sum + amt).toString();
        _remainAmount = _employeeSalary.map((f) => f.salaryAmount).reduce((sum, amt) => sum + amt);
      });

      print(_employeeSalary.length);
    } else {
      _cRemark.text = '';
    }
  }

  Future _accountListener() async {
    try {
      if (payment.id == null && _fAccountId.hasFocus) {
        await Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) =>  AccountSelectDialog(
                      a: widget.analytics,
                      o: widget.observer,
                      returnScreenId: 4,
                      selectedAccount: (selectedAccount) {
                        if (selectedAccount.id != null) {
                          _account = selectedAccount;
                          _cAccountId.text = '${_account.firstName} ${_account.lastName}';
                        }
                      },
                    )))
            .then((v) {
          if (_account == null) {
            if (v != null) {
              _account = v;
              _cAccountId.text = '${_account.firstName} ${_account.lastName}';
            }
          }
        });
        setState(() {
          FocusScope.of(context).requestFocus(_focusNode);
        });
      }
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _accountListener(): ' + e.toString());
      return null;
    }
  }

  Future<Null> _dateListener() async {
    try {
      if (_fTransactioDate.hasFocus) {
        _selectDate(context); //open _cTransactionDate picker
      }
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _dateListener(): ' + e.toString());
      return null;
    }
  }

  Future _fetchDataForUpdate() async {
    try {
      payment.paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: [payment.id]);
      if (payment.account != null) {
        _cAccountId.text = '${payment.account.firstName} ${payment.account.lastName}';
      }
      //   '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + payment.account.accountCode.toString().length))}${payment.account.accountCode} - ${payment.account.firstName} ${payment.account.lastName}';
      _cTransactionDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(payment.transactionDate);
      _transactionDate2 = payment.transactionDate.toString();
      //_cRemark.text = payment.remark;
      _paymentType = payment.paymentType;
      // _selectedType = (payment.paymentType == 'RECEIVED') ? 0 : 1;
      _totalAmount = payment.amount;
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _fetchDataForUpdate(): ' + e.toString());
      return null;
    }
  }

  Future _onSave() async {
    try {
      if (payment.paymentDetailList.length != 0) {
        showLoader(global.appLocaleValues['txt_wait']);
        setState(() {});
        if (_formKey.currentState.validate()) {
          if (account != null) {
            payment.accountId = account.id;
          } else {
            payment.accountId = (_account != null) ? _account.id : payment.accountId;
          }
          payment.amount = _totalAmount;
          payment.transactionDate = DateTime.parse(_transactionDate2);
          payment.paymentType = _paymentType;
          payment.remark = _cRemark.text.trim();
          if (payment.id == null) {
            payment = await dbHelper.paymentInsert(payment);
            if (payment.id != null) {
              if (_isAdvanced == true) {
                employeeSalaryPayment.id = null;
                employeeSalaryPayment.employeeSalaryId = null;
                employeeSalaryPayment.accountId = (account != null) ? account.id : _account.id;
                employeeSalaryPayment.paymentId = payment.id;
                employeeSalaryPayment.transactionDate = DateTime.parse(_transactionDate2);
                employeeSalaryPayment.isActive = true;
                employeeSalaryPayment.isAdvanced = _isAdvanced;
                employeeSalaryPayment.salaryAmount = double.parse(_cRemark.text);
                await dbHelper.employeeSalaryPaymentsInsert(employeeSalaryPayment);
              } else {
                for (int i = 0; i < _employeeSalary.length; i++) {
                  employeeSalaryPayment.id = null;
                  employeeSalaryPayment.employeeSalaryId = _employeeSalary[i].id;
                  employeeSalaryPayment.accountId = account.id;
                  employeeSalaryPayment.paymentId = payment.id;
                  employeeSalaryPayment.transactionDate = DateTime.parse(_transactionDate2);
                  employeeSalaryPayment.isActive = true;
                  employeeSalaryPayment.isAdvanced = _isAdvanced;
                  employeeSalaryPayment.salaryAmount = _employeeSalary[i].salaryAmount;
                  await dbHelper.employeeSalaryPaymentsInsert(employeeSalaryPayment);
                  await dbHelper.employeeSalaryStatusUpdate(empSalId: _employeeSalary[i].id);
                }
              }
            }
          } else {
            await dbHelper.paymentUpdate(payment);
          }
          hideLoader();
          setState(() {});
          if (returnScreenId == 15) {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DashboardScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          } else {
            Navigator.of(context).pop();
            AccountSearch accountSearch =  AccountSearch();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EmployeeScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      accountSearch: accountSearch,
                      redirectToCustomersTab: true,
                    )));
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${global.appLocaleValues['tle_payment_err_req']}'),
        ));
      }
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _onSave(): ' + e.toString());
      return null;
    }
  }

  // void _onTypeChange(int value) {
  //   try {
  //     if (payment.id == null) {
  //       setState(() {
  //         _selectedType = value;
  //       });
  //       if (_selectedType == 0) {
  //         _paymentType = 'RECEIVED';
  //       } else {
  //         _paymentType = 'GIVEN';
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['tle_payment_err_vld']}')));
  //     }
  //   } catch (e) {
  //     print('Exception - paymentAddScreen.dart - _onTypeChange(): ' + e.toString());
  //     return null;
  //   }
  // }

  Future<Null> _selectDate(BuildContext context) async {
    try {
      // choose dob
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != DateTime(2000)) {
        setState(() {
          //   _date=picked;
          _cTransactionDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
          _transactionDate2 = picked.toString().substring(0, 10);
        });
      }
      FocusScope.of(context).requestFocus(_focusNode);
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _selectDate(): ' + e.toString());
      return null;
    }
  }

  Future _addPaymentMethods() async {
    try {
      if (returnScreenId == 14 || returnScreenId == 15) {
        print(_remainAmount);
        if (_isAdvanced == true) {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return PaymentAddDialog(
                  paymentDetail: (obj) {
                    payment.paymentDetailList.add(obj);
                    _totalAmount += obj.amount;
                  },
                );
              });
        } else {
          if (_remainAmount != 0.0) {
            await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return PaymentAddDialog(
                    remainAmountToPay: _remainAmount,
                    paymentDetail: (obj) {
                      payment.paymentDetailList.add(obj);
                      _totalAmount += obj.amount;
                    },
                  );
                });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${global.appLocaleValues['tle_payment_detail_err_vld']}'),
            ));
          }
        }
      } else {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return PaymentAddDialog(
                paymentDetail: (obj) {
                  payment.paymentDetailList.add(obj);
                  _totalAmount += obj.amount;
                },
              );
            });
      }
      setState(() {});
    } catch (e) {
      print('Exception - paymentAddScreen.dart - _addPaymentMethods(): ' + e.toString());
      return null;
    }
  }
}
