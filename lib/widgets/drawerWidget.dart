// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/accountSearchModel.dart';
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/reports/accountSellerReport.dart';
import 'package:accounting_app/reports/expenseGeneralReport.dart';
import 'package:accounting_app/reports/exportAccountReport.dart';
import 'package:accounting_app/reports/paymentGeneralReport.dart';
import 'package:accounting_app/reports/productGeneralReport.dart';
import 'package:accounting_app/reports/quotesGeneralReport.dart';
import 'package:accounting_app/reports/salesGeneralReport.dart';
import 'package:accounting_app/reports/salesTaxAndDiscountReport.dart';
import 'package:accounting_app/reports/topSellingProductsReport.dart';
import 'package:accounting_app/screens/aboutScreen.dart';
import 'package:accounting_app/screens/accountScreen.dart';
import 'package:accounting_app/screens/attendanceScreen.dart';
import 'package:accounting_app/screens/backupAndRestoreScreen.dart';
import 'package:accounting_app/screens/changeLoginPinScreen.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/employeeSalaryStatementScreen.dart';
import 'package:accounting_app/screens/employeeScreen.dart';
import 'package:accounting_app/screens/expenseCategoryScreen.dart';
import 'package:accounting_app/screens/expenseScreen.dart';
import 'package:accounting_app/screens/otherAppsScreen.dart';
// import 'package:accounting_app/screens/exportAccountScreen.dart';
import 'package:accounting_app/screens/paymentScreen.dart';
import 'package:accounting_app/screens/privacyPolicyScreen.dart';
import 'package:accounting_app/screens/productScreen.dart';
import 'package:accounting_app/screens/productTypeScreen.dart';
import 'package:accounting_app/screens/profileBusinessSettingsScreen.dart';
import 'package:accounting_app/screens/profilePersonalSettingsScreen.dart';
import 'package:accounting_app/screens/purchaseInvoiceReturnScreen.dart';
import 'package:accounting_app/screens/purchaseInvoiceScreen.dart';
import 'package:accounting_app/screens/saleInvoiceReturnScreen.dart';
import 'package:accounting_app/screens/saleInvoiceScreen.dart';
import 'package:accounting_app/screens/saleOrderScreen.dart';
import 'package:accounting_app/screens/salesQuoteScreen.dart';
import 'package:accounting_app/screens/settingsScreen.dart';
import 'package:accounting_app/screens/taxScreen.dart';
import 'package:accounting_app/screens/unitScreen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerWidget extends Base {
  // final String routeName;
  // final FirebaseAnalytics analytics;
  // final FirebaseAnalyticsObserver observer;

  DrawerWidget({
    @required a,
    @required o,
    @required routeName,
  }) : super(analytics: a, observer: o, routeName: routeName);
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends BaseState {
  // final FirebaseAnalytics analytics;
  // final FirebaseAnalyticsObserver observer;
  // final String routeName;

  //var _key = GlobalKey();

  _DrawerWidgetState() : super();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          children: <Widget>[
            // DrawerHeader(
            //   child: Stack(
            //     children: <Widget>[
            //       Center(
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: <Widget>[
            //             CircleAvatar(
            //               minRadius: 60,
            //               backgroundColor: Colors.white,
            //               child: Icon(
            //                 Icons.contacts,
            //                 size: 60,
            //                 color: Colors.lightGreen,
            //               ),
            //             )
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            //   decoration: BoxDecoration(color: Colors.blueGrey),
            // ),
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                      //   child: Container(
                      //     height: 80,
                      //     width: 80,
                      //     decoration: BoxDecoration(borderRadius:  BorderRadius.circular(10.0), color: Colors.white, border:  Border.all(color: Colors.white), image: global.business.logoPath != null ? DecorationImage(image: FileImage(File(global.business.logoPath))) : null),
                      //     child: global.business.logoPath == null
                      //         ? Container(
                      //             height: 80,
                      //             width: 80,
                      //             decoration: BoxDecoration(
                      //               borderRadius:  BorderRadius.circular(10.0),
                      //               border:  Border.all(color: Colors.white),
                      //             ),
                      //             //color: Theme.of(context).primaryColor,
                      //             child: Center(
                      //               child: Text(
                      //                 "${global.business.name[0]}",
                      //                 textAlign: TextAlign.center,
                      //                 style: TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 25),
                      //               ),
                      //             ),
                      //           )
                      //         : SizedBox(),
                      //   ),
                      // ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Text("${global.business.name}", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text("${global.user.firstName} ${global.user.lastName}", style: Theme.of(context).primaryTextTheme.headline3),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                "${global.country.isoCode} ${global.user.mobile}",
                                style: TextStyle(
                                  letterSpacing: 1.0,
                                  fontSize: 15,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  (global.user.email != null && global.user.email.isNotEmpty)
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Chip(
                              backgroundColor: Colors.white,
                              avatar: Icon(
                                MdiIcons.email,
                                color: Theme.of(context).primaryColor,
                                size: 13,
                              ),
                              label: Text(
                                global.user.email,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              curve: Curves.bounceInOut,
            ),

            ListTile(
              leading: Icon(Icons.dashboard, color: widget.routeName == 'DashboardScreen' ? Colors.black : Colors.white),
              title: Text(
                global.appLocaleValues['tle_dashboard'],
                style: widget.routeName == 'DashboardScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                // style: TextStyle(color: widget.routeName == 'DashboardScreen' ? Colors.black : Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => DashboardScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )));
              },
            ),
            ListTile(
              leading: Icon(Icons.people, color: widget.routeName == 'AccountScreen' ? Colors.black : Colors.white),
              title: Text(
                global.appLocaleValues['tle_ac'],
                style: widget.routeName == 'AccountScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
              ),
              onTap: () {
                AccountSearch accountSearch = AccountSearch();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => AccountScreen(
                          redirectToCustomersTab: true,
                          a: widget.analytics,
                          o: widget.observer,
                          accountSearch: accountSearch,
                        )));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.local_mall,
                color: widget.routeName == 'ProductScreen' ? Colors.black : Colors.white,
              ),
              title: Text(
                '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_products'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_services'] : global.appLocaleValues['tle_both']}',
                style: widget.routeName == 'ProductScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ProductScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )));
              },
            ),
            ExpansionTile(
              leading: Icon(
                Icons.shopping_cart,
                color: widget.routeName == 'SalesQuoteScreen' || widget.routeName == 'SaleOrderScreen' || widget.routeName == 'SaleInvoiceScreen' || widget.routeName == 'SaleInvoiceReturnScreen' ? Colors.black : Colors.white,
              ),
              title: Row(
                children: <Widget>[
                  Text(
                    "${global.appLocaleValues['lbl_map_sales']}",
                    style: widget.routeName == 'SalesQuoteScreen' || widget.routeName == 'SaleOrderScreen' || widget.routeName == 'SaleInvoiceScreen' || widget.routeName == 'SaleInvoiceReturnScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                  ),
                ],
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    leading: Icon(
                      Icons.request_quote,
                      color: widget.routeName == 'SalesQuoteScreen' ? Colors.black : Colors.white,
                    ),
                    title: Text(
                      '${global.appLocaleValues['sal_quote']}',
                      style: widget.routeName == 'SalesQuoteScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => SalesQuoteScreen(
                                a: widget.analytics,
                                o: widget.observer,
                              )));
                    },
                  ),
                ),
                (br.getSystemFlagValue(global.systemFlagNameList.enableSaleOrder) == 'true')
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (BuildContext context) => SaleOrderScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                    )));
                          },
                          leading: Icon(
                            Icons.shopping_cart,
                            color: widget.routeName == 'SaleOrderScreen' ? Colors.black : Colors.white,
                          ),
                          title: Text(
                            global.appLocaleValues['tle_sale_orders'],
                            style: widget.routeName == 'SaleOrderScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                          ),
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListTile(
                    leading: Icon(
                      Icons.shopping_cart,
                      color: widget.routeName == 'SaleInvoiceScreen' ? Colors.black : Colors.white,
                    ),
                    title: Text(
                      global.appLocaleValues['tle_sale_invoices'],
                      style: widget.routeName == 'SaleInvoiceScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => SaleInvoiceScreen(
                                a: widget.analytics,
                                o: widget.observer,
                              )));
                    },
                  ),
                ),
                (br.getSystemFlagValue(global.systemFlagNameList.enableSalesReturn) == 'true')
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ListTile(
                          leading: Icon(
                            Icons.shopping_cart,
                            color: widget.routeName == 'SaleInvoiceReturnScreen' ? Colors.black : Colors.white,
                          ),
                          title: Text(
                            global.appLocaleValues['tle_sales_return'],
                            style: widget.routeName == 'SaleInvoiceReturnScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (BuildContext context) => SaleInvoiceReturnScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                    )));
                          },
                        ),
                      )
                    : SizedBox(),
              ],
            ),

            // children: <Widget>[
            //   (br.getSystemFlagValue(global.systemFlagNameList.enableSaleOrder) == 'true')
            //       ? Padding(
            //           padding: const EdgeInsets.only(left: 20),
            //           child: ListTile(
            //             leading: Icon(
            //               Icons.shopping_cart,
            //               color: widget.routeName == 'SaleOrderScreen' ? Colors.black : Colors.white,
            //             ),
            //             title: Text(
            //               global.appLocaleValues['tle_sale_orders'],
            //                 style: widget.routeName == 'SaleOrderScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
            //             ),
            //             onTap: () {
            //               Navigator.of(context).pushReplacement(MaterialPageRoute(
            //                   builder: (BuildContext context) =>  SaleOrderScreen(
            //                         a: widget.analytics,
            //                         o: widget.observer,
            //                       )));
            //             },
            //           ),
            //         )
            //       : SizedBox(),
            //   Padding(
            //     padding: EdgeInsets.only(left: 20),
            //     child: ListTile(
            //       leading: Icon(
            //         Icons.shopping_cart,
            //         color: widget.routeName == 'SaleInvoiceScreen' ? Colors.black : Colors.white,
            //       ),
            //       title: Text(
            //         global.appLocaleValues['tle_sale_invoices'],
            //          style: widget.routeName == 'SaleInvoiceScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
            //       ),
            //       onTap: () {
            //         Navigator.of(context).pushReplacement(MaterialPageRoute(
            //             builder: (BuildContext context) =>  SaleInvoiceScreen(
            //                   a: widget.analytics,
            //                   o: widget.observer,
            //                 )));
            //       },
            //     ),
            //   ),
            //   Padding(
            //     padding: EdgeInsets.only(left: 20),
            //     child: Column(
            //       children: <Widget>[
            //         (br.getSystemFlagValue(global.systemFlagNameList.enableSalesReturn) == 'true')
            //             ? ListTile(
            //                 leading: Icon(
            //                   Icons.shopping_cart,
            //                   color: widget.routeName == 'SaleInvoiceReturnScreen' ? Colors.black : Colors.white,
            //                 ),
            //                 title: Text(
            //                   global.appLocaleValues['tle_sales_return'],
            //                     style: widget.routeName == 'SaleInvoiceReturnScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
            //                 ),
            //                 onTap: () {
            //                   Navigator.of(context).pushReplacement(MaterialPageRoute(
            //                       builder: (BuildContext context) =>  SaleInvoiceReturnScreen(
            //                             a: widget.analytics,
            //                             o: widget.observer,
            //                           )));
            //                 },
            //               )
            //             : SizedBox(),
            //         ListTile(
            //           enabled: false,
            //           trailing: Padding(
            //               padding: const EdgeInsets.only(bottom: 20),
            //               child: Text(
            //                 global.appLocaleValues['tle_coming_soon'],
            //                 style: TextStyle(color: Colors.red, fontSize: 8),
            //               )),
            //           leading: Icon(
            //             Icons.shopping_cart,
            //           ),
            //           title: Text(global.appLocaleValues['tle_sale_quotes']),
            //           onTap: () {},
            //         ),
            //       ],
            //     ),
            //   ),
            // ],

            ListTile(
              leading: Icon(
                Icons.credit_card,
                color: widget.routeName == 'PaymentScreen' ? Colors.black : Colors.white,
              ),
              title: Text(
                global.appLocaleValues['lbl_payments'],
                style: widget.routeName == 'PaymentScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => PaymentScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )));
              },
            ),

            (br.getSystemFlagValue(global.systemFlagNameList.enableEmployee) == 'true')
                ? ExpansionTile(
                    leading: Icon(
                      Icons.people,
                      color: widget.routeName == 'EmployeeScreen' || widget.routeName == 'AttenDanceScreen' ? Colors.black : Colors.white,
                    ),
                    title: Text(
                      global.appLocaleValues['tle_emp'],
                      style: widget.routeName == 'EmployeeScreen' || widget.routeName == 'AttenDanceScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ListTile(
                          leading: Icon(Icons.people, color: widget.routeName == 'EmployeeScreen' ? Colors.black : Colors.white),
                          title: Text(
                            global.appLocaleValues['tle_emp'],
                            style: widget.routeName == 'EmployeeScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                          ),
                          onTap: () {
                            AccountSearch accountSearch = AccountSearch();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (BuildContext context) => EmployeeScreen(
                                      redirectToCustomersTab: true,
                                      a: widget.analytics,
                                      o: widget.observer,
                                      accountSearch: accountSearch,
                                    )));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ListTile(
                          leading: Icon(
                            Icons.compare_arrows,
                            color: widget.routeName == 'AttenDanceScreen' ? Colors.black : Colors.white,
                          ),
                          title: Text(
                            global.appLocaleValues['tle_attendance'],
                            style: widget.routeName == 'AttenDanceScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (BuildContext context) => AttenDanceScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                    )));
                          },
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            ListTile(
              leading: Icon(
                MdiIcons.currencyUsd,
                color: widget.routeName == 'ExpenseScreen' ? Colors.black : Colors.white,
              ),
              title: Text(
                global.appLocaleValues['lbl_expenses'],
                style: widget.routeName == 'ExpenseScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ExpenseScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )));
              },
            ),
            (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true')
                ? ExpansionTile(
                    leading: Icon(
                      Icons.shopping_cart,
                      color: widget.routeName == 'PurchaseInvoiceScreen' || widget.routeName == 'PurchaseInvoiceReturnScreen' ? Colors.black : Colors.white,
                    ),
                    title: Row(
                      children: <Widget>[
                        Text(
                          global.appLocaleValues['tle_purchase'],
                          style: widget.routeName == 'PurchaseInvoiceScreen' || widget.routeName == 'PurchaseInvoiceReturnScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                        ),
                      ],
                    ),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: ListTile(
                          enabled: true,
                          leading: Icon(
                            Icons.shopping_cart,
                            color: widget.routeName == 'PurchaseInvoiceScreen' ? Colors.black : Colors.white,
                          ),
                          title: Text(
                            global.appLocaleValues['tle_purchase_invoice'],
                            style: widget.routeName == 'PurchaseInvoiceScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (BuildContext context) => PurchaseInvoiceScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                    )));
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          children: <Widget>[
                            (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseReturn) == 'true')
                                ? ListTile(
                                    leading: Icon(
                                      Icons.shopping_cart,
                                      color: widget.routeName == 'PurchaseInvoiceReturnScreen' ? Colors.black : Colors.white,
                                    ),
                                    title: Text(
                                      global.appLocaleValues['tle_purchase_return'],
                                      style: widget.routeName == 'PurchaseInvoiceReturnScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                          builder: (BuildContext context) => PurchaseInvoiceReturnScreen(
                                                a: widget.analytics,
                                                o: widget.observer,
                                              )));
                                    },
                                  )
                                : SizedBox(),
                            ListTile(
                              enabled: false,
                              trailing: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    global.appLocaleValues['tle_coming_soon'],
                                    style: TextStyle(color: Colors.green, fontSize: 8),
                                  )),
                              leading: Icon(Icons.shopping_cart),
                              title: Text(global.appLocaleValues['tle_purchase_orders']),
                              onTap: () {},
                            ),
                            ListTile(
                              enabled: false,
                              trailing: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    global.appLocaleValues['tle_coming_soon'],
                                    style: TextStyle(color: Colors.green, fontSize: 8),
                                  )),
                              leading: Icon(Icons.shopping_cart),
                              title: Text(global.appLocaleValues['tle_purchase_quotes']),
                              onTap: () {},
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : SizedBox(),
            ExpansionTile(
              leading: Icon(
                Icons.assessment,
                color: widget.routeName == 'TaxAndDiscountReport' || widget.routeName == 'PaymentGeneralReport' || widget.routeName == 'ExportAccountsScreen' || widget.routeName == 'AccountSellerReport' || widget.routeName == 'ExportAccountReport' ? Colors.black : Colors.white,
              ),
              title: Row(
                children: <Widget>[
                  Text(
                    global.appLocaleValues['tle_reports'],
                    style: widget.routeName == 'TaxAndDiscountReport' || widget.routeName == 'PaymentGeneralReport' || widget.routeName == 'SalesGeneralReport' || widget.routeName == 'AccountSellerReport' || widget.routeName == 'ExportAccountReport'
                        ? Theme.of(context).primaryTextTheme.headline3
                        : Theme.of(context).primaryTextTheme.headline2,
                  ),
                ],
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ListTile(
                    enabled: true,
                    leading: Icon(
                      Icons.assessment,
                      color: widget.routeName == 'SalesGeneralReport' ? Colors.black : Colors.white,
                    ),
                    title: Text(
                      global.appLocaleValues['tle_sales_gen_report'],
                      style: widget.routeName == 'SalesGeneralReport' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      // SalesGeneralReportFilterModel salesGeneralReportFilter =  SalesGeneralReportFilterModel();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => SalesGeneralReport(
                                a: widget.analytics,
                                o: widget.observer,
                              )));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ListTile(
                    enabled: true,
                    leading: Icon(
                      Icons.assessment,
                      color: widget.routeName == 'QuotesGeneralReport' ? Colors.black : Colors.white,
                    ),
                    title: Text(
                      '${global.appLocaleValues['quote_gen_rep']}',
                      style: widget.routeName == 'QuotesGeneralReport' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      // SalesGeneralReportFilterModel salesGeneralReportFilter =  SalesGeneralReportFilterModel();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => QuotesGeneralReport(
                                a: widget.analytics,
                                o: widget.observer,
                                filter: null,
                              )));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ListTile(
                    enabled: true,
                    leading: Icon(
                      Icons.assessment,
                      color: widget.routeName == 'ExpenseGeneralReport' ? Colors.black : Colors.white,
                    ),
                    title: Text(
                      '${global.appLocaleValues['exp_gen_rpt']}',
                      style: widget.routeName == 'ExpenseGeneralReport' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      // SalesGeneralReportFilterModel salesGeneralReportFilter =  SalesGeneralReportFilterModel();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => ExpenseGeneralReport(
                                a: widget.analytics,
                                o: widget.observer,
                                filter: null,
                              )));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        enabled: true,
                        leading: Icon(
                          Icons.assessment,
                          color: widget.routeName == 'AccountSellerReport' ? Colors.black : Colors.white,
                        ),
                        title: Text(
                          '${global.appLocaleValues['ac_seller_rpt']}',
                          style: widget.routeName == 'AccountSellerReport' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => AccountSellerReport(
                                    filter: null,
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )));
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        enabled: true,
                        leading: Icon(
                          Icons.assessment,
                          color: widget.routeName == 'ProductGeneralReport' ? Colors.black : Colors.white,
                        ),
                        title: Text(
                          '${global.appLocaleValues['pro_gen_rep']}',
                          style: widget.routeName == 'ProductGeneralReport' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => ProductGeneralReport(
                                    filter: null,
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )));
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        enabled: true,
                        leading: Icon(
                          Icons.assessment,
                          color: widget.routeName == 'TopSellingProductsReport' ? Colors.black : Colors.white,
                        ),
                        title: Text(
                          '${global.appLocaleValues['top_sel_pro_rep']}',
                          style: widget.routeName == 'TopSellingProductsReport' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => TopSellingProductsReport(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    filter: null,
                                  )));
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ListTile(
                    enabled: true,
                    leading: Icon(
                      Icons.assessment,
                      color: widget.routeName == 'ExportAccountReport' ? Colors.black : Colors.white,
                    ),
                    title: Text(
                      global.appLocaleValues['tle_export_acct_report'],
                      style: widget.routeName == 'ExportAccountReport' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => ExportAccountReport(
                                filter: null,
                                a: widget.analytics,
                                o: widget.observer,
                              )));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ListTile(
                    enabled: true,
                    leading: Icon(
                      Icons.assessment,
                      color: widget.routeName == 'PaymentGeneralReport' ? Colors.black : Colors.white,
                    ),
                    title: Text(
                      global.appLocaleValues['tle_payment_general_report'],
                      style: widget.routeName == 'PaymentGeneralReport' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      // SalesGeneralReportFilterModel salesGeneralReportFilter =  SalesGeneralReportFilterModel();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => PaymentGeneralReport(
                                filter: null,
                                a: widget.analytics,
                                o: widget.observer,
                              )));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ListTile(
                    enabled: true,
                    leading: Icon(
                      Icons.assessment,
                      color: widget.routeName == 'TaxAndDiscountReport' ? Colors.black : Colors.white,
                    ),
                    title: Text(
                      global.appLocaleValues['tle_Tax_Discount_report'],
                      style: widget.routeName == 'TaxAndDiscountReport' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      // SalesGeneralReportFilterModel salesGeneralReportFilter =  SalesGeneralReportFilterModel();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => SalesTaxAndDiscountReport(
                                a: widget.analytics,
                                o: widget.observer,
                                taxAndDiscountReportFilter: null,
                              )));
                    },
                  ),
                ),
                // (br.getSystemFlagValue(global.systemFlagNameList.enableEmployee) == 'true')
                //     ? Padding(
                //         padding: EdgeInsets.only(left: 20),
                //         child: ListTile(
                //           enabled: true,
                //           leading: Icon(
                //             Icons.assessment,
                //             color: widget.routeName == 'EmployeeStatementScreen' ? Theme.of(context).primaryColor : Colors.white,
                //           ),
                //           title: Text(
                //             global.appLocaleValues['tle_emp_statement'],
                //             style: widget.routeName == 'TaxAndDiscountReport' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                //           ),
                //           onTap: () async {
                //             Navigator.of(context).pop();
                //             Navigator.of(context).pushReplacement(MaterialPageRoute(
                //                 builder: (BuildContext context) => EmployeeStatementScreen(
                //                       a: widget.analytics,
                //                       o: widget.observer,
                //                       screenId: 0,
                //                     )));
                //           },
                //         ),
                //       )
                //     : SizedBox(),
                (br.getSystemFlagValue(global.systemFlagNameList.enableEmployee) == 'true')
                    ? Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: ListTile(
                          leading: Icon(
                            Icons.assessment,
                            color: widget.routeName == 'EmployeeSalaryStatementScreen' ? Theme.of(context).primaryColor : Colors.white,
                          ),
                          title: Text(
                            global.appLocaleValues['tle_emp_salary_statement'],
                            style: widget.routeName == 'TaxAndDiscountReport' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (BuildContext context) => EmployeeSalaryStatementScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                    )));
                          },
                        ),
                      )
                    : SizedBox(),
              ],
            ),

            ExpansionTile(
              leading: Icon(
                Icons.person,
                color: widget.routeName == 'ProfilePersonalSettingsScreen' || widget.routeName == 'ProfileBusinessSettingsScreen' ? Colors.black : Colors.white,
              ),
              title: Text(
                '${global.appLocaleValues['tle_profile']}',
                style: widget.routeName == 'ProfilePersonalSettingsScreen' || widget.routeName == 'ProfileBusinessSettingsScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          global.appLocaleValues['tle_personal_profile'],
                          style: widget.routeName == 'ProfilePersonalSettingsScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                        ),
                        leading: Icon(
                          MdiIcons.faceMan,
                          color: widget.routeName == 'ProfilePersonalSettingsScreen' ? Colors.black : Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => ProfilePersonalSettingsScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )));
                        },
                      ),
                      ListTile(
                        title: Text(
                          global.appLocaleValues['tle_business_profile'],
                          style: widget.routeName == 'ProfileBusinessSettingsScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                        ),
                        leading: Icon(
                          Icons.work,
                          color: widget.routeName == 'ProfileBusinessSettingsScreen' ? Colors.black : Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => ProfileBusinessSettingsScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )));
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),

            ListTile(
              title: Text(
                global.appLocaleValues['lbl_setting'],
                style: widget.routeName == 'SettingsScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
              ),
              leading: Icon(
                Icons.settings,
                color: widget.routeName == 'SettingsScreen' ? Colors.black : Colors.white,
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )));
              },
            ),
            ExpansionTile(
              leading: Icon(
                MdiIcons.cogs,
                color: widget.routeName == 'TaxScreen' || widget.routeName == 'ExpenseCategoriesScreen' || widget.routeName == 'ProductTypeScreen' ? Colors.black : Colors.white,
              ),
              title: Text(
                global.appLocaleValues['tle_configuration'],
                style: widget.routeName == 'TaxScreen' || widget.routeName == 'ExpenseCategoriesScreen' || widget.routeName == 'ProductTypeScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    children: <Widget>[
                      (br.getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true")
                          ? ListTile(
                              leading: Icon(
                                Icons.view_list,
                                color: widget.routeName == 'UnitScreen' ? Colors.black : Colors.white,
                              ),
                              title: Text(
                                global.appLocaleValues['tle_units'],
                                style: widget.routeName == 'UnitScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                              ),
                              onTap: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (BuildContext context) => UnitScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                        )));
                              },
                            )
                          : SizedBox(),
                      ListTile(
                        leading: Icon(
                          Icons.local_mall,
                          color: widget.routeName == 'ProductTypeScreen' ? Colors.black : Colors.white,
                        ),
                        title: Text(
                          '${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product_cats'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service_cats'] : global.appLocaleValues['tle_both_cat']}',
                          style: widget.routeName == 'ProductTypeScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => ProductTypeScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )));
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          MdiIcons.currencyUsd,
                          color: widget.routeName == 'ExpenseCategoriesScreen' ? Colors.black : Colors.white,
                        ),
                        title: Text(
                          global.appLocaleValues['tle_expense_cats'],
                          style: widget.routeName == 'ExpenseCategoriesScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => ExpenseCategoriesScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )));
                        },
                      ),
                      ListTile(
                        title: Text(
                          global.appLocaleValues['tle_tax_setup'],
                          style: widget.routeName == 'TaxScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                        ),
                        leading: Icon(
                          MdiIcons.percent,
                          color: widget.routeName == 'TaxScreen' ? Colors.black : Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => TaxScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )));
                        },
                      ),

                      // ListTile(
                      //   title: Text(
                      //     global.appLocaleValues['tle_business_profile'],
                      //      style: widget.routeName == 'ProfileBusinessSettingsScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                      //   ),
                      //   leading: Icon(
                      //     Icons.work,
                      //     color: widget.routeName == 'ProfileBusinessSettingsScreen' ? Colors.black : Colors.white,
                      //   ),
                      //   onTap: () {
                      //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //         builder: (context) =>  ProfileBusinessSettingsScreen(
                      //               a: widget.analytics,
                      //               o: widget.observer,
                      //             )));
                      //   },
                      // ),
                      // ListTile(
                      //   title: Text(
                      //     global.appLocaleValues['tle_personal_profile'],
                      //     style: widget.routeName == 'ProfilePersonalSettingsScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                      //   ),
                      //   leading: Icon(
                      //     Icons.person,
                      //     color: widget.routeName == 'ProfilePersonalSettingsScreen' ? Colors.black : Colors.white,
                      //   ),
                      //   onTap: () {
                      //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //         builder: (context) =>  ProfilePersonalSettingsScreen(
                      //               a: widget.analytics,
                      //               o: widget.observer,
                      //             )));
                      //   },
                      // ),
                      // ListTile(
                      //   leading: Icon(
                      //     Icons.settings,
                      //     color: widget.routeName == 'SettingsScreen' ? Colors.black : Colors.white,
                      //   ),
                      //   title: Text(
                      //     global.appLocaleValues['lbl_setting'],
                      //     style: widget.routeName == 'SettingsScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                      //   ),
                      //   onTap: () {
                      //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //         builder: (BuildContext context) =>  SettingsScreen(
                      //               a: widget.analytics,
                      //               o: widget.observer,
                      //             )));
                      //   },
                      // ),
                    ],
                  ),
                )
              ],
            ),
            (br.getSystemFlagValue(global.systemFlagNameList.enableGoogleBackupRestore) == 'true')
                ? ListTile(
                    leading: Icon(
                      Icons.cloud,
                      color: widget.routeName == 'BackupAndRestoreScreen' ? Colors.black : Colors.white,
                    ),
                    title: Text(
                      global.appLocaleValues['tle_backup_and_restore'],
                      style: widget.routeName == 'BackupAndRestoreScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => BackupAndRestoreScreen(
                                a: widget.analytics,
                                o: widget.observer,
                              )));
                    },
                  )
                : SizedBox(),
            ExpansionTile(
              leading: Icon(
                Icons.menu_sharp,
                color: Colors.white,
              ),
              title: Text(
                '${global.appLocaleValues['Others']}',
                style: Theme.of(context).primaryTextTheme.headline2,
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                        title: Text(
                          global.appLocaleValues['tle_abt_us'],
                          style: Theme.of(context).primaryTextTheme.headline2,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => AboutScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )));
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.apps,
                          color: Colors.white,
                        ),
                        title: Text(
                          global.appLocaleValues['tle_others_app'],
                          style: Theme.of(context).primaryTextTheme.headline2,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => OtherAppsScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )));
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.security,
                          color: Colors.white,
                        ),
                        title: Text(
                          global.appLocaleValues['tle_privacy_policy'],
                          style: Theme.of(context).primaryTextTheme.headline2,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => PrivacyPolicyScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )));
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        title: Text(
                          global.appLocaleValues['lt_share'],
                          style: Theme.of(context).primaryTextTheme.headline2,
                        ),
                        onTap: () {
                          _onShareTap();
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.rate_review,
                          color: Colors.white,
                        ),
                        title: Text(
                          global.appLocaleValues['tle_rate'],
                          style: Theme.of(context).primaryTextTheme.headline2,
                        ),
                        onTap: () {
                          _onRateTap();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.settings,
            //     color: widget.routeName == 'SettingsScreen' ? Colors.black : Colors.white,
            //   ),
            //   title: Text(
            //     global.appLocaleValues['lbl_setting'],
            //     style: widget.routeName == 'SettingsScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(MaterialPageRoute(
            //         builder: (BuildContext context) =>  SettingsScreen(
            //               a: widget.analytics,
            //               o: widget.observer,
            //             )));
            //   },
            // ),

            // ListTile(
            //   leading: Icon(
            //     Icons.security,
            //      color: (widget.routeName == 'ContributeScreen') ? Colors.black : Colors.white,
            //   ),
            //   title: Text(global.appLocaleValues['tle_privacy_policy'],style: widget.routeName == 'PrivacyPolicyScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,),
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(MaterialPageRoute(
            //         builder: (BuildContext context) =>  PrivacyPolicyScreen(
            //               a: widget.analytics,
            //               o: widget.observer,
            //             )));
            //   },
            // ),
            // ListTile(
            //   leading: Icon(
            //     FontAwesomeIcons.handsHelping,
            //     size: 24,
            //     color: (widget.routeName == 'ContributeScreen') ? Colors.black : Colors.white,
            //   ),
            //   title: Text(
            //     "${global.appLocaleValues['tle_contribute']}",
            //      style: widget.routeName == 'ContributeScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(MaterialPageRoute(
            //         builder: (BuildContext context) =>  ContributeScreen(
            //               o: widget.observer,
            //               a: widget.analytics,
            //             )));
            //   },
            // ),

            // ListTile(
            //   leading: Icon(Icons.info, color: Colors.white),
            //   title: Text(
            //     global.appLocaleValues['tle_abt_us'],
            //     style: widget.routeName == 'AboutScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(MaterialPageRoute(
            //         builder: (BuildContext context) =>  AboutScreen(
            //               a: widget.analytics,
            //               o: widget.observer,
            //             )));
            //   },
            // ),

            // ListTile(
            //   leading: Icon(
            //     Icons.apps,
            //      color: (widget.routeName == 'OtherAppsScreen') ? Colors.black : Colors.white,
            //   ),
            //   title: Text(
            //     global.appLocaleValues['tle_others_app'],
            //     style: widget.routeName == 'OtherAppsScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(MaterialPageRoute(
            //         builder: (BuildContext context) =>  OtherAppsScreen(
            //               a: widget.analytics,
            //               o: widget.observer,
            //             )));
            //   },
            // ),

            // ListTile(
            //     leading: Icon(Icons.share, color: Colors.white),
            //     title: Text(global.appLocaleValues['lt_share'], style: Theme.of(context).primaryTextTheme.headline2),
            //     onTap: () {
            //       setState(() {
            //         // _onShareTap();
            //       });
            //     }),

            // ListTile(
            //     leading: Icon(Icons.rate_review, color: Colors.white),
            //     title: Text(global.appLocaleValues['tle_rate'], style: Theme.of(context).primaryTextTheme.headline2),
            //     onTap: () {
            //       _onRateTap();
            //     }),
            ListTile(
              title: Text(
                global.appLocaleValues['tel_change_pin'],
                style: widget.routeName == 'ChangeLoginPinScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
              ),
              leading: Icon(Icons.lock, color: widget.routeName == 'ChangeLoginPinScreen' ? Colors.black : Colors.white),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ChangeLoginPinScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )));
              },
            ),

            // ListTile(
            //   leading: Icon(Icons.feedback, color: widget.routeName == 'FeedBackScreen' ? Colors.black : Colors.white),
            //   title: Text(
            //     global.appLocaleValues['tle_feedback'],
            //     style: widget.routeName == 'FeedBackScreen' ? Theme.of(context).primaryTextTheme.headline3 : Theme.of(context).primaryTextTheme.headline2,
            //   ),
            //   onTap: () async {
            //     Navigator.of(context).pushReplacement(MaterialPageRoute(
            //         builder: (BuildContext context) => FeedBackScreen(
            //               a: widget.analytics,
            //               o: widget.observer,
            //             )));
            //   },
            // ),

            // ListTile(
            //   leading: Icon(Icons.power_settings_new, color: Colors.white),
            //   title: Text(global.appLocaleValues['tle_logout'], style: Theme.of(context).primaryTextTheme.headline2),
            //   onTap: () async {
            //     await logoutAppDialog();
            //   },
            // ),
            ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text(global.appLocaleValues['tle_exit'], style: Theme.of(context).primaryTextTheme.headline2),
                onTap: () async {
                  await exitAppDialog(0);
                }),
          ],
        ),
      ),
    );
  }

  // Future getData() async {
  //   business = await dbHelper.businessGetList();
  // }

  @override
  void initState() {
    super.initState();
    print(widget.routeName);
    //  getData();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  void _onRateTap() async {
    try {
      String _url = (global.isAndroidPlatform) ? global.playStoreURL : global.appStoreURL;
      if (await canLaunch(_url)) {
        await launch(_url);
      } else {
        throw 'Could not launch ' + _url;
      }
    } catch (e) {
      // log(e.toString());
    }
  }

  void _onShareTap() {
    global.isAppOperation = true;
    String referral = '&referrer=${br.encrypt(global.user.mobile.toString())}';
    //final RenderBox box = context.findRenderObject();
    // Share.text(global.appName, global.appShareMessage + referral, 'text/plain');
    Share.share(
      global.appShareMessage + referral,
    );
  }
}
