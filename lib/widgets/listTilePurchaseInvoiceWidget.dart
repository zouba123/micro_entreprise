// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/screens/paymentAddScreen.dart';
import 'package:accounting_app/screens/purchaseInvoiceAddScreen.dart';
import 'package:accounting_app/screens/purchaseInvoiceDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTilePurchaseInvoiceWidget extends Base {
  final PurchaseInvoice purchaseInvoice;
  final Account account;
  final int tabIndex;
  final onDeletePressed;
  final invoicePrintOrShare;
  final invoiceCancelOrRetrive;
  ListTilePurchaseInvoiceWidget({@required Key key, @required this.purchaseInvoice, @required this.tabIndex, @required a, @required o, this.account, this.onDeletePressed, this.invoicePrintOrShare, this.invoiceCancelOrRetrive}) : super(key: key, analytics: a, observer: o);
  @override
  _ListTilePurchaseInvoiceWidgetState createState() => _ListTilePurchaseInvoiceWidgetState(this.purchaseInvoice, this.tabIndex, this.onDeletePressed, this.invoicePrintOrShare, this.invoiceCancelOrRetrive, this.account);
}

class _ListTilePurchaseInvoiceWidgetState extends BaseState {
  PurchaseInvoice purchaseInvoice;
  final int _tabIndex;
  final onDeletePressed;
  final invoicePrintOrShare;
//  var _formKey = GlobalKey<FormState>();
//  TextEditingController _cMsg =  TextEditingController();
  bool _actionOfCancelInvoice;
  bool _isPrintAction;
  final invoiceCancelOrRetrive;
  final Account account;

  _ListTilePurchaseInvoiceWidgetState(this.purchaseInvoice, this._tabIndex, this.onDeletePressed, this.invoicePrintOrShare, this.invoiceCancelOrRetrive, this.account);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
      title: Text(
        '${purchaseInvoice.invoiceNumber} - ${br.generateAccountName(purchaseInvoice.account)}',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14),
      ),
      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(purchaseInvoice.invoiceDate)}  ${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_item']}: ${purchaseInvoice.totalProducts}',
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          Row(
            children: <Widget>[
              (purchaseInvoice.remainAmount != null)
                  ? (purchaseInvoice.remainAmount < 0)
                      ? Row(
                          children: <Widget>[
                            Text('${global.appLocaleValues['lbl_credit']}: ${global.currency.symbol} ${(purchaseInvoice.remainAmount * -1).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: TextStyle(color: Colors.green)),
                            (purchaseInvoice.returnProducts > 0)
                                ? Text(
                                    '  ${global.appLocaleValues['lbl_r']}.${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_item']}: ${purchaseInvoice.returnProducts}',
                                    style: TextStyle(color: Colors.red))
                                : SizedBox()
                          ],
                        )
                      : Row(
                          children: <Widget>[
                            Text(
                              '${global.appLocaleValues['lbl_due']}: ${global.currency.symbol} ${purchaseInvoice.remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                              style: TextStyle(color: Colors.red),
                            ),
                            (purchaseInvoice.returnProducts > 0)
                                ? Text(
                                    '  ${global.appLocaleValues['lbl_r']}.${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_item']}: ${purchaseInvoice.returnProducts}',
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
                        '${global.currency.symbol} ${purchaseInvoice.netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 0.9,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Center(
                    child: (purchaseInvoice.status != 'CANCELLED')
                        ? (purchaseInvoice.status == 'PAID')
                            ? Text(
                                '${purchaseInvoice.status}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, height: 0.9),
                              )
                            : Text(
                                '${purchaseInvoice.status}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, height: 0.9),
                              )
                        : Text(
                            '${purchaseInvoice.status}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, height: 0.9),
                          )

                    // child: Container(
                    //   padding: EdgeInsets.all(5),
                    //   color: (purchaseInvoice.status != 'CANCELLED') ? (purchaseInvoice.status == 'PAID') ? Colors.green : Colors.red : Colors.grey,
                    //   width: 80,
                    //   child:
                    //       Text(
                    //         '${purchaseInvoice.status}',
                    //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    //       )
                    // ),
                    )
              ],
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              (purchaseInvoice.status != 'CANCELLED' && _tabIndex < 2)
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
                              builder: (context) => PurchaseInvoiceAddSreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    invoice: purchaseInvoice,
                                  )));
                        },
                      ),
                    )
                  : null,
              (_tabIndex < 2 && onDeletePressed != null)
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
                          await onDeletePressed(purchaseInvoice);
                        },
                      ),
                    )
                  : null,
              (purchaseInvoice.status == 'DUE')
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
                                    purchaseInvoice: purchaseInvoice,
                                    account: account,
                                    returnScreenId: (_tabIndex == 2)
                                        ? 5
                                        : (_tabIndex == 3)
                                            ? 4
                                            : 7,
                                  )));
                        },
                      ),
                    )
                  : null,
              (purchaseInvoice.status != 'CANCELLED' && purchaseInvoice.remainAmount < 0)
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
                                    purchaseInvoice: purchaseInvoice,
                                    account: account,
                                    returnScreenId: (_tabIndex == 2)
                                        ? 6
                                        : (_tabIndex == 3)
                                            ? 3
                                            : 8,
                                  )));
                        },
                      ),
                    )
                  : null,
              (invoicePrintOrShare != null)
                  ? PopupMenuItem(
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
                          //  _showLoader();
                          await invoicePrintOrShare(purchaseInvoice, _isPrintAction, context);
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
                    //   _showLoader();
                    await invoicePrintOrShare(purchaseInvoice, _isPrintAction, context);
                  },
                ),
              ) : null,
              (invoiceCancelOrRetrive != null && purchaseInvoice.status != 'CANCELLED' && _tabIndex < 2)
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
                          await invoiceCancelOrRetrive(purchaseInvoice, _actionOfCancelInvoice, context);
                        },
                      ),
                    )
                  : null,
              (invoiceCancelOrRetrive != null && purchaseInvoice.status == 'CANCELLED' && _tabIndex < 2 && (DateTime.now().difference(purchaseInvoice.modifiedAt).inDays) == 0)
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
                          Navigator.of(context).pop();
                          _actionOfCancelInvoice = false;
                          await invoiceCancelOrRetrive(purchaseInvoice, _actionOfCancelInvoice, context);
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
            builder: (context) => PurchaseInvoiceDetailScreen(
                  a: widget.analytics,
                  o: widget.observer,
                  invoice: purchaseInvoice,
                )));
      },
    );
  }
}
