// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:accounting_app/screens/taxAddScreen.dart';
import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TaxScreen extends BaseRoute {
  TaxScreen({@required a, @required o}) : super(a: a, o: o, r: 'TaxScreen');
  @override
  _TaxScreenState createState() => _TaxScreenState();
}

class _TaxScreenState extends BaseRouteState {
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<TaxMaster> _taxMasterList = [];

  _TaxScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(global.appLocaleValues['tle_taxes'],style: Theme.of(context).appBarTheme.titleTextStyle,),
       
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width - 90,
        child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
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
          child: (_taxMasterList.isNotEmpty)
              ? Scrollbar(
                  child: ListView.builder(
                      itemCount: _taxMasterList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          key: ValueKey(index),
                          child: ListTile(
                              contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
                              key: ValueKey('value$index'),
                              title: Text('${_taxMasterList[index].taxName}', style: Theme.of(context).primaryTextTheme.subtitle1,),
                              subtitle: Text('${_taxMasterList[index].percentage.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%', style: Theme.of(context).primaryTextTheme.subtitle2),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TaxAddScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                          taxMaster: _taxMasterList[index],
                                        )));
                              },
                              trailing: PopupMenuButton(
                                icon: Icon(Icons.more_vert, color: Theme.of(context).primaryColor,),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.edit,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          Text(global.appLocaleValues['lbl_edit']),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => TaxAddScreen(
                                                  a: widget.analytics,
                                                  o: widget.observer,
                                                  taxMaster: _taxMasterList[index],
                                                )));
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        );
                      }),
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      MdiIcons.percent,
                      color: Colors.grey,
                      size: 180,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: Text(
                        global.appLocaleValues['tle_taxes_empty'],
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    )
                  ],
                )),
        ),
      ),
    );
  }

  Future refreshData() async {
    await getData();
    setState(() {});
  }

  Future getData() async {
    _taxMasterList = await dbHelper.taxMasterGetList();
    setState(() {});
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }
}
