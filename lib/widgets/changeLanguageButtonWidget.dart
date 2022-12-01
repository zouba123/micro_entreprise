// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/screens/selectLanguageScreen.dart';
import 'package:flutter/material.dart';

class ChangeLanguageButtonWidget extends Base {
  final bool atTAndCScreen;
  ChangeLanguageButtonWidget({@required a, @required o, this.atTAndCScreen = false}) : super(analytics: a, observer: o);
  @override
  _ChangeLanguageButtonWidgetState createState() => _ChangeLanguageButtonWidgetState(this.atTAndCScreen);
}

class _ChangeLanguageButtonWidgetState extends BaseState {
  final bool atTAndCScreen;
  _ChangeLanguageButtonWidgetState(this.atTAndCScreen);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (atTAndCScreen) ? EdgeInsets.only(right: 4) : EdgeInsets.only(bottom: 3),
      child: FloatingActionButton(
          heroTag: null,
          mini: true,
          elevation: 2,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.translate,
            size: 24,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>  SelectLanguageScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      screenId: 2,
                    )));
          }),
    );
  }
}
