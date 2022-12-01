// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation

import 'dart:io' as io;
import 'dart:convert';
import 'dart:io';
import 'package:accounting_app/models/paymentDetailModel.dart';
import 'package:accounting_app/models/paymentSaleOrderModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailTaxModel.dart';
import 'package:accounting_app/models/saleOrderDetailModel.dart';
import 'package:accounting_app/models/saleOrderTaxModel.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/authProfileModel.dart';
import 'package:accounting_app/models/businessLayer/dbHelper.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/businessLayer/global.dart';
import 'package:accounting_app/models/businessModel.dart';
import 'package:accounting_app/models/oAuthUserModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceTaxModel.dart';
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/models/salesQuoteInvoiceModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/models/systemFlagModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
// import 'package:accounting_app/screens/loginScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mailer/mailer.dart' as email;
//import 'package:location/location.dart';
import 'package:mailer/smtp_server.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pd;
import 'package:printing/printing.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:accounting_app/models/businessLayer/nativeExtensiones.dart';

import '../saleOrderDetailTaxModel.dart';
import '../userModel.dart';

class BusinessRule {
  // final iv = enc.IV.fromLength(16);
  BusinessRule();

  String encrypt(String plainText) {
    try {
      if (plainText != null && plainText.isNotEmpty) {
        enc.Key key = enc.Key.fromUtf8(global.globalEncryptionKey);
        final encrypter = enc.Encrypter(enc.AES(key));
        return encrypter.encrypt(plainText, iv: enc.IV.fromLength(16)).base64;
      }
    } catch (e) {
      print("Exception - businessRule.dart - encrypt():" + e.toString());
    }
    return null;
  }

  Future generatePaymentReceiptHtml(context, {Payment payment, bool isPrintAction}) async {
    try {
      if (payment.paymentDetailList == null) {
        DBHelper dbHelper = DBHelper(global.business);
        payment.paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: [payment.id]);
      }

      String _address = generateAccountAddress(payment.account);
      final bytes = (global.business.logoPath != null && global.business.logoPath.isNotEmpty) ? await io.File(global.business.logoPath).readAsBytes() : null;
      var encodedImage = (global.business.logoPath != null && global.business.logoPath.isNotEmpty) ? base64.encode(bytes) : null;

      var htmlContent = """
   <!DOCTYPE html>
<html>
<head>
  <style>
  table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
  }
  th, td, p {
    padding: 2px;
    text-align: left;
  }""";

      if (isPrintAction == null) {
        htmlContent += """
    .page {
        width: 210mm;
        min-height: 297mm;
        padding: 20mm;
        margin: 10mm auto;
        border: 1px #D3D3D3 solid;
        border-radius: 5px;
    }

     @page {
        size: A4;
        margin: 0;
    }
    """;
      }

      htmlContent += """ 

  </style>
</head> """;
      if (isPrintAction == null) {
        htmlContent += """
  <body class="page">
  """;
      } else {
        htmlContent += """
  <body>
  """;
      }
      htmlContent += """ <div align=center style="display: flex;
        align-items: center;
        justify-content: center;">""";
      if (encodedImage != null) {
        htmlContent += """ <img src="data:image/jpeg;base64,$encodedImage"
                style="width: 50px;height: auto;margin-right: 10px;" alt="logo">""";
      }

      htmlContent += """  <span style="font-size: xx-large; font-weight: bold;">${global.business.name}</span></div><h4 align=center>${global.business.addressLine1}</br>""";

      if (global.business.contact1 != null) {
        htmlContent += """${global.country.isoCode} ${global.business.contact1}<br>""";
      }
      if (global.business.email != null && global.business.email != "") {
        htmlContent += """${global.business.email}<br>""";
      }

      if (global.business.website != null && global.business.website != "") {
        htmlContent += """${global.business.website}<br><h4>""";
      }
      // if (global.business.gstNo != null && global.business.gstNo != "") {
      //   htmlContent += """${global.appLocaleValues['lbl_gst_no_']}: ${global.business.gstNo}<br><h4>""";
      // }
      htmlContent += """
  <hr>
  </header>
  """;

      htmlContent += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_payment_receipt']}</font></h1> <br>
      <p style='float: left;clear: both;'><font size=4>${generateAccountName(payment.account)} ( +${payment.account.mobileCountryCode} ${payment.account.mobile} ) <br>$_address</font></p> 
                      <p style='text-align: center;clear: both;'><font size=4><font style="color: gray;">${global.appLocaleValues['lbl_payment_methods_']}:</font></font></p>
                      <table style='width:100%'>
    <tr>
    <th>#</th>
    <th>${global.appLocaleValues['lbl_method']}</th>
    <th>${global.appLocaleValues['lbl_amount']}</th>
     <th>${global.appLocaleValues['lbl_date']}</th>
    <th>${global.appLocaleValues['lbl_remark']}</th>
    </tr>
   """;

      payment.paymentDetailList.forEach((i) {
        htmlContent += """
     <tr>
    <td>${(payment.paymentDetailList.indexOf(i)) + 1}</td>
    <td>${i.paymentMode}</td>
    <td>${global.currency.symbol} ${i.amount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
   <td> ${DateFormat(getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(payment.transactionDate)}</td>
     """;

        if (i.remark != '') {
          htmlContent += """
       <td>${i.remark}</td>
    </tr>
       """;
        } else {
          htmlContent += """
       <td>-</td>
    </tr>
       """;
        }
      });

      htmlContent += """
   </table>
</body>
    <table style='width:62%;', align="right">
                    <tr>
                            <td style="background-color: teal;color: white;"><b>${global.appLocaleValues['lbl_total']}</b></td>
                            <td style="background-color: teal;color: white;"><b>${global.currency.symbol} ${payment.amount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
                        </tr>
        </table>
  </body>
  <footer style="bottom: 0;position: absolute;width: 100%">
      <hr>
      <p>${(getSystemFlagValue(global.systemFlagNameList.paymentPdfFooter) != null) ? getSystemFlagValue(global.systemFlagNameList.paymentPdfFooter) : ''}</p>
      </footer>
</html>
   """;
      if (isPrintAction) // print invoice
      {
        await printReport(htmlContent);
      } else // share invoice
      {
        String fileName = 'paymentReceipt.pdf';
        await shareReport(htmlContent, fileName, email: payment.account.email, subject: 'Payment Receipt');
      }
    } catch (e) {
      print('Exception - br.generatePaymentReceiptHtml(): ' + e.toString());
    }
  }

  Future<String> generatePurchaseInvoiceHtml(context, {PurchaseInvoice invoice, bool isPrintAction, List<PurchaseInvoiceReturnDetail> returnProductList, List<TaxMaster> returnProductTaxList, double returnProductSubTotal, double returnProductfinalTotal, String returnProductPaymentStatus}) async {
    try {
      String _address = generateAccountAddress(invoice.account);
      String grossAmountInWords = NumberToWord().convert('en-in', invoice.netAmount.round()) + global.currency.name;
      String returnProductfinalTotalInWords = (returnProductfinalTotal != null) ? NumberToWord().convert('en-in', returnProductfinalTotal.round()) + global.currency.name : '';
      var htmlContent = """
    <!DOCTYPE html>
<html>
<head>
  <style>
  table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
    
  }
  th, td, p {
    padding: 2px;
    text-align: left;
  }
  </style>
</head>
  <body>
  <header>
    <h1 align=center><font size=6>${global.business.name}</font></h1>""";

      htmlContent += """<h4 align=center>${global.business.addressLine1}</br>""";

      if (global.business.contact1 != null) {
        htmlContent += """${global.country.isoCode} ${global.business.contact1}<br>""";
      }
      if (global.business.email != null && global.business.email != "") {
        htmlContent += """${global.business.email}<br>""";
      }

      if (global.business.website != null && global.business.website != "") {
        htmlContent += """${global.business.website}<br><h4>""";
      }

      // if (global.business.gstNo != null && global.business.gstNo != "") {
      //   htmlContent += """${global.appLocaleValues['lbl_gst_no_']}: ${global.business.gstNo}<br><h4>""";
      // }
      htmlContent += """
  <hr>
  </header>
  """;
      if (invoice.invoiceTaxList.length == 0) {
        htmlContent += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_purchase_inv']}</font></h1> """;
      } else {
        htmlContent += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_tax_purchase_inv']}</font></h1> """;
      }
      htmlContent += """
    <h4 style='float: left;'>${global.appLocaleValues['tle_purchase_inv_no']}: ${invoice.invoiceNumber}</h4> <p style='float: right'><font size=4>${global.appLocaleValues['lbl_date']}: ${DateFormat(getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.invoiceDate)}</font></p>
    <p style='float: left;clear: both;'><font size=4>${generateAccountName(invoice.account)} ( +${invoice.account.mobileCountryCode} ${invoice.account.mobile} ) <br>$_address</font></p> 
    <table style='width:100%'>
""";

      if (invoice.invoiceDetailList.length > 0) {
        htmlContent += """
        <tr>
    <th>#</th>
    <th>${(getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_both']}</th>
    <th>${global.appLocaleValues['lbl_quantity']}</th> """;

        if (getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          htmlContent += """  <th>${global.appLocaleValues['lbl_unit_code']}</th>""";
        }

        htmlContent += """
    <th>${global.appLocaleValues['lbl_unit_price_']}</th>
    <th>${global.appLocaleValues['lbl_amount']}</th>
    </tr>
        """;
      }
      invoice.invoiceDetailList.forEach((item) {
        htmlContent += """
      <tr>
    <td>${(invoice.invoiceDetailList.indexOf(item)) + 1}</td>
    <td>${item.productName}</td>
    <td>${item.quantity}</td> """;

        if (getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          htmlContent += """ <td>${item.unitCode}</td>""";
        }

        htmlContent += """  
    <td>${global.currency.symbol} ${item.unitPrice.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    <td>${global.currency.symbol} ${item.amount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    </tr>
      """;
      });

      htmlContent += """
    </table>
    <br>
    <table style='width:50%', align="left" , border: 1px solid black;>
        <tr>
            <td><b>${global.appLocaleValues['lbl_in_words']}:</b></td>
          
        </tr>
        <tr>
          <td><b><font style="color: teal;">${grossAmountInWords.intoSentanseCase()} </font></b></td>
        </tr>
        <tr>
          <td><b>${global.appLocaleValues['lbl_terms_and_condition']}:</b></td>
          
        </tr>
        <tr> """;
      if (getSystemFlagValue(global.systemFlagNameList.termsAndCondition) != null && getSystemFlagValue(global.systemFlagNameList.termsAndCondition) != '') {
        htmlContent += """
        <td><b><font style="color: teal;">${getSystemFlagValue(global.systemFlagNameList.termsAndCondition).replaceAll('\n', '<br>')}</font></b></td>
        </tr>
    """;
      } else {
        htmlContent += """
        <td><b><font style="color: teal;">${global.appLocaleValues['lbl_tnaking_note']}</font></b></td>
        </tr>
    """;
      }

      htmlContent += """
    </table>
    <table style='width:50%',align="right">
            <tr>
                <td><b>${global.appLocaleValues['lbl_sub_total_']}</b></td>
                <td> ${global.currency.symbol} ${invoice.grossAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
            </tr>
            <tr>
                    <td><b>${global.appLocaleValues['lbl_discount']}</b></td>
                    <td>${global.currency.symbol} ${invoice.discount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                </tr>""";

      for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
        if (invoice.invoiceDetailTaxList.length != 0) {
          htmlContent += """ <tr>
                        <td><b>${invoice.invoiceTaxList[i].taxName}</b></td>
                        <td>${global.currency.symbol} ${invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                    </tr>
                    """;
        } else {
          htmlContent += """ <tr>
                        <td><b>${invoice.invoiceTaxList[i].taxName}(${invoice.invoiceTaxList[i].percentage.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)</b></td>
                        <td>${global.currency.symbol} ${invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                    </tr>
                    """;
        }
      }

      if (invoice.remainAmount >= 0) {
        htmlContent += """
      <tr>
                <td><b>${global.appLocaleValues['lbl_due']}</b></td>
                <td>${global.currency.symbol} ${invoice.remainAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
            </tr>
      """;
      } else {
        htmlContent += """
      <tr>
                <td><b>${global.appLocaleValues['lbl_credit']}</b></td>
                <td>${global.currency.symbol} ${(invoice.remainAmount * -1).toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
            </tr>
      """;
      }

      if (invoice.status == 'CANCELLED') {
        htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: gray;">${invoice.status}</font></td>
                </tr>
      """;
      } else if (invoice.status == 'DUE') {
        htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: red;">${invoice.status}</font></td>
                </tr>
      """;
      } else {
        htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: green;">${invoice.status}</font></td>
                </tr>
      """;
      }

      htmlContent += """          <tr>
                            <td style="background-color: teal;color: white;"><b>${global.appLocaleValues['lbl_total']}</b></td>
                            <td style="background-color: teal;color: white;"><b>${global.currency.symbol} ${invoice.netAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
                        </tr>
        </table>
        <br>
       """;

      //
      if (invoice.returnProducts > 0) {
        htmlContent += """
       <center> <font size=3><b>${(getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_return_product'] : global.appLocaleValues['tle_return_service']}</b></font> </center>
    <table style='width:100%'>
    <tr>
    <th>#</th>
    <th>${(getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_both']}</th>
    <th>${global.appLocaleValues['lbl_quantity']}</th> """;

        if (getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          htmlContent += """<th>${global.appLocaleValues['lbl_unit_code']}</th> """;
        }

        htmlContent += """  
    <th>${global.appLocaleValues['lbl_unit_price_']}</th>
    <th>${global.appLocaleValues['lbl_amount']}</th>
    </tr>
""";
        returnProductList.forEach((item) {
          htmlContent += """
      <tr>
    <td>${(returnProductList.indexOf(item)) + 1}</td>
    <td>${item.productName}</td>
    <td>${item.quantity}</td> """;

          if (getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
            htmlContent += """ <td>${item.unitCode}</td>""";
          }

          htmlContent += """   
    <td>${global.currency.symbol} ${item.unitPrice.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    <td>${global.currency.symbol} ${item.amount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    </tr>
      """;
        });

        htmlContent += """
    </table>
    <br>
    <table style='width:50%', align="left" , border: 1px solid black;>
        <tr>
            <td><b>${global.appLocaleValues['lbl_in_words']}:</b></td>
          
        </tr>
        <tr>
          <td><b><font style="color: teal;">${returnProductfinalTotalInWords.intoSentanseCase()}</font></b></td>
        </tr>
        <tr>
          <td><b>${global.appLocaleValues['lbl_terms_and_condition']}:</b></td>
          
        </tr>
        <tr> """;
        if (getSystemFlagValue(global.systemFlagNameList.termsAndCondition) != null && getSystemFlagValue(global.systemFlagNameList.termsAndCondition) != '') {
          htmlContent += """
        <td><b><font style="color: teal;">${getSystemFlagValue(global.systemFlagNameList.termsAndCondition).replaceAll('\n', '<br>')}</font></b></td>
        </tr>
    """;
        } else {
          htmlContent += """
        <td><b><font style="color: teal;">${global.appLocaleValues['lbl_tnaking_note']}</font></b></td>
        </tr>
    """;
        }

        htmlContent += """
    </table>
    <table style='width:50%',align="right">
            <tr>
                <td><b>${global.appLocaleValues['lbl_sub_total_']}</b></td>
                <td> ${global.currency.symbol} ${returnProductSubTotal.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
            </tr>
           """;

        for (int i = 0; i < returnProductTaxList.length; i++) {
          htmlContent += """ <tr>
                        <td><b>${returnProductTaxList[i].taxName}</b></td>
                        <td>${global.currency.symbol} ${returnProductTaxList[i].taxAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                    </tr>
                    """;
        }

        if (returnProductPaymentStatus == 'CANCELLED') {
          htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: gray;">$returnProductPaymentStatus</font></td>
                </tr>
      """;
        } else if (returnProductPaymentStatus == 'PENDING') {
          htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: red;">$returnProductPaymentStatus</font></td>
                </tr>
      """;
        } else {
          htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: green;">$returnProductPaymentStatus</font></td>
                </tr>
      """;
        }

        htmlContent += """          <tr>
                            <td style="background-color: teal;color: white;"><b>${global.appLocaleValues['lbl_total']}</b></td>
                            <td style="background-color: teal;color: white;"><b>${global.currency.symbol} ${returnProductfinalTotal.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
                        </tr>
        </table>
        <br>
       """;
      }
      //

      htmlContent += """   
  </body>
  <footer style="bottom: 0;position: relative;width: 100%">
      <hr>
      <p>${(getSystemFlagValue(global.systemFlagNameList.invoicePdfFooter) != null) ? getSystemFlagValue(global.systemFlagNameList.invoicePdfFooter) : ''}</p>
      </footer>
</html>
      """;
      if (isPrintAction != null) {
        if (isPrintAction) // print invoice
        {
          await printReport(htmlContent);
        } else // share invoice
        {
          await shareReport(htmlContent, '${invoice.invoiceNumber}.pdf');
        }
      }
      return htmlContent;
    } catch (e) {
      print('Exception - br.generatePurchaseInvoiceHtml(): ' + e.toString());
      return null;
    }
  }

  Future<String> generateSaleInvoiceHtml(context, {SaleInvoice invoice, bool isPrintAction, List<SaleInvoiceReturnDetail> returnProductList, List<TaxMaster> returnProductTaxList, double returnProductSubTotal, double returnProductfinalTotal, String returnProductPaymentStatus}) async {
    try {
      String _address = (invoice.account.businessName != null && invoice.account.businessName.isNotEmpty) ? '<b>${invoice.account.businessName}</b><br>' : '';
      _address += generateAccountAddress(invoice.account);
      String grossAmountInWords = NumberToWord().convert('en-in', invoice.netAmount.round()) + global.currency.name;
      String returnProductfinalTotalInWords = (returnProductfinalTotal != null) ? NumberToWord().convert('en-in', returnProductfinalTotal.round()) + global.currency.name : '';
      final bytes = (global.business.logoPath != null && global.business.logoPath.isNotEmpty) ? await io.File(global.business.logoPath).readAsBytes() : null;
      var encodedImage = (global.business.logoPath != null && global.business.logoPath.isNotEmpty) ? base64.encode(bytes) : null;
      var htmlContent = """
    <!DOCTYPE html>
<html>
<head>
  <style>
  table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
    
  }
  th, td, p {
    padding: 2px;
    text-align: left;
  }""";

      if (isPrintAction == null) {
        htmlContent += """
    .page {
        width: 210mm;
        min-height: 297mm;
        padding: 20mm;
        margin: 10mm auto;
        border: 1px #D3D3D3 solid;
        border-radius: 5px;
    }

     @page {
        size: A4;
        margin: 0;
    }
    """;
      }

      htmlContent += """  </style>
</head> """;
      if (isPrintAction == null) {
        htmlContent += """
  <body class="page">
  """;
      } else {
        htmlContent += """
  <body>
  """;
      }
      htmlContent += """ <div align=center style="display: flex;
        align-items: center;
        justify-content: center;">""";
      if (encodedImage != null) {
        htmlContent += """ <img src="data:image/jpeg;base64,$encodedImage"
                style="width: 50px;height: auto;margin-right: 10px;" alt="logo">""";
      }

      htmlContent += """  <span style="font-size: xx-large; font-weight: bold;">${global.business.name}</span></div><h4 align=center>${global.business.addressLine1}</br>""";

      if (global.business.contact1 != null) {
        htmlContent += """${global.country.isoCode} ${global.business.contact1}<br>""";
      }
      if (global.business.email != null && global.business.email != "") {
        htmlContent += """${global.business.email}<br>""";
      }

      if (global.business.website != null && global.business.website != "") {
        htmlContent += """${global.business.website}<br><h4>""";
      }
      // if (global.business.gstNo != null && global.business.gstNo != "") {
      //   htmlContent += """${global.appLocaleValues['lbl_gst_no_']}: ${global.business.gstNo}<br><h4>""";
      // }
      htmlContent += """
  <hr>
  </header>
  """;
      if (invoice.invoiceTaxList.length == 0) {
        htmlContent += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_sale_inv']}</font></h1> """;
      } else {
        htmlContent += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_tax_sale_inv']}</font></h1> """;
      }
      htmlContent += """
    <h4 style='float: left;'>${global.appLocaleValues['tle_sale_inv_no']}: ${getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + invoice.invoiceNumber.toString().length))}${invoice.invoiceNumber}</h4> <p style='float: right'><font size=4>${global.appLocaleValues['lbl_date']}: ${DateFormat(getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(invoice.invoiceDate)}</font></p>
    <p style='float: left;clear: both;'><font size=4>${generateAccountName(invoice.account)} ( +${invoice.account.mobileCountryCode} ${invoice.account.mobile} ) <br>$_address</font></p> 
    <table style='width:100%'>
""";
      if (!invoice.generateByProductCategory) {
        if (invoice.invoiceDetailList.length > 0) {
          htmlContent += """
        <tr>
    <th>#</th>
    <th>${(getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_both']}</th>
    <th>Description</th>
    <th>${global.appLocaleValues['lbl_quantity']}</th>""";

          if (getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
            htmlContent += """ <th>${global.appLocaleValues['lbl_unit_code_']}</th> """;
          }

          htmlContent += """
    <th>${global.appLocaleValues['lbl_unit_price_']}</th>
    <th>${global.appLocaleValues['lbl_amount']}</th>
    </tr>
        """;
        }
        invoice.invoiceDetailList.forEach((item) {
          htmlContent += """
      <tr>
    <td>${(invoice.invoiceDetailList.indexOf(item)) + 1}</td>
    <td>${item.productName}</td>
    <td>${item.productDescription.replaceAll('\n', '<br>')}</td>
    <td>${item.quantity}</td>""";
          if (getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
            htmlContent += """  <td>${item.unitCode}</td>""";
          }

          htmlContent += """
    <td>${global.currency.symbol} ${item.unitPrice.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    <td>${global.currency.symbol} ${item.amount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    </tr>
      """;
        });
      } else {
        if (invoice.generateByCategoryList.length > 0) {
          htmlContent += """
        <tr>
    <th>#</th>
    <th>${(getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_cat'] : global.appLocaleValues['lbl_service_cat']}</th>
    <th>${global.appLocaleValues['lbl_quantity']}</th>
    <th>${global.appLocaleValues['lbl_amount']}</th>
    </tr>
        """;
        }
        invoice.generateByCategoryList.forEach((item) {
          htmlContent += """
      <tr>
    <td>${(invoice.generateByCategoryList.indexOf(item)) + 1}</td>
    <td>${item.productCategoryName}</td>
    <td>${item.quantity}</td>
    <td>${global.currency.symbol} ${item.amount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    </tr>
      """;
        });
      }

      htmlContent += """
    </table>
    <br>
    <table style='width:50%', align="left" , border: 1px solid black;>
        <tr>
            <td><b>${global.appLocaleValues['lbl_in_words']}:</b></td>
          
        </tr>
        <tr>
          <td><b><font style="color: teal;">${grossAmountInWords.intoSentanseCase()} </font></b></td>
        </tr>
        <tr>
          <td><b>${global.appLocaleValues['lbl_terms_and_condition']}:</b></td>
          
        </tr>
        <tr> """;
      if (getSystemFlagValue(global.systemFlagNameList.termsAndCondition) != null && getSystemFlagValue(global.systemFlagNameList.termsAndCondition) != '') {
        htmlContent += """
        <td><b><font style="color: teal;">${getSystemFlagValue(global.systemFlagNameList.termsAndCondition).replaceAll('\n', '<br>')}</font></b></td>
        </tr>
    """;
      } else {
        htmlContent += """
        <td><b><font style="color: teal;">${global.appLocaleValues['lbl_tnaking_note']}</font></b></td>
        </tr>
    """;
      }

      htmlContent += """
    </table>
    <table style='width:50%',align="right">
            <tr>
                <td><b>${global.appLocaleValues['lbl_sub_total_']}</b></td>
                <td> ${global.currency.symbol} ${invoice.grossAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
            </tr>
            <tr>
                    <td><b>${global.appLocaleValues['lbl_discount']}</b></td>
                    <td>${global.currency.symbol} ${invoice.discount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                </tr>""";

      if (invoice.finalTax != null && invoice.finalTax > 0) {
        for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
          if (invoice.invoiceDetailTaxList.length != 0) {
            htmlContent += """ <tr>
                        <td><b>${invoice.invoiceTaxList[i].taxName}</b></td>
                        <td>${global.currency.symbol} ${invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                    </tr>
                    """;
          } else {
            htmlContent += """ <tr>
                        <td><b>${invoice.invoiceTaxList[i].taxName}(${invoice.invoiceTaxList[i].percentage.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)</b></td>
                        <td>${global.currency.symbol} ${invoice.invoiceTaxList[i].totalAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                    </tr>
                    """;
          }
        }
      }

      if (invoice.remainAmount >= 0) {
        htmlContent += """
      <tr>
                <td><b>${global.appLocaleValues['lbl_due']}</b></td>
                <td>${global.currency.symbol} ${invoice.remainAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
            </tr>
      """;
      } else {
        htmlContent += """
      <tr>
                <td><b>${global.appLocaleValues['lbl_credit']}</b></td>
                <td>${global.currency.symbol} ${(invoice.remainAmount * -1).toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
            </tr>
      """;
      }

      if (invoice.status == 'CANCELLED') {
        htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: gray;">${invoice.status}</font></td>
                </tr>
      """;
      } else if (invoice.status == 'DUE') {
        htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: red;">${invoice.status}</font></td>
                </tr>
      """;
      } else {
        htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: green;">${invoice.status}</font></td>
                </tr>
      """;
      }

      htmlContent += """          <tr>
                            <td style="background-color: teal;color: white;"><b>${global.appLocaleValues['lbl_total']}</b></td>
                            <td style="background-color: teal;color: white;"><b>${global.currency.symbol} ${invoice.netAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
                        </tr>
        </table>
        <br>
       """;

      //

      if (invoice.returnProducts > 0) {
        if (!invoice.generateByProductCategory) {
          htmlContent += """
       <center> <font size=3><b>${(getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_return_product'] : global.appLocaleValues['tle_return_service']}</b></font> </center>
    <table style='width:100%'>
    <tr>
    <th>#</th>
    <th>${(getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_both']}</th>
    <th>${global.appLocaleValues['lbl_quantity']}</th>""";
          if (getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
            htmlContent += """ <th>${global.appLocaleValues['lbl_unit_code']}</th>""";
          }
          htmlContent += """ 
    <th>${global.appLocaleValues['lbl_unit_price_']}</th>
    <th>${global.appLocaleValues['lbl_amount']}</th>
    </tr>
""";
          returnProductList.forEach((item) {
            htmlContent += """
      <tr>
    <td>${(returnProductList.indexOf(item)) + 1}</td>
    <td>${item.productName}</td>
    <td>${item.quantity}</td>""";

            if (getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
              htmlContent += """ <td>${item.unitCode}</td>""";
            }

            htmlContent += """ 
    <td>${global.currency.symbol} ${item.unitPrice.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    <td>${global.currency.symbol} ${item.amount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    </tr>
      """;
          });
        } else {
          htmlContent += """
       <center> <font size=3><b>${(getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_return_product'] : global.appLocaleValues['tle_return_service']}</b></font> </center>
    <table style='width:100%'>
    <tr>
    <th>#</th>
    <th>${(getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['lbl_product_cat'] : global.appLocaleValues['lbl_service_cat']}</th>
    <th>${global.appLocaleValues['lbl_quantity']}</th>
    <th>${global.appLocaleValues['lbl_amount']}</th>
    </tr>
""";
          invoice.returnGenerateByCategoryList.forEach((item) {
            htmlContent += """
      <tr>
    <td>${(invoice.returnGenerateByCategoryList.indexOf(item)) + 1}</td>
    <td>${item.productCategoryName}</td>
    <td>${item.quantity}</td>
    <td>${global.currency.symbol} ${item.amount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    </tr>
      """;
          });
        }

        htmlContent += """
    </table>
    <br>
    <table style='width:50%', align="left" , border: 1px solid black;>
        <tr>
            <td><b>${global.appLocaleValues['lbl_in_words']}:</b></td>
          
        </tr>
        <tr>
          <td><b><font style="color: teal;">${returnProductfinalTotalInWords.intoSentanseCase()}</font></b></td>
        </tr>
        <tr>
          <td><b>${global.appLocaleValues['lbl_terms_and_condition']}:</b></td>
          
        </tr>
        <tr> """;
        if (getSystemFlagValue(global.systemFlagNameList.termsAndCondition) != null && getSystemFlagValue(global.systemFlagNameList.termsAndCondition) != '') {
          htmlContent += """
        <td><b><font style="color: teal;">${getSystemFlagValue(global.systemFlagNameList.termsAndCondition).replaceAll('\n', '<br>')}</font></b></td>
        </tr>
    """;
        } else {
          htmlContent += """
        <td><b><font style="color: teal;">${global.appLocaleValues['lbl_tnaking_note']}</font></b></td>
        </tr>
    """;
        }

        htmlContent += """
    </table>
    <table style='width:50%',align="right">
            <tr>
                <td><b>${global.appLocaleValues['lbl_sub_total_']}</b></td>
                <td> ${global.currency.symbol} ${returnProductSubTotal.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
            </tr>
           """;

        for (int i = 0; i < returnProductTaxList.length; i++) {
          htmlContent += """ <tr>
                        <td><b>${returnProductTaxList[i].taxName}</b></td>
                        <td>${global.currency.symbol} ${returnProductTaxList[i].taxAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                    </tr>
                    """;
        }

        if (returnProductPaymentStatus == 'CANCELLED') {
          htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: gray;">$returnProductPaymentStatus</font></td>
                </tr>
      """;
        } else if (returnProductPaymentStatus == 'PENDING') {
          htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: red;">$returnProductPaymentStatus</font></td>
                </tr>
      """;
        } else {
          htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: green;">$returnProductPaymentStatus</font></td>
                </tr>
      """;
        }

        htmlContent += """          <tr>
                            <td style="background-color: teal;color: white;"><b>${global.appLocaleValues['lbl_total']}</b></td>
                            <td style="background-color: teal;color: white;"><b>${global.currency.symbol} ${returnProductfinalTotal.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
                        </tr>
        </table>
        <br>
       """;
      }
      //

      htmlContent += """   
  </body>
  <footer style="bottom: 0;position: relative;width: 100%"> """;
      if (invoice.showRemarkInPrint && invoice.remark.isNotEmpty) {
        htmlContent += """ <p><b>Remark:</b> ${invoice.remark.replaceAll('\n', '<br>')}</p> """;
      }
      htmlContent += """       <hr>
      <p>${(getSystemFlagValue(global.systemFlagNameList.invoicePdfFooter) != null) ? getSystemFlagValue(global.systemFlagNameList.invoicePdfFooter) : ''}</p>
      </footer>
</html>
      """;

      if (isPrintAction != null) {
        if (isPrintAction) // print invoice
        {
          await printReport(htmlContent);
        } else // share invoice
        {
          String fileName = '${getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + invoice.invoiceNumber.toString().length))}${invoice.invoiceNumber}.pdf';
          await shareReport(htmlContent, fileName, email: invoice.account.email, subject: 'Sale Invoice #${getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + invoice.invoiceNumber.toString().length))}${invoice.invoiceNumber}');
        }
      }
      return htmlContent;
    } catch (e) {
      print('Exception - br.generateSaleInvoiceHtml(): ' + e.toString());
      return null;
    }
  }

  Future<String> generateSaleOrderHtml(context, {SaleOrder order, bool isPrintAction}) async {
    try {
      String _address = generateAccountAddress(order.account);
      String grossAmountInWords = NumberToWord().convert('en-in', order.netAmount.round()) + global.currency.name;
      var htmlContent = """
    <!DOCTYPE html>
<html>
<head>
  <style>
  table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
    
  }
  th, td, p {
    padding: 2px;
    text-align: left;
  }""";

      if (isPrintAction == null) {
        htmlContent += """
    .page {
        width: 210mm;
        min-height: 297mm;
        padding: 20mm;
        margin: 10mm auto;
        border: 1px #D3D3D3 solid;
        border-radius: 5px;
    }

     @page {
        size: A4;
        margin: 0;
    }
    """;
      }

      htmlContent += """  </style>
</head> """;
      if (isPrintAction == null) {
        htmlContent += """
  <body class="page">
  """;
      } else {
        htmlContent += """
  <body>
  """;
      }
      htmlContent += """
  <header>
    <h1 align=center><font size=6>${global.business.name}</font></h1>""";

      htmlContent += """<h4 align=center>${global.business.addressLine1}</br>""";

      if (global.business.contact1 != null) {
        htmlContent += """${global.country.isoCode} ${global.business.contact1}<br>""";
      }
      if (global.business.email != null && global.business.email != "") {
        htmlContent += """${global.business.email}<br>""";
      }

      if (global.business.website != null && global.business.website != "") {
        htmlContent += """${global.business.website}<br><h4>""";
      }
      // if (global.business.gstNo != null && global.business.gstNo != "") {
      //   htmlContent += """${global.appLocaleValues['lbl_gst_no_']}: ${global.business.gstNo}<br><h4>""";
      // }
      htmlContent += """
  <hr>
  </header>
  """;
      if (order.orderTaxList.length == 0) {
        htmlContent += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_sale_order']}</font></h1> """;
      } else {
        htmlContent += """ <h1 align=center><font size=6>${global.appLocaleValues['tle_tax_sale_order']}</font></h1> """;
      }
      htmlContent += """
    <h4 style='float: left;'>${global.appLocaleValues['tle_sale_order_no']}: ${order.saleOrderNumber}</h4> <p style='float: right'><font size=4>${global.appLocaleValues['lbl_date']}: ${DateFormat(getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(order.orderDate)}</font></p>
    <p style='float: left;clear: both;'><font size=4>${generateAccountName(order.account)} ( +${order.account.mobileCountryCode} ${order.account.mobile} ) <br>$_address</font></p> 
    <table style='width:100%'>
""";
      if (order.orderDetailList.length > 0) {
        htmlContent += """
        <tr>
    <th>#</th>
    <th>${(getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_both']}</th>
    <th>${global.appLocaleValues['lbl_quantity']}</th>""";

        if (getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          htmlContent += """ <th>${global.appLocaleValues['lbl_unit_code_']}</th> """;
        }

        htmlContent += """
    <th>${global.appLocaleValues['lbl_unit_price_']}</th>
    <th>${global.appLocaleValues['lbl_amount']}</th>
    </tr>
        """;
      }
      order.orderDetailList.forEach((item) {
        htmlContent += """
      <tr>
    <td>${(order.orderDetailList.indexOf(item)) + 1}</td>
    <td>${item.productName}</td>
    <td>${item.quantity}</td>""";
        if (getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          htmlContent += """  <td>${item.unitCode}</td>""";
        }

        htmlContent += """
    <td>${global.currency.symbol} ${item.unitPrice.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    <td>${global.currency.symbol} ${item.amount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    </tr>
      """;
      });

      htmlContent += """
    </table>
    <br>
    <table style='width:50%', align="left" , border: 1px solid black;>
        <tr>
            <td><b>${global.appLocaleValues['lbl_in_words']}:</b></td>
          
        </tr>
        <tr>
          <td><b><font style="color: teal;">${grossAmountInWords.intoSentanseCase()}</font></b></td>
        </tr>
        <tr>
          <td><b>${global.appLocaleValues['lbl_terms_and_condition']}:</b></td>
          
        </tr>
        <tr> """;
      if (getSystemFlagValue(global.systemFlagNameList.termsAndCondition) != null && getSystemFlagValue(global.systemFlagNameList.termsAndCondition) != '') {
        htmlContent += """
        <td><b><font style="color: teal;">${getSystemFlagValue(global.systemFlagNameList.termsAndCondition).replaceAll('\n', '<br>')}</font></b></td>
        </tr>
    """;
      } else {
        htmlContent += """
        <td><b><font style="color: teal;">${global.appLocaleValues['lbl_tnaking_note']}</font></b></td>
        </tr>
    """;
      }

      htmlContent += """
    </table>
    <table style='width:50%',align="right">
            <tr>
                <td><b>${global.appLocaleValues['lbl_sub_total_']}</b></td>
                <td> ${global.currency.symbol} ${order.netAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
            </tr>
            <tr>
                    <td><b>${global.appLocaleValues['lbl_discount']}</b></td>
                    <td>${global.currency.symbol} ${order.discount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                </tr>""";

      for (int i = 0; i < order.orderTaxList.length; i++) {
        if (order.orderDetailTaxList.length != 0) {
          htmlContent += """ <tr>
                        <td><b>${order.orderTaxList[i].taxName}</b></td>
                        <td>${global.currency.symbol} ${order.orderTaxList[i].totalAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                    </tr>
                    """;
        } else {
          htmlContent += """ <tr>
                        <td><b>${order.orderTaxList[i].taxName}(${order.orderTaxList[i].percentage.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)</b></td>
                        <td>${global.currency.symbol} ${order.orderTaxList[i].totalAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                    </tr>
                    """;
        }
      }

      htmlContent += """
      <tr>
                <td><b>${global.appLocaleValues['lbl_advance']}</b></td>
                <td>${global.currency.symbol} ${order.advanceAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
            </tr>
      """;

      if (order.status == 'CANCELLED') {
        htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: gray;">${order.status}</font></td>
                </tr>
      """;
      } else if (order.status == 'OPEN') {
        htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: red;">${order.status}</font></td>
                </tr>
      """;
      } else {
        htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: green;">${order.status}</font></td>
                </tr>
      """;
      }

      htmlContent += """          <tr>
                            <td style="background-color: teal;color: white;"><b>${global.appLocaleValues['lbl_total']}</b></td>
                            <td style="background-color: teal;color: white;"><b>${global.currency.symbol} ${order.netAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
                        </tr>
        </table>
        <br>
       """;

      htmlContent += """   
  </body>
  <footer style="bottom: 0;position: relative;width: 100%">""";
      if (order.showRemarkInPrint && order.remark.isNotEmpty) {
        htmlContent += """ <p><b>Remark:</b> ${order.remark.replaceAll('\n', '<br>')}</p> """;
      }
      htmlContent += """      <hr>
      <p>${(getSystemFlagValue(global.systemFlagNameList.invoicePdfFooter) != null) ? getSystemFlagValue(global.systemFlagNameList.invoicePdfFooter) : ''}</p>
      </footer>
</html>
      """;

      if (isPrintAction != null) {
        if (isPrintAction) // print invoice
        {
          await printReport(htmlContent);
        } else // share invoice
        {
          String fileName = 'saleOrder${order.saleOrderNumber}.pdf';
          await shareReport(htmlContent, fileName, email: order.account.email, subject: 'Sale Order #${getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + order.saleOrderNumber.toString().length))}${order.saleOrderNumber}');
        }
      }
      return htmlContent;
    } catch (e) {
      print('Exception - br.generateSaleOrderHtml(): ' + e.toString());
      return null;
    }
  }

  Future<String> generateSaleQuoteHtml(context, {SaleQuote quote, bool isPrintAction}) async {
    try {
      String _address = (quote.account.businessName != null && quote.account.businessName.isNotEmpty) ? '<b>${quote.account.businessName}</b><br>' : '';
      _address += generateAccountAddress(quote.account);
      String grossAmountInWords = NumberToWord().convert('en-in', quote.netAmount.round()) + global.currency.name;
      String _generatedInvoiceNo = '${getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${quote.saleQuoteNumber}';
      _generatedInvoiceNo = '${getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}' + '${'0' * (int.parse(getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - _generatedInvoiceNo.length)}' + '${quote.saleQuoteNumber}';
      final bytes = (global.business.logoPath != null && global.business.logoPath.isNotEmpty) ? await io.File(global.business.logoPath).readAsBytes() : null;
      var encodedImage = (global.business.logoPath != null && global.business.logoPath.isNotEmpty) ? base64.encode(bytes) : null;
      var htmlContent = """
    <!DOCTYPE html>
<html>
<head>
  <style>
  table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
    
  }
  th, td, p {
    padding: 2px;
    text-align: left;
  }""";

      if (isPrintAction == null) {
        htmlContent += """
    .page {
        width: 210mm;
        min-height: 297mm;
        padding: 20mm;
        margin: 10mm auto;
        border: 1px #D3D3D3 solid;
        border-radius: 5px;
    }

     @page {
        size: A4;
        margin: 0;
    }
    """;
      }

      htmlContent += """  </style>
</head> """;
      if (isPrintAction == null) {
        htmlContent += """
  <body class="page">
  """;
      } else {
        htmlContent += """
  <body>
  """;
      }
      htmlContent += """
  <header>""";

      htmlContent += """ <div align=center style="display: flex;
        align-items: center;
        justify-content: center;">""";
      if (encodedImage != null) {
        htmlContent += """ <img src="data:image/jpeg;base64,$encodedImage"
                style="width: 50px;height: auto;margin-right: 10px;" alt="logo">""";
      }

      htmlContent += """  <span style="font-size: xx-large; font-weight: bold;">${global.business.name}</span></div><h4 align=center>${global.business.addressLine1}</br>""";

      if (global.business.contact1 != null) {
        htmlContent += """${global.country.isoCode} ${global.business.contact1}<br>""";
      }
      if (global.business.email != null && global.business.email != "") {
        htmlContent += """${global.business.email}<br>""";
      }

      if (global.business.website != null && global.business.website != "") {
        htmlContent += """${global.business.website}<br><h4>""";
      }
      // if (global.business.gstNo != null && global.business.gstNo != "") {
      //   htmlContent += """${global.appLocaleValues['lbl_gst_no_']}: ${global.business.gstNo}<br><h4>""";
      // }
      htmlContent += """
  <hr>
  </header>
  """;
      if (quote.quoteTaxList == null) {
        htmlContent += """ <h1 align=center><font size=6>${global.appLocaleValues['lbl_quoteno']}</font></h1> """;
      } else {
        htmlContent += """ <h1 align=center><font size=6>${global.appLocaleValues['lbl_quoteno']}</font></h1> """;
      }
      htmlContent += """
    <h4 style='float: left;'>${global.appLocaleValues['tle_quote_no']}: $_generatedInvoiceNo-${quote.versionNumber}</h4> <p style='float: right'><font size=4>${global.appLocaleValues['lbl_date']}: ${DateFormat(getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(quote.orderDate)}</font></p>
    <p style='float: left;clear: both;'><font size=4>${generateAccountName(quote.account)} ( +${quote.account.mobileCountryCode} ${quote.account.mobile} ) <br>$_address</font></p> 
    <table style='width:100%'>
""";
      if (quote.quoteDetailList.length > 0) {
        htmlContent += """
        <tr>
    <th>#</th>
    <th>${(getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_both']}</th>
    <th>Description</th>
    <th>${global.appLocaleValues['lbl_quantity']}</th>""";

        if (getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          htmlContent += """ <th>${global.appLocaleValues['lbl_unit_code_']}</th> """;
        }

        htmlContent += """
    <th>${global.appLocaleValues['lbl_unit_price_']}</th>
    <th>${global.appLocaleValues['lbl_amount']}</th>
    </tr>
        """;
      }
      quote.quoteDetailList.forEach((item) {
        htmlContent += """
      <tr>
    <td>${(quote.quoteDetailList.indexOf(item)) + 1}</td>
    <td>${item.productName}</td>
      <td>${item.productDescription.replaceAll('\n', '<br>')}</td>
    <td>${item.quantity}</td>""";
        if (getSystemFlagValue(global.systemFlagNameList.enableUnitModule) == "true") {
          htmlContent += """  <td>${item.unitCode}</td>""";
        }

        htmlContent += """
    <td>${global.currency.symbol} ${item.unitPrice.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    <td>${global.currency.symbol} ${item.amount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
    </tr>
      """;
      });

      htmlContent += """
    </table>
    <br>
    <table style='width:50%', align="left" , border: 1px solid black;>
        <tr>
            <td><b>${global.appLocaleValues['lbl_in_words']}:</b></td>
          
        </tr>
        <tr>
          <td><b><font style="color: teal;">${grossAmountInWords.intoSentanseCase()}</font></b></td>
        </tr>
        <tr>
          <td><b>${global.appLocaleValues['lbl_terms_and_condition']}:</b></td>
          
        </tr>
        <tr> """;
      if (getSystemFlagValue(global.systemFlagNameList.termsAndCondition) != null && getSystemFlagValue(global.systemFlagNameList.termsAndCondition) != '') {
        htmlContent += """
        <td><b><font style="color: teal;">${getSystemFlagValue(global.systemFlagNameList.termsAndCondition).replaceAll('\n', '<br>')}</font></b></td>
        </tr>
    """;
      } else {
        htmlContent += """
        <td><b><font style="color: teal;">${global.appLocaleValues['lbl_tnaking_note']}</font></b></td>
        </tr>
    """;
      }

      htmlContent += """
    </table>
    <table style='width:50%',align="right">
            <tr>
                <td><b>${global.appLocaleValues['lbl_sub_total_']}</b></td>
                <td> ${global.currency.symbol} ${quote.grossAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
            </tr>
            <tr>
                    <td><b>${global.appLocaleValues['lbl_discount']}</b></td>
                    <td>${global.currency.symbol} ${quote.discount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                </tr>""";

      if (quote.finalTax != null && quote.finalTax > 0.1) {
        for (int i = 0; i < quote.quoteTaxList.length; i++) {
          if (quote.quoteDetailTaxList.length != 0) {
            htmlContent += """ <tr>
                        <td><b>${quote.quoteTaxList[i].taxName}</b></td>
                        <td>${global.currency.symbol} ${quote.quoteTaxList[i].totalAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                    </tr>
                    """;
          } else {
            htmlContent += """ <tr>
                        <td><b>${quote.quoteTaxList[i].taxName}(${quote.quoteTaxList[i].percentage.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}%)</b></td>
                        <td>${global.currency.symbol} ${quote.quoteTaxList[i].totalAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
                    </tr>
                    """;
          }
        }
      }

      // htmlContent += """
      // <tr>
      //           <td><b>${global.appLocaleValues['lbl_advance']}</b></td>
      //           <td>${global.currency.symbol} ${quote.advanceAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</td>
      //       </tr>
      // """;

      if (quote.status == 'CANCELLED') {
        htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: gray;">${quote.status}</font></td>
                </tr>
      """;
      } else if (quote.status == 'OPEN') {
        htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: red;">${quote.status}</font></td>
                </tr>
      """;
      } else {
        htmlContent += """
       <tr>
                    <td><b>${global.appLocaleValues['lbl_status']}</b></td>
                    <td><font style="color: green;">${quote.status}</font></td>
                </tr>
      """;
      }

      htmlContent += """          <tr>
                            <td style="background-color: teal;color: white;"><b>${global.appLocaleValues['lbl_total']}</b></td>
                            <td style="background-color: teal;color: white;"><b>${global.currency.symbol} ${quote.netAmount.toStringAsFixed(int.parse(getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}</b></td>
                        </tr>
        </table>
        <br>
       """;

      htmlContent += """   
  </body>
  <footer style="bottom: 0;position: relative;width: 100%"> """;
      if (quote.showRemarkInPrint && quote.remark.isNotEmpty) {
        htmlContent += """ <p><b>${global.appLocaleValues['lbl_remark']}:</b> ${quote.remark.replaceAll('\n', '<br>')}</p> """;
      }
      htmlContent += """      <hr>
      <p>${(getSystemFlagValue(global.systemFlagNameList.invoicePdfFooter) != null) ? getSystemFlagValue(global.systemFlagNameList.invoicePdfFooter) : ''}</p>
      </footer>
</html>
      """;

      if (isPrintAction != null) {
        if (isPrintAction) // print invoice
        {
          await printReport(htmlContent);
        } else // share invoice
        {
          String fileName = 'saleQuote${quote.saleQuoteNumber}.pdf';
          await shareReport(htmlContent, fileName, email: quote.account.email, subject: 'Sale Quote #${getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + quote.saleQuoteNumber.toString().length))}${quote.saleQuoteNumber} - ${quote.versionNumber}');
        }
      }
      return htmlContent;
    } catch (e) {
      print('Exception - br.generateSaleOrderHtml(): ' + e.toString());
      return null;
    }
  }

  SystemFlag getSystemFlag(String flagName) {
    try {
      return systemFlagList.where((t) => t.name == flagName).first;
    } catch (e) {
      print('Exception - br.getSystemFlag(): ' + e.toString());
      return null;
    }
  }

  String getSystemFlagValue(String flagName) {
    try {
      var result = systemFlagList.where((t) => t.name == flagName).first.value;
      return (result != null) ? result : '';
    } catch (e) {
      print('Exception - br.getSystemFlagValue(): ' + e.toString());
      return '';
    }
  }

  Future printReport(htmlContent) async {
    final pdf = await Printing.convertHtml(html: htmlContent, format: PdfPageFormat.a4);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf);
  }

  Future shareReport(htmlContent, String fileName, {String email, String subject}) async {
    final pdf = await Printing.convertHtml(html: htmlContent, format: PdfPageFormat.a4);
    await Printing.sharePdf(bytes: pdf, filename: fileName, emails: (email != null && email.isNotEmpty) ? [email] : null, subject: (subject != null && subject.isNotEmpty) ? subject : null);

    // final output = await getTemporaryDirectory();
    // print('path: ${output.path}');
    // final file = File("${output.path}/$fileName");
    // await file.writeAsBytes(pdf);
    // OpenFile.open("${output.path}/$fileName");
  }

  Future updateSystemFlagValue(String flagName, String value) async {
    try {
      systemFlagList.where((t) => t.name == flagName).map((f) => f.value = value).toList();
    } catch (e) {
      print('Exception - br.getSystemFlagValue(): ' + e.toString());
    }
  }

  String generateAccountName(Account account) {
    try {
      String name = '';

      if (account.namePrefix != null && account.namePrefix != '') {
        name += '${account.namePrefix} ';
      }

      if (account.firstName != null && account.firstName != '') {
        name += '${account.firstName} ';
      }

      if (account.middleName != null && account.middleName != '') {
        name += '${account.middleName} ';
      }

      if (account.lastName != null && account.lastName != '') {
        name += '${account.lastName}';
      }

      if (account.nameSuffix != null && account.nameSuffix != '') {
        name += ', ${account.nameSuffix} ';
      }
      return name;
    } catch (e) {
      print('Exception - br.generateAccountName(): ' + e.toString());
      return '';
    }
  }

  String generateAccountAddress(Account account) {
    try {
      String address = '';

      if (account.addressLine1 != '') {
        address += '${account.addressLine1}';
      }

      if (account.addressLine2 != '') {
        if (address.isNotEmpty) {
          address += ', ';
        }
        address += '${account.addressLine2}';
      }

      if (account.city != '') {
        if (address.isNotEmpty) {
          address += ', ';
        }
        address += '${account.city}';
      }

      if (account.state != '') {
        if (address.isNotEmpty) {
          address += ', ';
        }
        address += '${account.state}';
      }

      if (account.country != '') {
        if (address.isNotEmpty) {
          address += ', ';
        }
        address += '${account.country}';
      }

      if (account.pincode != null) {
        if (address.isNotEmpty) {
          address += ', ';
        }
        address += '${account.pincode}';
      }
      return address;
    } catch (e) {
      print('Exception - br.generateAccountAddress(): ' + e.toString());
      return '';
    }
  }

  Future getSharedPreferences() async {
    try {
      global.prefs = await SharedPreferences.getInstance();
    } catch (e) {
      print('Exception - br.getSharedPreferences(): ' + e.toString());
    }
  }

  Future discardRegistrationProcess(context, observer, analytics) async {
    try {
      AlertDialog _dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['lbl_warning'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(global.appLocaleValues['txt_discard_registration']),
        actions: <Widget>[
          TextButton(
            //   textColor: Colors.blue,
            child: Text(global.appLocaleValues['btn_no']),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_yes']),
            onPressed: () async {
              Navigator.of(context).pop();
              DBHelper dbHelper = DBHelper(global.business);
              await dbHelper.taxMasterDelete();
              await dbHelper.businessDelete();
              await dbHelper.userDelete();
              await dbHelper.productTypeDelete();
              global.user = null;
              global.business = null;
              // Navigator.of(context).push(PageTransition(
              //     type: PageTransitionType.rightToLeft,
              //     child: LoginScreen(
              //       a: analytics,
              //       o: observer,
              //     )));
            },
          ),
        ],
      );
      showDialog(builder: (context) => _dialog, context: context);
    } catch (e) {
      print('Exception - br.discardRegistrationProcess(): ' + e.toString());
    }
  }

  Future<bool> disableBackupAndRestore(context, String message) async {
    try {
      bool action;
      AlertDialog _dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['lbl_backup_restore'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('$message'),
        actions: <Widget>[
          TextButton(
            //   textColor: Colors.blue,
            child: Text(global.appLocaleValues['btn_no']),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              action = true;
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_yes']),
            onPressed: () async {
              Navigator.of(context).pop();

              action = false;
            },
          ),
        ],
      );
      await showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
      return action;
    } catch (e) {
      print('Exception - br.disableBackupAndRestore(): ' + e.toString());
      return null;
    }
  }

  Future<bool> authenticate() async {
    try {
      var auth = LocalAuthentication();
      bool _isAuthenticated = await auth.authenticateWithBiometrics(localizedReason: global.appLocaleValues['desc_auth_finger_print'], useErrorDialogs: true, stickyAuth: true);
      return _isAuthenticated;
    } on PlatformException catch (e) {
      print('Exception - br.authenticate(): ' + e.toString());
      return false;
    }
  }

  Future updateSystemFlag(String flagName, String value) async {
    try {
      DBHelper dbHelper = DBHelper(global.business);
      int result = await dbHelper.systemFlagUpdateValue(flagName, value);
      if (result == 1) {
        updateSystemFlagValue(flagName, value);
      }
    } catch (e) {
      print('Exception - br.updateSystemFlag(): ' + e.toString());
      return null;
    }
  }

  Future<List<dynamic>> systemLanguageGetList() async {
    try {
      final jsonString = await rootBundle.loadString('assets/locales/languages.json');
      var result = jsonDecode(jsonString);
      return result;
    } catch (e) {
      print('BusinessRule - systemLanguageGetList() Error: ' + e.toString());
    }
    return null;
  }

  Future<bool> setSystemLanguage() async {
    try {
      final jsonString = await rootBundle.loadString('assets/locales/${global.appLanguage['file']}');
      global.appLocaleValues = jsonDecode(jsonString);
      return true;
    } catch (e) {
      print('BusinessRule - setSystemLanguage() Error: ' + e.toString());
    }
    return false;
  }

  Future<SaleInvoice> generateInvoice(SaleQuote _salesQuote, DBHelper _dbHelper) async {
    try {
      SaleInvoice _saleInvoice = SaleInvoice();
      // List<PaymentSaleOrder> _paymentSaleOrderList = [];
      // List<SaleQuoteInvoice> _saleQuoteInvoiceList = await _dbHelper.saleQuotesInvoiceGetList(saleQuoteIdList: [_salesQuote.id]);
      _saleInvoice.account = _salesQuote.account;
      _salesQuote.quoteTaxList = await _dbHelper.saleQuoteTaxGetList(saleQuoteId: _salesQuote.id);
      _salesQuote.quoteDetailList = await _dbHelper.saleQuoteDetailGetList(orderIdList: [_salesQuote.id]);
      _salesQuote.quoteDetailTaxList = await _dbHelper.saleQuoteDetailTaxGetList(quoteDetailIdList: _salesQuote.quoteDetailList.map((e) => e.id).toList());
      // if (_saleQuoteInvoiceList.length < 1) {
      //   _paymentSaleOrderList = await _dbHelper.paymentSaleOrderGetList(orderIdList: [_salesQuote.id]);
      //   _salesQuote.payment.paymentDetailList = (_paymentSaleOrderList.length > 0) ? await _dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleOrderList.map((e) => e.paymentId).toList()) : [];
      // }

      _saleInvoice.accountId = _salesQuote.accountId;
      _saleInvoice.invoiceDate = _salesQuote.orderDate;
      _saleInvoice.deliveryDate = _salesQuote.deliveryDate;
      _saleInvoice.voucherNumber = _salesQuote.voucherNumber;
      _saleInvoice.discount = _salesQuote.discount;
      _saleInvoice.taxGroup = _salesQuote.taxGroup;
      _saleInvoice.remark = _salesQuote.remark;
      _saleInvoice.showRemarkInPrint = _salesQuote.showRemarkInPrint;

      _salesQuote.quoteDetailList.forEach((element) {
        if (element.quantity != element.invoicedQuantity) {
          SaleInvoiceDetail _obj = SaleInvoiceDetail(null, null, element.productId, element.unitId, element.productUnitId, element.unitCode, element.quantity - element.invoicedQuantity, element.unitPrice, (element.quantity - element.invoicedQuantity) * element.unitPrice, element.productName, element.productCode, element.productTypeName, element.actualUnitPrice, false, null, null, element.productDescription);
          _saleInvoice.invoiceDetailList.add(_obj);
        }
      });

      _salesQuote.quoteTaxList.forEach((element) {
        SaleInvoiceTax _obj = SaleInvoiceTax(null, null, element.taxId, element.percentage, element.totalAmount);
        _obj.taxName = element.taxName;
        _saleInvoice.invoiceTaxList.add(_obj);
      });

      _salesQuote.quoteDetailTaxList.forEach((element) {
        SaleInvoiceDetailTax _obj = SaleInvoiceDetailTax(null, null, element.taxId, element.percentage, element.taxAmount);
        // _obj.taxName = element.taxName;
        _saleInvoice.invoiceDetailTaxList.add(_obj);
      });

      // if (_saleQuoteInvoiceList.length < 1) {
      //   _saleInvoice.payment = _salesQuote.payment;
      // }
      _saleInvoice.saleQuoteList.add(_salesQuote);
      return _saleInvoice;
    } catch (e) {
      print('Exception - BusinessRule.dart - generateInvoice(): ' + e.toString());
      return SaleInvoice();
    }
  }

  Future<SaleInvoice> generateInvoiceFromOrder(SaleOrder _salesOrder, DBHelper _dbHelper) async {
    try {
       SaleInvoice _saleInvoice = SaleInvoice();
      // List<PaymentSaleOrder> _paymentSaleOrderList = [];
      // List<SaleQuoteInvoice> _saleQuoteInvoiceList = await _dbHelper.saleQuotesInvoiceGetList(saleQuoteIdList: [_salesQuote.id]);
      _saleInvoice.account = _salesOrder.account;
      _salesOrder.orderTaxList = await _dbHelper.saleOrderTaxGetList(saleOrderId: _salesOrder.id);
      _salesOrder.orderDetailList = await _dbHelper.saleOrderDetailGetList(orderIdList: [_salesOrder.id]);
      _salesOrder.orderDetailTaxList = await _dbHelper.saleOrderDetailTaxGetList(orderDetailIdList: _salesOrder.orderDetailList.map((e) => e.id).toList());
       List<PaymentSaleOrder> _paymentSaleOrderList = await _dbHelper.paymentSaleOrderGetList(orderIdList: [_salesOrder.id], isCancel: false);
      List<Payment> _paymentList = await _dbHelper.paymentGetList(paymentIdList: _paymentSaleOrderList.map((paymentorder) => paymentorder.paymentId).toList());
      List<PaymentDetail> _paymentDetailList = await _dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleOrderList.map((paymentorder) => paymentorder.paymentId).toList());
      // if (_saleQuoteInvoiceList.length < 1) {
      //   _paymentSaleOrderList = await _dbHelper.paymentSaleOrderGetList(orderIdList: [_salesQuote.id]);
      //   _salesQuote.payment.paymentDetailList = (_paymentSaleOrderList.length > 0) ? await _dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleOrderList.map((e) => e.paymentId).toList()) : [];
      // }

      _saleInvoice.accountId = _salesOrder.accountId;
      _saleInvoice.invoiceDate = _salesOrder.orderDate;
      _saleInvoice.deliveryDate = _salesOrder.deliveryDate;
      _saleInvoice.voucherNumber = _salesOrder.voucherNumber;
      _saleInvoice.discount = _salesOrder.discount;
      _saleInvoice.taxGroup = _salesOrder.taxGroup;
      _saleInvoice.remark = _salesOrder.remark;
      _saleInvoice.showRemarkInPrint = _salesOrder.showRemarkInPrint;

      _salesOrder.orderDetailList.forEach((element) {
        if (element.quantity != element.invoicedQuantity) {
          SaleInvoiceDetail _obj = SaleInvoiceDetail(null, null, element.productId, element.unitId, element.productUnitId, element.unitCode, element.quantity - element.invoicedQuantity, element.unitPrice, (element.quantity - element.invoicedQuantity) * element.unitPrice, element.productName, element.productCode, element.productTypeName, element.actualUnitPrice, false, null, null, element.productDescription);
          _saleInvoice.invoiceDetailList.add(_obj);
        }
      });

      _salesOrder.orderTaxList.forEach((element) {
        SaleInvoiceTax _obj = SaleInvoiceTax(null, null, element.taxId, element.percentage, element.totalAmount);
        _obj.taxName = element.taxName;
        _saleInvoice.invoiceTaxList.add(_obj);
      });

      _salesOrder.orderDetailTaxList.forEach((element) {
        SaleInvoiceDetailTax _obj = SaleInvoiceDetailTax(null, null, element.taxId, element.percentage, element.taxAmount);
        // _obj.taxName = element.taxName;
        _saleInvoice.invoiceDetailTaxList.add(_obj);
      });

      
      if (_paymentList != null && _paymentList.length > 0) {
        Payment _payment = Payment();
        _payment.accountId = _salesOrder.accountId;
        _payment.amount = _paymentDetailList.map((e) => e.amount).reduce((a, b) => a + b);
        _payment.transactionDate = _salesOrder.orderDate;
        _payment.paymentType = "RECEIVED";
        _payment.businessId = global.business.id;

        _payment.paymentDetailList = [];
        for(int i = 0; i < _paymentDetailList.length; i++)
        {
          _payment.paymentDetailList.add(PaymentDetail(null, null, _paymentDetailList[i].amount, _paymentDetailList[i].paymentMode, _paymentDetailList[i].remark, false, DateTime.now(), DateTime.now()));
        }

        _saleInvoice.payment = _payment;
      }

      // if (_saleQuoteInvoiceList.length < 1) {
      //   _saleInvoice.payment = _salesQuote.payment;
      // }
      _saleInvoice.saleOrderList.add(_salesOrder);
      return _saleInvoice;
      // SaleInvoice _saleInvoice = SaleInvoice();
      // // List<PaymentSaleOrder> _paymentSaleOrderList = [];
      // // List<SaleQuoteInvoice> _saleQuoteInvoiceList = await _dbHelper.saleQuotesInvoiceGetList(saleQuoteIdList: [_salesQuote.id]);
      // _saleInvoice.account = _salesOrder.account;
      // _salesOrder.orderTaxList = await _dbHelper.saleOrderTaxGetList(saleOrderId: _salesOrder.id);
      // _salesOrder.orderDetailList = await _dbHelper.saleOrderDetailGetList(orderIdList: [_salesOrder.id]);
      // _salesOrder.orderDetailTaxList = await _dbHelper.saleOrderDetailTaxGetList(orderDetailIdList: _salesOrder.orderDetailList.map((e) => e.id).toList());
      // List<PaymentSaleOrder> _paymentSaleOrderList = await _dbHelper.paymentSaleOrderGetList(orderIdList: [_salesOrder.id], isCancel: false);
      // List<Payment> _paymentList = await _dbHelper.paymentGetList(paymentIdList: _paymentSaleOrderList.map((paymentorder) => paymentorder.paymentId).toList());
      // List<PaymentDetail> _paymentDetailList = await _dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleOrderList.map((paymentorder) => paymentorder.paymentId).toList());

      // _saleInvoice.accountId = _salesOrder.accountId;
      // _saleInvoice.invoiceDate = _salesOrder.orderDate;
      // _saleInvoice.deliveryDate = _salesOrder.deliveryDate;
      // _saleInvoice.voucherNumber = _salesOrder.voucherNumber;
      // _saleInvoice.discount = _salesOrder.discount;
      // _saleInvoice.finalTax = _salesOrder.finalTax;
      // _saleInvoice.netAmount = _salesOrder.netAmount;
      // _saleInvoice.grossAmount = _salesOrder.grossAmount;
      // _saleInvoice.taxGroup = _salesOrder.taxGroup;
      // _saleInvoice.remark = _salesOrder.remark;
      // _saleInvoice.showRemarkInPrint = _salesOrder.showRemarkInPrint;


      // _salesOrder.orderDetailList.forEach((element) {
      //   // if (element.quantity != element.invoicedQuantity) {
      //     SaleInvoiceDetail _obj = SaleInvoiceDetail(null, null, element.productId, element.unitId, element.productUnitId, element.unitCode, element.quantity, element.unitPrice, element.quantity * element.unitPrice, element.productName, element.productCode, element.productTypeName, element.actualUnitPrice, false, null, null, element.productDescription);
      //     _saleInvoice.invoiceDetailList.add(_obj);
      //   // }
      // });

      // _salesOrder.orderTaxList.forEach((element) {
      //   SaleInvoiceTax _obj = SaleInvoiceTax(null, null, element.taxId, element.percentage, element.totalAmount);
      //   _obj.taxName = element.taxName;
      //   _saleInvoice.invoiceTaxList.add(_obj);
      // });

      // _salesOrder.orderDetailTaxList.forEach((element) {
      //   SaleInvoiceDetailTax _obj = SaleInvoiceDetailTax(null, null, element.taxId, element.percentage, element.taxAmount);
      //   // _obj.taxName = element.taxName;
      //   _saleInvoice.invoiceDetailTaxList.add(_obj);
      // });

      // if (_paymentList != null && _paymentList.length > 0) {
      //   Payment _payment = Payment();
      //   _payment.accountId = _salesOrder.accountId;
      //   _payment.amount = _paymentDetailList.map((e) => e.amount).reduce((a, b) => a + b);
      //   _payment.transactionDate = _salesOrder.orderDate;
      //   _payment.paymentType = "RECEIVED";
      //   _payment.businessId = global.business.id;

      //   _payment.paymentDetailList = [];
      //   for(int i = 0; i < _paymentDetailList.length; i++)
      //   {
      //     _payment.paymentDetailList.add(PaymentDetail(null, null, _paymentDetailList[i].amount, _paymentDetailList[i].paymentMode, _paymentDetailList[i].remark, false, DateTime.now(), DateTime.now()));
      //   }

      //   _saleInvoice.payment = _payment;
      // }

      // // if (_saleQuoteInvoiceList.length < 1) {
      // //   _saleInvoice.payment = _salesQuote.payment;
      // // }
      // // _saleInvoice.saleQuoteList.add(_salesQuote);
      // return _saleInvoice;
    } catch (e) {
      print('Exception - BusinessRule.dart - generateInvoiceFromOrder(): ' + e.toString());
      return SaleInvoice();
    }
  }

  Future<SaleOrder> generateOrder(SaleQuote _salesQuote, DBHelper _dbHelper) async {
    try {
      SaleOrder _obj = SaleOrder();
      // List<PaymentSaleOrder> _paymentSaleOrderList = [];
      // List<SaleQuoteInvoice> _saleQuoteInvoiceList = await _dbHelper.saleQuoteInvoiceGetList(saleQuoteIdList: [_salesQuote.id]);
      _obj.account = _salesQuote.account;
      _salesQuote.quoteTaxList = await _dbHelper.saleQuoteTaxGetList(saleQuoteId: _salesQuote.id);
      _salesQuote.quoteDetailList = await _dbHelper.saleQuoteDetailGetList(orderIdList: [_salesQuote.id]);
      _salesQuote.quoteDetailTaxList = await _dbHelper.saleQuoteDetailTaxGetList(quoteDetailIdList: _salesQuote.quoteDetailList.map((e) => e.id).toList());
      // if (_saleQuoteInvoiceList.length < 1) {
      //   _paymentSaleOrderList = await _dbHelper.paymentSaleOrderGetList(orderIdList: [_salesQuote.id]);
      //   _salesQuote.payment.paymentDetailList = (_paymentSaleOrderList.length > 0) ? await _dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleOrderList.map((e) => e.paymentId).toList()) : [];
      // }

      _obj.accountId = _salesQuote.accountId;
      _obj.orderDate = _salesQuote.orderDate;
      _obj.deliveryDate = _salesQuote.deliveryDate;
      _obj.voucherNumber = _salesQuote.voucherNumber;
      _obj.discount = _salesQuote.discount;
      _obj.taxGroup = _salesQuote.taxGroup;
      _obj.remark = _salesQuote.remark;
      _obj.showRemarkInPrint = _salesQuote.showRemarkInPrint;

      _salesQuote.quoteDetailList.forEach((element) {
        if (element.quantity != element.invoicedQuantity) {
          SaleOrderDetail _objTemp = SaleOrderDetail(
            null,
            null,
            element.productId,
            element.unitId,
            element.productUnitId,
            element.unitCode,
            element.quantity - element.invoicedQuantity,
            0,
            element.unitPrice,
            (element.quantity - element.invoicedQuantity) * element.unitPrice,
            element.productName,
            element.productCode,
            element.productTypeName,
            element.actualUnitPrice,
            false,
            null,
            null,
            element.productDescription,
          );
          _obj.orderDetailList.add(_objTemp);
        }
      });

      _salesQuote.quoteTaxList.forEach((element) {
        SaleOrderTax _objTemp = SaleOrderTax(null, null, element.taxId, element.percentage, element.totalAmount);
        _objTemp.taxName = element.taxName;
        _obj.orderTaxList.add(_objTemp);
      });

      _salesQuote.quoteDetailTaxList.forEach((element) {
        SaleOrderDetailTax _obj1 = SaleOrderDetailTax(null, null, element.taxId, element.percentage, element.taxAmount);
        // _obj.taxName = element.taxName;
        _obj.orderDetailTaxList.add(_obj1);
      });
      // if (_saleQuoteInvoiceList.length < 1) {
      //   _obj.payment = _salesQuote.payment;
      // }
      _obj.saleQuoteList.add(_salesQuote);
      return _obj;
    } catch (e) {
      print('Exception - BusinessRule.dart - generateOrder(): ' + e.toString());
      return SaleOrder();
    }
  }

  Future<SaleInvoice> generateSalesQuotesInvoice(SaleQuote _saleQuote, _dbHelper) async {
    try {
      SaleInvoice _saleInvoice = SaleInvoice();
      // List<PaymentSaleQuotes> _paymentSaleQuoteList = [];
      List<SaleQuoteInvoice> _saleQuoteInvoiceList = await _dbHelper.saleQuoteInvoiceGetList(saleQuoteIdList: [_saleQuote.id]);
      _saleInvoice.account = _saleQuote.account;
      _saleQuote.quoteTaxList = await _dbHelper.saleQuoteTaxGetList(saleQuoteId: _saleQuote.id);
      _saleQuote.quoteDetailList = await _dbHelper.saleQuoteDetailGetList(orderIdList: [_saleQuote.id]);
      _saleQuote.quoteDetailTaxList = await _dbHelper.saleQuoteDetailTaxGetList(quoteDetailIdList: _saleQuote.quoteDetailList.map((e) => e.id).toList());
      // if (_saleQuoteInvoiceList.length < 1) {
      //   _paymentSaleQuoteList = await _dbHelper.paymentSaleQuoteGetList(orderIdList: [_saleQuote.id]);
      //    _saleQuote.payment.paymentDetailList = (_paymentSaleQuoteList.length > 0) ? await _dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleQuoteList.map((e) => e.paymentId).toList()) : [];
      // }

      _saleInvoice.accountId = _saleQuote.accountId;
      _saleInvoice.invoiceDate = _saleQuote.orderDate;
      _saleInvoice.deliveryDate = _saleQuote.deliveryDate;
      _saleInvoice.voucherNumber = _saleQuote.voucherNumber;
      _saleInvoice.discount = (_saleQuoteInvoiceList.length < 1) ? _saleQuote.discount : 0;
      _saleInvoice.taxGroup = _saleQuote.taxGroup;
      _saleInvoice.remark = _saleQuote.remark;
      _saleInvoice.grossAmount = _saleQuote.grossAmount;
      _saleInvoice.netAmount = _saleQuote.netAmount;
      _saleInvoice.status = _saleQuote.status;
      _saleInvoice.versionNumber = _saleQuote.versionNumber;
      _saleQuote.quoteDetailList.forEach((element) {
        if (element.quantity != element.invoicedQuantity) {
          SaleInvoiceDetail _obj = SaleInvoiceDetail(null, null, element.productId, element.unitId, element.productUnitId, element.unitCode, element.quantity - element.invoicedQuantity, element.unitPrice, (element.quantity - element.invoicedQuantity) * element.unitPrice, element.productName, element.productCode, element.productTypeName, element.actualUnitPrice, false, null, null, element.productDescription);
          _saleInvoice.invoiceDetailList.add(_obj);
        }
      });

      _saleQuote.quoteTaxList.forEach((element) {
        SaleInvoiceTax _obj = SaleInvoiceTax(null, null, element.taxId, element.percentage, element.totalAmount);
        _obj.taxName = element.taxName;
        _saleInvoice.invoiceTaxList.add(_obj);
      });

      // if (_saleQuoteInvoiceList.length < 1) {
      //   _saleInvoice.payment = _saleQuote.payment;
      // }
      _saleInvoice.saleQuoteList.add(_saleQuote);
      return _saleInvoice;
    } catch (e) {
      print('Exception - BusinessRule.dart - generateSalesQuotesInvoice(): ' + e.toString());
      return SaleInvoice();
    }
  }

  Future<String> chooseFinantialMonth(context, String _oldValue) async {
    try {
      String value = '';
      List<String> _finantialMonthValueList = getSystemFlag(global.systemFlagNameList.financialMonth).valueList.split(',').toList();
      AlertDialog dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['dia_lbl_financial_month'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width - 40,
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _finantialMonthValueList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text('${_finantialMonthValueList[index]}'),
                      onTap: () async {
                        Navigator.of(context).pop();
                        value = _finantialMonthValueList[index];
                      },
                    ),
                    Divider()
                  ],
                );
              },
            ),
          ),
        ),
      );
      await showDialog(builder: (context) => dialog, context: context);
      return (value != '') ? value : _oldValue;
    } catch (e) {
      print('Exception - BusinessRule.dart - chooseFinantialMonth(): ' + e.toString());
      return null;
    }
  }

  List<FinancialYear> generateFinancialYearList() {
    try {
      List<FinancialYear> _financialYearList = [];
      int _minYear = global.user.createdAt.year;
      int _maxYear = DateTime.now().year;
      int _loopTimes = _maxYear - _minYear;
      if (global.user.createdAt.month < generateMonthNumber(getSystemFlagValue(global.systemFlagNameList.financialMonth))) // if user registered before financial month
      {
        FinancialYear _obj = FinancialYear(_minYear - 1, _minYear);
        _financialYearList.add(_obj);
      }
      for (int i = 0; i < _loopTimes; i++) {
        if (i > 0) {
          _minYear += 1;
        }
        if (_minYear < _maxYear) {
          FinancialYear _obj = FinancialYear(_minYear, _minYear + 1);
          _financialYearList.add(_obj);
        }
      }

      if (DateTime.now().month > generateMonthNumber(getSystemFlagValue(global.systemFlagNameList.financialMonth))) // if financial month is running or gone
      {
        FinancialYear _obj = FinancialYear(_maxYear, _maxYear + 1);
        _financialYearList.add(_obj);
      }
      return _financialYearList;
    } catch (e) {
      print('Exception - BusinessRule.dart - generateFinancialYearList(): ' + e.toString());
      return null;
    }
  }

  dynamic generateMonthNumber(String monthName) {
    try {
      // if (monthNumber != null) {
      //   switch (monthNumber) {
      //     case 1:
      //       return "January";
      //       break;

      //     case 2:
      //       return "February";
      //       break;

      //     case 3:
      //       return "March";
      //       break;

      //     case 4:
      //       return "April";
      //       break;

      //     case 5:
      //       return "May";
      //       break;

      //     case 6:
      //       return "June";
      //       break;

      //     case 7:
      //       return "July";
      //       break;

      //     case 8:
      //       return "August";
      //       break;

      //     case 9:
      //       return "September";
      //       break;

      //     case 10:
      //       return "October";
      //       break;

      //     case 11:
      //       return "November";
      //       break;

      //     case 12:
      //       return "December";
      //       break;
      //   }
      // } else {
      switch (monthName) {
        case "January":
          return 1;
          break;

        case "February":
          return 2;
          break;

        case "March":
          return 3;
          break;

        case "April":
          return 4;
          break;

        case "May":
          return 5;
          break;

        case "June":
          return 6;
          break;

        case "July":
          return 7;
          break;

        case "August":
          return 8;
          break;

        case "September":
          return 9;
          break;

        case "October":
          return 10;
          break;

        case "November":
          return 11;
          break;

        case "December":
          return 12;
          break;
        //    }
      }
      return null;
    } catch (e) {
      print('Exception - BusinessRule.dart - generateMonthName(): ' + e.toString());
      return null;
    }
  }

  Future getUserInfo(User account, AuthProfile authProfile, bool locationPermission) async {
    OAuthUser user = OAuthUser();
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Map<String, dynamic> deviceData = {
        "deviceModel": androidInfo.model,
        "deviceManufacturer": androidInfo.manufacturer,
        "deviceId": androidInfo.androidId,
        // "deviceLocation": (locationPermission) ? await getCurrentLocation() : null,
        "deviceLocation": null,
      };

      user.firstName = account.firstName;
      user.lastName = account.lastName;
      user.email = account.email;
      user.phone = account.mobile.toString();
      user.authProfile = authProfile;
      user.deviceData = deviceData;
    } catch (e) {
      print('BusinessRule.dart - getUserInfo(): ' + e.toString());
    }
    return user;
  }

  // Future<LocationData> getCurrentLocation() async {
  //   LocationData currentLocation;
  //   try {
  //     Location location =  Location();
  //     bool _serviceEnabled;
  //     _serviceEnabled = await location.serviceEnabled();
  //     if (!_serviceEnabled) {
  //       _serviceEnabled = await location.requestService();
  //       print('_serviceEnabled In: $_serviceEnabled');
  //       if (!_serviceEnabled) {
  //         print(" !_serviceEnabled");
  //       }
  //     }
  //     print('_serviceEnabled Out: $_serviceEnabled');
  //     // _permissionGranted = await location.hasPermission();
  //     // if (_permissionGranted == PermissionStatus.denied) {
  //     //   _permissionGranted = await location.requestPermission();
  //     //   if (_permissionGranted != PermissionStatus.granted) {
  //     //     print("_permissionGranted != PermissionStatus.granted");
  //     //   }
  //     // }
  //     if (_serviceEnabled) {
  //       try {
  //         currentLocation = await location.getLocation();
  //       } catch (e) {
  //         if (e.code == "PERMISSION_DENIED") {
  //           print('BusinessRule.dart - getCurrentLocation() - PERMISSION_DENIED: ' + e.toString());
  //         } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
  //           print('BusinessRule.dart - getCurrentLocation() - PERMISSION_DENIED_NEVER_ASK: ' + e.toString());
  //         }
  //         print('BusinessRule.dart - getCurrentLocation(): ' + e.toString());
  //         currentLocation = null;
  //       }
  //     } else {
  //       currentLocation = null;
  //     }
  //     //result.addAll({"currentLocation":currentLocation, "error":error});
  //     return currentLocation;
  //   } catch (e) {
  //     print("Exception  - businessRule.dart - getCurrentLocation():" + e.toString());
  //     currentLocation = null;
  //     return currentLocation;
  //   }
  // }

  Future<bool> sendEmail(String to, String cc, String subject, String bodyText, {List<email.Attachment> attachments}) async {
    bool result = false;
    try {
      final smtpServer = SmtpServer(global.hostName, username: global.username, password: global.password, port: global.port, allowInsecure: global.allowInsecure);
      final message = email.Message();
      message.from = email.Address(global.username, global.appName);
      message.recipients.add(to);
      if (cc != null && cc.isNotEmpty) {
        message.ccRecipients.add(cc);
      }
      message.subject = subject;
      message.text = bodyText;
      if (attachments != null && attachments.isNotEmpty) {
        message.attachments = attachments;
      }

      try {
        final sendReport = await email.send(message, smtpServer);
        result = true;
        print('Message sent: ' + sendReport.toString());
      } on email.MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
// // Create a smtp client that will persist the connection
//       var connection = email.PersistentConnection(smtpServer);

//       // Send the first message
//       await connection.send(message);

//       // close the connection
//       await connection.close();
    } catch (e) {
      print("Exception - businessRule.dart - sendEmail():" + e.toString());
    }
    return result;
  }

  // String decrypt(String cipherText) {
  //   try {
  //     if (cipherText != null && cipherText.isNotEmpty) {
  //       enc.Key key =  enc.Key.fromUtf8(global.globalEncryptionKey);
  //       final encrypter = enc.Encrypter(enc.AES(key));
  //       enc.Encrypted encrypted =  enc.Encrypted.fromBase64(cipherText);
  //       return encrypter.decrypt(encrypted, iv: iv);
  //     }
  //   } catch (e) {
  //     print("Exception - businessRule.dart - decrypt():" + e.toString());
  //   }
  //   return null;
  // }

  // String encrypt(String plainText) {
  //   try {
  //     if (plainText != null && plainText.isNotEmpty) {
  //       enc.Key key =  enc.Key.fromUtf8(global.globalEncryptionKey);
  //       final encrypter = enc.Encrypter(enc.AES(key));
  //       return encrypter.encrypt(plainText, iv: iv).base64;
  //     }
  //   } catch (e) {
  //     print("Exception - businessRule.dart - encrypt():" + e.toString());
  //   }
  //   return null;
  // }

  Future<String> generatePdf(String filesDirectoryPath) async {
    try {
      List<Asset> result = await MultiImagePicker.pickImages(maxImages: 10, enableCamera: true, cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"));
      if (result != null) {
        String tempDirectory = '$filesDirectoryPath/temp';
        if (FileSystemEntity.typeSync(tempDirectory) == FileSystemEntityType.notFound) {
          await Directory(tempDirectory).create(recursive: true);
        }
        final pdf = pd.Document(compress: true);
        for (int i = 0; i < result.length; i++) {
          String filePath = '$tempDirectory/${result.elementAt(i).name.toString()}';
          ByteData imgByteData = await result[i].getByteData(quality: 40);
          await _writeToFileByteData(imgByteData, filePath);
          if (await File(filePath).exists()) {}
          final image = pd.MemoryImage(
            File(filePath).readAsBytesSync(),
          );
          //  pdfImageFromImageProvider(pdf: pdf.document, image: FileImage(File(filePath)));
          pdf.addPage(
            pd.Page(
                pageFormat: PdfPageFormat.a4,
                build: (pd.Context context) {
                  return pd.Center(child: pd.Image(image));
                }),
          );
        }

        try {
          // Future<Uint8List> fileData = pdf.save();
          if (FileSystemEntity.typeSync(filesDirectoryPath) == FileSystemEntityType.notFound) {
            await Directory(filesDirectoryPath).create(recursive: true);
          }
          String imgid = DateFormat('ddMMyyyyHHmmsst').format(DateTime.now());
          String pdfFilePath = '$tempDirectory/doc$imgid.pdf';
          await _writeToFile(await pdf.save(), pdfFilePath);
          return pdfFilePath;
        } catch (e) {
          print('Save PDF Error: ' + e.toString());
        }
        await Directory(tempDirectory).delete(recursive: true);
      }
    } on PlatformException catch (e) {
      print('Exception - businessRule.dart - platformException - generatePdf(): ' + e.toString());
    } catch (e) {
      print('Exception - businessRule.dart - generatePdf(): ' + e.toString());
    }
    return null;
  }

  Future<void> _writeToFile(var data, String path) {
    try {
      print('Step _writeToFile 1');
      return File(path).writeAsBytes(data);
    } catch (e) {
      print('Exception - businessRule.dart - _writeToFile(): ' + e.toString());
    }
    return null;
  }

  Future<void> _writeToFileByteData(ByteData data, String path) {
    try {
      final buffer = data.buffer;
      print('Step _writeToFileByteData 1');
      return File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    } catch (e) {
      print('Exception - businessRule.dart - _writeToFileByteData(): ' + e.toString());
    }
    return null;
  }

  Future<String> openGallery(String directoryPath, Color color) async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile _selectedImage = await _picker.pickImage(source: ImageSource.gallery);
      File imageFile = File(_selectedImage.path);
      global.isAppOperation = true;
      if (_selectedImage != null) {
        File croppedFile = await ImageCropper.cropImage(
          sourcePath: _selectedImage.path,
          androidUiSettings: AndroidUiSettings(
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
            backgroundColor: Colors.grey,
            toolbarColor: Colors.grey[100],
            toolbarWidgetColor: color,
            activeControlsWidgetColor: color,
            cropFrameColor: color,
          ),
        );

        if (croppedFile != null) {
          imageFile = croppedFile;
          String tempDirectory = '$directoryPath/temp';
          if (!await Directory(tempDirectory).exists()) {
            await Directory(tempDirectory).create();
          }
          String imgid = DateFormat('ddMMyyyyHHmmsst').format(DateTime.now());
          final File newImage = await imageFile.copy('$tempDirectory/img$imgid.png');
          return newImage.path;
        }
      }
    } catch (e) {
      print("Exception - businessRule.dart - _openGallery()" + e.toString());
    }
    return null;
  }

  Future<String> openCamera(String directoryPath, Color color) async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile _selectedImage = await _picker.pickImage(source: ImageSource.camera);
      File imageFile = File(_selectedImage.path);
      global.isAppOperation = true;
      if (_selectedImage != null) {
        File _croppedFile = await ImageCropper.cropImage(
          sourcePath: _selectedImage.path,
          androidUiSettings: AndroidUiSettings(
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
            backgroundColor: Colors.grey,
            toolbarColor: Colors.grey[100],
            toolbarWidgetColor: color,
            activeControlsWidgetColor: color,
            cropFrameColor: color,
          ),
        );
        if (_croppedFile != null) {
          imageFile = _croppedFile;
          String tempDirectory = '$directoryPath/temp';
          if (!await Directory(tempDirectory).exists()) {
            await Directory(tempDirectory).create();
          }
          String imgid = DateFormat('ddMMyyyyHHmmsst').format(DateTime.now());
          final File newImage = await imageFile.copy('$tempDirectory/img$imgid.png');
          return newImage.path;
        }
      }
    } catch (e) {
      print("Exception - businessRule.dart - _openCamera():" + e.toString());
    }
    return null;
  }

  Future<bool> saveFile(String currentPath, String newPath) async {
    try {
      File file = File(currentPath);
      if (await file.exists()) {
        file.copy(newPath);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Exception - businessRule.dart - saveFile():" + e.toString());
    }
    return false;
  }

  Future deleteFile(String path) async {
    try {
      final dir = Directory(path);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      print('Exception - businessRule.dart - deleteFile(): ' + e.toString());
    }
  }

  Future<String> openFileExplorer(String directoryPath) async {
    try {
      FilePickerResult _selectedFile = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          onFileLoading: (_) async {
            // showLoader("Adding file");
          });

      if (_selectedFile != null) {
        String tempDirectory = '$directoryPath/temp';
        if (!await Directory(tempDirectory).exists()) {
          await Directory(tempDirectory).create();
        }
        File file = File(_selectedFile.files.single.path);

        String imgid = DateFormat('ddMMyyyyHHmmsst').format(DateTime.now());
        File docfile = await file.copy('$tempDirectory/doc$imgid.pdf');
        return docfile.path;
      }
    } catch (e) {
      print(" Exception - businessRule.dart - openFileExplorer():" + e.toString());
    }
    return null;
  }

  Future rescheduleNotification(bool reminderTime, dbHelper) async {
    try {
      //   var a = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      // var b = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
      // print(a.length);
      // print(a.toList());

      String _notificationTime = getSystemFlagValue(global.systemFlagNameList.notificationTime);
      TimeOfDay tod = stringToTimeOfDay(_notificationTime);

      List<SaleOrder> _saleOrderList = await dbHelper.saleOrderGetList();
      List<Account> _acccountList = await dbHelper.accountGetList();
      for (int a = 0; a < _acccountList.length; a++) {
        if (_acccountList[a].birthdate != null && _acccountList[a].anniversary != null && _acccountList[a].birthdate.month == _acccountList[a].anniversary.month && _acccountList[a].birthdate.day == _acccountList[a].anniversary.day) {
          int notificationId = int.parse(global.moduleIds['Account'].toString() + '01' + _acccountList[a].id.toString());
          scheduleNotification(notificationId, getNextEventDate(_acccountList[a].birthdate).add(Duration(hours: tod.hour, minutes: tod.minute)), '${_acccountList[a].firstName} ${_acccountList[a].lastName}\'s Birthday & Anniversary', 'on ${DateFormat('MMMM dd').format(_acccountList[a].birthdate)}', '{"module":"Account","id":"${_acccountList[a].id}"}');
        } else {
          if (_acccountList[a].birthdate != null) {
            int notificationId = int.parse(global.moduleIds['Account'].toString() + '02' + _acccountList[a].id.toString());
            scheduleNotification(notificationId, getNextEventDate(_acccountList[a].birthdate).add(Duration(hours: tod.hour, minutes: tod.minute)), '${_acccountList[a].firstName} ${_acccountList[a].lastName}\'s Birthday', 'on ${DateFormat('MMMM dd').format(_acccountList[a].birthdate)}', '{"module":"Account","id":"${_acccountList[a].id}"}');
          }
          if (_acccountList[a].anniversary != null) {
            int notificationId = int.parse(global.moduleIds['Account'].toString() + '03' + _acccountList[a].id.toString());
            scheduleNotification(notificationId, getNextEventDate(_acccountList[a].anniversary).add(Duration(hours: tod.hour, minutes: tod.minute)), '${_acccountList[a].firstName} ${_acccountList[a].lastName}\'s Anniversary', 'on ${DateFormat('MMMM dd').format(_acccountList[a].anniversary)}', '{"module":"Account","id":"${_acccountList[a].id}"}');
          }
        }
      }
      for (int d = 0; d < _saleOrderList.length; d++) {
        if (_saleOrderList[d].deliveryDate != null) {
          // int notificationId = int.parse(global.moduleIds['SaleOrder'].toString() + '01' + _saleOrderList[d].id.toString());
          // await scheduleNotification(notificationId, _saleOrderList[d].deliveryDate.add( Duration(hours: tod.hour, minutes: tod.minute)), 'Sale order delivery', 'Today ${DateFormat('MMMM dd').format(_saleOrderList[d].deliveryDate)}', '{"module":"SaleOrder","id":"${_saleOrderList[d].id}"}');

          int notificationId1 = int.parse(global.moduleIds['SaleOrder'].toString() + '02' + _saleOrderList[d].id.toString());
          await scheduleNotification(notificationId1, (_saleOrderList[d].deliveryDate.subtract(Duration(days: remainingDays(_saleOrderList[d].deliveryDate, false)))).add(Duration(hours: tod.hour, minutes: tod.minute)), 'Sale order delivery', 'order number - ${_saleOrderList[d].saleOrderNumber} on ${DateFormat('MMMM dd').format(_saleOrderList[d].deliveryDate)}', '{"module":"SaleOrder","id":"${_saleOrderList[d].id}"}');
          if (reminderTime == true) {
            int notificationId1 = int.parse(global.moduleIds['SaleOrder'].toString() + '02' + _saleOrderList[d].id.toString());

            await scheduleNotification(notificationId1, (_saleOrderList[d].deliveryDate.subtract(Duration(days: remainingDays(_saleOrderList[d].deliveryDate, false)))).add(Duration(hours: tod.hour, minutes: tod.minute)), 'Sale order delivery', 'order number - ${_saleOrderList[d].saleOrderNumber} on ${DateFormat('MMMM dd').format(_saleOrderList[d].deliveryDate)}', '{"module":"SaleOrder","id":"${_saleOrderList[d].id}"}');
          }
        }
      }
    } catch (e) {
      print('Exception - businessRule.dart - rescheduleNotification(): ' + e.toString());
    }
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  int remainingDays(DateTime date, bool isEvent, {int pastDays = 3}) {
    try {
      if (date != null) {
        DateTime _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        if (isEvent) {
          DateTime _nextEvents = DateTime(DateTime.now().year, date.month, date.day);

          if (_nextEvents.isBefore(_today)) {
            if (_today.difference(_nextEvents).inDays > pastDays) {
              _nextEvents = DateTime(DateTime.now().year + 1, date.month, date.day);
            }
          }

          return _nextEvents.difference(_today).inDays;
        } else {
          return date.difference(_today).inDays;
        }
      }
    } catch (e) {
      print("Exception - businessRule.dart - remainingDays():" + e.toString());
    }

    return null;
  }

  Future<bool> scheduleNotification(int id, DateTime scheduleDateTime, String title, String body, String payload, {bool setNextDate = false}) async {
    try {
      DateTime notificationDate = DateTime(scheduleDateTime.year, scheduleDateTime.month, scheduleDateTime.day, scheduleDateTime.hour, scheduleDateTime.minute);
      if (scheduleDateTime.isBefore(DateTime.now()) && setNextDate) {
        notificationDate = DateTime(scheduleDateTime.year + 1, scheduleDateTime.month, scheduleDateTime.day, scheduleDateTime.hour, scheduleDateTime.minute);
      }
      if (notificationDate.isAfter(DateTime.now())) {
        var androidPlatformChannelSpecifics = AndroidNotificationDetails('your other channel id', 'your other channel name');
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.schedule(id, title, body, notificationDate, platformChannelSpecifics, payload: payload);
        return true;
      }
    } catch (e) {
      print('Exception: BusinessRule - scheduleNotification() : ' + e.toString());
    }
    return false;
  }

  DateTime getNextEventDate(DateTime eventDate) {
    DateTime _nextEventDate = DateTime(DateTime.now().year, eventDate.month, eventDate.day);
    DateTime _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (_nextEventDate.isBefore(_today)) {
      _nextEventDate = DateTime(DateTime.now().year + 1, eventDate.month, eventDate.day);
    }
    return _nextEventDate;
  }

  // Future<dynamic> shareAccountCard(Account account) async {
  //   try {
  //     global.isAppOperation = true;
  //     var vCard = VCard();
  //     if (account.namePrefix != null) {
  //       vCard.namePrefix = account.namePrefix;
  //     }
  //     vCard.firstName = account.firstName;

  //     if (account.middleName != null) {
  //       vCard.middleName = account.middleName;
  //     }
  //     if (account.lastName != null) {
  //       vCard.lastName = account.lastName;
  //     }
  //     if (account.nameSuffix != null) {
  //       vCard.nameSuffix = account.nameSuffix;
  //     }
  //     if (account.birthdate != null) {
  //       vCard.birthday = account.birthdate;
  //     }
  //     if (account.anniversary != null) {
  //       vCard.anniversary = account.anniversary;
  //     }
  //     if (account.gender != null) {
  //       vCard.gender = account.gender[0];
  //     }
  //     if (account.phoneCountryCode != null && account.phone != null) {
  //       vCard.workPhone = '${account.phone != null ? '+' + account.phoneCountryCode + ' ' + account.phone : ''}';
  //     }
  //     if (account.mobileCountryCode != null && account.mobile != null) {
  //       vCard.cellPhone = '${account.mobile != null ? '+' + account.mobileCountryCode + ' ' + account.mobile : ''}';
  //     }
  //     if (account.email != null) {
  //       vCard.email = account.email;
  //     }
  //     if (account.addressLine1 != null) {
  //       vCard.homeAddress.label = account.addressLine1;
  //     }
  //     if (account.addressLine2 != null) {
  //       vCard.homeAddress.street = account.addressLine2;
  //     }
  //     if (account.city != null) {
  //       vCard.homeAddress.city = account.city;
  //     }
  //     if (account.state != null) {
  //       vCard.homeAddress.stateProvince = account.state;
  //     }
  //     if (account.pincode != null) {
  //       vCard.homeAddress.postalCode = account.pincode.toString();
  //     }
  //     String vCardString = vCard.getFormattedString();
  //     String filePath = join(global.accountvCardExportPath, 'contact${account.id}.vcf');
  //     Directory accountvCardExport = Directory(global.accountvCardExportPath);
  //     if (await accountvCardExport.exists()) {
  //       await Directory(global.accountvCardExportPath).delete(recursive: true);
  //       await accountvCardExport.create();
  //     } else {
  //       await accountvCardExport.create();
  //     }
  //     await File(filePath).writeAsString(vCardString);
  //     if (FileSystemEntity.typeSync(filePath) == FileSystemEntityType.notFound) {
  //       print('File is not created');
  //     } else {
  //       print('File is created');
  //     }
  //     //ByteData bytes = await rootBundle.load(filePath);
  //     File imageFile =  File(filePath);
  //     List<int> fileBytes = imageFile.readAsBytesSync();
  //     await Share.shareFiles([imageFile.path],  text: '${generateAccountName(account)}', mimeTypes: ['${generateAccountName(account)}.vcf', 'text/x-vcard']);
  //     print(vCard.getFormattedString());
  //   } catch (e) {
  //     print("Exception - businessRule.dart - _shareCard():" + e.toString());
  //   }
  // }

  Future shareFile(String path, String fileName) async {
    try {
      global.isAppOperation = true;
      // File file =  File(path);
      // List<int> bytes = file.readAsBytesSync();
      if (path.contains('.png')) {
        await Share.shareFiles([path]);
        // (
        //    [path],
        //  text: 'Secure wallet',

        //   // bytes,
        //   // 'image/png',
        // );
      } else if (path.contains('.pdf')) {
        await Share.shareFiles(
          [
            path,
          ],
          text: global.appName,
          // bytes,
          // 'application/pdf',
        );
      }
    } catch (e) {
      print("Exeption - businessRule.dart - shareFile():" + e.toString());
    }
  }

  Future openFile(String path) async {
    try {
      if (path.contains('.png')) {
        OpenFile.open('$path', type: "image/png", uti: "public.png");
      } else if (path.contains('.pdf')) {
        OpenFile.open('$path', type: "application/pdf", uti: "com.adobe.pdf");
      }
    } catch (e) {
      print('Exception - businessRule.dart - openFile(): ' + e.toString());
    }
  }

  Future printFile(String path) async {
    try {
      global.isAppOperation = true;
      if (path.contains('.png')) {
        final doc = pd.Document();

        final image = pd.MemoryImage(
          File(path).readAsBytesSync(),
        );
        //  await pdfImageFromImageProvider(pdf: doc.document, image: FileImage(File(path)));
        doc.addPage(pd.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pd.Context context) {
              return pd.Center(
                child: pd.Image(image),
              ); // Center
            }));

        await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
      } else if (path.contains('.pdf')) {
        File pdfFile = File(path);
        final pdfBytes = pdfFile.readAsBytesSync();

        await Printing.layoutPdf(onLayout: (_) async => pdfBytes.buffer.asUint8List());
      }
    } catch (e) {
      print("Exception - businessRule.dart -  printFile():" + e.toString());
    }
  }

  Future<String> selectMobileNumber(List<String> mobileNumbers, context) async {
    String _selected = mobileNumbers[0];
    try {
      AlertDialog dialog = AlertDialog(
        title: Text(
          '${global.appLocaleValues['tle_choose_phone_number']}',
        ),
        content: Container(
          //height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: mobileNumbers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  title: Text(
                    '${mobileNumbers[index]}',
                  ),
                  onTap: () {
                    _selected = mobileNumbers[index];
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          ),
        ),
      );
      await showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
      return _selected;
    } catch (e) {
      print('Exception - businessRule.dart - selectMobileNumber(): ' + e.toString());
      return _selected;
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    try {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
      final format = DateFormat.jm(); //"6:00 AM"

      return format.format(dt);
    } catch (e) {
      print('Exception - businessRule.dart - formatTimeOfDay(): ' + e.toString());
      return '';
    }
  }
}
