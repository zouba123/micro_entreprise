// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/paymentSaleQuotesModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleQuoteDetailModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/screens/saleInvoiceDetailScreen.dart';
import 'package:accounting_app/screens/salesQuoteDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/screens/InvoicePreviewScreen.dart';
import 'package:accounting_app/screens/saleOrderAddScreen.dart';
import 'package:accounting_app/screens/saleOrderDetailScreen.dart';

class ListTileSaleOrderWidget extends Base {
  final SaleOrder saleOrder;
  final Account account;

  final onGenerateInvoicePressed;
  final onDeletePressed;
  final orderPrintOrShare;
  final orderCancelOrRetrive;
  ListTileSaleOrderWidget({@required Key key, @required this.saleOrder, @required a, @required o, this.account, this.onDeletePressed, this.orderPrintOrShare, this.onGenerateInvoicePressed, this.orderCancelOrRetrive}) : super(key: key, analytics: a, observer: o);
  @override
  _ListTileSaleOrderWidgetState createState() => _ListTileSaleOrderWidgetState(this.saleOrder, this.onDeletePressed, this.onGenerateInvoicePressed, this.orderPrintOrShare, this.orderCancelOrRetrive, this.account);
}

class _ListTileSaleOrderWidgetState extends BaseState {
  SaleOrder saleOrder;

  final onDeletePressed;
  final onGenerateInvoicePressed;
  final orderPrintOrShare;
  final Account account;
  bool _actionOfCancelOrder;
  bool _isPrintAction;
  final orderCancelOrRetrive;

  _ListTileSaleOrderWidgetState(this.saleOrder, this.onDeletePressed, this.onGenerateInvoicePressed, this.orderPrintOrShare, this.orderCancelOrRetrive, this.account);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
      title: Text(
        '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + saleOrder.saleOrderNumber.toString().length))}${saleOrder.saleOrderNumber} - ${br.generateAccountName(saleOrder.account)}',
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).primaryTextTheme.subtitle1,
      ),
      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              (saleOrder.salesQuoteNumber != null && saleOrder.salesQuoteVersion != null)
                  ? InkWell(
                      onTap: () async {
                        List<SaleQuote> _list = await dbHelper.saleQuoteGetList(orderIdList: [saleOrder.salesQuoteId]);
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
                      child: Text('${global.appLocaleValues['lbl_quoteno']}: ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + saleOrder.salesQuoteNumber.toString().length))}${saleOrder.salesQuoteNumber}-${saleOrder.salesQuoteVersion}'))
                  : SizedBox()
            ],
          ),
          Row(
            children: <Widget>[
              (saleOrder.salesInvoiceId != null && saleOrder.salesInvoiceNumber != null)
                  ? InkWell(
                      onTap: () async {
                        List<SaleInvoice> _list = await dbHelper.saleInvoiceGetList(invoiceIdList: [saleOrder.salesInvoiceId]);
                        if (_list != null && _list.length > 0) {
                          List<SaleInvoiceDetail> _saleInvoiceDetailList = await dbHelper.saleInvoiceDetailGetList(invoiceIdList: [_list[0].id]);
                          _list[0].totalProducts = _saleInvoiceDetailList.length;
                          _list[0].invoiceDetailList = _saleInvoiceDetailList;

                          List<PaymentSaleInvoice> _paymentSaleInvoiceList = await dbHelper.paymentSaleInvoiceGetList(invoiceIdList: [_list[0].id], isCancel: false);
                          List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentSaleInvoiceList.map((paymentOrder) => paymentOrder.paymentId).toList());

                          // double _givenAmount = 0;
                          // if (_paymentList.length != 0) {
                          //   _paymentList.forEach((item) {
                          //     if (item.paymentType == 'RECEIVED') {
                          //       _list[0].advanceAmount += item.amount;
                          //     } else {
                          //       _givenAmount += item.amount;
                          //     }
                          //   });
                          // }
                          // _list[0].remainAmount = (_paymentList.length != 0) ? (_list[0].grossAmount - (_list[0].advanceAmount - _givenAmount)) : _list[0].grossAmount;
                          // _list[0].isEditable = await dbHelper.saleQuoteisUsed(_list[0].id);
                          // _list[0].isEditable = !_list[0].isEditable;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SaleInvoiceDetailScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    invoice: _list[0],
                                    // screenId: 0,
                                  )));
                        }
                      },
                      child: Text('${global.appLocaleValues['lbl_purchase_invoice_no']}: ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + saleOrder.salesInvoiceNumber.toString().length))}${saleOrder.salesInvoiceNumber}'))
                  : SizedBox()
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(saleOrder.orderDate)}  ${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_item']}: ${saleOrder.totalProducts}',
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).primaryTextTheme.subtitle2,
              )
            ],
          ),
          Row(
            children: <Widget>[
              (saleOrder.advanceAmount > 0)
                  ? Row(
                      children: <Widget>[
                        Text(
                          '${global.appLocaleValues['lbl_advance']}: ${global.currency.symbol} ${saleOrder.advanceAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                          style: TextStyle(color: Colors.green),
                        ),
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
            width: MediaQuery.of(context).size.width * .3,
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
                        '${global.currency.symbol} ${saleOrder.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Center(
                    child: (saleOrder.status != 'CANCELLED')
                        ? (saleOrder.status == 'INVOICED')
                            ? Text(
                                '${saleOrder.status}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, height: 0.9),
                              )
                            : Text(
                                '${saleOrder.status}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, height: 0.9),
                              )
                        : Text(
                            '${saleOrder.status}',
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
              (saleOrder.status != 'CANCELLED' && saleOrder.isEditable)
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
                              builder: (context) => SaleOrderAddSreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    order: saleOrder,
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
                    await onDeletePressed(saleOrder);
                  },
                ),
              ) : null,

              // (saleOrder.status != 'CANCELLED' && saleOrder.isEditable && saleOrder.remainAmount > 0)
              //     ? PopupMenuItem(
              //         child: ListTile(
              //           contentPadding: EdgeInsets.zero,
              //           title: Row(
              //             children: <Widget>[
              //               Padding(
              //                 padding: const EdgeInsets.only(right: 10),
              //                 child: Icon(
              //                   Icons.payment,
              //                   color: Theme.of(context).primaryColor,
              //                 ),
              //               ),
              //               Text('Take Advance'),
              //             ],
              //           ),
              //           onTap: () {
              //             Navigator.of(context).pop();
              //             Navigator.of(context).push(MaterialPageRoute(
              //                 builder: (context) => PaymentAddScreen(
              //                       a: widget.analytics,
              //                       o: widget.observer,
              //                       saleOrder: saleOrder,
              //                       returnScreenId:  13,
              //                       account: account,
              //                     )));
              //           },
              //         ),
              //       )
              //     : null,
              // (saleOrder.status != 'CANCELLED' && saleOrder.isEditable && saleOrder.remainAmount < 0)
              //     ? PopupMenuItem(
              //         child: ListTile(
              //           contentPadding: EdgeInsets.zero,
              //           title: Row(
              //             children: <Widget>[
              //               Padding(
              //                 padding: const EdgeInsets.only(right: 10),
              //                 child: Icon(
              //                   Icons.payment,
              //                   color: Theme.of(context).primaryColor,
              //                 ),
              //               ),
              //               Text(global.appLocaleValues['lt_give_payment']),
              //             ],
              //           ),
              //           onTap: () {
              //             Navigator.of(context).pop();
              //             // Navigator.of(context).push(MaterialPageRoute(
              //             //     builder: (context) => PaymentAddScreen(
              //             //           a: widget.analytics,
              //             //           o: widget.observer,
              //             //           saleOrder: saleOrder,
              //             //           returnScreenId:  14,
              //             //           account: account,
              //             //         )));
              //           },
              //         ),
              //       )
              //     : null,
              (saleOrder.status == 'OPEN' && onGenerateInvoicePressed != null)
                  ? PopupMenuItem(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.add,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(global.appLocaleValues['lt_generate_invoice']),
                          ],
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();
                          await onGenerateInvoicePressed(saleOrder);
                        },
                      ),
                    )
                  : null,
             (orderPrintOrShare != null) ? PopupMenuItem(
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
                    await orderPrintOrShare(saleOrder, _isPrintAction, context);
                    //   _invoicePrintOrShare(index, context);
                  },
                ),
              ) : null,
            (orderPrintOrShare != null) ?   PopupMenuItem(
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
                    await orderPrintOrShare(saleOrder, _isPrintAction, context);
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
                    var htmlContent = await orderPrintOrShare(saleOrder, null, context);
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
              (saleOrder.status != 'CANCELLED' && orderCancelOrRetrive != null)
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
                          _actionOfCancelOrder = true;
                          Navigator.of(context).pop();
                          await orderCancelOrRetrive(saleOrder, _actionOfCancelOrder, context);
                          //  _cancelOrRetriveInvoice(index);
                        },
                      ),
                    )
                  : null,
              (saleOrder.status == 'CANCELLED' && orderCancelOrRetrive != null && (DateTime.now().difference(saleOrder.modifiedAt).inDays) == 0)
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
                          _actionOfCancelOrder = false;
                          Navigator.of(context).pop();
                          await orderCancelOrRetrive(saleOrder, _actionOfCancelOrder, context);
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
            builder: (context) => SaleOrderDetailScreen(
                  a: widget.analytics,
                  o: widget.observer,
                  order: saleOrder,
                  screenId: 0,
                )));
      },
    );
  }
}
