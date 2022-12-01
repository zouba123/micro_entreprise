// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables

import 'dart:core';
import 'dart:io';

import 'package:accounting_app/models/paymentPurchaseInvoiceModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/paymentSaleOrderModel.dart';
import 'package:accounting_app/models/purchaseInvoiceDetailModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailTaxModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnTaxModel.dart';
import 'package:accounting_app/models/saleOrderDetailModel.dart';
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/screens/purchaseInvoiceScreen.dart';
import 'package:accounting_app/screens/saleInvoiceAddScreen.dart';
import 'package:accounting_app/screens/saleOrderScreen.dart';
import 'package:accounting_app/widgets/listTilePurchaseInvoiceWidget.dart';
import 'package:accounting_app/widgets/listTileSaleOrderWidget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleQuoteDetailModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/paymentDetailScreen.dart';
import 'package:accounting_app/screens/paymentScreen.dart';
import 'package:accounting_app/screens/saleInvoiceScreen.dart';
import 'package:accounting_app/screens/salesQuoteScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/listTileSaleInvoiceWidget.dart';
import 'package:accounting_app/widgets/listTileSaleQuoteWidget.dart';
import 'package:ribbon/ribbon.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountDetailScreen extends BaseRoute {
  final Account account;
  final int screenId;
  AccountDetailScreen({@required a, @required o, this.screenId, @required this.account}) : super(a: a, o: o, r: 'AccountDetailScreen');
  @override
  _AccountDetailScreenState createState() => _AccountDetailScreenState(this.screenId, this.account);
}

class _AccountDetailScreenState extends BaseRouteState {
  List<SaleInvoice> _saleInvoiceList = [];
  List<SaleQuote> _saleQuoteList = [];
  List<SaleOrder> _saleOrderList = [];
  List<PurchaseInvoice> _purchaseInvoiceList = [];
  // List<PurchaseInvoiceReturn> _pTransactionGroupIdList = [];
  int screenId;
  List<Payment> _paymentList = [];
  // double _totalSpent = 0;
  // double _totalPaid = 0;
  // double _totalDue = 0;
  bool _isPaymentPrintAction = false;
  Account account;
  bool _isDataLoaded = false;
  int _currentIndex = 0;
  TextEditingController _cMsg = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  // var _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;
  int customerType; // 1 = customer, 2 = supplier, 3 = both

  _AccountDetailScreenState(this.screenId, this.account) : super();

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () {
        if (screenId != null) {
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
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          // key: _scaffoldKey,
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                if (screenId != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => DashboardScreen(
                            o: widget.observer,
                            a: widget.analytics,
                          )));
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            title: Text(
              '${br.generateAccountName(account)}',
              style: Theme.of(context).appBarTheme.titleTextStyle,
              // '${br.generateAccountName(account)}'
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorWeight: 10,
              indicatorColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              tabs: [Center(child: Text('${global.appLocaleValues['tab_ac']}')), Center(child: Text('${global.appLocaleValues['tle_profile']}'))],
              onTap: (index) {
                _currentIndex = index;
                // _tabController.animateTo(_currentIndex);
                setState(() {});
              },
            ),
          ),
          body: _isDataLoaded
              ? TabBarView(controller: _tabController, children: [
                  SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height + 700,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${global.currency.symbol} ${account.totalSpent.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                              style: TextStyle(color: Colors.green, fontSize: 30),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(global.appLocaleValues['lbl_total_spent'], style: Theme.of(context).primaryTextTheme.headline3),
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${global.currency.symbol} ${account.totalPaid.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                      style: TextStyle(color: Colors.green, fontSize: 25),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        global.appLocaleValues['lbl_total_paid'],
                                        style: Theme.of(context).primaryTextTheme.headline3,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 40,
                                  child: VerticalDivider(),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Column(
                                      children: [
                                        (account.totalDue >= 0)
                                            ? Text('${global.currency.symbol} ${account.totalDue.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: TextStyle(color: Colors.red, fontSize: 25))
                                            : Text('${global.currency.symbol} ${(account.totalDue * -1).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: TextStyle(color: Colors.green, fontSize: 25)),
                                        (account.totalDue >= 0)
                                            ? Text(
                                                global.appLocaleValues['lbl_due'],
                                                style: Theme.of(context).primaryTextTheme.headline3,
                                              )
                                            : Text(
                                                global.appLocaleValues['lbl_credit'],
                                                style: Theme.of(context).primaryTextTheme.headline3,
                                              )
                                      ],
                                    ))
                              ],
                            ),
                            Divider(),
                            SizedBox(
                              height: 30,
                            ),
                            (customerType == 1)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${global.appLocaleValues['rec_sal_quo']}',
                                        style: Theme.of(context).primaryTextTheme.subtitle1,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => SalesQuoteScreen(
                                                      a: widget.analytics,
                                                      o: widget.observer,
                                                      account: account,
                                                    )));
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                global.appLocaleValues['btn_view_all'],
                                                style: Theme.of(context).primaryTextTheme.subtitle2,
                                              ),
                                              Icon(Icons.keyboard_arrow_right_outlined)
                                            ],
                                          ))
                                    ],
                                  )
                                : SizedBox(),
                            (customerType == 1)
                                ? (_isDataLoaded)
                                    ? (_saleQuoteList.length > 0)
                                        ? ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _saleQuoteList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return (_saleQuoteList[index].finalTax > 0)
                                                  ? Card(
                                                      child: Ribbon(
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
                                                          account: account,
                                                          o: widget.observer,
                                                          orderPrintOrShare: (_saleQuote, _isPrintAction, context) async {
                                                            var htmlContent = await _orderPrintOrShare(_saleQuote, context, _isPrintAction);
                                                            return htmlContent;
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  : Card(
                                                      child: ListTileSaleQuoteWidget(
                                                        key: ValueKey(_saleQuoteList[index].id),
                                                        saleQuote: _saleQuoteList[index],
                                                        a: widget.analytics,
                                                        account: account,
                                                        o: widget.observer,
                                                        orderPrintOrShare: (_saleQuote, _isPrintAction, context) async {
                                                          var htmlContent = await _orderPrintOrShare(_saleQuote, context, _isPrintAction);
                                                          return htmlContent;
                                                        },
                                                      ),
                                                    );
                                            })
                                        : Container(
                                            margin: const EdgeInsets.only(top: 10),
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(top: 20, bottom: 10),
                                                  child: Icon(
                                                    Icons.request_quote,
                                                    color: Colors.grey,
                                                    size: 50,
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    '${global.appLocaleValues['rec_sal_quo_des']}',
                                                    style: TextStyle(color: Colors.grey),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            ),
                                          )
                                    : Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Center(
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      )
                                : SizedBox(),
                            (customerType == 1)
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${global.appLocaleValues['tle_recent_sale_order']}',
                                          style: Theme.of(context).primaryTextTheme.subtitle1,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => SaleOrderScreen(
                                                        a: widget.analytics,
                                                        o: widget.observer,
                                                        account: account,
                                                      )));
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  global.appLocaleValues['btn_view_all'],
                                                  style: Theme.of(context).primaryTextTheme.subtitle2,
                                                ),
                                                Icon(Icons.keyboard_arrow_right_outlined)
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            (customerType == 1)
                                ? (_isDataLoaded)
                                    ? (_saleOrderList.length > 0)
                                        ? ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _saleOrderList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return (_saleOrderList[index].finalTax > 0)
                                                  ? Card(
                                                      child: Ribbon(
                                                        nearLength: 47,
                                                        farLength: 20,
                                                        title: global.appLocaleValues['rbn_with_tax'],
                                                        titleStyle: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                                        color: Colors.green,
                                                        location: RibbonLocation.values[1],
                                                        child: ListTileSaleOrderWidget(
                                                          key: ValueKey(_saleOrderList[index].id),
                                                          saleOrder: _saleOrderList[index],
                                                          a: widget.analytics,
                                                          o: widget.observer,
                                                          onGenerateInvoicePressed: (_saleOrder) async {
                                                            SaleInvoice _saleInvoice = await br.generateInvoiceFromOrder(_saleOrder, dbHelper);
                                                            _saleInvoice.salesOrderId = _saleOrder.id;
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                                builder: (BuildContext context) => SaleInvoiceAddSreen(
                                                                      a: widget.analytics,
                                                                      o: widget.observer,
                                                                      invoice: _saleInvoice,
                                                                      screenId: 2,
                                                                    )));
                                                          },
                                                          orderPrintOrShare: (_saleOrder, _isPrintAction, context) async {
                                                            var htmlContent = await _orderPrintOrShare(_saleOrder, context, _isPrintAction);
                                                            return htmlContent;
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  : Card(
                                                      child: ListTileSaleOrderWidget(
                                                        key: ValueKey(_saleOrderList[index].id),
                                                        saleOrder: _saleOrderList[index],
                                                        a: widget.analytics,
                                                        o: widget.observer,
                                                        onGenerateInvoicePressed: (_saleOrder) async {
                                                          SaleInvoice _saleInvoice = await br.generateInvoiceFromOrder(_saleOrder, dbHelper);
                                                          _saleInvoice.salesOrderId = _saleOrder.id;
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (BuildContext context) => SaleInvoiceAddSreen(
                                                                    a: widget.analytics,
                                                                    o: widget.observer,
                                                                    invoice: _saleInvoice,
                                                                    screenId: 2,
                                                                  )));
                                                        },
                                                        orderPrintOrShare: (_saleOrder, _isPrintAction, context) async {
                                                          var htmlContent = await _orderPrintOrShare(_saleOrder, context, _isPrintAction);
                                                          return htmlContent;
                                                        },
                                                      ),
                                                    );
                                            })
                                        : Container(
                                            margin: const EdgeInsets.only(top: 10),
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(top: 20, bottom: 10),
                                                  child: Icon(
                                                    Icons.request_quote,
                                                    color: Colors.grey,
                                                    size: 50,
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    '${global.appLocaleValues['tle_recent_sale_order_empty_msg']}',
                                                    style: TextStyle(color: Colors.grey),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            ),
                                          )
                                    : Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Center(
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      )
                                : SizedBox(),
                            (customerType == 1)
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${global.appLocaleValues['tle_recent_sale']}',
                                          style: Theme.of(context).primaryTextTheme.subtitle1,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => SaleInvoiceScreen(
                                                        a: widget.analytics,
                                                        o: widget.observer,
                                                        account: account,
                                                      )));
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  global.appLocaleValues['btn_view_all'],
                                                  style: Theme.of(context).primaryTextTheme.subtitle2,
                                                ),
                                                Icon(Icons.keyboard_arrow_right_outlined)
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            (customerType == 1)
                                ? (_isDataLoaded)
                                    ? (_saleInvoiceList.length > 0)
                                        ? ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _saleInvoiceList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return (_saleInvoiceList[index].finalTax > 0)
                                                  ? Card(
                                                      child: Ribbon(
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
                                                          account: account,
                                                          o: widget.observer,
                                                          invoicePrintOrShare: (_saleQuote, _isPrintAction, context) async {
                                                            var htmlContent = await _orderPrintOrShare(_saleQuote, context, _isPrintAction);
                                                            return htmlContent;
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  : Card(
                                                      child: ListTileSaleInvoiceWidget(
                                                        key: ValueKey(_saleInvoiceList[index].id),
                                                        saleInvoice: _saleInvoiceList[index],
                                                        a: widget.analytics,
                                                        account: account,
                                                        o: widget.observer,
                                                        invoicePrintOrShare: (_saleQuote, _isPrintAction, context) async {
                                                          var htmlContent = await _orderPrintOrShare(_saleQuote, context, _isPrintAction);
                                                          return htmlContent;
                                                        },
                                                      ),
                                                    );
                                            })
                                        : Container(
                                            margin: const EdgeInsets.only(top: 10),
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(top: 20, bottom: 10),
                                                  child: Icon(
                                                    Icons.shopping_cart,
                                                    color: Colors.grey,
                                                    size: 50,
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    '${global.appLocaleValues['tle_recent_sale_empty_msg']}',
                                                    style: TextStyle(color: Colors.grey),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            ),
                                          )
                                    : Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Center(
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      )
                                : SizedBox(),
                            (customerType == 2)
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${global.appLocaleValues['tle_recent_purchase']}',
                                          style: Theme.of(context).primaryTextTheme.subtitle1,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => PurchaseInvoiceScreen(
                                                        a: widget.analytics,
                                                        o: widget.observer,
                                                        account: account,
                                                      )));
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  global.appLocaleValues['btn_view_all'],
                                                  style: Theme.of(context).primaryTextTheme.subtitle2,
                                                ),
                                                Icon(Icons.keyboard_arrow_right_outlined)
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            (customerType == 2)
                                ? (_isDataLoaded)
                                    ? (_purchaseInvoiceList.length > 0)
                                        ? ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _purchaseInvoiceList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return (_purchaseInvoiceList[index].finalTax > 0)
                                                  ? Card(
                                                      child: Ribbon(
                                                        nearLength: 47,
                                                        farLength: 20,
                                                        title: global.appLocaleValues['rbn_with_tax'],
                                                        titleStyle: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                                        color: Colors.green,
                                                        location: RibbonLocation.values[1],
                                                        child: ListTilePurchaseInvoiceWidget(
                                                          key: ValueKey(_purchaseInvoiceList[index].id),
                                                          purchaseInvoice: _purchaseInvoiceList[index],
                                                          tabIndex: 0,
                                                          a: widget.analytics,
                                                          o: widget.observer,
                                                          invoicePrintOrShare: (_saleInvoice, _isPrintAction, context) async {
                                                            var html = await _invoicePrintOrShare(_saleInvoice, context, _isPrintAction);
                                                            return html;
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  : Card(
                                                      child: ListTilePurchaseInvoiceWidget(
                                                        key: ValueKey(_purchaseInvoiceList[index].id),
                                                        purchaseInvoice: _purchaseInvoiceList[index],
                                                        tabIndex: 0,
                                                        a: widget.analytics,
                                                        o: widget.observer,
                                                        invoicePrintOrShare: (_saleInvoice, _isPrintAction, context) async {
                                                          var html = await _invoicePrintOrShare(_saleInvoice, context, _isPrintAction);
                                                          return html;
                                                        },
                                                      ),
                                                    );
                                            })
                                        : Container(
                                            margin: const EdgeInsets.only(top: 10),
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(top: 20, bottom: 10),
                                                  child: Icon(
                                                    Icons.shopping_cart,
                                                    color: Colors.grey,
                                                    size: 50,
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    '${global.appLocaleValues['tle_recent_purchase_empty_msg']}',
                                                    style: TextStyle(color: Colors.grey),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            ),
                                          )
                                    : Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Center(
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      )
                                : SizedBox(),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    global.appLocaleValues['tle_recent_payments'],
                                    style: Theme.of(context).primaryTextTheme.subtitle1,
                                  ),
                                  _paymentList.length > 0
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => PaymentScreen(
                                                      a: widget.analytics,
                                                      o: widget.observer,
                                                      account: account,
                                                    )));
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                global.appLocaleValues['btn_view_all'],
                                                style: Theme.of(context).primaryTextTheme.subtitle2,
                                              ),
                                              Icon(Icons.keyboard_arrow_right_outlined)
                                            ],
                                          ))
                                      : SizedBox()
                                ],
                              ),
                            ),
                            _paymentList.length > 0
                                ? Expanded(
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: _paymentList.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Card(
                                            child: ListTile(
                                                contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
                                                leading: CircleAvatar(
                                                  backgroundColor: Theme.of(context).primaryColorLight,
                                                  foregroundColor: Colors.black,
                                                  radius: 25,
                                                  child: Text(
                                                    '${global.currency.symbol} ${_paymentList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                title: Text(
                                                  '${br.generateAccountName(_paymentList[index].account)}',
                                                  style: TextStyle(fontSize: 14),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                subtitle: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_paymentList[index].transactionDate)}')],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        (_paymentList[index].invoiceNumber != null)
                                                            ? Text(
                                                                'ref: ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _paymentList[index].invoiceNumber.toString().length))}${_paymentList[index].invoiceNumber}')
                                                            : (_paymentList[index].isSaleInvoiceReturnRef)
                                                                ? Text('ref: ${global.appLocaleValues['ref_sales_return']}')
                                                                : (_paymentList[index].isPurchaseInvoiceReturnRef)
                                                                    ? Text('ref: ${global.appLocaleValues['ref_purchase_return']}')
                                                                    : (_paymentList[index].isExpenseRef)
                                                                        ? Text('ref: ${global.appLocaleValues['lbl_expense_small']}')
                                                                        : (_paymentList[index].isSaleOrderRef)
                                                                            ? Text('ref: ${global.appLocaleValues['lbl_sale_order_']} ${_paymentList[index].orderNumber}')
                                                                            : SizedBox()
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                isThreeLine: true,
                                                onTap: () {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) => PaymentDetailScreen(
                                                            a: widget.analytics,
                                                            o: widget.observer,
                                                            payment: _paymentList[index],
                                                          )));
                                                },
                                                trailing: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.2,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          (_paymentList[index].paymentType == 'RECEIVED')
                                                              ? Text('${_paymentList[index].paymentType}', textAlign: TextAlign.center, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                                                              : Text('${_paymentList[index].paymentType}', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          (_paymentList[index].isCancel == true)
                                                              ? Text('${global.appLocaleValues['status_cancelled']}', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                                                              : SizedBox(
                                                                  width: 0,
                                                                )
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuButton(
                                                      itemBuilder: (context) => [
                                                        PopupMenuItem(
                                                          child: ListTile(
                                                            contentPadding: EdgeInsets.zero,
                                                            title: Row(
                                                              children: <Widget>[
                                                                Padding(
                                                                  padding: const EdgeInsets.only(right: 10),
                                                                  child: Icon(
                                                                    Icons.remove_red_eye,
                                                                    color: Theme.of(context).primaryColor,
                                                                  ),
                                                                ),
                                                                Text(global.appLocaleValues['lt_view']),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                              Navigator.of(context).push(MaterialPageRoute(
                                                                  builder: (context) => PaymentDetailScreen(
                                                                        a: widget.analytics,
                                                                        o: widget.observer,
                                                                        payment: _paymentList[index],
                                                                      )));
                                                            },
                                                          ),
                                                        ),
                                                        PopupMenuItem(
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
                                                              _isPaymentPrintAction = true;
                                                              global.isAppOperation = true;
                                                              await br.generatePaymentReceiptHtml(context, payment: _paymentList[index], isPrintAction: _isPaymentPrintAction);
                                                            },
                                                          ),
                                                        ),
                                                        PopupMenuItem(
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
                                                              _isPaymentPrintAction = false;
                                                              global.isAppOperation = true;
                                                              await br.generatePaymentReceiptHtml(context, payment: _paymentList[index], isPrintAction: _isPaymentPrintAction);
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                          );
                                        }),
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 20, bottom: 10),
                                          child: Icon(
                                            Icons.credit_card,
                                            color: Colors.grey,
                                            size: 50,
                                          ),
                                        ),
                                        FittedBox(
                                          child: Text(
                                            '${global.appLocaleValues['tle_recent_payments_empty_msg']}',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: _height / 30,
                          ),
                          Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8, right: 8),
                                  child: Center(
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.grey[200]), image: account.imagePath != null && account.imagePath != '' ? DecorationImage(image: FileImage(File(account.imagePath))) : null),
                                            child: Container(
                                              height: 120,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColorDark,
                                                borderRadius: BorderRadius.circular(10.0),
                                                border: Border.all(color: Colors.grey[200]),
                                              ),
                                              child: Center(
                                                child: Text("${account.firstName[0]} ${account.lastName[0]}", textAlign: TextAlign.center, style: TextStyle(fontSize: 35, color: Colors.white)),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    subtitle: Text("${account.businessName}", style: Theme.of(context).primaryTextTheme.headline3),
                                    title: Text("${br.generateAccountName(account)}", style: Theme.of(context).primaryTextTheme.headline1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //
                          Column(
                            children: [
                              // (account.gstNo != '')
                              //     ? Card(
                              //         child: ListTile(
                              //           title: Text("${global.appLocaleValues['lbl_gst_no_']}", style: Theme.of(context).primaryTextTheme.headline1),
                              //           subtitle:  Text('${account.gstNo}', style: Theme.of(context).primaryTextTheme.headline3),
                              //         ),
                              //       )
                              //     : SizedBox(),
                              (account.email != '')
                                  ? Card(
                                      child: ListTile(
                                        title: Text("${global.appLocaleValues['txt_email']}", style: Theme.of(context).primaryTextTheme.headline1),
                                        subtitle: Text(account.email, style: Theme.of(context).primaryTextTheme.headline3),
                                        onTap: () async {
                                          global.isAppOperation = true;
                                          final MailOptions mailOptions = MailOptions(
                                            body: '',
                                            subject: '',
                                            recipients: ['${account.email}'],
                                            isHTML: true,
                                            bccRecipients: [],
                                            ccRecipients: [],
                                          );

                                          await FlutterMailer.send(mailOptions);
                                        },
                                        trailing: IconButton(
                                          icon: Icon(Icons.content_copy),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: '${account.email}'));
                                            showToast(global.appLocaleValues['txt_copied']);
                                          },
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              (account.mobile != '')
                                  ? Card(
                                      child: ListTile(
                                        title: Text("${global.appLocaleValues['txt_mobile_no']}", style: Theme.of(context).primaryTextTheme.headline1),
                                        subtitle: Text('+${account.mobileCountryCode} ${account.mobile}', style: Theme.of(context).primaryTextTheme.headline3),
                                        onTap: () async {
                                          global.isAppOperation = true;
                                          launch('tel:+${account.mobileCountryCode}${account.mobile}');
                                        },
                                        trailing: IconButton(
                                          icon: Icon(Icons.content_copy),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: '+${account.mobileCountryCode} ${account.mobile}'));
                                            showToast(global.appLocaleValues['txt_copied']);
                                          },
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              (account.phone != '')
                                  ? Card(
                                      child: ListTile(
                                        title: Text("${global.appLocaleValues['txt_phone_no']}", style: Theme.of(context).primaryTextTheme.headline1),
                                        subtitle: Text('+${account.phoneCountryCode} ${account.phone}', style: Theme.of(context).primaryTextTheme.headline3),
                                        onTap: () async {
                                          global.isAppOperation = true;
                                          launch('tel:+${account.phoneCountryCode}${account.phone}');
                                        },
                                        trailing: IconButton(
                                          icon: Icon(Icons.content_copy),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: '+${account.mobileCountryCode} ${account.mobile}'));
                                            showToast(global.appLocaleValues['txt_copied']);
                                          },
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              (br.generateAccountAddress(account) != '')
                                  ? Card(
                                      child: ListTile(
                                        title: Text("${global.appLocaleValues['txt_address']}", style: Theme.of(context).primaryTextTheme.headline1),
                                        subtitle: Text('${br.generateAccountAddress(account)}', style: Theme.of(context).primaryTextTheme.headline3),
                                        trailing: IconButton(
                                          icon: Icon(Icons.content_copy),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: '${br.generateAccountAddress(account)}'));
                                            showToast(global.appLocaleValues['txt_copied']);
                                          },
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              Card(
                                child: ListTile(
                                  title: Text("${global.appLocaleValues['lbl_ac_type']}", style: Theme.of(context).primaryTextTheme.headline1),
                                  subtitle: Text((account.accountType == ',Customer,Supplier,') ? '${global.appLocaleValues['txt_customer_and_supplier']}' : '${(account.accountType)}', style: Theme.of(context).primaryTextTheme.headline3),
                                ),
                              ),
                              (account.gender != null)
                                  ? Card(
                                      child: ListTile(
                                        title: Text("${global.appLocaleValues['lbl_gender']}", style: Theme.of(context).primaryTextTheme.headline1),
                                        subtitle: Text('${account.gender}', style: Theme.of(context).primaryTextTheme.headline3),
                                      ),
                                    )
                                  : SizedBox(),
                              (account.birthdate != null)
                                  ? Card(
                                      child: ListTile(
                                        title: Text("${global.appLocaleValues['txt_birthday']}", style: Theme.of(context).primaryTextTheme.headline1),
                                        subtitle: Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(account.birthdate)}', style: Theme.of(context).primaryTextTheme.headline3),
                                      ),
                                    )
                                  : SizedBox(),
                              (account.anniversary != null)
                                  ? Card(
                                      child: ListTile(
                                      title: Text("${global.appLocaleValues['lbl_anniversary']}", style: Theme.of(context).primaryTextTheme.headline1),
                                      subtitle: Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(account.anniversary)}', style: Theme.of(context).primaryTextTheme.headline3),
                                    ))
                                  : SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 60),
                  ),
                ])
              : Center(child: CircularProgressIndicator()),

          bottomSheet: Container(
             color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: (account.mobile != null && account.mobile != '') || (account.phone != null && account.phone != '') ? Theme.of(context).primaryColor : Theme.of(context).primaryColorLight,
                      ),
                      onPressed: (account.mobile != null && account.mobile != '') || (account.phone != null && account.phone != '')
                          ? () async {
                              String _contact = '';
                              if (account.phone != '') {
                                _contact = await br.selectMobileNumber(['+${account.mobileCountryCode} ${account.mobile}', '+${account.phoneCountryCode} ${account.phone}'], context);
                              } else {
                                _contact = '+${account.mobileCountryCode} ${account.mobile}';
                              }
                              AlertDialog dialog = AlertDialog(
                                shape: nativeTheme().dialogTheme.shape,
                                title: Text(global.appLocaleValues['tle_whtsapp_msg'], style: Theme.of(context).primaryTextTheme.headline1),
                                content: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: _cMsg,
                                    decoration: InputDecoration(icon: Icon(FontAwesomeIcons.whatsapp), hintText: global.appLocaleValues['lbl_whtsapp_msg']),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return global.appLocaleValues['lbl_whtsapp_msg'];
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      _cMsg.text = '';
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(global.appLocaleValues['btn_cancel'], style: Theme.of(context).primaryTextTheme.headline2),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        Navigator.of(context, rootNavigator: true).pop();
                                        Navigator.of(context).pop();
                                        global.isAppOperation = true;
                                        var whatsappUrl = "whatsapp://send?phone=$_contact&text=${_cMsg.text.trim()}";
                                        await canLaunch(whatsappUrl) ? launch(whatsappUrl) : showToast(global.appLocaleValues['err_whtsapp']);
                                      }
                                      _cMsg.text = '';
                                    },
                                    child: Text(global.appLocaleValues['btn_send'], style: Theme.of(context).primaryTextTheme.headline2),
                                  ),
                                ],
                              );
                              showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
                            }
                          : () {},
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        Icons.message,
                        color: (account.mobile != null && account.mobile != '') || (account.phone != null && account.phone != '') ? Theme.of(context).primaryColor : Theme.of(context).primaryColorLight,
                      ),
                      onPressed: (account.mobile != null && account.mobile != '') || (account.phone != null && account.phone != '')
                          ? () async {
                              String _contact = '';
                              if (account.phone != '') {
                                _contact = await br.selectMobileNumber(['+${account.mobileCountryCode} ${account.mobile}', '+${account.phoneCountryCode} ${account.phone}'], context);
                              } else {
                                _contact = '+${account.mobileCountryCode} ${account.mobile}';
                              }
                              _cMsg.text = '';
                              AlertDialog dialog = AlertDialog(
                                shape: nativeTheme().dialogTheme.shape,
                                title: Text(global.appLocaleValues['tle_text_msg'], style: Theme.of(context).primaryTextTheme.headline1),
                                content: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: _cMsg,
                                    decoration: InputDecoration(icon: Icon(Icons.message), hintText: global.appLocaleValues['lbl_text_msg']),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return global.appLocaleValues['lbl_text_msg'];
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      _cMsg.text = '';

                                      Navigator.of(context).pop();
                                    },
                                    child: Text(global.appLocaleValues['btn_cancel'], style: Theme.of(context).primaryTextTheme.headline2),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      global.isAppOperation = true;
                                      await launch('sms: +$_contact?body=${_cMsg.text}');
                                    },
                                    child: Text(global.appLocaleValues['btn_send'], style: Theme.of(context).primaryTextTheme.headline2),
                                  ),
                                ],
                              );
                              showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
                            }
                          : () {},
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                        icon: Icon(
                          Icons.call,
                          color: (account.mobile != null && account.mobile != '') || (account.phone != null && account.phone != '') ? Theme.of(context).primaryColor : Theme.of(context).primaryColorLight,
                        ),
                        onPressed: (account.mobile != null && account.mobile != '') || (account.phone != null && account.phone != '')
                            ? () async {
                                String _contact = '';
                                if (account.phone != '') {
                                  _contact = await br.selectMobileNumber(['+${account.mobileCountryCode} ${account.mobile}', '+${account.phoneCountryCode} ${account.phone}'], context);
                                } else {
                                  _contact = '+${account.mobileCountryCode} ${account.mobile}';
                                }
                                global.isAppOperation = true;
                                launch('tel:$_contact');
                              }
                            : () {}),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        Icons.email,
                        color: account.email != null && account.email != '' ? Theme.of(context).primaryColor : Theme.of(context).primaryColorLight,
                      ),
                      onPressed: account.email != null && account.email != ''
                          ? () async {
                              global.isAppOperation = true;
                              final MailOptions mailOptions = MailOptions(
                                body: 'Hello',
                                subject: 'Test Demo',
                                recipients: [account.email],
                                isHTML: true,
                                bccRecipients: [],
                                ccRecipients: [],
                              );

                              await FlutterMailer.send(mailOptions);
                            }
                          : () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget rowCell(String lable, String type) =>  Expanded(
  //         child:  Column(
  //       children: <Widget>[
  //          Text(
  //           lable,
  //           style:  TextStyle(color: Colors.black, fontSize: 16),
  //         ),
  //          Text(type, style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))
  //       ],
  //     ));

  @override
  void initState() {
    super.initState();
    _getInit();
  }

  Future _getInit() async {
    try {
      _tabController = TabController(length: 2, vsync: this, initialIndex: _currentIndex);
      await _getData();
    } catch (e) {
      print('Exception - accountDetailsScreen.dart - _getInit(): ' + e.toString());
    }
  }

  Future _getData() async {
    try {
      if (account.accountType == 'Customer') {
        customerType = 1;
      } else if (account.accountType == 'Supplier') {
        customerType = 2;
      } else {
        customerType = 3;
      }
      _paymentList = await dbHelper.paymentGetList(startIndex: 0, fetchRecords: 5, accountId: account.id, orderBy: 'DESC');
      _paymentList.map((e) => e.account = account).toList();
      if (customerType == 1) {
        await _getCustomerInvoiceData();
        await _getCustomerPaymentData();
        _isDataLoaded = true;
        setState(() {});
      } else if (customerType == 2) {
        await _getSupplierInvoiceData();
        await _getSupplierPaymentData();
        _isDataLoaded = true;
        setState(() {});
      }
      // else if (account.accountType == ',Customer,Supplier,') {
      //   await _getCustomerInvoiceData();
      //   await _getSupplierInvoiceData();
      //   await _getCustomerPaymentData();
      //   await _getSupplierPaymentData();
      //   _isDataLoaded = true;
      //   setState(() {});
      // }
    } catch (e) {
      print('Exception - accountDetailsScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _getCustomerPaymentData() async {
    try {
      for (int i = 0; i < _paymentList.length; i++) {
        List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(paymentId: _paymentList[i].id);
        PaymentSaleInvoice _paymentInvoice = (_paymentInvoiceList.length != 0) ? _paymentInvoiceList[0] : null;
        // List<PaymentSaleInvoiceReturn> _paymentSaleInvoiceReturnList;
        // PaymentSaleInvoiceReturn _paymentSaleInvoiceReturn;
        // List<PaymentSaleOrder> _paymentSaleOrderList;
        // PaymentSaleOrder _paymentSaleOrder;
        if (_paymentInvoice != null) {
          // _paymentList[i].isSaleInvoiceRef = true;
          _paymentList[i].invoiceNumber = _paymentInvoice.invoiceNumber;
        }
        // else if (_paymentInvoice == null) {
        //   _paymentSaleInvoiceReturnList = await dbHelper.paymentSaleInvoiceReturnGetList(paymentId: _paymentList[i].id);
        //   _paymentSaleInvoiceReturn = (_paymentSaleInvoiceReturnList.length > 0) ? _paymentSaleInvoiceReturnList[0] : null;
        //   if (_paymentSaleInvoiceReturn != null) {
        //     _paymentList[i].isSaleInvoiceReturnRef = true;
        //   }
        // } else if (_paymentSaleInvoiceReturn == null) {
        //   _paymentSaleOrderList = await dbHelper.paymentSaleOrderGetList(paymentIdList: [_paymentList[i].id]);
        //   _paymentSaleOrder = (_paymentSaleOrderList.length > 0) ? _paymentSaleOrderList[0] : null;
        //   if (_paymentSaleOrder != null) {
        //     _paymentList[i].isSaleInvoiceReturnRef = true;
        //     _paymentList[i].orderNumber = _paymentSaleOrder.orderNumber;
        //   }
        // }
      }
    } catch (e) {
      print('Exception - accountDetailsScreen.dart - _getCustomerPaymentData(): ' + e.toString());
    }
  }

  Future _getSupplierPaymentData() async {
    try {
      for (int i = 0; i < _paymentList.length; i++) {
        List<PaymentPurchaseInvoice> _paymentInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(paymentId: _paymentList[i].id);
        PaymentPurchaseInvoice _paymentInvoice = (_paymentInvoiceList.length != 0) ? _paymentInvoiceList[0] : null;
        if (_paymentInvoice != null) {
          _paymentList[i].isPurchaseInvoiceRef = true;
          _paymentList[i].invoiceNumber = _paymentInvoice.invoiceNumber;
        } else {
          List<PaymentPurchaseInvoiceReturn> _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(paymentId: _paymentList[i].id);
          PaymentPurchaseInvoiceReturn _paymentPurchaseInvoiceReturn = (_paymentPurchaseInvoiceReturnList.length > 0) ? _paymentPurchaseInvoiceReturnList[0] : null;
          if (_paymentPurchaseInvoiceReturn != null) {
            _paymentList[i].isPurchaseInvoiceReturnRef = true;
          }
        }
      }
    } catch (e) {
      print('Exception - accountDetailsScreen.dart - _getCustomerPaymentData(): ' + e.toString());
    }
  }

  Future _getCustomerInvoiceData() async {
    try {
      _saleInvoiceList = await dbHelper.saleInvoiceGetList(accountId: account.id, orderBy: 'DESC', startIndex: 0, fetchRecords: 5);
      for (int i = 0; i < _saleInvoiceList.length; i++) {
        List<SaleInvoiceDetail> _invoiceDetailList = await dbHelper.saleInvoiceDetailGetList(invoiceIdList: [_saleInvoiceList[i].id]);
        _saleInvoiceList[i].totalProducts = _invoiceDetailList.length;
        // _saleInvoiceList[i].returnProducts = await dbHelper.saleInvoiceReturnDetailGetCount(invoiceId: _saleInvoiceList[i].id);
        List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(invoiceId: _saleInvoiceList[i].id);
        double _paidAmount = await dbHelper.paymentGetSumOfAmount(paymentType: 'RECEIVED', paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
        double _givenAmount = await dbHelper.paymentGetSumOfAmount(paymentType: 'GIVEN', paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
        if (_paidAmount != null && _givenAmount != null) {
          _saleInvoiceList[i].remainAmount = _saleInvoiceList[i].netAmount - (_paidAmount - _givenAmount);
        } else if (_paidAmount != null && _givenAmount == null) {
          _saleInvoiceList[i].remainAmount = _saleInvoiceList[i].netAmount - _paidAmount;
        } else if (_paidAmount == null && _givenAmount == null) {
          _saleInvoiceList[i].remainAmount = _saleInvoiceList[i].netAmount;
        }
      }

      // get sales return data
      // _sTransactionGroupIdList += await dbHelper.saleInvoiceReturnTransactionGroupGetList(accountId: account.id, startIndex: 0, fetchRecords: 5, orderBy: 'DESC');
      // for (int i = 0; i < _sTransactionGroupIdList.length; i++) {
      //   _sTransactionGroupIdList[i].childList = await dbHelper.saleInvoiceReturnGetList(transactionGroupIdList: [_sTransactionGroupIdList[i].transactionGroupId]);
      //   List<PaymentSaleInvoiceReturn> _paymentSaleInvoiceReturnList = await dbHelper.paymentSaleInvoiceReturnGetList(transactionGroupId: _sTransactionGroupIdList[i].transactionGroupId);
      //   List<Payment> _paymentList = (_paymentSaleInvoiceReturnList.length > 0) ? await dbHelper.paymentGetList(paymentIdList: _paymentSaleInvoiceReturnList.map((f) => f.paymentId).toList()) : [];
      //   double _receivedAmount = 0;
      //   double _givenAmount = 0;
      //   if (_paymentList.length > 0) {
      //     _paymentList.forEach((item) {
      //       if (item.paymentType == 'GIVEN') {
      //         _receivedAmount += item.amount;
      //       } else {
      //         _givenAmount += item.amount;
      //       }
      //     });
      //   }

      //   _sTransactionGroupIdList[i].remainAmount = (_paymentList.length != 0) ? (_sTransactionGroupIdList[i].totalSpent - (_receivedAmount - _givenAmount)) : _sTransactionGroupIdList[i].totalSpent;
      // }

      // get sale order data
      _saleQuoteList += await dbHelper.saleQuoteGetList(startIndex: 0, fetchRecords: 5, accountId: account.id, orderBy: 'DESC');

      for (int i = 0; i < _saleQuoteList.length; i++) {
        List<SaleQuoteDetail> _saleQuoteDetailList = await dbHelper.saleQuoteDetailGetList(orderIdList: [_saleQuoteList[i].id]);
        _saleQuoteList[i].totalProducts = _saleQuoteDetailList.length;
        // List<PaymentSaleOrder> _paymentOrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [_saleQuoteList[i].id], isCancel: false);
        // List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());
        // double _givenAmount = 0;
        // if (_paymentList.length != 0) {
        //   _paymentList.forEach((item) {
        //     if (item.paymentType == 'RECEIVED') {
        //       _saleOrderList[i].advanceAmount += item.amount;
        //     } else {
        //       _givenAmount += item.amount;
        //     }
        //   });
        // }
        // _saleOrderList[i].remainAmount = (_paymentList.length != 0) ? (_saleOrderList[i].netAmount - (_saleOrderList[i].advanceAmount - _givenAmount)) : _saleOrderList[i].netAmount;
        // _saleOrderList[i].isEditable = await dbHelper.saleOrderisUsed(_saleOrderList[i].id);
        // _saleOrderList[i].isEditable = !_saleOrderList[i].isEditable;
      }
      await getSaleOrderList();
      setState(() {});
    } catch (e) {
      print('Exception - accountDetailsScreen.dart - _getCustomerInvoiceData(): ' + e.toString());
    }
  }

  Future getSaleOrderList() async {
    try {
      _saleOrderList += await dbHelper.saleOrderGetList(startIndex: 0, fetchRecords: 5, orderBy: 'DESC', accountId: account.id);
      for (int i = 0; i < _saleOrderList.length; i++) {
        List<SaleOrderDetail> _saleOrderDetailList = await dbHelper.saleOrderDetailGetList(orderIdList: [_saleOrderList[i].id]);
        _saleOrderList[i].totalProducts = _saleOrderDetailList.length;
        List<PaymentSaleOrder> _paymentOrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [_saleOrderList[i].id], isCancel: false);
        List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());
        double _givenAmount = 0;
        if (_paymentList.length != 0) {
          _paymentList.forEach((item) {
            if (item.paymentType == 'RECEIVED') {
              _saleOrderList[i].advanceAmount += item.amount;
            } else {
              _givenAmount += item.amount;
            }
          });
        }
        _saleOrderList[i].remainAmount = (_paymentList.length != 0) ? (_saleOrderList[i].netAmount - (_saleOrderList[i].advanceAmount - _givenAmount)) : _saleOrderList[i].netAmount;
        _saleOrderList[i].isEditable = await dbHelper.saleOrderisUsed(_saleOrderList[i].id);
        _saleOrderList[i].isEditable = !_saleOrderList[i].isEditable;
      }
      setState(() {});
    } catch (e) {
      print('Exception - dashboard.dart - getSaleOrderList(): ' + e.toString());
    }
  }

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

  Future<String> _invoicePrintOrShare(PurchaseInvoice _purchaseInvoice, context, bool _isPrintAction) async {
    try {
      global.isAppOperation = true;
      List<Account> _accountList = await dbHelper.accountGetList(accountId: _purchaseInvoice.accountId);
      _purchaseInvoice.account = _accountList[0];
      _purchaseInvoice.invoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(invoiceId: _purchaseInvoice.id);
      _purchaseInvoice.invoiceTaxList = await dbHelper.purchaseInvoiceTaxGetList(invoiceId: _purchaseInvoice.id);
      _purchaseInvoice.invoiceDetailTaxList = await dbHelper.purchaseInvoiceDetailTaxGetList(invoiceDetailIdList: _purchaseInvoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.id).toList());
      //  String _address = (_account.addressLine1.isNotEmpty && _account.state.isNotEmpty && _account.country.isNotEmpty && _account.pincode != null) ? ' ${_account.addressLine1}, ${_account.city}, ${_account.state}, ${_account.country}, ${_account.pincode}' : ' ${_account.city}';
      List<PurchaseInvoiceReturnDetail> _returnProductList = [];
      List<TaxMaster> _returnProductTaxList = [];
      double _returnProductSubTotal = 0;
      double _returnProductfinalTotal = 0;
      String _returnProductPaymentStatus = '';
      var html;

      if (_purchaseInvoice.returnProducts > 0) {
        _returnProductList = await dbHelper.purchaseInvoiceReturnDetailGetList(purchaseInvoiceId: _purchaseInvoice.id);
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
      //    Navigator.of(context).pop();
      if (_isPrintAction != null) {
        br.generatePurchaseInvoiceHtml(context,
            invoice: _purchaseInvoice,
            isPrintAction: _isPrintAction,
            returnProductList: _returnProductList,
            returnProductPaymentStatus: _returnProductPaymentStatus,
            returnProductSubTotal: _returnProductSubTotal,
            returnProductTaxList: _returnProductTaxList,
            returnProductfinalTotal: _returnProductfinalTotal);
      } else {
        html = br.generatePurchaseInvoiceHtml(context,
            invoice: _purchaseInvoice,
            isPrintAction: _isPrintAction,
            returnProductList: _returnProductList,
            returnProductPaymentStatus: _returnProductPaymentStatus,
            returnProductSubTotal: _returnProductSubTotal,
            returnProductTaxList: _returnProductTaxList,
            returnProductfinalTotal: _returnProductfinalTotal);
      }
      return html;
    } catch (e) {
      print('Exception - purchaseInvoiceScreen.dart - _invoicePrintOrShare(): ' + e.toString());
      return null;
    }
  }

  Future _getSupplierInvoiceData() async {
    try {
      _purchaseInvoiceList = await dbHelper.purchaseInvoiceGetList(accountId: account.id, orderBy: 'DESC', startIndex: 0, fetchRecords: 5);

      for (int i = 0; i < _purchaseInvoiceList.length; i++) {
        List<PurchaseInvoiceDetail> _invoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(invoiceId: _purchaseInvoiceList[i].id);
        _purchaseInvoiceList[i].totalProducts = _invoiceDetailList.length;
        _purchaseInvoiceList[i].returnProducts = await dbHelper.purchaseInvoiceReturnDetailGetCount(purchaseInvoiceId: _purchaseInvoiceList[i].id);
        List<PaymentPurchaseInvoice> _paymentInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(invoiceId: _purchaseInvoiceList[i].id);
        double _paidAmount = await dbHelper.paymentGetSumOfAmount(paymentType: 'GIVEN', paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
        double _givenAmount = await dbHelper.paymentGetSumOfAmount(paymentType: 'RECEIVED', paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
        if (_paidAmount != null && _givenAmount != null) {
          _purchaseInvoiceList[i].remainAmount = _purchaseInvoiceList[i].netAmount - (_paidAmount - _givenAmount);
        } else if (_paidAmount != null && _givenAmount == null) {
          _purchaseInvoiceList[i].remainAmount = _purchaseInvoiceList[i].netAmount - _paidAmount;
        } else if (_paidAmount == null && _givenAmount == null) {
          _purchaseInvoiceList[i].remainAmount = _purchaseInvoiceList[i].netAmount;
        }
      }

      // get purchase return data
      // _pTransactionGroupIdList += await dbHelper.purchaseInvoiceReturnTransactionGroupGetList(accountId: account.id, startIndex: 0, fetchRecords: 5, orderBy: 'DESC');
      // for (int i = 0; i < _pTransactionGroupIdList.length; i++) {
      //   _pTransactionGroupIdList[i].childList = await dbHelper.purchaseInvoiceReturnGetList(transactionGroupIdList: [_pTransactionGroupIdList[i].transactionGroupId]);
      //   List<PaymentPurchaseInvoiceReturn> _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(transactionGroupId: _pTransactionGroupIdList[i].transactionGroupId);
      //   List<Payment> _paymentList = (_paymentPurchaseInvoiceReturnList.length > 0) ? await dbHelper.paymentGetList(paymentIdList: _paymentPurchaseInvoiceReturnList.map((f) => f.paymentId).toList()) : [];
      //   double _receivedAmount = 0;
      //   double _givenAmount = 0;
      //   if (_paymentList.length > 0) {
      //     _paymentList.forEach((item) {
      //       if (item.paymentType == 'RECEIVED') {
      //         _receivedAmount += item.amount;
      //       } else {
      //         _givenAmount += item.amount;
      //       }
      //     });
      //   }

      //   _pTransactionGroupIdList[i].remainAmount = (_paymentList.length != 0) ? (_pTransactionGroupIdList[i].totalSpent - (_receivedAmount - _givenAmount)) : _pTransactionGroupIdList[i].totalSpent;
      // }
    } catch (e) {
      print('Exception - accountDetailsScreen.dart - _getSupplierInvoiceData(): ' + e.toString());
    }
  }

  // Future<String> _saleInvoicePrintOrShare(SaleInvoice _saleInvoice, context, bool _isInvoicePrintAction) async {
  //   try {
  //     global.isAppOperation = true;
  //     List<Account> _accountList = await dbHelper.accountGetList(accountId: _saleInvoice.accountId);
  //     Account _account = _accountList[0];
  //     _saleInvoice.account = _account;
  //     _saleInvoice.invoiceDetailList = await dbHelper.saleInvoiceDetailGetList(invoiceIdList: [_saleInvoice.id]);
  //     _saleInvoice.invoiceTaxList = await dbHelper.saleInvoiceTaxGetList(invoiceId: _saleInvoice.id);
  //     _saleInvoice.invoiceDetailTaxList = await dbHelper.saleInvoiceDetailTaxGetList(invoiceDetailIdList: _saleInvoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.id).toList());
  //     //  String _address = (_account.addressLine1.isNotEmpty && _account.state.isNotEmpty && _account.country.isNotEmpty && _account.pincode != null) ? ' ${_account.addressLine1}, ${_account.city}, ${_account.state}, ${_account.country}, ${_account.pincode}' : ' ${_account.city}';
  //     List<PaymentSaleInvoice> _paymentInvoiceList = [];
  //     List<SaleInvoiceReturnDetail> _returnProductList = [];
  //     List<TaxMaster> _returnProductTaxList = [];
  //     double _returnProductSubTotal = 0;
  //     double _returnProductfinalTotal = 0;
  //     String _returnProductPaymentStatus = '';
  //     var htmlContent;

  //     if (_saleInvoice.generateByProductCategory) {
  //       // generate by product category
  //       _saleInvoice.invoiceDetailList.forEach((items) {
  //         int _isExistCategory = 0;
  //         _saleInvoice.generateByCategoryList.forEach((f) {
  //           if (f.productCategoryName == items.productTypeName) {
  //             _isExistCategory++;
  //           }
  //         });
  //         if (_isExistCategory == 0) {
  //           GenerateByCategory _generateByProductCategory =  GenerateByCategory();
  //           _generateByProductCategory.productCategoryName = items.productTypeName;
  //           List<SaleInvoiceDetail> _saleInvoiceDetailList = _saleInvoice.invoiceDetailList.where((f) => f.productTypeName == items.productTypeName).toList();
  //           _generateByProductCategory.quantity = _saleInvoiceDetailList.length;
  //           _generateByProductCategory.amount = _saleInvoiceDetailList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
  //           _saleInvoice.generateByCategoryList.add(_generateByProductCategory);
  //         }
  //       });
  //     }

  //     _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(invoiceId: _saleInvoice.id, isCancel: false);
  //     _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
  //     if (_saleInvoice.returnProducts > 0) {
  //       _returnProductList = await dbHelper.saleInvoiceReturnDetailGetList(saleInvoiceIdList: [_saleInvoice.id]);
  //       List<SaleInvoiceReturnDetailTax> _saleInvoiceReturnDetailTaxList = await dbHelper.saleInvoiceReturnDetailTaxGetList(invoiceReturnDetailIdList: _returnProductList.map((f) => f.id).toList());
  //       List<SaleInvoiceReturn> _saleInvoiceReturnList = await dbHelper.saleInvoiceReturnGetList(invoiceReturnIdList: [_returnProductList[0].saleInvoiceReturnId]);
  //       SaleInvoiceReturn _saleInvoiceReturn = (_saleInvoiceReturnList.length > 0) ? _saleInvoiceReturnList[0] : null;
  //       _returnProductPaymentStatus = _saleInvoiceReturn.status;

  //       if (_saleInvoice.generateByProductCategory) {
  //         // generate return  by product category
  //         _returnProductList.forEach((items) {
  //           int _isExistCategory = 0;
  //           _saleInvoice.returnGenerateByCategoryList.forEach((f) {
  //             if (f.productCategoryName == items.productTypeName) {
  //               _isExistCategory++;
  //             }
  //           });
  //           if (_isExistCategory == 0) {
  //             ReturnGenerateByCategory _returnGenerateByProductCategory =  ReturnGenerateByCategory();
  //             _returnGenerateByProductCategory.productCategoryName = items.productTypeName;
  //             List<SaleInvoiceReturnDetail> _saleInvoiceReturnDetailList = _returnProductList.where((f) => f.productTypeName == items.productTypeName).toList();
  //             _returnGenerateByProductCategory.quantity = _saleInvoiceReturnDetailList.length;
  //             _returnGenerateByProductCategory.amount = _saleInvoiceReturnDetailList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
  //             _saleInvoice.returnGenerateByCategoryList.add(_returnGenerateByProductCategory);
  //           }
  //         });
  //       }

  //       if (_saleInvoiceReturnDetailTaxList.length > 0) // when sales return tax is product wise
  //       {
  //         _returnProductTaxList = await dbHelper.taxMasterGetList(taxMasterIdList: _saleInvoiceReturnDetailTaxList.map((f) => f.taxId).toSet().toList());
  //         _returnProductTaxList.forEach((f) {
  //           double _taxAmount = 0;
  //           _saleInvoiceReturnDetailTaxList.forEach((item) {
  //             if (item.taxId == f.id) {
  //               _taxAmount += item.taxAmount;
  //             }
  //           });
  //           f.taxAmount = _taxAmount;
  //         });

  //         _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
  //         _returnProductfinalTotal = _returnProductSubTotal + _returnProductTaxList.map((f) => f.taxAmount).reduce((sum, amt) => sum + amt);
  //       } else // when sales return tax is tax wise
  //       {
  //         List<SaleInvoiceReturnTax> _saleInvoiceReturnTaxList = await dbHelper.saleInvoiceReturnTaxGetList(invoiceReturnId: _returnProductList[0].saleInvoiceReturnId);

  //         if (_saleInvoiceReturn != null) {
  //           if (_saleInvoiceReturnTaxList.length > 0) {
  //             _returnProductTaxList = await dbHelper.taxMasterGetList(taxMasterIdList: _saleInvoiceReturnTaxList.map((f) => f.taxId).toList());
  //             _returnProductTaxList.forEach((item) {
  //               item.taxAmount = (item.percentage * _saleInvoiceReturn.netAmount) / 100;
  //             });
  //             _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
  //             _returnProductfinalTotal = _returnProductSubTotal + _returnProductTaxList.map((f) => f.taxAmount).reduce((sum, amt) => sum + amt);
  //           } else // when sales return tax not available
  //           {
  //             _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
  //             _returnProductfinalTotal = _returnProductSubTotal;
  //           }
  //         }
  //       }
  //     }
  //     // Navigator.of(context).pop();
  //     if (_isInvoicePrintAction != null) {
  //       br.generateSaleInvoiceHtml(context, invoice: _saleInvoice, isPrintAction: _isInvoicePrintAction, returnProductList: _returnProductList, returnProductPaymentStatus: _returnProductPaymentStatus, returnProductSubTotal: _returnProductSubTotal, returnProductTaxList: _returnProductTaxList, returnProductfinalTotal: _returnProductfinalTotal);
  //     } else {
  //       htmlContent = br.generateSaleInvoiceHtml(context, invoice: _saleInvoice, isPrintAction: _isInvoicePrintAction, returnProductList: _returnProductList, returnProductPaymentStatus: _returnProductPaymentStatus, returnProductSubTotal: _returnProductSubTotal, returnProductTaxList: _returnProductTaxList, returnProductfinalTotal: _returnProductfinalTotal);
  //     }
  //     return htmlContent;
  //   } catch (e) {
  //     print('Exception - accountDetailsScreen.dart - _saleInvoicePrintOrShare(): ' + e.toString());
  //     return null;
  //   }
  // }

  // Future _purchaseInvoicePrintOrShare(PurchaseInvoice _purchaseInvoice, context, bool _isInvoicePrintAction) async {
  //   try {
  //     global.isAppOperation = true;
  //     List<Account> _accountList = await dbHelper.accountGetList(accountId: _purchaseInvoice.accountId);
  //     _purchaseInvoice.account = _accountList[0];
  //     _purchaseInvoice.invoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(invoiceId: _purchaseInvoice.id);
  //     _purchaseInvoice.invoiceTaxList = await dbHelper.purchaseInvoiceTaxGetList(invoiceId: _purchaseInvoice.id);
  //     _purchaseInvoice.invoiceDetailTaxList = await dbHelper.purchaseInvoiceDetailTaxGetList(invoiceDetailIdList: _purchaseInvoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.id).toList());
  //     //  String _address = (_account.addressLine1.isNotEmpty && _account.state.isNotEmpty && _account.country.isNotEmpty && _account.pincode != null) ? ' ${_account.addressLine1}, ${_account.city}, ${_account.state}, ${_account.country}, ${_account.pincode}' : ' ${_account.city}';
  //     List<PaymentPurchaseInvoice> _paymentInvoiceList = [];
  //     List<PurchaseInvoiceReturnDetail> _returnProductList = [];
  //     List<TaxMaster> _returnProductTaxList = [];
  //     double _returnProductSubTotal = 0;
  //     double _returnProductfinalTotal = 0;
  //     String _returnProductPaymentStatus = '';

  //     _paymentInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(invoiceId: _purchaseInvoice.id, isCancel: false);
  //     _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
  //     if (_purchaseInvoice.returnProducts > 0) {
  //       _returnProductList = await dbHelper.purchaseInvoiceReturnDetailGetList(purchaseInvoiceId: _purchaseInvoice.id);
  //       List<PurchaseInvoiceReturnDetailTax> _purchaseInvoiceReturnDetailTaxList = await dbHelper.purchaseInvoiceReturnDetailTaxGetList(purchaseInvoiceReturnDetailIdList: _returnProductList.map((f) => f.id).toList());
  //       List<PurchaseInvoiceReturn> _purchaseInvoiceReturnList = await dbHelper.purchaseInvoiceReturnGetList(purchaseInvoiceReturnIdList: [_returnProductList[0].purchaseInvoiceReturnId]);
  //       PurchaseInvoiceReturn _purchaseInvoiceReturn = (_purchaseInvoiceReturnList.length > 0) ? _purchaseInvoiceReturnList[0] : null;
  //       _returnProductPaymentStatus = _purchaseInvoiceReturn.status;

  //       if (_purchaseInvoiceReturnDetailTaxList.length > 0) // when purchase return tax is product wise
  //       {
  //         _returnProductTaxList = await dbHelper.taxMasterGetList(taxMasterIdList: _purchaseInvoiceReturnDetailTaxList.map((f) => f.taxId).toSet().toList());
  //         _returnProductTaxList.forEach((f) {
  //           double _taxAmount = 0;
  //           _purchaseInvoiceReturnDetailTaxList.forEach((item) {
  //             if (item.taxId == f.id) {
  //               _taxAmount += item.taxAmount;
  //             }
  //           });
  //           f.taxAmount = _taxAmount;
  //         });

  //         _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
  //         _returnProductfinalTotal = _returnProductSubTotal + _returnProductTaxList.map((f) => f.taxAmount).reduce((sum, amt) => sum + amt);
  //       } else // when purchase return tax is tax wise
  //       {
  //         List<PurchaseInvoiceReturnTax> _purchaseInvoiceReturnTaxList = await dbHelper.purchaseInvoiceReturnTaxGetList(purchaseInvoiceReturnId: _returnProductList[0].purchaseInvoiceReturnId);

  //         if (_purchaseInvoiceReturn != null) {
  //           if (_purchaseInvoiceReturnTaxList.length > 0) {
  //             _returnProductTaxList = await dbHelper.taxMasterGetList(taxMasterIdList: _purchaseInvoiceReturnTaxList.map((f) => f.taxId).toList());
  //             _returnProductTaxList.forEach((item) {
  //               item.taxAmount = (item.percentage * _purchaseInvoiceReturn.netAmount) / 100;
  //             });
  //             _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
  //             _returnProductfinalTotal = _returnProductSubTotal + _returnProductTaxList.map((f) => f.taxAmount).reduce((sum, amt) => sum + amt);
  //           } else // when sales return tax not available
  //           {
  //             _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
  //             _returnProductfinalTotal = _returnProductSubTotal;
  //           }
  //         }
  //       }
  //     }
  //     // Navigator.of(context).pop();
  //     br.generatePurchaseInvoiceHtml(context, invoice: _purchaseInvoice, isPrintAction: _isInvoicePrintAction, returnProductList: _returnProductList, returnProductPaymentStatus: _returnProductPaymentStatus, returnProductSubTotal: _returnProductSubTotal, returnProductTaxList: _returnProductTaxList, returnProductfinalTotal: _returnProductfinalTotal);
  //   } catch (e) {
  //     print('Exception - accountDetailsScreen.dart - _purchaseInvoicePrintOrShare(): ' + e.toString());
  //   }
  // }

  // Future<String> _saleOrderPrintOrShare(SaleOrder _saleOrder, context, bool _isPrintAction) async {
  //   try {
  //     global.isAppOperation = true;
  //     List<Account> _accountList = await dbHelper.accountGetList(accountId: _saleOrder.accountId);
  //     _saleOrder.account = _accountList[0];
  //     _saleOrder.orderDetailList = await dbHelper.saleOrderDetailGetList(orderIdList: [_saleOrder.id]);
  //     _saleOrder.orderTaxList = await dbHelper.saleOrderTaxGetList(saleOrderId: _saleOrder.id);
  //     _saleOrder.orderDetailTaxList = await dbHelper.saleOrderDetailTaxGetList(orderDetailIdList: _saleOrder.orderDetailList.map((orderDetail) => orderDetail.id).toList());
  //     //  String _address = (_account.addressLine1.isNotEmpty && _account.state.isNotEmpty && _account.country.isNotEmpty && _account.pincode != null) ? ' ${_account.addressLine1}, ${_account.city}, ${_account.state}, ${_account.country}, ${_account.pincode}' : ' ${_account.city}';
  //     List<PaymentSaleOrder> _paymentSaleOrderList = [];
  //     List<Payment> _paymentList = [];
  //     List<PaymentDetail> _paymentDetailList = [];
  //     var htmlContent;

  //     _paymentSaleOrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [_saleOrder.id], isCancel: false);
  //     _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentSaleOrderList.map((paymentSaleOrder) => paymentSaleOrder.paymentId).toList());
  //     _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleOrderList.map((paymentSaleOrder) => paymentSaleOrder.paymentId).toList());
  //     if (_paymentList.length != 0) {
  //       _paymentList.forEach((item) {
  //         if (item.paymentType == 'RECEIVED') {
  //           _paymentDetailList.forEach((paymentDetail) {
  //             if (item.id == paymentDetail.paymentId) {
  //               if (paymentDetail.paymentMode == 'Cheque') {
  //                 _saleOrder.paymentByCheque += paymentDetail.amount;
  //               } else if (paymentDetail.paymentMode == 'Cash') {
  //                 _saleOrder.paymentByCash += paymentDetail.amount;
  //               } else if (paymentDetail.paymentMode == 'Card') {
  //                 _saleOrder.paymentByCard += paymentDetail.amount;
  //               } else if (paymentDetail.paymentMode == 'EWallet' || paymentDetail.paymentMode == 'eWallet') {
  //                 _saleOrder.paymentByEWallet += paymentDetail.amount;
  //               } else {
  //                 _saleOrder.paymentByNetBanking += paymentDetail.amount;
  //               }
  //             }
  //           });
  //         }
  //       });
  //     }
  //     //  Navigator.pop(context);
  //     if (_isPrintAction != null) {
  //       br.generateSaleOrderHtml(
  //         context,
  //         order: _saleOrder,
  //         isPrintAction: _isPrintAction,
  //       );
  //     } else {
  //       htmlContent = br.generateSaleOrderHtml(
  //         context,
  //         order: _saleOrder,
  //         isPrintAction: _isPrintAction,
  //       );
  //     }
  //     return htmlContent;
  //   } catch (e) {
  //     print('Exception - dashboardScreen.dart - _saleOrderPrintOrShare(): ' + e.toString());
  //     return null;
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }
}
