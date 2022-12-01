// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'dart:async';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/businessRule.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/productSearchModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/productAddScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductScreen extends BaseRoute {
  ProductScreen({@required a, @required o}) : super(a: a, o: o, r: 'ProductScreen');
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends BaseRouteState {
  List<Product> _productList = [];
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  int _startIndex = 0;
  ProductSearch _productSearch =  ProductSearch();

  int filterCount = 0;
  bool _isDataLoaded = false;
  bool _isLoaderHide = false;
  bool _isRecordPending = true;

  _ProductScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_products'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_services'] : global.appLocaleValues['tle_both']}',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.search),
            //   iconSize: 25,
            //   color: Colors.white,
            //   onPressed: () async {
            //     await _searchProducts();
            //   },
            // ),
            IconButton(
                icon: Icon(MdiIcons.filter), // required
                onPressed: () async {
                  await _searchProducts();
                }),
            IconButton(
              icon: Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductAddSreen(
                              a: widget.analytics,
                              o: widget.observer,
                              product:  Product(),
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
                ? (_productList.isNotEmpty)
                    ? Scrollbar(
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          itemCount: _productList.length + 1,
                          itemBuilder: (context, index) {
                            if (_productList.length == index) {
                              return (!_isLoaderHide)
                                  ? Center(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : SizedBox();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                              child: Card(
                                  shape: Border(
                                      left: BorderSide(
                                    color: Colors.yellow,
                                    width: 5,
                                  )),
                                  child: ListTile(
                                      contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
                                      leading: CircleAvatar(
                                        backgroundColor: Theme.of(context).primaryColorDark,
                                        radius: 25,
                                        child: (_productList[index].imagePath.isNotEmpty)
                                            ? ClipOval(
                                                child: Image.file(File(_productList[index].imagePath)),
                                              )
                                            : Text('${_productList[index].name.substring(0, 1)}', style: Theme.of(context).primaryTextTheme.headline2),
                                      ),
                                      title: Text(
                                        (br.getSystemFlagValue(global.systemFlagNameList.useProductSupplierCode) == 'true' && _productList[index].supplierProductCode != '') ? '${_productList[index].supplierProductCode} - ${_productList[index].name}' : '${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + _productList[index].productCode.toString().length))}${_productList[index].productCode} - ${_productList[index].name}',
                                        style: Theme.of(context).primaryTextTheme.subtitle1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Row(
                                        children: <Widget>[
                                          Text(
                                            (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") ? '${_productList[index].productTypeName}  \n${global.currency.symbol} ${_productList[index].productPriceList[0].price.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} / ${_productList[index].productPriceList[0].unitCode}' : '${_productList[index].productTypeName}  \n${global.currency.symbol} ${_productList[index].productPriceList[0].price.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                            style: Theme.of(context).primaryTextTheme.subtitle2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ProductAddSreen(
                                                      a: widget.analytics,
                                                      o: widget.observer,
                                                      product: _productList[index],
                                                      screenId: 0,
                                                    )));
                                      },
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.2,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                (_productList[index].isActive == false)
                                                    ? Text(
                                                        ' ${global.appLocaleValues['lbl_inactive']}',
                                                        textAlign: TextAlign.end,
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton(
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: Theme.of(context).primaryColor,
                                            ),
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
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => ProductAddSreen(
                                                                  a: widget.analytics,
                                                                  o: widget.observer,
                                                                  product: _productList[index],
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
                                                    await _deleteProduct(index);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ))),
                            );
                          },
                        ),
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
                              (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product')
                                  ? global.appLocaleValues['tle_product_empty']
                                  : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service')
                                      ? global.appLocaleValues['tle_service_empty']
                                      : global.appLocaleValues['tle_both_empty'],
                              style: TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          )
                        ],
                      ))
                : Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_lazyLoading);
  }

  @override
  void initState() {
    super.initState();
    _init();
    _scrollController.addListener(_lazyLoading);
  }

  _init() async{
    try {
     await _getDetails(false);
      _isDataLoaded = true;
    } catch (e) {
      print('Exception - productScreen.dart - _init(): ' + e.toString());
    }
  }

  Future _deleteProduct(index) async {
    try {
      AlertDialog _dialog =  AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
            (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product')
                ? global.appLocaleValues['tle_product_dlt']
                : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service')
                    ? global.appLocaleValues['tle_service_dlt']
                    : global.appLocaleValues['tle_both_dlt'],
            style: Theme.of(context).primaryTextTheme.headline1),
        content: (global.appLanguage['name'] == 'English') ? Text('${global.appLocaleValues['txt_delete']} "${_productList[index].name}" ?', style: Theme.of(context).primaryTextTheme.headline3) : Text('"${_productList[index].name}" ${global.appLocaleValues['txt_delete']} ?', style: Theme.of(context).primaryTextTheme.headline3),
        actions: <Widget>[
          TextButton(
            child: Text(global.appLocaleValues['btn_cancel'], style: Theme.of(context).primaryTextTheme.headline3),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
              child: Text(global.appLocaleValues['btn_delete'], style: Theme.of(context).primaryTextTheme.headline2),
              onPressed: () async {
                Navigator.of(context).pop();
                int _count = await dbHelper.productExistInInvoice(productId: _productList[index].id);
                if (_count == 0) {
                  await dbHelper.productPriceDelete(productId: _productList[index].id);
                  int _result = await dbHelper.productDelete(_productList[index].id);
                  if (_result == 1) {
                    await dbHelper.productTaxDelete([_productList[index].id]);
                    await _refreshData(isReset: false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product_dlt_success'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service_dlt_success'] : global.appLocaleValues['tle_both_dlt_success']}'),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product_dlt_fail'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service_dlt_fail'] : global.appLocaleValues['tle_both_dlt_fail']}'),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product_dlt_failed'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service_dlt_failed'] : global.appLocaleValues['tle_both_dlt_failed']}'),
                  ));
                }
              }),
        ],
      );
      showDialog(builder: (context) => _dialog, context: context);
    } catch (e) {
      print('Exception - productScreen.dart - _deleteProduct(): ' + e.toString());
    }
  }

  Future _getDetails(bool _isResetAction) async {
    try {
      if (_isResetAction) {
        _startIndex = 0;
        _productList = [];
        setState(() {});
      }
      if (_isRecordPending) {
        if (_productList.length != null && _productList.length > 0) {
          _startIndex = _productList.length;
        } else {
          _productList = [];
        }
        _productList += await dbHelper.productGetList(startIndex: _startIndex, fetchRecords: global.fetchRecords, searchString: _productSearch.searchBar, productCodePrefix: br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix), productCodePrefixLen: br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength));
        for (int i = _startIndex; i < _productList.length; i++) {
          _productList[i].productPriceList = await dbHelper.productPriceGetList(_productList[i].id);
        }
        _startIndex += global.fetchRecords;
        setState(() {
          (_productList.length.isFinite) ? _isLoaderHide = true : _isLoaderHide = false;
        });
      }
    } catch (e) {
      print('Exception - productScreen.dart - _getDetails(): ' + e.toString());
    }
  }

  Future _lazyLoading() async {
    try {
      int _dataLen = _productList.length;
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        await _getDetails(false);

        if (_dataLen == _productList.length) {
          setState(() {
            _isLoaderHide = true;
          });
        }
      }
    } catch (e) {
      print('Exception - productScreen.dart - _lazyLoading(): ' + e.toString());
    }
  }

  Future _refreshData({bool isReset}) async {
    try {
      _startIndex = 0;
      _productList.clear();
      await _getDetails(true);
      _isLoaderHide = false;
      _scrollController.position.jumpTo(1);
      setState(() {});
    } catch (e) {
      print('Exception - productScreen.dart - _refreshData(): ' + e.toString());
    }
  }

  Future _searchProducts() async {
    try {
      Navigator.of(context)
          .push(ProductFilter(
        _productSearch,
      ))
          .then((value) async {
        if (value != null) {
          _productSearch = value;
          _productList.clear();
          if (_productSearch.isSearch != null || _productSearch.isSearch) {
            _isDataLoaded = false;
            setState(() {});
            await _getDetails(true);
            _isDataLoaded = true;
            setState(() {});
          }
        }
      });
    } catch (e) {
      print('Exception - productScreen.dart - _searchProducts(): ' + e.toString());
    }
  }
}

class ProductFilter extends ModalRoute<ProductSearch> {
  ProductSearch productSearch;
  ProductFilter(this.productSearch);

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
    return EmployeeFilterForm(
        productSearch: productSearch,
        searchValue: (obj) {
          productSearch = obj;
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

class EmployeeFilterForm extends StatefulWidget {
  final ProductSearch productSearch;
  final ValueChanged<ProductSearch> searchValue;
  EmployeeFilterForm({
    this.productSearch,
    this.searchValue,
  });
  @override
  _EventFilterFormState createState() => _EventFilterFormState(
        productSearch,
        searchValue,
      );
}

class _EventFilterFormState extends State<EmployeeFilterForm> {
  ProductSearch productSearch;
  final ValueChanged<ProductSearch> searchValue;
  BusinessRule br =  BusinessRule();
  _EventFilterFormState(this.productSearch, this.searchValue);

  bool isText = false; //search text avalaibal or not.
  bool isReset = true;

  var _cSearchBar = TextEditingController();

  ProductSearch eSearch =  ProductSearch();

  void resetFilter() {
    resetConfermation();
  }

  void assignValue() {
    if (productSearch != null) {
      _cSearchBar.text = (productSearch.searchBar.isNotEmpty) ? productSearch.searchBar : '';
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (productSearch != null && productSearch.searchBar != null) {
      assignValue();
    } else {}
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
          height: 56.0,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        MdiIcons.filter,
                        color: Colors.white,
                        size: 26.0,
                      ),
                      SizedBox(
                        width: 31.0,
                      ),
                      Text(
                          (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product')
                              ? global.appLocaleValues['lbl_search_product']
                              : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service')
                                  ? global.appLocaleValues['lbl_search_service']
                                  : global.appLocaleValues['lbl_search_both'],
                          style: Theme.of(context).appBarTheme.titleTextStyle),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
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
                          Text('${global.appLocaleValues['btn_reset']}', style: Theme.of(context).primaryTextTheme.headline2),
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _cSearchBar,
                        decoration: InputDecoration(hintText: global.appLocaleValues['lbl_search_here'], border: nativeTheme().inputDecorationTheme.border, prefixIcon: Icon(Icons.search)),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
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
                          width: 3.0,
                        ),
                        Text('${global.appLocaleValues['btn_cancel']}', style: Theme.of(context).primaryTextTheme.headline3)
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
                      eSearch.isSearch = true;
                      eSearch.searchBar = _cSearchBar.text;
                      searchValue(eSearch);
                      Navigator.pop(context, eSearch);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          '${global.appLocaleValues['btn_search']}',
                          style: Theme.of(context).primaryTextTheme.headline2,
                          textAlign: TextAlign.center,
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

  Future<void> resetConfermation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${global.appLocaleValues['lbl_reset']}', style: Theme.of(context).primaryTextTheme.headline1),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${global.appLocaleValues['txt_filter']}', style: Theme.of(context).primaryTextTheme.headline3),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('${global.appLocaleValues['btn_cancel']}', style: Theme.of(context).primaryTextTheme.headline3),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('${global.appLocaleValues['btn_ok']}', style: Theme.of(context).primaryTextTheme.headline2),
              onPressed: () {
                setState(() {
                  isReset = false;
                  eSearch.isSearch = true;
                  eSearch.searchBar = null;
                  Navigator.of(context).pop();
                  Navigator.pop(context, eSearch);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
