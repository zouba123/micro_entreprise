// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/screens/saleOrderDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/screens/InvoicePreviewScreen.dart';
import 'package:accounting_app/screens/saleInvoiceDetailScreen.dart';
import 'package:accounting_app/screens/salesQuoteAddScreen.dart';
import 'package:accounting_app/screens/salesQuoteDetailScreen.dart';

class ListTileSaleQuoteWidget extends Base {
  final Account account;
  final SaleQuote saleQuote;
  final onGenerateInvoicePressed;
  final onGenerateOrderPressed;
  final onDeletePressed;
  final orderPrintOrShare;
  final orderCancelOrRetrive;
  ListTileSaleQuoteWidget({@required Key key, @required a, @required o, this.account, this.onDeletePressed, this.orderPrintOrShare, this.onGenerateInvoicePressed, this.onGenerateOrderPressed, this.orderCancelOrRetrive, this.saleQuote}) : super(key: key, analytics: a, observer: o);
  @override
  _ListTileSaleQuoteWidgetState createState() => _ListTileSaleQuoteWidgetState(this.onDeletePressed, this.onGenerateInvoicePressed, this.onGenerateOrderPressed, this.orderPrintOrShare, this.orderCancelOrRetrive, this.account, this.saleQuote);
}

class _ListTileSaleQuoteWidgetState extends BaseState {
  SaleQuote saleQuote;
  final onDeletePressed;
  final onGenerateInvoicePressed;
  final onGenerateOrderPressed;
  final orderPrintOrShare;
  final Account account;
  bool _actionOfCancelOrder;
  bool _isPrintAction;
  final orderCancelOrRetrive;

  _ListTileSaleQuoteWidgetState(this.onDeletePressed, this.onGenerateInvoicePressed, this.onGenerateOrderPressed, this.orderPrintOrShare, this.orderCancelOrRetrive, this.account, this.saleQuote);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
      title: Text(
        '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + saleQuote.saleQuoteNumber.toString().length))}${saleQuote.saleQuoteNumber}-${saleQuote.versionNumber} ${br.generateAccountName(saleQuote.account)}',
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).primaryTextTheme.subtitle1,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (saleQuote.saleInvoiceNumber != null && saleQuote.saleInvoiceId != null)
              ? Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () async {
                      List<SaleInvoice> _list = await dbHelper.saleInvoiceGetList(invoiceIdList: [saleQuote.saleInvoiceId]);
                      if (_list != null && _list.length > 0) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SaleInvoiceDetailScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  invoice: _list[0],
                                )));
                      }
                    },
                    child: Text(
                      '${global.appLocaleValues['lbl_purchase_invoice_no']}: ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + saleQuote.saleInvoiceNumber.toString().length))}${saleQuote.saleInvoiceNumber}',
                      style: Theme.of(context).primaryTextTheme.subtitle2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SizedBox(),
          (saleQuote.saleOrderNumber != null && saleQuote.saleOrderId != null)
              ? Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () async {
                      List<SaleOrder> _list = await dbHelper.saleOrderGetList(orderIdList: [saleQuote.saleOrderId]);
                      if (_list != null && _list.length > 0) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SaleOrderDetailScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  screenId: 1,
                                  order: _list[0],
                                )));
                      }
                    },
                    child: Text(
                      '${global.appLocaleValues['tle_sale_order_no']}: ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + saleQuote.saleOrderNumber.toString().length))}${saleQuote.saleOrderNumber}',
                      style: Theme.of(context).primaryTextTheme.subtitle2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SizedBox(),
          Row(
            children: <Widget>[
              Text(
                '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(saleQuote.orderDate)}  ${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_item']}: ${saleQuote.totalProducts}',
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).primaryTextTheme.subtitle2,
              )
            ],
          ),
          Row(
            children: <Widget>[
              (saleQuote.advanceAmount > 0)
                  ? Row(
                      children: <Widget>[
                        Text(
                          '${global.appLocaleValues['lbl_advance']}: ${global.currency.symbol} ${saleQuote.advanceAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                        '${global.currency.symbol} ${saleQuote.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Center(
                    child: (saleQuote.status != 'CANCELLED')
                        ? (saleQuote.status == 'INVOICED')
                            ? Text(
                                '${saleQuote.status}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, height: 0.9),
                              )
                            : (saleQuote.status == 'ORDERED')
                                ? Text(
                                    '${saleQuote.status}',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, height: 0.9),
                                  )
                                : Text(
                                    '${saleQuote.status}',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, height: 0.9),
                                  )
                        : Text(
                            '${saleQuote.status}',
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
              (saleQuote.status != 'CANCELLED' && saleQuote.isEditable)
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
                              builder: (context) => SaleQuoteAddSreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    quote: saleQuote,
                                    isMakeNewVersion: false,
                                    returnScreenId: 0,
                                  )));
                        },
                      ),
                    )
                  : null,
              (saleQuote.status != 'CANCELLED' && saleQuote.isEditable)
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
                            Text('${global.appLocaleValues['mk_ver']}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SaleQuoteAddSreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    quote: saleQuote,
                                    isMakeNewVersion: true,
                                    returnScreenId: 0,
                                  )));
                        },
                      ),
                    )
                  : null,
              (onDeletePressed != null)
                  ? PopupMenuItem(
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
                          await onDeletePressed(saleQuote);
                        },
                      ),
                    )
                  : null,
              // (saleQuote.status != 'CANCELLED' && saleQuote.isEditable && saleQuote.remainAmount > 0)
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
              //               Text(global.appLocaleValues['lt_take_payment']),
              //             ],
              //           ),
              //           onTap: () {
              //             // Navigator.of(context).pop();
              //             // Navigator.of(context).push(MaterialPageRoute(
              //             //     builder: (context) => PaymentAddScreen(
              //             //           a: widget.analytics,
              //             //           o: widget.observer,
              //             //           saleOrder: saleOrder,
              //             //           returnScreenId:  13,
              //             //           account: account,
              //             //         )));
              //           },
              //         ),
              //       )
              //     : null,
              // (saleQuote.status != 'CANCELLED' && saleQuote.isEditable && saleQuote.remainAmount < 0)
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
              //             // Navigator.of(context).pop();
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
              (saleQuote.status == 'OPEN' && onGenerateOrderPressed != null)
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
                            Text('${global.appLocaleValues['gen_odr']}'),
                          ],
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();
                          await onGenerateOrderPressed(saleQuote);
                        },
                      ),
                    )
                  : null,
              (saleQuote.status == 'OPEN' && onGenerateInvoicePressed != null)
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
                          await onGenerateInvoicePressed(saleQuote);
                        },
                      ),
                    )
                  : null,

           (orderPrintOrShare != null) ?  PopupMenuItem(
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
                    await orderPrintOrShare(saleQuote, _isPrintAction, context);
                    //   _invoicePrintOrShare(index, context);
                  },
                ),
              ) : null,
              (orderPrintOrShare != null) ? PopupMenuItem(
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
                    await orderPrintOrShare(saleQuote, _isPrintAction, context);
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
                    var htmlContent = await orderPrintOrShare(saleQuote, null, context);
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
              (saleQuote.status != 'CANCELLED' && orderCancelOrRetrive != null)
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
                          await orderCancelOrRetrive(saleQuote, _actionOfCancelOrder, context);
                          //  _cancelOrRetriveInvoice(index);
                        },
                      ),
                    )
                  : null,
              (saleQuote.status == 'CANCELLED' && orderCancelOrRetrive != null && (DateTime.now().difference(saleQuote.modifiedAt).inDays) == 0)
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
                          await orderCancelOrRetrive(saleQuote, _actionOfCancelOrder, context);
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
            builder: (context) => SalesQuoteDetailScreen(
                  a: widget.analytics,
                  o: widget.observer,
                  quote: saleQuote,
                  screenId: 0,
                )));
      },
    );
  }
}
