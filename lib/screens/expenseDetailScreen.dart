// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/expenseModel.dart';
import 'package:accounting_app/models/paymentModel.dart';

class ExpenseDetailScreen extends BaseRoute {
  final Expense expense;

  ExpenseDetailScreen({a, o, @required this.expense}) : super(a: a, o: o, r: 'ExpenseDetailScreen');
  @override
  ExpenseDetailScreenState createState() => ExpenseDetailScreenState(this.expense);
}

class ExpenseDetailScreenState extends BaseRouteState {
  Expense expense;
  ExpenseDetailScreenState(this.expense) : super();
  double _totalDue = 0;
  double _totalPaid = 0;

  Widget _paymentList() {
    try {
      List<Widget> _widgetList = [];
      if (expense.paymentList.isNotEmpty && expense.paymentList.length > 0) {
        for (int i = 0; i < expense.paymentList.length; i++) {
          if (expense.paymentList[i].paymentDetailList.isNotEmpty) {
            _widgetList.add(Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Card(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                borderOnForeground: true,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Container(
                    padding: EdgeInsets.only(left: 5, top: 5, bottom: 2),
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.8), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                    child: Text(
                      "${expense.paymentList[i].transactionDate != null ? DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(expense.paymentList[i].transactionDate.toString())) : ''}",
                      style: Theme.of(context).primaryTextTheme.headline2,
                    ),
                  ),
                  subtitle: _paymentDetailList(payment: expense.paymentList[i]),
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

  @override
  void initState() {
    super.initState();
    _calculate();
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

  Widget _paymentDetailList({Payment payment}) {
    try {
      List<Widget> _widgetList = [];
      if (payment != null) {
        for (int i = 0; i < payment.paymentDetailList.length; i++) {
          _widgetList.add(Column(
            children: <Widget>[
              SizedBox(
                height: 55,
                child: ListTile(
                    contentPadding: EdgeInsets.only(left: 5, right: 5),
                    title: Text(
                      '${payment.paymentDetailList[i].paymentMode}',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                    subtitle: (payment.paymentDetailList[i].remark != null)
                        ? Text(
                            '${payment.paymentDetailList[i].remark}',
                            style: Theme.of(context).primaryTextTheme.subtitle2,
                            //
                          )
                        : null,
                    trailing: Text(
                      '${global.currency.symbol} ${payment.paymentDetailList[i].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    )),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${global.appLocaleValues['tle_expense_details']}",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                  child: Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 10, right: 5),
                      title: Text(
                        "${global.appLocaleValues['lbl_expense_category']}",
                        style: Theme.of(context).primaryTextTheme.headline1,
                      ),
                      subtitle: Text(
                        expense.expenseCategoryName,
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                    child: Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 10, right: 5),
                        title: Text(
                          "${global.appLocaleValues['lbl_payment_mode']}",
                          style: Theme.of(context).primaryTextTheme.headline1,
                        ),
                        subtitle: Text(
                          expense.paymentMode,
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                    child: Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 10, right: 5),
                        title: Text(
                          "${global.appLocaleValues['lbl_amount']}",
                          style: Theme.of(context).primaryTextTheme.headline1,
                        ),
                        subtitle: Text(
                          '${expense.amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                    child: Card(
                      child: ListTile(
                          contentPadding: EdgeInsets.only(left: 10, right: 5),
                          title: Text(
                            '${global.appLocaleValues['lbl_total_paid']}',
                            style: Theme.of(context).primaryTextTheme.headline1,
                          ),
                          subtitle: Text(
                            '${global.currency.symbol} ${_totalPaid.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                            style: Theme.of(context).primaryTextTheme.headline3,
                          )),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                    child: Card(
                      child: ListTile(
                          contentPadding: EdgeInsets.only(left: 10, right: 5),
                          title: Text(
                            (_totalDue >= 0) ? '${global.appLocaleValues['lbl_net_payable_due']}' : '${global.appLocaleValues['lbl_total_credit']}',
                            style: Theme.of(context).primaryTextTheme.headline1,
                          ),
                          subtitle: Text(
                            (_totalDue >= 0)
                                ? '${global.currency.symbol} ${_totalDue.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}'
                                : ' ${global.currency.symbol} ${(_totalDue * -1).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                            style: Theme.of(context).primaryTextTheme.headline3,
                          )),
                    )),
                expense.billerName != null
                    ? Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                        child: Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.only(left: 10, right: 5),
                            title: Text(
                              "${global.appLocaleValues['tle_biller_name']}",
                              style: Theme.of(context).primaryTextTheme.headline1,
                            ),
                            subtitle: Text(
                              expense.billerName,
                              style: Theme.of(context).primaryTextTheme.headline3,
                            ),
                          ),
                        ))
                    : SizedBox(),
                expense.billNumber != null
                    ? Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                        child: Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.only(left: 10, right: 5),
                            title: Text(
                              "${global.appLocaleValues['tle_bill_number']}",
                              style: Theme.of(context).primaryTextTheme.headline1,
                            ),
                            subtitle: Text(
                              'Bill No.',
                              style: Theme.of(context).primaryTextTheme.headline3,
                            ),
                          ),
                        ))
                    : SizedBox(),
              ],
            ),
            expense.paymentList.isNotEmpty && expense.paymentList.length > 0
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        child: Text(
                          "${global.appLocaleValues['tle_payments']}",
                          style: Theme.of(context).primaryTextTheme.headline1,
                        ),
                      ),
                      _paymentList(),
                    ],
                  )
                : SizedBox()
          ],
        ),
      ),
      //bottomSheet:
      // //  expense.filePath != null
      // //     ?
      //     Padding(
      //         padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 20),
      //         child: TextButton(
      //           onPressed: () {
      //             // global.isAppOperation = true;
      //             // if (expense.filePath.contains('.png')) {
      //             //   OpenFile.open('${expense.filePath}', type: "image/png", uti: "public.png");
      //             // } else if (expense.filePath.contains('.pdf')) {
      //             //   OpenFile.open('${expense.filePath}', type: "application/pdf", uti: "com.adobe.pdf");
      //             // }
      //           },
      //           minWidth: MediaQuery.of(context).size.width,
      //           color: Theme.of(context).primaryColor,
      //           child: Row(
      //             mainAxisSize: MainAxisSize.min,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               // expense.filePath.contains('.png') ?
      //               Icon(Icons.image) ,
      //               // : Icon(Icons.picture_as_pdf),
      //               SizedBox(
      //                 width: 5,
      //               ),
      //               Text(
      //                 '${global.appLocaleValues['btn_view_bill_invoice']}',
      //                 style: Theme.of(context).primaryTextTheme.headline2,
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     // : SizedBox(),
    );
  }
}
