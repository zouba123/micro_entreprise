// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/unitCombinationModel.dart';
import 'package:flutter/material.dart';

class UnitCombinationSelectDialog extends Base {
  final List<UnitCombination> unitCombinationList;
  UnitCombinationSelectDialog({@required a, @required o, @required this.unitCombinationList}) : super(analytics: a, observer: o);
  @override
  _UnitCombinationSelectDialogState createState() => _UnitCombinationSelectDialogState(this.unitCombinationList);
}

class _UnitCombinationSelectDialogState extends BaseState {
  List<UnitCombination> unitCombinationList;

  _UnitCombinationSelectDialogState(this.unitCombinationList) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(global.appLocaleValues['tle_select_unit_com']),
         
        ),
        body: Column(
          children: <Widget>[
            (unitCombinationList.length > 0)
                ? Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: unitCombinationList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text((unitCombinationList[index].secondaryUnit != null) ? '${unitCombinationList[index].primaryUnit} / ${unitCombinationList[index].secondaryUnit}' : '${unitCombinationList[index].primaryUnit}'),
                                subtitle: Text((unitCombinationList[index].secondaryUnitCode != null) ?'${unitCombinationList[index].primaryUnitCode} / ${unitCombinationList[index].secondaryUnitCode}' : '${unitCombinationList[index].primaryUnitCode}'),
                                onTap: () {
                                  unitCombinationList.map((e) => e.isSelected =false).toList();
                                  unitCombinationList[index].isSelected = true;
                                  Navigator.of(context).pop(unitCombinationList);
                                  //   getAccounts();
                                },
                              ),
                              ((unitCombinationList.length - 1) != index) ? Divider() : SizedBox()
                            ],
                          );
                        },
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      global.appLocaleValues['txt_no_com_found'],
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
