// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/expenseModel.dart';
import 'package:accounting_app/screens/expenseDetailScreen.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ShowExpenseListScreen extends BaseRoute {
  final int expenseCategoryId;
  final String billerName;

  final String expenseCategoryName;
  ShowExpenseListScreen({a, o, this.expenseCategoryId, this.expenseCategoryName, this.billerName}) : super(a: a, o: o, r: 'ShowExpenseListScreen');
  @override
  _ShowExpenseListScreenState createState() => _ShowExpenseListScreenState(this.expenseCategoryId, this.expenseCategoryName, this.billerName);
}

class _ShowExpenseListScreenState extends BaseRouteState {
  final int expenseCategoryId;
  final String billerName;
  final String expenseCategoryName;
  _ShowExpenseListScreenState(this.expenseCategoryId, this.expenseCategoryName, this.billerName) : super();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Expense> _expenseList = [];
  bool _isDataLoaded = false;

  bool _isRecordPending = true;
  int _totalRecords = 10;
  int _startIndex = 0;
  ScrollController _scrollController = ScrollController();
  Future _getData() async {
    try {
      if (_isRecordPending) {
        if (_expenseList.length != null && _expenseList.length > 0) {
          _startIndex = _expenseList.length;
        } else {
          _expenseList = [];
        }
        List<Expense> _tExpenseList = await dbHelper.expenseGetList(
          expenseCategoryId: expenseCategoryId != null ? expenseCategoryId : null,
          billerName: billerName != null ? billerName : null,
          isShowExpenseList: expenseCategoryId != null
              ? null
              : billerName != null
                  ? null
                  : true,
        );

        for (int i = 0; i < _tExpenseList.length; i++) {
          _tExpenseList[i].expensePaymentList = await dbHelper.expensePaymentsGetList(expenseId: _tExpenseList[i].id);
          if (_tExpenseList[i].expensePaymentList.isNotEmpty && _tExpenseList[i].expensePaymentList.length > 0) {
            _tExpenseList[i].paymentList = await dbHelper.paymentGetList(paymentIdList: _tExpenseList[i].expensePaymentList.map((e) => e.paymentId).toList());

            if (_tExpenseList[i].paymentList.isNotEmpty && _tExpenseList[i].paymentList.length > 0) {
              for (int j = 0; j < _tExpenseList[i].paymentList.length; j++) {
                _tExpenseList[i].paymentList[j].paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: [_tExpenseList[i].paymentList[j].id]);
              }
            }
          }
        }
        print("Range  $_startIndex - ${_startIndex + _totalRecords} ${_tExpenseList.length}");
        if (_tExpenseList.length == 0) {
          _isRecordPending = false;
        }
        setState(() {
          _expenseList.addAll(_tExpenseList);
        });
      }
      print("_expenseList showExpensePage F${_expenseList.length}");
    } catch (e) {
      print('Exception - ShowExpenseListScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future init() async {
    try {
      await _getData().then((_) {
        _isDataLoaded = true;
        setState(() {});
      });
    } catch (e) {
      print("Exception - ShowExpenseListScreen.dart - init():" + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _expenseListTile() {
    try {
      return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            ListView.builder(
              itemCount: _expenseList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => ExpenseDetailScreen(
                                    expense: _expenseList[index],
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )))
                          .then((value) {
                        _isRecordPending = true;
                        _expenseList.clear();
                        _getData();
                      });
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 5, right: 5),
                      leading: CircleAvatar(
                        backgroundColor: _expenseList[index].color,
                        radius: 25,
                        child: Text('${_expenseList[index].expenseName != null && _expenseList[index].expenseName.isNotEmpty ? _expenseList[index].expenseName[0] : _expenseList[index].expenseCategoryName[0]}', style: Theme.of(context).primaryTextTheme.bodyText2),
                      ),
                      title: Text('${_expenseList[index].expenseName != null && _expenseList[index].expenseName.isNotEmpty ? _expenseList[index].expenseName + ' - ' : ''}${_expenseList[index].expenseCategoryName}', overflow: TextOverflow.ellipsis, style: Theme.of(context).primaryTextTheme.subtitle1),
                      subtitle: Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(_expenseList[index].transactionDate.toString()))}', overflow: TextOverflow.ellipsis, style: Theme.of(context).primaryTextTheme.subtitle2),
                      trailing: Text("${global.currency.symbol} ${NumberFormat.compactCurrency(decimalDigits: 1, symbol: '', locale: 'en_IN').format(_expenseList[index].amount).replaceAll('T', 'K')}", style: Theme.of(context).primaryTextTheme.subtitle1),
                    ),
                  ),
                );
              },
            ),
            !_isRecordPending
                ? SizedBox(
                    height: 70,
                  )
                : SizedBox()
          ],
        ),
      );
    } catch (e) {
      print("Exception - ShowExpenseListScreen.dart - _expenseListTile():" + e.toString());
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          '${expenseCategoryName != null ? expenseCategoryName : billerName != null ? billerName : 'Unknown'}',
          style: Theme.of(context).appBarTheme.titleTextStyle,
          // (
        ),
      ),
      body: (_isDataLoaded)
          ? _expenseList.length > 0
              ? _expenseListTile()
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      MdiIcons.currencyUsd,
                      color: Colors.grey,
                      size: 180,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: Text(
                        '${global.appLocaleValues['tle_expense_empty']}',
                      ),
                    )
                  ],
                ))
          : Center(
              child: showLoader2('${global.appLocaleValues['lbl_loading']}'),
            ),
    );
  }
}
