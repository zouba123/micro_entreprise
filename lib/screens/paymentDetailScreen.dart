// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/screens/AccountDetailScreen.dart';

class PaymentDetailScreen extends BaseRoute {
  final Payment payment;
  PaymentDetailScreen({@required a, @required o, @required this.payment}) : super(a: a, o: o, r: 'PaymentDetailScreen');
  @override
  _PaymentDetailScreenState createState() => _PaymentDetailScreenState(this.payment);
}

class _PaymentDetailScreenState extends BaseRouteState {
  Payment payment;
  bool _isPrintAction = false;
  bool _isDataLoaded = false;

  _PaymentDetailScreenState(this.payment) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            global.appLocaleValues['tle_payment_details'],
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 3),
              child: IconButton(
                tooltip: global.appLocaleValues['tt_payment_print'],
                icon: Icon(
                  Icons.print,
                  size: 25,
                ),
                onPressed: () async {
                  _isPrintAction = true;
                  global.isAppOperation = true;
                  await br.generatePaymentReceiptHtml(context, payment: payment, isPrintAction: _isPrintAction);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 3),
              child: IconButton(
                tooltip: global.appLocaleValues['tt_payment_share'],
                icon: Icon(
                  Icons.share,
                  size: 25,
                ),
                onPressed: () async {
                  global.isAppOperation = true;
                  _isPrintAction = false;
                  await br.generatePaymentReceiptHtml(context, payment: payment, isPrintAction: _isPrintAction);
                },
              ),
            ),
          ],
        ),
        body: (_isDataLoaded)
            ? Column(
                children: [
                  // (payment.accountId != null)
                  //     ?
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                    child: Card(
                      child: ListTile(
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          title: Text("${global.appLocaleValues['lbl_ac_name']}", style: Theme.of(context).primaryTextTheme.headline1),
                          subtitle: Text(
                            payment.account != null ? '${br.generateAccountName(payment.account)}' : 'Unknown',
                            style: Theme.of(context).primaryTextTheme.headline3,
                          ),
                          onTap: () async {
                            List<Payment> _paymentList = await dbHelper.paymentGetList(accountId: payment.account.id);
                            double returnSaleInvoiceAmount = (_paymentList.length > 0)
                                ? (payment.account.accountType.contains('Customer'))
                                    ? await dbHelper.paymentSaleInvoiceReturnGetSumOfAmount(paymentIdList: _paymentList.map((f) => f.id).toList())
                                    : await dbHelper.paymentPurchaseInvoiceReturnGetSumOfAmount(paymentIdList: _paymentList.map((f) => f.id).toList())
                                : 0;
                            payment.account.totalPaid -= returnSaleInvoiceAmount;
                            payment.account.totalDue = payment.account.totalSpent - payment.account.totalPaid;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AccountDetailScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                      account: payment.account,
                                    )));
                          }),
                    ),
                  ),
                  // : SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                    child: Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        title: Text(
                          "${global.appLocaleValues['lbl_total_amount']}",
                          style: Theme.of(context).primaryTextTheme.headline1,
                        ),
                        subtitle: Text(
                          '${global.currency.symbol} ${payment.amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                    child: Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        title: Text(
                          "${global.appLocaleValues['type']}",
                          style: Theme.of(context).primaryTextTheme.headline1,
                        ),
                        subtitle: Text(
                          '${payment.paymentType}',
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                    child: Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        title: Text(
                          "${global.appLocaleValues['lbl_transaction_date_']}",
                          style: Theme.of(context).primaryTextTheme.headline1,
                        ),
                        subtitle: Text(
                          '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(payment.transactionDate)}',
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                    child: Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        title: Text(
                          "${global.appLocaleValues['ref']}",
                          style: Theme.of(context).primaryTextTheme.headline1,
                        ),
                        subtitle: (payment.invoiceNumber != null)
                            ?
                            // Text(global.appLocaleValues['lbl_sale_order_'], style: Theme.of(context).primaryTextTheme.subtitle2,),
                            Text(
                                (payment.isSaleInvoiceRef) ? '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + payment.invoiceNumber.toString().length))}${payment.invoiceNumber}' : '${payment.invoiceNumber}',
                                style: Theme.of(context).primaryTextTheme.headline3,
                              )
                            : (payment.isSaleInvoiceReturnRef)
                                ? Text(
                                    '${global.appLocaleValues['ref_sales_return']}',
                                    style: Theme.of(context).primaryTextTheme.headline3,
                                  )
                                : (payment.isPurchaseInvoiceReturnRef)
                                    ? Text(
                                        '${global.appLocaleValues['ref_purchase_return']}',
                                        style: Theme.of(context).primaryTextTheme.headline3,
                                      )
                                    : (payment.isExpenseRef)
                                        ? Text(
                                            '${global.appLocaleValues['lbl_expense_small']}',
                                            style: Theme.of(context).primaryTextTheme.headline3,
                                          )
                                        : (payment.isSaleOrderRef)
                                            ? Text(
                                                '${global.appLocaleValues['lbl_sale_order_']} ${payment.orderNumber}',
                                                style: Theme.of(context).primaryTextTheme.headline3,
                                              )
                                            : SizedBox(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                    child: Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        title: Text(
                          "${global.appLocaleValues['lbl_payment_methods_']}",
                          style: Theme.of(context).primaryTextTheme.headline1,
                        ),
                        subtitle: payment.paymentDetailList.length != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ListView.builder(
                                  itemCount: payment.paymentDetailList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${payment.paymentDetailList[index].paymentMode}   ${global.currency.symbol} ${payment.paymentDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                          style: Theme.of(context).primaryTextTheme.headline3,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : SizedBox,
                      ),
                    ),
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ));
  }

  Future _getData() async {
    try {
      payment.paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: [payment.id]);
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - paymentDetailScreen.dart - getData(): ' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
