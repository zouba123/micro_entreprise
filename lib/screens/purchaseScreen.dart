// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/purchaseStatementModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/searchReport.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class PurchaseScreen extends BaseRoute {
  final String search;
  final String timePeriod;
  final String dateRange;
  PurchaseScreen({@required a, @required o, this.search, this.timePeriod, this.dateRange}) : super(a: a, o: o, r: 'PurchaseScreen');
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState(this.search, this.timePeriod, this.dateRange);
}

class _PurchaseScreenState extends BaseRouteState {
  List<PurchaseStatement> _purchaseStatementList = [];
  bool _isDataLoaded = false;
  bool _isPrint = false;
  double debit;
  final String search;
  final String timePeriod;
  final String dateRange;

  _PurchaseScreenState(this.search, this.timePeriod, this.dateRange) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '${global.appLocaleValues['tle_purchase_statement']}',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
          (_isDataLoaded && _purchaseStatementList.length > 0)
              ? IconButton(
                  icon: Icon(Icons.print),
                  iconSize: 25,
                  onPressed: () async {
                    _isPrint = true;
                    global.isAppOperation = true;
                    await _printReport(_isPrint);
                  },
                )
              : SizedBox(),
          (_isDataLoaded && _purchaseStatementList.length > 0)
              ? IconButton(
                  icon: Icon(Icons.share),
                  iconSize: 25,
                  onPressed: () async {
                    _isPrint = false;
                    global.isAppOperation = true;
                    await _printReport(_isPrint);
                  },
                )
              : SizedBox(),
          (_isDataLoaded)
              ? IconButton(
                  icon: Icon(FontAwesomeIcons.filter),
                  iconSize: 18,
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchReportScreen(
                              a: widget.analytics,
                              o: widget.observer,
                              returnScreenId: 4,
                            )));
                  },
                )
              : SizedBox(),
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
          child: (_isDataLoaded)
              ? (_purchaseStatementList.length > 0)
                  ? Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(padding: const EdgeInsets.only(top: 10)),
                            Text(
                              (timePeriod == null || timePeriod == 'All Time') ? '${global.appLocaleValues['lbl_all_time']}' : '$timePeriod ($dateRange)',
                              style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: DataTable(
                                  columnSpacing: 3.5,
                                  headingRowHeight: 35,
                                  dataRowHeight: 60,
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text('#'),
                                    ),
                                    DataColumn(
                                      label: Text(global.appLocaleValues['tle_invoice'], style: TextStyle(fontSize: 10)),
                                    ),
                                    DataColumn(label: Text(global.appLocaleValues['tle_date_ac'], style: TextStyle(fontSize: 10))),
                                    DataColumn(
                                      label: Text(global.appLocaleValues['lbl_amount'], style: TextStyle(fontSize: 10)),
                                    ),
                                    DataColumn(
                                      label: Text('${global.appLocaleValues['lbl_status']}', style: TextStyle(fontSize: 10)),
                                    ),
                                  ],
                                  rows: _purchaseStatementList
                                      .map((f) => DataRow(cells: [
                                            DataCell((_purchaseStatementList != null) ? Text((_purchaseStatementList.indexOf(f) + 1).toString()) : Text('')),
                                            DataCell((f.invoice != null) ? Text('${f.invoice}') : Text('')),
                                            DataCell((f.date != null) ? Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(f.date)}\n${f.account}') : Text('')),
                                            DataCell((f.amount != null)
                                                ? Text(
                                                    '${global.currency.symbol} ${(f.amount).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                    style: TextStyle(color: Colors.black),
                                                  )
                                                : Text('')),
                                            DataCell((f.status != null) ? Text('${f.status}') : Text('')),
                                          ]))
                                      .toList()),
                            )
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.assessment,
                          color: Colors.grey,
                          size: 180,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${global.appLocaleValues['txt_purchase_empty_msg']}',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        Text(
                          '${(timePeriod == null || timePeriod == 'All Time') ? global.appLocaleValues['lbl_all_time'] : '$timePeriod ($dateRange)'}',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        )
                      ],
                    ))
              : Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                )),
      bottomSheet: (_isDataLoaded)
          ? (_purchaseStatementList.isNotEmpty)
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
                              Text('${global.appLocaleValues['lbl_total_purchase_amount']}', style: TextStyle(color: Colors.red)),
                              (_purchaseStatementList.isNotEmpty) ? Text('${global.currency.symbol} ${_purchaseStatementList.map((b) => b.amount).reduce((sum, amount) => sum + amount).round()}') : Text(''),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox()
          : SizedBox(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState({bool isSearchAction}) {
    super.initState();
    // if (isSearchAction == null) {
    //   search == null;
    // }
    _getData();
    _isDataLoaded = true;
  }

  Future _getData() async {
    try {
      String todate = (search != null) ? search.substring(0, 10) : null;
      String endDate = (search != null) ? search.substring(11, 21) : null;
      var dateto = (search != null) ? DateTime.parse(todate) : null;
      var datefrom = (search != null) ? DateTime.parse(endDate) : null;
      _purchaseStatementList.clear();

      List<PurchaseInvoice> _purchaseInvoiceList = await dbHelper.purchaseInvoiceGetList(startDate: (search != null) ? dateto : null, endDate: (search != null) ? datefrom : null);

      for (int i = 0; i < _purchaseInvoiceList.length; i++) {
        PurchaseStatement _purchaseStatment = PurchaseStatement(_purchaseInvoiceList[i].invoiceDate, br.generateAccountName(_purchaseInvoiceList[i].account), _purchaseInvoiceList[i].invoiceNumber, _purchaseInvoiceList[i].netAmount, _purchaseInvoiceList[i].status, _purchaseInvoiceList[i].netAmount);
        List<PurchaseInvoiceReturn> _purchaseInvoiceReturnList = await dbHelper.purchaseInvoiceReturnGetList(purchaseInvoiceNumber: _purchaseInvoiceList[i].invoiceNumber);
        if (_purchaseInvoiceReturnList.length > 0) {
          double _purchaseReturnAmount = _purchaseInvoiceReturnList.map((f) => f.netAmount).reduce((sum, amt) => sum + amt);
          _purchaseStatment.amount -= _purchaseReturnAmount;
        }
        if (_purchaseStatment.amount > 0) {
          _purchaseStatementList.add(_purchaseStatment);
        }
      }
      setState(() {});
    } catch (e) {
      print('Exception - PurchaseStatement.dart - _getData(): ' + e.toString());
    }
  }

  Future _printReport(_isPrint) async {
    try {
      double _amount = _purchaseStatementList.map((b) => b.amount).reduce((sum, amount) => sum + amount);
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
      htmlContent += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_purchase_statement']}</font></h1>
    <p style='float: right'><font size=4>${global.appLocaleValues['lbl_date']}: ${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.now())}</font></p>
    <table style='width:100%'>
    <tr>
    <th>#</th>
    <th>${global.appLocaleValues['lbl_date']}</th>
    <th>${global.appLocaleValues['tab_ac']}</th>
    <th>${global.appLocaleValues['tle_invoice']}</th>
    <th>${global.appLocaleValues['lbl_amount']}</th>
    <th>${global.appLocaleValues['lbl_status']}</th>

    </tr>
     """;

      _purchaseStatementList.forEach((item) {
        htmlContent += """
      <tr>
    <td>${(_purchaseStatementList.indexOf(item)) + 1}</td>
    <td>${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(item.date)}</td>
     <td>${item.account}</td>
     <td>${item.invoice}</td>
     <td>${global.currency.symbol} ${(item.amount).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
     <td>${item.status}</td>
    </tr>
      """;
      });

      htmlContent += """
    </table>
     <table style='width:100%'>
   
     <tr>
     <td style="background-color: teal;color: white;width: 20%"><b>${global.appLocaleValues['lbl_total_purchase_amount']}</b></td>
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
        await Printing.sharePdf(bytes: pdf, filename: 'Purchase_statement.pdf');
      }
    } catch (e) {
      print('Exception - PurchaseStatement.dart - _printReport(): ' + e.toString());
    }
  }
}
