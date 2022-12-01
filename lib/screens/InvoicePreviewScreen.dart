// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';

class InvoicePreviewScreen extends BaseRoute {
  final htmlContent;
  InvoicePreviewScreen({@required a, @required o, this.htmlContent}) : super(a: a, o: o, r: 'InvoicePreviewScreen');

  @override
  _InvoicePreviewScreenState createState() => _InvoicePreviewScreenState(this.htmlContent);
}

class _InvoicePreviewScreenState extends BaseRouteState {
  final htmlContent;
  String encodedHtmlContent;
  Widget progressPrivacy = Center(
    child: Container(
      child: CircularProgressIndicator(
        backgroundColor: Color(0xff0d46a0),
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0d46a0)),
        strokeWidth: 2,
      ),
    ),
  );

  _InvoicePreviewScreenState(this.htmlContent) : super();

  @override
  Widget build(BuildContext context) => InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse('data:text/html;base64,$encodedHtmlContent')),

        // withJavascript: false,
        // displayZoomControls: true,
        // useWideViewPort: false,
        // withZoom: true,
        // hidden: true,
        // appBar: AppBar(title: Text("Preview", style: Theme.of(context).appBarTheme.titleTextStyle), elevation: 1),
      );

  @override
  void initState() {
    super.initState();
    _encodeHtml();
  }

  void _encodeHtml() {
    encodedHtmlContent = base64Encode(const Utf8Encoder().convert(htmlContent));
  }
}
