// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/screens/AccountDetailScreen.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentDetailModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailTaxModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnTaxModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';


class PurchaseInvoiceDetailScreen extends BaseRoute {
  final PurchaseInvoice invoice;
  PurchaseInvoiceDetailScreen({@required a, @required o, @required this.invoice}) : super(a: a, o: o, r: 'PurchaseInvoiceDetailScreen');

  @override
  _PurchaseInvoiceDetailScreenState createState() => _PurchaseInvoiceDetailScreenState(this.invoice);
}

class _PurchaseInvoiceDetailScreenState extends BaseRouteState {
  PurchaseInvoice invoice;
  bool _isPrintAction;
  double _byCash = 0;
  double _byCheque = 0;
  double _byCard = 0;
  double _byNetBanking = 0;
  double _byEWallet = 0;
  List<PaymentPurchaseInvoice> _paymentInvoiceList = [];
  List<Payment> _paymentList = [];
  List<PaymentDetail> _paymentDetailList = [];
  double _receivedAmount = 0;
  double _givenAmount = 0;
  bool _isdataLoaded = false;
  List<PurchaseInvoiceReturnDetail> _returnProductList = [];
  List<TaxMaster> _returnProductTaxList = [];
  double _returnProductSubTotal = 0;
  double _returnProductfinalTotal = 0;
  String _returnProductPaymentStatus = '';

  _PurchaseInvoiceDetailScreenState(this.invoice) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${invoice.invoiceNumber}'),
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
                  _isPrintAction = true;
                  global.isAppOperation = true;
                  await br.generatePurchaseInvoiceHtml(context, invoice: invoice, isPrintAction: _isPrintAction, returnProductList: _returnProductList, returnProductPaymentStatus: _returnProductPaymentStatus, returnProductSubTotal: _returnProductSubTotal, returnProductTaxList: _returnProductTaxList, returnProductfinalTotal: _returnProductfinalTotal);
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
                  _isPrintAction = false;
                  global.isAppOperation = true;
                  await br.generatePurchaseInvoiceHtml(context, invoice: invoice, isPrintAction: _isPrintAction, returnProductList: _returnProductList, returnProductPaymentStatus: _returnProductPaymentStatus, returnProductSubTotal: _returnProductSubTotal, returnProductTaxList: _returnProductTaxList, returnProductfinalTotal: _returnProductfinalTotal);
                },
              ),
            ),
          ],
        ),
        body: (_isdataLoaded)
            ? SingleChildScrollView(
                child: Column(
                  children: <Widget>[
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
                                  '${br.generateAccountName(invoice.account)}',
                                  style: Theme.of(context).primaryTextTheme.headline3,
                                ),
                              ],
                            ),
                            onTap: () async {
                              List<Payment> _paymentList = await dbHelper.paymentGetList(accountId: invoice.account.id);
                              double returnPurchaseInvoiceAmount = (_paymentList.length > 0) ? await dbHelper.paymentPurchaseInvoiceReturnGetSumOfAmount(paymentIdList: _paymentList.map((f) => f.id).toList()) : 0;
                              invoice.account.totalPaid -= returnPurchaseInvoiceAmount;
                              invoice.account.totalDue = invoice.account.totalSpent - invoice.account.totalPaid;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AccountDetailScreen(
                                        a: widget.analytics,
                                        o: widget.observer,
                                        account: invoice.account,
                                      )));
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.only(left: 10),
                          title: Text(
                            "${global.appLocaleValues['lbl_purchase_invoice_type']}",
                            style: Theme.of(context).primaryTextTheme.headline1,
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                '${(invoice.invoiceTaxList.length > 0) ? global.appLocaleValues['tle_with_tax'] : global.appLocaleValues['tle_without_tax']}',
                                style: Theme.of(context).primaryTextTheme.headline3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: ListTile(
                                contentPadding: EdgeInsets.only(left: 10),
                                title: Text(
                                  "${global.appLocaleValues['lbl_invoice_date_']}",
                                  style: Theme.of(context).primaryTextTheme.headline1,
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.invoiceDate)}',
                                      style: Theme.of(context).primaryTextTheme.headline3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Card(
                              child: ListTile(
                                contentPadding: EdgeInsets.only(left: 10),
                                title: Text(
                                  "${global.appLocaleValues['lbl_delivery_date_']}",
                                  style: Theme.of(context).primaryTextTheme.headline1,
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.deliveryDate)}',
                                      style: Theme.of(context).primaryTextTheme.headline3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            (invoice.invoiceDetailList.length > 0)
                                ? Row(
                                    children: [
                                      Container(
                                          width: 17,
                                          child: Text(
                                            '#',
                                            style: TextStyle(color: Colors.grey, fontSize: 13),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Text(
                                        '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_both']}',
                                        style: TextStyle(color: Colors.grey, fontSize: 13),
                                      )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                          width: 45,
                                          child: Text(
                                            '${global.appLocaleValues['lbl_quantity']}',
                                            style: TextStyle(color: Colors.grey, fontSize: 13),
                                          )),
                                      (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                          ? SizedBox(
                                              width: 10,
                                            )
                                          : SizedBox(),
                                      (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                          ? Container(
                                              width: 60,
                                              child: Text(
                                                '${global.appLocaleValues['lbl_unit_code_']}',
                                                style: TextStyle(color: Colors.grey, fontSize: 13),
                                              ))
                                          : SizedBox(),
                                      Container(
                                        width: 70,
                                        child: Text(
                                          '${global.appLocaleValues['lbl_unit_price_']}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(color: Colors.grey, fontSize: 13),
                                        ),
                                      ),
                                      Container(
                                        width: 70,
                                        child: Text(
                                          '${global.appLocaleValues['lbl_amount']}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(color: Colors.grey, fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: invoice.invoiceDetailList.length,
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
                                              style: TextStyle(fontSize: 13),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          '${invoice.invoiceDetailList[index].productName}',
                                          style: TextStyle(fontSize: 13),
                                        )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                            width: 45,
                                            child: Text(
                                              '${invoice.invoiceDetailList[index].quantity}',
                                              style: TextStyle(fontSize: 13),
                                              textAlign: TextAlign.center,
                                            )),
                                        (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                            ? SizedBox(
                                                width: 10,
                                              )
                                            : SizedBox(),
                                        (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                            ? Container(
                                                width: 60,
                                                child: Text(
                                                  '${invoice.invoiceDetailList[index].unitCode}',
                                                  style: TextStyle(fontSize: 13),
                                                  textAlign: TextAlign.center,
                                                ))
                                            : SizedBox(),
                                        Container(
                                          width: 70,
                                          child: Text(
                                            '${global.currency.symbol} ${invoice.invoiceDetailList[index].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                        Container(
                                          width: 70,
                                          child: Text(
                                            '${global.currency.symbol} ${invoice.invoiceDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(fontSize: 13),
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${global.appLocaleValues['lbl_sub_total_']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                          Text(
                            ' ${global.currency.symbol} ${invoice.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                            ' ${global.currency.symbol} ${invoice.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                            style: Theme.of(context).primaryTextTheme.overline,
                            textAlign: TextAlign.end,
                          )
                        ],
                      ),
                    ),
                    (invoice.invoiceTaxList != null && invoice.invoiceTaxList.length > 0)
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: invoice.invoiceTaxList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${invoice.invoiceTaxList[index].taxName}', style: Theme.of(context).primaryTextTheme.subtitle2),
                                    Text(
                                      ' ${global.currency.symbol} ${invoice.invoiceTaxList[index].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                            ' ${global.currency.symbol} ${invoice.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                          Text('${global.appLocaleValues['lbl_paid']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                          Text(
                            ' ${global.currency.symbol} ${_receivedAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                          Text((invoice.remainAmount >= 0) ? '${global.appLocaleValues['lbl_due']}' : '${global.appLocaleValues['lbl_credit']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                          Text(
                            (invoice.remainAmount >= 0) ? ' ${global.currency.symbol} ${invoice.remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}' : ' ${global.currency.symbol} ${(invoice.remainAmount * -1).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                          Text('${global.appLocaleValues['lbl_status']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                          Text(
                            ' ${invoice.status}',
                            style: TextStyle(
                                fontSize: 14,
                                color: (invoice.status != 'CANCELLED')
                                    ? (invoice.status == 'PAID')
                                        ? Colors.green
                                        : Colors.red
                                    : Colors.grey,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     top: 5,
                    //   ),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Container(
                    //         width: ((MediaQuery.of(context).size.width / 2) - 25),
                    //         child: Column(
                    //           children: <Widget>[
                    //             Table(
                    //               columnWidths: {
                    //                 0: FixedColumnWidth(70),
                    //               },
                    //               children: [
                    //                 TableRow(children: [
                    //                   TableCell(
                    //                     child: Padding(
                    //                       padding: EdgeInsets.only(top: 5, left: 5),
                    //                       child: Text(
                    //                         ' ${global.appLocaleValues['lbl_paid']}',
                    //                         style: TextStyle(fontSize: 15, color: Colors.grey),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   TableCell(
                    //                     child: Padding(
                    //                       padding: EdgeInsets.only(top: 5),
                    //                       child: Text(' ${global.currency.symbol} ${_receivedAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: TextStyle(fontSize: 15)),
                    //                     ),
                    //                   )
                    //                 ]),
                    //                 TableRow(children: [
                    //                   TableCell(
                    //                     child: Padding(
                    //                       padding: EdgeInsets.only(top: 5, left: 5),
                    //                       child: (invoice.remainAmount >= 0)
                    //                           ? Text(
                    //                               ' ${global.appLocaleValues['lbl_due']}',
                    //                               style: TextStyle(fontSize: 15, color: Colors.grey),
                    //                             )
                    //                           : Text(
                    //                               ' ${global.appLocaleValues['lbl_credit']}',
                    //                               style: TextStyle(fontSize: 15, color: Colors.grey),
                    //                             ),
                    //                     ),
                    //                   ),
                    //                   TableCell(
                    //                     child: Padding(
                    //                       padding: EdgeInsets.only(top: 5),
                    //                       child: (invoice.remainAmount >= 0) ? Text(' ${global.currency.symbol} ${invoice.remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: TextStyle(fontSize: 15)) : Text(' ${global.currency.symbol} ${(invoice.remainAmount * -1).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: TextStyle(fontSize: 15)),
                    //                     ),
                    //                   )
                    //                 ]),
                    //                 TableRow(children: [
                    //                   TableCell(
                    //                     child: Padding(
                    //                       padding: EdgeInsets.only(top: 5, left: 5),
                    //                       child: Text(
                    //                         ' ${global.appLocaleValues['lbl_status']}',
                    //                         style: TextStyle(fontSize: 15, color: Colors.grey),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   TableCell(
                    //                     child: Padding(
                    //                       padding: EdgeInsets.only(top: 5),
                    //                       child: Text(
                    //                         ' ${invoice.status}',
                    //                         style: TextStyle(
                    //                             fontSize: 14,
                    //                             color: (invoice.status != 'CANCELLED')
                    //                                 ? (invoice.status == 'PAID')
                    //                                     ? Colors.green
                    //                                     : Colors.red
                    //                                 : Colors.grey,
                    //                             fontWeight: FontWeight.bold),
                    //                       ),
                    //                     ),
                    //                   )
                    //                 ]),
                    //               ],
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //       Container(height: 100, child: VerticalDivider(color: Colors.grey)),
                    //       Container(
                    //           width: ((MediaQuery.of(context).size.width / 2)),
                    //           //    height: ((MediaQuery.of(context).size.width / 2) - 80),
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: <Widget>[
                    //               Table(
                    //                 columnWidths: {
                    //                   2: FixedColumnWidth(75),
                    //                 },
                    //                 children: [
                    //                   TableRow(children: [
                    //                     TableCell(
                    //                         child: Padding(
                    //                       padding: EdgeInsets.only(left: 5),
                    //                       child: Text(
                    //                         '${global.appLocaleValues['lbl_sub_total_']}',
                    //                         style: TextStyle(fontSize: 15, color: Colors.grey),
                    //                       ),
                    //                     )),
                    //                     TableCell(
                    //                         child: Text(
                    //                       ' ${global.currency.symbol} ${invoice.grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                    //                       style: TextStyle(fontSize: 14),
                    //                       textAlign: TextAlign.end,
                    //                     )),
                    //                   ]),
                    //                   TableRow(children: [
                    //                     TableCell(
                    //                         child: Padding(
                    //                       padding: EdgeInsets.only(left: 5),
                    //                       child: Text(
                    //                         '${global.appLocaleValues['lbl_discount']}',
                    //                         style: TextStyle(fontSize: 15, color: Colors.grey),
                    //                       ),
                    //                     )),
                    //                     TableCell(
                    //                         child: Text(
                    //                       ' ${global.currency.symbol} ${invoice.discount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                    //                       style: TextStyle(fontSize: 14),
                    //                       textAlign: TextAlign.end,
                    //                     )),
                    //                   ]),
                    //                   // TableRow(children: [
                    //                   //   TableCell(
                    //                   //       child: Padding(
                    //                   //     padding: EdgeInsets.only(left: 5),
                    //                   //     child: Text(
                    //                   //       'Tax (18%)',
                    //                   //       style: TextStyle(fontSize: 15),
                    //                   //     ),
                    //                   //   )),
                    //                   //   TableCell(
                    //                   //       child: Text(
                    //                   //     ' ${global.currency.symbol}${invoice.finalTax}',
                    //                   //     style: TextStyle(fontSize: 14),
                    //                   //   )),
                    //                   // ]),
                    //                 ],
                    //               ),
                    //               Table(
                    //                 columnWidths: {
                    //                   0: FixedColumnWidth(80),
                    //                 },
                    //                 children: [
                    //                   TableRow(children: [
                    //                     TableCell(
                    //                         child: Padding(
                    //                       padding: EdgeInsets.only(left: 5),
                    //                       child: Container(
                    //                         child: Text(
                    //                           '${global.appLocaleValues['lbl_total']}',
                    //                           style: TextStyle(fontSize: 15, color: Colors.grey),
                    //                         ),
                    //                       ),
                    //                     )),
                    //                     TableCell(
                    //                         child: Container(
                    //                       child: Text(
                    //                         ' ${global.currency.symbol} ${invoice.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                    //                         style: Theme.of(context).primaryTextTheme.headline3,
                    //                         textAlign: TextAlign.end,
                    //                       ),
                    //                     )),
                    //                   ]),
                    //                 ],
                    //               )
                    //             ],
                    //           )),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Divider(),
                    ),
                    Column(
                      children: <Widget>[
                        (_byCash > 0 || _byCheque > 0 || _byCard > 0 || _byNetBanking > 0 || _byEWallet != 0)
                            ? Card(
                                child: ListTile(
                                    title: Text(
                                      "${global.appLocaleValues['lbl_paid_remark']}",
                                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                    ),
                                    subtitle: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        (_byCash != 0) ? Text('${global.currency.symbol} ${_byCash.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_cash']}. ', style: TextStyle(fontSize: 13)) : SizedBox(),
                                        (_byCheque != 0) ? Text('${global.currency.symbol} ${_byCheque.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_cheque']}. ', style: TextStyle(fontSize: 13)) : SizedBox(),
                                        (_byCard != 0) ? Text('${global.currency.symbol} ${_byCard.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_card']}. ', style: TextStyle(fontSize: 13)) : SizedBox(),
                                        (_byNetBanking != 0) ? Text('${global.currency.symbol} ${_byNetBanking.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_netbanking']}. ', style: TextStyle(fontSize: 13)) : SizedBox(),
                                        (_byEWallet != 0) ? Text('${global.currency.symbol} ${_byEWallet.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_ewallet']}. ', style: TextStyle(fontSize: 13)) : SizedBox(),
                                      ],
                                    )),
                              )
                            : SizedBox()
                        // Text(
                        //   '${global.appLocaleValues['lbl_paid_remark']}',
                        //   style: TextStyle(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.bold),
                        // ),
                        // FittedBox(
                        //   child: Row(
                        //     children: <Widget>[
                        //       Text('- '),
                        //       (_byCash != 0) ? Text('${global.currency.symbol} ${_byCash.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_cash']}. ', style: TextStyle(color: Colors.blueAccent, fontSize: 12)) : SizedBox(),
                        //       (_byCheque != 0) ? Text('${global.currency.symbol} ${_byCheque.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_cheque']}. ', style: TextStyle(color: Colors.blueAccent, fontSize: 12)) : SizedBox(),
                        //       (_byCard != 0) ? Text('${global.currency.symbol} ${_byCard.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_card']}. ', style: TextStyle(color: Colors.blueAccent, fontSize: 12)) : SizedBox(),
                        //       (_byNetBanking != 0) ? Text('${global.currency.symbol} ${_byNetBanking.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_netbanking']}. ', style: TextStyle(color: Colors.blueAccent, fontSize: 12)) : SizedBox(),
                        //       (_byEWallet != 0) ? Text('${global.currency.symbol} ${_byEWallet.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${global.appLocaleValues['txt_by_ewallet']}. ', style: TextStyle(color: Colors.blueAccent, fontSize: 12)) : SizedBox(),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                    (invoice.returnProducts > 0)
                        ? Column(
                            children: <Widget>[
                              Divider(),
                              Text('${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_return_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_return_service'] : global.appLocaleValues['tle_return_both']}'),
                              Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 17,
                                              child: Text(
                                                '#',
                                                style: TextStyle(color: Colors.grey, fontSize: 13),
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Text(
                                            '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_both']}',
                                            style: TextStyle(color: Colors.grey, fontSize: 13),
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              width: 45,
                                              child: Text(
                                                '${global.appLocaleValues['lbl_quantity']}',
                                                style: TextStyle(color: Colors.grey, fontSize: 13),
                                              )),
                                          (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                              ? SizedBox(
                                                  width: 10,
                                                )
                                              : SizedBox(),
                                          (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                              ? Container(
                                                  width: 60,
                                                  child: Text(
                                                    '${global.appLocaleValues['lbl_unit_code_']}',
                                                    style: TextStyle(color: Colors.grey, fontSize: 13),
                                                  ))
                                              : SizedBox(),
                                          Container(
                                            width: 70,
                                            child: Text(
                                              '${global.appLocaleValues['lbl_unit_price_']}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(color: Colors.grey, fontSize: 13),
                                            ),
                                          ),
                                          Container(
                                            width: 70,
                                            child: Text(
                                              '${global.appLocaleValues['lbl_amount']}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(color: Colors.grey, fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: _returnProductList.length,
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
                                                        style: TextStyle(fontSize: 13),
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    '${_returnProductList[index].productName}',
                                                    style: TextStyle(fontSize: 13),
                                                  )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                      width: 45,
                                                      child: Text(
                                                        '${_returnProductList[index].quantity}',
                                                        style: TextStyle(fontSize: 13),
                                                        textAlign: TextAlign.center,
                                                      )),
                                                  (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                      ? SizedBox(
                                                          width: 10,
                                                        )
                                                      : SizedBox(),
                                                  (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                                                      ? Container(
                                                          width: 60,
                                                          child: Text(
                                                            '${_returnProductList[index].unitCode}',
                                                            style: TextStyle(fontSize: 13),
                                                            textAlign: TextAlign.center,
                                                          ))
                                                      : SizedBox(),
                                                  Container(
                                                    width: 70,
                                                    child: Text(
                                                      '${global.currency.symbol} ${_returnProductList[index].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                      textAlign: TextAlign.right,
                                                      style: TextStyle(fontSize: 13),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 70,
                                                    child: Text(
                                                      '${global.currency.symbol} ${_returnProductList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                      textAlign: TextAlign.right,
                                                      style: TextStyle(fontSize: 13),
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
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${global.appLocaleValues['lbl_sub_total_']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                                    Text(
                                      ' ${global.currency.symbol} ${_returnProductSubTotal.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                      style: Theme.of(context).primaryTextTheme.overline,
                                      textAlign: TextAlign.end,
                                    )
                                  ],
                                ),
                              ),
                              _returnProductTaxList != null && _returnProductTaxList.length > 0
                                  ? ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _returnProductTaxList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${_returnProductTaxList[index].taxName}', style: Theme.of(context).primaryTextTheme.subtitle2),
                                              Text(
                                                ' ${global.currency.symbol} ${_returnProductTaxList[index].taxAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                                      ' ${global.currency.symbol} ${_returnProductfinalTotal.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                                    Text('${global.appLocaleValues['lbl_status']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                                    Text(
                                      ' $_returnProductPaymentStatus',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: (_returnProductPaymentStatus != 'CANCELLED')
                                              ? (_returnProductPaymentStatus == 'REFUNDED')
                                                  ? Colors.green
                                                  : Colors.red
                                              : Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ));
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      invoice.invoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(invoiceId: invoice.id);
      invoice.invoiceTaxList = await dbHelper.purchaseInvoiceTaxGetList(invoiceId: invoice.id);
      invoice.invoiceDetailTaxList = await dbHelper.purchaseInvoiceDetailTaxGetList(invoiceDetailIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.id).toList());
      List<Account> _accountList = await dbHelper.accountGetList(accountId: invoice.accountId, accountType: 'Supplier');
      invoice.account = _accountList[0];
      _paymentInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(invoiceId: invoice.id, isCancel: false);
      _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
      _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
      if (_paymentList.length != 0) {
        _paymentList.forEach((item) {
          if (item.paymentType == 'GIVEN') {
            _receivedAmount += item.amount;
            _paymentDetailList.forEach((paymentDetail) {
              if (item.id == paymentDetail.paymentId) {
                if (paymentDetail.paymentMode == 'Cheque') {
                  _byCheque += paymentDetail.amount;
                } else if (paymentDetail.paymentMode == 'Cash') {
                  _byCash += paymentDetail.amount;
                } else if (paymentDetail.paymentMode == 'Card') {
                  _byCard += paymentDetail.amount;
                } else if (paymentDetail.paymentMode == 'EWallet' || paymentDetail.paymentMode == 'eWallet') {
                  _byEWallet += paymentDetail.amount;
                } else {
                  _byNetBanking += paymentDetail.amount;
                }
              }
            });
          } else {
            _givenAmount += item.amount;
          }
        });
        _receivedAmount -= _givenAmount;
      }
      if (invoice.remainAmount == null) {
        invoice.remainAmount = (_paymentList.length != 0) ? (invoice.netAmount - (_receivedAmount - _givenAmount)) : invoice.netAmount;
      }

      if (invoice.returnProducts > 0) {
        _returnProductList = await dbHelper.purchaseInvoiceReturnDetailGetList(purchaseInvoiceId: invoice.id);
        List<PurchaseInvoiceReturnDetailTax> _purchaseInvoiceReturnDetailTaxList = await dbHelper.purchaseInvoiceReturnDetailTaxGetList(purchaseInvoiceReturnDetailIdList: _returnProductList.map((f) => f.id).toList());
        List<PurchaseInvoiceReturn> _purchaseInvoiceReturnList = await dbHelper.purchaseInvoiceReturnGetList(purchaseInvoiceReturnIdList: [_returnProductList[0].purchaseInvoiceReturnId]);
        PurchaseInvoiceReturn _purchaseInvoiceReturn = (_purchaseInvoiceReturnList.length > 0) ? _purchaseInvoiceReturnList[0] : null;
        _returnProductPaymentStatus = _purchaseInvoiceReturn.status;

        if (_purchaseInvoiceReturnDetailTaxList.length > 0) // when purchase return tax is product wise
        {
          _returnProductTaxList = await dbHelper.taxMasterGetList(taxMasterIdList: _purchaseInvoiceReturnDetailTaxList.map((f) => f.taxId).toSet().toList());
          _returnProductTaxList.forEach((f) {
            double _taxAmount = 0;
            _purchaseInvoiceReturnDetailTaxList.forEach((item) {
              if (item.taxId == f.id) {
                _taxAmount += item.taxAmount;
              }
            });
            f.taxAmount = _taxAmount;
          });

          _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
          _returnProductfinalTotal = _returnProductSubTotal + _returnProductTaxList.map((f) => f.taxAmount).reduce((sum, amt) => sum + amt);
        } else // when purchase return tax is tax wise
        {
          List<PurchaseInvoiceReturnTax> _purchaseInvoiceReturnTaxList = await dbHelper.purchaseInvoiceReturnTaxGetList(purchaseInvoiceReturnId: _returnProductList[0].purchaseInvoiceReturnId);

          if (_purchaseInvoiceReturn != null) {
            if (_purchaseInvoiceReturnTaxList.length > 0) {
              _returnProductTaxList = await dbHelper.taxMasterGetList(taxMasterIdList: _purchaseInvoiceReturnTaxList.map((f) => f.taxId).toList());
              _returnProductTaxList.forEach((item) {
                item.taxAmount = (item.percentage * _purchaseInvoiceReturn.grossAmount) / 100;
              });
              _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
              _returnProductfinalTotal = _returnProductSubTotal + _returnProductTaxList.map((f) => f.taxAmount).reduce((sum, amt) => sum + amt);
            } else // when purchase return tax not available
            {
              _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
              _returnProductfinalTotal = _returnProductSubTotal;
            }
          }
        }
      }
      //print(_list.length);
      _isdataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - purchaseInvoiceDetailscreen - _getData(): ' + e.toString());
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
