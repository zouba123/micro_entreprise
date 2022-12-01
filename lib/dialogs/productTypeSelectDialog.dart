// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/productTypeModel.dart';
import 'package:accounting_app/screens/productTypeAddScreen.dart';
import 'package:flutter/material.dart';

class ProductTypeSelectDialog extends Base {
  final ValueChanged<ProductType> selectedProductType;
  ProductTypeSelectDialog({@required a, @required o, @required this.selectedProductType}) : super(analytics: a, observer: o);

  @override
  _ProductTypeSelectDialogState createState() => _ProductTypeSelectDialogState(this.selectedProductType);
}

class _ProductTypeSelectDialogState extends BaseState {
  final ValueChanged<ProductType> selectedProductType;
  List<ProductType> _productTypeList = [];
  bool _isDataLoaded = false;

  _ProductTypeSelectDialogState(this.selectedProductType) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_select_pro_cat'] :(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_select_ser_cat'] : global.appLocaleValues['tle_select_both_cat']}', style: Theme.of(context).appBarTheme.titleTextStyle,),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30,
            color: Colors.white,
            onPressed: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (BuildContext context) =>  ProductTypeAddSreen(
                            a: widget.analytics,
                            o: widget.observer,
                            screenId: 1,
                          )))
                  .then((v) {
                setState(() {
                  if (v.id != null) {
                    _productTypeList.add(v);
                  }
                });
              });
            },
          )
        ],
      ),
      body: (_isDataLoaded)
          ? Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.search,
                    onChanged: (value) async {
                      _isDataLoaded = false;
                      _productTypeList = await dbHelper.productTypeGetList(searchString: value);
                      _isDataLoaded = true;
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_search_pro_cat'] :(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['lbl_search_ser_cat']: global.appLocaleValues['lbl_search_both_cat']}',
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                (_productTypeList.length > 0)
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: _productTypeList.length,
                          shrinkWrap: true,
                          //    physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                (index == 0) ? Divider() : SizedBox(),
                                ListTile(
                                  title: Text('${_productTypeList[index].name}',style: Theme.of(context).primaryTextTheme.headline3),
                                  onTap: () {
                                    selectedProductType(_productTypeList[index]);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                  Divider()
                              ],
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text(
                          '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['txt_no_pro_cat_found'] :(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['txt_no_ser_cat_found'] : global.appLocaleValues['txt_no_both_cat_found']}',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                strokeWidth: 2
              ),
            ),
    );
    // return AlertDialog(
    //     shape: nativeTheme().dialogTheme.shape,
    //     title: Text('Select ${br.getSystemFlagValue(global.systemFlagNameList.businessInventory)} Type', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
    //     content: Container(
    //       height: MediaQuery.of(context).size.height * 0.5,
    //       width: MediaQuery.of(context).size.width - 40,
    //       child: Column(
    //         children: <Widget>[
    //           TextButton(
    //             color: Colors.blueGrey[100],
    //             textColor: Colors.blue,
    //             onPressed: () async {
    //               // Navigator.of(context).pop();
    //               Navigator.of(context)
    //                   .push(MaterialPageRoute(
    //                       builder: (BuildContext context) =>  ProductTypeAddSreen(
    //                             a: widget.analytics,
    //                             o: widget.observer,
    //                             screenId: 1,
    //                           )))
    //                   .then((v) {
    //                 setState(() {
    //                   _productTypeList.add(v);
    //                 });
    //               });
    //             },
    //             child: Row(
    //               mainAxisSize: MainAxisSize.min,
    //               children: <Widget>[Icon(Icons.add), Text('ADD NEW ${br.getSystemFlagValue(global.systemFlagNameList.businessInventory).toUpperCase()} TYPE')],
    //             ),
    //           ),
    //           TextFormField(
    //             decoration: InputDecoration(
    //               labelText: 'Search ${br.getSystemFlagValue(global.systemFlagNameList.businessInventory)} Type',
    //               icon: Icon(Icons.search),
    //             ),
    //             onChanged: (value) async {
    //               _isDataLoaded = false;
    //               _productTypeList = await dbHelper.productTypeGetList(searchString: value);
    //               _isDataLoaded = true;
    //               setState(() {});
    //             },
    //           ),
    //           Divider(),
    //         ],
    //       ),
    //     ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getProductTypeData();
  }

  Future _getProductTypeData() async //fetching data from ProductType table
  {
    try {
      _productTypeList = await dbHelper.productTypeGetList(isActive: true);
      print(_productTypeList.length);
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - productTypeScreen.dart - _getProductTypeData(): ' + e.toString());
    }
  }
}
