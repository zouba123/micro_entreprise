// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/dialogs/productSelectDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/businessRule.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentDetailModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/paymentSaleOrderModel.dart';
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnDetailTaxModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnTaxModel.dart';
import 'package:accounting_app/models/saleInvoiceSearchModel.dart';
import 'package:accounting_app/models/saleOrderInvoiceModel.dart';
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/saleInvoiceAddScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:accounting_app/widgets/listTileSaleInvoiceWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ribbon/ribbon.dart';

class SaleInvoiceScreen extends BaseRoute {
  final Account account;
  SaleInvoiceScreen({@required a, @required o, this.account}) : super(a: a, o: o, r: 'SaleInvoiceScreen');
  @override
  _SaleInvoiceScreenState createState() => _SaleInvoiceScreenState(this.account);
}

class _SaleInvoiceScreenState extends BaseRouteState {
  List<SaleInvoice> _saleInvoiceList = [];
  List<SaleInvoice> _saleInvoiceWithoutTaxList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _startIndex = 0;
  SaleInvoiceSearch _invoiceSearch = SaleInvoiceSearch();
  List<int> _searchByInvoiceIdList;
  final Account account;
  bool _isLoaderHide = false;
  bool _isDataLoaded = false;
  bool _isRecordPending = true;
  var _refreshKey1 = GlobalKey<RefreshIndicatorState>();
  // var _refreshKey2 = GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController1 = ScrollController();
  // ScrollController _scrollController2 =  ScrollController();
  // int _startIndex2 = 0;
  int filterCount = 0;
  int _filterIndex;
  _SaleInvoiceScreenState(this.account) : super();

  @override
  Widget build(BuildContext context) {
    return
        //(br.getSystemFlagValue(global.systemFlagNameList.showSaleInvoicesSeprated) == 'true')
        //     ? Scaffold(
        //         backgroundColor: Colors.white,
        //         key: _scaffoldKey,
        //         appBar: AppBar(
        //           title: Text(
        //             global.appLocaleValues['lbl_invoices'],
        //             style: Theme.of(context).appBarTheme.titleTextStyle,
        //           ),
        //           actions: <Widget>[
        //             // (br.getSystemFlagValue(global.systemFlagNameList.showSaleInvoicesSeprated) == 'true')
        //             //     ? IconButton(
        //             //         tooltip: '${global.appLocaleValues['tt_show_combined']}',
        //             //         icon: Icon(Icons.view_day),
        //             //         iconSize: 20,
        //             //         onPressed: () async {
        //             //           await _changeLayout(false);
        //             //         },
        //             //       )
        //             // : SizedBox(),
        //             IconButton(
        //                 // itemCount: filterCount, // required
        //                 icon: Icon(MdiIcons.filter), // required
        //                 // badgeColor: Colors.green, // default: Colors.red
        //                 // badgeTextColor: Colors.white, // default: Colors.white
        //                 // hideZeroCount: true, // default: true
        //                 onPressed: () async {
        //                   await _searchInvoices();
        //                 }),
        //             IconButton(
        //               icon: Icon(Icons.add),
        //               iconSize: 30,
        //               onPressed: () {
        //                 Navigator.of(context).push(MaterialPageRoute(
        //                     builder: (context) => SaleInvoiceAddSreen(
        //                           a: widget.analytics,
        //                           o: widget.observer,
        //                           invoice: SaleInvoice(),
        //                         )));
        //               },
        //             )
        //           ],
        //         ),
        //         drawer: SizedBox(
        //           width: MediaQuery.of(context).size.width - 90,
        //           child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
        //         ),
        //         body: WillPopScope(
        //             onWillPop: () {
        //               Navigator.of(context).push(MaterialPageRoute(
        //                   builder: (context) => DashboardScreen(
        //                         a: widget.analytics,
        //                         o: widget.observer,
        //                       )));
        //               return null;
        //             },
        //             child: _saleInvoiceTab(_saleInvoiceWithoutTaxList, 1)),
        //       )
        //     :
        Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(global.appLocaleValues['lbl_invoices'], style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: <Widget>[
          // (br.getSystemFlagValue(global.systemFlagNameList.showSaleInvoicesSeprated) != 'true' && br.getSystemFlagValue(global.systemFlagNameList.enableTax) == 'true')
          //     ? IconButton(
          //         tooltip: '${global.appLocaleValues['tt_show_separated']}',
          //         icon: Icon(Icons.view_array),
          //         iconSize: 25,
          //         onPressed: () async {
          //           await _changeLayout(true);
          //         },
          //       )
          //     : SizedBox(),
          IconButton(
              icon: Icon(MdiIcons.filter), // required

              onPressed: () async {
                await _searchInvoices();
              }),
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SaleInvoiceAddSreen(
                        a: widget.analytics,
                        o: widget.observer,
                        invoice: SaleInvoice(),
                      )));
            },
          )
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width - 90,
        child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
      ),
      body: WillPopScope(
          onWillPop: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DashboardScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
            return null;
          },
          child: Column(
            children: [
              _filterTab(),
              Expanded(child: _saleInvoiceTab(_saleInvoiceList, 0)),
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController1.addListener(_lazyLoading);
    // _scrollController2.addListener(_lazyLoadingInvoiceWithoutTax);
  }

  @override
  void initState() {
    super.initState();
    _filterIndex = 0;
    if (account != null) {
      _invoiceSearch.account = account;
    }
    _getData();
  }

  Future _getData() async {
    try {
      await _getSaleInvoice(false);
      // await _getSaleInvoiceWithoutTax(false);
      _scrollController1.addListener(_lazyLoading);
      // _scrollController2.addListener(_lazyLoadingInvoiceWithoutTax);
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - saleInvoiceScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _cancelOrRetriveInvoice(SaleInvoice _saleInvoice, context, bool _actionOfCancelInvoice) async {
    try {
      //   int _index = index;
      if (_actionOfCancelInvoice) //check it is action of cancel invoice
      {
        try {
          AlertDialog dialog = AlertDialog(
            shape: nativeTheme().dialogTheme.shape,
            title: Text(
              global.appLocaleValues['tle_cancel_invoice'],
              style: Theme.of(context).primaryTextTheme.headline1,
            ),
            content: (global.appLanguage['name'] == 'English')
                ? Text(
                    '${global.appLocaleValues['txt_cancel_invoice']} "${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleInvoice.invoiceNumber.toString().length))}${_saleInvoice.invoiceNumber}" ?',
                    style: Theme.of(context).primaryTextTheme.headline3)
                : Text(
                    '"${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleInvoice.invoiceNumber.toString().length))}${_saleInvoice.invoiceNumber}" ${global.appLocaleValues['txt_cancel_invoice']} ?',
                    style: Theme.of(context).primaryTextTheme.headline3),
            actions: <Widget>[
              TextButton(
                child: Text(global.appLocaleValues['btn_no'], style: Theme.of(context).primaryTextTheme.headline3),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  global.appLocaleValues['btn_yes'],
                  style: Theme.of(context).primaryTextTheme.headline2,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _saleInvoice.status = 'CANCELLED';
                  await dbHelper.saleInvoiceUpdate(invoice: _saleInvoice, updateFrom: 2);
                  try {
                    AlertDialog dialog = AlertDialog(
                      shape: nativeTheme().dialogTheme.shape,
                      title: Text(global.appLocaleValues['tle_cancel_payments'], style: Theme.of(context).primaryTextTheme.headline1),
                      content: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: (global.appLanguage['name'] == 'English')
                                      ? Text(
                                          '${global.appLocaleValues['txt_cancel_payments']} "${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleInvoice.invoiceNumber.toString().length))}${_saleInvoice.invoiceNumber}" ?',
                                          style: Theme.of(context).primaryTextTheme.headline3)
                                      : Text(
                                          '"${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleInvoice.invoiceNumber.toString().length))}${_saleInvoice.invoiceNumber}" ${global.appLocaleValues['txt_cancel_payments']} ?',
                                          style: Theme.of(context).primaryTextTheme.headline3),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(global.appLocaleValues['btn_no'], style: Theme.of(context).primaryTextTheme.headline3),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await _getSaleInvoice(true);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${global.appLocaleValues['txt_invoice_cancel_success']}'),
                            ));
                          },
                        ),
                        TextButton(
                          child: Text(global.appLocaleValues['btn_yes'], style: Theme.of(context).primaryTextTheme.headline2),
                          onPressed: () async {
                            List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(invoiceId: _saleInvoice.id);
                            List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
                            List<PaymentDetail> _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());

                            _paymentInvoiceList.forEach((item) async {
                              item.isCancel = true;
                              await dbHelper.paymentSaleInvoiceUpdate(item);
                            });

                            _paymentDetailList.forEach((item) async {
                              item.isCancel = true;
                              await dbHelper.paymentDetailUpdate(item);
                            });

                            _paymentList.forEach((item) async {
                              item.isCancel = true;
                              await dbHelper.paymentUpdate(item);
                            });
                            Navigator.of(context).pop();
                            await _getSaleInvoice(true);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${global.appLocaleValues['txt_invoice_cancel_success']}'),
                            ));
                          },
                        ),
                      ],
                    );
                    showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
                  } catch (e) {
                    print('Exception - saleInvoiceScreen.dart - _cancelOrRetriveInvoice(): ' + e.toString());
                  }
                },
              ),
            ],
          );
          showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
        } catch (e) {
          print('Exception - saleInvoiceScreen.dart - _cancelOrRetriveInvoice(): ' + e.toString());
        }
      } else {
        List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(invoiceId: _saleInvoice.id);
        List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
        List<PaymentDetail> _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());

        _paymentInvoiceList.forEach((item) async {
          item.isCancel = false;
          await dbHelper.paymentSaleInvoiceUpdate(item);
        });

        _paymentDetailList.forEach((item) async {
          item.isCancel = false;
          await dbHelper.paymentDetailUpdate(item);
        });

        _paymentList.forEach((item) async {
          item.isCancel = false;
          await dbHelper.paymentUpdate(item);
        });

        _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(invoiceId: _saleInvoice.id, isCancel: false);
        _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
        double _receivedAmount = 0;
        double _givenAmount = 0;
        if (_paymentList.length != 0) {
          _paymentList.forEach((item) {
            if (item.paymentType == 'RECEIVED') {
              _receivedAmount += item.amount;
            } else {
              _givenAmount += item.amount;
            }
          });
        }
        _saleInvoice.remainAmount = (_paymentList.length != 0) ? (_saleInvoice.netAmount - (_receivedAmount - _givenAmount)) : _saleInvoice.netAmount;
        _saleInvoice.status = (_saleInvoice.remainAmount <= 0) ? 'PAID' : 'DUE';
        await dbHelper.saleInvoiceUpdate(invoice: _saleInvoice, updateFrom: 2);
        await _getSaleInvoice(true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('${global.appLocaleValues['txt_invoice_retrvied_success']}'),
        ));
        // setState(() {});
      }
    } catch (e) {
      print('Exception - saleInvoiceScreen.dart - _cancelOrRetriveInvoice(): ' + e.toString());
    }
  }

  Future _deleteInvoice(SaleInvoice _saleInvoice) async {
    try {
      AlertDialog _dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(global.appLocaleValues['tle_delete_invoice'], style: Theme.of(context).primaryTextTheme.headline1),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  (global.appLanguage['name'] == 'English')
                      ? Text(
                          '${global.appLocaleValues['txt_delete']} "${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleInvoice.invoiceNumber.toString().length))}${_saleInvoice.invoiceNumber}" ?',
                          style: Theme.of(context).primaryTextTheme.headline3)
                      : Text(
                          '"${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleInvoice.invoiceNumber.toString().length))}${_saleInvoice.invoiceNumber}" ${global.appLocaleValues['txt_delete']} ?',
                          style: Theme.of(context).primaryTextTheme.headline3),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(global.appLocaleValues['btn_cancel'], style: Theme.of(context).primaryTextTheme.headline3),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_delete'], style: Theme.of(context).primaryTextTheme.headline2),
            onPressed: () async {
              Navigator.of(context).pop();
              List<SaleOrder> _saleOrderList = [];
              List<SaleInvoiceDetail> _saleInvoiceDetailList = await dbHelper.saleInvoiceDetailGetList(invoiceIdList: [_saleInvoice.id]);
              await dbHelper.saleInvoiceDetailTaxDelete(invoiceDetailIdList: _saleInvoiceDetailList.map((invoiceDetail) => invoiceDetail.id).toList());
              await dbHelper.saleInvoiceTaxDelete(_saleInvoice.id);
              await dbHelper.saleInvoiceDetailDelete(invoiceId: _saleInvoice.id);
              await _deletePayment(_saleInvoice);
              List<SaleOrderInvoice> _saleOrderInvoiceList = await dbHelper.saleOrderInvoiceGetList(saleInvoiceId: _saleInvoice.id);
              if (_saleOrderInvoiceList.length > 0) {
                _saleOrderList = await dbHelper.saleOrderGetList(orderIdList: [_saleOrderInvoiceList[0].saleOrderId]);
                if (_saleOrderList.length > 0) {
                  _saleOrderList[0].orderDetailList = await dbHelper.saleOrderDetailGetList(orderIdList: [_saleOrderInvoiceList[0].saleOrderId]);
                  _saleOrderList[0].orderDetailList.forEach((element) async {
                    _saleInvoiceDetailList.forEach((e) {
                      if (element.productId == e.productId) {
                        element.invoicedQuantity -= e.quantity;
                      }
                    });
                    await dbHelper.saleOrderDetailUpdate(element);
                  });
                }
                for (int i = 0; i < _saleOrderList.length; i++) {
                  int _isInvoicedOrder = 0;
                  _saleOrderList[i].orderDetailList.forEach((orderDetail) {
                    if (orderDetail.quantity != orderDetail.invoicedQuantity) {
                      _isInvoicedOrder++;
                    }
                  });
                  _saleOrderList[i].status = (_isInvoicedOrder == 0) ? 'INVOICED' : 'OPEN';
                  await dbHelper.saleOrderUpdate(order: _saleOrderList[i], updateFrom: 2);
                }
              }
              await dbHelper.saleOrderInvoiceDelete(_saleInvoice.id);

              int _result = await dbHelper.saleInvoiceDelete(_saleInvoice.id);
              if (_result == 1) {
                _saleInvoiceList.removeWhere((f) => f.id == _saleInvoice.id);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('${global.appLocaleValues['txt_invoice_dlt_success']}'),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('${global.appLocaleValues['txt_invoice_dlt_fail']}'),
                ));
              }
            },
          ),
        ],
      );
      showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
    } catch (e) {
      print('Exception - saleInvoiceScreen.dart - _deleteInvoice(): ' + e.toString());
    }
  }

  Future _deletePayment(SaleInvoice _saleInvoice) async {
    try {
      AlertDialog _dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['tle_payment_dlt'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: (global.appLanguage['name'] == 'English')
                          ? Text(
                              '${global.appLocaleValues['txt_payment_dlt']} "${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleInvoice.invoiceNumber.toString().length))}${_saleInvoice.invoiceNumber}" ?')
                          : Text(
                              '"${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleInvoice.invoiceNumber.toString().length))}${_saleInvoice.invoiceNumber}" ${global.appLocaleValues['txt_payment_dlt']} ?')),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(global.appLocaleValues['btn_no']),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_yes']),
            onPressed: () async {
              Navigator.of(context).pop();
              List<PaymentSaleInvoice> _paymentInvoice = await dbHelper.paymentSaleInvoiceGetList(invoiceId: _saleInvoice.id);
              List<PaymentSaleOrder> _paymentSaleOrderList = (_paymentInvoice.length > 0) ? await dbHelper.paymentSaleOrderGetList(paymentIdList: _paymentInvoice.map((e) => e.paymentId).toList()) : [];
              _paymentSaleOrderList.forEach((element) {
                _paymentInvoice.removeWhere((e) => e.paymentId == element.paymentId);
              });
              await dbHelper.paymentDetailDelete(paymentIdList: _paymentInvoice.map((paymentInvoice) => paymentInvoice.paymentId).toList());
              await dbHelper.paymentSaleInvoiceDelete(paymentIdList: _paymentInvoice.map((paymentInvoice) => paymentInvoice.paymentId).toList());
              await dbHelper.paymentDelete(paymentIdList: _paymentInvoice.map((paymentInvoice) => paymentInvoice.paymentId).toList());
            },
          ),
        ],
      );
      await showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
    } catch (e) {
      print('Exception - saleInvoiceScreen.dart - _deletePayment(): ' + e.toString());
    }
  }

  Future<String> _invoicePrintOrShare(SaleInvoice _saleInvoice, context, bool _isPrintAction) async {
    try {
      global.isAppOperation = true;
      List<Account> _accountList = await dbHelper.accountGetList(accountId: _saleInvoice.accountId);
      _saleInvoice.account = _accountList[0];
      _saleInvoice.invoiceDetailList = await dbHelper.saleInvoiceDetailGetList(invoiceIdList: [_saleInvoice.id]);
      _saleInvoice.invoiceTaxList = await dbHelper.saleInvoiceTaxGetList(invoiceId: _saleInvoice.id);
      _saleInvoice.invoiceDetailTaxList = await dbHelper.saleInvoiceDetailTaxGetList(invoiceDetailIdList: _saleInvoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.id).toList());
      //  String _address = (_account.addressLine1.isNotEmpty && _account.state.isNotEmpty && _account.country.isNotEmpty && _account.pincode != null) ? ' ${_account.addressLine1}, ${_account.city}, ${_account.state}, ${_account.country}, ${_account.pincode}' : ' ${_account.city}';
      List<SaleInvoiceReturnDetail> _returnProductList = [];
      List<TaxMaster> _returnProductTaxList = [];
      double _returnProductSubTotal = 0;
      double _returnProductfinalTotal = 0;
      String _returnProductPaymentStatus = '';
      var htmlContent;

      if (_saleInvoice.generateByProductCategory) {
        // generate by product category
        _saleInvoice.invoiceDetailList.forEach((items) {
          int _isExistCategory = 0;
          _saleInvoice.generateByCategoryList.forEach((f) {
            if (f.productCategoryName == items.productTypeName) {
              _isExistCategory++;
            }
          });
          if (_isExistCategory == 0) {
            GenerateByCategory _generateByProductCategory = GenerateByCategory();
            _generateByProductCategory.productCategoryName = items.productTypeName;
            List<SaleInvoiceDetail> _saleInvoiceDetailList = _saleInvoice.invoiceDetailList.where((f) => f.productTypeName == items.productTypeName).toList();
            _generateByProductCategory.quantity = _saleInvoiceDetailList.length;
            _generateByProductCategory.amount = _saleInvoiceDetailList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
            _saleInvoice.generateByCategoryList.add(_generateByProductCategory);
          }
        });
      }

      if (_saleInvoice.returnProducts > 0) {
        _returnProductList = await dbHelper.saleInvoiceReturnDetailGetList(saleInvoiceIdList: [_saleInvoice.id]);
        List<SaleInvoiceReturnDetailTax> _saleInvoiceReturnDetailTaxList = await dbHelper.saleInvoiceReturnDetailTaxGetList(invoiceReturnDetailIdList: _returnProductList.map((f) => f.id).toList());
        List<SaleInvoiceReturn> _saleInvoiceReturnList = await dbHelper.saleInvoiceReturnGetList(invoiceReturnIdList: [_returnProductList[0].saleInvoiceReturnId]);
        SaleInvoiceReturn _saleInvoiceReturn = (_saleInvoiceReturnList.length > 0) ? _saleInvoiceReturnList[0] : null;
        _returnProductPaymentStatus = _saleInvoiceReturn.status;

        if (_saleInvoice.generateByProductCategory) {
          // generate return  by product category
          _returnProductList.forEach((items) {
            int _isExistCategory = 0;
            _saleInvoice.returnGenerateByCategoryList.forEach((f) {
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
              _saleInvoice.returnGenerateByCategoryList.add(_returnGenerateByProductCategory);
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
      //  Navigator.of(context).pop();
      if (_isPrintAction != null) {
        br.generateSaleInvoiceHtml(context,
            invoice: _saleInvoice,
            isPrintAction: _isPrintAction,
            returnProductList: _returnProductList,
            returnProductPaymentStatus: _returnProductPaymentStatus,
            returnProductSubTotal: _returnProductSubTotal,
            returnProductTaxList: _returnProductTaxList,
            returnProductfinalTotal: _returnProductfinalTotal);
      } else {
        htmlContent = br.generateSaleInvoiceHtml(context,
            invoice: _saleInvoice,
            isPrintAction: _isPrintAction,
            returnProductList: _returnProductList,
            returnProductPaymentStatus: _returnProductPaymentStatus,
            returnProductSubTotal: _returnProductSubTotal,
            returnProductTaxList: _returnProductTaxList,
            returnProductfinalTotal: _returnProductfinalTotal);
      }
      return htmlContent;
    } catch (e) {
      print('Exception - saleInvoiceScreen.dart - _invoicePrintOrShare(): ' + e.toString());
      return null;
    }
  }

  Future _lazyLoading() async {
    try {
      int _dataLen = _saleInvoiceList.length;
      if (_scrollController1.position.pixels == _scrollController1.position.maxScrollExtent) {
        await _getSaleInvoice(false);
        if (_dataLen == _saleInvoiceList.length) {
          setState(() {
            _isLoaderHide = true;
          });
        }
      }
    } catch (e) {
      print('Exception - saleInvoiceScreen.dart - _lazyLoading(): ' + e.toString());
    }
  }

  // Future _lazyLoadingInvoiceWithoutTax() async {
  //   try {
  //     int _dataLen = _saleInvoiceWithoutTaxList.length;
  //     if (_scrollController2.position.pixels == _scrollController2.position.maxScrollExtent) {
  //       await _getSaleInvoiceWithoutTax(false);
  //       if (_dataLen == _saleInvoiceWithoutTaxList.length) {
  //         setState(() {
  //           _isLoaderHide = true;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print('Exception - saleInvoiceScreen.dart - _lazyLoadingInvoiceWithoutTax(): ' + e.toString());
  //   }
  // }

  Future _searchInvoices() async {
    try {
      Navigator.of(context)
          .push(SaleInvoiceFilter(
        _invoiceSearch,
      ))
          .then((value) async {
        if (value != null) {
          _invoiceSearch = value;
          if (_invoiceSearch.isSearch) {
            _saleInvoiceWithoutTaxList.clear();
            //  if (_orderSearch.isSearch) {
            if (_invoiceSearch.product != null && _invoiceSearch.product.id != null) {
              List<SaleInvoiceDetail> _saleInvoiceDetailList = await dbHelper.saleInvoiceDetailGetList(productId: _invoiceSearch.product.id);
              _searchByInvoiceIdList = (_saleInvoiceDetailList != null)
                  ? (_saleInvoiceDetailList.length != 0)
                      ? _saleInvoiceDetailList.map((invoiceDetail) => invoiceDetail.invoiceId).toList()
                      : null
                  : null;
            } else {
              _searchByInvoiceIdList = null;
            }
            _isDataLoaded = false;
            setState(() {});
            await _getSaleInvoice(true);
            _isDataLoaded = true;
            setState(() {});
            //    }
          }
        }
      });
      // Navigator.of(context)
      //     .push(SaleInvoiceFilter(
      //   _invoiceSearch,
      // ))
      //     .then((value) async {
      //   _invoiceSearch = value;

      //   if (_invoiceSearch != null) {
      //     if (_invoiceSearch.isSearch = true) {
      //       _saleInvoiceList.clear();
      //       _saleInvoiceWithoutTaxList.clear();
      //       if (_invoiceSearch.isSearch) {
      //         if (_invoiceSearch.product != null && _invoiceSearch.product.id != null) {
      //         } else {
      //           _searchByInvoiceIdList = null;
      //         }
      //         (_tabController.index == 0) ? await _getSaleInvoiceWithTax(true) : await _getSaleInvoiceWithoutTax(true);
      //         setState(() {});
      //       }
      //     }
      //   }
      // });
    } catch (e) {
      print('Exception - saleInvoiceScreen.dart - _searchInvoices(): ' + e.toString());
    }
  }

  Widget _filterTab() {
    try {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                onTap: () async {
                  _startIndex = 0;
                  _saleInvoiceList.clear();
                  _invoiceSearch.status = null;
                  await _getData();
                  setState(() {
                    _filterIndex = 0;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      color: _filterIndex == 0 ? Theme.of(context).primaryColor : Colors.transparent),
                  padding: EdgeInsets.all(4),
                  height: 30,
                  child: Center(
                    child: Text(global.appLocaleValues["txt_All"], style: _filterIndex == 0 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                onTap: () async {
                  _startIndex = 0;
                  _saleInvoiceList.clear();
                  _invoiceSearch.status = 'PAID';
                  await _getData();
                  setState(() {
                    _filterIndex = 1;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      color: _filterIndex == 1 ? Theme.of(context).primaryColor : Colors.transparent),
                  padding: EdgeInsets.all(4),
                  height: 30,
                  child: Center(
                    child: Text(global.appLocaleValues["lbl_paid"], style: _filterIndex == 1 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                onTap: () async {
                  _startIndex = 0;
                  _saleInvoiceList.clear();
                  _invoiceSearch.status = 'DUE';
                  await _getData();
                  setState(() {
                    _filterIndex = 2;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 4, left: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      color: _filterIndex == 2 ? Theme.of(context).primaryColor : Colors.transparent),
                  padding: EdgeInsets.all(4),
                  height: 30,
                  child: Center(
                    child: Text(global.appLocaleValues["lbl_due"], style: _filterIndex == 2 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                onTap: () async {
                  _startIndex = 0;
                  _saleInvoiceList.clear();
                  _invoiceSearch.status = 'CANCELLED';
                  await _getData();
                  setState(() {
                    _filterIndex = 3;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      color: _filterIndex == 3 ? Theme.of(context).primaryColor : Colors.transparent),
                  padding: EdgeInsets.all(4),
                  height: 30,
                  child: Center(
                    child: Text(global.appLocaleValues["txt_cancelled"], style: _filterIndex == 3 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Exception - saleInvoiceScreen.dart - _filterTab(): ' + e.toString());
      return null;
    }
  }

  Widget _saleInvoiceTab(List<SaleInvoice> _saleInvoiceList, int _tabIndex) {
    try {
      return RefreshIndicator(
          key: _refreshKey1,
          onRefresh: () async {
            await _getSaleInvoice(true);
          },
          child: (_isDataLoaded)
              ? (_saleInvoiceList.isNotEmpty)
                  ? Scrollbar(
                      child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _scrollController1,
                        itemCount: _saleInvoiceList.length + 1,
                        itemBuilder: (context, index) {
                          if (_saleInvoiceList.length == index) {
                            return (!_isLoaderHide)
                                ? Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : SizedBox();
                          }

                          return Card(
                            margin: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                            semanticContainer: true,
                            child: (_saleInvoiceList[index].finalTax > 0)
                                ? Ribbon(
                                    nearLength: 47,
                                    farLength: 20,
                                    title: global.appLocaleValues['rbn_with_tax'],
                                    titleStyle: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                    color: Colors.green,
                                    location: RibbonLocation.values[1],
                                    child: ListTileSaleInvoiceWidget(
                                      key: ValueKey(_saleInvoiceList[index].id),
                                      saleInvoice: _saleInvoiceList[index],
                                      a: widget.analytics,
                                      o: widget.observer,
                                      onDeletePressed: (_saleInvoice) async {
                                        await _deleteInvoice(_saleInvoice);
                                      },
                                      invoicePrintOrShare: (_saleInvoice, _isPrintAction, context) async {
                                        var htmlContent = await _invoicePrintOrShare(_saleInvoice, context, _isPrintAction);
                                        return htmlContent;
                                      },
                                      invoiceCancelOrRetrive: (_saleInvoice, _actionOfCancelInvoice, context) async {
                                        await _cancelOrRetriveInvoice(_saleInvoice, context, _actionOfCancelInvoice);
                                      },
                                    ),
                                  )
                                : ListTileSaleInvoiceWidget(
                                    key: ValueKey(_saleInvoiceList[index].id),
                                    saleInvoice: _saleInvoiceList[index],
                                    a: widget.analytics,
                                    o: widget.observer,
                                    onDeletePressed: (_saleInvoice) async {
                                      await _deleteInvoice(_saleInvoice);
                                    },
                                    invoicePrintOrShare: (_saleInvoice, _isPrintAction, context) async {
                                      var htmlContent = await _invoicePrintOrShare(_saleInvoice, context, _isPrintAction);
                                      return htmlContent;
                                    },
                                    invoiceCancelOrRetrive: (_saleInvoice, _actionOfCancelInvoice, context) async {
                                      await _cancelOrRetriveInvoice(_saleInvoice, context, _actionOfCancelInvoice);
                                    },
                                  ),
                          );
                        },
                      ),
                    ))
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.grey,
                          size: 180,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FittedBox(
                          child: Text(
                            (_tabIndex == 0 && br.getSystemFlagValue(global.systemFlagNameList.showSaleInvoicesSeprated) == 'true') ? global.appLocaleValues['tle_tax_invoice_empty_'] : global.appLocaleValues['tle_without_tax_invoice_empty_'],
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        )
                      ],
                    ))
              : Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ));
    } catch (e) {
      print('Exception - _saleInvoiceTab.dart - ${_tabIndex == 0 ? 'withTaxTab()' : 'withoutTaxstab()'}: ' + e.toString());
      return null;
    }
  }

  Future _getSaleInvoice(bool _isResetAction) async {
    try {
      if (_isResetAction) {
        _startIndex = 0;
        _saleInvoiceList = [];
        setState(() {});
      }
      if (_isRecordPending) {
        if (_saleInvoiceList.length != null && _saleInvoiceList.length > 0) {
          _startIndex = _saleInvoiceList.length;
        } else {
          _saleInvoiceList = [];
        }
        _saleInvoiceList += await dbHelper.saleInvoiceGetList(
            startIndex: _startIndex,
            fetchRecords: global.fetchRecords,
            // fetchTaxInvoices: (br.getSystemFlagValue(global.systemFlagNameList.showSaleInvoicesSeprated) == 'true') ? true : null,
            startDate: (_invoiceSearch != null)
                ? (_invoiceSearch.dateFrom != null)
                    ? _invoiceSearch.dateFrom
                    : null
                : null,
            endDate: (_invoiceSearch != null)
                ? (_invoiceSearch.dateTo != null)
                    ? _invoiceSearch.dateTo
                    : null
                : null,
            amountFrom: (_invoiceSearch != null)
                ? (_invoiceSearch.amountFrom != null)
                    ? _invoiceSearch.amountFrom
                    : null
                : null,
            amountTo: (_invoiceSearch != null)
                ? (_invoiceSearch.amountTo != null)
                    ? _invoiceSearch.amountTo
                    : null
                : null,
            accountId: (_invoiceSearch != null)
                ? (_invoiceSearch.account != null)
                    ? _invoiceSearch.account.id
                    : null
                : null,
            status: (_invoiceSearch != null)
                ? (_invoiceSearch.status != null)
                    ? _invoiceSearch.status
                    : null
                : null,
            orderByInvoiceDate: "desc",
            invoiceIdList: _searchByInvoiceIdList);
        for (int i = _startIndex; i < _saleInvoiceList.length; i++) {
          List<SaleInvoiceDetail> _saleInvoiceDetailList = await dbHelper.saleInvoiceDetailGetList(invoiceIdList: [_saleInvoiceList[i].id]);
          _saleInvoiceList[i].totalProducts = _saleInvoiceDetailList.length;

          _saleInvoiceList[i].returnProducts = await dbHelper.saleInvoiceReturnDetailGetCount(invoiceId: _saleInvoiceList[i].id);

          List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(invoiceId: _saleInvoiceList[i].id, isCancel: false);
          List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
          double _receivedAmount = 0;
          double _givenAmount = 0;
          if (_paymentList.length != 0) {
            _paymentList.forEach((item) {
              if (item.paymentType == 'RECEIVED') {
                _receivedAmount += item.amount;
              } else {
                _givenAmount += item.amount;
              }
            });
          }
          _saleInvoiceList[i].remainAmount = (_paymentList.length != 0) ? (_saleInvoiceList[i].netAmount - (_receivedAmount - _givenAmount)) : _saleInvoiceList[i].netAmount;
        }
        _startIndex += global.fetchRecords;
        //_getAccount();
        setState(() {
          (_saleInvoiceList.length.isFinite) ? _isLoaderHide = true : _isLoaderHide = false;
        });
      }
    } catch (e) {
      print('Exception - saleInvoiceScreen.dart - _getSaleInvoiceWithTax(): ' + e.toString());
    }
  }

  // Future _getSaleInvoiceWithoutTax(bool _isResetAction) async {
  //   try {
  //     if (_isResetAction) {
  //       _startIndex2 = 0;
  //       _saleInvoiceWithoutTaxList = [];
  //       setState(() {});
  //     }
  //     if (_isRecordPending) {
  //       if (_saleInvoiceWithoutTaxList.length != null && _saleInvoiceWithoutTaxList.length > 0) {
  //         _startIndex2 = _saleInvoiceWithoutTaxList.length;
  //       } else {
  //         _saleInvoiceWithoutTaxList = [];
  //       }
  //       _saleInvoiceWithoutTaxList += await dbHelper.saleInvoiceGetList(
  //           startIndex: _startIndex2,
  //           fetchRecords: global.fetchRecords,
  //           // fetchTaxInvoices: false,
  //           startDate: (_invoiceSearch != null)
  //               ? (_invoiceSearch.dateFrom != null)
  //                   ? _invoiceSearch.dateFrom
  //                   : null
  //               : null,
  //           endDate: (_invoiceSearch != null)
  //               ? (_invoiceSearch.dateTo != null)
  //                   ? _invoiceSearch.dateTo
  //                   : null
  //               : null,
  //           amountFrom: (_invoiceSearch != null)
  //               ? (_invoiceSearch.amountFrom != null)
  //                   ? _invoiceSearch.amountFrom
  //                   : null
  //               : null,
  //           amountTo: (_invoiceSearch != null)
  //               ? (_invoiceSearch.amountTo != null)
  //                   ? _invoiceSearch.amountTo
  //                   : null
  //               : null,
  //           accountId: (_invoiceSearch != null)
  //               ? (_invoiceSearch.account != null)
  //                   ? _invoiceSearch.account.id
  //                   : null
  //               : null,
  //           invoiceIdList: _searchByInvoiceIdList);
  //       for (int i = _startIndex2; i < _saleInvoiceWithoutTaxList.length; i++) {
  //         List<SaleInvoiceDetail> _saleInvoiceDetailList = await dbHelper.saleInvoiceDetailGetList(invoiceIdList: [_saleInvoiceWithoutTaxList[i].id]);
  //         _saleInvoiceWithoutTaxList[i].totalProducts = _saleInvoiceDetailList.length;

  //         _saleInvoiceWithoutTaxList[i].returnProducts = await dbHelper.saleInvoiceReturnDetailGetCount(invoiceId: _saleInvoiceWithoutTaxList[i].id);

  //         List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(invoiceId: _saleInvoiceWithoutTaxList[i].id, isCancel: false);
  //         List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
  //         double _receivedAmount = 0;
  //         double _givenAmount = 0;
  //         if (_paymentList.length != 0) {
  //           _paymentList.forEach((item) {
  //             if (item.paymentType == 'RECEIVED') {
  //               _receivedAmount += item.amount;
  //             } else {
  //               _givenAmount += item.amount;
  //             }
  //           });
  //         }
  //         _saleInvoiceWithoutTaxList[i].remainAmount = (_paymentList.length != 0) ? (_saleInvoiceWithoutTaxList[i]. netAmount - (_receivedAmount - _givenAmount)) : _saleInvoiceWithoutTaxList[i]. netAmount;
  //       }
  //       _startIndex2 += global.fetchRecords;
  //       //_getAccount();
  //       setState(() {
  //         (_saleInvoiceWithoutTaxList.length.isFinite) ? _isLoaderHide = true : _isLoaderHide = false;
  //       });
  //     }
  //   } catch (e) {
  //     print('Exception - saleInvoiceScreen.dart - _getSaleInvoiceWithoutTax(): ' + e.toString());
  //   }
  // }

  // Future _changeLayout(bool value) async {
  //   try {
  //     _isDataLoaded = false;
  //     setState(() {});
  //     await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.showSaleInvoicesSeprated, value.toString());
  //     await _getSaleInvoice(true);
  //     // await _getSaleInvoiceWithoutTax(true);
  //     _isDataLoaded = true;
  //     setState(() {});
  //   } catch (e) {
  //     print('Exception - saleInvoiceScreen.dart - _changeLayout(): ' + e.toString());
  //   }
  // }
}

class SaleInvoiceFilter extends ModalRoute<SaleInvoiceSearch> {
  SaleInvoiceSearch saleInvoiceSearch;
  SaleInvoiceFilter(this.saleInvoiceSearch);

  @override
  Duration get transitionDuration => Duration(milliseconds: 2);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.3);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return SaleInvoiceFilterForm(
        saleInvoiceSearch: saleInvoiceSearch,
        searchValue: (obj) {
          saleInvoiceSearch = obj;
        });
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

// ignore: must_be_immutable
class SaleInvoiceFilterForm extends StatefulWidget {
  final SaleInvoiceSearch saleInvoiceSearch;
  final ValueChanged<SaleInvoiceSearch> searchValue;
  SaleInvoiceFilterForm({this.saleInvoiceSearch, this.searchValue});
  @override
  _SaleInvoiceState createState() => _SaleInvoiceState(saleInvoiceSearch, searchValue);
}

class _SaleInvoiceState extends State<SaleInvoiceFilterForm> {
  SaleInvoiceSearch saleInvoiceSearch;
  final ValueChanged<SaleInvoiceSearch> searchValue;
  _SaleInvoiceState(this.saleInvoiceSearch, this.searchValue);

  var _cAmountRangeFrom = TextEditingController();
  var _cAmountRangeTo = TextEditingController();
  var _cDateRangeTo = TextEditingController();
  var _cDateRangeFrom = TextEditingController();
  // var _cPaymentMode = TextEditingController();
  var _cChooseAccount = TextEditingController();
  var _cChooseProduct = TextEditingController();
  var _fFromDateFocusNode = FocusNode();
  var _fToDateFocusNode = FocusNode();
  var _fChooseAccount = FocusNode();
  var _fChooseProduct = FocusNode();
  var _focusNode = FocusNode();
  bool isReset = true;
  BusinessRule br = BusinessRule();
  bool _dateFrom = false;
  String _dateRangeFrom2 = '', _dateRangeTo2 = '';
  Account _account;
  Product _product;

  SaleInvoiceSearch eSearch = SaleInvoiceSearch();

  void resetFilter() {
    resetConfermation();
  }

  void assignValue() {
    _fFromDateFocusNode.addListener(_selectdateListener);
    _fToDateFocusNode.addListener(_selectdateListener);

    if (saleInvoiceSearch != null) {
      _cChooseAccount.text = (saleInvoiceSearch.account != null)
          ? (saleInvoiceSearch.account.firstName != null)
              ? '${saleInvoiceSearch.account.firstName} ${saleInvoiceSearch.account.lastName}'
              //    ? '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + invoiceSearch.account.accountCode.toString().length))}${invoiceSearch.account.accountCode} - ${invoiceSearch.account.firstName} ${invoiceSearch.account.lastName}'
              : ''
          : '';
      _cChooseProduct.text = (saleInvoiceSearch.product != null)
          ? (saleInvoiceSearch.product.productCode != null)
              ? '${saleInvoiceSearch.product.name}'
              : ''
          : '';
      _cDateRangeFrom.text = (saleInvoiceSearch.dateFrom != null) ? '${DateFormat('dd-MM-yyyy').format(saleInvoiceSearch.dateFrom)}' : '';
      _dateRangeFrom2 = (saleInvoiceSearch.dateFrom != null) ? '${saleInvoiceSearch.dateFrom}' : '';
      _cDateRangeTo.text = (saleInvoiceSearch.dateTo != null) ? '${DateFormat('dd-MM-yyyy').format(saleInvoiceSearch.dateTo)}' : '';
      _dateRangeTo2 = (saleInvoiceSearch.dateTo != null) ? '${saleInvoiceSearch.dateTo}' : '';
      _cAmountRangeTo.text = (saleInvoiceSearch.amountTo != null) ? '${saleInvoiceSearch.amountTo}' : '';
      _cAmountRangeFrom.text = (saleInvoiceSearch.amountFrom != null) ? '${saleInvoiceSearch.amountFrom}' : '';
      _account = saleInvoiceSearch.account;
      _product = saleInvoiceSearch.product;
      saleInvoiceSearch.isSearch = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    assignValue();
    // if (accountSearch.searchBar != null || accountSearch.isCredit != null || accountSearch.isDue != null) {
    //   assignValue();
    // } else {
    //   accountSearch.isCredit = false;
    //   accountSearch.isDue = false;
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _selectAccount() async {
    try {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AccountSelectDialog(
                a: null,
                o: null,
                returnScreenId: 1,
                selectedAccount: (selectedAccount) {
                  _account = selectedAccount;
                },
              )));
      setState(() {
        if (_account.id != null) {
          _cChooseAccount.text = '${_account.firstName} ${_account.lastName}';
          //  '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode} - ${_account.firstName} ${_account.lastName}';
        }
      });
      //
      // if (_fChooseAccount.hasFocus) {
      //   await showDialog(
      //       context: context,
      //       builder: (_) {
      //         return AccountSelectDialog(
      //           a: widget.analytics,
      //           o: widget.observer,
      //           returnScreenId: 1,
      //           selectedAccount: (account) {
      //             _account = account;
      //           },
      //         );
      //       });
      //   setState(() {
      //     _cChooseAccount.text =
      //         '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode} - ${_account.firstName} ${_account.lastName}';
      //     FocusScope.of(context).requestFocus(_focusNode);
      //   });
      // }
    } catch (e) {
      print('Exception - saleInvoiceSearchDialog.dart - _selectAccount(): ' + e.toString());
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    try {
      // choose dob
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != DateTime(2000)) {
        setState(() {
          //   _date=picked;
          if (_dateFrom) {
            _cDateRangeFrom.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(picked.toString().substring(0, 10)));
            _dateRangeFrom2 = picked.toString().substring(0, 10);
          } else {
            _cDateRangeTo.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(picked.toString().substring(0, 10)));
            _dateRangeTo2 = picked.toString().substring(0, 10);
          }
        });
      }
      FocusScope.of(context).requestFocus(_focusNode);
    } catch (e) {
      print('Exception - saleInvoiceSearchDialog.dart - _selectDate(): ' + e.toString());
    }
  }

  Future<Null> _selectdateListener() async {
    try {
      if (_fFromDateFocusNode.hasFocus || _fToDateFocusNode.hasFocus) {
        if (_fFromDateFocusNode.hasFocus) {
          _dateFrom = true;
        } else {
          _dateFrom = false;
        }
        _selectDate(context); //open date picker
      }
    } catch (e) {
      print('Exception - saleInvoiceSearchDialog.dart - _selectdateListener(): ' + e.toString());
    }
  }

  Future _selectProduct() async {
    try {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductSelectDialog(
                a: null,
                o: null,
                returnScreenId: 1,
                onValueSelected: (product) {
                  _product = product[0];
                },
              )));
      setState(() {
        if (_product.id != null) {
          _cChooseProduct.text = '${_product.name}';
          FocusScope.of(context).requestFocus(_focusNode);
        }
      });
      // if (_fChooseProduct.hasFocus) {
      //   await showDialog(
      //       context: context,
      //       builder: (_) {
      //         return ProductSelectDialog(
      //           a: widget.analytics,
      //           o: widget.observer,
      //           returnScreenId: 1,
      //           onValueSelected: (product) {
      //             _product = product[0];
      //           },
      //         );
      //       });
      //   setState(() {
      //     _cChooseProduct.text = '${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + _product.productCode.toString().length))}${_product.productCode} - ${_product.name}';
      //     FocusScope.of(context).requestFocus(_focusNode);
      //   });
      // }
    } catch (e) {
      print('Exception - saleInvoiceSearchDialog.dart - _selectProduct(): ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 56.0,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        MdiIcons.filter,
                        color: Colors.white,
                        size: 21,
                      ),
                      SizedBox(
                        width: 31.0,
                      ),
                      Text(global.appLocaleValues['tle_search_sale_invoices'], style: Theme.of(context).appBarTheme.titleTextStyle),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: InkWell(
                      onTap: () {
                        resetFilter();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            MdiIcons.restore,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                          Text('${global.appLocaleValues['btn_reset']}', style: Theme.of(context).primaryTextTheme.headline2),
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(global.appLocaleValues['lbl_choose_ac'], style: Theme.of(context).primaryTextTheme.headline3),
                  ),
                  TextFormField(
                    controller: _cChooseAccount,
                    focusNode: _fChooseAccount,
                    readOnly: true,
                    decoration: InputDecoration(border: nativeTheme().inputDecorationTheme.border, prefixIcon: Icon(Icons.people)),
                    onTap: () async {
                      await _selectAccount();
                    },
                  ),
                ],
              ),
            )),
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8),
          child: Text(global.appLocaleValues['tle_choose_service'], style: Theme.of(context).primaryTextTheme.headline3),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                child: TextFormField(
                  controller: _cChooseProduct,
                  focusNode: _fChooseProduct,
                  onTap: () async {
                    await _selectProduct();
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product')
                          ? global.appLocaleValues['tle_choose_product']
                          : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service')
                              ? global.appLocaleValues['tle_choose_service']
                              : global.appLocaleValues['tle_choose_both'],
                      border: nativeTheme().inputDecorationTheme.border,
                      prefixIcon: Icon(Icons.local_mall)),
                ),
              ),
            )),
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8),
          child: Text('${global.appLocaleValues['lbl_enter_amount']}', style: Theme.of(context).primaryTextTheme.headline3),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: _cAmountRangeFrom,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          maxLength: 5,
                          decoration: InputDecoration(hintText: global.appLocaleValues['lbl_from_amount'], border: nativeTheme().inputDecorationTheme.border, counterText: '', prefixIcon: Icon(Icons.credit_card)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: _cAmountRangeTo,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          maxLength: 5,
                          decoration: InputDecoration(hintText: global.appLocaleValues['lbl_to_amount'], border: nativeTheme().inputDecorationTheme.border, counterText: '', prefixIcon: Icon(Icons.credit_card)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8),
          child: Text('${global.appLocaleValues['lbl_date_err_req']}', style: Theme.of(context).primaryTextTheme.headline3),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: _cDateRangeFrom,
                          focusNode: _fFromDateFocusNode,
                          readOnly: true,
                          decoration: InputDecoration(hintText: global.appLocaleValues['lbl_date_from'], border: nativeTheme().inputDecorationTheme.border, counterText: '', prefixIcon: Icon(Icons.calendar_today)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: _cDateRangeTo,
                          focusNode: _fToDateFocusNode,
                          readOnly: true,
                          maxLength: 5,
                          decoration: InputDecoration(hintText: global.appLocaleValues['lbl_date_to'], border: nativeTheme().inputDecorationTheme.border, counterText: '', prefixIcon: Icon(Icons.calendar_today)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          MdiIcons.close,
                          color: Theme.of(context).primaryColorDark,
                          size: 18.0,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text('${global.appLocaleValues['btn_cancel']}', style: Theme.of(context).primaryTextTheme.headline3)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  flex: 5,
                  child: TextButton(
                    onPressed: () {
                      eSearch.isSearch = true;
                      eSearch.account = _account;
                      eSearch.product = _product;
                      eSearch.isSearch = true;
                      eSearch.amountFrom = (_cAmountRangeFrom.text != '') ? double.parse(_cAmountRangeFrom.text) : null;
                      eSearch.amountTo = (_cAmountRangeTo.text != '') ? double.parse(_cAmountRangeTo.text) : null;
                      eSearch.dateFrom = (_dateRangeFrom2 != '') ? DateTime.parse(_dateRangeFrom2) : null;
                      eSearch.dateTo = (_dateRangeTo2 != '') ? DateTime.parse(_dateRangeTo2) : null;
                      searchValue(eSearch);
                      Navigator.pop(context, eSearch);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          '${global.appLocaleValues['btn_search']}',
                          style: Theme.of(context).primaryTextTheme.headline2,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> resetConfermation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${global.appLocaleValues['lbl_reset']}', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${global.appLocaleValues['txt_filter']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('${global.appLocaleValues['btn_cancel']}'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('${global.appLocaleValues['btn_ok']}'),
              onPressed: () {
                setState(() {
                  isReset = false;
                  eSearch.isSearch = true;
                  eSearch.account = null;
                  eSearch.product = null;
                  eSearch.amountFrom = null;
                  eSearch.amountTo = null;
                  eSearch.dateFrom = null;
                  eSearch.dateTo = null;
                  eSearch.isSearch = true;

                  Navigator.of(context).pop();
                  Navigator.pop(context, eSearch);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
