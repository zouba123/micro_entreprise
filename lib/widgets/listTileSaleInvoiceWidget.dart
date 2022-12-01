// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentSaleOrderModel.dart';
import 'package:accounting_app/models/paymentSaleQuotesModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleOrderDetailModel.dart';
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/models/saleQuoteDetailModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/screens/paymentAddScreen.dart';
import 'package:accounting_app/screens/saleInvoiceAddScreen.dart';
import 'package:accounting_app/screens/saleInvoiceDetailScreen.dart';
import 'package:accounting_app/screens/InvoicePreviewScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/screens/salesQuoteDetailScreen.dart';

import '../screens/saleOrderDetailScreen.dart';

class ListTileSaleInvoiceWidget extends Base {
  final SaleInvoice saleInvoice;
  final Account account;
  final onDeletePressed;
  final invoicePrintOrShare;
  final invoiceCancelOrRetrive;
  ListTileSaleInvoiceWidget({@required Key key, @required this.saleInvoice, @required a, @required o, this.account, this.onDeletePressed, this.invoicePrintOrShare, this.invoiceCancelOrRetrive}) : super(key: key, analytics: a, observer: o);
  @override
  _ListTileSaleInvoiceWidgetState createState() => _ListTileSaleInvoiceWidgetState(this.saleInvoice, this.onDeletePressed, this.invoicePrintOrShare, this.invoiceCancelOrRetrive, this.account);
}

class _ListTileSaleInvoiceWidgetState extends BaseState {
  SaleInvoice saleInvoice;

  final onDeletePressed;
  final invoicePrintOrShare;
  final Account account;
//  var _formKey = GlobalKey<FormState>();
//  TextEditingController _cMsg =  TextEditingController();
  bool _actionOfCancelInvoice;
  bool _isPrintAction;
  final invoiceCancelOrRetrive;

  _ListTileSaleInvoiceWidgetState(this.saleInvoice, this.onDeletePressed, this.invoicePrintOrShare, this.invoiceCancelOrRetrive, this.account);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
      title: Text(
        '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + saleInvoice.invoiceNumber.toString().length))}${saleInvoice.invoiceNumber} - ${br.generateAccountName(saleInvoice.account)}',
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).primaryTextTheme.subtitle1,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              (saleInvoice.salesQuoteNumber != null && saleInvoice.salesQuoteVersion != null)
                  ? InkWell(
                      onTap: () async {
                        List<SaleQuote> _list = await dbHelper.saleQuoteGetList(orderIdList: [saleInvoice.salesQuoteId]);
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
                          _list[0].remainAmount = (_paymentList.length != 0) ? (_list[0].grossAmount - (_list[0].advanceAmount - _givenAmount)) : _list[0].grossAmount;
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
                      child: Text('${global.appLocaleValues['lbl_quoteno']}: ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + saleInvoice.salesQuoteNumber.toString().length))}${saleInvoice.salesQuoteNumber}-${saleInvoice.salesQuoteVersion}'))
                  : SizedBox()
            ],
          ),
          Row(
            children: <Widget>[
              (saleInvoice.salesOrderId != null && saleInvoice.salesOrderNumber != null)
                  ? InkWell(
                      onTap: () async {
                        List<SaleOrder> _list = await dbHelper.saleOrderGetList(orderIdList: [saleInvoice.salesOrderId]);
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
                      child: Text('${global.appLocaleValues['tle_sale_order_no']}: ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + saleInvoice.salesOrderNumber.toString().length))}${saleInvoice.salesOrderNumber}'))
                  : SizedBox()
            ],
          ),
          Text(
            '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(saleInvoice.invoiceDate)}  ${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_item']}: ${saleInvoice.totalProducts}',
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).primaryTextTheme.subtitle2,
          ),
          Row(
            children: <Widget>[
              (saleInvoice.remainAmount != null)
                  ? (saleInvoice.remainAmount < 0)
                      ? Row(
                          children: <Widget>[
                            Text('${global.appLocaleValues['lbl_credit']}: ${global.currency.symbol} ${(saleInvoice.remainAmount * -1).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: TextStyle(color: Colors.green)),
                            (saleInvoice.returnProducts > 0)
                                ? Text(
                                    '  ${global.appLocaleValues['lbl_r']}.${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_item']}: ${saleInvoice.returnProducts}',
                                    style: TextStyle(color: Colors.red))
                                : SizedBox()
                          ],
                        )
                      : Row(
                          children: <Widget>[
                            Text(
                              '${global.appLocaleValues['lbl_due']}: ${global.currency.symbol} ${saleInvoice.remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                              style: TextStyle(color: Colors.red),
                            ),
                            (saleInvoice.returnProducts > 0)
                                ? Text(
                                    '  ${global.appLocaleValues['lbl_r']}.${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_item']}: ${saleInvoice.returnProducts}',
                                    style: TextStyle(color: Colors.red, fontSize: 12))
                                : SizedBox()
                          ],
                        )
                  : SizedBox()
            ],
          )
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * .25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${global.currency.symbol} ${saleInvoice.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Center(
                    child: (saleInvoice.status != 'CANCELLED')
                        ? (saleInvoice.status == 'PAID')
                            ? Text(
                                '${saleInvoice.status}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, height: 0.9),
                              )
                            : Text(
                                '${saleInvoice.status}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, height: 0.9),
                              )
                        : Text(
                            '${saleInvoice.status}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, height: 0.9),
                          ))
              ],
            ),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryColor,
            ),
            itemBuilder: (context) => [
              (saleInvoice.status != 'CANCELLED')
                  ? PopupMenuItem(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(global.appLocaleValues['lbl_edit']),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SaleInvoiceAddSreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    invoice: saleInvoice,
                                  )));
                        },
                      ),
                    )
                  : null,
            (onDeletePressed != null) ?  PopupMenuItem(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.delete,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(global.appLocaleValues['lbl_delete']),
                    ],
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await onDeletePressed(saleInvoice);
                  },
                ),
              ) : null,
              (saleInvoice.status == 'DUE')
                  ? PopupMenuItem(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.payment,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(global.appLocaleValues['lt_take_payment']),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PaymentAddScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    saleInvoice: saleInvoice,
                                    returnScreenId: 1,
                                    account: account,
                                  )));
                        },
                      ),
                    )
                  : null,
              (saleInvoice.status != 'CANCELLED' && saleInvoice.remainAmount < 0)
                  ? PopupMenuItem(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.payment,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(global.appLocaleValues['lt_give_payment']),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PaymentAddScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    saleInvoice: saleInvoice,
                                    returnScreenId: 2,
                                    account: account,
                                  )));
                        },
                      ),
                    )
                  : null,
             (invoicePrintOrShare != null) ? PopupMenuItem(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.print,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(global.appLocaleValues['lt_print']),
                    ],
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    _isPrintAction = true;
                    //_showLoader();
                    await invoicePrintOrShare(saleInvoice, _isPrintAction, context);
                    //   _invoicePrintOrShare(index, context);
                  },
                ),
              ) : null,
             (invoicePrintOrShare != null) ? PopupMenuItem(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.share,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(global.appLocaleValues['lt_share']),
                    ],
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    _isPrintAction = false;
                    //    _showLoader();
                    await invoicePrintOrShare(saleInvoice, _isPrintAction, context);
                    // _invoicePrintOrShare(index, context);
                  },
                ),
              ) : null,
              PopupMenuItem(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.visibility,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(global.appLocaleValues['tle_preview']),
                    ],
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    //   _showLoader();
                    var htmlContent = await invoicePrintOrShare(saleInvoice, null, context);
                    //  OpenFile.open(_path);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InvoicePreviewScreen(
                              a: widget.analytics,
                              o: widget.observer,
                              htmlContent: htmlContent,
                            )));
                  },
                ),
              ),
              (saleInvoice.status != 'CANCELLED' && invoiceCancelOrRetrive != null)
                  ? PopupMenuItem(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.cancel,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(global.appLocaleValues['txt_cancel']),
                          ],
                        ),
                        onTap: () async {
                          _actionOfCancelInvoice = true;
                          Navigator.of(context).pop();
                          await invoiceCancelOrRetrive(saleInvoice, _actionOfCancelInvoice, context);
                          //  _cancelOrRetriveInvoice(index);
                        },
                      ),
                    )
                  : null,
              (saleInvoice.status == 'CANCELLED' && invoiceCancelOrRetrive != null && (DateTime.now().difference(saleInvoice.modifiedAt).inDays) == 0)
                  ? PopupMenuItem(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.undo,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(global.appLocaleValues['lbl_retrive']),
                          ],
                        ),
                        onTap: () async {
                          _actionOfCancelInvoice = false;
                          await invoiceCancelOrRetrive(saleInvoice, _actionOfCancelInvoice, context);
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                      ),
                    )
                  : null,
            ],
          )
        ],
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SaleInvoiceDetailScreen(
                  a: widget.analytics,
                  o: widget.observer,
                  invoice: saleInvoice,
                )));
      },
    );
  }
}
