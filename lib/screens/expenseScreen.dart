// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/dialogs/expenseCategorySelectDialog.dart';
import 'package:accounting_app/dialogs/paymentMethodSelectDialog.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/businessRule.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/expenseCategoryModel.dart';
import 'package:accounting_app/models/expenseFilterModel.dart';
import 'package:accounting_app/models/expenseModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/expenseAddScreen.dart';
import 'package:accounting_app/screens/expenseDetailScreen.dart';
import 'package:accounting_app/screens/showExpenseListScreen.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ExpenseScreen extends BaseRoute {
  ExpenseScreen({a, o}) : super(a: a, o: o, r: 'ExpenseScreen');
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends BaseRouteState {
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Expense> _expenseList = [];

  ScrollController _scrollController = ScrollController();

  ExpenseFilter expenseFilter = ExpenseFilter();
  bool _isDataLoaded = false;
  bool _isShowGraph = true;
  bool _isRecordPending = true;
  int filterCount = 0;
  int _totalRecords = 10;

  int _bottomNavBarIndex = 0;
  int touchedIndex;
  List<Expense> _expenseListCategoryWise = [];
  List<Expense> _expenseListBillerWise = [];
  List<Expense> _expenseListForBarChart = [];
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  var _tabController;
  final double width = 7;
  int touchedGroupIndex;

  _ExpenseScreenState() : super();
  // _calculate(Expense expense) {
  //   double _paid = 0;
  //   expense.paymentList.forEach((e) {
  //     e.paymentDetailList.forEach((element) {
  //       if (!element.deletedFromScreen) {
  //         _paid += element.amount;
  //       }
  //     });
  //   });

  //   expense.totalPaid = _paid;
  //   expense.totalDue = expense.amount - expense.totalPaid;
  // }

  void _tabControllerListener() {
    setState(() {
      _bottomNavBarIndex = _tabController.index;
    });
  }

  List<BarChartGroupData> showingGroups() => List.generate(_expenseListForBarChart.length, (i) {
        // showingBarGroups.clear();
        int dateInt = _expenseListForBarChart[i].transactionDate.microsecondsSinceEpoch;
        print(' Date INt $dateInt');
        final barGroup1 = makeGroupData(dateInt, double.parse(_expenseListForBarChart[i].totalAmount));
        //showingBarGroups += [barGroup1];
        // ignore: unnecessary_statements

        return barGroup1;
      });
  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      showingTooltipIndicators: [0],
      barRods: [
        BarChartRodData(
          y: y1,
          colors: [Colors.white],
          width: 25,
          borderRadius: BorderRadius.circular(2),
        ),
        // BarChartRodData(
        //   y: y2,
        //   color: rightBarColor,
        //   width: width,
        //   borderRadius: BorderRadius.circular(10),
        // ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    if (_bottomNavBarIndex == 2) {
      return List.generate(_expenseListBillerWise.length, (i) {
        final isTouched = i == touchedIndex;
        final double fontSize = isTouched ? 25 : 16;
        final double radius = isTouched ? 60 : 50;

        return PieChartSectionData(
          color: _expenseListBillerWise[i].color,
          value: double.parse(_expenseListBillerWise[i].totalAmount.toString()),
          title: '',
          radius: radius,
          titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        );
      });
    } else {
      // ignore: missing_return
      return List.generate(_expenseListCategoryWise.length, (i) {
        final isTouched = i == touchedIndex;
        final double fontSize = isTouched ? 25 : 16;
        final double radius = isTouched ? 60 : 50;

        return PieChartSectionData(
          color: _expenseListCategoryWise[i].color,
          value: double.parse(_expenseListCategoryWise[i].totalAmount.toString()),
          title: '', //isTouched ? '${_expenseListCategoryWise[i].expenseCategoryName.toString()}' : '${NumberFormat.compactCurrency(decimalDigits: 1, symbol: '', locale: 'en_IN').format(double.parse(_expenseListCategoryWise[i].totalAmount)).replaceAll('T', 'K')} ',
          radius: radius,
          titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        );
      });
    }
  }

  // Future _addPaymentMethod(Expense expense) async {
  //   try {
  //     _calculate(expense);
  //     //   _remainAmount = (invoice.payment.paymentDetailList.length != 0) ? invoice.netAmount - invoice.payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount) : invoice.netAmount;
  //     if (expense.totalDue > 0) {
  //       await showDialog(
  //           context: context,
  //           builder: (_) {
  //             return ExpensePaymentAddDialog(
  //               remainAmountToPay: double.parse(expense.totalDue.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))),
  //               expense: expense,
  //             );
  //           });
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['lbl_err_vld_payment']}')));
  //     }
  //   } catch (e) {
  //     print('Exception - expenseAddScreen.dart - _addPaymentMethod(): ' + e.toString());
  //   }
  // }

  Widget _expenseListTile() {
    try {
      return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            _isShowGraph && filterCount == 0
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('${global.appLocaleValues['lbl_last_6_month']}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                              Expanded(
                                child: BarChart(
                                  BarChartData(
                                    alignment: BarChartAlignment.spaceEvenly,
                                    // groupsSpace: 20,
                                    // backgroundColor: Theme.of(context).primaryColor,
                                    minY: 0,
                                    maxY: _expenseListForBarChart.map((e) => double.parse(e.totalAmount)).reduce(max) + ((_expenseListForBarChart.map((e) => double.parse(e.totalAmount)).reduce(max) * 25) / 100),

                                    barTouchData: BarTouchData(
                                      enabled: false,
                                      touchTooltipData: BarTouchTooltipData(
                                        tooltipBgColor: Colors.transparent,
                                        tooltipPadding: const EdgeInsets.only(top: 5),
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
                                              fontSize: 12,
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    titlesData: FlTitlesData(
                                        show: true,
                                        topTitles: SideTitles(showTitles: false),
                                        bottomTitles: SideTitles(
                                          //rotateAngle: 0.0,
                                          showTitles: true,
                                          getTextStyles: (t, _) {
                                            return TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal, letterSpacing: 0);
                                          },
                                          margin: 05,
                                          interval: 3,
                                          reservedSize: 20,
                                          getTitles: (double value) {
                                            int d = value.toInt();
                                            DateTime dd = DateTime.fromMicrosecondsSinceEpoch(d);
                                            return '${DateFormat('MMM yy').format(dd)}';
                                          },
                                        ),
                                        leftTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                        rightTitles: SideTitles(
                                          showTitles: false,
                                          getTextStyles: (t, _) {
                                            return TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal, letterSpacing: 0);
                                          },
                                          margin: 10,

                                          reservedSize: 30,

                                          //rotateAngle: 5.0,
                                          // ignore: missing_return
                                          // getTitles: (dou) {
                                          //   return '$dou';
                                          // },
                                        )),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    barGroups: showingGroups(),
                                  ),
                                  swapAnimationDuration: Duration(seconds: 2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ListView.builder(
                itemCount: _expenseList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 4, top: 4),
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.0),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => ExpenseDetailScreen(
                                        expense: _expenseList[index],
                                        a: widget.analytics,
                                        o: widget.observer,
                                      )))
                              .then((value) async {
                            _expenseList.clear();
                            _expenseListForBarChart.clear();
                            _expenseListBillerWise.clear();
                            _expenseListCategoryWise.clear();
                            await _getData();
                          });
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
                          leading: CircleAvatar(
                            backgroundColor: _expenseList[index].color,
                            //  Theme.of(context).primaryColorDark,
                            foregroundColor: Colors.black,
                            radius: 25,
                            child: Text(
                              '${_expenseList[index].expenseName != null && _expenseList[index].expenseName.isNotEmpty ? _expenseList[index].expenseName[0] : _expenseList[index].expenseCategoryName[0]}',
                              style: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.w500, fontSize: 25),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text("${NumberFormat.compactCurrency(decimalDigits: 1, symbol: '', locale: 'en_IN').format(_expenseList[index].amount).replaceAll('T', 'K')}", style: Theme.of(context).primaryTextTheme.subtitle1),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  (_expenseList[index].isPaid)
                                      ? Container(
                                          width: 50,
                                          height: 27,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            border: Border.all(
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text("${global.appLocaleValues['lbl_paid_cap']} ", style: Theme.of(context).primaryTextTheme.subtitle2),
                                          ),
                                        )
                                      : Container(
                                          width: 50,
                                          height: 27,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            border: Border.all(
                                              color: Colors.red[200],
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${global.appLocaleValues['lbl_due_cap']} ",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                              PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                itemBuilder: (context) => [
                                  _expenseList[index].filePath != null
                                      ? PopupMenuItem(
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: _expenseList[index].filePath.contains('.png')
                                                      ? Icon(
                                                          Icons.image,
                                                          color: Theme.of(context).primaryColor,
                                                        )
                                                      : Icon(Icons.picture_as_pdf, color: Theme.of(context).primaryColor),
                                                ),
                                                Text(global.appLocaleValues['btn_view_details']),
                                              ],
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              br.openFile(_expenseList[index].filePath);
                                              setState(() {});
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
                                            child: Icon(Icons.view_module, color: Theme.of(context).primaryColor),
                                          ),
                                          Text(global.appLocaleValues['btn_view_details']),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => ExpenseDetailScreen(
                                                      expense: _expenseList[index],
                                                      a: widget.analytics,
                                                      o: widget.observer,
                                                    )))
                                            .then((value) async {
                                          _expenseList.clear();
                                          _expenseListForBarChart.clear();
                                          _expenseListBillerWise.clear();
                                          _expenseListCategoryWise.clear();
                                          await _getData();
                                        });
                                      },
                                    ),
                                  ),
                                  !(_expenseList[index].isPaid)
                                      ? PopupMenuItem(
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: Icon(Icons.add_circle_outline, color: Theme.of(context).primaryColor),
                                                ),
                                                Text(global.appLocaleValues['lbl_add_payment']),
                                              ],
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pop();

                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => ExpenseAddScreen(
                                                        a: widget.analytics,
                                                        o: widget.observer,
                                                        expense: _expenseList[index],
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
                                            child: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                                          ),
                                          Text("${global.appLocaleValues['lbl_edit']}"),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                                            builder: (context) => ExpenseAddScreen(
                                                  a: widget.analytics,
                                                  o: widget.observer,
                                                  expense: _expenseList[index],
                                                )));
                                      },
                                    ),
                                  ),
                                  _expenseList[index].filePath != null
                                      ? PopupMenuItem(
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: Icon(Icons.print, color: Theme.of(context).primaryColor),
                                                ),
                                                Text('${global.appLocaleValues['lt_print']}'),
                                              ],
                                            ),
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              global.isAppOperation = true;
                                              br.printFile(_expenseList[index].filePath);
                                            },
                                          ),
                                        )
                                      : null,
                                  _expenseList[index].filePath != null
                                      ? PopupMenuItem(
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: Icon(Icons.share, color: Theme.of(context).primaryColor),
                                                ),
                                                Text('${global.appLocaleValues['lt_share']}'),
                                              ],
                                            ),
                                            onTap: () async {
                                              Navigator.of(context).pop();

                                              await br.shareFile(_expenseList[index].filePath, _expenseList[index].expenseCategoryName);
                                              setState(() {});
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
                                            child: Icon(Icons.delete, color: Theme.of(context).primaryColor),
                                          ),
                                          Text('${global.appLocaleValues['lbl_delete']}'),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        deleteExpense(_expenseList[index]);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            !_isRecordPending
                ? SizedBox(
                    height: 70,
                  )
                : SizedBox()
          ],
        ),
      );
    } catch (e) {
      print("Exception - expenseScreen.dart - _expenseListTile():" + e.toString());
      return SizedBox();
    }
  }

  Widget _expenseListTileCatergoryWise() {
    try {
      return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            _isShowGraph
                ? Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                                enabled: true,
                                touchCallback: (_, PieTouchResponse pieTouchResponse) {
                                  return setState(() {
                                    if (pieTouchResponse.touchedSection is FlLongPressEnd) {
                                      touchedIndex = -1;
                                    } else {
                                      touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                                    }
                                  });
                                }),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections(),
                          ),
                          swapAnimationDuration: Duration(seconds: 1),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ListView.builder(
                itemCount: _expenseListCategoryWise.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 4, top: 4),
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.0),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => ShowExpenseListScreen(
                                        expenseCategoryName: _expenseListCategoryWise[index].expenseCategoryName,
                                        expenseCategoryId: _expenseListCategoryWise[index].expenseCategoryId,
                                        a: widget.analytics,
                                        o: widget.observer,
                                      )))
                              .then((value) async {
                            _isRecordPending = true;
                            _expenseList.clear();
                            _expenseListForBarChart.clear();
                            _expenseListBillerWise.clear();
                            _expenseListCategoryWise.clear();
                            await _getData();
                          });
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                          leading: CircleAvatar(
                            //  backgroundColor: Theme.of(context).primaryColorDark,
                            backgroundColor: _expenseListCategoryWise[index].color,
                            radius: 22,
                            child: Text(
                              _expenseListCategoryWise[index].expenseCategoryName[0],
                              style: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.w500, fontSize: 25),
                            ),
                          ),
                          title: Text('${_expenseListCategoryWise[index].expenseCategoryName}', overflow: TextOverflow.ellipsis, style: Theme.of(context).primaryTextTheme.subtitle1),
                          subtitle: Text('${global.appLocaleValues['lbl_total_spends']} ${_expenseListCategoryWise[index].categoryTotalSpends != null ? _expenseListCategoryWise[index].categoryTotalSpends : ''}', overflow: TextOverflow.ellipsis, style: Theme.of(context).primaryTextTheme.subtitle2),
                          trailing: Text('${global.currency.symbol} ${NumberFormat.compactCurrency(decimalDigits: 1, symbol: '', locale: 'en_IN').format(double.parse(_expenseListCategoryWise[index].totalAmount)).replaceAll('T', 'K')}', style: Theme.of(context).primaryTextTheme.subtitle1),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            !_isRecordPending
                ? SizedBox(
                    height: 70,
                  )
                : SizedBox()
          ],
        ),
      );
    } catch (e) {
      print("Exception - expenseScreen.dart - _expenseListTile():" + e.toString());
      return SizedBox();
    }
  }

  Widget _expenseListTileBillerWise() {
    try {
      return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            _isShowGraph
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                                enabled: true,
                                touchCallback: (_, PieTouchResponse pieTouchResponse) {
                                  return setState(() {
                                    if (pieTouchResponse.touchedSection is FlLongPressEnd) {
                                      touchedIndex = -1;
                                    } else {
                                      touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                                    }
                                  });
                                }),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections(),
                          ),
                          swapAnimationDuration: Duration(seconds: 1),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ListView.builder(
                itemCount: _expenseListBillerWise.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 4, top: 4),
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.0),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => ShowExpenseListScreen(
                                        billerName: _expenseListBillerWise[index].billerName,
                                        a: widget.analytics,
                                        o: widget.observer,
                                      )))
                              .then((value) async {
                            _isRecordPending = true;
                            _expenseList.clear();
                            _expenseListForBarChart.clear();
                            _expenseListBillerWise.clear();
                            _expenseListCategoryWise.clear();
                            await _getData();
                          });
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                          leading: CircleAvatar(
                              backgroundColor: _expenseListBillerWise[index].color,
                              //  Theme.of(context).primaryColorDark,  //
                              foregroundColor: Colors.black,
                              radius: 22,
                              child: Text(
                                '${_expenseListBillerWise[index].billerName != null && _expenseListBillerWise[index].billerName.isNotEmpty ? _expenseListBillerWise[index].billerName[0] : 'U'}',
                                style: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.w500, fontSize: 25),
                              )),
                          title: Text('${_expenseListBillerWise[index].billerName != null && _expenseListBillerWise[index].billerName.isNotEmpty ? _expenseListBillerWise[index].billerName : 'Unknown'}', overflow: TextOverflow.ellipsis, style: Theme.of(context).primaryTextTheme.subtitle1),
                          subtitle: Text('${global.appLocaleValues['lbl_total_spends']} ${_expenseListBillerWise[index].billerTotalSpends != null ? _expenseListBillerWise[index].billerTotalSpends : ''}', overflow: TextOverflow.ellipsis, style: Theme.of(context).primaryTextTheme.subtitle2),
                          trailing: Text('${global.currency.symbol} ${NumberFormat.compactCurrency(decimalDigits: 1, symbol: '', locale: 'en_IN').format(double.parse(_expenseListBillerWise[index].totalAmount)).replaceAll('T', 'K')}', style: Theme.of(context).primaryTextTheme.subtitle1),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            !_isRecordPending
                ? SizedBox(
                    height: 70,
                  )
                : SizedBox()
          ],
        ),
      );
    } catch (e) {
      print("Exception - expenseScreen.dart - _expenseListTile():" + e.toString());
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          global.appLocaleValues['lbl_expenses'],
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
          _expenseList.length > 0
              ? Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isShowGraph = !_isShowGraph;
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.chartArea,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                )
              : SizedBox(),
          SizedBox(),
          _expenseList.isNotEmpty && _expenseList.length > 0
              ? IconButton(
                  icon: Icon(MdiIcons.filter),
                  onPressed: () {
                    Navigator.of(context).push(ExpenseFilterDialog(expenseFilter)).then((value) async {
                      if (value != null) {
                        expenseFilter = value;
                        int i = 0;

                        if (expenseFilter.searchString != null) {
                          i++;
                        }
                        if (expenseFilter.toDate != null) {
                          i++;
                        }

                        if (expenseFilter.fromDate != null) {
                          i++;
                        }
                        if (expenseFilter.paymentMode != null) {
                          i++;
                        }
                        if (expenseFilter.searchExpenseCategory != null) {
                          i++;
                        }
                        filterCount = i;
                        _isRecordPending = true;
                        _expenseList.clear();
                        _expenseListForBarChart.clear();
                        _expenseListBillerWise.clear();
                        _expenseListCategoryWise.clear();
                        await _getData();
                      } else {
                        print("value is null");
                      }
                    });
                    setState(() {});
                  },
                )
              : SizedBox(),
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ExpenseAddScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      )));
            },
          )
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width - 90,
        child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
      ),
      bottomSheet:
          //  (_expenseList.length > 0)
          //     ?
          BottomNavigationBar(
        currentIndex: _bottomNavBarIndex,
        onTap: (cIndex) {
          setState(() {
            _bottomNavBarIndex = cIndex;
            _tabController.animateTo(_bottomNavBarIndex);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.currencyUsd,
            ),
            label: "${global.appLocaleValues['lbl_expenses']}",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: "${global.appLocaleValues['lbl_categories']}",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "${global.appLocaleValues['lbl_billers']}",
          ),
        ],
      ),
      // : null,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        key: _refreshKey,
        child: WillPopScope(
          onWillPop: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DashboardScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
            return null;
          },
          child: (_isDataLoaded)
              ? (_expenseList != null && _expenseList.isNotEmpty)
                  ? TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        _expenseListTile(),
                        _expenseListTileCatergoryWise(),
                        _expenseListTileBillerWise(),
                      ],
                    )
                  : filterCount != 0 && _expenseList.isEmpty && _expenseList.length == 0
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              MdiIcons.filter,
                              color: Colors.grey,
                              size: 180,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FittedBox(
                              child: Text(
                                '${global.appLocaleValues['tle_expense_empty']}',
                                style: TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                            )
                          ],
                        ))
                      : Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              MdiIcons.currencyUsd,
                              color: Colors.grey,
                              size: 180,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FittedBox(
                              child: Text(
                                '${global.appLocaleValues['tle_expense_empty']}',
                                style: TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                            )
                          ],
                        ))
              : Center(
                  child: showLoader2('${global.appLocaleValues['txt_wait']}'),
                ),
        ),
      ),
    );
  }

  void deleteExpense(Expense expense) {
    try {
      AlertDialog _dialog = AlertDialog(
        contentPadding: EdgeInsets.only(top: 24, left: 8, right: 8, bottom: 24),
        insetPadding: EdgeInsets.all(16),
        title: Text(
          '${global.appLocaleValues['tle_expense_dlt']}',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '${global.appLocaleValues['lbl_delete_expense_msg']}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorDark,
                  foregroundColor: Colors.black,
                  radius: 28,
                  child: Text('${global.currency.symbol} ${expense.amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: Theme.of(context).primaryTextTheme.bodyText2),
                ),
                title: Text('${expense.expenseName != null && expense.expenseName.isNotEmpty ? expense.expenseName + ' - ' : ''}${expense.expenseCategoryName}', overflow: TextOverflow.ellipsis, style: Theme.of(context).primaryTextTheme.subtitle1),
                subtitle: Text(DateFormat('dd-MM-yyyy').format(expense.transactionDate), overflow: TextOverflow.ellipsis, style: Theme.of(context).primaryTextTheme.subtitle2),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              child: Text('${global.appLocaleValues['btn_no']}'.toUpperCase()),
              // textColor: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              }),
          TextButton(
            child: Text(
              '${global.appLocaleValues['btn_yes']}',
              style: Theme.of(context).primaryTextTheme.headline2,
            ),
            // textColor: Theme.of(context).primaryColor,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await dbHelper.expensePaymentsDelete(expenseId: [expense.id]);

              expense.paymentList.forEach((e) async {
                await dbHelper.paymentDelete(paymentIdList: [e.id]);
                if (e.paymentDetailList.isNotEmpty) {
                  e.paymentDetailList.forEach((e) async {
                    await dbHelper.paymentDetailDelete(paymentDetailId: e.id);
                  });
                }
              });
              int _result = await dbHelper.expenseDelete(expense.id);
              if (_result == 1) {
                _isRecordPending = true;
                _expenseList.clear();
                _expenseListForBarChart.clear();
                _expenseListBillerWise.clear();
                _expenseListCategoryWise.clear();
                await _getData();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['txt_expense_dlt_success']}')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['txt_expense_dlt_fail']}')));
              }
            },
          ),
        ],
      );
      showDialog(builder: (context) => _dialog, context: context);
    } catch (e) {
      print('Exception - expenseScreen.dart - deleteExpense(): ' + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_lazyLoading);
    _tabController.removeListener(_tabControllerListener);
    _tabController.dispose();
  }

  // Future expenseFilter() async {
  //   try {
  //     if (expenseFilter == null) {
  //       expenseFilter =  expenseFilter();
  //     }
  //     await showDialog(
  //         context: context,
  //         builder: (_) {
  //           return ExpensesSearchDialog(
  //             expenseFilter: expenseFilter,
  //             searchValue: (obj) {
  //               expenseFilter = obj;
  //             },
  //           );
  //         });

  //     if (expenseFilter.isSearch != null && expenseFilter.isSearch) {
  //       await _refreshData(isSearchAction: true);
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     print('Exception - expenseScreen.dart - expenseFilter(): ' + e.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: _bottomNavBarIndex);
    _tabController.addListener(_tabControllerListener);
    init();
  }

  Future init() async {
    try {
      await _getData();
      _scrollController.addListener(_lazyLoading);
      _isDataLoaded = true;
    } catch (e) {
      print("Exception - expenseScreen.dart - init():" + e.toString());
    }
  }

  Future _getData() async {
    try {
      if (_isRecordPending) {
        int _startIndex = 0;
        if (_expenseList.length != null && _expenseList.length > 0) {
          _startIndex = _expenseList.length;
        } else {
          _expenseList = [];
        }
        List<Expense> _tExpenseList = await dbHelper.expenseGetList(
          startIndex: _startIndex,
          fetchRecords: _totalRecords,
          searchString: (expenseFilter != null)
              ? (expenseFilter.searchString != null)
                  ? expenseFilter.searchString
                  : null
              : null,
          startDate: (expenseFilter != null)
              ? (expenseFilter.fromDate != null)
                  ? expenseFilter.fromDate
                  : null
              : null,
          endDate: (expenseFilter != null)
              ? (expenseFilter.toDate != null)
                  ? expenseFilter.toDate
                  : null
              : null,
          paymentMode: (expenseFilter != null)
              ? (expenseFilter.paymentMode != null)
                  ? expenseFilter.paymentMode
                  : null
              : null,
          expenseCategoryId: (expenseFilter != null)
              ? (expenseFilter.searchExpenseCategory != null)
                  ? expenseFilter.searchExpenseCategory.id
                  : null
              : null,
        );

        _expenseListForBarChart = await dbHelper.expenseGetListChart(
          startDate: (expenseFilter.fromDate != null) ? expenseFilter.fromDate : DateTime(DateTime.now().year, DateTime.now().month - 5, 1),
          endDate: (expenseFilter.toDate != null) ? expenseFilter.toDate : DateTime.now(),
        );

        _expenseListCategoryWise = await dbHelper.expenseGetList(
            //startIndex: _startIndex,
            // fetchRecords: _totalRecords,
            searchString: (expenseFilter != null)
                ? (expenseFilter.searchString != null)
                    ? expenseFilter.searchString
                    : null
                : null,
            startDate: (expenseFilter != null)
                ? (expenseFilter.fromDate != null)
                    ? expenseFilter.fromDate
                    : null
                : null,
            endDate: (expenseFilter != null)
                ? (expenseFilter.toDate != null)
                    ? expenseFilter.toDate
                    : null
                : null,
            paymentMode: (expenseFilter != null)
                ? (expenseFilter.paymentMode != null)
                    ? expenseFilter.paymentMode
                    : null
                : null,
            expenseCategoryId: (expenseFilter != null)
                ? (expenseFilter.searchExpenseCategory != null)
                    ? expenseFilter.searchExpenseCategory.id
                    : null
                : null,
            isCategorywise: true);
        _expenseListBillerWise = await dbHelper.expenseGetList(
            // startIndex: _startIndex,
            // fetchRecords: _totalRecords,
            searchString: (expenseFilter != null)
                ? (expenseFilter.searchString != null)
                    ? expenseFilter.searchString
                    : null
                : null,
            startDate: (expenseFilter != null)
                ? (expenseFilter.fromDate != null)
                    ? expenseFilter.fromDate
                    : null
                : null,
            endDate: (expenseFilter != null)
                ? (expenseFilter.toDate != null)
                    ? expenseFilter.toDate
                    : null
                : null,
            paymentMode: (expenseFilter != null)
                ? (expenseFilter.paymentMode != null)
                    ? expenseFilter.paymentMode
                    : null
                : null,
            expenseCategoryId: (expenseFilter != null)
                ? (expenseFilter.searchExpenseCategory != null)
                    ? expenseFilter.searchExpenseCategory.id
                    : null
                : null,
            isBillerwise: true);

        for (int i = 0; i < _tExpenseList.length; i++) {
          _tExpenseList[i].expensePaymentList = await dbHelper.expensePaymentsGetList(expenseId: _tExpenseList[i].id);
          if (_tExpenseList[i].expensePaymentList.isNotEmpty && _tExpenseList[i].expensePaymentList.length > 0) {
            _tExpenseList[i].paymentList = await dbHelper.paymentGetList(paymentIdList: _tExpenseList[i].expensePaymentList.map((e) => e.paymentId).toList());
            if (_tExpenseList[i].paymentList.isNotEmpty && _tExpenseList[i].paymentList.length > 0) {
              for (int j = 0; j < _tExpenseList[i].paymentList.length; j++) {
                _tExpenseList[i].paymentList[j].paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: [_tExpenseList[i].paymentList[j].id]);
              }
            }
          }
        }
        print("Range  $_startIndex - ${_startIndex + _totalRecords} ${_tExpenseList.length}");
        if (_tExpenseList.length == 0) {
          _isRecordPending = false;
        }
        setState(() {
          _expenseList.addAll(_tExpenseList);
        });
      }
    } catch (e) {
      print('Exception - expenseScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _lazyLoading() async {
    try {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        await _getData();
      }
    } catch (e) {
      print('Exception - expenseScreen.dart - _lazyloading(): ' + e.toString());
    }
  }

  Future _refreshData({bool isSearchAction}) async {
    try {
      _expenseList.clear();
      if (isSearchAction == null) {
        expenseFilter = null;
      }

      await _getData();

      _scrollController.position.jumpTo(1);
      setState(() {});
    } catch (e) {
      print('Exception - expenseScreen.dart - _refreshdata(): ' + e.toString());
    }
  }
}

class ExpenseFilterDialog extends ModalRoute<ExpenseFilter> {
  ExpenseFilter expenseFilter;
  ExpenseFilterDialog(this.expenseFilter);

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
    return ExpenseFilterForm(
        expenseFilter: expenseFilter,
        searchValue: (obj) {
          expenseFilter = obj;
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
class ExpenseFilterForm extends StatefulWidget {
  final ExpenseFilter expenseFilter;
  final ValueChanged<ExpenseFilter> searchValue;
  ExpenseFilterForm({this.expenseFilter, this.searchValue});
  @override
  _ExpenseFilterFormState createState() => _ExpenseFilterFormState(expenseFilter, searchValue);
}

class _ExpenseFilterFormState extends State<ExpenseFilterForm> {
  ExpenseFilter expenseFilter;
  final ValueChanged<ExpenseFilter> searchValue;
  _ExpenseFilterFormState(this.expenseFilter, this.searchValue);

  bool isText = false; //search text avalaibal or not.
  bool isReset = true;
  BusinessRule br = BusinessRule();

  ExpenseCategory _expenseCategory;
  var _cSearchString = TextEditingController();
  var _cDateRangeTo = TextEditingController();
  var _cDateRangeFrom = TextEditingController();
  var _cPaymentMode = TextEditingController();
  var _cCategory = TextEditingController();
  var _fFromDate = FocusNode();
  var _fToDate = FocusNode();
  var _fCategory = FocusNode();
  var _fPaymentMethod = FocusNode();
  var _focusNode = FocusNode();
  String _dateRangeTo2 = '';
  String _dateRangeFrom2 = '';
  bool _error = false;

  // PropertyFilter _accountFilter =  PropertyFilter();

  void resetFilter() {
    resetConfirmationDialog();
  }

  // Future<Null> _selectDate(BuildContext context) async {
  //   try {
  //     final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: _dateRangeFrom2 != null && _dateRangeFrom2.isNotEmpty ? DateTime.parse(_dateRangeFrom2) : _dateRangeTo2 != null && _dateRangeTo2.isNotEmpty ? DateTime.parse(_dateRangeTo2) : DateTime.now(),
  //       firstDate: DateTime(1940),
  //       lastDate: DateTime.now(),
  //       helpText: "${global.appLocaleValues['tle_select_date']}".toUpperCase(),
  //       cancelText: "${global.appLocaleValues['lbl_cancel']}".toUpperCase(),
  //       confirmText: "${global.appLocaleValues['btn_confirm']}".toUpperCase(),
  //     );
  //     if (picked != null && picked != DateTime(2000)) {
  //       setState(() {
  //         if (_dateFrom) {
  //           _cDateRangeFrom.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
  //           _dateRangeFrom2 = picked.toString().substring(0, 10);
  //         } else {
  //           _cDateRangeTo.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
  //           _dateRangeTo2 = picked.toString().substring(0, 10);
  //         }
  //       });
  //     }
  //     FocusScope.of(context).requestFocus(_focusNode);
  //   } catch (e) {
  //     print('Exception - expenseScreen.dart - _selectDate(): ' + e.toString());
  //   }
  // }

  Future<Null> _selectDateFrom() async {
    try {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _dateRangeFrom2 != null && _dateRangeFrom2.isNotEmpty
            ? DateTime.parse(_dateRangeFrom2)
            : _dateRangeTo2.isNotEmpty
                ? DateTime.parse(_dateRangeTo2)
                : DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: _dateRangeTo2.isNotEmpty ? DateTime.parse(_dateRangeTo2) : DateTime.now(),
        helpText: "${global.appLocaleValues['tle_select_date']}".toUpperCase(),
        cancelText: "${global.appLocaleValues['lbl_cancel']}".toUpperCase(),
        confirmText: "${global.appLocaleValues['btn_confirm']}".toUpperCase(),
      );
      if (picked != null && picked != DateTime(2000)) {
        setState(() {
          _error = false;
          _cDateRangeFrom.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
          _dateRangeFrom2 = picked.toString().substring(0, 10);
        });
      }
      FocusScope.of(context).requestFocus(_focusNode);
    } catch (e) {
      print('Exception - expenseScreen.dart - _selectDateFrom(): ' + e.toString());
    }
  }

  Future<Null> _selectDateTo() async {
    try {
      DateTime _date = DateTime(1990);
      if (_dateRangeFrom2 != null && _dateRangeFrom2.isNotEmpty) {
        _date = DateTime.parse(_dateRangeFrom2);
      }
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _dateRangeTo2 != null && _dateRangeTo2.isNotEmpty ? DateTime.parse(_dateRangeTo2) : DateTime.now(),
        firstDate: _date,
        lastDate: DateTime.now(),
        helpText: "${global.appLocaleValues['tle_select_date']}".toUpperCase(),
        cancelText: "${global.appLocaleValues['lbl_cancel']}".toUpperCase(),
        confirmText: "${global.appLocaleValues['btn_confirm']}".toUpperCase(),
      );
      if (picked != null && picked != DateTime(2000)) {
        setState(() {
          _cDateRangeTo.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
          _dateRangeTo2 = picked.toString().substring(0, 10);
        });
      }
      FocusScope.of(context).requestFocus(_focusNode);
    } catch (e) {
      print('Exception - expenseScreen.dart - _selectDateTo(): ' + e.toString());
    }
  }

  Future _selectPaymentMethod() async {
    try {
      if (_fPaymentMethod.hasFocus) {
        await showDialog(
            context: context,
            builder: (_) {
              return PaymentMethodSelectDialog(
                onChanged: (value) {
                  _cPaymentMode.text = value;
                },
              );
            });

        setState(() {
          FocusScope.of(context).requestFocus(_focusNode);
        });
      }
    } catch (e) {
      print('Exception - expenseScreen.dart - _selectPaymentMethod(): ' + e.toString());
    }
  }

  Future _selectExpenseCategory() async {
    try {
      if (_fCategory.hasFocus) {
        await showDialog(
            context: context,
            builder: (_) {
              return ExpenseCategorySelectDialog(
                returnScreenId: 1,
                selectedExpense: (obj) {
                  _expenseCategory = obj;
                },
              );
            });

        setState(() {
          _cCategory.text = (_expenseCategory != null) ? _expenseCategory.name : '';
        });
      }
      FocusScope.of(context).requestFocus(_focusNode);
    } catch (e) {
      print('Exception - expenseScreen.dart - _selectExpenseCategory(): ' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    _fPaymentMethod.addListener(_selectPaymentMethod);
    _fCategory.addListener(_selectExpenseCategory);

    _cSearchString.text = expenseFilter.searchString;
    _dateRangeFrom2 = (expenseFilter.fromDate != null) ? expenseFilter.fromDate.toString() : '';
    _cDateRangeFrom.text = (expenseFilter.fromDate != null) ? DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(expenseFilter.fromDate) : null;
    _dateRangeTo2 = (expenseFilter.toDate != null) ? expenseFilter.toDate.toString() : '';
    _cDateRangeTo.text = (expenseFilter.toDate != null) ? DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(expenseFilter.toDate) : null;
    _cPaymentMode.text = expenseFilter.paymentMode;
    _expenseCategory = expenseFilter.searchExpenseCategory;
    _cCategory.text = (expenseFilter.searchExpenseCategory != null) ? expenseFilter.searchExpenseCategory.name : '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: AppBar(
              leading: Icon(
                MdiIcons.filter,
                size: 20,
              ),
              title: Text(
                '${global.appLocaleValues['tle_search_expense']}',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
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
                ),
              ],
            )),
        Container(
          color: Colors.white,
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Column(
              children: [
                Align(alignment: Alignment.centerLeft, child: Text('Search Expense', style: Theme.of(context).primaryTextTheme.headline3)),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextFormField(
                    controller: _cSearchString,
                    decoration: InputDecoration(
                      hintText: '${global.appLocaleValues['lbl_search_here']}',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) {
                      if (val.isEmpty) {
                        expenseFilter.searchString = null;
                      } else {
                        expenseFilter.searchString = _cSearchString.text;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: [
                Align(alignment: Alignment.centerLeft, child: Text('Select Expense Category', style: Theme.of(context).primaryTextTheme.headline3)),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextFormField(
                    controller: _cCategory,
                    focusNode: _fCategory,
                    readOnly: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: '${global.appLocaleValues['lbl_select_expense_cat_err_vel']}',
                      counterText: '',
                      prefixIcon: Icon(Icons.view_list),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: [
                Align(alignment: Alignment.centerLeft, child: Text('Select Date', style: Theme.of(context).primaryTextTheme.headline3)),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              controller: _cDateRangeFrom,
                              focusNode: _fFromDate,
                              readOnly: true,
                              maxLength: 5,
                              decoration: InputDecoration(
                                hintText: '${global.appLocaleValues['lbl_date_from']}',
                                counterText: '',
                                prefixIcon: Icon(Icons.calendar_today),
                                errorText: _error ? '${global.appLocaleValues['lbl_select_date']}' : null,
                              ),
                              onTap: () {
                                _selectDateFrom();
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              controller: _cDateRangeTo,
                              focusNode: _fToDate,
                              readOnly: true,
                              maxLength: 5,
                              decoration: InputDecoration(hintText: '${global.appLocaleValues['lbl_date_to']}', counterText: '', prefixIcon: Icon(Icons.calendar_today)),
                              onTap: () {
                                _selectDateTo();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: [
                Align(alignment: Alignment.centerLeft, child: Text('Select Payment Method', style: Theme.of(context).primaryTextTheme.headline3)),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextFormField(
                    controller: _cPaymentMode,
                    focusNode: _fPaymentMethod,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: '${global.appLocaleValues['lbl_payment_mode_err_vel']}',
                      counterText: '',
                      prefixIcon: Icon(Icons.payment),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 8.0, right: 8.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: TextButton(
                    onPressed: () {
                      expenseFilter.isSearch = false;
                      Navigator.of(context).pop();
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
                          width: 5.0,
                        ),
                        Text('${global.appLocaleValues['btn_cancel']}'.toUpperCase(), style: Theme.of(context).primaryTextTheme.headline3)
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
                      if (_dateRangeFrom2.isNotEmpty && _dateRangeTo2.isEmpty) {
                        setState(() {
                          _error = false;
                        });
                        _dateRangeTo2 = DateTime.now().toString().substring(0, 10);
                      } else if (_dateRangeTo2.isNotEmpty && _dateRangeFrom2.isEmpty) {
                        setState(() {
                          _error = true;
                        });
                      } else {
                        expenseFilter.isSearch = true;
                        expenseFilter.searchString = (_cSearchString.text.trim().isNotEmpty) ? _cSearchString.text.trim() : null;
                        expenseFilter.fromDate = (_dateRangeFrom2 != '') ? DateTime.parse(_dateRangeFrom2) : null;
                        expenseFilter.toDate = (_dateRangeTo2 != '') ? DateTime.parse(_dateRangeTo2) : null;
                        expenseFilter.paymentMode = (_cPaymentMode.text.trim().isNotEmpty) ? _cPaymentMode.text.trim() : null;
                        expenseFilter.searchExpenseCategory = (_expenseCategory != null) ? _expenseCategory : null;
                        //   searchValue(expenseFilter);
                        Navigator.pop(context, expenseFilter);
                      }
                      // Navigator.of(context).pop(expenseFilter);
                      //  _searchExpenses();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          color: Colors.white,
                          // size: 18.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('${global.appLocaleValues['btn_search']}', style: Theme.of(context).primaryTextTheme.headline2
                            // style: TextStyle(color: Colors.white, fontSize: 16.0),
                            // textAlign: TextAlign.center,
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

  Future<void> resetConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${global.appLocaleValues['lbl_reset']}'.toUpperCase(),
            style: Theme.of(context).primaryTextTheme.headline1,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${global.appLocaleValues['txt_filter']}', style: Theme.of(context).primaryTextTheme.headline3),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('${global.appLocaleValues['btn_cancel']}'.toUpperCase(), style: Theme.of(context).primaryTextTheme.headline2),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('${global.appLocaleValues['btn_ok']}', style: Theme.of(context).primaryTextTheme.headline2),
              onPressed: () {
                setState(() {
                  expenseFilter.isSearch = true;
                  expenseFilter.searchString = null;
                  expenseFilter.fromDate = null;
                  expenseFilter.toDate = null;
                  expenseFilter.paymentMode = null;
                  expenseFilter.searchExpenseCategory = null;
                  Navigator.of(context).pop();
                  Navigator.pop(context, expenseFilter);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
