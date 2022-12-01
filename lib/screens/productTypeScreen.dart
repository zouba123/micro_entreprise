// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/productTypeModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:accounting_app/screens/productTypeAddScreen.dart';

import 'package:flutter/material.dart';

import 'package:accounting_app/models/businessLayer/global.dart' as global;

class ProductTypeScreen extends BaseRoute {
  ProductTypeScreen({@required a, @required o}) : super(a: a, o: o, r: 'ProductTypeScreen');

  @override
  _ProductTypeScreenState createState() => _ProductTypeScreenState();
}

class _ProductTypeScreenState extends BaseRouteState {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  List<ProductType> _productTypesList = [];
  bool _isDataLoaded = false;

  _ProductTypeScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text('${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product_cat'] :(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service_cat']: global.appLocaleValues['tle_both_cat']}',style: Theme.of(context).appBarTheme.titleTextStyle,),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  ProductTypeAddSreen(
                            a: widget.analytics,
                            o: widget.observer,
                            screenId: 0,
                          )));
                },
              )
            ],
          
         
        ),
       
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width - 90,
          child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
        ),
        body: RefreshIndicator(
          onRefresh: _getData,
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
                ? (_productTypesList.length > 0)
                    ? ListView.builder(
                        itemCount: _productTypesList.length,
                        itemBuilder: (context, index) {
                          return (_productTypesList[index].name != 'General')
                              ? Card(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
                                    title: Text(_productTypesList[index].name),
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => ProductTypeAddSreen(
                                                a: widget.analytics,
                                                o: widget.observer,
                                                productType: _productTypesList[index],
                                                screenId: 0,
                                              )));
                                    },
                                    trailing: PopupMenuButton(
                                      icon: Icon(Icons.more_vert,color: Theme.of(context).primaryColor,),
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
                                                  builder: (context) => ProductTypeAddSreen(
                                                        a: widget.analytics,
                                                        o: widget.observer,
                                                        productType: _productTypesList[index],
                                                        screenId: 0,
                                                      )));
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
                                                    Icons.delete,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                                Text(global.appLocaleValues['lbl_delete']),
                                              ],
                                            ),
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              await deleteProductType(index);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox();
                        },
                      )
                    : Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.local_mall,
                            color: Colors.grey,
                            size: 180,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FittedBox(
                            child: Text(
                              '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product_cat_empty'] :(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service_cat_empty']: global.appLocaleValues['tle_both_cat_empty']}',
                              style: TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          )
                        ],
                      ))
                : Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2
                    ),
                  ),
          ),
        ));
  }

  Future deleteProductType(index) async {
    try {
      AlertDialog _dialog =  AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product_cat_dlt'] :(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service_cat_dlt']: global.appLocaleValues['tle_both_cat_dlt']}',
         style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width / 5,
          child: Column(
            children: <Widget>[
              Flexible(
                  child: (global.appLanguage['name'] == 'English')
                      ? Text(
                          '${global.appLocaleValues['txt_delete']} "${_productTypesList[index].name}" ?',
                           style: Theme.of(context).primaryTextTheme.headline3,
                          textAlign: TextAlign.left,
                        )
                      : Text(
                          '"${_productTypesList[index].name}" ${global.appLocaleValues['txt_delete']} ?',
                         style: Theme.of(context).primaryTextTheme.headline3,
                          textAlign: TextAlign.left,
                        )),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            // textColor: Theme.of(context).primaryColor,
            child: Text(global.appLocaleValues['btn_cancel'],style: Theme.of(context).primaryTextTheme.headline3,),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_delete'], style: Theme.of(context).primaryTextTheme.headline2,),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              int _productTypeIsUsed = await dbHelper.productTypeIsUsed(_productTypesList[index].id);
              if (_productTypeIsUsed == 0) {
                int _result = await dbHelper.productTypeDelete(productTypeId: _productTypesList[index].id);
                if (_result == 1) {
                  await dbHelper.productTypeTaxDelete(_productTypesList[index].id);
                  _getData();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product_cat_dlt_success'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ?global.appLocaleValues['tle_service_cat_dlt_success']: global.appLocaleValues['tle_both_cat_dlt_success']}'),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product_cat_dlt_fail'] :(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service_cat_dlt_fail']: global.appLocaleValues['tle_both_cat_dlt_fail']}'),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product_cat_dlt_failed'] :(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service_cat_dlt_failed']: global.appLocaleValues['tle_both_cat_dlt_failed']}'),
                ));
              }
            },
          ),
        ],
      );
      showDialog(builder: (context) => _dialog, context: context);
    } catch (e) {
      print('Exception - productTypeScreen.dart - deleteProductType(): ' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      _productTypesList = await dbHelper.productTypeGetList(isActive: true);
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - productTypeScreen.dart - _getData(): ' + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
