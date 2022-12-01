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
import 'package:accounting_app/models/exportAccountFilterModel.dart';
import 'package:accounting_app/reports/exportAccountReportFilterScreen.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ExportAccountReport extends BaseRoute {
  final ExportAccountFilterModel filter;
  ExportAccountReport({@required a, @required o, @required this.filter}) : super(a: a, o: o, r: 'ExportAccountReport');
  @override
  _ExportAccountReportState createState() => _ExportAccountReportState(this.filter);
}

class _ExportAccountReportState extends BaseRouteState {
  final ExportAccountFilterModel filter;
  List<Account> _exportAccountReportList = [];
  ExportAccountFilterModel _exportAccountFilter =  ExportAccountFilterModel();
  bool downloading = false;
  String progress = '0';
  bool isDownloaded = false;
  String filename = 'test.pdf';
  bool _isDataLoaded = false;
  var _html;
  String encodedHtmlContent;
  AnimationController menuAnimation;
  IconData lastTapped = Icons.notifications;

  _ExportAccountReportState(this.filter) : super();

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
                global.appLocaleValues['tle_export_acct_report'],
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              actions: [
                IconButton(
                    icon: Icon(MdiIcons.filter),
                    onPressed: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExportAccountReportFilterScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    appliedFilter: _exportAccountFilter, 
                                  )));
                    }),
              ],
            ),
            body: (_isDataLoaded)
                ? (_exportAccountReportList != null && _exportAccountReportList.length > 0)
                    ? Stack(children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.79,
                          child:InAppWebView(
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
                            Icons.assessment,
                            color: Colors.grey,
                            size: 180,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FittedBox(
                            child: Text(
                              '${global.appLocaleValues['no_rcd_fnd']}',
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
       if (filter != null) {
         _exportAccountFilter = filter;
       }
      await _getData();
      encodedHtmlContent = base64Encode(const Utf8Encoder().convert(_html));
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - ExportAccountReport.dart - _init(): ' + e.toString());
    }
  }

  Future _getData() async {
    try {
      _exportAccountReportList = await dbHelper.getExportAccountReportData(_exportAccountFilter);

      await _buildHtml();
    } catch (e) {
      print('Exception - ExportAccountReport.dart - _getData(): ' + e.toString());
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

      _html += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_export_acct_report']}</font></h1> <br>
                      <table style='width:100%'>
    <tr>
  
    <th><span style="display: flex;
    align-items: center;
    justify-content: center;">#</span></th>
   
   
    <th><span style="display: flex;
    align-items: center;
    justify-content: center;">${global.appLocaleValues['ac_code']}</span></th>
    
    
    <th><span style="display: flex;
    align-items: center;
    justify-content: center;">${global.appLocaleValues['lbl_name']}</span></th>
   
   
    <th><span style="display: flex;
    align-items: center;
    justify-content: center;">${global.appLocaleValues['buss_name']}</span></th>
   
    <th><span style="display: flex;
    align-items: center;
    justify-content: center;">${global.appLocaleValues['con_det']}</span></th>

    <th><span style="display: flex;
    align-items: center;
    justify-content: center;">${global.appLocaleValues['tle_reg_on']}</span></th>
   
   
    <th><span style="display: flex;
    align-items: center;
    justify-content: center;">${global.appLocaleValues['txt_address']}</span></th>
        </tr>
   """;

      for (int i = 0; i < _exportAccountReportList.length; i++) {
        String _accountName = br.generateAccountName(_exportAccountReportList[i]);

        String _contactDetails;
        if (_exportAccountReportList[i].mobile.isNotEmpty) {
          _contactDetails = '+${_exportAccountReportList[i].mobileCountryCode}${_exportAccountReportList[i].mobile}';
        }

        if (_exportAccountReportList[i].email.isNotEmpty) {
          _contactDetails += '<br> ${_exportAccountReportList[i].email}';
        }

        _html += """ <tr>
     <td>${i + 1}</td>
     <td>${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _exportAccountReportList[i].accountCode.toString().length))}${_exportAccountReportList[i].accountCode}</td>
     <td>$_accountName</td>
     <td>${_exportAccountReportList[i].businessName}</td>
     <td>$_contactDetails</td>
      <td>${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_exportAccountReportList[i].createdAt)}</td>
     <td>${br.generateAccountAddress(_exportAccountReportList[i])}</td>
    
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
      print('Exception - ExportAccountReport.dart - _buildHtml(): ' + e.toString());
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
            String fileName = 'ExportAccountReport.pdf';
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
