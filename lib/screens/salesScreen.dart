// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnModel.dart';
import 'package:accounting_app/models/salesStatementModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/searchReport.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class SalesScreen extends BaseRoute {
  final String search;
  final String timePeriod;
  final String dateRange;
  SalesScreen({@required a, @required o, this.search, this.timePeriod, this.dateRange}) : super(a: a, o: o, r: 'SalesScreen');
  @override
  _SalesScreenState createState() => _SalesScreenState(this.search, this.timePeriod, this.dateRange);
}

class _SalesScreenState extends BaseRouteState {
  final String search;
  final String timePeriod;
  final String dateRange;
  List<SalesStatement> _salesStatementList = [];
  bool _isDataLoaded = false;
  bool _isPrint = false;
  double debit;
  _SalesScreenState(this.search, this.timePeriod, this.dateRange) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '${global.appLocaleValues['tle_sales_statement']}',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
          // (_isDataLoaded && _salesStatementList.length > 0)
          //     ? IconButton(
          //         icon: Icon(Icons.print),
          //         iconSize: 25,
          //         onPressed: () async {
          //           _isPrint = true;
          //           global.isAppOperation = true;
          //           await _printReport(_isPrint);
          //         },
          //       )
          //     : SizedBox(),
          // (_isDataLoaded && _salesStatementList.length > 0)
          //     ? IconButton(
          //         icon: Icon(Icons.share),
          //         iconSize: 25,
          //         onPressed: () async {
          //           _isPrint = false;
          //           global.isAppOperation = true;
          //           await _printReport(_isPrint);
          //         },
          //       )
          //     : SizedBox(),
          (_isDataLoaded)
              ? IconButton(
                  icon: Icon(FontAwesomeIcons.filter),
                  iconSize: 18,
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchReportScreen(
                              a: widget.analytics,
                              o: widget.observer,
                              returnScreenId: 3,
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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DashboardScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
            return null;
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              '${global.appLocaleValues['sal_stat_des']}',
              style: Theme.of(context).primaryTextTheme.headline3,
            )),
          )

          // (_isDataLoaded)
          //     ? (_salesStatementList.length > 0)
          //         ? Scrollbar(
          //             child: SingleChildScrollView(
          //               child: Column(
          //                 children: <Widget>[
          //                   Padding(padding: const EdgeInsets.only(top: 10)),
          //                   Text(
          //                     (timePeriod == null || timePeriod == 'All Time') ? '${global.appLocaleValues['lbl_all_time']}' : '$timePeriod ($dateRange)',
          //                     style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          //                   ),
          //                   Container(
          //                     width: MediaQuery.of(context).size.width,
          //                     child: DataTable(
          //                         columnSpacing: 3.5,
          //                         headingRowHeight: 35,
          //                         dataRowHeight: 60,
          //                         columns: <DataColumn>[
          //                           DataColumn(
          //                             label: Text('#'),
          //                           ),
          //                           DataColumn(
          //                             label: Text(global.appLocaleValues['tle_invoice'], style: TextStyle(fontSize: 10)),
          //                           ),
          //                           DataColumn(label: Text(global.appLocaleValues['tle_date_ac'], style: TextStyle(fontSize: 10))),
          //                           DataColumn(
          //                             label: Text(global.appLocaleValues['lbl_amount'], style: TextStyle(fontSize: 10)),
          //                           ),
          //                           DataColumn(
          //                             label: Text('${global.appLocaleValues['lbl_status']}', style: TextStyle(fontSize: 10)),
          //                           ),
          //                         ],
          //                         rows: _salesStatementList
          //                             .map((f) => DataRow(cells: [
          //                                   DataCell((_salesStatementList != null) ? Text((_salesStatementList.indexOf(f) + 1).toString()) : Text('')),
          //                                   DataCell((f.invoice != null) ? Text('${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + f.invoice.toString().length))}${f.invoice}') : Text('')),
          //                                   DataCell((f.date != null) ? Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(f.date)}\n${f.account}') : Text('')),
          //                                   DataCell((f.amount != null)
          //                                       ? Text(
          //                                           '${global.currency.symbol} ${(f.amount).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
          //                                           style: TextStyle(color: Colors.black),
          //                                         )
          //                                       : Text('')),
          //                                   DataCell((f.status != null) ? Text('${f.status}') : Text('')),
          //                                 ]))
          //                             .toList()),
          //                   )
          //                 ],
          //               ),
          //             ),
          //           )
          //         : Center(
          //             child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: <Widget>[
          //               Icon(
          //                 Icons.assessment,
          //                 color: Colors.grey,
          //                 size: 180,
          //               ),
          //               SizedBox(
          //                 height: 10,
          //               ),
          //               Text(
          //                 '${global.appLocaleValues['txt_sale_empty_msg']}',
          //                 style: TextStyle(color: Colors.grey, fontSize: 18),
          //               ),
          //               Text(
          //                 '${(timePeriod == null || timePeriod == 'All Time') ? global.appLocaleValues['lbl_all_time'] : '$timePeriod ($dateRange)'}',
          //                 style: TextStyle(color: Colors.grey, fontSize: 18),
          //               )
          //             ],
          //           ))
          //     : Center(
          //         child: CircularProgressIndicator(strokeWidth: 2),
          //       )
          ),
      bottomSheet: (_isDataLoaded)
          ? (_salesStatementList.isNotEmpty)
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
                              Text(global.appLocaleValues['lbl_total_sales_amount'], style: TextStyle(color: Colors.green)),
                              (_salesStatementList.isNotEmpty) ? Text('${global.currency.symbol} ${_salesStatementList.map((b) => b.amount).reduce((sum, amount) => sum + amount).round()}') : Text(''),
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
      _salesStatementList.clear();

      List<SaleInvoice> _saleInvoiceList = await dbHelper.saleInvoiceGetList(startDate: (search != null) ? dateto : null, endDate: (search != null) ? datefrom : null);

      for (int i = 0; i < _saleInvoiceList.length; i++) {
        SalesStatement _salesStatment = SalesStatement(_saleInvoiceList[i].invoiceDate, br.generateAccountName(_saleInvoiceList[i].account), _saleInvoiceList[i].invoiceNumber, _saleInvoiceList[i].netAmount, _saleInvoiceList[i].status, _saleInvoiceList[i].grossAmount);

        List<SaleInvoiceReturn> _saleInvoiceReturnList = await dbHelper.saleInvoiceReturnGetList(invoiceNumber: _saleInvoiceList[i].invoiceNumber);
        if (_saleInvoiceReturnList.length > 0) {
          double _saleReturnAmount = _saleInvoiceReturnList.map((f) => f.grossAmount).reduce((sum, amt) => sum + amt);
          _salesStatment.amount -= _saleReturnAmount;
        }

        if (_salesStatment.amount > 0) {
          _salesStatementList.add(_salesStatment);
        }
      }
      setState(() {});
    } catch (e) {
      print('Exception - salesScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _printReport(_isPrint) async {
    try {
      double _amount = _salesStatementList.map((b) => b.amount).reduce((sum, amount) => sum + amount);
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
      htmlContent += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_sales_statement']}</font></h1>
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

      _salesStatementList.forEach((item) {
        htmlContent += """
      <tr>
    <td>${(_salesStatementList.indexOf(item)) + 1}</td>
    <td>${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(item.date)}</td>
     <td>${item.account}</td>
     <td>${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + item.invoice.toString().length))}${item.invoice}</td>
     <td>${global.currency.symbol} ${(item.amount).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
     <td>${item.status}</td>
    </tr>
      """;
      });

      htmlContent += """
    </table>
     <table style='width:100%'>
   
     <tr>
     <td style="background-color: teal;color: white;width: 20%"><b>${global.appLocaleValues['lbl_total_sales_amount']}</b></td>
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
        await Printing.sharePdf(bytes: pdf, filename: 'sales_statement.pdf');
      }
    } catch (e) {
      print('Exception - salesScreen.dart - _printReport(): ' + e.toString());
    }
  }
}
