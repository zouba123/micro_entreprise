// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/salesGeneralReportFilterModel.dart';
import 'package:accounting_app/models/salesGeneralReportModel.dart';
import 'package:accounting_app/reports/salesGeneralReportFilterScreen.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SalesGeneralReport extends BaseRoute {
  final SalesGeneralReportFilterModel salesGeneralReportFilter;
  SalesGeneralReport({@required a, @required o, this.salesGeneralReportFilter}) : super(a: a, o: o, r: 'SalesGeneralReport');
  @override
  _SalesGeneralReportState createState() => _SalesGeneralReportState(salesGeneralReportFilter: salesGeneralReportFilter);
}

class _SalesGeneralReportState extends BaseRouteState {

  List<SalesGeneralReportModel> _salesGeneralReportList = [];
  SalesGeneralReportFilterModel salesGeneralReportFilter =  SalesGeneralReportFilterModel();
  bool downloading = false;
  // String progress = '0';
  // bool isDownloaded = false;
  // String filename = 'test.pdf';
  bool _isDataLoaded = false;  
  var _html;
  String encodedHtmlContent;
  AnimationController menuAnimation;
  IconData lastTapped = Icons.notifications;

  _SalesGeneralReportState({this.salesGeneralReportFilter}) : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          _checkBackPress();
          return null;
        },
        child: Scaffold(
          
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
            floatingActionButton: Padding(
              padding: EdgeInsets.only(left: 10, bottom: 8),
              child: SizedBox(
                height: 58,
                child: Flow(
                  delegate: FlowMenuDelegate(menuAnimation: menuAnimation),
                  children: menuItems.map<Widget>((IconData icon) => flowMenuItem(icon)).toList(),
                ),
              ),
            ),
            appBar: AppBar(
              title: Text(
                global.appLocaleValues['tle_sales_gen_report'],
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              actions: [
                IconButton(
                    icon: Icon(MdiIcons.filter),
                    onPressed: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalesGeneralReportFilterScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    appliedFilter: salesGeneralReportFilter,
                                  )));
                    }),
              ],
            ),
            body: (_isDataLoaded)
                ? (_salesGeneralReportList != null)
                    ? Stack(children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.79,
                          child: InAppWebView(
                            initialUrlRequest: URLRequest(url: Uri.parse('data:text/html;base64,$encodedHtmlContent')),
                            // withJavascript: false,
                            // displayZoomControls: true,
                            // useWideViewPort: true,
                            // withZoom: true,
                            // hidden: false,
                            // withOverviewMode: true,
                          ),
                        ),
                      ])
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
                              global.appLocaleValues['tle_without_tax_invoice_empty_'],
                              style: TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          )
                        ],
                      ))
                : Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )));
  }

 
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    menuAnimation = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _init();
  }

  Future _init() async {
    try {
      await _getData();
      encodedHtmlContent = base64Encode(const Utf8Encoder().convert(_html));
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - salesGeneralReport.dart - _init(): ' + e.toString());
    }
  }

  Future _getData() async {
    try {
      if (salesGeneralReportFilter == null) {
        salesGeneralReportFilter =  SalesGeneralReportFilterModel();
        salesGeneralReportFilter.invoiceDateFrom = DateTime.parse(DateTime.now().subtract(Duration(days: 7)).toString().substring(0, 10));
        salesGeneralReportFilter.invoiceDateTo = DateTime.parse(DateTime.now().toString().substring(0, 10));
      }
      _salesGeneralReportList = await dbHelper.getSalesGeneralReportData(salesGeneralReportFilter);

      await _buildHtml();
    } catch (e) {
      print('Exception - salesGeneralReport.dart - _getData(): ' + e.toString());
    }
  }

  Future _buildHtml() async {
    try {
      if (global.encodedLogo == null) {
        final bytes = (global.business.logoPath != null && global.business.logoPath.isNotEmpty) ? await io.File(global.business.logoPath).readAsBytes() : null;
        global.encodedLogo = (global.business.logoPath != null && global.business.logoPath.isNotEmpty) ? base64.encode(bytes) : null;
      }
      _html = """
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
  }""";

      // if (isPrintAction == null) {
      _html += """
    .page {
        width: 210mm;
        min-height: 297mm;
        padding: 20mm;
        margin: 10mm auto;
        // border: 1px #D3D3D3 solid;
        // border-radius: 5px;
    }

     @page {
        size: A4;
        margin: 0;
    }
    """;
      // }

      _html += """ 

  </style>
</head> """;
      // if (isPrintAction == null) {
      _html += """
  <body class="page">
  """;
      // }
      _html += """ <div align=center style="display: flex;
        align-items: center;
        justify-content: center;">""";
      if (global.encodedLogo != null) {
        _html += """ <img src="data:image/jpeg;base64,${global.encodedLogo}"
                style="width: 50px;height: auto;margin-right: 10px;" alt="logo">""";
      }

      _html += """  <span style="font-size: xx-large; font-weight: bold;">${global.business.name}</span></div><h4 align=center>${global.business.addressLine1}</br>""";

      if (global.business.contact1 != null) {
        _html += """${global.country.isoCode} ${global.business.contact1}<br>""";
      }
      if (global.business.email != null && global.business.email != "") {
        _html += """${global.business.email}<br>""";
      }

      if (global.business.website != null && global.business.website != "") {
        _html += """${global.business.website}<br><h4>""";
      }
      // if (global.business.gstNo != null && global.business.gstNo != "") {
      //   _html += """${global.appLocaleValues['lbl_gst_no_']}: ${global.business.gstNo}<br><h4>""";
      // }
      _html += """
  <hr>
  </header>
  """;

      _html += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_sales_gen_report']}</font></h1> <br>
                      <table style='width:100%'>
    <tr>
    <th>#</th>
     <th>${global.appLocaleValues['tle_sale_inv']}</th>
    <th>${global.appLocaleValues['sale_quot']}</th>
    <th>${global.appLocaleValues['tab_ac']}</th>
    <th>${global.appLocaleValues['sunttl']}</th>
    <th>${global.appLocaleValues['lbl_discount']}<br>${global.appLocaleValues['tle_tax']}</th>
    <th>${global.appLocaleValues['lbl_total']}</th>
    <th>${global.appLocaleValues['lbl_invoice_date_']}<br>${global.appLocaleValues['lbl_delivery_date_']}</th>
    <th>${global.appLocaleValues['payment_paid']}</th>
    <th>${global.appLocaleValues['payment_pensing']}</th>
    <th>${global.appLocaleValues['inv_sta']}</th>
    </tr>
   """;

      for (int i = 0; i < _salesGeneralReportList.length; i++) {
        Account _account =  Account();
        _account.namePrefix = _salesGeneralReportList[i].accountNamePrefix;
        _account.firstName = _salesGeneralReportList[i].accountFirstName;
        _account.middleName = _salesGeneralReportList[i].accountMiddleName;
        _account.lastName = _salesGeneralReportList[i].accountLastName;
        _account.nameSuffix = _salesGeneralReportList[i].accountNameSuffix;

        String _accountDetails = br.generateAccountName(_account);
        if (_salesGeneralReportList[i].accountMobile.isNotEmpty) {
          _accountDetails += '<br> +${_salesGeneralReportList[i].accountMobileCountryCode}${_salesGeneralReportList[i].accountMobile}';
        }

        if (_salesGeneralReportList[i].accountEmail.isNotEmpty) {
          _accountDetails += '<br> ${_salesGeneralReportList[i].accountEmail}';
        }

        String _quote = (_salesGeneralReportList[i].saleQuoteNumber.isNotEmpty) ? '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _salesGeneralReportList[i].saleQuoteNumber.toString().length))}${_salesGeneralReportList[i].saleQuoteNumber}-${_salesGeneralReportList[i].saleQuoteversion}' : '';
        _html += """ <tr>
     <td>${i + 1}</td>
     <td>${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _salesGeneralReportList[i].saleInvoiceNumber.toString().length))}${_salesGeneralReportList[i].saleInvoiceNumber}</td>
     <td>$_quote</td>
     <td>$_accountDetails</td>
     <td>${global.currency.symbol}${_salesGeneralReportList[i].grossAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
     <td>${global.currency.symbol}${_salesGeneralReportList[i].discountAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}<br>${global.currency.symbol}${_salesGeneralReportList[i].taxAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
     <td>${global.currency.symbol}${_salesGeneralReportList[i].netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
     <td>${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_salesGeneralReportList[i].invoiceDate)}<br>${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_salesGeneralReportList[i].deliveryDate)}</td>
    <td>${global.currency.symbol}${_salesGeneralReportList[i].paymentDone.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    <td>${global.currency.symbol}${_salesGeneralReportList[i].paymentPending.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    <td>${_salesGeneralReportList[i].status}</td>
     </tr>""";
      }

      _html += """ <tr>
     <td></td>
     <td></td>
     <td></td>
     <td></td>
     <td><b>${global.currency.symbol}${_salesGeneralReportList.map((e) => e.grossAmount).reduce((v, e) => e + v).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
     <td><b>${global.currency.symbol}${_salesGeneralReportList.map((e) => e.discountAmount).reduce((v, e) => e + v).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}<br>${global.currency.symbol}${_salesGeneralReportList.map((e) => e.taxAmount).reduce((v, e) => e + v).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
     <td><b>${global.currency.symbol}${_salesGeneralReportList.map((e) => e.netAmount).reduce((v, e) => e + v).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
     <td></td>
    <td><b>${global.currency.symbol}${_salesGeneralReportList.map((e) => e.paymentDone).reduce((v, e) => e + v).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
    <td><b>${global.currency.symbol}${_salesGeneralReportList.map((e) => e.paymentPending).reduce((v, e) => e + v).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
    <td></td>
     </tr>""";

      _html += """
   </table>
</body>
  <footer>
      <hr>
      <span style="display: flex;
    align-items: center;
    justify-content: center;">Generated on: ${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.now())} ${DateFormat.jm().format(DateTime.now())}</span>
      </footer>
</html>
      """;
      print('hi');
    } catch (e) {
      print('Exception - salesGeneralReport.dart - _buildHtml(): ' + e.toString());
    }
  }

 Future<bool> _checkBackPress() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardScreen(
                  a: widget.analytics,
                  o: widget.observer,
                )));
    return false;
  }

Widget progressPrivacy =  Center(
    child: Container(
      child: CircularProgressIndicator(
        backgroundColor: Color(0xFFbc9307),
        valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFFbc9307)),
        strokeWidth: 2,
      ),
    ),
  );

  void _updateMenu(IconData icon) {
    if (icon == Icons.menu) {
      setState(() => lastTapped = icon);
    } else if (icon == Icons.print) {
      lastTapped = icon;
      setState(() {});
    } else if (icon == Icons.share) {
      lastTapped = icon;
      setState(() {});
    } 
    // else if (icon == Icons.download) {
    //   lastTapped = icon;
    //   setState(() {});
    // } else if (icon == MdiIcons.fileExcel) {
    //   lastTapped = icon;
    //   setState(() {});
    // }
  }

  Widget flowMenuItem(IconData icon) {
    final double buttonDiameter = 48;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: RawMaterialButton(
        fillColor: Theme.of(context).primaryColor,
        splashColor: Colors.amber[100],
        shape: CircleBorder(),
        constraints: BoxConstraints.tight(Size(buttonDiameter, buttonDiameter)),
        onPressed: () async {
          _updateMenu(icon);
          if (lastTapped == Icons.print) {
            global.isAppOperation = true;
            await br.printReport(_html);
          } else if (lastTapped == Icons.print) {
            global.isAppOperation = true;
            await br.printReport(_html);
          } else if (lastTapped == Icons.share) {
            global.isAppOperation = true;
            String fileName = 'SalesGeneralReport.pdf';
            await br.shareReport(_html, fileName);
          } 
          // else if (lastTapped == Icons.download) {
          //   global.isAppOperation = true;
          //   await br.printReport(_html);
          // } else if (lastTapped == MdiIcons.fileExcel) {
          //   // global.isAppOperation = true;
          //   // await br.printReport(_html);
          // } 
          else {
            menuAnimation.status == AnimationStatus.completed ? menuAnimation.reverse() : menuAnimation.forward();
          }
        },
        child: Icon(
          icon,
          color: lastTapped == icon ? Theme.of(context).primaryColorDark : Colors.white,
          size: 23.0,
        ),
      ),
    );
  }

  // _downloadExcel() {
  //   try {
  //     xl.Workbook workbook =  xl.Workbook();
  //     xl.Worksheet sheet = workbook.worksheets[0];

  //     List<xl.ExcelDataRow> _dataRow = _getExcelDataRow();
  //     sheet.importData(_dataRow, 1, 1);

  //     sheet.getRangeByName('A1:F1').cellStyle.bold = true;
  //     sheet.getRangeByName('A1:B1').columnWidth = 25.0;
  //     sheet.getRangeByName('C1').columnWidth = 50.0;
  //     sheet.getRangeByName('D1:F1').columnWidth = 25.0;
  //     sheet.getRangeByName('A1:G1').cellStyle.hAlign = xl.HAlignType.center;
  //     sheet.getRangeByName('A1:G1').cellStyle.vAlign = xl.VAlignType.center;

  //     List<int> bytes = workbook.saveAsStream();
  //     workbook.dispose();
  //     //Save and launch file.
  //     // SaveFilehelper.saveAndOpenFile(bytes);

  //     // final url = ht.Url.createObjectUrlFromBlob(ht.Blob([bytes], "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
  //     // final anchor = ht.document.createElement('a') as ht.AnchorElement
  //     //   ..href = url
  //     //   ..style.display = 'none'
  //     //   ..download = 'productpricereport.xlsx';
  //     // ht.document.body.children.add(anchor);
  //     // anchor.click();
  //     // ht.document.body.children.remove(anchor);
  //     // ht.Url.revokeObjectUrl(url);
  //     // workbook.dispose();
  //   } catch (e) {
  //     print('Exception: salesGeneralReport: _downloadExcel(): ${e.toString()}');
  //   }
  // }

  // List<xl.ExcelDataRow> _getExcelDataRow() {
  //   List<xl.ExcelDataRow> _dataRowList = [];
  //   for (int i = 0; i < _salesGeneralReportList.length; i++) {
  //     _dataRowList.add(
  //       xl.ExcelDataRow(
  //         cells: [
  //           xl.ExcelDataCell(columnHeader: 'Index', value: i + 1),
  //           xl.ExcelDataCell(columnHeader: 'Sale Invoice', value: _salesGeneralReportList[i].saleInvoiceNumber),
  //           xl.ExcelDataCell(columnHeader: 'Sale Quote', value: _salesGeneralReportList[i].saleQuoteNumber),
  //           xl.ExcelDataCell(columnHeader: 'Account', value: _salesGeneralReportList[i].accountNamePrefix + _salesGeneralReportList[i].accountFirstName + _salesGeneralReportList[i].accountMiddleName + _salesGeneralReportList[i].accountLastName + _salesGeneralReportList[i].accountNameSuffix + '\n' + _salesGeneralReportList[i].accountMobileCountryCode + _salesGeneralReportList[i].accountMobile + '\n' + _salesGeneralReportList[i].accountEmail),
  //           xl.ExcelDataCell(columnHeader: 'Sub Total', value: _salesGeneralReportList[i].grossAmount),
  //           xl.ExcelDataCell(columnHeader: 'Discount', value: _salesGeneralReportList[i].discountAmount),
  //           xl.ExcelDataCell(columnHeader: 'Tax', value: _salesGeneralReportList[i].taxAmount),
  //           xl.ExcelDataCell(columnHeader: 'Total', value: _salesGeneralReportList[i].netAmount),
  //           xl.ExcelDataCell(columnHeader: 'Invoice Date', value: _salesGeneralReportList[i].invoiceDate),
  //           xl.ExcelDataCell(columnHeader: 'Delivery Date', value: _salesGeneralReportList[i].deliveryDate),
  //           xl.ExcelDataCell(columnHeader: 'Payment Paid', value: _salesGeneralReportList[i].paymentDone),
  //           xl.ExcelDataCell(columnHeader: 'Payment Pending', value: _salesGeneralReportList[i].paymentPending),
  //           xl.ExcelDataCell(columnHeader: 'Invoice Status', value: _salesGeneralReportList[i].status),
  //         ],
  //       ),
  //     );
  //   }
  //   return _dataRowList;
  // }

final List<IconData> menuItems = <IconData>[
    Icons.menu,
    Icons.print,
    Icons.share,
    // Icons.download,
    // MdiIcons.fileExcel,
  ];

}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({this.menuAnimation}) : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = context.childCount - 1; i >= 0; i--) {
      double dx = (context.getChildSize(i).height + 10) * i;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(dx * menuAnimation.value + 10, 0, 0),
      );
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(double.infinity, double.infinity);
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return i == 0 ? constraints : BoxConstraints.tight(const Size(55.0, 55.0));
  }
}
