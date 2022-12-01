// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/screens/AccountDetailScreen.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentDetailModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/screens/purchaseInvoiceDetailScreen.dart';


class PurchaseInvoiceReturnDetailScreen extends BaseRoute {
  final List<PurchaseInvoiceReturn> invoiceReturnList;
  final double remainAmount;
  PurchaseInvoiceReturnDetailScreen({@required a, @required o, @required this.invoiceReturnList, @required this.remainAmount}) : super(a: a, o: o, r: 'PurchaseInvoiceReturnDetailScreen');

  @override
  _PurchaseInvoiceReturnDetailScreenState createState() => _PurchaseInvoiceReturnDetailScreenState(this.invoiceReturnList, this.remainAmount);
}

class _PurchaseInvoiceReturnDetailScreenState extends BaseRouteState {
  List<PurchaseInvoiceReturn> invoiceReturnList;
  // bool _isPrintAction;
  final double remainAmount;
  bool _isdataLoaded = false;
  double _subTotal = 0;
  double _finalTotal = 0;
  double _byCash = 0;
  double _byCheque = 0;
  double _byCard = 0;
  double _byNetBanking = 0;
  double _byEWallet = 0;
  // double _receivedAmount = 0;
  double _givenAmount = 0;
  List<TaxMaster> _taxList = [];

  _PurchaseInvoiceReturnDetailScreenState(this.invoiceReturnList, this.remainAmount) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${global.appLocaleValues['tle_purchase_invoice_return']}'),
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
                                  '${br.generateAccountName(invoiceReturnList[0].account)}',
                                  style: Theme.of(context).primaryTextTheme.headline3,
                                ),
                              ],
                            ),
                            onTap: () async {
                              List<Payment> _paymentList = await dbHelper.paymentGetList(accountId: invoiceReturnList[0].account.id);
                              double returnPurchaseInvoiceAmount = (_paymentList.length > 0) ? await dbHelper.paymentPurchaseInvoiceReturnGetSumOfAmount(paymentIdList: _paymentList.map((f) => f.id).toList()) : 0;
                              invoiceReturnList[0].account.totalPaid -= returnPurchaseInvoiceAmount;
                              invoiceReturnList[0].account.totalDue = invoiceReturnList[0].account.totalSpent - invoiceReturnList[0].account.totalPaid;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AccountDetailScreen(
                                        a: widget.analytics,
                                        o: widget.observer,
                                        account: invoiceReturnList[0].account,
                                      )));
                            }),
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
                                  "${global.appLocaleValues['tle_return_date']}",
                                  style: Theme.of(context).primaryTextTheme.headline1,
                                ),
                                subtitle: Text(
                                  '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoiceReturnList[0].invoiceDate)}',
                                  style: Theme.of(context).primaryTextTheme.headline3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: invoiceReturnList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                List<PurchaseInvoice> _purchaseInvoiceList = await dbHelper.purchaseInvoiceGetList(invoiceNumber: invoiceReturnList[index].purchaseInvoiceNumber);
                                PurchaseInvoice _purchaseInvoice = (_purchaseInvoiceList.length > 0) ? _purchaseInvoiceList[0] : null;
                                if (_purchaseInvoice != null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PurchaseInvoiceDetailScreen(
                                            a: widget.analytics,
                                            o: widget.observer,
                                            invoice: _purchaseInvoice,
                                          )));
                                }
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      '${global.appLocaleValues['tle_invoice']} ${invoiceReturnList[index].purchaseInvoiceNumber}',
                                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
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
                                              '${global.appLocaleValues['lbl_return_qty_']}',
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
                                  ),
                                  Divider(),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: invoiceReturnList[index].invoiceReturnDetailList.length,
                                    itemBuilder: (context, i) {
                                      return Column(
                                        children: [
                                          (i != 0) ? Divider() : SizedBox(),
                                          Row(
                                            children: [
                                              Container(
                                                  width: 17,
                                                  child: Text(
                                                    '${i + 1}',
                                                    style: TextStyle(fontSize: 13),
                                                  )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                '${invoiceReturnList[index].invoiceReturnDetailList[i].productName}',
                                                style: TextStyle(fontSize: 13),
                                              )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                  width: 45,
                                                  child: Text(
                                                    '${invoiceReturnList[index].invoiceReturnDetailList[i].quantity}',
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
                                                        '${invoiceReturnList[index].invoiceReturnDetailList[i].unitCode}',
                                                        style: TextStyle(fontSize: 13),
                                                        textAlign: TextAlign.center,
                                                      ))
                                                  : SizedBox(),
                                              Container(
                                                width: 70,
                                                child: Text(
                                                  '${global.currency.symbol} ${invoiceReturnList[index].invoiceReturnDetailList[i].unitPrice.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(fontSize: 13),
                                                ),
                                              ),
                                              Container(
                                                width: 70,
                                                child: Text(
                                                  '${global.currency.symbol} ${invoiceReturnList[index].invoiceReturnDetailList[i].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(fontSize: 13),
                                                ),
                                              ),
                                            ],
                                          ),
                                          (i == invoiceReturnList[index].invoiceReturnDetailList.length - 1) ? Divider() : SizedBox(),
                                        ],
                                      );
                                    },
                                  ),
                                  ((invoiceReturnList.length - 1) != index)
                                      ? SizedBox(
                                          height: 20,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            );
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${global.appLocaleValues['lbl_sub_total_']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                          Text(
                            ' ${global.currency.symbol} ${_subTotal.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                            style: Theme.of(context).primaryTextTheme.overline,
                            textAlign: TextAlign.end,
                          )
                        ],
                      ),
                    ),
                    (_taxList != null && _taxList.length > 0)
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _taxList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${_taxList[index].taxName}', style: Theme.of(context).primaryTextTheme.subtitle2),
                                    Text(
                                      ' ${global.currency.symbol} ${_taxList[index].taxAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                            ' ${global.currency.symbol} ${_finalTotal.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                            ' ${global.currency.symbol} ${_givenAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                          Text((remainAmount >= 0) ? '${global.appLocaleValues['lbl_due']}' : '${global.appLocaleValues['lbl_credit']}', style: Theme.of(context).primaryTextTheme.subtitle2),
                          Text(
                            (remainAmount >= 0) ? ' ${global.currency.symbol} ${remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}' : '${global.currency.symbol} ${(remainAmount * -1).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
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
                            ' ${invoiceReturnList[0].status}',
                            style: TextStyle(
                                fontSize: 14,
                                color: (invoiceReturnList[0].status != 'CANCELLED')
                                    ? (invoiceReturnList[0].status == 'REFUNDED')
                                        ? Colors.green
                                        : Colors.blueAccent
                                    : Colors.grey,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(left: 5, right: 5), child: Divider()),
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
      List<Account> _tempList = await dbHelper.accountGetList(accountId: invoiceReturnList[0].accountId);
      for (int i = 0; i < invoiceReturnList.length; i++) {
        invoiceReturnList[i].account = _tempList[0];
        invoiceReturnList[i].invoiceReturnDetailList = await dbHelper.purchaseInvoiceReturnDetailGetList(purchaseInvoiceReturnId: invoiceReturnList[i].id);
        invoiceReturnList[i].invoiceReturnTaxList = await dbHelper.purchaseInvoiceReturnTaxGetList(purchaseInvoiceReturnId: invoiceReturnList[i].id);
      }

      _subTotal = invoiceReturnList.map((f) => f.grossAmount).reduce((sum, amt) => sum + amt);
      _finalTotal = invoiceReturnList.map((f) => f.netAmount).reduce((sum, amt) => sum + amt);

      List<int> _taxId = [];
      invoiceReturnList.forEach((item) {
        item.invoiceReturnTaxList.forEach((f) {
          _taxId.add(f.taxId);
        });
      });

      _taxList = await dbHelper.taxMasterGetList(taxMasterIdList: _taxId.toSet().toList());

      _taxList.forEach((f) {
        double _taxAmt = 0;
        invoiceReturnList.forEach((item) {
          item.invoiceReturnTaxList.forEach((tax) {
            if (f.id == tax.taxId) {
              _taxAmt += tax.totalAmount;
            }
          });
        });
        f.taxAmount = _taxAmt;
      });

      List<PaymentPurchaseInvoiceReturn> _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(transactionGroupId: invoiceReturnList[0].transactionGroupId);
      List<Payment> _paymentList = (_paymentPurchaseInvoiceReturnList.length > 0) ? await dbHelper.paymentGetList(paymentIdList: _paymentPurchaseInvoiceReturnList.map((f) => f.paymentId).toList()) : [];
      List<PaymentDetail> _paymentDetailList = (_paymentPurchaseInvoiceReturnList.length > 0) ? await dbHelper.paymentDetailGetList(paymentIdList: _paymentPurchaseInvoiceReturnList.map((f) => f.paymentId).toList()) : [];
      //   _receivedAmount = 0;
      _givenAmount = 0;
      if (_paymentList.length > 0) {
        _paymentList.forEach((item) {
          if (item.paymentType == 'RECEIVED') {
            _givenAmount += item.amount;
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
            // _receivedAmount += item.amount;
          }
        });
      }
      _isdataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnDetailScreen - _getData(): ' + e.toString());
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
