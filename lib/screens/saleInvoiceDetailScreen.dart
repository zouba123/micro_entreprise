// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/paymentSaleOrderModel.dart';
import 'package:accounting_app/models/saleOrderDetailModel.dart';
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/screens/saleOrderDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentDetailModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/paymentSaleQuotesModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnDetailTaxModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnTaxModel.dart';
import 'package:accounting_app/models/saleQuoteDetailModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/screens/AccountDetailScreen.dart';
import 'package:accounting_app/screens/salesQuoteDetailScreen.dart';

class SaleInvoiceDetailScreen extends BaseRoute {
  final SaleInvoice invoice;
  SaleInvoiceDetailScreen({@required a, @required o, @required this.invoice}) : super(a: a, o: o, r: 'SaleInvoiceDetailScreen');

  @override
  _SaleInvoiceDetailScreenState createState() => _SaleInvoiceDetailScreenState(this.invoice);
}

class _SaleInvoiceDetailScreenState extends BaseRouteState {
  SaleInvoice invoice;
  bool _isPrintAction;
  double _byCash = 0;
  double _byCheque = 0;
  double _byCard = 0;
  double _byNetBanking = 0;
  double _byEWallet = 0;
  List<PaymentSaleInvoice> _paymentInvoiceList = [];
  List<Payment> _paymentList = [];
  List<PaymentDetail> _paymentDetailList = [];
  double _receivedAmount = 0;
  double _givenAmount = 0;
  bool _isdataLoaded = false;
  List<SaleInvoiceReturnDetail> _returnProductList = [];
  List<TaxMaster> _returnProductTaxList = [];
  double _returnProductSubTotal = 0;
  double _returnProductfinalTotal = 0;
  String _returnProductPaymentStatus = '';

  _SaleInvoiceDetailScreenState(this.invoice) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + invoice.invoiceNumber.toString().length))}${invoice.invoiceNumber}', style: Theme.of(context).appBarTheme.titleTextStyle),
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
                  await br.generateSaleInvoiceHtml(context, invoice: invoice, isPrintAction: _isPrintAction, returnProductList: _returnProductList, returnProductPaymentStatus: _returnProductPaymentStatus, returnProductTaxList: _returnProductTaxList, returnProductSubTotal: _returnProductSubTotal, returnProductfinalTotal: _returnProductfinalTotal);
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
                  await br.generateSaleInvoiceHtml(context, invoice: invoice, isPrintAction: _isPrintAction, returnProductList: _returnProductList, returnProductPaymentStatus: _returnProductPaymentStatus, returnProductSubTotal: _returnProductSubTotal, returnProductTaxList: _returnProductTaxList, returnProductfinalTotal: _returnProductfinalTotal);
                },
              ),
            ),
          ],
        ),
        body: (_isdataLoaded)
            ? SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                        child: Card(
                          child: ListTile(
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
                                double returnSaleInvoiceAmount = (_paymentList.length > 0) ? await dbHelper.paymentSaleInvoiceReturnGetSumOfAmount(paymentIdList: _paymentList.map((f) => f.id).toList()) : 0;
                                invoice.account.totalPaid -= returnSaleInvoiceAmount;
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
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                        child: Card(
                          child: ListTile(
                              title: Text(
                                "${global.appLocaleValues['lbl_sale_invoice_type']}",
                                style: Theme.of(context).primaryTextTheme.headline1,
                              ),
                              subtitle: Text(
                                '${(invoice.invoiceTaxList.length > 0) ? global.appLocaleValues['tle_with_tax'] : global.appLocaleValues['tle_without_tax']}',
                                style: Theme.of(context).primaryTextTheme.headline3,
                              )),
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
                                      "${global.appLocaleValues['lbl_date']}",
                                      style: Theme.of(context).primaryTextTheme.headline1,
                                    ),
                                    subtitle: Text(
                                      '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.invoiceDate)}',
                                      style: Theme.of(context).primaryTextTheme.headline3,
                                    )),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                child: ListTile(
                                    title: Text(
                                      "${global.appLocaleValues['lbl_delivery_date_']}",
                                      style: Theme.of(context).primaryTextTheme.headline1,
                                    ),
                                    subtitle: Text(
                                      '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.deliveryDate)}  ${DateFormat("HH:mm a").format(invoice.deliveryDate)}',
                                      style: Theme.of(context).primaryTextTheme.headline3,
                                    )),
                              ),
                            ),
                          ],
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
                                      "${global.appLocaleValues['lbl_voucher_no']}",
                                      style: Theme.of(context).primaryTextTheme.headline1,
                                    ),
                                    subtitle: Text(
                                      '${invoice.voucherNumber}',
                                      style: Theme.of(context).primaryTextTheme.headline3,
                                    )),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: ListTile(
                                    contentPadding: EdgeInsets.only(left: 10),
                                    title: Text(
                                      "Show Remark in Print",
                                      style: Theme.of(context).primaryTextTheme.headline1,
                                    ),
                                    subtitle: Text(
                                      '${invoice.showRemarkInPrint ? 'Yes' : 'No'}',
                                      // '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(order.orderDate)}',
                                      style: Theme.of(context).primaryTextTheme.headline3,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                        child: Row(
                          children: [
                            (invoice.salesQuoteNumber != null && invoice.salesQuoteVersion != null)
                                ? Expanded(
                                    child: Card(
                                      margin: EdgeInsets.only(top: 5, bottom: 5),
                                      child: ListTile(
                                          onTap: () async {
                                            List<SaleQuote> _list = await dbHelper.saleQuoteGetList(orderIdList: [invoice.salesQuoteId]);
                                            if (_list != null && _list.length > 0) {
                                              List<SaleQuoteDetail> _saleQuoteDetailList = await dbHelper.saleQuoteDetailGetList(orderIdList: [_list[0].id]);
                                              _list[0].totalProducts = _saleQuoteDetailList.length;
                                              _list[0].quoteDetailList = _saleQuoteDetailList;

                                              List<PaymentSaleQuotes> _paymentSaleQuoteList = await dbHelper.paymentSaleQuoteGetList(orderIdList: [_list[0].id], isCancel: false);
                                              List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentSaleQuoteList.map((paymentOrder) => paymentOrder.paymentId).toList());

                                              double _givenAmount = 0;
                                              if (_paymentList.length != 0) {
                                                _paymentList.forEach((item) {
                                                  if (item.paymentType == 'RECEIVED') {
                                                    _list[0].advanceAmount += item.amount;
                                                  } else {
                                                    _givenAmount += item.amount;
                                                  }
                                                });
                                              }
                                              _list[0].remainAmount = (_paymentList.length != 0) ? (_list[0].netAmount - (_list[0].advanceAmount - _givenAmount)) : _list[0].netAmount;
                                              // _list[0].isEditable = await dbHelper.saleQuoteisUsed(_list[0].id);
                                              // _list[0].isEditable = !_list[0].isEditable;
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => SalesQuoteDetailScreen(
                                                        a: widget.analytics,
                                                        o: widget.observer,
                                                        quote: _list[0],
                                                        screenId: 0,
                                                      )));
                                            }
                                          },
                                          title: Text(
                                            "${global.appLocaleValues['lbl_quoteno']}",
                                            style: Theme.of(context).primaryTextTheme.headline1,
                                          ),
                                          subtitle: Text(
                                            '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + invoice.salesQuoteNumber.toString().length))}${invoice.salesQuoteNumber}-${invoice.salesQuoteVersion}',
                                            style: Theme.of(context).primaryTextTheme.headline3,
                                          )),
                                    ),
                                  )
                                : SizedBox(),
                            (invoice.salesOrderId != null && invoice.salesOrderNumber != null)
                                ? Expanded(
                                    child: Card(
                                      margin: EdgeInsets.only(top: 5, bottom: 5),
                                      child: ListTile(
                                          onTap: () async {
                                            List<SaleOrder> _list = await dbHelper.saleOrderGetList(orderIdList: [invoice.salesOrderId]);
                                            if (_list != null && _list.length > 0) {
                                              List<SaleOrderDetail> _saleOrderDetailList = await dbHelper.saleOrderDetailGetList(orderIdList: [_list[0].id]);
                                              _list[0].totalProducts = _saleOrderDetailList.length;
                                              _list[0].orderDetailList = _saleOrderDetailList;

                                              List<PaymentSaleOrder> _paymentSaleOrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [_list[0].id], isCancel: false);
                                              List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentSaleOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());

                                              double _givenAmount = 0;
                                              if (_paymentList.length != 0) {
                                                _paymentList.forEach((item) {
                                                  if (item.paymentType == 'RECEIVED') {
                                                    _list[0].advanceAmount += item.amount;
                                                  } else {
                                                    _givenAmount += item.amount;
                                                  }
                                                });
                                              }
                                              _list[0].remainAmount = (_paymentList.length != 0) ? (_list[0].grossAmount - (_list[0].advanceAmount - _givenAmount)) : _list[0].grossAmount;
                                              // _list[0].isEditable = await dbHelper.saleQuoteisUsed(_list[0].id);
                                              // _list[0].isEditable = !_list[0].isEditable;
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => SaleOrderDetailScreen(
                                                        a: widget.analytics,
                                                        o: widget.observer,
                                                        order: _list[0],
                                                        screenId: 0,
                                                      )));
                                            }
                                          },
                                          title: Text(
                                            "${global.appLocaleValues['odr']}",
                                            style: Theme.of(context).primaryTextTheme.headline1,
                                          ),
                                          subtitle: Text(
                                            '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + invoice.salesOrderNumber.toString().length))}${invoice.salesOrderNumber}',
                                            style: Theme.of(context).primaryTextTheme.headline3,
                                          )),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                        child: Card(
                          child: ListTile(
                              title: Text(
                                "${global.appLocaleValues['lbl_desc']}",
                                style: Theme.of(context).primaryTextTheme.headline1,
                              ),
                              subtitle: Text(
                                '${invoice.remark}',
                                style: Theme.of(context).primaryTextTheme.headline3,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      //------------------
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   height: MediaQuery.of(context).size.height * 0.07,
                      //   decoration: BoxDecoration(border: Border.all(color: Colors.grey[300])),
                      //   child: Center(
                      //     child: Padding(
                      //       padding: EdgeInsets.only(top: 3),
                      //       child: Text(
                      //         '${global.business.name}',
                      //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   height: MediaQuery.of(context).size.height * 0.07,
                      //   //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                      //   child: Center(
                      //     child: Padding(
                      //       padding: EdgeInsets.only(top: 3),
                      //       child: Text(
                      //         (invoice.invoiceTaxList.length == 0) ? '${global.appLocaleValues['tle_sale_inv']}' : '${global.appLocaleValues['tle_tax_sale_inv']}',
                      //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Theme.of(context).primaryColorLight),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Row(
                      //   children: <Widget>[
                      //     Padding(
                      //         padding: EdgeInsets.only(top: 20, left: 5),
                      //         child: Row(
                      //           children: [
                      //             Text(
                      //               '${global.appLocaleValues['lbl_date']} ',
                      //               style: TextStyle(color: Colors.grey),
                      //             ),
                      //             Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.invoiceDate)}')
                      //           ],
                      //         )),
                      //   ],
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                      //   child: Row(
                      //     children: <Widget>[
                      //       Icon(
                      //         Icons.person,
                      //         size: 15,
                      //       ),
                      //       (_account != null) ? (_account.firstName != null) ? Text(' ${br.generateAccountName(_account)}') : Text('') : Text(''),
                      //       (_account.mobile.isNotEmpty)
                      //           ? Row(
                      //               children: <Widget>[
                      //                 Text(' ('),
                      //                 Icon(
                      //                   Icons.phone,
                      //                   size: 15,
                      //                 ),
                      //                 Text('+${_account.mobileCountryCode} ${_account.mobile} )')
                      //               ],
                      //             )
                      //           : SizedBox(),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
                      //   child: Row(
                      //     children: <Widget>[
                      //       (_account.addressLine1.isNotEmpty && _account.addressLine2.isNotEmpty && _account.city.isNotEmpty && _account.state.isNotEmpty && _account.country.isNotEmpty && _account.pincode != null)
                      //           ? Row(
                      //               children: <Widget>[
                      //                 Icon(
                      //                   Icons.home,
                      //                   size: 15,
                      //                 ),
                      //                 Text(' ${_account.addressLine1}, ${_account.addressLine2}, ${_account.city}, ${_account.state}, ${_account.country}, ${_account.pincode}')
                      //               ],
                      //             )
                      //           : (_account.city.isNotEmpty)
                      //               ? Row(
                      //                   children: <Widget>[
                      //                     Icon(
                      //                       Icons.home,
                      //                       size: 15,
                      //                     ),
                      //                     Text(' ${_account.city}')
                      //                   ],
                      //                 )
                      //               : SizedBox()
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 5, right: 5),
                      //   child: Divider(),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
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
                                    )
                                  : SizedBox(),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
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
                                                style: Theme.of(context).primaryTextTheme.overline,
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Text(
                                            '${invoice.invoiceDetailList[index].productName}',
                                            style: Theme.of(context).primaryTextTheme.overline,
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              width: 45,
                                              child: Text(
                                                '${invoice.invoiceDetailList[index].quantity}',
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
                                                    '${invoice.invoiceDetailList[index].unitCode}',
                                                    style: Theme.of(context).primaryTextTheme.overline,
                                                    textAlign: TextAlign.center,
                                                  ))
                                              : SizedBox(),
                                          Container(
                                            width: 70,
                                            child: Text(
                                              '${global.currency.symbol} ${invoice.invoiceDetailList[index].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                              textAlign: TextAlign.right,
                                              style: Theme.of(context).primaryTextTheme.overline,
                                            ),
                                          ),
                                          Container(
                                            width: 70,
                                            child: Text(
                                              '${global.currency.symbol} ${invoice.invoiceDetailList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
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
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
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

                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: invoice.invoiceTaxList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (invoice.invoiceDetailTaxList.length != 0) ? Text('${invoice.invoiceTaxList[index].taxName}', style: Theme.of(context).primaryTextTheme.subtitle2) : Text('${invoice.invoiceTaxList[index].taxName}(${invoice.invoiceTaxList[index].percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)', style: Theme.of(context).primaryTextTheme.subtitle2),
                                Text(
                                  ' ${global.currency.symbol} ${invoice.invoiceTaxList[index].totalAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                  style: Theme.of(context).primaryTextTheme.overline,
                                  textAlign: TextAlign.end,
                                )
                              ],
                            ),
                          );
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${global.appLocaleValues['lbl_total']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                            Text(
                              ' ${global.currency.symbol} ${invoice.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                              style: Theme.of(context).primaryTextTheme.overline,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(' ${global.appLocaleValues['lbl_paid']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                              Text(
                                '${global.currency.symbol} ${_receivedAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                style: Theme.of(context).primaryTextTheme.overline,
                              ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (invoice.remainAmount >= 0) ? Text(' ${global.appLocaleValues['lbl_due']}', style: Theme.of(context).primaryTextTheme.subtitle2) : Text(' ${global.appLocaleValues['lbl_credit']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                              (invoice.remainAmount >= 0)
                                  ? Text(
                                      '${global.currency.symbol} ${invoice.remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                      style: Theme.of(context).primaryTextTheme.overline,
                                    )
                                  : Text(
                                      '${global.currency.symbol} ${invoice.remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                      style: Theme.of(context).primaryTextTheme.overline,
                                    ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(' ${global.appLocaleValues['lbl_status']}', style: Theme.of(context).primaryTextTheme.subtitle2),
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
                              ),
                            ],
                          )),

                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Divider(),
                      ),
                      (_byCash > 0 || _byCheque > 0 || _byCard > 0 || _byNetBanking > 0 || _byEWallet != 0)
                          ? Padding(
                              padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                              child: Card(
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
                              ),
                            )
                          : SizedBox(),

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
                                            SizedBox(
                                              width: 10,
                                            ),
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
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
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
                                                    SizedBox(
                                                      width: 10,
                                                    ),
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
                                //               // border: TableBorder.all(width: 1),
                                //               children: [
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
                                //                         ' $_returnProductPaymentStatus',
                                //                         style: TextStyle(
                                //                             fontSize: 14,
                                //                             color: (_returnProductPaymentStatus != 'CANCELLED')
                                //                                 ? (_returnProductPaymentStatus == 'REFUNDED')
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
                                //           //  height: ((MediaQuery.of(context).size.width / 2) - 80),
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
                                //                       ' ${global.currency.symbol} ${_returnProductSubTotal.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                //                       style: TextStyle(fontSize: 15),
                                //                       textAlign: TextAlign.end,
                                //                     )),
                                //                   ]),
                                //                 ],
                                //               ),
                                //               ListView.builder(
                                //                 physics: NeverScrollableScrollPhysics(),
                                //                 itemCount: _returnProductTaxList.length,
                                //                 shrinkWrap: true,
                                //                 itemBuilder: (context, index) {
                                //                   return Table(
                                //                     columnWidths: {
                                //                       0: FixedColumnWidth(75),
                                //                     },
                                //                     children: [
                                //                       TableRow(children: [
                                //                         TableCell(
                                //                             child: Padding(
                                //                                 padding: EdgeInsets.only(left: 5),
                                //                                 child: Text(
                                //                                   '${_returnProductTaxList[index].taxName}',
                                //                                   style: TextStyle(fontSize: 15, color: Colors.grey),
                                //                                 ))),
                                //                         TableCell(
                                //                             child: Text(
                                //                           ' ${global.currency.symbol} ${_returnProductTaxList[index].taxAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                //                           style: TextStyle(fontSize: 14),
                                //                           textAlign: TextAlign.end,
                                //                         )),
                                //                       ])
                                //                     ],
                                //                   );
                                //                 },
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
                                //                         ' ${global.currency.symbol} ${_returnProductfinalTotal.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                //                         style: nativeTheme().primaryTextTheme.headline3,
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
                              ],
                            )
                          : SizedBox()
                    ],
                  ),
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
      invoice.invoiceDetailList = await dbHelper.saleInvoiceDetailGetList(invoiceIdList: [invoice.id]);
      invoice.invoiceTaxList = await dbHelper.saleInvoiceTaxGetList(invoiceId: invoice.id);
      invoice.invoiceDetailTaxList = await dbHelper.saleInvoiceDetailTaxGetList(invoiceDetailIdList: invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.id).toList());
      List<Account> _accountList = await dbHelper.accountGetList(accountId: invoice.accountId);
      invoice.account = _accountList[0];
      _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(invoiceId: invoice.id, isCancel: false);
      _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
      _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());

      if (invoice.generateByProductCategory) {
        // generate by product category
        invoice.invoiceDetailList.forEach((items) {
          int _isExistCategory = 0;
          invoice.generateByCategoryList.forEach((f) {
            if (f.productCategoryName == items.productTypeName) {
              _isExistCategory++;
            }
          });
          if (_isExistCategory == 0) {
            GenerateByCategory _generateByProductCategory = GenerateByCategory();
            _generateByProductCategory.productCategoryName = items.productTypeName;
            List<SaleInvoiceDetail> _saleInvoiceDetailList = invoice.invoiceDetailList.where((f) => f.productTypeName == items.productTypeName).toList();
            _generateByProductCategory.quantity = _saleInvoiceDetailList.length;
            _generateByProductCategory.amount = _saleInvoiceDetailList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
            invoice.generateByCategoryList.add(_generateByProductCategory);
          }
        });
      }

      if (_paymentList.length != 0) {
        _paymentList.forEach((item) {
          if (item.paymentType == 'RECEIVED') {
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
        _returnProductList = await dbHelper.saleInvoiceReturnDetailGetList(saleInvoiceIdList: [invoice.id]);
        List<SaleInvoiceReturnDetailTax> _saleInvoiceReturnDetailTaxList = await dbHelper.saleInvoiceReturnDetailTaxGetList(invoiceReturnDetailIdList: _returnProductList.map((f) => f.id).toList());
        List<SaleInvoiceReturn> _saleInvoiceReturnList = await dbHelper.saleInvoiceReturnGetList(invoiceReturnIdList: [_returnProductList[0].saleInvoiceReturnId]);
        SaleInvoiceReturn _saleInvoiceReturn = (_saleInvoiceReturnList.length > 0) ? _saleInvoiceReturnList[0] : null;
        _returnProductPaymentStatus = _saleInvoiceReturn.status;

        if (invoice.generateByProductCategory) {
          // generate return  by product category
          _returnProductList.forEach((items) {
            int _isExistCategory = 0;
            invoice.returnGenerateByCategoryList.forEach((f) {
              if (f.productCategoryName == items.productTypeName) {
                _isExistCategory++;
              }
            });
            if (_isExistCategory == 0) {
              ReturnGenerateByCategory _returnGenerateByProductCategory = ReturnGenerateByCategory();
              _returnGenerateByProductCategory.productCategoryName = items.productTypeName;
              List<SaleInvoiceReturnDetail> _saleInvoiceReturnDetailList = _returnProductList.where((f) => f.productTypeName == items.productTypeName).toList();
              _returnGenerateByProductCategory.quantity = _saleInvoiceReturnDetailList.length;
              _returnGenerateByProductCategory.amount = _saleInvoiceReturnDetailList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
              invoice.returnGenerateByCategoryList.add(_returnGenerateByProductCategory);
            }
          });
        }

        if (_saleInvoiceReturnDetailTaxList.length > 0) // when sales return tax is product wise
        {
          _returnProductTaxList = await dbHelper.taxMasterGetList(taxMasterIdList: _saleInvoiceReturnDetailTaxList.map((f) => f.taxId).toSet().toList());
          _returnProductTaxList.forEach((f) {
            double _taxAmount = 0;
            _saleInvoiceReturnDetailTaxList.forEach((item) {
              if (item.taxId == f.id) {
                _taxAmount += item.taxAmount;
              }
            });
            f.taxAmount = _taxAmount;
          });

          _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
          _returnProductfinalTotal = _returnProductSubTotal + _returnProductTaxList.map((f) => f.taxAmount).reduce((sum, amt) => sum + amt);
        } else // when sales return tax is tax wise
        {
          List<SaleInvoiceReturnTax> _saleInvoiceReturnTaxList = await dbHelper.saleInvoiceReturnTaxGetList(invoiceReturnId: _returnProductList[0].saleInvoiceReturnId);

          if (_saleInvoiceReturn != null) {
            if (_saleInvoiceReturnTaxList.length > 0) {
              _returnProductTaxList = await dbHelper.taxMasterGetList(taxMasterIdList: _saleInvoiceReturnTaxList.map((f) => f.taxId).toList());
              _returnProductTaxList.forEach((item) {
                item.taxAmount = (item.percentage * _saleInvoiceReturn.grossAmount) / 100;
              });
              _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
              _returnProductfinalTotal = _returnProductSubTotal + _returnProductTaxList.map((f) => f.taxAmount).reduce((sum, amt) => sum + amt);
            } else // when sales return tax not available
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
      print('Exception - saleInvoiceDetailscreen - _getData(): ' + e.toString());
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
