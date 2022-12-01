// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/dialogs/productSelectDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/businessRule.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentSaleQuotesModel.dart';
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/models/saleQuoteDetailModel.dart';
import 'package:accounting_app/models/saleQuoteSearchModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/saleInvoiceAddScreen.dart';
import 'package:accounting_app/screens/saleOrderAddScreen.dart';
import 'package:accounting_app/screens/salesQuoteAddScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:accounting_app/widgets/listTileSaleQuoteWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ribbon/ribbon.dart';

class SalesQuoteScreen extends BaseRoute {
  final Account account;
  SalesQuoteScreen({@required a, @required o, this.account}) : super(a: a, o: o, r: 'SalesQuoteScreen');
  @override
  _SalesQuoteScreenState createState() => _SalesQuoteScreenState(this.account);
}

class _SalesQuoteScreenState extends BaseRouteState {
  List<SaleQuote> _saleQuoteList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SaleQuoteSearch _quoteSearch = SaleQuoteSearch();
  List<int> _searchByOrderIdList;
  final Account account;
  bool _isLoaderHide = false;
  bool _isDataLoaded = false;
  bool _isRecordPending = true;
  var _refreshKey1 = GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController1 = ScrollController();
  int _filterIndex;
  int _startIndex2 = 0;
  int filterCount = 0;

  _SalesQuoteScreenState(this.account) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          '${global.appLocaleValues['sal_quote']}',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
          // (br.getSystemFlagValue(global.systemFlagNameList.showSaleOrdersSeprated) == 'true')
          //     ? IconButton(
          //         tooltip: '${global.appLocaleValues['tt_show_combined']}',
          //         icon: Icon(Icons.view_day),
          //         iconSize: 20,
          //         onPressed: () async {
          //           await _changeLayout(false);
          //         },
          //       )
          //     : SizedBox(),

          IconButton(
            icon: Icon(MdiIcons.filter),
            iconSize: 20,
            onPressed: () async {
              await _searchOrders();
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SaleQuoteAddSreen(
                        a: widget.analytics,
                        o: widget.observer,
                        quote: SaleQuote(),
                        returnScreenId: 0,
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
            Expanded(child: _saleQuoteTab(_saleQuoteList)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController1.addListener(_lazyLoadingOrderWithoutTax);
  }

  @override
  void initState() {
    super.initState();
    _filterIndex = 0;
    if (account != null) {
      _quoteSearch.account = account;
    }
    _getData();
  }

  Future _getData() async {
    try {
      await _getSaleQuoteWithoutTax(false);

      _scrollController1.addListener(_lazyLoadingOrderWithoutTax);
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - SalesQuoteScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _cancelOrRetriveOrder(SaleQuote _saleQuote, context, bool _actionOfCancelOrder) async {
    try {
      if (_actionOfCancelOrder) //check it is action of cancel invoice
      {
        try {
          AlertDialog dialog = AlertDialog(
            shape: nativeTheme().dialogTheme.shape,
            title: Text(global.appLocaleValues['tle_cancel_order'], style: Theme.of(context).primaryTextTheme.headline1),
            content: (global.appLanguage['name'] == 'English')
                ? Text(
                    '${global.appLocaleValues['txt_cancel_invoice']} "${br.generateAccountName(_saleQuote.account)} ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleQuote.saleQuoteNumber.toString().length))}${_saleQuote.saleQuoteNumber}-${_saleQuote.versionNumber}" ?',
                    style: Theme.of(context).primaryTextTheme.headline3)
                : Text(
                    '"${br.generateAccountName(_saleQuote.account)} ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleQuote.saleQuoteNumber.toString().length))}${_saleQuote.saleQuoteNumber}-${_saleQuote.versionNumber}" ${global.appLocaleValues['txt_cancel_invoice']} ?',
                    style: Theme.of(context).primaryTextTheme.headline3),
            actions: <Widget>[
              TextButton(
                child: Text(global.appLocaleValues['btn_no'], style: Theme.of(context).primaryTextTheme.headline3),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(global.appLocaleValues['btn_yes'], style: Theme.of(context).primaryTextTheme.headline2),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _saleQuote.status = 'CANCELLED';
                  await dbHelper.saleQuoteUpdate(quote: _saleQuote, updateFrom: 2);
                  setState(() {});
                  // try {
                  //   AlertDialog dialog =  AlertDialog(
                  //     shape: nativeTheme().dialogTheme.shape,
                  //     title: Text(
                  //       global.appLocaleValues['tle_cancel_payments'],
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //     content: Container(
                  //       width: MediaQuery.of(context).size.width - 40,
                  //       height: MediaQuery.of(context).size.height * 0.1,
                  //       child: Column(
                  //         children: <Widget>[
                  //           Row(
                  //             children: <Widget>[
                  //               Expanded(
                  //                 child: (global.appLanguage['name'] == 'English') ? Text('${global.appLocaleValues['txt_cancel_payments']} "${br.generateAccountName(_saleQuote.account)} ${_saleQuote.saleQuoteNumber}" ?') : Text('"${br.generateAccountName(_saleQuote.account)} ${_saleQuote.saleQuoteNumber}" ${global.appLocaleValues['txt_cancel_payments']} ?'),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     actions: <Widget>[
                  //       TextButton(
                  //         child: Text(
                  //           global.appLocaleValues['btn_no'],
                  //           style: TextStyle(color: Theme.of(context).primaryColor),
                  //         ),
                  //         onPressed: () async {
                  //           Navigator.of(context).pop();
                  //           await _getSaleQuoteWithoutTax(true);
                  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //             content: Text('${global.appLocaleValues['txt_order_cancel_success']}'),
                  //           ));
                  //         },
                  //       ),
                  //       TextButton(
                  //         child: Text(global.appLocaleValues['btn_yes']),
                  //         onPressed: () async {
                  //           // await _cancelOrRetrivePayments(_saleQuote.id, true);
                  //           Navigator.of(context).pop();
                  //           await _getSaleQuoteWithoutTax(true);
                  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //             content: Text('${global.appLocaleValues['txt_order_cancel_success']}'),
                  //           ));
                  //         },
                  //       ),
                  //     ],
                  //   );
                  //   showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
                  // } catch (e) {
                  //   print('Exception - SalesQuoteScreen.dart - _cancelOrRetriveOrder(): ' + e.toString());
                  // }
                },
              ),
            ],
          );
          showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
        } catch (e) {
          print('Exception - SalesQuoteScreen.dart - _cancelOrRetriveOrder(): ' + e.toString());
        }
      } else {
        // await _cancelOrRetrivePayments(_saleQuote.id, false);
        List<SaleQuoteDetail> _saleQuoteDetailList = await dbHelper.saleQuoteDetailGetList(orderIdList: [_saleQuote.id]);
        bool _isSame = true;
        _saleQuoteDetailList.forEach((element) {
          if (element.quantity != element.invoicedQuantity) {
            _isSame = false;
          }
        });
        _saleQuote.status = (_isSame)
            ? (_saleQuote.saleOrderId != null && _saleQuote.saleOrderNumber != null)
                ? "ORDERED"
                : "INVOICED"
            : "OPEN";
        await dbHelper.saleQuoteUpdate(quote: _saleQuote, updateFrom: 2).then((value) {
          _saleQuoteList.clear();
        });
        await _getSaleQuoteWithoutTax(true);

        setState(() {});
      }
    } catch (e) {
      print('Exception - SalesQuoteScreen.dart - _cancelOrRetriveOrder(): ' + e.toString());
    }
  }

  Future _deleteOrder(SaleQuote _saleQuote) async {
    try {
      AlertDialog _dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['tle_delete_order'],
          style: Theme.of(context).primaryTextTheme.headline1,
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  (global.appLanguage['name'] == 'English')
                      ? Expanded(
                          child: Text(
                          '${global.appLocaleValues['txt_delete']} "${br.generateAccountName(_saleQuote.account)} ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleQuote.saleQuoteNumber.toString().length))}${_saleQuote.saleQuoteNumber}-${_saleQuote.versionNumber}" ?',
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ))
                      : Expanded(
                          child: Text(
                              '"${br.generateAccountName(_saleQuote.account)} ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleQuote.saleQuoteNumber.toString().length))}${_saleQuote.saleQuoteNumber}-${_saleQuote.versionNumber}" ${global.appLocaleValues['txt_delete']} ?',
                              style: Theme.of(context).primaryTextTheme.headline3)),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            // textColor: Theme.of(context).primaryColor,
            child: Text(global.appLocaleValues['btn_cancel'], style: Theme.of(context).primaryTextTheme.headline3),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_delete'], style: Theme.of(context).primaryTextTheme.headline2),
            onPressed: () async {
              Navigator.of(context).pop();
              // bool _isUsed = await dbHelper.saleQuoteisUsed(_saleQuote.id);
              // if (!_isUsed) {
              List<SaleQuoteDetail> _saleQuoteDetailList = await dbHelper.saleQuoteDetailGetList(orderIdList: [_saleQuote.id]);
              await dbHelper.saleQuoteDetailTaxDelete(quoteDetailIdList: _saleQuoteDetailList.map((orderDetail) => orderDetail.id).toList());
              await dbHelper.saleQuoteTaxDelete(_saleQuote.id);
              await dbHelper.saleQuoteDetailDelete(quoteId: _saleQuote.id);
              // await _deletePayment(_saleQuote);
              int _result = await dbHelper.saleQuoteDelete(_saleQuote.id);
              if (_result == 1) {
                _saleQuoteList.removeWhere((f) => f.id == _saleQuote.id);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('${global.appLocaleValues['sal_quote_dlt']}'),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('${global.appLocaleValues['sal_quot_dlt_fail']}'),
                ));
              }
              // } else {
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //     backgroundColor: Colors.red,
              //     content: Text('${global.appLocaleValues['txt_order_dlt_failed']}'),
              //   ));
              // }
            },
          ),
        ],
      );
      showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
    } catch (e) {
      print('Exception - SalesQuoteScreen.dart - _deleteOrder(): ' + e.toString());
    }
  }

  // Future _deletePayment(SaleQuote _saleQuote) async {
  //   try {
  //     AlertDialog _dialog = AlertDialog(
  //       shape: nativeTheme().dialogTheme.shape,
  //       title: Text(global.appLocaleValues['tle_payment_dlt'], style: Theme.of(context).primaryTextTheme.headline1),
  //       content: Container(
  //         height: MediaQuery.of(context).size.height * 0.1,
  //         width: MediaQuery.of(context).size.width - 40,
  //         child: Column(
  //           children: <Widget>[
  //             Row(
  //               children: <Widget>[
  //                 Expanded(child: (global.appLanguage['name'] == 'English') ? Text('${global.appLocaleValues['txt_payment_dlt']} "${br.generateAccountName(_saleQuote.account)} ${_saleQuote.saleQuoteNumber}" ?', style: Theme.of(context).primaryTextTheme.headline3) : Text('"${br.generateAccountName(_saleQuote.account)} ${_saleQuote.saleQuoteNumber}" ${global.appLocaleValues['txt_payment_dlt']} ?', style: Theme.of(context).primaryTextTheme.headline3)),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: <Widget>[
  //         TextButton(
  //           // textColor: Theme.of(context).primaryColor,
  //           child: Text(global.appLocaleValues['btn_no'], style: Theme.of(context).primaryTextTheme.headline3),
  //           onPressed: () {
  //             Navigator.of(context, rootNavigator: true).pop();
  //           },
  //         ),
  //         TextButton(
  //           child: Text(global.appLocaleValues['btn_yes'], style: Theme.of(context).primaryTextTheme.headline2),
  //           onPressed: () async {
  //             Navigator.of(context).pop();
  //             List<PaymentSaleQuotes> _paymentOrder = await dbHelper.paymentSaleQuoteGetList(orderIdList: [_saleQuote.id]);
  //             await dbHelper.paymentDetailDelete(paymentIdList: _paymentOrder.map((paymentOrder) => paymentOrder.paymentId).toList());
  //             await dbHelper.paymentSaleQuoteDelete(paymentIdList: _paymentOrder.map((paymentOrder) => paymentOrder.paymentId).toList());
  //             await dbHelper.paymentDelete(paymentIdList: _paymentOrder.map((paymentOrder) => paymentOrder.paymentId).toList());
  //           },
  //         ),
  //       ],
  //     );
  //     await showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
  //   } catch (e) {
  //     print('Exception - SalesQuoteScreen.dart - _deletePayment(): ' + e.toString());
  //   }
  // }

  Future<String> _orderPrintOrShare(SaleQuote _saleQuote, context, bool _isPrintAction) async {
    try {
      global.isAppOperation = true;
      List<Account> _accountList = await dbHelper.accountGetList(accountId: _saleQuote.accountId);
      _saleQuote.account = _accountList[0];
      _saleQuote.quoteDetailList = await dbHelper.saleQuoteDetailGetList(orderIdList: [_saleQuote.id]);
      _saleQuote.quoteTaxList = await dbHelper.saleQuoteTaxGetList(saleQuoteId: _saleQuote.id);
      _saleQuote.quoteDetailTaxList = await dbHelper.saleQuoteDetailTaxGetList(quoteDetailIdList: _saleQuote.quoteDetailList.map((orderDetail) => orderDetail.id).toList());
      //  String _address = (_account.addressLine1.isNotEmpty && _account.state.isNotEmpty && _account.country.isNotEmpty && _account.pincode != null) ? ' ${_account.addressLine1}, ${_account.city}, ${_account.state}, ${_account.country}, ${_account.pincode}' : ' ${_account.city}';
      // List<PaymentSaleOrder> _paymentSaleOrderList = [];
      // List<Payment> _paymentList = [];
      // List<PaymentDetail> _paymentDetailList = [];
      var htmlContent;

      // _paymentSaleOrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [_saleQuote.id], isCancel: false);
      // _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentSaleOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());
      // _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());
      // if (_paymentList.length != 0) {
      //   _paymentList.forEach((item) {
      //     if (item.paymentType == 'RECEIVED') {
      //       _paymentDetailList.forEach((paymentDetail) {
      //         if (item.id == paymentDetail.paymentId) {
      //           if (paymentDetail.paymentMode == 'Cheque') {
      //             _saleQuote.paymentByCheque += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'Cash') {
      //             _saleQuote.paymentByCash += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'Card') {
      //             _saleQuote.paymentByCard += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'EWallet' || paymentDetail.paymentMode == 'eWallet') {
      //             _saleQuote.paymentByEWallet += paymentDetail.amount;
      //           } else {
      //             _saleQuote.paymentByNetBanking += paymentDetail.amount;
      //           }
      //         }
      //       });
      //     }
      //   });
      // }
      if (_isPrintAction != null) {
        br.generateSaleQuoteHtml(
          context,
          quote: _saleQuote,
          isPrintAction: _isPrintAction,
        );
      } else {
        htmlContent = br.generateSaleQuoteHtml(
          context,
          quote: _saleQuote,
          isPrintAction: _isPrintAction,
        );
      }
      return htmlContent;
    } catch (e) {
      print('Exception - SalesQuoteScreen.dart - _orderPrintOrShare(): ' + e.toString());
      return null;
    }
  }

  Future _lazyLoadingOrderWithoutTax() async {
    try {
      int _dataLen = _saleQuoteList.length;
      if (_scrollController1.position.pixels == _scrollController1.position.maxScrollExtent) {
        await _getSaleQuoteWithoutTax(false);
        if (_dataLen == _saleQuoteList.length) {
          setState(() {
            _isLoaderHide = true;
          });
        }
      }
    } catch (e) {
      print('Exception - SalesQuoteScreen.dart - _lazyLoadingOrderWithoutTax(): ' + e.toString());
    }
  }

  Future _searchOrders() async {
    try {
      Navigator.of(context)
          .push(SaleQuoteFilter(
        _quoteSearch,
      ))
          .then((value) async {
        if (value != null) {
          _quoteSearch = value;
          if (_quoteSearch.isSearch) {
            _saleQuoteList.clear();
            if (_quoteSearch.product != null && _quoteSearch.product.id != null) {
              List<SaleQuoteDetail> _saleQuoteDetailList = await dbHelper.saleQuoteDetailGetList(productId: _quoteSearch.product.id);
              _searchByOrderIdList = (_saleQuoteDetailList.length > 0) ? _saleQuoteDetailList.map((orderDetail) => orderDetail.saleQuoteId).toList() : [];
            } else {
              _searchByOrderIdList = null;
            }
            _isDataLoaded = false;
            setState(() {});
            await _getSaleQuoteWithoutTax(true);
            _isDataLoaded = true;
            setState(() {});
            //    }
          }
        }
      });
    } catch (e) {
      print('Exception - SalesQuoteScreen.dart - _searchOrders(): ' + e.toString());
    }
  }

  Widget _saleQuoteTab(List<SaleQuote> _saleQuoteList) {
    try {
      return RefreshIndicator(
          key: _refreshKey1,
          onRefresh: () async {
            await _getSaleQuoteWithoutTax(false);
          },
          child: (_isDataLoaded)
              ? (_saleQuoteList.isNotEmpty)
                  ? Scrollbar(
                      child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          controller: _scrollController1,
                          itemCount: _saleQuoteList.length,
                          itemBuilder: (context, index) {
                            if (_saleQuoteList.length == index) {
                              return (!_isLoaderHide)
                                  ? Center(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : SizedBox();
                            }

                            return Card(
                              margin: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                              semanticContainer: true,
                              child: (_saleQuoteList[index].finalTax > 0)
                                  ? Ribbon(
                                      nearLength: 47,
                                      farLength: 20,
                                      title: global.appLocaleValues['rbn_with_tax'],
                                      titleStyle: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                      color: Colors.green,
                                      location: RibbonLocation.values[1],
                                      child: ListTileSaleQuoteWidget(
                                        key: ValueKey(_saleQuoteList[index].id),
                                        saleQuote: _saleQuoteList[index],
                                        a: widget.analytics,
                                        o: widget.observer,
                                        onGenerateInvoicePressed: (_saleQuote) async {
                                          SaleInvoice _saleInvoice = await br.generateInvoice(_saleQuote, dbHelper);
                                          _saleInvoice.salesQuoteId = _saleQuote.id;
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (BuildContext context) => SaleInvoiceAddSreen(
                                                    a: widget.analytics,
                                                    o: widget.observer,
                                                    invoice: _saleInvoice,
                                                    screenId: 1,
                                                  )));
                                        },
                                        onGenerateOrderPressed: (_saleQuote) async {
                                          SaleOrder _saleOrder = await br.generateOrder(_saleQuote, dbHelper);
                                          _saleOrder.salesQuoteId = _saleQuote.id;
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (BuildContext context) => SaleOrderAddSreen(
                                                    a: widget.analytics,
                                                    o: widget.observer,
                                                    order: _saleOrder,
                                                    screenId: 1,
                                                  )));
                                        },
                                        onDeletePressed: (_saleQuote) async {
                                          await _deleteOrder(_saleQuote);
                                        },
                                        orderPrintOrShare: (_saleQuote, _isPrintAction, context) async {
                                          var htmlContent = await _orderPrintOrShare(_saleQuote, context, _isPrintAction);
                                          return htmlContent;
                                        },
                                        orderCancelOrRetrive: (_saleQuote, _actionOfCancelOrder, context) async {
                                          await _cancelOrRetriveOrder(_saleQuote, context, _actionOfCancelOrder);
                                        },
                                      ),
                                    )
                                  : ListTileSaleQuoteWidget(
                                      key: ValueKey(_saleQuoteList[index].id),
                                      saleQuote: _saleQuoteList[index],
                                      a: widget.analytics,
                                      o: widget.observer,
                                      onGenerateInvoicePressed: (_saleQuote) async {
                                        SaleInvoice _saleInvoice = await br.generateInvoice(_saleQuote, dbHelper);
                                        _saleInvoice.salesQuoteId = _saleQuote.id;
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (BuildContext context) => SaleInvoiceAddSreen(
                                                  a: widget.analytics,
                                                  o: widget.observer,
                                                  invoice: _saleInvoice,
                                                  screenId: 1,
                                                )));
                                      },
                                      onGenerateOrderPressed: (_saleQuote) async {
                                        SaleOrder _saleOrder = await br.generateOrder(_saleQuote, dbHelper);
                                        _saleOrder.salesQuoteId = _saleQuote.id;
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (BuildContext context) => SaleOrderAddSreen(
                                                  a: widget.analytics,
                                                  o: widget.observer,
                                                  order: _saleOrder,
                                                  screenId: 1,
                                                )));
                                      },
                                      onDeletePressed: (_saleQuote) async {
                                        await _deleteOrder(_saleQuoteList[index]);
                                      },
                                      orderPrintOrShare: (_saleQuote, _isPrintAction, context) async {
                                        var htmlContent = await _orderPrintOrShare(_saleQuote, context, _isPrintAction);
                                        return htmlContent;
                                      },
                                      orderCancelOrRetrive: (_saleQuote, _actionOfCancelOrder, context) async {
                                        await _cancelOrRetriveOrder(_saleQuote, context, _actionOfCancelOrder);
                                      },
                                    ),
                            );
                          }),
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
                            (br.getSystemFlagValue(global.systemFlagNameList.showSaleOrdersSeprated) == 'true') ? global.appLocaleValues['tle_tax_order_empty_'] : global.appLocaleValues['tle_without_tax_order_empty_'],
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        )
                      ],
                    ))
              : Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ));
    } catch (e) {
      print('Exception - _saleOrderTab.dart - ${'withTaxTab()'}: ' + e.toString());
      return null;
    }
  }

  Widget _filterTab() {
    try {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: SizedBox(
          height: 40,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    height: 30,
                    width: 50,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        _startIndex2 = 0;
                        _saleQuoteList = [];
                        _quoteSearch.status = null;
                        _quoteSearch.isWithTax = null;
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
                ),
                SizedBox(
                  height: 30,
                  width: 70,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      _startIndex2 = 0;
                      _saleQuoteList = [];
                      _filterIndex = 1;
                      _quoteSearch.status = 'OPEN';
                      _quoteSearch.isWithTax = null;
                      await _getData();
                      setState(() {});
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
                        child: Text(global.appLocaleValues["txt_open"], style: _filterIndex == 1 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 80,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      _startIndex2 = 0;
                      _saleQuoteList = [];
                      _quoteSearch.status = 'ORDERED';
                      _quoteSearch.isWithTax = null;
                      _filterIndex = 2;
                      await _getData();
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 0, left: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                          color: _filterIndex == 2 ? Theme.of(context).primaryColor : Colors.transparent),
                      padding: EdgeInsets.all(4),
                      height: 30,
                      child: Center(
                        child: Text("Order", style: _filterIndex == 2 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 80,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      _startIndex2 = 0;
                      _saleQuoteList = [];
                      _quoteSearch.status = 'INVOICED';
                      _quoteSearch.isWithTax = null;
                      _filterIndex = 3;
                      await _getData();
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 4, left: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                          color: _filterIndex == 3 ? Theme.of(context).primaryColor : Colors.transparent),
                      padding: EdgeInsets.all(4),
                      height: 30,
                      child: Center(
                        child: Text(global.appLocaleValues["txt_invoiced"], style: _filterIndex == 3 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 80,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      _startIndex2 = 0;
                      _saleQuoteList = [];
                      _filterIndex = 4;
                      _quoteSearch.status = 'CANCELLED';
                      _quoteSearch.isWithTax = null;
                      await _getData();
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                          color: _filterIndex == 4 ? Theme.of(context).primaryColor : Colors.transparent),
                      padding: EdgeInsets.all(4),
                      height: 30,
                      child: Center(
                        child: Text(global.appLocaleValues["txt_cancelled"], style: _filterIndex == 4 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 80,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      _startIndex2 = 0;
                      _saleQuoteList = [];
                      _quoteSearch.status = null;
                      _quoteSearch.isWithTax = true;
                      _filterIndex = 5;
                      await _getData();
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 4, left: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                          color: _filterIndex == 5 ? Theme.of(context).primaryColor : Colors.transparent),
                      padding: EdgeInsets.all(4),
                      height: 30,
                      child: Center(
                        child: Text(global.appLocaleValues["tle_with_tax"], style: _filterIndex == 5 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      height: 30,
                      width: 90,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _startIndex2 = 0;
                          _saleQuoteList = [];
                          _quoteSearch.status = null;
                          _quoteSearch.isWithTax = false;
                          _filterIndex = 6;
                          await _getData();
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                              color: _filterIndex == 6 ? Theme.of(context).primaryColor : Colors.transparent),
                          padding: EdgeInsets.all(4),
                          height: 30,
                          child: Center(
                            child: Text(global.appLocaleValues["tle_without_tax"], style: _filterIndex == 6 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print('Exception - _saleOrderTab.dart - _filterTab(): ' + e.toString());
      return null;
    }
  }

  Future _getSaleQuoteWithoutTax(bool _isResetAction) async {
    try {
      if (_isResetAction) {
        _startIndex2 = 0;
        _saleQuoteList = [];
        setState(() {});
      }
      if (_isRecordPending) {
        if (_saleQuoteList.length != null && _saleQuoteList.length > 0) {
          _startIndex2 = _saleQuoteList.length;
        } else {
          _saleQuoteList = [];
        }
        _saleQuoteList += await dbHelper.saleQuoteGetList(
            startIndex: _startIndex2,
            fetchRecords: global.fetchRecords,
            // fetchTaxOrders: true,
            startDate: (_quoteSearch != null)
                ? (_quoteSearch.dateFrom != null)
                    ? _quoteSearch.dateFrom
                    : null
                : null,
            endDate: (_quoteSearch != null)
                ? (_quoteSearch.dateTo != null)
                    ? _quoteSearch.dateTo
                    : null
                : null,
            amountFrom: (_quoteSearch != null)
                ? (_quoteSearch.amountFrom != null)
                    ? _quoteSearch.amountFrom
                    : null
                : null,
            amountTo: (_quoteSearch != null)
                ? (_quoteSearch.amountTo != null)
                    ? _quoteSearch.amountTo
                    : null
                : null,
            accountId: (_quoteSearch != null)
                ? (_quoteSearch.account != null)
                    ? _quoteSearch.account.id
                    : null
                : null,
            status: (_quoteSearch != null)
                ? (_quoteSearch.status != null)
                    ? _quoteSearch.status
                    : null
                : null,
            orderByQuoteDate: 'DESC',
            isWithTax: _quoteSearch.isWithTax,
            orderIdList: _searchByOrderIdList);

        for (int i = _startIndex2; i < _saleQuoteList.length; i++) {
          List<SaleQuoteDetail> _saleQuoteDetailList = await dbHelper.saleQuoteDetailGetList(orderIdList: [_saleQuoteList[i].id]);
          _saleQuoteList[i].totalProducts = _saleQuoteDetailList.length;
          _saleQuoteList[i].quoteDetailList = _saleQuoteDetailList;

          List<PaymentSaleQuotes> _paymentSaleQuoteList = await dbHelper.paymentSaleQuoteGetList(orderIdList: [_saleQuoteList[i].id], isCancel: false);
          List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentSaleQuoteList.map((paymentOrder) => paymentOrder.paymentId).toList());

          double _givenAmount = 0;
          if (_paymentList.length != 0) {
            _paymentList.forEach((item) {
              if (item.paymentType == 'RECEIVED') {
                _saleQuoteList[i].advanceAmount += item.amount;
              } else {
                _givenAmount += item.amount;
              }
            });
          }
          _saleQuoteList[i].remainAmount = (_paymentList.length != 0) ? (_saleQuoteList[i].netAmount - (_saleQuoteList[i].advanceAmount - _givenAmount)) : _saleQuoteList[i].netAmount;
          // _saleQuoteList[i].isEditable = await dbHelper.saleQuoteisUsed(_saleQuoteList[i].id);
          // _saleQuoteList[i].isEditable = !_saleQuoteList[i].isEditable;
          print('_saleOrderWithoutTaxList2 ${_saleQuoteList.length}');
        }
        _startIndex2 += global.fetchRecords;
        // _getAccount();
        setState(() {
          (_saleQuoteList.length.isFinite) ? _isLoaderHide = true : _isLoaderHide = false;
        });
      }
      print('_saleOrderWithoutTaxList3 ${_saleQuoteList.length}');
    } catch (e) {
      print('Exception - SalesQuoteScreen.dart - _getSaleOrderWithoutTax(): ' + e.toString());
    }
  }

  // Future _cancelOrRetrivePayments(int _saleOrderId, bool _isCancelling) async {
  //   try {
  //     List<PaymentSaleOrder> _paymentSaleOrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [_saleOrderId]);
  //     List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentSaleOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());
  //     List<PaymentDetail> _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());

  //     _paymentSaleOrderList.forEach((item) async {
  //       item.isCancel = _isCancelling;
  //       await dbHelper.paymentSaleOrderUpdate(item);
  //     });

  //     _paymentDetailList.forEach((item) async {
  //       item.isCancel = _isCancelling;
  //       await dbHelper.paymentDetailUpdate(item);
  //     });

  //     _paymentList.forEach((item) async {
  //       item.isCancel = _isCancelling;
  //       await dbHelper.paymentUpdate(item);
  //     });
  //   } catch (e) {
  //     print('Exception - SalesQuoteScreen.dart - _cancelOrRetrivePayments(): ' + e.toString());
  //   }
  // }

}

class SaleQuoteFilter extends ModalRoute<SaleQuoteSearch> {
  SaleQuoteSearch saleQuoteSearch;
  SaleQuoteFilter(this.saleQuoteSearch);

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
    return SaleQuoteFilterForm(
        saleQuoteSearch: saleQuoteSearch,
        searchValue: (obj) {
          saleQuoteSearch = obj;
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
class SaleQuoteFilterForm extends StatefulWidget {
  final SaleQuoteSearch saleQuoteSearch;
  final ValueChanged<SaleQuoteSearch> searchValue;
  SaleQuoteFilterForm({this.saleQuoteSearch, this.searchValue});
  @override
  _SaleQuoteState createState() => _SaleQuoteState(saleQuoteSearch, searchValue);
}

class _SaleQuoteState extends State<SaleQuoteFilterForm> {
  SaleQuoteSearch saleQuoteSearch;
  final ValueChanged<SaleQuoteSearch> searchValue;
  _SaleQuoteState(this.saleQuoteSearch, this.searchValue);
  BusinessRule br = BusinessRule();
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

  bool _dateFrom = false;
  String _dateRangeFrom2 = '', _dateRangeTo2 = '';
  Account _account;
  Product _product;

  SaleQuoteSearch eSearch = SaleQuoteSearch();

  void resetFilter() {
    resetConfermation();
  }

  void assignValue() {
    _fFromDateFocusNode.addListener(_selectdateListener);
    _fToDateFocusNode.addListener(_selectdateListener);

    if (saleQuoteSearch != null) {
      _cChooseAccount.text = (saleQuoteSearch.account != null)
          ? (saleQuoteSearch.account.firstName != null)
              ? '${saleQuoteSearch.account.firstName} ${saleQuoteSearch.account.lastName}'
              //    ? '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + invoiceSearch.account.accountCode.toString().length))}${invoiceSearch.account.accountCode} - ${invoiceSearch.account.firstName} ${invoiceSearch.account.lastName}'
              : ''
          : '';
      _cChooseProduct.text = (saleQuoteSearch.product != null)
          ? (saleQuoteSearch.product.productCode != null)
              ? '${saleQuoteSearch.product.name}'
              : ''
          : '';
      _cDateRangeFrom.text = (saleQuoteSearch.dateFrom != null) ? '${DateFormat('dd-MM-yyyy').format(saleQuoteSearch.dateFrom)}' : '';
      _dateRangeFrom2 = (saleQuoteSearch.dateFrom != null) ? '${saleQuoteSearch.dateFrom}' : '';
      _cDateRangeTo.text = (saleQuoteSearch.dateTo != null) ? '${DateFormat('dd-MM-yyyy').format(saleQuoteSearch.dateTo)}' : '';
      _dateRangeTo2 = (saleQuoteSearch.dateTo != null) ? '${saleQuoteSearch.dateTo}' : '';
      _cAmountRangeTo.text = (saleQuoteSearch.amountTo != null) ? '${saleQuoteSearch.amountTo}' : '';
      _cAmountRangeFrom.text = (saleQuoteSearch.amountFrom != null) ? '${saleQuoteSearch.amountFrom}' : '';
      _account = saleQuoteSearch.account;
      _product = saleQuoteSearch.product;
      saleQuoteSearch.isSearch = false;
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
      print('Exception - saleOrderSearchDialog.dart - _selectAccount(): ' + e.toString());
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
      print('Exception - saleOrderSearchDialog.dart - _selectDate(): ' + e.toString());
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
      print('Exception - saleOrderSearchDialog.dart - _selectdateListener(): ' + e.toString());
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
      print('Exception - saleOrderSearchDialog.dart - _selectProduct(): ' + e.toString());
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
                        size: 20,
                      ),
                      SizedBox(
                        width: 31.0,
                      ),
                      Text(
                        '${global.appLocaleValues['sal_quote']}',
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      ),
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
                          Text(
                            '${global.appLocaleValues['btn_reset']}',
                            style: Theme.of(context).primaryTextTheme.headline2,
                          ),
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
                children: [
                  Text(
                    global.appLocaleValues['lbl_choose_ac'],
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: _cChooseAccount,
                          focusNode: _fChooseAccount,
                          readOnly: true,
                          decoration: InputDecoration(border: nativeTheme().inputDecorationTheme.border, prefixIcon: Icon(Icons.people), hintText: 'Choose account'),
                          onTap: () async {
                            await _selectAccount();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    global.appLocaleValues['tle_choose_product'],
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: TextFormField(
                      controller: _cChooseProduct,
                      focusNode: _fChooseProduct,
                      onTap: () async {
                        await _selectProduct();
                      },
                      readOnly: true,
                      decoration: InputDecoration(hintText: 'Choose product/services', border: nativeTheme().inputDecorationTheme.border, prefixIcon: Icon(Icons.local_mall)),
                    ),
                  ),
                ],
              ),
            )),
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${global.appLocaleValues['lbl_enter_amount']}',
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
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
                  ),
                ],
              ),
            )),
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${global.appLocaleValues['lbl_date_err_req']}',
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
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
                        Text(
                          '${global.appLocaleValues['btn_cancel']}',
                          style: Theme.of(context).primaryTextTheme.headline3,
                        )
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
          title: Text('${global.appLocaleValues['lbl_reset']}', style: Theme.of(context).primaryTextTheme.headline1),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${global.appLocaleValues['txt_filter']}', style: Theme.of(context).primaryTextTheme.headline3),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('${global.appLocaleValues['btn_cancel']}', style: Theme.of(context).primaryTextTheme.headline2),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('${global.appLocaleValues['btn_ok']}', style: Theme.of(context).primaryTextTheme.headline2),
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
