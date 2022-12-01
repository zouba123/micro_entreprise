// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment
import 'dart:math';

import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/accountSearchModel.dart';
import 'package:accounting_app/models/buisnessStatementGraphModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceReturnModel.dart';
import 'package:accounting_app/screens/accountScreen.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/searchReport.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class AccountStatementScreen extends BaseRoute {
  final Account account;
  final String search;
  final String timePeriod;
  final String dateRange;
  final int screenId;
  final int recordNo;
  AccountStatementScreen({@required a, @required o, @required this.screenId, this.account, this.search, this.timePeriod, this.dateRange, this.recordNo}) : super(a: a, o: o, r: 'AccountStatmentScreen');
  @override
  _AccountStatemnetScreenState createState() => _AccountStatemnetScreenState(this.account, this.search, this.timePeriod, this.dateRange, this.screenId, this.recordNo);
}

class _AccountStatemnetScreenState extends BaseRouteState {
  final String search;
  final Account account;
  final String dateRange;
  final int screenId;
  final String timePeriod;
  int recordNo;

  Account _account;
  AccountSearch eSearch;
  bool _isDataLoaded = false;
  bool _isPrint = false;
  double _totalReceived = 0;
  double _totalGiven = 0;

  int touchedGroupIndex;

  TextEditingController _cAccountId = TextEditingController();

  final Color leftBarColor = Colors.white;
  final Color rightBarColor = Colors.blue;
  final double width = 7;
  double amount = 200.0;
  String leftString = 'Amount';
  String bottomString = 'Date';
  DateTime toDateSearchGraph;
  DateTime fromDateGraph;
  DateTime date;
  String amountToShow;
  bool showgraph = true;
  int lastBarIndex = -1;

  List<BuisnessStatementGraph> buisnessGraphDataList = [];
  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups = [];
  List<BuisnessStatementGraph> buisnessGraphDataList2 = [];
  List<BuisnessStatementGraph> buisnessGraphDataList1 = [];
  DateTime dateThisYear = DateTime.now();
  DateTime endDateShow = DateTime.now();

  _AccountStatemnetScreenState(this.account, this.search, this.timePeriod, this.dateRange, this.screenId, this.recordNo) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            global.appLocaleValues['tle_ac_statement'],
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          actions: <Widget>[
            (_isDataLoaded)
                ? FloatingActionButton(
                    mini: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    heroTag: null,
                    onPressed: () {
                      showgraph = (showgraph) ? false : true;
                      setState(() {});
                    },
                    child: Icon(
                      FontAwesomeIcons.chartArea,
                      size: 20,
                      color: Theme.of(context).appBarTheme.iconTheme.color,
                    ),
                  )
                : SizedBox(),
            (_isDataLoaded && _account != null)
                ? IconButton(
                    icon: Icon(FontAwesomeIcons.filter),
                    iconSize: 15,
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchReportScreen(
                                a: widget.analytics,
                                o: widget.observer,
                                returnScreenId: 1,
                                account: _account,
                                accountStatementScreenId: screenId,
                                recordNo: recordNo,
                              )));
                    },
                  )
                : SizedBox(),
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
                                  Icons.print,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(global.appLocaleValues['lt_print']),
                            ],
                          ),
                          onTap: () async {
                            _isPrint = true;
                            global.isAppOperation = true;
                            await _printReport(_isPrint);
                            Navigator.of(context).pop();
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
                            _isPrint = false;
                            global.isAppOperation = true;
                            await _printReport(_isPrint);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ]),
          ],
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width - 90,
          child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
        ),
        body: WillPopScope(
            onWillPop: () {
              if (screenId == 0) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DashboardScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => AccountScreen(
                      redirectToCustomersTab: true,
                          a: widget.analytics,
                          o: widget.observer,
                          accountSearch: eSearch,
                        )));
              }
              return null;
            },
            child:

                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Center(child: Text('Account Statements will be shown here', style: Theme.of(context).primaryTextTheme.headline3,)),
                // )
                Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            global.appLocaleValues['lbl_select_ac'],
                            style: Theme.of(context).primaryTextTheme.headline3,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                      child: TextFormField(
                          controller: _cAccountId,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: global.appLocaleValues['lbl_select_ac'],
                            suffixIcon: Icon(
                              Icons.star,
                              size: 9,
                              color: Colors.red,
                            ),
                          ),
                          onTap: () async {
                            await _accountListener();
                          }),
                    ),
                    (_account != null && _isDataLoaded && _account.paymentList.length > 0)
                        ? Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  (timePeriod == null || timePeriod == 'All Time') ? global.appLocaleValues['lbl_all_time'] : '$timePeriod ($dateRange)',
                                  style: Theme.of(context).primaryTextTheme.headline3,
                                ),
                              ),
                              (showgraph)
                                  ? Container(
                                      child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Card(
                                        elevation: 0,
                                        color: Theme.of(context).primaryColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Text('${date != null ? DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(date) : ''}', style: Theme.of(context).primaryTextTheme.bodyText2, textAlign: TextAlign.center),
                                                  amountToShow != null
                                                      ? Container(
                                                          padding: EdgeInsets.all(5),
                                                          alignment: Alignment.center,
                                                          height: 22,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(10.0),
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                          child: Text(
                                                            "${global.currency.symbol} ${amountToShow != null ? amountToShow : ''}",
                                                            style: Theme.of(context).primaryTextTheme.caption,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text('${global.appLocaleValues['lbl_credit_']}', style: Theme.of(context).primaryTextTheme.bodyText2),
                                                  Icon(
                                                    Icons.graphic_eq,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text('${global.appLocaleValues['lbl_debit']}', style: Theme.of(context).primaryTextTheme.bodyText2),
                                                  Icon(
                                                    Icons.graphic_eq,
                                                    color: Colors.blue,
                                                  )
                                                ],
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 50),
                                                  child: BarChart(
                                                    BarChartData(
                                                      minY: 0,
                                                      maxY: buisnessGraphDataList.map((e) => e.totalCredit).reduce(max) + 500,
                                                      barTouchData: BarTouchData(
                                                        allowTouchBarBackDraw: true,
                                                        enabled: true,
                                                        handleBuiltInTouches: true,
                                                        touchCallback: (_, response) {
                                                          if (response == null) {
                                                            setState(() {
                                                              touchedGroupIndex = -1;
                                                              //showingBarGroups = List.of(rawBarGroups);
                                                            });
                                                            return;
                                                          }
                                                          setState(() {
                                                            if (response is FlLongPressEnd) {
                                                              touchedGroupIndex = -1;
                                                            } else {
                                                              touchedGroupIndex = response.spot.touchedBarGroupIndex;
                                                              lastBarIndex = response.spot.touchedBarGroupIndex;
                                                            }
                                                          });
                                                        },
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
                                                            int x = group.x;
                                                            date = DateTime.fromMicrosecondsSinceEpoch(x);
                                                            amountToShow = (rod.y.round() > 0 ? NumberFormat.compactCurrency(decimalDigits: 1, symbol: '', locale: 'en_IN').format(rod.y.round()).replaceAll('T', 'K') : '');
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
                                                          topTitles: SideTitles(showTitles: false),
                                                          rightTitles: SideTitles(showTitles: false),
                                                          bottomTitles: SideTitles(
                                                            //rotateAngle: 50.0,
                                                            showTitles: (recordNo != 5) ? true : false,
                                                            getTextStyles: (cxt, double t) {
                                                              TextStyle myStyle = TextStyle(fontSize: 8);
                                                              return myStyle;
                                                            },
                                                            //  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                                            margin: 32,
                                                            reservedSize: 35,
                                                            getTitles: (double value) {
                                                              int d = value.toInt();
                                                              DateTime dd = DateTime.fromMicrosecondsSinceEpoch(d);
                                                              // date = dd;
                                                              if (recordNo != null) {
                                                                if (recordNo == 1) {
                                                                  return '${DateFormat('dd').format(dd) + ' - ' + DateFormat('dd').format(_getDateOfNextMonday(dd, filterEndDate: endDateShow))}'; //weekwise
                                                                } else if (recordNo == 6) {
                                                                  return '${DateFormat('dd MMM').format(dd) + ' - ' '\n' + DateFormat('dd MMM').format(_getDateOfNextMonday(dd, filterEndDate: endDateShow))}'; //weekwise
                                                                } else if (recordNo == 2) {
                                                                  return '${DateFormat('MMM').format(dd)}'; //Month Wise Date Display
                                                                } else if (recordNo == 7) {
                                                                  return '${DateFormat('MMM').format(dd)} \n ${DateFormat('yyyy').format(dd)} '; //Month Wise Date Display
                                                                } else if (recordNo == 5 || recordNo == 10) {
                                                                  return '${DateFormat('MMM').format(dd)} \n  ${DateFormat('yyyy').format(dd)}'; //Month Wise Date Display
                                                                } else if (recordNo == 8) {
                                                                  return '${DateFormat('dd MMM yy').format(dd)}'; //DateWise Date Display
                                                                } else if (recordNo == 9) {
                                                                  return '${DateFormat('dd MMM yy').format(dd) + ' - ' '\n' + DateFormat('dd MMM yy').format(_getDateOfNextMonday(dd, filterEndDate: endDateShow))}'; //weekwise
                                                                } else if (recordNo == 0) {
                                                                  return '${DateFormat('EE').format(dd)}'; //DateWise Date Display
                                                                } else {
                                                                  return '${DateFormat('dd MMM').format(dd)} \n ${DateFormat('yyyy').format(dd)} ';
                                                                  //DateWise Date Display
                                                                }
                                                              } else {
                                                                return '${DateFormat('dd MMM').format(dd)} \n ${DateFormat('yyyy').format(dd)} ';
                                                              }
                                                            },
                                                          ),
                                                          leftTitles: SideTitles(
                                                            showTitles: true,
                                                            getTextStyles: (cxt, double t) {
                                                              TextStyle myStyle = TextStyle(fontSize: 8);
                                                              return myStyle;
                                                            },
                                                            // textStyle: TextStyle(color: const Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                                                            margin: 0,
                                                            reservedSize: 50,
                                                            //rotateAngle: 5.0,
                                                            // ignore: missing_return
                                                            getTitles: (dou) {
                                                              return '$dou';
                                                            },
                                                          )),
                                                      borderData: FlBorderData(
                                                        show: false,
                                                      ),
                                                      barGroups: showingGroups(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))
                                  : SizedBox(),
                              Padding(padding: const EdgeInsets.only(top: 15)),
                              Container(
                                height: 35,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text('#', textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.button),
                                    ),

                                    Expanded(child: Text('${global.appLocaleValues['lbl_desc']}', textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.button)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(child: Text('${global.appLocaleValues['lbl_date']}', textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.button)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(child: Text('${global.appLocaleValues['lbl_amount']}', textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.button)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(child: Text('${global.appLocaleValues['lbl_status']}', textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.button)),
                                    // SizedBox(
                                    //     width: 10,
                                    //   ),
                                    //   Expanded(child: Text('${global.appLocaleValues['lbl_debit']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 10))),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1.2,
                              ),
                              ListView.builder(
                                  itemCount: _account.paymentList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: <Widget>[
                                        Container(
                                          height: 35,
                                          width: MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(child: Text('${index + 1}', textAlign: TextAlign.center, style: TextStyle(fontSize: 10))),
                                              Expanded(
                                                  child: (_account.paymentList[index].invoiceNumber != null)
                                                      ? Row(
                                                          children: <Widget>[
                                                            Text('ref ', style: Theme.of(context).primaryTextTheme.caption),
                                                            Text(
                                                                '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _account.paymentList[index].invoiceNumber.toString().length))}${_account.paymentList[index].invoiceNumber}',
                                                                style: Theme.of(context).primaryTextTheme.caption)
                                                          ],
                                                        )
                                                      : (_account.paymentList[index].isSaleInvoiceReturnRef)
                                                          ? Row(
                                                              children: <Widget>[Text('ref ', style: Theme.of(context).primaryTextTheme.caption), Text(global.appLocaleValues['ref_sales_return'], style: Theme.of(context).primaryTextTheme.caption)],
                                                            )
                                                          : Text('')),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: (_account.paymentList[index].transactionDate != null)
                                                      ? Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_account.paymentList[index].transactionDate)}', style: Theme.of(context).primaryTextTheme.caption)
                                                      : Text('')),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: (_account.paymentList[index].amount != null)
                                                      ? Text('${global.currency.symbol} ${_account.paymentList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: Theme.of(context).primaryTextTheme.caption)
                                                      : Text('')),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(child: (_account.paymentList[index].paymentType != null) ? Text('${_account.paymentList[index].paymentType}', style: Theme.of(context).primaryTextTheme.caption) : Text('')),
                                            ],
                                          ),
                                        ),
                                        _account.paymentList.length - 1 == index
                                            ? SizedBox(
                                                height: 20,
                                              )
                                            : Divider(),
                                      ],
                                    );
                                  }),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            )),
        bottomSheet: (_isDataLoaded)
            ? (_account != null && _account.paymentList.length > 0)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Card(
                        color: Colors.white70,
                        child: ListTile(
                          title: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(global.appLocaleValues['lbl_total_amount'], style: TextStyle(color: Colors.green)),
                                (_account.paymentList.length > 0) ? Text('${global.currency.symbol}${(_totalReceived - _totalGiven).round()}') : Text(''),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox()
            : SizedBox());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (account != null) {
      _account = account;
      _cAccountId.text = '${_account.firstName} ${_account.lastName}';
      _getData();
    } else {
      _isDataLoaded = true;
    }
  }

  Future _getData() async {
    try {
      _totalGiven = 0;
      _totalReceived = 0;
      String todate = (search != null) ? search.substring(0, 10) : null;
      String endDate = (search != null) ? search.substring(11, 21) : null;
      var dateto = (search != null) ? DateTime.parse(todate) : null;
      var datefrom = (search != null) ? DateTime.parse(endDate) : null;
      _account.paymentList.clear();
      _account.paymentList = await dbHelper.paymentGetList(accountId: _account.id, startDate: (search != null) ? dateto : null, endDate: (search != null) ? datefrom : null);
      for (int i = 0; i < _account.paymentList.length; i++) {
        if (_account.paymentList[i].paymentType == 'RECEIVED') {
          _totalReceived += _account.paymentList[i].amount;
        } else if (_account.paymentList[i].paymentType == 'GIVEN') {
          _totalGiven += _account.paymentList[i].amount;
        }
        List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(paymentId: _account.paymentList[i].id);
        if (_paymentInvoiceList.length > 0) {
          _account.paymentList[i].invoiceNumber = _paymentInvoiceList[0].invoiceNumber;
          _account.paymentList[i].isSaleInvoiceRef = true;
        } else {
          List<PaymentSaleInvoiceReturn> _paymentSaleInvoiceReturnList = await dbHelper.paymentSaleInvoiceReturnGetList(paymentId: _account.paymentList[i].id);
          if (_paymentSaleInvoiceReturnList.length > 0) {
            //   _account.paymentList[i].invoiceNumber = _paymentInvoiceList[0].invoiceNumber;
            _account.paymentList[i].isSaleInvoiceReturnRef = true;
          }
        }
      }
      await graphData();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - ExpenseStatement.dart - _getData(): ' + e.toString());
    }
  }

  Future graphData() async {
    try {
      buisnessGraphDataList.clear();
      String todate = (search != null) ? search.substring(0, 10) : null;
      String endDate = (search != null) ? search.substring(11, 21) : null;
      DateTime _startDate = DateTime(dateThisYear.year, br.generateMonthNumber(br.getSystemFlagValue(global.systemFlagNameList.financialMonth)));
      DateTime _endDate = DateTime(dateThisYear.year + 1, br.generateMonthNumber(br.getSystemFlagValue(global.systemFlagNameList.financialMonth)), 0);
      // _dates = '${_startDate.toString().substring(0, 10)},${_endDate.toString().substring(0, 10)}';
      // _dateRange = '${dateThisYear.year} TO ${dateThisYear.year}';
      var dateto = (search != null) ? DateTime.parse(todate) : _startDate;
      var datefrom = (search != null) ? DateTime.parse(endDate) : _endDate;
      toDateSearchGraph = dateto;
      fromDateGraph = datefrom;
      endDateShow = fromDateGraph;

      if (recordNo == null) {
        recordNo = 7;
      }
      print('recordNo $recordNo');
      if (recordNo != null) {
        if (recordNo == 1 || recordNo == 6 || recordNo == 9) {
          buisnessGraphDataList1.clear();
          buisnessGraphDataList2.clear();
          buisnessGraphDataList1 = await dbHelper.buissnesGraphGetWeekDataCredit(startDate: (dateto != null) ? dateto : null, endDate: (datefrom != null) ? datefrom : null, orderBy: 'ASC', accountId: _account.id); //credit
          buisnessGraphDataList2 = await dbHelper.buissnesGraphGetWeekDataDebit(startDate: (dateto != null) ? dateto : null, endDate: (datefrom != null) ? datefrom : null, orderBy: 'ASC', accountId: _account.id); //debit
        } else if (recordNo == 2 || recordNo == 7 || recordNo == 10) {
          buisnessGraphDataList1.clear();
          buisnessGraphDataList2.clear();
          buisnessGraphDataList1 = await dbHelper.buissnesGraphGetMonthDataCredit(startDate: (dateto != null) ? dateto : null, endDate: (datefrom != null) ? datefrom : null, orderBy: 'ASC', accountId: _account.id); //credit
          buisnessGraphDataList2 = await dbHelper.buissnesGraphGetMonthDataDebit(startDate: (dateto != null) ? dateto : null, endDate: (datefrom != null) ? datefrom : null, orderBy: 'ASC', accountId: _account.id); //debit
        } else if (recordNo == 0 || recordNo == 8) {
          buisnessGraphDataList1.clear();
          buisnessGraphDataList2.clear();
          buisnessGraphDataList1 = await dbHelper.buissnesGraphGetDataCredit(startDate: (dateto != null) ? dateto : null, endDate: (datefrom != null) ? datefrom : null, orderBy: 'ASC', paymentType: 'RECEIVED', accountId: _account.id); //credit
          buisnessGraphDataList2 = await dbHelper.buissnesGraphGetDataDebit(startDate: (dateto != null) ? dateto : null, endDate: (datefrom != null) ? datefrom : null, orderBy: 'ASC', paymentType: 'GIVEN', accountId: _account.id); //debit
        } else if (recordNo == 5) {
          buisnessGraphDataList1.clear();
          buisnessGraphDataList2.clear();
          buisnessGraphDataList1 = await dbHelper.buissnesGraphGetMonthDataCredit(startDate: (dateto != null) ? dateto : null, endDate: (datefrom != null) ? datefrom : null, orderBy: 'ASC', accountId: _account.id); //credit
          buisnessGraphDataList2 = await dbHelper.buissnesGraphGetMonthDataDebit(startDate: (dateto != null) ? dateto : null, endDate: (datefrom != null) ? datefrom : null, orderBy: 'ASC', accountId: _account.id); //
        }
      } else {
        buisnessGraphDataList1 = await dbHelper.buissnesGraphGetDataCredit(startDate: (dateto != null) ? dateto : null, endDate: (datefrom != null) ? datefrom : null, orderBy: 'ASC', paymentType: 'RECEIVED', accountId: _account.id); //credit
        buisnessGraphDataList2 = await dbHelper.buissnesGraphGetDataDebit(startDate: (dateto != null) ? dateto : null, endDate: (datefrom != null) ? datefrom : null, orderBy: 'ASC', paymentType: 'GIVEN', accountId: _account.id); //debit
      }
      for (int i = 0; i < buisnessGraphDataList2.length; i++) {
        for (int j = 0; j < buisnessGraphDataList1.length; j++) {
          buisnessGraphDataList1.where((element) => element.transactionDate == buisnessGraphDataList2[i].transactionDate).map((e) => e.totalDebit = buisnessGraphDataList2[i].totalDebit).toList();
        }
      }

      buisnessGraphDataList += buisnessGraphDataList1;
      setState(() {});
    } catch (e) {
      print('Exception - ExpenseStatement.dart - graphData(): ' + e.toString());
    }
  }

  List<BarChartGroupData> showingGroups() => List.generate(buisnessGraphDataList.length, (i) {
        int dateInt = buisnessGraphDataList[i].transactionDate.microsecondsSinceEpoch;

        // print('Start of week: ${(buisnessGraphDataList[i].transactionDate.subtract(Duration(days: buisnessGraphDataList[i].transactionDate.weekday - 1)))}');
        // print('End of week: ${(buisnessGraphDataList[i].transactionDate.add(Duration(days: DateTime.daysPerWeek - buisnessGraphDataList[i].transactionDate.weekday)))}');
        final barGroup1 = makeGroupData(
          dateInt,
          buisnessGraphDataList[i].totalCredit != 0.0 ? buisnessGraphDataList[i].totalCredit : 0.0,
          buisnessGraphDataList[i].totalDebit != 0.0 ? buisnessGraphDataList[i].totalDebit : 0.0,
          double.parse(_returnWidth(buisnessGraphDataList.length).toString()),
          i,
        );

        return barGroup1;
      });
  int _returnWidth(int listLength) {
    if ((24 - listLength).isNegative) {
      return 4;
    } else {
      return 24 - listLength;
    }
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
      print("Exception - _getDateOfNextMonday():" + e.toString());
      return date;
    }
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double width, int barIndex) {
    return BarChartGroupData(
        barsSpace: 3.0,

        // showingTooltipIndicators: [0, 1],

        x: x,
        barRods: [
          BarChartRodData(
            y: y1,
            colors: [lastBarIndex == barIndex ? Colors.white : Colors.white54],
            width: width,
            borderRadius: const BorderRadius.all(Radius.circular(2)),
          ),
          BarChartRodData(
            y: y2,
            colors: [lastBarIndex == barIndex ? Colors.blue : Colors.lightBlue[100]],
            width: width,
            borderRadius: const BorderRadius.all(Radius.circular(2)),
          ),
        ]);
  }

  Future _printReport(_isPrint) async {
    try {
      double _amount = _totalReceived - _totalGiven.round();

      var htmlContent = """
    <!DOCTYPE html>
<html>
<head>
  <style>
  table, th, td {
    border: 1px solid black;
    border-collapse: collapse;

  }
  th, td, p {
    padding: 2px;
    text-align: left;
  }
  </style>
</head>
  <body>
  <header>
    <h1 align=center><font size=6>${global.business.name}</font></h1>""";

      htmlContent += """<h4 align=center>${global.business.addressLine1}</br>""";

      if (global.business.contact1 != null) {
        htmlContent += """${global.country.isoCode} ${global.business.contact1}<br>""";
      }
      if (global.business.email != null && global.business.email != "") {
        htmlContent += """${global.business.email}<br>""";
      }

      if (global.business.website != null && global.business.website != "") {
        htmlContent += """${global.business.website}<br><h4>""";
      }
      htmlContent += """
  <hr>
 
  </header>
  """;
      htmlContent += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_ac_statement']}</font></h1>
    
    <p style='float: left'><font size=4> ${global.appLocaleValues['tab_ac']}: ${br.generateAccountName(_account)}<p style='float: right'><font size=4>${global.appLocaleValues['lbl_date']}: ${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.now())}</font></p>
    <table style='width:100%'>
    <tr>
    <th>#</th>
    <th>${global.appLocaleValues['lbl_desc']}</th>
    <th>${global.appLocaleValues['lbl_date']}</th>
    <th>${global.appLocaleValues['lbl_amount']}</th>
    <th>${global.appLocaleValues['lbl_status']}</th>
    
    </tr>
     """;

      _account.paymentList.forEach((item) {
        htmlContent += """
      <tr>
    <td>${(_account.paymentList.indexOf(item)) + 1}</td>
    <td>ref  ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + item.invoiceNumber.toString().length))}${item.invoiceNumber}</td>
    <td>${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(item.transactionDate)}</td>
    <td>${global.currency.symbol} ${item.amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    <td>${item.paymentType}</td>
    </tr>
      """;
      });

      htmlContent += """
    </table>
     <table style='width:100%'>

     <tr>
     <td style="background-color: teal;color: white;width: 50%"><b>${global.appLocaleValues['lbl_total_amount']}</b></td>
    <td style="background-color: teal;color: white;"><b> ${global.currency.symbol} ${_amount.round()}</b></td>
     </tr>
     </table>
     </body>
     <footer style="bottom: 0;position: relative;width: 100%">
      <hr>
      </footer>
     </html>""";

      final pdf = await Printing.convertHtml(html: htmlContent, format: PdfPageFormat.a4);
      if (_isPrint) {
        await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf);
      } else {
        await Printing.sharePdf(bytes: pdf, filename: 'account_statement.pdf');
      }
    } catch (e) {
      print('Exception - accountStatement.dart - _printReport(): ' + e.toString());
    }
  }

  Future _accountListener() async {
    try {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AccountSelectDialog(
                a: widget.analytics,
                o: widget.observer,
                returnScreenId: 1,
                selectedAccount: (selectedAccount) async {
                  _account = selectedAccount;
                  //  String _code = '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode}';
                  _cAccountId.text = '${_account.firstName} ${_account.lastName}';
                  await _getData();
                },
              )));
      setState(() {});
    } catch (e) {
      print('Exception - accountStatement.dart - _accountListener(): ' + e.toString());
    }
  }
}
