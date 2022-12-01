// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/accountSearchModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceReturnModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/employeeScreen.dart';
import 'package:accounting_app/screens/searchReport.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class EmployeeStatementScreen extends BaseRoute {
  final Account account;
  final String search;
  final String timePeriod;
  final String dateRange;
  final int screenId;
  EmployeeStatementScreen({@required a, @required o, @required this.screenId, this.account, this.search, this.timePeriod, this.dateRange}) : super(a: a, o: o, r: 'EmployeeStatementScreen');
  @override
  _EmployeeStatemnetScreenState createState() => _EmployeeStatemnetScreenState(this.account, this.search, this.timePeriod, this.dateRange, this.screenId);
}

class _EmployeeStatemnetScreenState extends BaseRouteState {
  final String search;
  final Account account;
  final String dateRange;
  final int screenId;
  final String timePeriod;
  Account _account;
  bool _isDataLoaded = false;
  bool _isPrint = false;
  double _totalReceived = 0;
  double _totalGiven = 0;
  TextEditingController _cAccountId = TextEditingController();

  _EmployeeStatemnetScreenState(this.account, this.search, this.timePeriod, this.dateRange, this.screenId) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          global.appLocaleValues['tle_emp_statement'],
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
          (_isDataLoaded && _account != null && _account.paymentList.length > 0)
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
          (_isDataLoaded && _account != null && _account.paymentList.length > 0)
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
          (_isDataLoaded && _account != null)
              ? IconButton(
                  icon: Icon(FontAwesomeIcons.filter),
                  iconSize: 18,
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchReportScreen(
                              a: widget.analytics,
                              o: widget.observer,
                              returnScreenId: 7,
                              account: _account,
                              accountStatementScreenId: screenId,
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
            if (screenId == 0) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      )));
            } else {
              AccountSearch accountSearch = AccountSearch();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => EmployeeScreen(
                        redirectToCustomersTab: true,
                        a: widget.analytics,
                        o: widget.observer,
                        accountSearch: accountSearch,
                      )));
            }
            return null;
          },
          child: (_isDataLoaded)
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                          controller: _cAccountId,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: global.appLocaleValues['lbl_emp_err_req'],
                            labelText: global.appLocaleValues['lbl_emp_err_req'],
                            border: nativeTheme().inputDecorationTheme.border,
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
                    (_account != null && _account.paymentList.length > 0)
                        ? Scrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Padding(padding: const EdgeInsets.only(top: 5)),
                                  Text(
                                    global.appLocaleValues['tle_emp_statement'],
                                    style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Padding(padding: const EdgeInsets.only(top: 10)),
                                  Text(
                                    '${br.generateAccountName(_account)}',
                                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  Padding(padding: const EdgeInsets.only(top: 10)),
                                  Text(
                                    (timePeriod == null || timePeriod == 'All Time') ? global.appLocaleValues['lbl_all_time'] : '$timePeriod ($dateRange)',
                                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  Padding(padding: const EdgeInsets.only(top: 15)),
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
                                            label: Text(global.appLocaleValues['lbl_desc'], style: TextStyle(fontSize: 10)),
                                          ),
                                          DataColumn(
                                            label: Text(global.appLocaleValues['lbl_date'], style: TextStyle(fontSize: 10)),
                                          ),
                                          DataColumn(
                                            label: Text(global.appLocaleValues['lbl_amount'], style: TextStyle(fontSize: 10)),
                                          ),
                                          DataColumn(
                                            label: Text(global.appLocaleValues['lbl_status'], style: TextStyle(fontSize: 10)),
                                          ),
                                        ],
                                        rows: (_account.paymentList != null)
                                            ? _account.paymentList
                                                .map((f) => DataRow(cells: [
                                                      DataCell((_account.paymentList != null) ? Text((_account.paymentList.indexOf(f) + 1).toString()) : Text('')),
                                                      DataCell((f.invoiceNumber != null)
                                                          ? Row(
                                                              children: <Widget>[
                                                                Text('ref ', style: TextStyle(color: Colors.grey)),
                                                                Text(
                                                                    '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + f.invoiceNumber.toString().length))}${f.invoiceNumber}')
                                                              ],
                                                            )
                                                          : (f.isSaleInvoiceReturnRef)
                                                              ? Row(
                                                                  children: <Widget>[
                                                                    Text(
                                                                      'ref ',
                                                                      style: TextStyle(color: Colors.grey),
                                                                    ),
                                                                    Text(global.appLocaleValues['ref_sales_return'])
                                                                  ],
                                                                )
                                                              : Text('')),
                                                      DataCell((f.transactionDate != null) ? Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(f.transactionDate)}') : Text('')),
                                                      DataCell((f.amount != null) ? Text('${global.currency.symbol} ${f.amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}') : Text('')),
                                                      DataCell((f.paymentType != null) ? Text('${f.paymentType}') : Text('')),
                                                      //  DataCell(Text('${f.remark}')),
                                                    ]))
                                                .toList()
                                            : SizedBox()),
                                  )
                                ],
                              ),
                            ),
                          )
                        : (_account != null)
                            ? Center(
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
                                    '${global.appLocaleValues['txt_ac_statement_empty_msg']}',
                                    style: TextStyle(color: Colors.grey, fontSize: 18),
                                  ),
                                  Text(
                                    '${(timePeriod == null || timePeriod == 'All Time') ? global.appLocaleValues['lbl_all_time'] : '$timePeriod ($dateRange)'}',
                                    style: TextStyle(color: Colors.grey, fontSize: 18),
                                  )
                                ],
                              ))
                            : SizedBox()
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
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
          : SizedBox(),
    );
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
    // _getData();
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
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - ExpenseStatement.dart - _getData(): ' + e.toString());
    }
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
      htmlContent += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_emp_statement']}</font></h1>
    
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
        await Printing.sharePdf(bytes: pdf, filename: 'emp_statement.pdf');
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
                returnScreenId: 4,
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
