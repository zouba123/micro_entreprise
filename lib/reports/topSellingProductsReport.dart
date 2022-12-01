// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/businessLayer/baseroute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/topSellingProductReportFilterModel.dart';
import 'package:accounting_app/models/topSellingProductReportModel.dart';
import 'package:accounting_app/reports/topSellingProductReportFilterScreen.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TopSellingProductsReport extends BaseRoute {
  final TopSellingProductReportFilterModel filter;
  TopSellingProductsReport({@required a, @required o, @required this.filter}) : super(a: a, o: o, r: 'TopSellingProductsReport');
  @override
  _TopSellingProductsReportState createState() => _TopSellingProductsReportState(this.filter);
}

class _TopSellingProductsReportState extends BaseRouteState {
  final TopSellingProductReportFilterModel filter;
  bool _isDataLoaded = false;
  List<TopSellingProductReportModel> _topSellingProductsReportList = [];
  TopSellingProductReportFilterModel _topSellingProductsReportFilter =  TopSellingProductReportFilterModel();
  var _html;
  String encodedHtmlContent;
  IconData lastTapped = Icons.notifications;
  AnimationController menuAnimation;

  Widget progressPrivacy =  Center(
    child: Container(
      child: CircularProgressIndicator(
        backgroundColor: Color(0xFFbc9307),
        valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFFbc9307)),
        strokeWidth: 2,
      ),
    ),
  );

  _TopSellingProductsReportState(this.filter) : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          _checkBackPress();
          return null;
        },
        child: Scaffold(
            // // backgroundColor: Colors.yellow,
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
                '${global.appLocaleValues['top_sel_pro_rep']}',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              actions: [
                IconButton(
                    icon: Icon(MdiIcons.filter),
                    onPressed: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TopSellingProductReportFilterScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    appliedFilter: _topSellingProductsReportFilter,
                                  )));
                    }),
              ],
            ),
            body: (_isDataLoaded)
                ? (_topSellingProductsReportList != null)
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
                              '${global.appLocaleValues['data_not_found']}',
                              style: TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          )
                        ],
                      ))
                : Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )));
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    try {
      if (filter != null) {
        _topSellingProductsReportFilter = filter;
      }
      menuAnimation = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );
      await _getData();
      await _buildHtml();
      encodedHtmlContent = base64Encode(const Utf8Encoder().convert(_html));
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - TopSellingProductsReport.dart - _init(): ' + e.toString());
    }
  }

  Future _getData() async {
    try {
      _topSellingProductsReportList = await dbHelper.getTopSellingProductReportData(_topSellingProductsReportFilter);
      print('');
    } catch (e) {
      print('Exception - TopSellingProductsReport.dart - _getData(): ' + e.toString());
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
      _html += """ <h1 align=center><font size=6>${global.appLocaleValues['top_sel_pro_rep']}</font></h1> <br>
                      <table style='width:100%'>
    <tr>
    <th>#</th>
    <th>${global.appLocaleValues['lbl_product_code']}</th>
    <th>${global.appLocaleValues['pro_name']}</th>
    <th>${global.appLocaleValues['pro_type']}</th>
    <th>${global.appLocaleValues['hsn_code']}</th>
    <th>${global.appLocaleValues['tot_sold_qty']}</th>
    <th>${global.appLocaleValues['tot_sold_amt']}</th>
    </tr>
   """;

      for (int i = 0; i < _topSellingProductsReportList.length; i++) {
        _html += """ <tr>
     <td>${i + 1}</td>
    <td>${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + _topSellingProductsReportList[i].productCode.toString().length))}${_topSellingProductsReportList[i].productCode}</td>
     <td>${_topSellingProductsReportList[i].productName}</td>
     <td>${_topSellingProductsReportList[i].productTypeName}</td>
     <td>${_topSellingProductsReportList[i].productHsnCode}</td>
     <td>${_topSellingProductsReportList[i].totalSoldQty}</td>
     <td>${global.currency.symbol} ${_topSellingProductsReportList[i].totalSoldAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
     </tr>""";
      }

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
      print('Exception - TopSellingProductsReport.dart - _buildHtml(): ' + e.toString());
    }
  }

  final List<IconData> menuItems = <IconData>[
    Icons.menu,
    Icons.print,
    Icons.share,
    // Icons.download,
    // MdiIcons.fileExcel,
  ];

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
    //  else if (icon == Icons.download) {
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
          }
          // else if (lastTapped == Icons.print) {
          //   global.isAppOperation = true;
          //   await br.printReport(_html);
          // }
          else if (lastTapped == Icons.share) {
            global.isAppOperation = true;
            await br.shareReport(_html, 'TopSellingProductsReport.pdf');
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
