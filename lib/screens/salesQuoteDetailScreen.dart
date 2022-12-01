// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/screens/saleOrderDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/screens/AccountDetailScreen.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/saleInvoiceDetailScreen.dart';

class SalesQuoteDetailScreen extends BaseRoute {
  final SaleQuote quote;
  final int screenId;
  SalesQuoteDetailScreen({@required a, @required o, @required this.quote, this.screenId}) : super(a: a, o: o, r: 'SalesQuoteDetailScreen');

  @override
  _SalesQuoteDetailScreenState createState() => _SalesQuoteDetailScreenState(this.quote, this.screenId);
}

class _SalesQuoteDetailScreenState extends BaseRouteState {
  SaleQuote quote;
  bool _isPrintAction;
  // List<PaymentSaleOrder> _paymentSaleOrderList = [];
  // List<Payment> _paymentList = [];
  // List<PaymentDetail> _paymentDetailList = [];
  // double _receivedAmount = 0;
  // double _givenAmount = 0;
  bool _isdataLoaded = false;
  final int screenId;
  TimeOfDay _timeOfDay;
  String time;

  _SalesQuoteDetailScreenState(this.quote, this.screenId) : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (screenId == null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => DashboardScreen(
                    o: widget.observer,
                    a: widget.analytics,
                  )));
        } else {
          Navigator.of(context).pop();
        }
        return null;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              '${global.appLocaleValues['sal_quot_det']}',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 3),
                child: IconButton(
                  tooltip: global.appLocaleValues['lt_print'],
                  icon: Icon(
                    Icons.print,
                    size: 25,
                  ),
                  onPressed: () async {
                    global.isAppOperation = true;
                    _isPrintAction = true;
                    await br.generateSaleQuoteHtml(
                      context,
                      quote: quote,
                      isPrintAction: _isPrintAction,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 3),
                child: IconButton(
                  tooltip: global.appLocaleValues['lt_share'],
                  icon: Icon(
                    Icons.share,
                    size: 25,
                  ),
                  onPressed: () async {
                    global.isAppOperation = true;
                    _isPrintAction = false;
                    await br.generateSaleQuoteHtml(context, quote: quote, isPrintAction: _isPrintAction);
                  },
                ),
              ),
            ],
          ),
          body: (_isdataLoaded)
              ? SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Card(
                              child: ListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text(
                                    "${global.appLocaleValues['lbl_ac_name']}",
                                    style: Theme.of(context).primaryTextTheme.headline1,
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        '${br.generateAccountName(quote.account)}',
                                        style: Theme.of(context).primaryTextTheme.headline3,
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    // List<Payment> _paymentList = await dbHelper.paymentGetList(accountId: order.account.id);
                                    // double returnSaleInvoiceAmount = (_paymentList.length > 0) ? await dbHelper.paymentSaleInvoiceReturnGetSumOfAmount(paymentIdList: _paymentList.map((f) => f.id).toList()) : 0;
                                    // quote.account.totalPaid -= returnSaleInvoiceAmount;
                                    quote.account.totalDue = quote.account.totalSpent - quote.account.totalPaid;
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => AccountDetailScreen(
                                              a: widget.analytics,
                                              o: widget.observer,
                                              account: quote.account,
                                            )));
                                  }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Card(
                                    child: ListTile(
                                        contentPadding: EdgeInsets.only(left: 10),
                                        title: Text(
                                          "${global.appLocaleValues['sal_quot_no']}",
                                          style: Theme.of(context).primaryTextTheme.headline1,
                                        ),
                                        subtitle: Text(
                                          '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + quote.saleQuoteNumber.toString().length))}${quote.saleQuoteNumber}',
                                          style: Theme.of(context).primaryTextTheme.headline3,
                                        )),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    child: ListTile(
                                        contentPadding: EdgeInsets.only(left: 10),
                                        title: Text(
                                          "${global.appLocaleValues['rev_no']}",
                                          style: Theme.of(context).primaryTextTheme.headline1,
                                        ),
                                        subtitle: Text(
                                          quote.versionNumber.toString(),
                                          style: Theme.of(context).primaryTextTheme.headline3,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Card(
                              child: ListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text(
                                    "${global.appLocaleValues['sal_quot_typ']}",
                                    // ${global.appLocaleValues['lbl_sale_invoice_type']}",
                                    style: Theme.of(context).primaryTextTheme.headline1,
                                  ),
                                  subtitle: Text(
                                    '${(quote.quoteTaxList.length > 0) ? global.appLocaleValues['tle_with_tax'] : global.appLocaleValues['tle_without_tax']}',
                                    style: Theme.of(context).primaryTextTheme.headline3,
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Card(
                              child: ListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text(
                                    "${global.appLocaleValues['lbl_date']}",
                                    style: Theme.of(context).primaryTextTheme.headline1,
                                  ),
                                  subtitle: Text(
                                    '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(quote.orderDate)}',
                                    // '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(order.orderDate)}',
                                    style: Theme.of(context).primaryTextTheme.headline3,
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              children: [
                                (quote.saleInvoiceNumber != null && quote.saleInvoiceId != null)
                                    ? Expanded(
                                        child: Card(
                                          child: ListTile(
                                              onTap: () async {
                                                List<SaleInvoice> _list = await dbHelper.saleInvoiceGetList(invoiceIdList: [quote.saleInvoiceId]);
                                                if (_list != null && _list.length > 0) {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) => SaleInvoiceDetailScreen(
                                                            a: widget.analytics,
                                                            o: widget.observer,
                                                            invoice: _list[0],
                                                          )));
                                                }
                                              },
                                              contentPadding: EdgeInsets.only(left: 10),
                                              title: Text(
                                                "${global.appLocaleValues['lbl_invoiceno']}",
                                                style: Theme.of(context).primaryTextTheme.headline1,
                                              ),
                                              subtitle: Text(
                                                '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + quote.saleQuoteNumber.toString().length))}${quote.saleQuoteNumber}',
                                                style: Theme.of(context).primaryTextTheme.headline3,
                                              )),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              children: [
                                (quote.saleOrderNumber != null && quote.saleOrderId != null)
                                    ? Expanded(
                                        child: Card(
                                          child: ListTile(
                                              onTap: () async {
                                                List<SaleOrder> _list = await dbHelper.saleOrderGetList(orderIdList: [quote.saleOrderId]);
                                                if (_list != null && _list.length > 0) {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) => SaleOrderDetailScreen(
                                                            a: widget.analytics,
                                                            o: widget.observer,
                                                            order: _list[0],
                                                          )));
                                                }
                                              },
                                              contentPadding: EdgeInsets.only(left: 10),
                                              title: Text(
                                                "${global.appLocaleValues['odr_no']}",
                                                style: Theme.of(context).primaryTextTheme.headline1,
                                              ),
                                              subtitle: Text(
                                                '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + quote.saleOrderNumber.toString().length))}${quote.saleOrderNumber}',
                                                style: Theme.of(context).primaryTextTheme.headline3,
                                              )),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Card(
                              child: ListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text(
                                    "${global.appLocaleValues['show_rema_prn']}",
                                    style: Theme.of(context).primaryTextTheme.headline1,
                                  ),
                                  subtitle: Text(
                                    '${quote.showRemarkInPrint ? 'Yes' : 'No'}',
                                    // '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(order.orderDate)}',
                                    style: Theme.of(context).primaryTextTheme.headline3,
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Card(
                              child: ListTile(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  title: Text(
                                    "${global.appLocaleValues['lbl_note_remark']}",
                                    style: Theme.of(context).primaryTextTheme.headline1,
                                  ),
                                  subtitle: Text(
                                    '${quote.remark}',
                                    // '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(order.orderDate)}',
                                    style: Theme.of(context).primaryTextTheme.headline3,
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                      quote.quoteDetailList.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(left: 9, right: 9, top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: 17,
                                          child: Text(
                                            '#',
                                            style: Theme.of(context).primaryTextTheme.button,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Text(
                                        '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_both']}',
                                        style: Theme.of(context).primaryTextTheme.button,
                                      )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                          width: 45,
                                          child: Text(
                                            '${global.appLocaleValues['lbl_quantity']}',
                                            style: Theme.of(context).primaryTextTheme.button,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                          ? Container(
                                              width: 60,
                                              child: Text(
                                                '${global.appLocaleValues['lbl_unit_code_']}',
                                                style: Theme.of(context).primaryTextTheme.button,
                                              ))
                                          : SizedBox(),
                                      Container(
                                        width: 70,
                                        child: Text(
                                          '${global.appLocaleValues['lbl_unit_price_']}',
                                          textAlign: TextAlign.right,
                                          style: Theme.of(context).primaryTextTheme.button,
                                        ),
                                      ),
                                      Container(
                                        width: 70,
                                        child: Text(
                                          '${global.appLocaleValues['lbl_amount']}',
                                          textAlign: TextAlign.right,
                                          style: Theme.of(context).primaryTextTheme.button,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: quote.quoteDetailList.length, // order.quoteDetailList.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          (index == 0) ? Divider() : SizedBox(),
                                          Row(
                                            children: [
                                              Container(
                                                  width: 17,
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: Theme.of(context).primaryTextTheme.overline,
                                                  )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                '${quote.quoteDetailList[index].productName}',
                                                style: Theme.of(context).primaryTextTheme.overline,
                                              )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                  width: 45,
                                                  child: Text(
                                                    '${quote.quoteDetailList[index].quantity}',
                                                    style: Theme.of(context).primaryTextTheme.overline,
                                                    textAlign: TextAlign.center,
                                                  )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                  ? Container(
                                                      width: 60,
                                                      child: Text(
                                                        '${quote.quoteDetailList[index].unitCode}',
                                                        style: Theme.of(context).primaryTextTheme.overline,
                                                        textAlign: TextAlign.center,
                                                      ))
                                                  : SizedBox(),
                                              Container(
                                                width: 70,
                                                child: Text(
                                                  '${global.currency.symbol} ${quote.quoteDetailList[index].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                  textAlign: TextAlign.right,
                                                  style: Theme.of(context).primaryTextTheme.overline,
                                                ),
                                              ),
                                              Container(
                                                width: 70,
                                                child: Text(
                                                  '${global.currency.symbol} ${quote.quoteDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                  textAlign: TextAlign.right,
                                                  style: Theme.of(context).primaryTextTheme.overline,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider()
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),

                      Padding(
                        padding: const EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${global.appLocaleValues['lbl_sub_total_']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                            Text(
                              ' ${global.currency.symbol} ${quote.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                              style: Theme.of(context).primaryTextTheme.overline,
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${global.appLocaleValues['lbl_discount']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                            Text(
                              ' ${global.currency.symbol} ${quote.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                              style: Theme.of(context).primaryTextTheme.overline,
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
                      ),

                      (quote.finalTax != null && quote.finalTax > 0)
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: quote.quoteTaxList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      (quote.quoteDetailTaxList.length != 0) ? Text('${quote.quoteTaxList[index].taxName}', style: Theme.of(context).primaryTextTheme.subtitle2) : Text('${quote.quoteTaxList[index].taxName}(${quote.quoteTaxList[index].percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)', style: Theme.of(context).primaryTextTheme.subtitle2),
                                      Text(
                                        ' ${global.currency.symbol} ${quote.quoteTaxList[index].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                        style: Theme.of(context).primaryTextTheme.overline,
                                        textAlign: TextAlign.end,
                                      )
                                    ],
                                  ),
                                );
                              },
                            )
                          : SizedBox(),

                      Padding(
                        padding: const EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${global.appLocaleValues['lbl_total']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                            Text(
                              ' ${global.currency.symbol} ${quote.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                              style: Theme.of(context).primaryTextTheme.overline,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(' ${global.appLocaleValues['lbl_paid']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                              Text(
                                '${global.currency.symbol} ${quote.advanceAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                style: Theme.of(context).primaryTextTheme.overline,
                              ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (quote.remainAmount >= 0) ? Text(' ${global.appLocaleValues['lbl_due']}', style: Theme.of(context).primaryTextTheme.subtitle2) : Text(' ${global.appLocaleValues['lbl_credit']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                              (quote.remainAmount >= 0)
                                  ? Text(
                                      '${global.currency.symbol} ${quote.remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                      style: Theme.of(context).primaryTextTheme.overline,
                                    )
                                  : Text(
                                      '${global.currency.symbol} ${quote.remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                      style: Theme.of(context).primaryTextTheme.overline,
                                    ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(' ${global.appLocaleValues['lbl_status']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                              Text(' ${quote.status}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: (quote.status != 'CANCELLED')
                                          ? (quote.status == 'INVOICED')
                                              ? Colors.green
                                              : Colors.red
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )),

                      // Column(
                      //   children: <Widget>[
                      //     Divider(),
                      //     (order.paymentByCash > 0 || order.paymentByCheque > 0 || order.paymentByCard > 0 || order.paymentByNetBanking > 0 || order.paymentByEWallet != 0)
                      //         ?
                      //     ListTile(
                      //       contentPadding: EdgeInsets.only(left: 10,right: 10),
                      //         title: Text(
                      //           "${global.appLocaleValues['lbl_paid_remark']}",
                      //           style: Theme.of(context).primaryTextTheme.headline1,
                      //         ),
                      //         subtitle: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: <Widget>[
                      //           order.paymentByCash != 0 ?  Text(global.appLocaleValues['txt_by_cash'], style: TextStyle(fontSize: 13)) : SizedBox(),
                      //           order.paymentByCard != 0 ?  Text(global.appLocaleValues['txt_by_card'], style: TextStyle(fontSize: 13)) : SizedBox(),
                      //            order.paymentByCheque != 0 ? Text(global.appLocaleValues['txt_by_cheque'], style: TextStyle(fontSize: 13)): SizedBox(),
                      //            order.paymentByNetBanking != 0 ? Text(global.appLocaleValues['txt_by_netbanking'], style: TextStyle(fontSize: 13)) : SizedBox(),
                      //            order.paymentByEWallet != 0 ? Text(global.appLocaleValues['txt_by_ewallet'], style: TextStyle(fontSize: 13)) : SizedBox(),

                      //             (order.paymentByCash != 0) ? Text('${global.currency.symbol} ${order.paymentByCash.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_cash']}. ', style: TextStyle(fontSize: 13)) : SizedBox(),
                      //             (order.paymentByCheque != 0) ? Text('${global.currency.symbol} ${order.paymentByCheque.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_cheque']}. ', style: TextStyle(fontSize: 13)) : SizedBox(),
                      //             (order.paymentByCard != 0) ? Text('${global.currency.symbol} ${order.paymentByCard.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_card']}. ', style: TextStyle(fontSize: 13)) : SizedBox(),
                      //             (order.paymentByNetBanking != 0) ? Text('${global.currency.symbol} ${order.paymentByNetBanking.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_netbanking']}. ', style: TextStyle(fontSize: 13)) : SizedBox(),
                      //             (order.paymentByEWallet != 0) ? Text('${global.currency.symbol} ${order.paymentByEWallet.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_ewallet']}. ', style: TextStyle(fontSize: 13)) : SizedBox(),
                      //           ],
                      //         ))
                      //      : SizedBox(),
                      //     Text(
                      //       '${global.appLocaleValues['lbl_paid_remark']}',
                      //       style: TextStyle(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.bold),
                      //     ),
                      //     FittedBox(
                      //       child: Row(
                      //         children: <Widget>[
                      //           Text('- '),
                      //           (order.paymentByCash != 0) ? Text('${global.currency.symbol} ${order.paymentByCash.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_cash']}. ', style: TextStyle(color: Colors.blueAccent, fontSize: 12)) : SizedBox(),
                      //           (order.paymentByCheque != 0) ? Text('${global.currency.symbol} ${order.paymentByCheque.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_cheque']}. ', style: TextStyle(color: Colors.blueAccent, fontSize: 12)) : SizedBox(),
                      //           (order.paymentByCard != 0) ? Text('${global.currency.symbol} ${order.paymentByCard.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_card']}. ', style: TextStyle(color: Colors.blueAccent, fontSize: 12)) : SizedBox(),
                      //           (order.paymentByNetBanking != 0) ? Text('${global.currency.symbol} ${order.paymentByNetBanking.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_netbanking']}. ', style: TextStyle(color: Colors.blueAccent, fontSize: 12)) : SizedBox(),
                      //           (order.paymentByEWallet != 0) ? Text('${global.currency.symbol} ${order.paymentByEWallet.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_ewallet']}. ', style: TextStyle(color: Colors.blueAccent, fontSize: 12)) : SizedBox(),
                      //         ],
                      //       ),
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                )),
    );
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      _timeOfDay = TimeOfDay(hour: quote.deliveryDate.hour, minute: quote.deliveryDate.minute);
      time = br.formatTimeOfDay(_timeOfDay);
      // order.paymentByCard = 0;
      // order.paymentByCash = 0;
      // order.paymentByNetBanking = 0;
      // order.paymentByCheque = 0;
      // order.paymentByEWallet = 0;
      quote.quoteDetailList = await dbHelper.saleQuoteDetailGetList(orderIdList: [quote.id]);
      quote.quoteTaxList = await dbHelper.saleQuoteTaxGetList(saleQuoteId: quote.id);
      quote.quoteDetailTaxList = await dbHelper.saleQuoteDetailTaxGetList(quoteDetailIdList: quote.quoteDetailList.map((orderDetail) => orderDetail.id).toList());
      List<Account> _accountList = await dbHelper.accountGetList(accountId: quote.accountId);
      quote.account = _accountList[0];
      // _paymentSaleOrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [order.id], isCancel: false);
      // _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentSaleOrderList.map((paymentorder) => paymentorder.paymentId).toList());
      // _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleOrderList.map((paymentorder) => paymentorder.paymentId).toList());

      // if (_paymentList.length != 0) {
      //   _paymentList.forEach((item) {
      //     if (item.paymentType == 'RECEIVED') {
      //       _receivedAmount += item.amount;
      //       _paymentDetailList.forEach((paymentDetail) {
      //         if (item.id == paymentDetail.paymentId) {
      //           if (paymentDetail.paymentMode == 'Cheque') {
      //             order.paymentByCheque += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'Cash') {
      //             order.paymentByCash += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'Card') {
      //             order.paymentByCard += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'EWallet' || paymentDetail.paymentMode == 'eWallet') {
      //             order.paymentByEWallet += paymentDetail.amount;
      //           } else {
      //             order.paymentByNetBanking += paymentDetail.amount;
      //           }
      //         }
      //       });
      //     } else {
      //       _givenAmount += item.amount;
      //     }
      //   });
      //   _receivedAmount -= _givenAmount;
      // }
      // if (quote.remainAmount == null) {
      //   quote.remainAmount = (_paymentList.length != 0) ? (order.netAmount - (_receivedAmount - _givenAmount)) : order.netAmount;
      // }
      quote.remainAmount = 0;
      _isdataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - SalesQuoteDetailScreen - _getData(): ' + e.toString());
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
