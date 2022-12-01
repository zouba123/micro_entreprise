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
import 'package:accounting_app/models/salesTaxAndDiscountReportFilterModel.dart';
import 'package:accounting_app/models/salesTaxAndDiscountReportModel.dart';
import 'package:accounting_app/reports/salesTaxAndDiscountReportFilterScreen.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SalesTaxAndDiscountReport extends BaseRoute {
  final SalesTaxAndDiscountReportFilterModel taxAndDiscountReportFilter;
  SalesTaxAndDiscountReport({@required a, @required o, this.taxAndDiscountReportFilter}) : super(a: a, o: o, r: 'SalesTaxAndDiscountReport');
  @override
  _TaxAndDiscountReportState createState() => _TaxAndDiscountReportState(taxAndDiscountReportFilter: taxAndDiscountReportFilter);
}

class _TaxAndDiscountReportState extends BaseRouteState {
  List<SalesTaxAndDiscountReportModel> _taxAndDiscountReportList = [];
  final SalesTaxAndDiscountReportFilterModel taxAndDiscountReportFilter;
  SalesTaxAndDiscountReportFilterModel _taxAndDiscountReportFilter =  SalesTaxAndDiscountReportFilterModel();
  bool downloading = false;
  String progress = '0';
  bool isDownloaded = false;
  String filename = 'test.pdf';
  bool _isDataLoaded = false;
  var _html;
  String encodedHtmlContent;
  AnimationController menuAnimation;
  IconData lastTapped = Icons.notifications;

  _TaxAndDiscountReportState({this.taxAndDiscountReportFilter}) : super();

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
                global.appLocaleValues['tle_Tax_Discount_report'],
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              actions: [
                IconButton(
                    icon: Icon(MdiIcons.filter),
                    onPressed: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalesTaxAndDiscountReportFilterScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    appliedFilter: taxAndDiscountReportFilter,
                                  )));
                    }),
              ],
            ),
            body: (_isDataLoaded)
                ?  Stack(children: [
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
      if (taxAndDiscountReportFilter != null) {
        _taxAndDiscountReportFilter = taxAndDiscountReportFilter;
      }
      await _getData();
      encodedHtmlContent = base64Encode(const Utf8Encoder().convert(_html));
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - SalesTaxAndDiscountReport.dart - _init(): ' + e.toString());
    }
  }

  Future _getData() async {
    try {
      _taxAndDiscountReportList = await dbHelper.getSalesTaxAndDiscountReportData(_taxAndDiscountReportFilter);

      await _buildHtml();
    } catch (e) {
      print('Exception - SalesTaxAndDiscountReport.dart - _getData(): ' + e.toString());
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

      _html += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_Tax_Discount_report']}</font></h1> <br>
                      <table style='width:100%'>
    <tr>
    <th>#</th>
    <th>${global.appLocaleValues['ac_det']}</th>
    <th>${global.appLocaleValues['dis_amt']}</th>
    <th>${global.appLocaleValues['tax_amt']}</th>
    <th>${global.appLocaleValues['ac_reg_date']}</th>
    </tr>
   """;

      for (int i = 0; i < _taxAndDiscountReportList.length; i++) {
        Account _account =  Account();
        _account.namePrefix = _taxAndDiscountReportList[i].accountNamePrefix;
        _account.firstName = _taxAndDiscountReportList[i].accountFirstName;
        _account.middleName = _taxAndDiscountReportList[i].accountMiddleName;
        _account.lastName = _taxAndDiscountReportList[i].accountLastName;
        _account.nameSuffix = _taxAndDiscountReportList[i].accountNameSuffix;

        String _accountDetails = br.generateAccountName(_account);
        if (_taxAndDiscountReportList[i].accountMobile.isNotEmpty) {
          _accountDetails += '<br> +${_taxAndDiscountReportList[i].accountMobileCountryCode}${_taxAndDiscountReportList[i].accountMobile}';
        }

        if (_taxAndDiscountReportList[i].accountEmail.isNotEmpty) {
          _accountDetails += '<br> ${_taxAndDiscountReportList[i].accountEmail}';
        }

        _html += """ <tr>
     <td>${i + 1}</td>
     <td>$_accountDetails</td>
     <td>${global.currency.symbol}${_taxAndDiscountReportList[i].totalDiscountAmount}</td>
     <td>${global.currency.symbol}${_taxAndDiscountReportList[i].totalTaxAmount}</td>
     <td>${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_taxAndDiscountReportList[i].accountRegistrationDate)}</td>
     </tr>""";
      }

      _html += """ <tr>
     <td></td>
     <td></td>
     <td><b>${global.currency.symbol}${_taxAndDiscountReportList.map((e) => e.totalDiscountAmount).reduce((v, e) => e + v).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
     <td><b>${global.currency.symbol}${_taxAndDiscountReportList.map((e) => e.totalTaxAmount).reduce((v, e) => e + v).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
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
      print('Exception - SalesTaxAndDiscountReport.dart - _buildHtml(): ' + e.toString());
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
            String fileName = 'SalesTaxAndDiscountReport.pdf';
            await br.shareReport(_html, fileName);
          }
          // else if (lastTapped == Icons.download) {
          //   global.isAppOperation = true;
          //   await br.printReport(_html);
          // } else if (lastTapped == MdiIcons.fileExcel) {
          //             }
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
