// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals
import 'dart:async';

import 'package:accounting_app/models/paymentSaleOrderModel.dart';
import 'package:accounting_app/models/saleOrderDetailModel.dart';
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/screens/productAddScreen.dart';
import 'package:accounting_app/screens/purchaseInvoiceAddScreen.dart';
import 'package:accounting_app/screens/saleInvoiceAddScreen.dart';
import 'package:accounting_app/screens/saleOrderAddScreen.dart';
import 'package:accounting_app/screens/saleOrderScreen.dart';
import 'package:accounting_app/widgets/listTileSaleOrderWidget.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/dialogs/enableFingerprintDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/accountSearchModel.dart';
import 'package:accounting_app/models/businessChartModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/expenseModel.dart';
import 'package:accounting_app/models/expensePaymentsModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleQuoteDetailModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/screens/accountAddScreen.dart';
import 'package:accounting_app/screens/accountScreen.dart';
import 'package:accounting_app/screens/expenseAddScreen.dart';
import 'package:accounting_app/screens/expenseScreen.dart';
import 'package:accounting_app/screens/paymentAddScreen.dart';
import 'package:accounting_app/screens/paymentDetailScreen.dart';
import 'package:accounting_app/screens/paymentScreen.dart';
import 'package:accounting_app/screens/saleInvoiceScreen.dart';
import 'package:accounting_app/screens/salesQuoteAddScreen.dart';
import 'package:accounting_app/screens/salesQuoteScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:accounting_app/widgets/listTileAccountWidget.dart';
import 'package:accounting_app/widgets/listTileSaleInvoiceWidget.dart';
import 'package:accounting_app/widgets/listTileSaleQuoteWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ribbon/ribbon.dart';

class DashboardScreen extends BaseRoute {
  DashboardScreen({@required a, @required o}) : super(a: a, o: o, r: 'DashboardScreen');

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends BaseRouteState {
  int _noOfActiveAccounts = 0;
  int _noOfActiveInvoices = 0;
  int _noOfActivePayments = 0;
  double _sumOfExpeneseAmount = 0;
  double _sumOfPaymentAmount = 0;
  double _sumOfInvoicesAmount = 0;
  int _noOfExpenses = 0;
  bool _isPaymentPrintAction;
  // List<Product> _productList = [];
  List<SaleInvoice> _saleInvoiceList = [];
  List<SaleQuote> _saleQuoteList = [];
  List<SaleOrder> _saleOrderList = [];
  List<PurchaseInvoice> _purchaseInvoiceList = [];
  List<Payment> _paymentList = [];
  List<Account> _customerList = [];
  List<Account> _supplierList = [];
  List<Expense> _expenseList = [];
  // List<SaleInvoiceReturn> _sTransactionGroupIdList = [];
  // List<PurchaseInvoiceReturn> _pTransactionGroupIdList = [];
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  // var _formKey = GlobalKey<FormState>();
  // TextEditingController _cMsg =  TextEditingController();
  bool _isDataLoaded = false;
  // bool isShowingMainData;
  bool _fingerPrintSetup = global.prefs.getBool('fingerprintSetup');
  // List<MapData> _salesMapList = [];
  List<BusinessChart> _salesBusinessChartList = [];
  List<BusinessChart> _purchaseBusinessChartList = [];
  List<FlSpot> _salesMapFLSpotList = [];
  List<FlSpot> _purchaseMapFLSpotList = [];
  int _totalMonth = 3;
  bool _isLineMap = false;
  bool _isMonthWise = true;
  DateTime endDateShow = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  // final GlobalKey<ScaffoldState> _drawerscaffoldkey =  GlobalKey<ScaffoldState>();
//  double mapMaxAmount = 0;
  AppUpdateInfo _updateInfo;

  _DashboardScreenState() : super();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    int b = (size.width ~/ 160).toInt();

    final double itemHeight = 100;
    final double itemWidth = 160;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          global.appLocaleValues['tle_dashboard'],
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
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
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text('${global.appLocaleValues['add_cus']}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AccountAddScreen(
                              a: widget.analytics,
                              o: widget.observer,
                              returnScreenId: 1,
                            )));
                  },
                ),
              ),
              (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true')
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
                            Text('${global.appLocaleValues['add_sup']}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AccountAddScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    returnScreenId: 1,
                                    isAddAsCustomer: false,
                                  )));
                        },
                      ),
                    )
                  : null,
              PopupMenuItem(
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
                      Text((br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? '${global.appLocaleValues['tle_add_product']}' : '${global.appLocaleValues['tle_add_service']}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductAddSreen(
                              a: widget.analytics,
                              o: widget.observer,
                              screenId: 0,
                            )));
                  },
                ),
              ),
              (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true')
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
                            Text('${global.appLocaleValues['lbl_add_purchase_invoice']}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PurchaseInvoiceAddSreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    invoice: PurchaseInvoice(),
                                  )));
                        },
                      ),
                    )
                  : null,
              PopupMenuItem(
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
                      Text('${global.appLocaleValues['add_sal_quo']}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SaleQuoteAddSreen(
                              a: widget.analytics,
                              o: widget.observer,
                              quote: SaleQuote(),
                              returnScreenId: 1,
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
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(global.appLocaleValues['lbl_add_payment']),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentAddScreen(
                              a: widget.analytics,
                              o: widget.observer,
                              returnScreenId: 0,
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
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text('${global.appLocaleValues['tle_add_expense']}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ExpenseAddScreen(
                              a: widget.analytics,
                              o: widget.observer,
                            )));
                  },
                ),
              ),
              (br.getSystemFlagValue(global.systemFlagNameList.showDashboardStatistics) != 'true' && (_noOfActiveAccounts > 0 || _sumOfPaymentAmount > 0 || _sumOfInvoicesAmount > 0 || _sumOfExpeneseAmount > 0))
                  ? PopupMenuItem(
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
                            Text(global.appLocaleValues['lbl_show_statistics']),
                          ],
                        ),
                        onTap: () async {
                          await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.showDashboardStatistics, true.toString());
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                      ),
                    )
                  : null,
              (br.getSystemFlagValue(global.systemFlagNameList.showDashboardStatistics) == 'true' && (_noOfActiveAccounts > 0 || _sumOfPaymentAmount > 0 || _sumOfInvoicesAmount > 0 || _sumOfExpeneseAmount > 0))
                  ? PopupMenuItem(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.visibility_off,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(global.appLocaleValues['lbl_hide_statistics']),
                          ],
                        ),
                        onTap: () async {
                          await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.showDashboardStatistics, false.toString());
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
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width - 90,
        child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
      ),
      body: WillPopScope(
          onWillPop: () async {
            await exitAppDialog(0);
            return null;
          },
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            GridView.count(
              padding: EdgeInsets.all(5),
              crossAxisSpacing: 4.0,
              childAspectRatio: (itemWidth / itemHeight),
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: b,
              children: <Widget>[
                Card(
                  child: Center(
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 8.0, right: 6.0),
                      onTap: () {
                        AccountSearch accountSearch = AccountSearch();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AccountScreen(
                              redirectToCustomersTab: true,
                                  a: widget.analytics,
                                  o: widget.observer,
                                  accountSearch: accountSearch,
                                )));
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepOrange,
                        radius: 25,
                        child: Icon(Icons.people, color: Colors.white),
                      ),
                      title: Text(
                        global.appLocaleValues['tab_customers'],
                        style: Theme.of(context).primaryTextTheme.headline3,
                        softWrap: true,
                      ),
                      subtitle: (br.getSystemFlagValue(global.systemFlagNameList.showDashboardStatistics) == 'true')
                          ? (_noOfActiveAccounts > 0)
                              ? Text(
                                  '$_noOfActiveAccounts',
                                  style: Theme.of(context).primaryTextTheme.subtitle2,
                                )
                              : null
                          : null,
                    ),
                  ),
                ),
                Card(
                  child: Center(
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 8.0, right: 6.0),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SaleInvoiceScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                )));
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo[500],
                        radius: 25,
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        global.appLocaleValues['lbl_sales'],
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ),
                      subtitle: (br.getSystemFlagValue(global.systemFlagNameList.showDashboardStatistics) == 'true')
                          ? (_sumOfInvoicesAmount > 0)
                              ? Text(
                                  '${global.currency.symbol} ${_sumOfInvoicesAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} / $_noOfActiveInvoices',
                                  style: Theme.of(context).primaryTextTheme.subtitle2,
                                )
                              : null
                          : null,
                    ),
                  ),
                ),
                Card(
                  child: Center(
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 8.0, right: 6.0),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                )));
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 25,
                        child: Icon(Icons.payment, color: Colors.white),
                      ),
                      title: Text(
                        global.appLocaleValues['lbl_payments'],
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ),
                      subtitle: (br.getSystemFlagValue(global.systemFlagNameList.showDashboardStatistics) == 'true')
                          ? (_sumOfPaymentAmount > 0)
                              ? Text(
                                  '${global.currency.symbol} ${_sumOfPaymentAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} / $_noOfActivePayments',
                                  style: Theme.of(context).primaryTextTheme.subtitle2,
                                )
                              : null
                          : null,
                    ),
                  ),
                ),
                Card(
                  child: Center(
                      child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ExpenseScreen(
                                a: widget.analytics,
                                o: widget.observer,
                              )));
                    },
                    contentPadding: EdgeInsets.only(left: 8.0, right: 6.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple,
                      radius: 25,
                      child: Icon(
                        MdiIcons.currencyUsd,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      global.appLocaleValues['lbl_expenses'],
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ),
                    subtitle: (br.getSystemFlagValue(global.systemFlagNameList.showDashboardStatistics) == 'true')
                        ? (_sumOfExpeneseAmount > 0)
                            ? Text(
                                '${global.currency.symbol} ${_sumOfExpeneseAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} / $_noOfExpenses',
                                style: Theme.of(context).primaryTextTheme.subtitle2,
                              )
                            : null
                        : null,
                  )),
                )
              ],
            ),
            (br.getSystemFlagValue(global.systemFlagNameList.showDashboardStatistics) == 'true' && (_saleInvoiceList.length > 0 || _purchaseInvoiceList.length > 0))
                ? Padding(
                    padding: const EdgeInsets.only(left: 4, right: 5, top: 5),
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      child: (_salesMapFLSpotList.length > 0 || _purchaseMapFLSpotList.length > 0 || _totalMonth != 3)
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 280,
                                    child: Stack(
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    '${global.appLocaleValues['lbl_business_chart']}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                (_totalMonth != 3 && _totalMonth != 6)
                                                    ? GestureDetector(
                                                        child: Container(
                                                          width: 70,
                                                          height: 23,
                                                          padding: const EdgeInsets.only(top: 5, bottom: 3, left: 5, right: 5),
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)), color: (!_isMonthWise) ? Colors.white : Theme.of(context).primaryColor, border: Border.all(color: Colors.white)),
                                                          child: Center(
                                                            child: Text(
                                                              global.appLocaleValues['lbl_weekly_cap'],
                                                              style: TextStyle(fontWeight: FontWeight.bold, color: (!_isMonthWise) ? Theme.of(context).primaryColor : Colors.white, height: 0.9, fontSize: 12),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          _isMonthWise = false;
                                                          await _monthChanged();
                                                        },
                                                      )
                                                    : SizedBox(),
                                                Align(
                                                  child: GestureDetector(
                                                    child: Container(
                                                      width: 70,
                                                      height: 23,
                                                      padding: const EdgeInsets.only(top: 5, bottom: 3, left: 5, right: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                              topRight: Radius.circular(10),
                                                              bottomRight: Radius.circular(10),
                                                              bottomLeft: Radius.circular(
                                                                (_totalMonth == 3 || _totalMonth == 6) ? 10 : 0,
                                                              ),
                                                              topLeft: Radius.circular(
                                                                (_totalMonth == 3 || _totalMonth == 6) ? 10 : 0,
                                                              )),
                                                          color: (_isMonthWise) ? Colors.white : Theme.of(context).primaryColor,
                                                          border: Border.all(color: Colors.white)),
                                                      child: Center(
                                                        child: Text(
                                                          global.appLocaleValues['lbl_monthly_cap'],
                                                          style: TextStyle(fontWeight: FontWeight.bold, color: (_isMonthWise) ? Theme.of(context).primaryColor : Colors.white, height: 0.9, fontSize: 12),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      _isMonthWise = true;
                                                      await _monthChanged();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 0, top: 10),
                                              child: Row(
                                                // mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Row(
                                                      children: <Widget>[
                                                        CircleAvatar(
                                                          radius: 6,
                                                          backgroundColor: Colors.white,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 5),
                                                          child: Text(
                                                              '${global.appLocaleValues['lbl_map_sales']} ${global.currency.symbol} ${(_salesBusinessChartList.length > 0) ? NumberFormat.compactCurrency(decimalDigits: 2, symbol: '').format(_salesBusinessChartList.map((e) => e.totalAmount).reduce((value, element) => value + element)) : 0}',
                                                              style: TextStyle(color: Colors.white)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true')
                                                  //     ? Row(
                                                  //         children: <Widget>[
                                                  //           CircleAvatar(
                                                  //             radius: 6,
                                                  //             backgroundColor: Colors.white70,
                                                  //           ),
                                                  //           Padding(
                                                  //             padding: const EdgeInsets.only(left: 5),
                                                  //             child: Text('${global.appLocaleValues['tle_purchase']} ${global.currency.symbol}${(_purchaseBusinessChartList.length > 0) ? NumberFormat.compactCurrency(decimalDigits: 2, symbol: '').format(_purchaseBusinessChartList.map((e) => e.totalAmount).reduce((value, element) => value + element)) : 0}', style: TextStyle(color: Colors.white)),
                                                  //           ),
                                                  //         ],
                                                  //       )
                                                  //     : SizedBox(),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 37,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                                                child: (_isLineMap)
                                                    ? LineChart(
                                                        mapData(),
                                                        swapAnimationDuration: const Duration(milliseconds: 250),
                                                      )
                                                    : BarChart(
                                                        barMapData(),
                                                        swapAnimationDuration: const Duration(milliseconds: 250),
                                                      ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: GestureDetector(
                                            child: Container(
                                              height: 25,
                                              padding: const EdgeInsets.only(top: 5, bottom: 3, left: 5, right: 5),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)), color: (_totalMonth == 1) ? Colors.white : Theme.of(context).primaryColor, border: Border.all(color: Colors.white)),
                                              child: Center(
                                                child: Text(
                                                  '1 ${global.appLocaleValues['lbl_month']}',
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: (_totalMonth == 1) ? Theme.of(context).primaryColor : Colors.white, height: 0.9, fontSize: 14),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              _totalMonth = 1;
                                              await _monthChanged();
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            child: Container(
                                              height: 25,
                                              padding: const EdgeInsets.only(top: 5, bottom: 3, left: 0, right: 0),
                                              decoration: BoxDecoration(color: (_totalMonth == 2) ? Colors.white : Theme.of(context).primaryColor, border: Border.all(color: Colors.white)),
                                              child: Center(
                                                child: Text(
                                                  '2 ${global.appLocaleValues['lbl_months']}',
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: (_totalMonth == 2) ? Theme.of(context).primaryColor : Colors.white, height: 0.9, fontSize: 14),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              _totalMonth = 2;
                                              await _monthChanged();
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            child: Container(
                                              height: 25,
                                              padding: const EdgeInsets.only(top: 5, bottom: 3, left: 0, right: 0),
                                              decoration: BoxDecoration(color: (_totalMonth == 3) ? Colors.white : Theme.of(context).primaryColor, border: Border.all(color: Colors.white)),
                                              child: Center(
                                                child: Text(
                                                  '3 ${global.appLocaleValues['lbl_months']}',
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: (_totalMonth == 3) ? Theme.of(context).primaryColor : Colors.white, height: 0.9, fontSize: 14),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              _totalMonth = 3;
                                              _isMonthWise = true;
                                              await _monthChanged();
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            child: Container(
                                              height: 25,
                                              padding: const EdgeInsets.only(top: 5, bottom: 3, left: 0, right: 5),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)), color: (_totalMonth == 6) ? Colors.white : Theme.of(context).primaryColor, border: Border.all(color: Colors.white)),
                                              child: Center(
                                                child: Text(
                                                  '6 ${global.appLocaleValues['lbl_months']}',
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: (_totalMonth == 6) ? Theme.of(context).primaryColor : Colors.white, height: 0.9, fontSize: 14),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              _totalMonth = 6;
                                              _isMonthWise = true;
                                              await _monthChanged();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: 315,
                              child: Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                    ),
                  )
                : SizedBox(),
            // (_productList.length < 1 && _saleInvoiceList.length < 1 && _saleOrderList.length < 1 && _purchaseInvoiceList.length < 1 && _paymentList.length < 1 && _customerList.length < 1 && _supplierList.length < 1 && _expenseList.length < 1 && _sTransactionGroupIdList.length < 1 && _pTransactionGroupIdList.length < 1)
            //     ? Center(
            //         //     heightFactor: 20,
            //         child: Card(
            //           shape: nativeTheme().cardTheme.shape,
            //           child: Column(
            //             mainAxisSize: MainAxisSize.max,
            //             children: <Widget>[
            //               ListTile(
            //                 title: Row(
            //                   children: <Widget>[
            //                     Icon(
            //                       Icons.lightbulb_outline,
            //                       color: Theme.of(context).primaryColor,
            //                     ),
            //                     Text(
            //                       '  ${global.appLocaleValues['tle_tip']}',
            //                       style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(left: 15, right: 8, bottom: 8),
            //                 child: Text('${global.appLocaleValues['tle_sug_desc']}', textAlign: TextAlign.justify, style: TextStyle(color: Colors.grey)),
            //               )
            //             ],
            //           ),
            //         ),
            //       )
            //     : SizedBox(),
            // global.backupResult != null
            //     ? Card(
            //         child: ListTile(
            //             leading: CircleAvatar(
            //               backgroundColor: Theme.of(context).primaryColorLight,
            //               foregroundColor: Colors.white,
            //               radius: 25,
            //               child: Icon(
            //                 Icons.cloud_upload,
            //                 color: Colors.white,
            //               ),
            //             ),
            //             subtitle: global.backupResult.statusMessage != null ? Text(global.backupResult.statusMessage) : null,
            //             title: Text(
            //               '${global.appLocaleValues['tle_google_drive_backup']}',
            //               style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            //             ),
            //             trailing: global.backupResult.statusCode == 0
            //                 ? Icon(
            //                     Icons.cancel,
            //                     color: Colors.red,
            //                   )
            //                 : global.backupResult.statusCode == 1
            //                     ? Icon(Icons.check_circle, color: Colors.green)
            //                     : global.backupResult.statusCode == 2
            //                         ? Icon(
            //                             Icons.signal_wifi_off,
            //                             color: Colors.grey,
            //                           )
            //                         : SizedBox(
            //                             width: 25,
            //                             height: 25,
            //                             child: CircularProgressIndicator(
            //                               strokeWidth: 2,
            //                             ),
            //                           )),
            //       )
            //     : SizedBox(),
            // (_productList.length > 0)
            //     ? SizedBox(
            //         height: 460,
            //         child: Card(
            //           shape: nativeTheme().cardTheme.shape,
            //           child: Column(
            //             children: <Widget>[
            //               ListTile(
            //                 title: Text(
            //                   '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_top_sold_pro'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_top_sold_ser'] : global.appLocaleValues['tle_top_sold_both']}',
            //                   style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            //                 ),
            //                 trailing: TextButton.icon(
            //                     onPressed: null,
            //                     label: Icon(
            //                       Icons.navigate_next,
            //                       color: Theme.of(context).primaryColor,
            //                     ),
            //                     icon: Text(
            //                       global.appLocaleValues['btn_view_all'],
            //                       style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            //                     )),
            //                 onTap: () {
            //                   Navigator.of(context).push(MaterialPageRoute(
            //                       builder: (context) =>  ProductScreen(
            //                             a: widget.analytics,
            //                             o: widget.observer,
            //                           )));
            //                 },
            //               ),
            //               Padding(
            //                 padding: EdgeInsets.only(right: 0),
            //                 child: (_isDataLoaded)
            //                     ? ListView.builder(
            //                         physics: NeverScrollableScrollPhysics(),
            //                         itemCount: _productList.length,
            //                         shrinkWrap: true,
            //                         itemBuilder: (context, index) {
            //                           return ListTile(
            //                             contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
            //                             leading: CircleAvatar(
            //                               backgroundColor: Theme.of(context).primaryColorLight,
            //                               foregroundColor: Colors.black,
            //                               radius: 25,
            //                               child: (_productList[index].imagePath.isNotEmpty)
            //                                   ? ClipOval(
            //                                       child: Image.file(File(_productList[index].imagePath)),
            //                                     )
            //                                   : Text(
            //                                       '${_productList[index].name.substring(0, 1)}',
            //                                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            //                                     ),
            //                             ),
            //                             title: Text(
            //                               (br.getSystemFlagValue(global.systemFlagNameList.useProductSupplierCode) == 'true' && _productList[index].supplierProductCode != '')
            //                                   ? '${_productList[index].supplierProductCode} - ${_productList[index].name}'
            //                                   : '${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + _productList[index].productCode.toString().length))}${_productList[index].productCode} - ${_productList[index].name}',
            //                               overflow: TextOverflow.ellipsis,
            //                             ),
            //                             subtitle: Row(
            //                               children: <Widget>[
            //                                 Text(
            //                                   (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
            //                                       ? '${_productList[index].productTypeName}  \n${global.currency.symbol} ${_productList[index].productPriceList[0].price.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} / ${_productList[index].productPriceList[0].unitCode}'
            //                                       : '${_productList[index].productTypeName}  \n${global.currency.symbol} ${_productList[index].productPriceList[0].price.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
            //                                   overflow: TextOverflow.ellipsis,
            //                                 ),
            //                               ],
            //                             ),
            //                           );
            //                         },
            //                       )
            //                     : Padding(
            //                         padding: EdgeInsets.only(bottom: 10),
            //                         child: Center(
            //                           child: CircularProgressIndicator(strokeWidth: 2),
            //                         ),
            //                       ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       )
            //     : SizedBox(),
            (_customerList.length > 0)
                ? SizedBox(
                    height: 480,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                      child: Card(
                        shape: nativeTheme().cardTheme.shape,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                global.appLocaleValues['lbl_customers_due'],
                                style: Theme.of(context).primaryTextTheme.headline1,
                              ),
                              trailing: SizedBox(
                                height: 35,
                                child: TextButton.icon(
                                    onPressed: null,
                                    label: Icon(
                                      Icons.navigate_next,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    icon: Text(global.appLocaleValues['btn_view_all'], style: Theme.of(context).primaryTextTheme.bodyText2)),
                              ),
                              onTap: () {
                                AccountSearch accountSearch = AccountSearch();
                                accountSearch.isDue = true;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AccountScreen(
                                          a: widget.analytics,
                                          redirectToCustomersTab: true,
                                          o: widget.observer,
                                          accountSearch: accountSearch,
                                        )));
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0, top: 0, bottom: 5),
                              child: (_isDataLoaded)
                                  ? (_customerList.isNotEmpty)
                                      ? ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: _customerList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                                padding: const EdgeInsets.only(top: 0),
                                                child: ListTileAccountWidget(
                                                  key: ValueKey(_customerList[index].id),
                                                  account: _customerList[index],
                                                  a: widget.analytics,
                                                  o: widget.observer,
                                                  tabIndex: 0,
                                                ));
                                          },
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(top: 85),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                                child: Icon(
                                                  Icons.assignment,
                                                  color: Colors.grey,
                                                  size: 50,
                                                ),
                                              ),
                                              FittedBox(
                                                child: Text(global.appLocaleValues['lbl_customers_due_empty_msg'], style: Theme.of(context).primaryTextTheme.headline6),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        )
                                  : Padding(
                                      padding: EdgeInsets.only(bottom: 10, top: 0),
                                      child: Center(
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true' && _supplierList.length > 0)
                ? SizedBox(
                    height: 480,
                    child: Card(
                      shape: nativeTheme().cardTheme.shape,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              global.appLocaleValues['lbl_suppliers_due'],
                              style: Theme.of(context).primaryTextTheme.headline1,
                            ),
                            trailing: SizedBox(
                              height: 35,
                              child: TextButton.icon(
                                  onPressed: null,
                                  label: Icon(
                                    Icons.navigate_next,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  icon: Text(global.appLocaleValues['btn_view_all'], style: Theme.of(context).primaryTextTheme.bodyText2)),
                            ),
                            onTap: () {
                              AccountSearch accountSearch = AccountSearch();
                              accountSearch.isDue = true;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AccountScreen(
                                    redirectToCustomersTab: true,
                                        a: widget.analytics,
                                        o: widget.observer,
                                        accountSearch: accountSearch,
                                      )));
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 0, top: 0, bottom: 5),
                            child: (_isDataLoaded)
                                ? (_supplierList.isNotEmpty)
                                    ? ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _supplierList.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                              padding: const EdgeInsets.only(top: 0),
                                              child: ListTileAccountWidget(
                                                key: ValueKey(_supplierList[index].id),
                                                account: _supplierList[index],
                                                a: widget.analytics,
                                                o: widget.observer,
                                                tabIndex: 1,
                                              ));
                                        },
                                      )
                                    : Container(
                                        margin: const EdgeInsets.only(top: 85),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(top: 20, bottom: 10),
                                              child: Icon(
                                                Icons.assignment,
                                                color: Colors.grey,
                                                size: 50,
                                              ),
                                            ),
                                            FittedBox(
                                              child: Text(
                                                global.appLocaleValues['lbl_suppliers_due_empty_msg'],
                                                style: TextStyle(color: Colors.grey),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                : Padding(
                                    padding: EdgeInsets.only(bottom: 10, top: 0),
                                    child: Center(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            (_saleQuoteList.length > 0)
                ? SizedBox(
                    height: 470,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                      child: Card(
                        shape: nativeTheme().cardTheme.shape,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text('${global.appLocaleValues['rec_sal_quo']}', style: Theme.of(context).primaryTextTheme.headline1),
                              trailing: SizedBox(
                                height: 35,
                                child: TextButton.icon(
                                    onPressed: null,
                                    label: Icon(
                                      Icons.navigate_next,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    icon: Text(global.appLocaleValues['btn_view_all'], style: Theme.of(context).primaryTextTheme.bodyText2)),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SalesQuoteScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                        )));
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: (_isDataLoaded)
                                  ? ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _saleQuoteList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return _saleQuoteList[index].finalTax > 0
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
                                                  orderPrintOrShare: (_saleQuote, _isPrintAction, context) async {
                                                    var htmlContent = await _saleQuotePrintOrShare(_saleQuote, context, _isPrintAction);
                                                    return htmlContent;
                                                  },
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
                                                ),
                                              )
                                            : ListTileSaleQuoteWidget(
                                                key: ValueKey(_saleQuoteList[index].id),
                                                saleQuote: _saleQuoteList[index],
                                                a: widget.analytics,
                                                o: widget.observer,
                                                orderPrintOrShare: (_saleQuote, _isPrintAction, context) async {
                                                  var htmlContent = await _saleQuotePrintOrShare(_saleQuote, context, _isPrintAction);
                                                  return htmlContent;
                                                },
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
                                              );
                                      },
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Center(
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),

            (br.getSystemFlagValue(global.systemFlagNameList.enableSaleOrder) == "true" || _saleOrderList.length > 0)
                ? SizedBox(
                    height: 470,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                      child: Card(
                        shape: nativeTheme().cardTheme.shape,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text('${global.appLocaleValues['tle_recent_sale_order']}', style: Theme.of(context).primaryTextTheme.headline1),
                              trailing: SizedBox(
                                height: 35,
                                child: TextButton.icon(
                                    onPressed: null,
                                    label: Icon(
                                      Icons.navigate_next,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    icon: Text(global.appLocaleValues['btn_view_all'], style: Theme.of(context).primaryTextTheme.bodyText2)),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SaleOrderScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                        )));
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: (_isDataLoaded)
                                  ? ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _saleOrderList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return _saleOrderList[index].finalTax > 0
                                            ? Ribbon(
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
                                              )
                                            : ListTileSaleOrderWidget(
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
                                              );
                                      },
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Center(
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            (_saleInvoiceList.length > 0)
                ? SizedBox(
                    height: 500,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                      child: Card(
                        shape: nativeTheme().cardTheme.shape,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                "${global.appLocaleValues['tle_recent_sale']}",
                                style: Theme.of(context).primaryTextTheme.headline1,
                              ),
                              trailing: SizedBox(
                                height: 35,
                                child: TextButton.icon(
                                    onPressed: null,
                                    label: Icon(
                                      Icons.navigate_next,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    icon: Text(global.appLocaleValues['btn_view_all'], style: Theme.of(context).primaryTextTheme.bodyText2)),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SaleInvoiceScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                        )));
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: (_isDataLoaded)
                                  ? (_saleInvoiceList.isNotEmpty)
                                      ? ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: _saleInvoiceList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return (_saleInvoiceList[index].finalTax > 0)
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
                                                      invoicePrintOrShare: (_saleInvoice, _isPrintAction, context) async {
                                                        var htmlContent = await _invoicePrintOrShare(_saleInvoice, context, _isPrintAction);
                                                        return htmlContent;
                                                      },
                                                    ),
                                                  )
                                                : ListTileSaleInvoiceWidget(
                                                    key: ValueKey(_saleInvoiceList[index].id),
                                                    saleInvoice: _saleInvoiceList[index],
                                                    a: widget.analytics,
                                                    o: widget.observer,
                                                    invoicePrintOrShare: (_saleInvoice, _isPrintAction, context) async {
                                                      var htmlContent = await _invoicePrintOrShare(_saleInvoice, context, _isPrintAction);
                                                      return htmlContent;
                                                    },
                                                  );
                                          },
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(top: 140),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                                child: Icon(
                                                  Icons.assignment,
                                                  color: Colors.grey,
                                                  size: 50,
                                                ),
                                              ),
                                              FittedBox(
                                                child: Text(global.appLocaleValues['tle_recent_sale_empty_msg'], style: Theme.of(context).primaryTextTheme.headline6),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        )
                                  : Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Center(
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            // (br.getSystemFlagValue(global.systemFlagNameList.enableSalesReturn) == 'true' && _sTransactionGroupIdList.length > 0)
            //     ? SizedBox(
            //         height: 570,
            //         child: Card(
            //           shape: nativeTheme().cardTheme.shape,
            //           child: Column(
            //             children: <Widget>[
            //               ListTile(
            //                 title: Text(
            //                   global.appLocaleValues['tle_recent_sale_return'],
            //                   style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            //                 ),
            //                 trailing: TextButton.icon(
            //                     onPressed: null,
            //                     label: Icon(
            //                       Icons.navigate_next,
            //                       color: Theme.of(context).primaryColor,
            //                     ),
            //                     icon: Text(
            //                       global.appLocaleValues['btn_view_all'],
            //                       style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            //                     )),
            //                 onTap: () {
            //                   Navigator.of(context).push(MaterialPageRoute(
            //                       builder: (context) =>  SaleInvoiceReturnScreen(
            //                             a: widget.analytics,
            //                             o: widget.observer,
            //                           )));
            //                 },
            //               ),
            //               Padding(
            //                 padding: EdgeInsets.only(right: 0),
            //                 child: (_isDataLoaded)
            //                     ? (_sTransactionGroupIdList.isNotEmpty)
            //                         ? ListView.builder(
            //                             physics: NeverScrollableScrollPhysics(),
            //                             itemCount: _sTransactionGroupIdList.length,
            //                             shrinkWrap: true,
            //                             itemBuilder: (context, index) {
            //                               return ListTile(
            //                                 contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
            //                                 title: Text(
            //                                   '${br.generateAccountName(_sTransactionGroupIdList[index].account)}',
            //                                   overflow: TextOverflow.ellipsis,
            //                                   style: TextStyle(fontSize: 14),
            //                                 ),
            //                                 subtitle: Row(
            //                                   children: <Widget>[
            //                                     Text(
            //                                       '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_sTransactionGroupIdList[index].invoiceDate)}',
            //                                       overflow: TextOverflow.ellipsis,
            //                                     ),
            //                                     (_sTransactionGroupIdList[index].remainAmount != null)
            //                                         ? (_sTransactionGroupIdList[index].remainAmount < 0)
            //                                             ? Text(' ${global.appLocaleValues['lbl_credit']}: ${global.currency.symbol} ${(_sTransactionGroupIdList[index].remainAmount * -1).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: TextStyle(color: Colors.green))
            //                                             : Text(
            //                                                 ' ${global.appLocaleValues['lbl_due']}: ${global.currency.symbol} ${_sTransactionGroupIdList[index].remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
            //                                                 style: TextStyle(color: Colors.red),
            //                                               )
            //                                         : SizedBox()
            //                                   ],
            //                                 ),
            //                                 isThreeLine: true,
            //                                 trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            //                                   Text(
            //                                     '${global.currency.symbol} ${(_sTransactionGroupIdList[index].totalSpent != null) ? _sTransactionGroupIdList[index].totalSpent.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))) : 0.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
            //                                     style: TextStyle(
            //                                       fontWeight: FontWeight.bold,
            //                                       height: 0.9,
            //                                     ),
            //                                     textAlign: TextAlign.center,
            //                                   ),
            //                                   PopupMenuButton(
            //                                     itemBuilder: (context) => [
            //                                       PopupMenuItem(
            //                                         child: ListTile(
            //                                           contentPadding: EdgeInsets.zero,
            //                                           title: Row(
            //                                             children: <Widget>[
            //                                               Padding(
            //                                                 padding: const EdgeInsets.only(right: 10),
            //                                                 child: Icon(
            //                                                   Icons.remove_red_eye,
            //                                                   color: Theme.of(context).primaryColor,
            //                                                 ),
            //                                               ),
            //                                               Text(global.appLocaleValues['lt_view']),
            //                                             ],
            //                                           ),
            //                                           onTap: () async {
            //                                             try {
            //                                               Navigator.of(context).pop();

            //                                               Navigator.of(context).push(MaterialPageRoute(builder: (context) => SaleInvoiceReturnDetailScreen(a: widget.analytics, o: widget.observer, invoiceReturnList: _sTransactionGroupIdList[index].childList, remainAmount: _sTransactionGroupIdList[index].remainAmount)));
            //                                             } catch (e) {
            //                                               print('Exception - dashboardScreen.dart - _onTap(): ' + e.toString());
            //                                             }
            //                                           },
            //                                         ),
            //                                       ),
            //                                       (_sTransactionGroupIdList[index].status == 'PENDING')
            //                                           ? PopupMenuItem(
            //                                               child: ListTile(
            //                                                 contentPadding: EdgeInsets.zero,
            //                                                 title: Row(
            //                                                   children: <Widget>[
            //                                                     Padding(
            //                                                       padding: const EdgeInsets.only(right: 10),
            //                                                       child: Icon(
            //                                                         Icons.payment,
            //                                                         color: Theme.of(context).primaryColor,
            //                                                       ),
            //                                                     ),
            //                                                     Text(global.appLocaleValues['lt_give_payment']),
            //                                                   ],
            //                                                 ),
            //                                                 onTap: () {
            //                                                   Navigator.of(context).pop();
            //                                                   Navigator.of(context).push(MaterialPageRoute(
            //                                                       builder: (context) => PaymentAddScreen(
            //                                                             a: widget.analytics,
            //                                                             o: widget.observer,
            //                                                             saleInvoiceReturn: _sTransactionGroupIdList[index],
            //                                                             returnScreenId: 5,
            //                                                           )));
            //                                                 },
            //                                               ),
            //                                             )
            //                                           : null,
            //                                       (_sTransactionGroupIdList[index].status != 'CANCELLED' && _sTransactionGroupIdList[index].remainAmount < 0)
            //                                           ? PopupMenuItem(
            //                                               child: ListTile(
            //                                                 contentPadding: EdgeInsets.zero,
            //                                                 title: Row(
            //                                                   children: <Widget>[
            //                                                     Padding(
            //                                                       padding: const EdgeInsets.only(right: 10),
            //                                                       child: Icon(
            //                                                         Icons.payment,
            //                                                         color: Theme.of(context).primaryColor,
            //                                                       ),
            //                                                     ),
            //                                                     Text(global.appLocaleValues['lt_take_payment']),
            //                                                   ],
            //                                                 ),
            //                                                 onTap: () {
            //                                                   Navigator.of(context).pop();
            //                                                   Navigator.of(context).push(MaterialPageRoute(
            //                                                       builder: (context) => PaymentAddScreen(
            //                                                             a: widget.analytics,
            //                                                             o: widget.observer,
            //                                                             saleInvoiceReturn: _sTransactionGroupIdList[index],
            //                                                             returnScreenId: 6,
            //                                                           )));
            //                                                 },
            //                                               ),
            //                                             )
            //                                           : null,
            //                                     ],
            //                                   )
            //                                 ]),
            //                                 onTap: () async {
            //                                   try {
            //                                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => SaleInvoiceReturnDetailScreen(a: widget.analytics, o: widget.observer, invoiceReturnList: _sTransactionGroupIdList[index].childList, remainAmount: _sTransactionGroupIdList[index].remainAmount)));
            //                                   } catch (e) {
            //                                     print('Exception - dashboardScreen.dart - _onTap(): ' + e.toString());
            //                                   }
            //                                 },
            //                               );
            //                             },
            //                           )
            //                         : Container(
            //                             margin: const EdgeInsets.only(top: 140),
            //                             child: Column(
            //                               children: <Widget>[
            //                                 Padding(
            //                                   padding: EdgeInsets.only(top: 20, bottom: 10),
            //                                   child: Icon(
            //                                     Icons.assignment,
            //                                     color: Colors.grey,
            //                                     size: 50,
            //                                   ),
            //                                 ),
            //                                 FittedBox(
            //                                   child: Text(
            //                                     global.appLocaleValues['tle_recent_sale_return_empty_msg'],
            //                                     style: TextStyle(color: Colors.grey),
            //                                   ),
            //                                 ),
            //                                 SizedBox(
            //                                   height: 10,
            //                                 )
            //                               ],
            //                             ),
            //                           )
            //                     : Padding(
            //                         padding: EdgeInsets.only(bottom: 10),
            //                         child: Center(
            //                           child: CircularProgressIndicator(strokeWidth: 2),
            //                         ),
            //                       ),
            //               )
            //             ],
            //           ),
            //         ),
            //       )
            //     : SizedBox(),
            // (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true' && _purchaseInvoiceList.length > 0)
            //     ? SizedBox(
            //         height: 500,
            //         child: Card(
            //           shape: nativeTheme().cardTheme.shape,
            //           child: Column(
            //             children: <Widget>[
            //               ListTile(
            //                 title: Text(
            //                   global.appLocaleValues['tle_recent_purchase'],
            //                   style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            //                 ),
            //                 trailing: TextButton.icon(
            //                     onPressed: null,
            //                     label: Icon(Icons.navigate_next, color: Theme.of(context).primaryColor),
            //                     icon: Text(
            //                       global.appLocaleValues['btn_view_all'],
            //                       style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            //                     )),
            //                 onTap: () {
            //                   Navigator.of(context).push(MaterialPageRoute(
            //                       builder: (context) =>  PurchaseInvoiceScreen(
            //                             a: widget.analytics,
            //                             o: widget.observer,
            //                           )));
            //                 },
            //               ),
            //               Padding(
            //                 padding: EdgeInsets.only(right: 0),
            //                 child: (_isDataLoaded)
            //                     ? (_purchaseInvoiceList.isNotEmpty)
            //                         ? ListView.builder(
            //                             physics: NeverScrollableScrollPhysics(),
            //                             itemCount: _purchaseInvoiceList.length,
            //                             shrinkWrap: true,
            //                             itemBuilder: (context, index) {
            //                               return (_purchaseInvoiceList[index].finalTax > 0)
            //                                   ? Ribbon(
            //                                       nearLength: 47,
            //                                       farLength: 20,
            //                                       title: global.appLocaleValues['rbn_with_tax'],
            //                                       titleStyle: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
            //                                       color: Colors.green,
            //                                       location: RibbonLocation.values[1],
            //                                       child: ListTilePurchaseInvoiceWidget(
            //                                         key: ValueKey(_purchaseInvoiceList[index].id),
            //                                         purchaseInvoice: _purchaseInvoiceList[index],
            //                                         tabIndex: 2,
            //                                         a: widget.analytics,
            //                                         o: widget.observer,
            //                                         invoicePrintOrShare: (_purchaseInvoice, _isPrintAction, context) async {
            //                                           await _purchaseInvoicePrintOrShare(_purchaseInvoice, context, _isPrintAction);
            //                                         },
            //                                       ),
            //                                     )
            //                                   : ListTilePurchaseInvoiceWidget(
            //                                       key: ValueKey(_purchaseInvoiceList[index].id),
            //                                       purchaseInvoice: _purchaseInvoiceList[index],
            //                                       tabIndex: 2,
            //                                       a: widget.analytics,
            //                                       o: widget.observer,
            //                                       invoicePrintOrShare: (_purchaseInvoice, _isPrintAction, context) async {
            //                                         await _purchaseInvoicePrintOrShare(_purchaseInvoice, context, _isPrintAction);
            //                                       },
            //                                     );
            //                             },
            //                           )
            //                         : Container(
            //                             margin: const EdgeInsets.only(top: 140),
            //                             child: Column(
            //                               children: <Widget>[
            //                                 Padding(
            //                                   padding: EdgeInsets.only(top: 20, bottom: 10),
            //                                   child: Icon(
            //                                     Icons.assignment,
            //                                     color: Colors.grey,
            //                                     size: 50,
            //                                   ),
            //                                 ),
            //                                 FittedBox(
            //                                   child: Text(
            //                                     global.appLocaleValues['tle_recent_purchase_empty_msg'],
            //                                     style: TextStyle(color: Colors.grey),
            //                                   ),
            //                                 ),
            //                                 SizedBox(
            //                                   height: 10,
            //                                 )
            //                               ],
            //                             ),
            //                           )
            //                     : Padding(
            //                         padding: EdgeInsets.only(bottom: 10),
            //                         child: Center(
            //                           child: CircularProgressIndicator(strokeWidth: 2),
            //                         ),
            //                       ),
            //               )
            //             ],
            //           ),
            //         ),
            //       )
            //     : SizedBox(),
            // (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseReturn) == 'true' && _pTransactionGroupIdList.length > 0)
            //     ? SizedBox(
            //         height: 570,
            //         child: Card(
            //           shape: nativeTheme().cardTheme.shape,
            //           child: Column(
            //             children: <Widget>[
            //               ListTile(
            //                 title: Text(
            //                   global.appLocaleValues['tle_recent_purchase_return'],
            //                   style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            //                 ),
            //                 trailing: TextButton.icon(
            //                     onPressed: null,
            //                     label: Icon(Icons.navigate_next, color: Theme.of(context).primaryColor),
            //                     icon: Text(
            //                       global.appLocaleValues['btn_view_all'],
            //                       style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            //                     )),
            //                 onTap: () {
            //                   Navigator.of(context).push(MaterialPageRoute(
            //                       builder: (context) =>  PurchaseInvoiceReturnScreen(
            //                             a: widget.analytics,
            //                             o: widget.observer,
            //                           )));
            //                 },
            //               ),
            //               Padding(
            //                 padding: EdgeInsets.only(right: 0),
            //                 child: (_isDataLoaded)
            //                     ? (_pTransactionGroupIdList.isNotEmpty)
            //                         ? ListView.builder(
            //                             physics: NeverScrollableScrollPhysics(),
            //                             itemCount: _pTransactionGroupIdList.length,
            //                             shrinkWrap: true,
            //                             itemBuilder: (context, index) {
            //                               return ListTile(
            //                                 contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
            //                                 title: Text(
            //                                   '${br.generateAccountName(_pTransactionGroupIdList[index].account)}',
            //                                   overflow: TextOverflow.ellipsis,
            //                                   style: TextStyle(fontSize: 14),
            //                                 ),
            //                                 subtitle: Row(
            //                                   children: <Widget>[
            //                                     Text(
            //                                       '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_pTransactionGroupIdList[index].invoiceDate)}',
            //                                       overflow: TextOverflow.ellipsis,
            //                                     ),
            //                                     (_pTransactionGroupIdList[index].remainAmount != null)
            //                                         ? (_pTransactionGroupIdList[index].remainAmount < 0)
            //                                             ? Text(' ${global.appLocaleValues['lbl_credit']}: ${global.currency.symbol} ${(_pTransactionGroupIdList[index].remainAmount * -1).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: TextStyle(color: Colors.green))
            //                                             : Text(
            //                                                 ' ${global.appLocaleValues['lbl_due']}: ${global.currency.symbol} ${_pTransactionGroupIdList[index].remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
            //                                                 style: TextStyle(color: Colors.red),
            //                                               )
            //                                         : SizedBox()
            //                                   ],
            //                                 ),
            //                                 isThreeLine: true,
            //                                 trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            //                                   Text(
            //                                     '${global.currency.symbol} ${(_pTransactionGroupIdList[index].totalSpent != null) ? _pTransactionGroupIdList[index].totalSpent.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))) : 0.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
            //                                     style: TextStyle(
            //                                       fontWeight: FontWeight.bold,
            //                                       height: 0.9,
            //                                     ),
            //                                     textAlign: TextAlign.center,
            //                                   ),
            //                                   PopupMenuButton(
            //                                     itemBuilder: (context) => [
            //                                       PopupMenuItem(
            //                                         child: ListTile(
            //                                           contentPadding: EdgeInsets.zero,
            //                                           title: Row(
            //                                             children: <Widget>[
            //                                               Padding(
            //                                                 padding: const EdgeInsets.only(right: 10),
            //                                                 child: Icon(
            //                                                   Icons.remove_red_eye,
            //                                                   color: Theme.of(context).primaryColor,
            //                                                 ),
            //                                               ),
            //                                               Text(global.appLocaleValues['lt_view']),
            //                                             ],
            //                                           ),
            //                                           onTap: () async {
            //                                             try {
            //                                               Navigator.of(context).pop();

            //                                               Navigator.of(context).push(MaterialPageRoute(builder: (context) => PurchaseInvoiceReturnDetailScreen(a: widget.analytics, o: widget.observer, invoiceReturnList: _pTransactionGroupIdList[index].childList, remainAmount: _pTransactionGroupIdList[index].remainAmount)));
            //                                             } catch (e) {
            //                                               print('Exception - dashboardScreen.dart - _onTap(): ' + e.toString());
            //                                             }
            //                                           },
            //                                         ),
            //                                       ),
            //                                       (_pTransactionGroupIdList[index].status == 'PENDING')
            //                                           ? PopupMenuItem(
            //                                               child: ListTile(
            //                                                 contentPadding: EdgeInsets.zero,
            //                                                 title: Row(
            //                                                   children: <Widget>[
            //                                                     Padding(
            //                                                       padding: const EdgeInsets.only(right: 10),
            //                                                       child: Icon(
            //                                                         Icons.payment,
            //                                                         color: Theme.of(context).primaryColor,
            //                                                       ),
            //                                                     ),
            //                                                     Text(global.appLocaleValues['lt_take_payment']),
            //                                                   ],
            //                                                 ),
            //                                                 onTap: () {
            //                                                   Navigator.of(context).pop();
            //                                                   Navigator.of(context).push(MaterialPageRoute(
            //                                                       builder: (context) => PaymentAddScreen(
            //                                                             a: widget.analytics,
            //                                                             o: widget.observer,
            //                                                             purchaseInvoiceReturn: _pTransactionGroupIdList[index],
            //                                                             returnScreenId: 5,
            //                                                           )));
            //                                                 },
            //                                               ),
            //                                             )
            //                                           : null,
            //                                       (_pTransactionGroupIdList[index].status != 'CANCELLED' && _pTransactionGroupIdList[index].remainAmount < 0)
            //                                           ? PopupMenuItem(
            //                                               child: ListTile(
            //                                                 contentPadding: EdgeInsets.zero,
            //                                                 title: Row(
            //                                                   children: <Widget>[
            //                                                     Padding(
            //                                                       padding: const EdgeInsets.only(right: 10),
            //                                                       child: Icon(
            //                                                         Icons.payment,
            //                                                         color: Theme.of(context).primaryColor,
            //                                                       ),
            //                                                     ),
            //                                                     Text(global.appLocaleValues['lt_give_payment']),
            //                                                   ],
            //                                                 ),
            //                                                 onTap: () {
            //                                                   Navigator.of(context).pop();
            //                                                   Navigator.of(context).push(MaterialPageRoute(
            //                                                       builder: (context) => PaymentAddScreen(
            //                                                             a: widget.analytics,
            //                                                             o: widget.observer,
            //                                                             purchaseInvoiceReturn: _pTransactionGroupIdList[index],
            //                                                             returnScreenId: 6,
            //                                                           )));
            //                                                 },
            //                                               ),
            //                                             )
            //                                           : null,
            //                                     ],
            //                                   )
            //                                 ]),
            //                                 onTap: () async {
            //                                   try {
            //                                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => PurchaseInvoiceReturnDetailScreen(a: widget.analytics, o: widget.observer, invoiceReturnList: _pTransactionGroupIdList[index].childList, remainAmount: _pTransactionGroupIdList[index].remainAmount)));
            //                                   } catch (e) {
            //                                     print('Exception - dashboardScreen.dart - _onTap(): ' + e.toString());
            //                                   }
            //                                 },
            //                               );
            //                             },
            //                           )
            //                         : Container(
            //                             margin: const EdgeInsets.only(top: 140),
            //                             child: Column(
            //                               children: <Widget>[
            //                                 Padding(
            //                                   padding: EdgeInsets.only(top: 20, bottom: 10),
            //                                   child: Icon(
            //                                     Icons.assignment,
            //                                     color: Colors.grey,
            //                                     size: 50,
            //                                   ),
            //                                 ),
            //                                 FittedBox(
            //                                   child: Text(
            //                                     global.appLocaleValues['tle_recent_purchase_empty_msg'],
            //                                     style: TextStyle(color: Colors.grey),
            //                                   ),
            //                                 ),
            //                                 SizedBox(
            //                                   height: 10,
            //                                 )
            //                               ],
            //                             ),
            //                           )
            //                     : Padding(
            //                         padding: EdgeInsets.only(bottom: 10),
            //                         child: Center(
            //                           child: CircularProgressIndicator(strokeWidth: 2),
            //                         ),
            //                       ),
            //               )
            //             ],
            //           ),
            //         ),
            //       )
            //     : SizedBox(),
            (_paymentList.length > 0)
                ? SizedBox(
                    height: 570,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                      child: Card(
                        shape: nativeTheme().cardTheme.shape,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                global.appLocaleValues['tle_recent_payments'],
                                style: Theme.of(context).primaryTextTheme.headline1,
                              ),
                              trailing: SizedBox(
                                height: 35,
                                child: TextButton.icon(onPressed: null, label: Icon(Icons.navigate_next, color: Colors.white, size: 18), icon: Text(global.appLocaleValues['btn_view_all'], style: Theme.of(context).primaryTextTheme.bodyText2)),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                        )));
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: (_isDataLoaded)
                                  ? (_paymentList.isNotEmpty)
                                      ? ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: _paymentList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                                contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
                                                leading: CircleAvatar(
                                                  backgroundColor: Theme.of(context).primaryColorDark,
                                                  radius: 25,
                                                  child: Text(
                                                    '${global.currency.symbol} ${_paymentList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                    style: Theme.of(context).primaryTextTheme.bodyText2,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                title: Text(
                                                  (_paymentList[index].account != null) ? '${br.generateAccountName(_paymentList[index].account)}' : global.appLocaleValues['lbl_expense_cap'],
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context).primaryTextTheme.subtitle1,
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
                                                                (_paymentList[index].isSaleInvoiceRef)
                                                                    ? 'ref: ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _paymentList[index].invoiceNumber.toString().length))}${_paymentList[index].invoiceNumber}'
                                                                    : 'ref: ${_paymentList[index].invoiceNumber}',
                                                                style: Theme.of(context).primaryTextTheme.subtitle2)
                                                            : (_paymentList[index].isSaleInvoiceReturnRef)
                                                                ? Text(
                                                                    'ref: ${global.appLocaleValues['ref_sales_return']}',
                                                                    style: Theme.of(context).primaryTextTheme.subtitle2,
                                                                  )
                                                                : (_paymentList[index].isPurchaseInvoiceReturnRef)
                                                                    ? Text(
                                                                        'ref: ${global.appLocaleValues['ref_purchase_return']}',
                                                                        style: Theme.of(context).primaryTextTheme.subtitle2,
                                                                      )
                                                                    : (_paymentList[index].isExpenseRef)
                                                                        ? Text(
                                                                            'ref: ${global.appLocaleValues['lbl_expense_small']}',
                                                                            style: Theme.of(context).primaryTextTheme.subtitle2,
                                                                          )
                                                                        : (_paymentList[index].isSaleOrderRef)
                                                                            ? Text(
                                                                                'ref: ${global.appLocaleValues['lbl_sale_order_']} ${_paymentList[index].orderNumber}',
                                                                                style: Theme.of(context).primaryTextTheme.subtitle2,
                                                                              )
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
                                                      height: MediaQuery.of(context).size.height - 0.2,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          (_paymentList[index].paymentType == 'RECEIVED')
                                                              ? Text(
                                                                  '${_paymentList[index].paymentType}',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                                                                )
                                                              : Text('${_paymentList[index].paymentType}', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          (_paymentList[index].isCancel == true)
                                                              ? Text('CANCELLED', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, height: 1, fontSize: 12))
                                                              : SizedBox(
                                                                  width: 0,
                                                                )
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuButton(
                                                      icon: Icon(Icons.more_vert, color: Theme.of(context).primaryColor),
                                                      itemBuilder: (context) => [
                                                        (_paymentList[index].isCancel != true)
                                                            ? PopupMenuItem(
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
                                                              )
                                                            : null,
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
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                              _isPaymentPrintAction = false;
                                                              br.generatePaymentReceiptHtml(context, payment: _paymentList[index], isPrintAction: _isPaymentPrintAction);
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ));
                                          },
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(top: 135),
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
                                                  global.appLocaleValues['tle_recent_payments_empty_msg'],
                                                  style: Theme.of(context).primaryTextTheme.headline6,
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
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            (_expenseList.length > 0)
                ? SizedBox(
                    height: 570,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                      child: Card(
                        shape: nativeTheme().cardTheme.shape,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                '${global.appLocaleValues['tle_recent_expenses']}',
                                style: Theme.of(context).primaryTextTheme.headline1,
                              ),
                              trailing: SizedBox(
                                height: 35,
                                child: TextButton.icon(
                                    onPressed: null,
                                    label: Icon(Icons.navigate_next, color: Colors.white, size: 18),
                                    icon: Text(
                                      global.appLocaleValues['btn_view_all'],
                                      style: Theme.of(context).primaryTextTheme.bodyText2,
                                    )),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ExpenseScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                        )));
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: (_isDataLoaded)
                                  ? (_expenseList.isNotEmpty)
                                      ? ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: _expenseList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 20),
                                              leading: CircleAvatar(
                                                backgroundColor: Theme.of(context).primaryColorLight,
                                                foregroundColor: Colors.black,
                                                radius: 25,
                                                child: Text(
                                                  '${global.currency.symbol} ${_expenseList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                  style: Theme.of(context).primaryTextTheme.bodyText2,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              title: Text(
                                                '${_expenseList[index].expenseName != null && _expenseList[index].expenseName.isNotEmpty ? _expenseList[index].expenseName + ' - ' : ''}${_expenseList[index].expenseCategoryName}',
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).primaryTextTheme.subtitle1,
                                              ),
                                              subtitle: Text(
                                                '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(_expenseList[index].transactionDate.toString()))}',
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).primaryTextTheme.subtitle2,
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  (_expenseList[index].isPaid)
                                                      ? Text(
                                                          global.appLocaleValues['lbl_paid_cap'],
                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, height: 0.9),
                                                        )
                                                      : Text(
                                                          global.appLocaleValues['lbl_due_cap'],
                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, height: 0.9),
                                                        ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(top: 135),
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
                                                  global.appLocaleValues['lbl_recent_expense_empty_msg'],
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
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            // Padding(padding: const EdgeInsets.only(bottom: 20))
          ]))),
      bottomSheet: (global.availableBiometrics && br.getSystemFlagValue(global.systemFlagNameList.enableFingerPrint) != 'true' && (_fingerPrintSetup == null || !_fingerPrintSetup))
          ? Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Card(
                  shape: nativeTheme().cardTheme.shape,
                  child: Container(
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                child: Icon(
                                  Icons.fingerprint,
                                  color: Colors.blue[700],
                                  size: 30,
                                ),
                              ),
                              Text(
                                "${global.appLocaleValues['lbl_enable_fingrprint']}",
                                style: TextStyle(color: Colors.blue[700], fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                                child: TextButton(
                                  // color: Theme.of(context).primaryColorLight,
                                  // padding: EdgeInsets.all(0),
                                  child: Text('${global.appLocaleValues['btn_skip']}', style: Theme.of(context).primaryTextTheme.bodyText2),
                                  onPressed: () async {
                                    global.prefs.setBool('fingerprintSetup', true);
                                    _fingerPrintSetup = global.prefs.getBool('fingerprintSetup');
                                    setState(() {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['txt_enable_fingerprint']}')));
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: TextButton(
                                  // color: Theme.of(context).primaryColor,
                                  // padding: EdgeInsets.all(0),
                                  child: Text('${global.appLocaleValues['btn_set']}', style: Theme.of(context).primaryTextTheme.bodyText2),
                                  onPressed: () async {
                                    global.isAppOperation = true;
                                    await showDialog(
                                        context: context,
                                        builder: (_) {
                                          return EnableFingerprintDialog(
                                            a: widget.analytics,
                                            o: widget.observer,
                                          );
                                        }).then((value) {
                                      global.prefs.setBool('fingerprintSetup', true);
                                      _fingerPrintSetup = global.prefs.getBool('fingerprintSetup');
                                      setState(() {});
                                      if (value) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('${global.appLocaleValues['msg_fingerprint_success']}'),
                                          backgroundColor: Colors.green,
                                        ));
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }

  Future getData() async {
    try {
      if (global.isAndroidPlatform) {
        await checkForUpdate();
      }
      await _getTaxes();
      await getTotalNoOfActiveAccounts();
      await getTotalNoOfActiveInvoices();
      await getTotalNoOfActivePayments();
      await getPaymentDetail();
      await getExpenseData();
      await _getCustomers();
      if (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == "true") {
        await _getSuppliers();
      }
      await getTotalNoOfExpenses();
      await getSumOfPayemnts();
      //  await getTopSoldProducts();

      if (br.getSystemFlagValue(global.systemFlagNameList.enableSaleOrder) == "true") {
        await getSaleOrderList();
      }
      await getSaleInvoiceList();
      await getSaleQuoteList();
      // await getSaleInvoiceReturnList();
      // await getPurchaseInvoiceReturnList();
      // await getPurchaseInvoiceList();
      await getMapData();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - dashboardScreen.dart - getdata(): ' + e.toString());
    }
  }

  Future _getCustomers() async {
    try {
      _customerList += await dbHelper.accountGetList(accountType: 'Customer', startIndex: 0, isDue: true, fetchRecords: 5, orderBy: 'DESC', isActive: true, screenId: 0);
      for (int i = 0; i < _customerList.length; i++) {
        List<Payment> _paymentList = await dbHelper.paymentGetList(accountId: _customerList[i].id);
        double returnSaleInvoiceAmount = (_paymentList.length > 0) ? await dbHelper.paymentSaleInvoiceReturnGetSumOfAmount(paymentIdList: _paymentList.map((f) => f.id).toList()) : 0;
        _customerList[i].totalPaid -= returnSaleInvoiceAmount;
        _customerList[i].totalDue = _customerList[i].totalSpent - _customerList[i].totalPaid;
      }
      setState(() {});
    } catch (e) {
      print('Exception - DashBoard.dart - _getCustomers(): ' + e.toString());
    }
  }

  Future _getSuppliers() async {
    try {
      _supplierList += await dbHelper.accountGetList(accountType: 'Supplier', startIndex: 0, isDue: true, fetchRecords: 5, orderBy: 'DESC', isActive: true, screenId: 0);
      for (int i = 0; i < _supplierList.length; i++) {
        List<Payment> _paymentList = await dbHelper.paymentGetList(accountId: _supplierList[i].id);
        double returnPurchaseInvoiceAmount = (_paymentList.length > 0) ? await dbHelper.paymentPurchaseInvoiceReturnGetSumOfAmount(paymentIdList: _paymentList.map((f) => f.id).toList()) : 0;
        _supplierList[i].totalPaid -= returnPurchaseInvoiceAmount;
        _supplierList[i].totalDue = _supplierList[i].totalSpent - _supplierList[i].totalPaid;
      }
      setState(() {});
    } catch (e) {
      print('Exception - DashBoard.dart - _getSuppliers(): ' + e.toString());
    }
  }

  Future getSaleInvoiceList() async {
    try {
      _saleInvoiceList += await dbHelper.saleInvoiceGetList(startIndex: 0, fetchRecords: 5, orderBy: 'DESC');
      for (int i = 0; i < _saleInvoiceList.length; i++) {
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
      setState(() {});
    } catch (e) {
      print('Exception - dashboard.dart - getSaleInvoiceList(): ' + e.toString());
    }
  }

  Future getSaleOrderList() async {
    try {
      _saleOrderList += await dbHelper.saleOrderGetList(startIndex: 0, fetchRecords: 5, orderBy: 'DESC');
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

  Future getSaleQuoteList() async {
    try {
      _saleQuoteList += await dbHelper.saleQuoteGetList(startIndex: 0, fetchRecords: 5, orderBy: 'DESC');
      for (int i = 0; i < _saleQuoteList.length; i++) {
        List<SaleQuoteDetail> _saleQuoteDetailList = await dbHelper.saleQuoteDetailGetList(orderIdList: [_saleQuoteList[i].id]);
        _saleQuoteList[i].totalProducts = _saleQuoteDetailList.length;
        // List<PaymentSaleOrder> _paymentOrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [_saleOrderList[i].id], isCancel: false);
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
        // _saleQuoteList[i].isEditable = await dbHelper.saleQuoteisUsed(_saleQuoteList[i].id);
        // _saleQuoteList[i].isEditable = !_saleQuoteList[i].isEditable;
      }
      setState(() {});
    } catch (e) {
      print('Exception - dashboard.dart - getSaleQuoteList(): ' + e.toString());
    }
  }

  // Future getSaleInvoiceReturnList() async {
  //   try {
  //     _sTransactionGroupIdList += await dbHelper.saleInvoiceReturnTransactionGroupGetList(startIndex: 0, fetchRecords: 5, orderBy: 'DESC');
  //     for (int i = 0; i < _sTransactionGroupIdList.length; i++) {
  //       _sTransactionGroupIdList[i].childList = await dbHelper.saleInvoiceReturnGetList(transactionGroupIdList: [_sTransactionGroupIdList[i].transactionGroupId]);
  //       List<PaymentSaleInvoiceReturn> _paymentSaleInvoiceReturnList = await dbHelper.paymentSaleInvoiceReturnGetList(transactionGroupId: _sTransactionGroupIdList[i].transactionGroupId);
  //       List<Payment> _paymentList = (_paymentSaleInvoiceReturnList.length > 0) ? await dbHelper.paymentGetList(paymentIdList: _paymentSaleInvoiceReturnList.map((f) => f.paymentId).toList()) : [];
  //       double _receivedAmount = 0;
  //       double _givenAmount = 0;
  //       if (_paymentList.length > 0) {
  //         _paymentList.forEach((item) {
  //           if (item.paymentType == 'GIVEN') {
  //             _receivedAmount += item.amount;
  //           } else {
  //             _givenAmount += item.amount;
  //           }
  //         });
  //       }
  //       _sTransactionGroupIdList[i].remainAmount = (_paymentList.length != 0) ? (_sTransactionGroupIdList[i].totalSpent - (_receivedAmount - _givenAmount)) : _sTransactionGroupIdList[i].totalSpent;
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     print('Exception - dashboard.dart - getSaleInvoiceReturnList(): ' + e.toString());
  //   }
  // }

  // Future getPurchaseInvoiceReturnList() async {
  //   try {
  //     _pTransactionGroupIdList += await dbHelper.purchaseInvoiceReturnTransactionGroupGetList(startIndex: 0, fetchRecords: 5, orderBy: 'DESC');
  //     for (int i = 0; i < _pTransactionGroupIdList.length; i++) {
  //       _pTransactionGroupIdList[i].childList = await dbHelper.purchaseInvoiceReturnGetList(transactionGroupIdList: [_pTransactionGroupIdList[i].transactionGroupId]);
  //       List<PaymentPurchaseInvoiceReturn> _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(transactionGroupId: _pTransactionGroupIdList[i].transactionGroupId);
  //       List<Payment> _paymentList = (_paymentPurchaseInvoiceReturnList.length > 0) ? await dbHelper.paymentGetList(paymentIdList: _paymentPurchaseInvoiceReturnList.map((f) => f.paymentId).toList()) : [];
  //       double _receivedAmount = 0;
  //       double _givenAmount = 0;
  //       if (_paymentList.length > 0) {
  //         _paymentList.forEach((item) {
  //           if (item.paymentType == 'RECEIVED') {
  //             _receivedAmount += item.amount;
  //           } else {
  //             _givenAmount += item.amount;
  //           }
  //         });
  //       }
  //       _pTransactionGroupIdList[i].remainAmount = (_paymentList.length != 0) ? (_pTransactionGroupIdList[i].totalSpent - (_receivedAmount - _givenAmount)) : _pTransactionGroupIdList[i].totalSpent;
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     print('Exception - dashboard.dart - getPurchaseInvoiceReturnList(): ' + e.toString());
  //   }
  // }

  // Future getPurchaseInvoiceList() async {
  //   try {
  //     _purchaseInvoiceList += await dbHelper.purchaseInvoiceGetList(startIndex: 0, fetchRecords: 5, orderBy: 'DESC');
  //     for (int i = 0; i < _purchaseInvoiceList.length; i++) {
  //       List<PurchaseInvoiceDetail> _purchaseInvoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(invoiceId: _purchaseInvoiceList[i].id);
  //       _purchaseInvoiceList[i].totalProducts = _purchaseInvoiceDetailList.length;
  //       _purchaseInvoiceList[i].returnProducts = await dbHelper.purchaseInvoiceReturnDetailGetCount(purchaseInvoiceId: _purchaseInvoiceList[i].id);
  //       List<PaymentPurchaseInvoice> _paymentInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(invoiceId: _purchaseInvoiceList[i].id, isCancel: false);
  //       List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
  //       double _receivedAmount = 0;
  //       double _givenAmount = 0;
  //       if (_paymentList.length != 0) {
  //         _paymentList.forEach((item) {
  //           if (item.paymentType == 'GIVEN') {
  //             _receivedAmount += item.amount;
  //           } else {
  //             _givenAmount += item.amount;
  //           }
  //         });
  //       }
  //       _purchaseInvoiceList[i].remainAmount = (_paymentList.length != 0) ? (_purchaseInvoiceList[i].netAmount - (_receivedAmount - _givenAmount)) : _purchaseInvoiceList[i].netAmount;
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     print('Exception - dashboard.dart - getPurchaseInvoiceList(): ' + e.toString());
  //   }
  // }

  Future getMapData() async {
    try {
      _salesMapFLSpotList.clear();
      _purchaseMapFLSpotList.clear();
      _purchaseBusinessChartList.clear();
      _salesBusinessChartList.clear();
      _salesBusinessChartList = await dbHelper.saleInvoiceBusinessMapData(totalMonths: _totalMonth, isMonthWise: (_isMonthWise) ? true : false);
      _purchaseBusinessChartList = await dbHelper.purchaseInvoiceBusinessMapData(totalMonths: _totalMonth, isMonthWise: (_isMonthWise) ? true : false);
      for (int i = 0; i < _salesBusinessChartList.length; i++) {
        _salesMapFLSpotList.add(FlSpot(_salesBusinessChartList[i].date.microsecondsSinceEpoch.toDouble(), _salesBusinessChartList[i].totalAmount));
      }
      for (int i = 0; i < _purchaseBusinessChartList.length; i++) {
        _purchaseMapFLSpotList.add(FlSpot(_purchaseBusinessChartList[i].date.microsecondsSinceEpoch.toDouble(), _purchaseBusinessChartList[i].totalAmount));
      }
      setState(() {});
    } catch (e) {
      print('Exception - dashboardScreen.dart - getMapData(): ' + e.toString());
    }
  }

  Future getTotalNoOfActiveAccounts() async {
    try {
      _noOfActiveAccounts = await dbHelper.accountGetCount(isActive: true, accountType: 'Customer');
      setState(() {});
    } catch (e) {
      print('Exception - dashboardScreen.dart - getTotalNoOfActiveAccounts(): ' + e.toString());
    }
  }

  Future getTotalNoOfActiveInvoices() async {
    try {
      _noOfActiveInvoices = await dbHelper.saleInvoiceGetCount();
      _sumOfInvoicesAmount = await dbHelper.saleInvoiceGetSumOfGrossAmount();
      double _sumOfInvoiceReturnsAmount = await dbHelper.saleInvoiceReturnGetSumOfGrossAmount();
      if (_sumOfInvoicesAmount == null) {
        _sumOfInvoicesAmount = 0.0;
      }
      if (_sumOfInvoiceReturnsAmount == null) {
        _sumOfInvoiceReturnsAmount = 0.0;
      }
      _sumOfInvoicesAmount = _sumOfInvoicesAmount - _sumOfInvoiceReturnsAmount;
      setState(() {});
    } catch (e) {
      print('Exception - dashboardScreen.dart - getTotalNoOfActiveInvoices(): ' + e.toString());
    }
  }

  Future getPaymentDetail() async {
    try {
      _paymentList = await dbHelper.paymentGetList(startIndex: 0, fetchRecords: 5, orderBy: 'DESC');
      for (int i = 0; i < _paymentList.length; i++) {
        if (_paymentList[i].accountId != null) {
          List<Account> _accountList = await dbHelper.accountGetList(accountId: _paymentList[i].accountId);
          _paymentList[i].account = (_accountList.length > 0) ? _accountList[0] : null;
        }
        List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(paymentId: _paymentList[i].id);
        PaymentSaleInvoice _paymentInvoice = (_paymentInvoiceList.length != 0) ? _paymentInvoiceList[0] : null;
        // List<PaymentPurchaseInvoice> _paymentPurchaseInvoiceList;
        // PaymentPurchaseInvoice _paymentPurchaseInvoice;
        // List<PaymentSaleInvoiceReturn> _paymentSaleInvoiceReturnList;
        // PaymentSaleInvoiceReturn _paymentSaleInvoiceReturn;
        // List<PaymentPurchaseInvoiceReturn> _paymentPurchaseInvoiceReturnList;
        // PaymentPurchaseInvoiceReturn _paymentPurchaseInvoiceReturn;
        // PaymentSaleOrder _paymentSaleOrder;
        // List<PaymentSaleOrder> _paymentSaleOrderList;
        ExpensePayments _expensePayment;
        // List<ExpensePayments> _expensePaymentList;
        // if (_paymentInvoice == null) {
        //   _paymentPurchaseInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(paymentId: _paymentList[i].id);
        //   _paymentPurchaseInvoice = (_paymentPurchaseInvoiceList.length != 0) ? _paymentPurchaseInvoiceList[0] : null;
        // }
        // if (_paymentPurchaseInvoice == null) {
        //   _paymentSaleInvoiceReturnList = await dbHelper.paymentSaleInvoiceReturnGetList(paymentId: _paymentList[i].id);
        //   _paymentSaleInvoiceReturn = (_paymentSaleInvoiceReturnList.length != 0) ? _paymentSaleInvoiceReturnList[0] : null;
        // }
        // if (_paymentSaleInvoiceReturn == null) {
        //   _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(paymentId: _paymentList[i].id);
        //   _paymentPurchaseInvoiceReturn = (_paymentPurchaseInvoiceReturnList.length > 0) ? _paymentPurchaseInvoiceReturnList[0] : null;
        // }
        // if (_paymentPurchaseInvoiceReturn == null) {
        //   _paymentSaleOrderList = await dbHelper.paymentSaleOrderGetList(paymentIdList: [_paymentList[i].id]);
        //   _paymentSaleOrder = (_paymentSaleOrderList.length > 0) ? _paymentSaleOrderList[0] : null;
        // }
        // if (_paymentSaleOrder == null) {
        //   _expensePaymentList = await dbHelper.expensePaymentsGetList(paymentId: _paymentList[i].id);
        //   _expensePayment = (_expensePaymentList.length > 0) ? _expensePaymentList[0] : null;
        // }
        if (_paymentInvoice != null) {
          _paymentList[i].invoiceNumber = _paymentInvoice.invoiceNumber;
          _paymentList[i].isSaleInvoiceRef = true;
        }
        // else if (_paymentPurchaseInvoice != null) {
        //   _paymentList[i].invoiceNumber = _paymentPurchaseInvoice.invoiceNumber;
        //   _paymentList[i].isPurchaseInvoiceRef = true;
        // } else if (_paymentSaleInvoiceReturn != null) {
        //   _paymentList[i].isSaleInvoiceReturnRef = true;
        // } else if (_paymentPurchaseInvoiceReturn != null) {
        //   _paymentList[i].isPurchaseInvoiceReturnRef = true;
        // } else if (_paymentSaleOrder != null) {
        //   _paymentList[i].orderNumber = _paymentSaleOrder.orderNumber;
        //   _paymentList[i].isSaleOrderRef = true;
        // }
        else if (_expensePayment != null) {
          _paymentList[i].isExpenseRef = true;
        }
      }
      setState(() {});
    } catch (e) {
      print('Exception - dashboardScreen.dart - getPaymentDetail(): ' + e.toString());
    }
  }

  Future getTotalNoOfActivePayments() async {
    try {
      _noOfActivePayments = await dbHelper.paymentGetCount();
      setState(() {});
    } catch (e) {
      print('Exception - dashboardScreen.dart - getTotalNoOfActivePayments(): ' + e.toString());
    }
  }

  Future getSumOfPayemnts() async {
    try {
      _sumOfPaymentAmount = await dbHelper.paymentGetSumOfAmount();
      setState(() {});
    } catch (e) {
      print('Exception - dashboardScreen.dart - getSumOfPayemnts(): ' + e.toString());
    }
  }

  Future getExpenseData() async {
    try {
      _sumOfExpeneseAmount = await dbHelper.expenseGetSumOfAmount();
      _expenseList += await dbHelper.expenseGetList(startIndex: 0, fetchRecords: 5);
      setState(() {});
    } catch (e) {
      print('Exception - dashboardScreen.dart - getExpenseData(): ' + e.toString());
    }
  }

  Future getTotalNoOfExpenses() async {
    try {
      _noOfExpenses = await dbHelper.expenseGetCount();
      setState(() {});
    } catch (e) {
      print('Exception - dashboardScreen.dart - getTotalNoOfExpenses(): ' + e.toString());
    }
  }

  // Future getTopSoldProducts() async {
  //   try {
  //     List<UnitCombination> _unitcombinationList = await dbHelper.unitCombinationGetList();
  //     List<Product> _tempProductList = await dbHelper.productGetList();
  //     List<SaleInvoiceDetail> _saleInvoiceDetailList = await dbHelper.saleInvoiceDetailGetList();
  //     List<SaleInvoiceReturnDetail> _saleInvoiceReturnDetailList = await dbHelper.saleInvoiceReturnDetailGetList();
  //     _tempProductList.forEach((element) {
  //       UnitCombination _unitCombination = _unitcombinationList.firstWhere((e) => e.id == element.unitCombinationId);
  //       double _primaryUnitQty = 0;
  //       double _secondaryUnitQty = 0;
  //       _saleInvoiceDetailList.forEach((e) {
  //         // calculate sold qty
  //         if (element.id == e.productId) {
  //           if (e.unitId == _unitCombination.primaryUnitId) {
  //             _primaryUnitQty += e.quantity;
  //           } else {
  //             _secondaryUnitQty += e.quantity;
  //           }
  //         }
  //       });
  //       _saleInvoiceReturnDetailList.forEach((e) {
  //         // reduce return qty
  //         if (element.id == e.productId) {
  //           if (e.unitId == _unitCombination.primaryUnitId) {
  //             _primaryUnitQty -= e.quantity;
  //           } else {
  //             _secondaryUnitQty -= e.quantity;
  //           }
  //         }
  //       });
  //       if (_unitCombination.measurement != null) {
  //         _primaryUnitQty += _secondaryUnitQty / _unitCombination.measurement;
  //       }
  //       element.soldQty = _primaryUnitQty;
  //     });
  //     _tempProductList.sort((a, b) => a.soldQty.compareTo(b.soldQty)); // sort product list based on sold qty
  //     _tempProductList.removeWhere((element) => element.soldQty == 0); // remove unsold prosucts
  //     if (_tempProductList.length < 6) {
  //       _productList = _tempProductList.toList();
  //     } else {
  //       _tempProductList = _tempProductList.reversed.toList();
  //       _productList = _tempProductList.sublist(0, 5);
  //     }
  //     for (int i = 0; i < _productList.length; i++) {
  //       _productList[i].productPriceList = await dbHelper.productPriceGetList(_productList[i].id);
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     print('Exception - dashboardScreen.dart - getTopSoldProducts(): ' + e.toString());
  //   }
  // }

  Future<String> _invoicePrintOrShare(SaleInvoice _saleInvoice, context, bool _isPrintAction) async {
    try {
      global.isAppOperation = true;
      List<Account> _accountList = await dbHelper.accountGetList(accountId: _saleInvoice.accountId);
      _saleInvoice.account = _accountList[0];
      _saleInvoice.invoiceDetailList = await dbHelper.saleInvoiceDetailGetList(invoiceIdList: [_saleInvoice.id]);
      _saleInvoice.invoiceTaxList = await dbHelper.saleInvoiceTaxGetList(invoiceId: _saleInvoice.id);
      _saleInvoice.invoiceDetailTaxList = await dbHelper.saleInvoiceDetailTaxGetList(invoiceDetailIdList: _saleInvoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.id).toList());
      //  String _address = (_account.addressLine1.isNotEmpty && _account.state.isNotEmpty && _account.country.isNotEmpty && _account.pincode != null) ? ' ${_account.addressLine1}, ${_account.city}, ${_account.state}, ${_account.country}, ${_account.pincode}' : ' ${_account.city}';
      List<PaymentSaleInvoice> _paymentInvoiceList = [];
      // List<SaleInvoiceReturnDetail> _returnProductList = [];
      // List<TaxMaster> _returnProductTaxList = [];
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
      _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(invoiceId: _saleInvoice.id, isCancel: false);
      _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
      // if (_saleInvoice.returnProducts > 0) {
      //   _returnProductList = await dbHelper.saleInvoiceReturnDetailGetList(saleInvoiceIdList: [_saleInvoice.id]);
      //   List<SaleInvoiceReturnDetailTax> _saleInvoiceReturnDetailTaxList = await dbHelper.saleInvoiceReturnDetailTaxGetList(invoiceReturnDetailIdList: _returnProductList.map((f) => f.id).toList());
      //   List<SaleInvoiceReturn> _saleInvoiceReturnList = await dbHelper.saleInvoiceReturnGetList(invoiceReturnIdList: [_returnProductList[0].saleInvoiceReturnId]);
      //   SaleInvoiceReturn _saleInvoiceReturn = (_saleInvoiceReturnList.length > 0) ? _saleInvoiceReturnList[0] : null;
      //   _returnProductPaymentStatus = _saleInvoiceReturn.status;
      //   if (_saleInvoice.generateByProductCategory) {
      //     // generate return  by product category
      //     _returnProductList.forEach((items) {
      //       int _isExistCategory = 0;
      //       _saleInvoice.returnGenerateByCategoryList.forEach((f) {
      //         if (f.productCategoryName == items.productTypeName) {
      //           _isExistCategory++;
      //         }
      //       });
      //       if (_isExistCategory == 0) {
      //         ReturnGenerateByCategory _returnGenerateByProductCategory =  ReturnGenerateByCategory();
      //         _returnGenerateByProductCategory.productCategoryName = items.productTypeName;
      //         List<SaleInvoiceReturnDetail> _saleInvoiceReturnDetailList = _returnProductList.where((f) => f.productTypeName == items.productTypeName).toList();
      //         _returnGenerateByProductCategory.quantity = _saleInvoiceReturnDetailList.length;
      //         _returnGenerateByProductCategory.amount = _saleInvoiceReturnDetailList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
      //         _saleInvoice.returnGenerateByCategoryList.add(_returnGenerateByProductCategory);
      //       }
      //     });
      //   }
      //   if (_saleInvoiceReturnDetailTaxList.length > 0) // when sales return tax is product wise
      //   {
      //     _returnProductTaxList = await dbHelper.taxMasterGetList(taxMasterIdList: _saleInvoiceReturnDetailTaxList.map((f) => f.taxId).toSet().toList());
      //     _returnProductTaxList.forEach((f) {
      //       double _taxAmount = 0;
      //       _saleInvoiceReturnDetailTaxList.forEach((item) {
      //         if (item.taxId == f.id) {
      //           _taxAmount += item.taxAmount;
      //         }
      //       });
      //       f.taxAmount = _taxAmount;
      //     });
      //     _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
      //     _returnProductfinalTotal = _returnProductSubTotal + _returnProductTaxList.map((f) => f.taxAmount).reduce((sum, amt) => sum + amt);
      //   } else // when sales return tax is tax wise
      //   {
      //     List<SaleInvoiceReturnTax> _saleInvoiceReturnTaxList = await dbHelper.saleInvoiceReturnTaxGetList(invoiceReturnId: _returnProductList[0].saleInvoiceReturnId);
      //     if (_saleInvoiceReturn != null) {
      //       if (_saleInvoiceReturnTaxList.length > 0) {
      //         _returnProductTaxList = await dbHelper.taxMasterGetList(taxMasterIdList: _saleInvoiceReturnTaxList.map((f) => f.taxId).toList());
      //         _returnProductTaxList.forEach((item) {
      //           item.taxAmount = (item.percentage * _saleInvoiceReturn.netAmount) / 100;
      //         });
      //         _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
      //         _returnProductfinalTotal = _returnProductSubTotal + _returnProductTaxList.map((f) => f.taxAmount).reduce((sum, amt) => sum + amt);
      //       } else // when sales return tax not available
      //       {
      //         _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
      //         _returnProductfinalTotal = _returnProductSubTotal;
      //       }
      //     }
      //   }
      // }
      //  Navigator.pop(context);
      if (_isPrintAction != null) {
        br.generateSaleInvoiceHtml(context, invoice: _saleInvoice, isPrintAction: _isPrintAction, returnProductPaymentStatus: _returnProductPaymentStatus, returnProductSubTotal: _returnProductSubTotal, returnProductfinalTotal: _returnProductfinalTotal);
      } else {
        htmlContent = br.generateSaleInvoiceHtml(context, invoice: _saleInvoice, isPrintAction: _isPrintAction, returnProductPaymentStatus: _returnProductPaymentStatus, returnProductSubTotal: _returnProductSubTotal, returnProductfinalTotal: _returnProductfinalTotal);
      }
      return htmlContent;
    } catch (e) {
      print('Exception - dashboardScreen.dart - _invoicePrintOrShare(): ' + e.toString());
      return null;
    }
  }

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

  Future<String> _saleQuotePrintOrShare(SaleQuote _saleQuote, context, bool _isPrintAction) async {
    try {
      global.isAppOperation = true;
      List<Account> _accountList = await dbHelper.accountGetList(accountId: _saleQuote.accountId);
      _saleQuote.account = _accountList[0];
      _saleQuote.quoteDetailList = await dbHelper.saleQuoteDetailGetList(orderIdList: [_saleQuote.id]);
      _saleQuote.quoteTaxList = await dbHelper.saleQuoteTaxGetList(saleQuoteId: _saleQuote.id);
      _saleQuote.quoteDetailTaxList = await dbHelper.saleQuoteDetailTaxGetList(quoteDetailIdList: _saleQuote.quoteDetailList.map((quoteDetail) => quoteDetail.id).toList());
      //  String _address = (_account.addressLine1.isNotEmpty && _account.state.isNotEmpty && _account.country.isNotEmpty && _account.pincode != null) ? ' ${_account.addressLine1}, ${_account.city}, ${_account.state}, ${_account.country}, ${_account.pincode}' : ' ${_account.city}';
      // List<PaymentSaleOrder> _paymentSaleOrderList = [];
      // List<Payment> _paymentList = [];
      // List<PaymentDetail> _paymentDetailList = [];
      var htmlContent;
      // _paymentSaleOrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [_saleOrder.id], isCancel: false);
      // _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentSaleOrderList.map((paymentSaleOrder) => paymentSaleOrder.paymentId).toList());
      // _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleOrderList.map((paymentSaleOrder) => paymentSaleOrder.paymentId).toList());
      // if (_paymentList.length != 0) {
      //   _paymentList.forEach((item) {
      //     if (item.paymentType == 'RECEIVED') {
      //       _paymentDetailList.forEach((paymentDetail) {
      //         if (item.id == paymentDetail.paymentId) {
      //           if (paymentDetail.paymentMode == 'Cheque') {
      //             _saleOrder.paymentByCheque += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'Cash') {
      //             _saleOrder.paymentByCash += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'Card') {
      //             _saleOrder.paymentByCard += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'EWallet' || paymentDetail.paymentMode == 'eWallet') {
      //             _saleOrder.paymentByEWallet += paymentDetail.amount;
      //           } else {
      //             _saleOrder.paymentByNetBanking += paymentDetail.amount;
      //           }
      //         }
      //       });
      //     }
      //   });
      // }
      //  Navigator.pop(context);
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
      print('Exception - dashboardScreen.dart - _saleOrderPrintOrShare(): ' + e.toString());
      return null;
    }
  }

  // Future _purchaseInvoicePrintOrShare(PurchaseInvoice _purchaseInvoice, context, bool _isPrintAction) async {
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
  //     // Navigator.pop(context);
  //     br.generatePurchaseInvoiceHtml(context, invoice: _purchaseInvoice, isPrintAction: _isPrintAction, returnProductList: _returnProductList, returnProductPaymentStatus: _returnProductPaymentStatus, returnProductSubTotal: _returnProductSubTotal, returnProductTaxList: _returnProductTaxList, returnProductfinalTotal: _returnProductfinalTotal);
  //   } catch (e) {
  //     print('Exception - dashboardScreen.dart - _purchaseInvoicePrintOrShare(): ' + e.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _backUpData();
    getData();
    //  isShowingMainData = true;
    _isDataLoaded = true;
    setState(() {});
    // backupStatusRefresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // _backUpData() async {
  //   try {
  //     if (global.backupResult == null) {
  //       String _backUpTimeInDB = br.getSystemFlagValue(global.systemFlagNameList.backUpTime);
  //       if (_backUpTimeInDB != null && _backUpTimeInDB.isNotEmpty) {
  //         DateTime _backUpTime = DateTime.parse(_backUpTimeInDB);
  //         DateTime _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //         if (DateTime(_backUpTime.year, _backUpTime.month, _backUpTime.day) != _today) {
  //           if (br.getSystemFlagValue(global.systemFlagNameList.dbChanged) == 'true') {
  //             if (global.isAppStarted) {
  //               global.backupResult =  MethodResult();
  //               global.backupResult.statusMessage = '${global.appLocaleValues['txt_taking_backup']}';
  //               setState(() {});
  //               // global.backupResult = await backUp(true);
  //             }
  //           }
  //         }
  //       }
  //       global.isAppStarted = false;
  //     }
  //   } catch (e) {
  //     print("Exception - dashboardScreen.dart - _backUpData():" + e.toString());
  //   }
  // }

  LineChartData mapData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        // touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          //  rotateAngle: 50,
          showTitles: true,
          reservedSize: 22,
          // textStyle: const TextStyle(
          //   color: Color(0xFF000084),
          //   fontWeight: FontWeight.bold,
          //   fontSize: 10,
          // ),
          margin: 10,
          getTitles: (value) {
            if (_isMonthWise) {
              switch (value.toInt()) {
                case 1:
                  return 'JAN';
                case 2:
                  return 'FEB';
                case 3:
                  return 'MAR';
                case 4:
                  return 'APR';
                case 5:
                  return 'MAY';
                case 6:
                  return 'JUN';
                case 7:
                  return 'JUL';
                case 8:
                  return 'AUG';
                case 9:
                  return 'SEP';
                case 10:
                  return 'OCT';
                case 11:
                  return 'NOV';
                case 12:
                  return 'DEC';
              }
            } else {
              int d = value.toInt();
              DateTime dd = DateTime.fromMicrosecondsSinceEpoch(d);
              return '${DateFormat('dd MMM').format((dd.subtract(Duration(days: dd.weekday - 1))))} to ${DateFormat('dd MMM').format((dd.add(Duration(days: DateTime.daysPerWeek - dd.weekday))))}'; // WeekWise Date Display
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
          // textStyle: const TextStyle(
          //   color: Color(0xFF4e2eb5),
          //   fontWeight: FontWeight.bold,
          //   fontSize: 14,
          // ),
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 2,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: (_isMonthWise)
          ? (_totalMonth != 1)
              ? DateTime(DateTime.now().year, DateTime.now().month - (_totalMonth - 1)).month.toDouble()
              : DateTime.now().month.toDouble()
          : 1,
      maxX: (_isMonthWise) ? DateTime.now().month.toDouble() : 15,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    //sales code start
    final LineChartBarData salesLineChartBarData = LineChartBarData(
      spots: (_salesMapFLSpotList.length > 0) ? _salesMapFLSpotList : [FlSpot(0, 0)],
      isCurved: true,
      colors: [
        const Color(0xFF000084),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    //sales code end
    //purchase code start
    final LineChartBarData purchaseLineChartBarData = LineChartBarData(
      spots: (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true' && _purchaseMapFLSpotList.length > 0) ? _purchaseMapFLSpotList : [FlSpot(0, 0)],
      isCurved: true,
      colors: [
        const Color(0xFF4e2eb5), //
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    //purchase code end
    return [salesLineChartBarData, purchaseLineChartBarData];
  }

  Future _monthChanged() async {
    _isDataLoaded = false;
    setState(() {});
    await getMapData();
    _isDataLoaded = true;
    setState(() {});
  }

  List<BarChartGroupData> showingGroups() => List.generate((_salesMapFLSpotList.length > _purchaseMapFLSpotList.length) ? _salesMapFLSpotList.length : _purchaseMapFLSpotList.length, (i) {
        int _x = ((_salesMapFLSpotList.length - 1) >= i) ? _salesMapFLSpotList[i].x.toInt() : _purchaseMapFLSpotList[i].x.toInt();
        double _y1 = ((_salesMapFLSpotList.length - 1) >= i) ? _salesMapFLSpotList[i].y : 0;
        double _y2 = ((br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true') && (_purchaseMapFLSpotList.length - 1) >= i) ? _purchaseMapFLSpotList[i].y : 0;
        final barGroup1 = makeGroupData(_x, _y1, _y2);
        return barGroup1;
      });

  BarChartData barMapData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      barTouchData: BarTouchData(
        allowTouchBarBackDraw: true,
        enabled: false,
        handleBuiltInTouches: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          // tooltipBottomMargin: 10,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.y.round() > 0 ? NumberFormat.compactCurrency(decimalDigits: 1, symbol: '', locale: 'en_IN').format(rod.y.round()).replaceAll('T', 'K') : '',
              TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
              //   rotateAngle: 50.0,
              showTitles: true,
              // textStyle: const TextStyle(
              //   color: Colors.white,
              //   fontWeight: FontWeight.bold,
              //   fontSize: 10,
              // ),
              margin: 10,
              getTitles: (double value) {
                int d = value.toInt();
                DateTime dd = DateTime.fromMicrosecondsSinceEpoch(d);
                if (_isMonthWise) {
                  return '${DateFormat('MMM').format(dd)} ${DateFormat('yy').format(dd)}'; //Month Wise Date Display
                } else {
                  return '${DateFormat('dd').format((dd))}-${DateFormat('dd').format(_getDateOfNextMonday(dd, filterEndDate: (_totalMonth != 1) ? endDateShow : endDateShow))}\n${DateFormat('MMM').format((dd))}'; // WeekWise Date Display
                }
              }),
          // leftTitles: SideTitles(
          //   showTitles: false,
          //   // textStyle: const TextStyle(
          //   //   color: Colors.purple,
          //   //   fontWeight: FontWeight.bold,
          //   //   fontSize: 14,
          //   // ),
          //   margin: 8,
          //   reservedSize: 30,
          // ),
          topTitles: SideTitles(showTitles: false)),
      borderData: FlBorderData(
        show: false,
        border: const Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 2,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
        barsSpace: (_isMonthWise) ? 12 : 8,
        showingTooltipIndicators: [0, 1],
        x: x,
        barRods: [
          BarChartRodData(
            y: y1,
            colors: [Colors.white],
            width: (_isMonthWise) ? 13 : 10,
            borderRadius: const BorderRadius.all(Radius.circular(2)),
          ),
          BarChartRodData(
            y: y2,
            colors: [Colors.white70],
            width: (_isMonthWise) ? 13 : 10,
            borderRadius: const BorderRadius.all(Radius.circular(2)),
          ),
        ]);
  }

  DateTime _getDateOfNextMonday(DateTime date, {DateTime filterEndDate}) {
    try {
      DateTime endDate = date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
      if (filterEndDate != null && endDate.isAfter(filterEndDate)) {
        return filterEndDate;
      } else {
        return endDate;
      }
    } catch (e) {
      print("Exception dashboardScreen.dart - _getDateOfNextMonday():" + e.toString());
      return date;
    }
  }

  Future _getTaxes() async {
    try {
      global.taxList = await dbHelper.taxMasterGetList();
      setState(() {});
    } catch (e) {
      print('Exception - saleQuoteAddScreen.dart - _getTaxes(): ' + e.toString());
    }
  }

  Future<String> _orderPrintOrShare(SaleOrder _saleOrder, context, bool _isPrintAction) async {
    try {
      global.isAppOperation = true;
      List<Account> _accountList = await dbHelper.accountGetList(accountId: _saleOrder.accountId);
      _saleOrder.account = _accountList[0];
      _saleOrder.orderDetailList = await dbHelper.saleOrderDetailGetList(orderIdList: [_saleOrder.id]);
      _saleOrder.orderTaxList = await dbHelper.saleOrderTaxGetList(saleOrderId: _saleOrder.id);
      _saleOrder.orderDetailTaxList = await dbHelper.saleOrderDetailTaxGetList(orderDetailIdList: _saleOrder.orderDetailList.map((orderDetail) => orderDetail.id).toList());
      //  String _address = (_account.addressLine1.isNotEmpty && _account.state.isNotEmpty && _account.country.isNotEmpty && _account.pincode != null) ? ' ${_account.addressLine1}, ${_account.city}, ${_account.state}, ${_account.country}, ${_account.pincode}' : ' ${_account.city}';
      // List<PaymentSaleOrder> _paymentSaleOrderList = [];
      // List<Payment> _paymentList = [];
      // List<PaymentDetail> _paymentDetailList = [];
      var htmlContent;

      // _paymentSaleOrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [_saleOrder.id], isCancel: false);
      // _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentSaleOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());
      // _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());
      // if (_paymentList.length != 0) {
      //   _paymentList.forEach((item) {
      //     if (item.paymentType == 'RECEIVED') {
      //       _paymentDetailList.forEach((paymentDetail) {
      //         if (item.id == paymentDetail.paymentId) {
      //           if (paymentDetail.paymentMode == 'Cheque') {
      //             _saleOrder.paymentByCheque += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'Cash') {
      //             _saleOrder.paymentByCash += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'Card') {
      //             _saleOrder.paymentByCard += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'EWallet' || paymentDetail.paymentMode == 'eWallet') {
      //             _saleOrder.paymentByEWallet += paymentDetail.amount;
      //           } else {
      //             _saleOrder.paymentByNetBanking += paymentDetail.amount;
      //           }
      //         }
      //       });
      //     }
      //   });
      // }
      if (_isPrintAction != null) {
        br.generateSaleOrderHtml(
          context,
          order: _saleOrder,
          isPrintAction: _isPrintAction,
        );
      } else {
        htmlContent = br.generateSaleOrderHtml(
          context,
          order: _saleOrder,
          isPrintAction: _isPrintAction,
        );
      }
      return htmlContent;
    } catch (e) {
      print('Exception - SaleOrderScreen.dart - _orderPrintOrShare(): ' + e.toString());
      return null;
    }
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
      if (_updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((e) {
          print('Exception - dashboard.dart - checkForUpdate(): ' + e.toString());
        });
      }
    }).catchError((e) {
      print('Exception - dashboard.dart - checkForUpdate(): ' + e.toString());
    });
  }
}

class MapData {
  int monthNumber;
  int amount;
}
