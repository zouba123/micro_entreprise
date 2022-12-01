// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/models/EmployeeSalaryStructuresModel.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/accountSearchModel.dart';

import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/decimalTextInputFormatter.dart';
import 'package:accounting_app/screens/employeeScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:intl/intl.dart';

class SalarySetUpAddScreen extends BaseRoute {
  final Account account;
  final EmployeeSalaryStructures employeeSalaryStructures;
  final int screenId;
  SalarySetUpAddScreen({@required a, @required o, this.account, this.employeeSalaryStructures, this.screenId}) : super(a: a, o: o, r: 'SalarySetUpAddScreen');
  @override
  _SalarySetUpAddScreenState createState() => _SalarySetUpAddScreenState(this.account, this.employeeSalaryStructures, this.screenId);
}

class _SalarySetUpAddScreenState extends BaseRouteState {
  TextEditingController _csalary = TextEditingController();
  TextEditingController _cstartDate = TextEditingController();
  TextEditingController _cAccountId = TextEditingController();
  TextEditingController _cLeaveCut = TextEditingController();

  final _fAccountId = FocusNode();
  final _fTaxPercentage = FocusNode();
  final _fLeaveCut = FocusNode();

  int screenId;
  final _focusNode = FocusNode();
  final _fstartDate = FocusNode();
  String _startDate;
  String _payType = 'Monthly';
  int _selected;
  Account _account;
  bool _autoValidate = false;

  var _key = GlobalKey<FormState>();
  Account account;
  EmployeeSalaryStructures employeeSalaryStructures;
  _SalarySetUpAddScreenState(this.account, this.employeeSalaryStructures, this.screenId) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: employeeSalaryStructures.id != null ? Text(global.appLocaleValues['lbl_update_salarySetup']) : Text(global.appLocaleValues['lbl_add_salarySetup']),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (screenId == 1) {
                  _assignMent();
                } else {
                  _onSubmit();
                }
              },
              child: Text(global.appLocaleValues['btn_save'], style: TextStyle(color: Colors.white, fontSize: 18)),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            autovalidateMode: (_autoValidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
            key: _key,
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                        ),
                        (screenId != 1)
                            ? Padding(
                                padding: const EdgeInsets.only(left: 0, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(global.appLocaleValues['lbl_choose_emp'], style: Theme.of(context).primaryTextTheme.headline3),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        (screenId != 1)
                            ? Container(
                                padding: EdgeInsets.only(top: 0, bottom: 10),
                                child: Column(children: <Widget>[
                                  (employeeSalaryStructures.id == null || (employeeSalaryStructures.id != null && employeeSalaryStructures.accountId != null))
                                      ? Padding(
                                          padding: EdgeInsets.only(top: 0),
                                          child: TextFormField(
                                            controller: _cAccountId,
                                            focusNode: _fAccountId,
                                            readOnly: true,
                                            textInputAction: TextInputAction.next,
                                            decoration: InputDecoration(
                                              hintText: '${global.appLocaleValues['lbl_choose_emp']}',
                                              // labelText: '${global.appLocaleValues['lbl_choose_emp']}',
                                              border: nativeTheme().inputDecorationTheme.border,
                                              suffixIcon: Icon(
                                                Icons.star,
                                                size: 9,
                                                color: Colors.red,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return global.appLocaleValues['lbl_emp_err_req'];
                                              }
                                              return null;
                                            },
                                            onFieldSubmitted: (v) {
                                              // FocusScope.of(context).requestFocus(_fEventTypeId);
                                            },
                                          ),
                                        )
                                      : SizedBox(),
                                ]))
                            : SizedBox(),
                        // Divider(
                        //   color: Colors.black,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(global.appLocaleValues['lbl_salary_type'], style: Theme.of(context).primaryTextTheme.headline3),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            children: <Widget>[
                              // Text(
                              //   global.appLocaleValues['lbl_salary_type'],
                              //   style: TextStyle(color: Colors.grey, fontSize: 15),
                              // ),
                              RadioListTile(
                                // subtitle: Text(global.appLocaleValues['lbl_monthly']),
                                value: 0,
                                groupValue: _selected,
                                title: Text(global.appLocaleValues['lbl_monthly']),
                                onChanged: (int value) {
                                  setState(() {
                                    _selected = value;
                                  });
                                },
                              ),
                              RadioListTile(
                                // subtitle: Text(global.appLocaleValues['lbl_monthly']),
                                value: 1,
                                groupValue: _selected,
                                title: Text(global.appLocaleValues['lbl_perDay']),
                                onChanged: (int value) {
                                  setState(() {
                                    _selected = value;
                                  });
                                },
                              ),
                              RadioListTile(
                                // subtitle: Text(global.appLocaleValues['lbl_monthly']),
                                value: 2,
                                groupValue: _selected,
                                title: Text(global.appLocaleValues['lbl_weekly']),
                                onChanged: (int value) {
                                  setState(() {
                                    _selected = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                        // RadioListTile(
                        //   title: Text(global.appLocaleValues['lbl_monthly']),
                        //   value: 0,
                        //   groupValue: _grpvalue,
                        //   onChanged: (int value) {
                        //       _onChangeDateButton(value);

                        //     },
                        // ),
                        // RadioListTile(
                        //   title: Text(global.appLocaleValues['lbl_perDay']),
                        //   groupValue: _grpvalue,
                        //   value: _isPerday,
                        //   selected: false,
                        //   onChanged: (bool val) {
                        //     setState(() {
                        //       _grpvalue = val;
                        //       _isMonthly = false;
                        //       _weekly = false;
                        //       print(_grpvalue);
                        //     });
                        //   },
                        // ),
                        // RadioListTile(
                        //   title: Text(global.appLocaleValues['lbl_weekly']),
                        //   groupValue: _grpvalue,
                        //   value: _weekly,
                        //   selected: false,
                        //   onChanged: (bool val) {
                        //     setState(() {
                        //       _grpvalue = val;
                        //        _isMonthly = false;
                        //       _isPerday = false;

                        //       print(_grpvalue);
                        //     });
                        //   },
                        // ),
                        // CheckboxListTile(
                        //   title: Text(global.appLocaleValues['lbl_monthly']),
                        //   value: _isMonthly,
                        //   onChanged: (bool val) {
                        //     setState(() {
                        //       _isMonthly = val;
                        //       print(_isMonthly);
                        //     });
                        //   },
                        // ),
                        // CheckboxListTile(
                        //   title: Text(global.appLocaleValues['lbl_perDay']),
                        //   value: _isPerday,
                        //   onChanged: (bool val) {
                        //     setState(() {
                        //       _isPerday = val;
                        //       print(_isPerday);
                        //     });
                        //   },
                        // ),
                        // Divider(
                        //   color: Colors.black,
                        // ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(global.appLocaleValues['lbl_start_date'], style: Theme.of(context).primaryTextTheme.headline3),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: _cstartDate,
                              focusNode: _fstartDate,
                              readOnly: true,
                              onTap: () async {
                                await _selectCompletionEndDate(context);
                              },
                              decoration: InputDecoration(
                                  // labelText: '${global.appLocaleValues['lbl_start_date']}',
                                  border: nativeTheme().inputDecorationTheme.border,
                                  counterText: '',
                                  prefixIcon: Icon(Icons.calendar_today)),
                              validator: (v) {
                                if (v.isEmpty) {
                                  return global.appLocaleValues['lbl_date_err_req'];
                                }
                                return null;
                              },
                            ),
                          ),
                        ])),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(global.appLocaleValues['lbl_salary'], style: Theme.of(context).primaryTextTheme.headline3),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(),
                      child: TextFormField(
                        controller: _csalary,
                        textInputAction: TextInputAction.next,
                        maxLength: 5,
                        decoration: InputDecoration(
                          border: nativeTheme().inputDecorationTheme.border,
                          counterText: '',
                          hintText: global.appLocaleValues['lbl_salary'],
                          // labelText: global.appLocaleValues['lbl_salary'],
                          suffixIcon: Icon(
                            Icons.star,
                            size: 9,
                            color: Colors.red,
                          ),
                        ),
                        inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        focusNode: _fTaxPercentage,
                        validator: (value) {
                          if (value.isEmpty) {
                            return global.appLocaleValues['lbl_enter_amount'];
                          } else if (value.contains(RegExp('[a-zA-Z]'))) {
                            return global.appLocaleValues['vel_enter_number_only'];
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 0, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(global.appLocaleValues['lbl_leave_cut'], style: Theme.of(context).primaryTextTheme.headline3),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: TextFormField(
                        controller: _cLeaveCut,
                        textInputAction: TextInputAction.next,
                        maxLength: 5,
                        decoration: InputDecoration(
                          border: nativeTheme().inputDecorationTheme.border,
                          counterText: '',
                          hintText: global.appLocaleValues['lbl_leave_cut'],
                          // labelText: global.appLocaleValues['lbl_leave_cut'],
                          suffixIcon: Icon(
                            Icons.star,
                            size: 9,
                            color: Colors.red,
                          ),
                        ),
                        inputFormatters: (br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces) != '0') ? [DecimalTextInputFormatter(decimalRange: int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))] : [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        focusNode: _fLeaveCut,
                        validator: (value) {
                          if (value.isEmpty) {
                            return global.appLocaleValues['lbl_enter_amount'];
                          } else if (value.contains(RegExp('[a-zA-Z]'))) {
                            return global.appLocaleValues['vel_enter_number_only'];
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
            ]),
          ),
        ));
  }

  @override
  void dispose() {
    _fAccountId.removeListener(_accountListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fAccountId.addListener(_accountListener);
    if (account != null) {
      _cAccountId.text = '${account.firstName} ${account.lastName}';
    }
    if (employeeSalaryStructures != null) {
      _fillData();
    } else {
      _selected = 0;
      _cstartDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
      _startDate = DateTime.now().toString().substring(0, 10);
      employeeSalaryStructures = EmployeeSalaryStructures();
    }
  }

  Future _accountListener() async {
    try {
      if (employeeSalaryStructures.id == null && _fAccountId.hasFocus) {
        await Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => AccountSelectDialog(
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

  Future _selectCompletionEndDate(BuildContext context) async {
    try {
      final DateTime picked = await showDatePicker(
        context: context,
        helpText: '${global.appLocaleValues['lbl_date_from']}',
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime(DateTime.now().year + 1),
      );
      if (picked != null && picked != DateTime(2000)) {
        setState(() {
          _cstartDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
          _startDate = picked.toString().substring(0, 10);
        });
        return _startDate;
      }
    } catch (e) {
      print('Exception - eventAddScreen.dart - _selectCompletionEndDate(): ' + e.toString());
    }
  }

  // Future _getOrder() async {
  //   _order = await dbHelper.taxMatserCount();
  // }

  Future _fillData() async // display details during update expense
  {
    try {
      _cAccountId.text = '${employeeSalaryStructures.account.firstName} ${employeeSalaryStructures.account.lastName}';
      _csalary.text = employeeSalaryStructures.salary.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
      _cLeaveCut.text = employeeSalaryStructures.leaveCutAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
      _cstartDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(employeeSalaryStructures.startDate);
      _startDate = employeeSalaryStructures.startDate.toString();
      if (employeeSalaryStructures.salaryType == 'Monthly') {
        _selected = 0;
      } else if (employeeSalaryStructures.salaryType == 'Daily') {
        _selected = 1;
      } else if (employeeSalaryStructures.salaryType == 'Weekly') {
        _selected = 2;
      }
    } catch (e) {
      print('Exception - empstruSetupAdd.dart - _fillData(): ' + e.toString());
    }
  }

  Future _assignMent() async {
    try {
      if (_key.currentState.validate()) {
        if (_selected == 0) {
          _payType = 'Monthly';
        } else if (_selected == 1) {
          _payType = 'Daily';
        } else if (_selected == 2) {
          _payType = 'Weekly';
        }

        employeeSalaryStructures.salaryType = _payType;
        employeeSalaryStructures.salary = double.parse(_csalary.text.trim());
        employeeSalaryStructures.leaveCutAmount = double.parse(_cLeaveCut.text.trim());
        employeeSalaryStructures.startDate = DateTime.parse(_startDate);
        employeeSalaryStructures.isDelete = false;
        employeeSalaryStructures.isActive = true;

        Navigator.of(context).pop(employeeSalaryStructures);
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    } catch (e) {
      print('Exception - TaxAddScreen.dart - _onSubmit(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    try {
      if (_key.currentState.validate()) {
        showLoader(global.appLocaleValues['txt_wait']);
        setState(() {});
        if (_selected == 0) {
          _payType = 'Monthly';
        } else if (_selected == 1) {
          _payType = 'Daily';
        } else if (_selected == 2) {
          _payType = 'Weekly';
        }
        if (employeeSalaryStructures.account != null) {
          employeeSalaryStructures.accountId = employeeSalaryStructures.account.id;
        } else {
          employeeSalaryStructures.accountId = (account != null) ? account.id : _account.id;
        }
        employeeSalaryStructures.salaryType = _payType;
        employeeSalaryStructures.salary = double.parse(_csalary.text.trim());
        employeeSalaryStructures.leaveCutAmount = double.parse(_cLeaveCut.text.trim());
        employeeSalaryStructures.startDate = DateTime.parse(_startDate);
        employeeSalaryStructures.isDelete = false;
        employeeSalaryStructures.isActive = true;

        if (employeeSalaryStructures.id == null) {
          await dbHelper.employeeSalaryStructuresInsert(employeeSalaryStructures);
        } else {
          employeeSalaryStructures.id = null;
          await dbHelper.employeeSalaryStructuresInsert(employeeSalaryStructures);
          // await dbHelper.taxMasterUpdate(taxMaster);
        }
        hideLoader();
        setState(() {});
        if (screenId == 0) {
          AccountSearch accountSearch = AccountSearch();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EmployeeScreen(
                    accountSearch: accountSearch,
                    redirectToCustomersTab: true,
                    a: widget.analytics,
                    o: widget.observer,
                  )));
        } else {
          AccountSearch accountSearch = AccountSearch();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EmployeeScreen(
                    accountSearch: accountSearch,
                    redirectToCustomersTab: true,
                    a: widget.analytics,
                    o: widget.observer,
                  )));
        }
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    } catch (e) {
      print('Exception - TaxAddScreen.dart - _onSubmit(): ' + e.toString());
    }
  }

  // Future _checkNameExist(value) async {
  //   try {
  //     if (taxMaster.id == null) {
  //       _isTaxExist = await dbHelper.taxMasterCheckNameExist(taxName: value);
  //     } else {
  //       _isTaxExist = await dbHelper.taxMasterCheckNameExist(taxName: value, taxId: taxMaster.id);
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     print('Exception - productAddScreen.dart - _cheackNameExist(): ' + e.toString());
  //   }
  // }
}
