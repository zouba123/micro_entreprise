// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/unitModel.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';

class SelectUnitDialog extends Base {
  final List<Unit> unitList;

  SelectUnitDialog({@required a, @required o, @required this.unitList}) : super(analytics: a, observer: o);
  @override
  _SelectUnitDialogState createState() => _SelectUnitDialogState(this.unitList);
}

class _SelectUnitDialogState extends BaseState {
  List<Unit> unitList;
  _SelectUnitDialogState(this.unitList) : super();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        content: ListView.builder(
          itemCount: unitList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('${unitList[index].code}'),
                  onTap: () {
                    unitList.map((e) => e.isSelected = false).toList();
                    unitList[index].isSelected = true;
                    Navigator.of(context).pop(unitList);
                    //   getAccounts();
                  },
                ),
                ((unitList.length - 1) != index) ? Divider() : SizedBox()
              ],
            );
          },
        ),
        // actions: <Widget>[
        //   TextButton(
        //     textColor: Colors.blue,
        //     child: Text(global.appLocaleValues['btn_cancel']),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        //   TextButton(
        //     textColor: Colors.blue,
        //     child: Text(global.appLocaleValues['btn_add']),
        //     onPressed: () {
        //       if (_formKey.currentState.validate()) {
        //         _taxMaster.taxName = _cTaxName.text.trim();
        //         _taxMaster.percentage = double.parse(_cPercentage.text.trim());
        //         _taxMaster.applyOrder = applyOrder;
        //         _taxMaster.description = _cDescription.text.trim();
        //         _taxMaster.isApplyOnProduct = _isApplyOnProduct;
        //         _taxMaster.isActive = _isActive;
        //         addTax(_taxMaster);
        //         Navigator.of(context).pop();
        //       }
        //     },
        //   ),
        // ],
      ),
    );
  }

  // Future _fillData() async {
  //   try {
  //    // _cTaxName.text = (taxMaster.taxName != null) ? taxMaster.taxName : '';
  //      _isApplyOnProduct = isTaxProductWiseEnabled;
  //   //  _cPercentage.text = (taxMaster.percentage != null) ? taxMaster.percentage.toString() : '';
  //   //  _cDescription.text = (taxMaster.description != null) ? taxMaster.description.toString() : '';
  //     setState(() {});
  //   } catch (e) {
  //     print('Exception - SelectUnitDialog.dart - _fillData(): ' + e.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();

    //  _fillData();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
