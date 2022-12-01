// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/taxMasterPercentageModel.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';

class SelectTaxPercentageDialog extends Base {
  final List<TaxMasterPercentage> percentageList;

  SelectTaxPercentageDialog({@required a, @required o, @required this.percentageList}) : super(analytics: a, observer: o);
  @override
  SelectTaxPercentageDialogState createState() => SelectTaxPercentageDialogState(this.percentageList);
}

class SelectTaxPercentageDialogState extends BaseState {
  List<TaxMasterPercentage> percentageList;
  SelectTaxPercentageDialogState(this.percentageList) : super();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        content: ListView.builder(
          itemCount: percentageList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('${percentageList[index].percentage}%'),
                  onTap: () {
                    Navigator.of(context).pop(percentageList[index].percentage);
                    //   getAccounts();
                  },
                ),
                ((percentageList.length - 1) != index) ? Divider() : SizedBox()
              ],
            );
          },
        ),
      ),
    );
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
