// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_conditional_assignment, unnecessary_string_escapes
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/EmployeeSalaryModel.dart';
import 'package:accounting_app/models/EmployeeSalaryPaymentModel.dart';
import 'package:accounting_app/models/EmployeeSalaryStructuresModel.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/accountSellerReportFilterModel.dart';
import 'package:accounting_app/models/accountSellerReportModel.dart';
import 'package:accounting_app/models/attendanceModel.dart';
import 'package:accounting_app/models/buisnessStatementGraphModel.dart';
import 'package:accounting_app/models/businessChartModel.dart';
import 'package:accounting_app/models/businessLayer/businessRule.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/businessModel.dart';
import 'package:accounting_app/models/expenseCategoryModel.dart';
import 'package:accounting_app/models/expenseGeneralReportFilterModel.dart';
import 'package:accounting_app/models/expenseGeneralReportModel.dart';
import 'package:accounting_app/models/expenseModel.dart';
import 'package:accounting_app/models/expensePaymentsModel.dart';
import 'package:accounting_app/models/exportAccountFilterModel.dart';
import 'package:accounting_app/models/paymentGeneralReportFilterModel.dart';
import 'package:accounting_app/models/paymentGeneralReportModel.dart';
import 'package:accounting_app/models/paymentSaleQuotesModel.dart';
import 'package:accounting_app/models/productGeneralReportFilterModel.dart';
import 'package:accounting_app/models/productGeneralReportModel.dart';
import 'package:accounting_app/models/quotesGeneralReportFilterModel.dart';
import 'package:accounting_app/models/quotesGeneralReportModel.dart';
import 'package:accounting_app/models/saleOrderInvoiceModel.dart';
import 'package:accounting_app/models/paymentDetailModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceReturnModel.dart';
import 'package:accounting_app/models/paymentSaleOrderModel.dart';
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/productPriceModel.dart';
import 'package:accounting_app/models/productTaxModel.dart';
import 'package:accounting_app/models/productTypeModel.dart';
import 'package:accounting_app/models/productTypeTaxModel.dart';
import 'package:accounting_app/models/purchaseInvoiceDetailModel.dart';
import 'package:accounting_app/models/purchaseInvoiceDetailTaxModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailTaxModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnTaxModel.dart';
import 'package:accounting_app/models/purchaseInvoiceTaxModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailTaxModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnDetailTaxModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnTaxModel.dart';
import 'package:accounting_app/models/saleInvoiceTaxModel.dart';
import 'package:accounting_app/models/saleOrderDetailModel.dart';
import 'package:accounting_app/models/saleOrderDetailTaxModel.dart';
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/models/saleOrderTaxModel.dart';
import 'package:accounting_app/models/saleQuoteDetailModel.dart';
import 'package:accounting_app/models/saleQuoteDetailTaxModel.dart';
import 'package:accounting_app/models/saleQuoteTaxModel.dart';
import 'package:accounting_app/models/salesGeneralReportFilterModel.dart';
import 'package:accounting_app/models/salesGeneralReportModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/models/salesTaxAndDiscountReportFilterModel.dart';
import 'package:accounting_app/models/salesTaxAndDiscountReportModel.dart';
import 'package:accounting_app/models/systemFlagModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/models/topSellingProductReportFilterModel.dart';
import 'package:accounting_app/models/topSellingProductReportModel.dart';
import 'package:accounting_app/models/unitCombinationModel.dart';
import 'package:accounting_app/models/unitModel.dart';
import 'package:accounting_app/models/userModel.dart';
import 'package:accounting_app/models/taxMasterPercentageModel.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../accountModel.dart';

class DBHelper {
  static Database _db;
  Business _business;

  DBHelper(Business business) {
    _business = business;
  }
  BusinessRule br = BusinessRule();
  Future<Database> get db async {
    try {
      if (_db != null) {
        return _db;
      }
      print('zied connexion');
      _db = await initDb();
      return _db;
    } catch (e) {
      return null;
    }
  }

  Future<bool> accountCheckEmailExist(String email) async //check email in Account Table //accountCheckEmail
  {
    try {
      var dbClient = await db;
      int result = Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM Accounts WHERE businessId=? AND email=?', [_business.id, email]));
      return result == 1 ? true : false;
    } catch (e) {
      print('Exception - accountCheckEmailExist(): ' + e.toString());
      return null;
    }
  }

  Future<bool> accountCheckMobileExist(String mobile) async //check contact in Account Table //accountCheckContact
  {
    try {
      var dbClient = await db;
      int result = Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM Accounts WHERE businessId=? AND mobile=?', [_business.id, mobile]));
      return (result != 0) ? true : false;
    } catch (e) {
      print('Exception - accountCheckMobileExist(): ' + e.toString());
      return null;
    }
  }

  Future<int> accountDelete(String accountId) async //delete customer from Account Table //accountDeleteCustomer
  {
    try {
      var dbClient = await db;
      int _result = await dbClient.rawDelete('DELETE FROM Accounts WHERE id=$accountId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return _result;
    } catch (e) {
      print('Exception - accountDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> accountExistInInvoiceOrPayment({String accountIn, int accountId}) async //get no.of customers from Account Table //accountGetCount
  {
    try {
      var dbClient = await db;
      String query = 'SELECT COUNT(*) FROM $accountIn WHERE businessId=${_business.id} AND accountId = $accountId';
      return Sqflite.firstIntValue(await dbClient.rawQuery(query));
    } catch (e) {
      print('Exception - accountGetCount(): ' + e.toString());
      return null;
    }
  }

  Future<int> accountGetCount({bool isActive, String accountType}) async //get no.of customers from Account Table //accountGetCount
  {
    try {
      var dbClient = await db;
      String query = 'SELECT COUNT(*) FROM Accounts WHERE businessId = ${_business.id}';
      if (isActive != null) {
        query += ' AND isActive= \'$isActive\'';
      }
      if (accountType != null) {
        query += ' AND accountType LIKE \'%$accountType%\'';
      }
      return Sqflite.firstIntValue(await dbClient.rawQuery(query));
    } catch (e) {
      print('Exception - accountGetCount(): ' + e.toString());
      return null;
    }
  }

  Future<List<Account>> accountGetList({int startIndex, int fetchRecords, int screenId, String searchString, int accountId, String accountType, bool isActive, bool isCredit, bool isDue, String orderBy}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT a.*, IFNULL(s.totalSpent,0)  totalSpent, IFNULL(r.totaInvoiceReturnAmount,0)  totaInvoiceReturnAmount, IFNULL(p.totalPaid,0) totalPaid FROM Accounts a ' + ' LEFT JOIN (SELECT accountId,sum(netAmount) as totalSpent FROM SaleInvoices GROUP BY accountID)  s ON s.accountId = a.id ' + ' LEFT JOIN (SELECT accountId,sum(netAmount) as totaInvoiceReturnAmount FROM SaleInvoiceReturns GROUP BY accountID)  r ON r.accountId = a.id ' + ' LEFT JOIN (SELECT p.accountId,sum(p.amount) as totalPaid FROM Payments p left join PaymentSaleOrders pso on pso.paymentId = p.id left join SaleInvoices si on si.salesOrderId = pso.saleOrderId WHERE si.id is null and p.paymentType=\'RECEIVED\' GROUP BY p.accountId) p on p.accountId = a.id';

      if (accountType == 'Supplier') {
        query = 'SELECT a.*, IFNULL(s.totalSpent,0)  totalSpent, IFNULL(r.totaInvoiceReturnAmount,0)  totaInvoiceReturnAmount, IFNULL(p.totalPaid,0) totalPaid FROM Accounts a ' + ' LEFT JOIN (SELECT accountId,sum(netAmount) as totalSpent FROM PurchaseInvoices GROUP BY accountID)  s ON s.accountId = a.id ' + ' LEFT JOIN (SELECT accountId,sum(netAmount) as totaInvoiceReturnAmount FROM PurchaseInvoiceReturns GROUP BY accountID)  r ON r.accountId = a.id ' + ' LEFT JOIN (SELECT accountId,sum(amount) as totalPaid FROM Payments WHERE paymentType=\'GIVEN\' GROUP BY accountId) p on p.accountId = a.id';
      }

      if (_business != null) {
        query += ' WHERE a.businessId = ${_business.id}';
      }

      if (accountType != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' a.accountType LIKE \'%$accountType%\'';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' a.id = $accountId';
      }

      if (isActive == true) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' a.isActive = \'$isActive\'';
      }

      if (isDue == true) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND';
        }
        query += ' IFNULL(s.totalSpent,0) - IFNULL(p.totalPaid,0) > 0';
      }

      if (isCredit == true) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' IFNULL(s.totalSpent,0) - IFNULL(p.totalPaid,0) < 0';
      }

      if (searchString != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' (a.firstName LIKE \'%$searchString%\' OR a.lastName LIKE \'%$searchString%\' OR a.businessName LIKE \'%$searchString%\')';
      }

      if (orderBy != null && screenId == 0) {
        query += ' ORDER BY  a.id $orderBy';
      }
      if (screenId == 1) {
        query += ' ORDER BY a.firstName ,a.lastName';
      }
      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords ';
      }
      //  print(query);
      var result = await dbClient.rawQuery(query);
      return result.map((f) => Account.fromMap(f)).toList();
    } catch (e) {
      print('Exception - accountGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> accountGetNewAccountCode() async //fetch all accounts for generate account code from Account Table //accountFetchAccounts
  {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery('SELECT MAX(CAST(accountCode AS INT)) FROM Accounts WHERE businessId = ?', [_business.id]);
      if (result[0].values.first == null) {
        return 1;
      } else {
        int res = result[0].values.first;
        return res + 1;
      }
    } catch (e) {
      print('Exception - accountGetNewAccountCode(): ' + e.toString());
      return null;
    }
  }

  Future<int> accountInsert(Account obj) async // insertion in Account Table //accountCreateCustomer
  {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.insert('Accounts', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - accountInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> accountUpdate(Account obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('Accounts', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - accountUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> businessDelete() async {
    try {
      var dbClient = await db;
      return await dbClient.rawDelete('DELETE FROM Businesses');
    } catch (e) {
      print('Exception - businessDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> businessGetCount() async //get no.of records from Business Table //businessGetCount
  {
    try {
      var dbClient = await db;
      return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM Businesses'));
    } catch (e) {
      print('Exception - businessGetCount(): ' + e.toString());
      return null;
    }
  }

  Future<int> businessGetId(openDB) async {
    try {
      var dbClient = openDB;
      var result = await dbClient.rawQuery('SELECT id FROM Businesses');
      if (result.isNotEmpty) {
        return result.first['id'];
      } else {
        return null;
      }
    } catch (e) {
      print('Exception - businessGetId(): ' + e.toString());
      return null;
    }
  }

  Future<Business> businessGetList() async //display data from Business Table //businessDisplay
  {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery('SELECT * FROM Businesses');
      List<Business> businesses = result.map((f) => Business.fromMap(f)).toList();
      return (businesses.length > 0) ? businesses[0] : null;
    } catch (e) {
      print('Exception - businessGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> businessInsert(Business obj) async // insertion in Business Table //businessInsertion
  {
    try {
      var dbClient = await db;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      return await dbClient.insert('Businesses', obj.toMap());
    } catch (e) {
      print('Exception - businessInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> businessUpdate(Business obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('Businesses', obj.toMap(), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - businessUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<bool> expenseCategoryCheckNameExist({String categoryName, int expenseId}) async //check expense Category already exist or not in ExpenseCategories Table //expenseCategoryCheckCategory
  {
    try {
      var dbClient = await db;
      String query = 'SELECT COUNT(*) FROM ExpenseCategories WHERE businessId = ${_business.id}';

      if (expenseId != null) {
        query += ' AND id!=\'$expenseId\'';
      }

      if (categoryName != null) {
        query += ' AND (lower(name)=\'$categoryName\' OR upper(name)=\'$categoryName\' OR name= \'$categoryName\')';
      }

      var result = Sqflite.firstIntValue(await dbClient.rawQuery(query));
      return result == 1 ? true : false;
    } catch (e) {
      print('Exception - expenseCategoryCheckNameExist(): ' + e.toString());
      return null;
    }
  }

  Future<int> expenseCategoryDelete(int expenseCategoryId) async //delete category from ExpenseCategories Table //expenseCategoryDelete
  {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM ExpenseCategories WHERE id=$expenseCategoryId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - expenseCategoryDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<ExpenseCategory>> expenseCategoryGetList({int expenseCategoryId, String searchString, bool isParentId}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM ExpenseCategories';

      if (expenseCategoryId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' id = $expenseCategoryId ';
      }

      if (isParentId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' parentCategoryId IS NULL';
      }

      if (searchString != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (name LIKE \'%$searchString%\') ';
      }

      //query += ' ORDER BY name ';

      var result = await dbClient.rawQuery(query);
      //   print("expenseCategoryGetList - query - $query - length - ${result.map((f) => ExpenseCategory.fromMap(f)).toList().length} ");
      return result.map((f) => ExpenseCategory.fromMap(f)).toList();
    } catch (e) {
      print('Exception - expenseCategoryGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> expenseCategoryInsert(ExpenseCategory obj) async //insertion in ExpenseCategories Table //expenseCategoryCreateExpenseCategory
  {
    try {
      var dbClient = await db;
      obj.isActive = true;
      obj.isDelete = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.insert('ExpenseCategories', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - expenseCategoryInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> expenseCategoryIsUsed(int expenseCategoryId) async //delete product type from ProductTypes Table //productTypeDeleteProductType
  {
    try {
      var dbClient = await db;
      return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM Expenses WHERE businessId=? AND expenseCategoryId=?', [_business.id, expenseCategoryId]));
    } catch (e) {
      print('Exception - productTypeDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> expenseCategoryUpdate(ExpenseCategory obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('ExpenseCategories', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - expenseCategoryUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> expenseDelete(int expenseId) async //delete Expense from Expenses Table //expenseDeleteExpense
  {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('delete from Expenses where id=$expenseId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - expenseDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> expenseGetCount() async //get no.of Expense from Expenses Table //expenseGetCount
  {
    try {
      var dbClient = await db;
      return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM Expenses WHERE businessId=? AND isDelete=?', [_business.id, 'false']));
    } catch (e) {
      print('Exception - expenseGetCount(): ' + e.toString());
      return null;
    }
  }

  Future<List<Expense>> expenseGetList({int startIndex, int fetchRecords, String searchString, int expenseId, int expenseCategoryId, DateTime startDate, DateTime endDate, String paymentMode, bool isDelete, bool isCategorywise, bool isBillerwise, String billerName, bool isShowExpenseList}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,SUM(t1.amount) AS totalAmount,COUNT(t1.expenseCategoryId) as categoryTotalSpends,COUNT(t1.billerName IS NULL) as billerTotalSpends,t2.name FROM Expenses t1 INNER JOIN ExpenseCategories t2 ON t1.expenseCategoryId = t2.id ';

      if (expenseId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.id = $expenseId';
      }

      if (expenseCategoryId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.expenseCategoryId = $expenseCategoryId';
      }

      if (paymentMode != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.paymentMode = \'$paymentMode\'';
      }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (date(t1.transactionDate) >= date(\'$startDate\') AND date(t1.transactionDate) <= date(\'$endDate\')) ';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(t1.transactionDate) >= date(\'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(t1.transactionDate) <= date(\'$endDate\') ';
      }

      if (isDelete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' isDelete = \'$isDelete\' ';
      } else {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isDelete = \'false\' ';
      }

      if (searchString != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.expenseName LIKE \'%$searchString%\' OR t1.paymentMode LIKE \'%$searchString%\' OR t1.amount LIKE \'%$searchString%\')';
      }
      if (isCategorywise != null) {
        query += ' GROUP BY t1.expenseCategoryId';
      }
      if (isBillerwise != null) {
        query += ' GROUP BY t1.billerName';
      }
      if (billerName != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.billerName LIKE \'%$billerName%\')';
      }
      if (billerName == null && isShowExpenseList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.billerName IS NULL';
      }

      if (isCategorywise == null && isBillerwise == null) {
        query += ' GROUP BY t1.id';
      }

      query += ' ORDER BY date(t1.transactionDate) DESC ';

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords ';
      }
      var result = await dbClient.rawQuery(query);
      List<Expense> expenseList = result.map((f) => Expense.fromMap(f)).toList();
      print("expenseList  ${expenseList.length}");
      return expenseList;
    } catch (e) {
      print('Exception - expenseGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<Expense>> expenseGetListChart({
    DateTime startDate,
    DateTime endDate,
    bool inDay,
    bool inWeek,
    bool inMonth,
  }) async {
    try {
      var dbClient = await db;
      String query = 'WITH RECURSIVE dates(date) AS ( ' + ' VALUES(date(\'$startDate\'))' + ' UNION ALL' + ' SELECT date(date, \'+1 day\')' + ' FROM dates' + ' WHERE date < date(\'$endDate\'))' + ' SELECT date AS transactionDate,' + ' CASE WHEN date(date, "weekday 0") > date(\'$endDate\') THEN date(\'$endDate\') ELSE date(date, "weekday 0") End eekLastDay, ' + ' SUM(IFNULL(t1.amount, 0)) AS totalAmount FROM dates LEFT JOIN Expenses t1 ON date(t1.transactionDate) = date';

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += '(date(t1.transactionDate) >= date(\'$startDate\') AND date(t1.transactionDate <= date(\'$endDate\')))';
      }
      if (inMonth != null && inMonth == true) {
        query += ' GROUP BY strftime("%m - %Y",date) ORDER BY date ';
      } else if (inWeek != null && inWeek == true) {
        query += ' GROUP BY strftime("%W",date) ORDER BY date ';
      } else if (inDay != null && inDay == true) {
        query += ' GROUP BY strftime("%d",date) ORDER BY date ';
      } else {
        query += ' GROUP BY strftime("%m - %Y",date) ORDER BY date ';
      }

      // query += ' GROUP BY strftime("%m - %Y",date) ORDER BY date ';
      var result = await dbClient.rawQuery(query);

      List<Expense> expenseList = result.map((f) => Expense.fromMap(f)).toList();

      return expenseList;
    } catch (e) {
      print('Exception - expenseGetListChart(): ' + e.toString());
      return null;
    }
  }

  Future<double> expenseGetSumOfAmount() async //get no.of active invoices from Invoices Table //invoiceGetCount
  {
    try {
      double _result;
      String _value;
      var dbClient = await db;
      String query = 'SELECT SUM(amount) FROM Expenses WHERE businessId=${_business.id}';
      var result = await dbClient.rawQuery(query);
      _value = result[0].values.toString().substring(1, result[0].values.toString().length - 1);
      if (_value != 'null') {
        _result = double.parse(result[0].values.toString().substring(1, result[0].values.toString().length - 1));
      }
      return (_value != 'null') ? _result : 0;
    } catch (e) {
      print('Exception - expenseGetSumOfAmount(): ' + e.toString());
      return null;
    }
  }

  Future<int> expenseInsert(Expense obj) async {
    try {
      var dbClient = await db;
      obj.isDelete = false;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.businessId = _business.id;
      List<int> _intList = [];
      if (obj.isPaid && !obj.isSplitPayment) {
        _intList.clear();
        Payment p = Payment();

        p.amount = obj.amount;
        p.transactionDate = obj.transactionDate;
        p.paymentType = 'GIVEN';
        p.paymentDetailList.clear();
        PaymentDetail _paymentDetail = PaymentDetail(null, null, p.amount, obj.paymentMode, null, false, null, null);
        p.paymentDetailList.add(_paymentDetail);
        p = await paymentInsert(p);

        _intList.add(p.id);
      } else {
        _intList.clear();
        if (obj.paymentList.isNotEmpty) {
          for (int i = 0; i < obj.paymentList.length; i++) {
            if (obj.paymentList[i].paymentDetailList.length > 0) {
              obj.paymentList[i].amount = obj.paymentList[i].paymentDetailList.map((e) => e.amount).reduce((value, element) => value + element);
              obj.paymentList[i].transactionDate = obj.transactionDate;
              obj.paymentList[i].paymentType = 'GIVEN';
              obj.paymentList[i] = await paymentInsert(obj.paymentList[i]);
              _intList.add(obj.paymentList[i].id);
            }
          }
        }
        print("${_intList.length}");
      }

      int result = await dbClient.insert('Expenses', obj.toMap(true));
      if (_intList != null) {
        for (int i = 0; i < _intList.length; i++) {
          ExpensePayments expensePayments = ExpensePayments();
          expensePayments.paymentId = _intList[i];
          expensePayments.expenseId = result;

          await expensePaymentInsert(expensePayments);
        }
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - expenseInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> expensePaymentsDelete({List<int> expenseId, int paymentId}) async {
    try {
      var dbClient = await db;
      String query;
      if (expenseId != null) {
        query = 'DELETE FROM ExpensePayments WHERE expenseId IN (${expenseId.toString().substring(1, (expenseId.toString().length - 1))})';
      } else if (paymentId != null) {
        query = 'DELETE FROM ExpensePayments WHERE paymentId = $paymentId';
      }
      var result = Sqflite.firstIntValue(await dbClient.rawQuery(query));
      print("ExpensePaymentDelete -  $result");
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - expensePaymentsDelete(): ' + e.toString());
    }
    return null;
  }

  Future<List<ExpensePayments>> expensePaymentsGetList({int paymentId, int expenseId}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM ExpensePayments WHERE';
      if (paymentId != null) {
        query += ' paymentId = $paymentId';
      } else {
        query += ' expenseId = $expenseId';
      }
      List<Map> list = await dbClient.rawQuery(query);
      List<ExpensePayments> expensePayments = list.map((f) => ExpensePayments.fromMap(f)).toList();
      print("expensePaymentsGetList -  ${expensePayments.length}");
      return expensePayments;
    } catch (e) {
      print('Exception  - policyAccountGetList():' + e.toString());
    }
    return null;
  }

  Future<int> expensePaymentInsert(ExpensePayments expensePayments) async {
    try {
      var dbClient = await db;
      expensePayments.businessId = _business.id;
      var result = await dbClient.insert('ExpensePayments', expensePayments.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      print("ExpensePaymentInsert -  $result");
      return result;
    } catch (e) {
      print('Exception  - expensePaymentInsert():' + e.toString());
    }
    return null;
  }

  Future<int> expenseUpdate(Expense obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      List<int> _intList = [];
      await expensePaymentsDelete(expenseId: [obj.id]);
      if (obj.paymentList.isNotEmpty) {
        for (int i = 0; i < obj.paymentList.length; i++) {
          await paymentDetailDelete(paymentIdList: [obj.paymentList[i].id]);
          await paymentDelete(paymentIdList: [obj.paymentList[i].id]);
        }
      }
      if (obj.isPaid && !obj.isSplitPayment) {
        _intList.clear();
        Payment p = Payment();
        p.amount = obj.amount;
        p.transactionDate = obj.transactionDate;
        p.paymentType = 'GIVEN';
        p.paymentDetailList.clear();
        PaymentDetail _paymentDetail = PaymentDetail(null, null, p.amount, obj.paymentMode, null, false, null, null);
        p.paymentDetailList.add(_paymentDetail);
        p = await paymentInsert(p);
        _intList.add(p.id);
      } else {
        _intList.clear();
        if (obj.paymentList.isNotEmpty) {
          for (int i = 0; i < obj.paymentList.length; i++) {
            if (obj.paymentList[i].paymentDetailList.length > 0) {
              obj.paymentList[i].amount = obj.paymentList[i].paymentDetailList.map((e) => e.amount).reduce((value, element) => value + element);
              obj.paymentList[i].transactionDate = obj.transactionDate;
              obj.paymentList[i].paymentType = 'GIVEN';
              obj.paymentList[i] = await paymentInsert(obj.paymentList[i]);
              _intList.add(obj.paymentList[i].id);
            }
          }
        }
        print("${_intList.length}");
      }
      int result = await dbClient.update('Expenses', obj.toMap(false), where: 'id=${obj.id}');
      if (_intList != null) {
        for (int i = 0; i < _intList.length; i++) {
          ExpensePayments expensePayments = ExpensePayments();
          expensePayments.paymentId = _intList[i];
          expensePayments.expenseId = obj.id;
          await expensePaymentInsert(expensePayments);
        }
      }

      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - expenseUpdate(): ' + e.toString());
      return null;
    }
  }

  initDb() async {
    try {
      bool _isDatabaseExist = true;
      String databasePath = join(global.contentDirectoryPath, global.dbName);

      print("DB Path: " + databasePath);
      // Only copy if the database doesn't exist
      if (FileSystemEntity.typeSync(databasePath) == FileSystemEntityType.notFound) {
        _isDatabaseExist = false;
        print("DB Path Not found.");
        ByteData data = await rootBundle.load(join('assets', global.dbName));
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        // Save copied asset to documents
        await File(databasePath).writeAsBytes(bytes);
      }

      var openDb = await openDatabase(databasePath, password: 'XcwkW4a0hy7OQf6lK9q853oYAHT2t1FC');
      print("DATABASE EXIST"+ openDb.toString());
      if (_isDatabaseExist) {
        String dbVersion = await systemFlagGetValue(global.systemFlagNameList.dbVersion, openDB: openDb);
        if (dbVersion == null) {
          dbVersion = "";
        }
        switch (dbVersion) {
          case "5":
            await sqlScript6(openDb);
            continue case6;

          case6:
          case "6":
            await sqlScript7(openDb);
            continue case7;

          case7:
          case "7":
            await sqlScript8(openDb);
            break;
        }
      }
      return openDb;
    } catch (e) {
      print('Exception SQLITE - initDb(): ' + e.toString());
      return null;
    }
  }

  Future sqlScript6(openDb) async {
    try {
      var dbClient = openDb;
      await systemFlagUpdateValue(global.systemFlagNameList.dbVersion, '6', openDb: openDb);
      await dbClient.rawQuery('ALTER TABLE Accounts ADD anniversary TEXT');
      await dbClient.rawInsert('INSERT INTO SystemFlags (id, name, value, defaultValue, valueList, description, lable, isActive, isDelete, createdAt, modifiedAt, businessId) VALUES (41, "BACKUP_TIME", null, null, null, null, null, "true", "false", null, null , null )');
    } catch (e) {
      print('Exception - sqlScript6(): ' + e.toString());
    }
  }

  Future sqlScript7(openDb) async {
    try {
      var dbClient = openDb;
      await systemFlagUpdateValue(global.systemFlagNameList.dbVersion, '7', openDb: openDb);
      await dbClient.rawQuery('ALTER TABLE Products ADD hsnCode TEXT');
      await dbClient.rawInsert('INSERT INTO SystemFlags (id, name, value, defaultValue, valueList, description, lable, isActive, isDelete, createdAt, modifiedAt, businessId) VALUES (42, "LAST_CONTRIBUTED_AT", null, null, null, null, null, "true", "false", null, null , null )');
    } catch (e) {
      print('Exception - sqlScript7(): ' + e.toString());
    }
  }

  Future sqlScript8(openDb) async {
    try {
      var dbClient = openDb;
      await systemFlagUpdateValue(global.systemFlagNameList.dbVersion, '8', openDb: openDb);

      //step1
      try {
        await dbClient.rawQuery('ALTER TABLE PurchaseInvoiceDetails RENAME COLUMN quantity TO quantityOld');
        print("sqlScript8: step1 sucessfull");
      } catch (e) {
        print("sqlScript8: step1: ${e.toString()}");
      }

      // step2
      try {
        await dbClient.rawQuery('ALTER TABLE PurchaseInvoiceDetails ADD quantity NUMERIC DEFAULT 0 NOT NULL');
        print("sqlScript8: step2 sucessfull");
      } catch (e) {
        print("sqlScript8: step2: ${e.toString()}");
      }

      //step3
      try {
        await dbClient.rawQuery('UPDATE PurchaseInvoiceDetails SET quantity = quantityOld');
        print("sqlScript8: step3 sucessfull");
      } catch (e) {
        print("sqlScript8: step3: ${e.toString()}");
      }

      //step4
      try {
        await dbClient.rawQuery('ALTER TABLE PurchaseInvoiceReturnDetails RENAME COLUMN quantity TO quantityOld');
        print("sqlScript8: step4 sucessfull");
      } catch (e) {
        print("sqlScript8: step4: ${e.toString()}");
      }

      // step5
      try {
        await dbClient.rawQuery('ALTER TABLE PurchaseInvoiceReturnDetails ADD quantity NUMERIC DEFAULT 0 NOT NULL');
        print("sqlScript8: step5 sucessfull");
      } catch (e) {
        print("sqlScript8: step5: ${e.toString()}");
      }

      //step6
      try {
        await dbClient.rawQuery('UPDATE PurchaseInvoiceReturnDetails SET quantity = quantityOld');
        print("sqlScript8: step6 sucessfull");
      } catch (e) {
        print("sqlScript8: step6: ${e.toString()}");
      }

      //step7
      try {
        await dbClient.rawQuery('ALTER TABLE SaleInvoiceDetails RENAME COLUMN quantity TO quantityOld');
        print("sqlScript8: step7 sucessfull");
      } catch (e) {
        print("sqlScript8: step7: ${e.toString()}");
      }

      // step8
      try {
        await dbClient.rawQuery('ALTER TABLE SaleInvoiceDetails ADD quantity NUMERIC DEFAULT 0 NOT NULL');
        print("sqlScript8: step8 sucessfull");
      } catch (e) {
        print("sqlScript8: step8: ${e.toString()}");
      }

      //step9
      try {
        await dbClient.rawQuery('UPDATE SaleInvoiceDetails SET quantity = quantityOld');
        print("sqlScript8: step9 sucessfull");
      } catch (e) {
        print("sqlScript8: step9: ${e.toString()}");
      }

      //step10
      try {
        await dbClient.rawQuery('ALTER TABLE SaleInvoiceReturnDetails RENAME COLUMN quantity TO quantityOld');
        print("sqlScript8: step10 sucessfull");
      } catch (e) {
        print("sqlScript8: step10: ${e.toString()}");
      }

      // step11
      try {
        await dbClient.rawQuery('ALTER TABLE SaleInvoiceReturnDetails ADD quantity NUMERIC DEFAULT 0 NOT NULL');
        print("sqlScript8: step11 sucessfull");
      } catch (e) {
        print("sqlScript8: step11: ${e.toString()}");
      }

      //step12
      try {
        await dbClient.rawQuery('UPDATE SaleInvoiceReturnDetails SET quantity = quantityOld');
        print("sqlScript8: step12 sucessfull");
      } catch (e) {
        print("sqlScript8: step12: ${e.toString()}");
      }

      //step13
      try {
        await dbClient.rawQuery('ALTER TABLE SaleInvoices ADD isEmailSent TEXT');
        print("sqlScript8: step13 sucessfull");
      } catch (e) {
        print("sqlScript8: step13: ${e.toString()}");
      }

      //step14
      try {
        await dbClient.rawQuery('ALTER TABLE SaleQuotes ADD isEmailSent TEXT');
        print("sqlScript8: step13 sucessfull");
      } catch (e) {
        print("sqlScript8: step13: ${e.toString()}");
      }

      //step15
      try {
        await dbClient.rawInsert('INSERT INTO SystemFlags (id, name, value, defaultValue, valueList, description, lable, isActive, isDelete, createdAt, modifiedAt, businessId) VALUES (48, "emailForEmail", null, null, null, "This will use for google backup-restore and send quote and invoice emails to accounts", null, "true", "false", null, null , null )');
        print("sqlScript8: step15 sucessfull");
      } catch (e) {
        print("sqlScript8: step15: ${e.toString()}");
      }

      //step16
      try {
        await dbClient.rawQuery('ALTER TABLE SaleInvoices ADD pdfPath TEXT');
        print("sqlScript8: step16 sucessfull");
      } catch (e) {
        print("sqlScript8: step16: ${e.toString()}");
      }

      //step17
      try {
        await dbClient.rawQuery('ALTER TABLE SaleQuotes ADD pdfPath TEXT');
        print("sqlScript8: step17 sucessfull");
      } catch (e) {
        print("sqlScript8: step17: ${e.toString()}");
      }

      //step18
      try {
        await dbClient.rawQuery('ALTER TABLE SaleInvoices ADD includeAttachmentsEmail TEXT');
        print("sqlScript8: step18 sucessfull");
      } catch (e) {
        print("sqlScript8: step18: ${e.toString()}");
      }

      //step19
      try {
        await dbClient.rawQuery('ALTER TABLE SaleQuotes ADD includeAttachmentsEmail TEXT');
        print("sqlScript8: step19 sucessfull");
      } catch (e) {
        print("sqlScript8: step19 ${e.toString()}");
      }

      //step20
      try {
        await dbClient.rawQuery('ALTER TABLE SaleOrderDetails RENAME COLUMN quantity TO quantityOld');
        print("sqlScript8: step20 sucessfull");
      } catch (e) {
        print("sqlScript8: step20: ${e.toString()}");
      }

      // step21
      try {
        await dbClient.rawQuery('ALTER TABLE SaleOrderDetails ADD quantity NUMERIC DEFAULT 0 NOT NULL');
        print("sqlScript8: step21 sucessfull");
      } catch (e) {
        print("sqlScript8: step21: ${e.toString()}");
      }

      //step22
      try {
        await dbClient.rawQuery('UPDATE SaleOrderDetails SET quantity = quantityOld');
        print("sqlScript8: step22 sucessfull");
      } catch (e) {
        print("sqlScript8: step22: ${e.toString()}");
      }

      //step23
      try {
        await dbClient.rawQuery('ALTER TABLE SaleOrderDetails RENAME COLUMN invoicedQuantity TO invoicedQuantityOld');
        print("sqlScript8: step23 sucessfull");
      } catch (e) {
        print("sqlScript8: step23: ${e.toString()}");
      }

      // step24
      try {
        await dbClient.rawQuery('ALTER TABLE SaleOrderDetails ADD invoicedQuantity NUMERIC DEFAULT 0 NOT NULL');
        print("sqlScript8: step24 sucessfull");
      } catch (e) {
        print("sqlScript8: step24: ${e.toString()}");
      }

      //step25
      try {
        await dbClient.rawQuery('UPDATE SaleOrderDetails SET invoicedQuantity = invoicedQuantityOld');
        print("sqlScript8: step25 sucessfull");
      } catch (e) {
        print("sqlScript8: step25: ${e.toString()}");
      }

      //step26
      try {
        await dbClient.rawQuery('ALTER TABLE SaleOrders ADD showRemarkInPrint NUMERIC TEXT "" NOT NULL');
        print("sqlScript8: step26 sucessfull");
      } catch (e) {
        print("sqlScript8: step26: ${e.toString()}");
      }

      //step27
      try {
        await dbClient.rawQuery('ALTER TABLE SaleQuoteDetails RENAME COLUMN invoicedQuantity TO invoicedQuantityOld');
        print("sqlScript8: step27 sucessfull");
      } catch (e) {
        print("sqlScript8: step27: ${e.toString()}");
      }

      // step28
      try {
        await dbClient.rawQuery('ALTER TABLE SaleQuoteDetails ADD invoicedQuantity NUMERIC DEFAULT 0 NOT NULL');
        print("sqlScript8: step28 sucessfull");
      } catch (e) {
        print("sqlScript8: step28: ${e.toString()}");
      }

      //step29
      try {
        await dbClient.rawQuery('UPDATE SaleQuoteDetails SET invoicedQuantity = invoicedQuantityOld');
        print("sqlScript8: step29 sucessfull");
      } catch (e) {
        print("sqlScript8: step29: ${e.toString()}");
      }

      //step30
      try {
        await dbClient.rawQuery('ALTER TABLE SaleQuoteDetails RENAME COLUMN quantity TO quantityOld');
        print("sqlScript8: step30 sucessfull");
      } catch (e) {
        print("sqlScript8: step30: ${e.toString()}");
      }

      // step31
      try {
        await dbClient.rawQuery('ALTER TABLE SaleQuoteDetails ADD quantity NUMERIC DEFAULT 0 NOT NULL');
        print("sqlScript8: step31 sucessfull");
      } catch (e) {
        print("sqlScript8: step31: ${e.toString()}");
      }

      //step32
      try {
        await dbClient.rawQuery('UPDATE SaleQuoteDetails SET quantity = quantityOld');
        print("sqlScript8: step32 sucessfull");
      } catch (e) {
        print("sqlScript8: step32: ${e.toString()}");
      }

      //step33
      try {
        await dbClient.rawQuery("""CREATE TABLE `PaymentSaleQuotes` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`paymentId`	INTEGER NOT NULL,
	`saleQuoteId`	INTEGER NOT NULL,
	`amount`	NUMERIC NOT NULL,
	`isCancel`	TEXT NOT NULL,
	`createdAt`	TEXT NOT NULL,
	`modifiedAt`	TEXT NOT NULL,
	`businessId`	INTEGER NOT NULL,
	FOREIGN KEY(`paymentId`) REFERENCES `Payments`(`id`),
	FOREIGN KEY(`saleQuoteId`) REFERENCES `SaleQuotes`(`id`),
	FOREIGN KEY(`businessId`) REFERENCES `Businesses`(`id`)
)""");
        print("sqlScript8: step33 sucessfull");
      } catch (e) {
        print("sqlScript8: step33: ${e.toString()}");
      }

      //step34
      try {
        await dbClient.rawQuery('ALTER TABLE SaleInvoices ADD salesQuoteId INTEGER');
        print("sqlScript8: step34 sucessfull");
      } catch (e) {
        print("sqlScript8: step34: ${e.toString()}");
      }

      //step35
      try {
        await dbClient.rawQuery('ALTER TABLE SaleInvoices ADD includeAttachmentsEmail TEXT DEFAULT "0" NOT NULL');
        print("sqlScript8: step35 sucessfull");
      } catch (e) {
        print("sqlScript8: step35: ${e.toString()}");
      }

      //step36
      try {
        await dbClient.rawQuery("""CREATE TABLE `SaleQuoteDetailTaxes` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`saleQuoteDetailId`	INTEGER NOT NULL,
	`taxId`	INTEGER NOT NULL,
	`percentage`	NUMERIC NOT NULL,
	`taxAmount`	NUMERIC NOT NULL,
	`createdAt`	TEXT NOT NULL,
	`modifiedAt`	TEXT NOT NULL,
	`businessId`	INTEGER NOT NULL,
	FOREIGN KEY(`saleQuoteDetailId`) REFERENCES `SaleQuoteDetails`(`id`),
	FOREIGN KEY(`taxId`) REFERENCES `TaxMasters`(`id`),
	FOREIGN KEY(`businessId`) REFERENCES `Businesses`(`id`)
)
""");
        print("sqlScript8: step36 sucessfull");
      } catch (e) {
        print("sqlScript8: step36: ${e.toString()}");
      }

      //step37
      try {
        await dbClient.rawQuery("""CREATE TABLE "SaleQuoteDetails" (
	"id"	INTEGER NOT NULL,
	"saleQuoteId"	INTEGER NOT NULL,
	"productId"	INTEGER NOT NULL,
	"unitId"	INTEGER,
	"unitCode"	TEXT,
	"quantityOld"	INTEGER NOT NULL,
	"invoicedQuantity"	NUMERIC NOT NULL,
	"unitPrice"	NUMERIC NOT NULL,
	"amount"	NUMERIC NOT NULL,
	"isDelete"	TEXT NOT NULL,
	"createdAt"	TEXT NOT NULL,
	"modifiedAt"	TEXT NOT NULL,
	"productName"	TEXT NOT NULL,
	"productCode"	INTEGER NOT NULL,
	"productTypeName"	TEXT NOT NULL,
	"actualUnitPrice"	NUMERIC NOT NULL,
	"businessId"	INTEGER NOT NULL,
	"productUnitId"	INTEGER,
	"versionNumber"	INTEGER,
	"productDescription"	TEXT,
	"quantity"	NUMERIC NOT NULL,
	"invoicedQuantityOld"	INTEGER NOT NULL,
	FOREIGN KEY("saleQuoteId") REFERENCES "SaleOrders"("id"),
	FOREIGN KEY("businessId") REFERENCES "Businesses"("id"),
	FOREIGN KEY("productUnitId") REFERENCES "Units"("id"),
	FOREIGN KEY("productId") REFERENCES "Products"("id"),
	FOREIGN KEY("unitId") REFERENCES "Units"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
)
""");
        print("sqlScript8: step37 sucessfull");
      } catch (e) {
        print("sqlScript8: step37: ${e.toString()}");
      }

      //step38
      try {
        await dbClient.rawQuery("""
CREATE TABLE `SaleQuoteTaxes` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`saleQuoteId`	INTEGER NOT NULL,
	`taxId`	INTEGER NOT NULL,
	`percentage`	NUMERIC NOT NULL,
	`totalAmount`	NUMERIC NOT NULL,
	`createdAt`	TEXT NOT NULL,
	`modifiedAt`	TEXT NOT NULL,
	`businessId`	INTEGER NOT NULL,
	FOREIGN KEY(`saleQuoteId`) REFERENCES `SaleQuotes`(`id`),
	FOREIGN KEY(`taxId`) REFERENCES `TaxMasters`(`id`),
	FOREIGN KEY(`businessId`) REFERENCES `Businesses`(`id`)
)
""");
        print("sqlScript8: step38 sucessfull");
      } catch (e) {
        print("sqlScript8: step38: ${e.toString()}");
      }

      //step39
      try {
        await dbClient.rawQuery("""
CREATE TABLE "SaleQuotes" (
	"id"	INTEGER NOT NULL,
	"saleQuoteNumber"	TEXT NOT NULL,
	"accountId"	INTEGER NOT NULL,
	"grossAmount"	NUMERIC NOT NULL,
	"finalTax"	NUMERIC NOT NULL,
	"taxGroup"	TEXT,
	"discount"	NUMERIC NOT NULL,
	"netAmount"	NUMERIC NOT NULL,
	"orderDate"	TEXT NOT NULL,
	"deliveryDate"	TEXT,
	"isComplete"	TEXT NOT NULL,
	"status"	TEXT NOT NULL,
	"voucherNumber"	TEXT,
	"remark"	TEXT,
	"isDelete"	TEXT NOT NULL,
	"createdAt"	TEXT NOT NULL,
	"modifiedAt"	TEXT NOT NULL,
	"businessId"	INTEGER NOT NULL,
	"versionNumber"	TEXT NOT NULL,
	"showRemarkInPrint"	TEXT NOT NULL,
	"isEmailSent"	TEXT NOT NULL,
	"pdfPath"	TEXT,
	"includeAttachmentsEmail"	TEXT NOT NULL,
	FOREIGN KEY("businessId") REFERENCES "Businesses"("id"),
	FOREIGN KEY("accountId") REFERENCES "Accounts"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
)
""");
        print("sqlScript8: step39 sucessfull");
      } catch (e) {
        print("sqlScript8: step39: ${e.toString()}");
      }

      //step40
//       try {
//         await dbClient.rawQuery("""
// CREATE TABLE `SaleQuotesInvoices` (
// 	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
// 	`saleQuoteId`	INTEGER NOT NULL,
// 	`saleInvoiceId`	INTEGER NOT NULL,
// 	`isDelete`	TEXT NOT NULL,
// 	`createdAt`	TEXT NOT NULL,
// 	`modifiedAt`	TEXT NOT NULL,
// 	`businessId`	INTEGER NOT NULL,
// 	FOREIGN KEY(`saleQuoteId`) REFERENCES `SaleQuotes`(`id`),
// 	FOREIGN KEY(`saleInvoiceId`) REFERENCES `SaleInvoices`(`id`)
// )
// """);
//         print("sqlScript8: step40 sucessfull");
//       } catch (e) {
//         print("sqlScript8: step40: ${e.toString()}");
//       }

      // step41
      try {
        await dbClient.rawQuery('ALTER TABLE SaleOrderDetails ADD productDescription TEXT');
        print("sqlScript8: step41 sucessfull");
      } catch (e) {
        print("sqlScript8: step41: ${e.toString()}");
      }

      // step42
      try {
        await dbClient.rawQuery('ALTER TABLE SaleInvoiceDetails ADD productDescription TEXT');
        print("sqlScript8: step42 sucessfull");
      } catch (e) {
        print("sqlScript8: step42: ${e.toString()}");
      }

      // step43
      try {
        await dbClient.rawQuery('ALTER TABLE SaleInvoices ADD salesOrderId INTEGER');
        print("sqlScript8: step43 sucessfull");
      } catch (e) {
        print("sqlScript8: step43: ${e.toString()}");
      }
    } catch (e) {
      print('Exception - sqlScript8(): ' + e.toString());
    }
  }

  Future<int> paymentDelete({List<int> paymentIdList}) async //delete payment from Payments Table //paymentDeletePayment
  {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM Payments WHERE id IN (${paymentIdList.toString().substring(1, (paymentIdList.toString().length - 1))})');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentDetailDelete({int paymentDetailId, List<int> paymentIdList}) async //delete invoice Details from PaymentDetails Table //paymentDetailDeletePaymentDetail
  {
    try {
      var dbClient = await db;
      int result;
      if (paymentDetailId != null) {
        result = await dbClient.rawDelete('delete from PaymentDetails where id=$paymentDetailId');
      } else if (paymentIdList != null) {
        result = await dbClient.rawDelete('delete from PaymentDetails where paymentId IN (${paymentIdList.toString().substring(1, (paymentIdList.toString().length - 1))})');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentDetailDelete(): ' + e.toString());
    }
    return null;
  }

  Future<List<PaymentDetail>> paymentDetailGetList({List<int> paymentIdList}) async //display list of payment from PaymentDetails Table //paymentDetailDisplayPaymentDetail
  {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery('SELECT * FROM PaymentDetails WHERE businessId=${_business.id} AND paymentId IN (${paymentIdList.toString().substring(1, (paymentIdList.toString().length - 1))})');
      return result.map((f) => PaymentDetail.fromMap(f)).toList();
    } catch (e) {
      print('Exception - paymentDetailGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentDetailInsert(PaymentDetail obj) async //insertion in PaymentDetails Table //paymentDetailCreatePaymentDetail
  {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.insert('PaymentDetails', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentDetailInsert(): ' + e.toString());
      return null;
    }
  }

  Future paymentDetailUpdate(PaymentDetail obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('PaymentDetails', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentDetailUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentGetCount() async //get no.of active payments from Payments Table //paymentGetCount
  {
    try {
      var dbClient = await db;
      return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM Payments WHERE businessId=? AND isCancel=?', [_business.id, 'false']));
    } catch (e) {
      print('Exception - paymentGetCount(): ' + e.toString());
      return null;
    }
  }

  Future<List<Payment>> paymentGetList({int startIndex, int fetchRecords, List<int> paymentIdList, int accountId, DateTime startDate, DateTime endDate, bool isCancel, bool isDelete, String accountCode, String invoiceno, String paymentType, String orderBy}) async //display list of payment from Payments Table //paymentDisplayPayment
  {
    try {
      var dbClient = await db;

      String query = 'SELECT p.* FROM Payments p left join PaymentSaleOrders pso on pso.paymentId = p.id left join SaleInvoices si on si.salesOrderId = pso.saleOrderId WHERE si.id is null';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' p.businessId = ${_business.id}';
      }
      if (paymentIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' p.id IN (${paymentIdList.toString().substring(1, (paymentIdList.toString().length - 1))})';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' p.accountId = $accountId ';
      }

      if (paymentType != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' p.paymentType = \'$paymentType\'';
      }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (p.transactionDate >= \'$startDate\' AND p.transactionDate <= \'$endDate\') ';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' p.transactionDate >= \'$startDate\' ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' p.transactionDate <= \'$endDate\' ';
      }

      if (isCancel != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' p.isCancel = \'$isCancel\' ';
      }

      if (isDelete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' p.isDelete = \'$isDelete\' ';
      } else {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' p.isDelete = \'false\' ';
      }

      if (orderBy != null) {
        query += ' ORDER BY p.id $orderBy';
      }

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords ';
      }
      //  print(query);
      var result = await dbClient.rawQuery(query);
      //   print(result);
      return result.map((f) => Payment.fromMap(f)).toList();
    } catch (e) {
      print('Exception - paymentGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List> paymentGetRecentPayment() async //display last 5 payments from Payments Table //paymentDisplayRecentPayment
  {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery('SELECT * FROM Payments WHERE businessId=${_business.id} ORDER BY transactionDate DESC LIMIT 5');
      return result.toList();
    } catch (e) {
      print('Exception - paymentGetRecentPayment(): ' + e.toString());
      return null;
    }
  }

  Future<double> paymentGetSumOfAmount({String paymentType, List<int> paymentIdList, int accountId}) async //get no.of active invoices from SaleInvoices Table //invoiceGetCount
  {
    try {
      double _result;
      String _value;
      var dbClient = await db;
      String query = 'SELECT SUM(amount) FROM Payments WHERE businessId=${_business.id} AND isCancel != \'true\'';

      if (paymentIdList != null) {
        query += ' AND id IN (${paymentIdList.toString().substring(1, (paymentIdList.toString().length - 1))})';
      }

      if (paymentType != null) {
        query += 'AND paymentType = \'$paymentType\'';
      }

      if (accountId != null) {
        query += 'AND accountId = $accountId';
      }

      var result = await dbClient.rawQuery(query);
      _value = result[0].values.toString().substring(1, result[0].values.toString().length - 1);
      if (_value != 'null') {
        _result = double.parse(result[0].values.toString().substring(1, result[0].values.toString().length - 1));
      }
      return (_value != 'null') ? _result : 0;
    } catch (e) {
      print('Exception - paymentGetSumOfAmount(): ' + e.toString());
      return null;
    }
  }

  Future<Payment> paymentInsert(Payment obj) async //insertion in Payments Table //paymentCreatePayment
  {
    try {
      var dbClient = await db;
      obj.isCancel = false;
      obj.isDelete = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('Payments', obj.toMap(true));
      obj.paymentDetailList.map((paymentDetail) => paymentDetail.paymentId = obj.id).toList();
      for (int i = 0; i < obj.paymentDetailList.length; i++) {
        if (obj.paymentDetailList[i].id != null) {
          obj.paymentDetailList[i].id = null;
        }
      }
      obj.paymentDetailList.map((paymentDetail) async => paymentDetail.id = await paymentDetailInsert(paymentDetail)).toList();
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj;
    } catch (e) {
      print('Exception - paymentInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentPurchaseInvoiceDelete({int paymentInvoiceId, List<int> paymentIdList, int invoiceId}) async //delete payment invoice from PaymentSaleSaleInvoices Table //paymentInvoiceDeletePaymentSaleInvoices
  {
    try {
      var dbClient = await db;
      int result;
      if (paymentInvoiceId != null) {
        result = await dbClient.delete('PaymentPurchaseInvoices', where: 'id=$paymentInvoiceId');
      } else if (paymentIdList != null) {
        result = await dbClient.delete('PaymentPurchaseInvoices', where: 'paymentId IN (${paymentIdList.toString().substring(1, (paymentIdList.toString().length - 1))})');
      } else if (invoiceId != null) {
        result = await dbClient.delete('PaymentPurchaseInvoices', where: 'invoiceId=$invoiceId');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentPurchaseInvoiceDelete(): ' + e.toString());
    }
    return null;
  }

  Future<List<PaymentPurchaseInvoice>> paymentPurchaseInvoiceGetList({int paymentId, int invoiceId, bool isCancel, List<int> invoiceIdList}) async //display list of payment from PaymentDetails Table //paymentDetailDisplayPaymentDetail
  {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.invoiceNumber FROM PaymentPurchaseInvoices t1 INNER JOIN PurchaseInvoices t2 ON t1.invoiceId = t2.id';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (paymentId != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.paymentId = $paymentId';
      }

      if (invoiceIdList != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.invoiceId in (${invoiceIdList.toString().substring(1, (invoiceIdList.toString().length - 1))})';
      }

      if (invoiceId != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.invoiceId = $invoiceId';
      }

      if (isCancel != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.isCancel = \'$isCancel\'';
      }
      // print(query);
      var result = await dbClient.rawQuery(query);
      return result.map((f) => PaymentPurchaseInvoice.fromMap(f)).toList();
    } catch (e) {
      print('Exception - paymentPurchaseInvoiceGetList(): ' + e.toString());
      return null;
    }
  }

  Future<PaymentPurchaseInvoice> paymentPurchaseInvoiceInsert(PaymentPurchaseInvoice obj) async //insertion in PaymentSaleSaleInvoices Table //paymentInvoiceCreatePaymentSaleSaleInvoices
  {
    try {
      var dbClient = await db;
      obj.isCancel = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('PaymentPurchaseInvoices', obj.toMap());
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj;
    } catch (e) {
      print('Exception - paymentPurchaseInvoiceInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentPurchaseInvoiceReturnDelete({int paymentPurchaseInvoiceReturnId, List<int> paymentIdList, String transactionGroupId}) async //delete payment invoice from PaymentSaleSaleInvoices Table //paymentInvoiceDeletePaymentSaleInvoices
  {
    try {
      var dbClient = await db;
      int result;
      if (paymentPurchaseInvoiceReturnId != null) {
        result = await dbClient.delete('PaymentPurchaseInvoiceReturns', where: 'id=$paymentPurchaseInvoiceReturnId');
      } else if (paymentIdList != null) {
        result = await dbClient.delete('PaymentPurchaseInvoiceReturns', where: 'paymentId IN (${paymentIdList.toString().substring(1, (paymentIdList.toString().length - 1))})');
      } else if (transactionGroupId != null) {
        result = await dbClient.delete('PaymentPurchaseInvoiceReturns', where: 'transactionGroupId= \'$transactionGroupId\'');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentPurchaseInvoiceReturnDelete(): ' + e.toString());
    }
    return null;
  }

  Future<List<PaymentPurchaseInvoiceReturn>> paymentPurchaseInvoiceReturnGetList({int paymentId, bool isCancel, String transactionGroupId}) async //display list of payment from PaymentDetails Table //paymentDetailDisplayPaymentDetail
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM PaymentPurchaseInvoiceReturns';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (paymentId != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' paymentId = $paymentId';
      }

      if (transactionGroupId != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' transactionGroupId = \'$transactionGroupId\'';
      }

      if (isCancel != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' isCancel = \'$isCancel\'';
      }
      var result = await dbClient.rawQuery(query);
      return result.map((f) => PaymentPurchaseInvoiceReturn.fromMap(f)).toList();
    } catch (e) {
      print('Exception - paymentPurchaseInvoiceReturnGetList(): ' + e.toString());
      return null;
    }
  }

  Future<double> paymentPurchaseInvoiceReturnGetSumOfAmount({List<int> paymentIdList}) async //get no.of active invoices from SaleInvoices Table //invoiceGetCount
  {
    try {
      double _result;
      String _value;
      var dbClient = await db;
      String query = 'SELECT SUM(amount) FROM PaymentPurchaseInvoiceReturns WHERE businessId=${_business.id} AND paymentId IN ( ${paymentIdList.join(",")})';
      var result = await dbClient.rawQuery(query);
      _value = result[0].values.toString().substring(1, result[0].values.toString().length - 1);
      if (_value != 'null') {
        _result = double.parse(result[0].values.toString().substring(1, result[0].values.toString().length - 1));
      }
      return (_value != 'null') ? _result : 0;
    } catch (e) {
      print('Exception - paymentPurchaseInvoiceReturnGetSumOfAmount(): ' + e.toString());
      return null;
    }
  }

  Future<PaymentPurchaseInvoiceReturn> paymentPurchaseInvoiceReturnInsert(PaymentPurchaseInvoiceReturn obj) async //insertion in PaymentSaleSaleInvoices Table //paymentInvoiceCreatePaymentSaleSaleInvoices
  {
    try {
      var dbClient = await db;
      obj.isCancel = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('PaymentPurchaseInvoiceReturns', obj.toMap());
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj;
    } catch (e) {
      print('Exception - paymentPurchaseInvoiceReturnInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentPurchaseInvoiceUpdate(PaymentPurchaseInvoice obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('PaymentPurchaseInvoices', obj.toMap(), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentPurchaseInvoiceUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentPurchaseInvoiceReturnUpdate(PaymentPurchaseInvoiceReturn obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('PaymentPurchaseInvoiceReturns', obj.toMap(), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentPurchaseInvoiceReturnUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentSaleInvoiceDelete({int paymentInvoiceId, List<int> paymentIdList, int invoiceId}) async //delete payment invoice from PaymentSaleSaleInvoices Table //paymentInvoiceDeletePaymentSaleInvoices
  {
    try {
      var dbClient = await db;
      int result;
      if (paymentInvoiceId != null) {
        result = await dbClient.delete('PaymentSaleInvoices', where: 'id=$paymentInvoiceId');
      } else if (paymentIdList != null) {
        result = await dbClient.delete('PaymentSaleInvoices', where: 'paymentId IN (${paymentIdList.toString().substring(1, (paymentIdList.toString().length - 1))})');
      } else if (invoiceId != null) {
        result = await dbClient.delete('PaymentSaleInvoices', where: 'invoiceId=$invoiceId');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentSaleInvoiceDelete(): ' + e.toString());
    }
    return null;
  }

  Future<int> paymentSaleOrderDelete({int paymentSaleOrderId, List<int> paymentIdList, int saleOrderId}) async //delete payment invoice from PaymentSaleSaleInvoices Table //paymentInvoiceDeletePaymentSaleInvoices
  {
    try {
      var dbClient = await db;
      int result;
      if (paymentSaleOrderId != null) {
        result = await dbClient.delete('PaymentSaleOrders', where: 'id=$paymentSaleOrderId');
      } else if (paymentIdList != null) {
        result = await dbClient.delete('PaymentSaleOrders', where: 'paymentId IN (${paymentIdList.join(',')})');
      } else if (saleOrderId != null) {
        result = await dbClient.delete('PaymentSaleOrders', where: 'saleOrderId=$saleOrderId');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentSaleOrderDelete(): ' + e.toString());
    }
    return null;
  }

  Future<int> paymentSaleQuoteDelete({int paymentSaleQuoteId, List<int> paymentIdList, int saleQuoteId}) async //delete payment invoice from PaymentSaleSaleInvoices Table //paymentInvoiceDeletePaymentSaleInvoices
  {
    try {
      var dbClient = await db;
      int result;
      if (paymentSaleQuoteId != null) {
        result = await dbClient.delete('PaymentSaleQuotes', where: 'id=$paymentSaleQuoteId');
      } else if (paymentIdList != null) {
        result = await dbClient.delete('PaymentSaleQuotes', where: 'paymentId IN (${paymentIdList.join(',')})');
      } else if (saleQuoteId != null) {
        result = await dbClient.delete('PaymentSaleQuotes', where: 'saleQuoteId=$saleQuoteId');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentSaleQuoteDelete(): ' + e.toString());
    }
    return null;
  }

  Future<List<PaymentSaleInvoice>> paymentSaleInvoiceGetList({int paymentId, int invoiceId, bool isCancel, List<int> invoiceIdList}) async //display list of payment from PaymentDetails Table //paymentDetailDisplayPaymentDetail
  {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.invoiceNumber FROM PaymentSaleInvoices t1 INNER JOIN SaleInvoices t2 ON t1.invoiceId = t2.id';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (paymentId != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.paymentId = $paymentId';
      }

      if (invoiceIdList != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.invoiceId in (${invoiceIdList.toString().substring(1, (invoiceIdList.toString().length - 1))})';
      }

      if (invoiceId != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.invoiceId = $invoiceId';
      }

      if (isCancel != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.isCancel = \'$isCancel\'';
      }
      // print(query);
      var result = await dbClient.rawQuery(query);
      return result.map((f) => PaymentSaleInvoice.fromMap(f)).toList();
    } catch (e) {
      print('Exception - paymentSaleInvoiceGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<PaymentSaleOrder>> paymentSaleOrderGetList({List<int> paymentIdList, bool isCancel, List<int> orderIdList}) async //display list of payment from PaymentDetails Table //paymentDetailDisplayPaymentDetail
  {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.saleOrderNumber FROM PaymentSaleOrders t1 INNER JOIN SaleOrders t2 ON t1.saleOrderId = t2.id';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (paymentIdList != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.paymentId IN (${paymentIdList.join(',')})';
      }

      if (orderIdList != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.saleOrderId in (${orderIdList.toString().substring(1, (orderIdList.toString().length - 1))})';
      }

      if (isCancel != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.isCancel = \'$isCancel\'';
      }
      // print(query);
      var result = await dbClient.rawQuery(query);
      return result.map((f) => PaymentSaleOrder.fromMap(f)).toList();
    } catch (e) {
      print('Exception - paymentSaleOrderGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<PaymentSaleQuotes>> paymentSaleQuoteGetList({List<int> paymentIdList, bool isCancel, List<int> orderIdList}) async //display list of payment from PaymentDetails Table //paymentDetailDisplayPaymentDetail
  {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.saleQuoteNumber FROM PaymentSaleQuotes t1 INNER JOIN SaleQuotes t2 ON t1.saleQuoteId = t2.id';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (paymentIdList != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.paymentId IN (${paymentIdList.join(',')})';
      }

      if (orderIdList != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.saleQuoteId in (${orderIdList.toString().substring(1, (orderIdList.toString().length - 1))})';
      }

      if (isCancel != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' t1.isCancel = \'$isCancel\'';
      }
      // print(query);
      var result = await dbClient.rawQuery(query);
      return result.map((f) => PaymentSaleQuotes.fromMap(f)).toList();
    } catch (e) {
      print('Exception - paymentSaleQuoteGetList(): ' + e.toString());
      return null;
    }
  }

  Future<PaymentSaleInvoice> paymentSaleInvoiceInsert(PaymentSaleInvoice obj) async //insertion in PaymentSaleSaleInvoices Table //paymentInvoiceCreatePaymentSaleSaleInvoices
  {
    try {
      var dbClient = await db;
      obj.isCancel = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('PaymentSaleInvoices', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj;
    } catch (e) {
      print('Exception - paymentSaleInvoiceInsert(): ' + e.toString());
      return null;
    }
  }

  Future<SaleOrderInvoice> saleOrderInvoiceInsert(SaleOrderInvoice obj) async //insertion in PaymentSaleSaleInvoices Table //paymentInvoiceCreatePaymentSaleSaleInvoices
  {
    try {
      var dbClient = await db;
      obj.isDelete = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('SaleOrdersInvoices', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj;
    } catch (e) {
      print('Exception - saleOrderInvoiceInsert(): ' + e.toString());
      return null;
    }
  }

  Future<PaymentSaleOrder> paymentSaleOrderInsert(PaymentSaleOrder obj) async //insertion in PaymentSaleSaleInvoices Table //paymentInvoiceCreatePaymentSaleSaleInvoices
  {
    try {
      var dbClient = await db;
      obj.isCancel = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('PaymentSaleOrders', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj;
    } catch (e) {
      print('Exception - paymentSaleOrderInsert(): ' + e.toString());
      return null;
    }
  }

  Future<PaymentSaleQuotes> paymentSaleQuoteInsert(PaymentSaleQuotes obj) async //insertion in PaymentSaleSaleInvoices Table //paymentInvoiceCreatePaymentSaleSaleInvoices
  {
    try {
      var dbClient = await db;
      obj.isCancel = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('PaymentSaleQuotes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj;
    } catch (e) {
      print('Exception - paymentSaleQuoteInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentSaleInvoiceReturnDelete({int paymentSaleInvoiceReturnId, List<int> paymentIdList, String transactionGroupId}) async //delete payment invoice from PaymentSaleSaleInvoices Table //paymentInvoiceDeletePaymentSaleInvoices
  {
    try {
      var dbClient = await db;
      int result;
      if (paymentSaleInvoiceReturnId != null) {
        result = await dbClient.delete('PaymentSaleInvoiceReturns', where: 'id=$paymentSaleInvoiceReturnId');
      } else if (paymentIdList != null) {
        result = await dbClient.delete('PaymentSaleInvoiceReturns', where: 'paymentId IN (${paymentIdList.toString().substring(1, (paymentIdList.toString().length - 1))})');
      } else if (transactionGroupId != null) {
        result = await dbClient.delete('PaymentSaleInvoiceReturns', where: 'transactionGroupId= \'$transactionGroupId\'');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentSaleInvoiceReturnDelete(): ' + e.toString());
    }
    return null;
  }

  Future<List<PaymentSaleInvoiceReturn>> paymentSaleInvoiceReturnGetList({int paymentId, bool isCancel, String transactionGroupId}) async //display list of payment from PaymentDetails Table //paymentDetailDisplayPaymentDetail
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM PaymentSaleInvoiceReturns';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (paymentId != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' paymentId = $paymentId';
      }

      if (transactionGroupId != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' transactionGroupId = \'$transactionGroupId\'';
      }

      if (isCancel != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }

        query += ' isCancel = \'$isCancel\'';
      }
      var result = await dbClient.rawQuery(query);
      return result.map((f) => PaymentSaleInvoiceReturn.fromMap(f)).toList();
    } catch (e) {
      print('Exception - paymentSaleInvoiceGetList(): ' + e.toString());
      return null;
    }
  }

  Future<double> paymentSaleInvoiceReturnGetSumOfAmount({List<int> paymentIdList}) async //get no.of active invoices from SaleInvoices Table //invoiceGetCount
  {
    try {
      double _result;
      String _value;
      var dbClient = await db;
      String query = 'SELECT SUM(amount) FROM PaymentSaleInvoiceReturns WHERE businessId=${_business.id} AND paymentId IN ( ${paymentIdList.join(",")})';
      var result = await dbClient.rawQuery(query);
      _value = result[0].values.toString().substring(1, result[0].values.toString().length - 1);
      if (_value != 'null') {
        _result = double.parse(result[0].values.toString().substring(1, result[0].values.toString().length - 1));
      }
      return (_value != 'null') ? _result : 0;
    } catch (e) {
      print('Exception - paymentSaleInvoiceReturnGetSumOfAmount(): ' + e.toString());
      return null;
    }
  }

  Future<PaymentSaleInvoiceReturn> paymentSaleInvoiceReturnInsert(PaymentSaleInvoiceReturn obj) async //insertion in PaymentSaleSaleInvoices Table //paymentInvoiceCreatePaymentSaleSaleInvoices
  {
    try {
      var dbClient = await db;
      obj.isCancel = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('PaymentSaleInvoiceReturns', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj;
    } catch (e) {
      print('Exception - paymentSaleInvoiceReturnInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentSaleInvoiceUpdate(PaymentSaleInvoice obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('PaymentSaleInvoices', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentSaleInvoiceUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentSaleInvoiceReturnUpdate(PaymentSaleInvoiceReturn obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('PaymentSaleInvoiceReturns', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentSaleInvoiceReturnUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentSaleOrderUpdate(PaymentSaleOrder obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('PaymentSaleOrders', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentSaleOrderUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentSaleQuoteUpdate(PaymentSaleQuotes obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('PaymentSaleQuotes', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentSaleQuoteUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> paymentUpdate(Payment obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('Payments', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - paymentUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<bool> productCheckNameExist({String productName, int productId}) async //check product name already exist or not in Products Table //productCheckName
  {
    try {
      var dbClient = await db;
      String sql = 'SELECT COUNT(*) FROM Products WHERE businessId=${_business.id}';

      if (productId != null) {
        sql += ' AND id!=\'$productId\'';
      }
      if (productName != null) {
        sql += ' AND (lower(name)=\'$productName\' OR upper(name)=\'$productName\' OR name = \'$productName\')';
      }
      int result = Sqflite.firstIntValue(await dbClient.rawQuery(sql));
      return result == 1 ? true : false;
    } catch (e) {
      print('Exception - productCheckNameExist(): ' + e.toString());
      return null;
    }
  }

  Future<int> productDelete(int productId) async //delete product from Products Table //productDeleteProduct
  {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM Products WHERE id=$productId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - productDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> productExistInInvoice({int productId}) async //get no.of customers from Account Table //accountGetCount
  {
    try {
      var dbClient = await db;
      String query = 'SELECT COUNT(*) FROM SaleInvoiceDetails WHERE businessId=${_business.id} AND productId = $productId';
      int value = Sqflite.firstIntValue(await dbClient.rawQuery(query));
      if (value == 0) {
        String query = 'SELECT COUNT(*) FROM PurchaseInvoiceDetails WHERE businessId=${_business.id} AND productId = $productId';
        value = Sqflite.firstIntValue(await dbClient.rawQuery(query));
      }
      return value;
    } catch (e) {
      print('Exception - accountGetCount(): ' + e.toString());
      return null;
    }
  }

  Future<List<Product>> productGetList({int startIndex, int fetchRecords, String searchString, List<int> productId, int productTypeId, bool isActive, bool isDelete, String productCodePrefix, String productCodePrefixLen}) async //display all products from Products Table //productDisplayProducts
  {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.typeName FROM Products t1 INNER JOIN ProductTypes t2 ON t1.productTypeId = t2.id';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (productId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.id IN (${productId.toString().substring(1, (productId.toString().length - 1))})';
      }

      if (productTypeId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.productTypeId = $productTypeId';
      }

      if (searchString != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' \'$productCodePrefix\'||substr(0||0||0||0||0||0||0||0||0||t1.productCode,(-$productCodePrefixLen+${productCodePrefix.length})) LIKE \'%$searchString%\' OR t1.name LIKE \'%$searchString%\' OR t1.supplierProductCode LIKE \'%$searchString%\'';
      }

      if (isActive != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.isActive = \'$isActive\'';
      }
      query += ' ORDER BY t1.name';

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => Product.fromMap(f)).toList();
    } catch (e) {
      print('Exception - productGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> productGetNewProductCode() async //fetch all products for generate product code from Products Table //productFetchProducts
  {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery('select MAX(productCode) from Products WHERE businessId=?', [_business.id]);
      if (result[0].values.first == null) {
        return 1;
      } else {
        int res = result[0].values.first;
        return res + 1;
      }
    } catch (e) {
      print('Exception - productGetListForGenerateCode(): ' + e.toString());
      return null;
    }
  }

  Future<int> productInsert(Product obj) async //add  product in Products Table //productCreateProduct
  {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.isDelete = false;
      obj.id = await dbClient.insert('Products', obj.toMap(true));
      obj.productPriceList.map((e) => e.productId = obj.id).toList();
      obj.productPriceList.map((e) async => e.id = await productPriceInsert(e)).toList();
      obj.productTaxList.map((productTax) => productTax.productId = obj.id).toList();
      obj.productTaxList.map((productTax) async => productTax.id = await productTaxInsert(productTax)).toList();
      //   print(obj);
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - productInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> productPriceDelete({int productId, productPriceId}) async {
    try {
      var dbClient = await db;
      int result;
      if (productId != null) {
        result = await dbClient.rawDelete('DELETE FROM ProductPrices WHERE productId = $productId');
      } else if (productPriceId != null) {
        result = await dbClient.rawDelete('DELETE FROM ProductPrices WHERE id = $productId');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - productPriceDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<ProductPrice>> productPriceGetList(int productId) async {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*, t2.code FROM ProductPrices t1 INNER JOIN Units t2 ON t1.unitId = t2.id';

      if (productId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.productId =  \'$productId\'';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => ProductPrice.fromMap(f)).toList();
    } catch (e) {
      print('Exception - productPriceGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> productPriceInsert(ProductPrice obj, {int businessId}) async {
    try {
      var dbClient = await db;
      obj.businessId = (_business != null) ? _business.id : businessId;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('ProductPrices', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - productPriceInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> productTaxDelete(List<int> productIdList) async {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM ProductTaxes WHERE productId IN (${productIdList.toString().substring(1, (productIdList.toString().length - 1))})');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - productTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<ProductTax>> productTaxGetList({List<int> productIdList}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*, t2.taxName, t2.groupName FROM ProductTaxes t1 INNER JOIN TaxMasters t2 ON t1.taxMasterId = t2.id WHERE t1.businessId=${_business.id} AND t1.productId IN (${productIdList.toString().substring(1, (productIdList.toString().length - 1))})';
      var result = await dbClient.rawQuery(query);
      return result.map((f) => ProductTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - productTaxGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> productTaxInsert(ProductTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.insert('ProductTaxes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - productTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future<bool> productTypeCheckTypeExist({String productTypeName, int productTypeId}) async //check product type already exist or not in ProductTypes Table //productTypeCheckType
  {
    try {
      var dbClient = await db;
      String query = 'SELECT COUNT(*) FROM ProductTypes WHERE businessId=${_business.id}';

      if (productTypeId != null) {
        query += ' AND id!=\'$productTypeId\'';
      }

      if (productTypeName != null) {
        query += ' AND (lower(typeName)=\'$productTypeName\' OR upper(typeName)=\'$productTypeName\' OR typeName= \'$productTypeName\')';
      }

      var result = Sqflite.firstIntValue(await dbClient.rawQuery(query));
      return result == 1 ? true : false;
    } catch (e) {
      print('Exception - productTypeCheckTypeExist(): ' + e.toString());
      return null;
    }
  }

  Future<int> productTypeDelete({int productTypeId}) async //delete product type from ProductTypes Table //productTypeDeleteProductType
  {
    try {
      var dbClient = await db;
      int _result;
      if (productTypeId != null) {
        _result = await dbClient.rawDelete('DELETE FROM ProductTypes WHERE id=$productTypeId');
      } else {
        _result = await dbClient.rawDelete('DELETE FROM ProductTypes');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return _result;
    } catch (e) {
      print('Exception - productTypeDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<ProductType>> productTypeGetList({int productTypeId, String searchString, bool isActive}) async //display list of product type from ProductTypes Table //productTypeDisplayProductType
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM ProductTypes';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (productTypeId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' id = $productTypeId';
      }

      if (isActive != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' isActive = \'$isActive\' ';
      }

      if (searchString != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' (typeName LIKE \'%$searchString%\')';
      }

      query += ' ORDER BY typeName';

      var result = await dbClient.rawQuery(query);
      return result.map((f) => ProductType.fromMap(f)).toList();
    } catch (e) {
      print('Exception - productTypeGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> productTypeInsert(ProductType obj) async //insertion in ProductTypes Table //productTypeCreateProductType
  {
    try {
      var dbClient = await db;
      obj.isActive = true;
      obj.isDelete = false;
      if (obj.businessId == null) {
        obj.businessId = _business.id;
      }
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('ProductTypes', obj.toMap(true));
      obj.productTypeTaxList.map((productTypeTax) => productTypeTax.productTypeId = obj.id).toList();
      obj.productTypeTaxList.map((productTypeTax) async => productTypeTax.id = await productTypeTaxInsert(productTypeTax)).toList();
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - productTypeInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> productTypeIsUsed(int productTypeId) async //delete product type from ProductTypes Table //productTypeDeleteProductType
  {
    try {
      var dbClient = await db;
      return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM Products WHERE businessId=? AND productTypeId=?', [_business.id, productTypeId]));
    } catch (e) {
      print('Exception - productTypeDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> productTypeTaxDelete(int productTypeId) async {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM ProductTypeTaxes WHERE productTypeId = $productTypeId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - productTypeTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<ProductTypeTax>> productTypeTaxGetList({int productTypeTaxid, int productTypeId}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.taxName,t2.groupName FROM ProductTypeTaxes t1 INNER JOIN TaxMasters t2 ON t1.taxMasterId = t2.id';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (productTypeId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.productTypeId = $productTypeId';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => ProductTypeTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - taxMasterGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> productTypeTaxInsert(ProductTypeTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.insert('ProductTypeTaxes', obj.toMap());
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - productTypeTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> productTypeTaxUpdate(ProductTypeTax obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('ProductTypeTaxes', obj.toMap(), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - productTypeTaxUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> productTypeUpdate(ProductType obj, bool applyOnAllProducts, bool isTaxAddedAlready) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('ProductTypes', obj.toMap(false), where: 'id=${obj.id}');
      if (result == 1) {
        if (isTaxAddedAlready) {
          obj.productTypeTaxList.map((productTypeTax) async => await productTypeTaxUpdate(productTypeTax)).toList();
        } else {
          obj.productTypeTaxList.map((productTypeTax) => productTypeTax.productTypeId = obj.id).toList();
          obj.productTypeTaxList.map((productTypeTax) async => productTypeTax.id = await productTypeTaxInsert(productTypeTax)).toList();
        }

        if (applyOnAllProducts) {
          List<ProductTax> _productTaxList = [];
          List<Product> _productList = await productGetList(productTypeId: obj.id);
          await productTaxDelete(_productList.map((product) => product.id).toList());
          _productList.forEach((product) {
            obj.productTypeTaxList.forEach((productTypeTax) {
              ProductTax _productTax = ProductTax(null, product.id, productTypeTax.taxMasterId, productTypeTax.percentage, productTypeTax.taxName);
              _productTaxList.add(_productTax);
            });
          });
          _productTaxList.map((productTax) async => await productTaxInsert(productTax)).toList();
        }
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - productTypeUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> productUpdate(Product obj, {bool onlyUpdateProduct}) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int _result = await dbClient.update('Products', obj.toMap(false), where: 'id=${obj.id}');
      if (_result == 1 && onlyUpdateProduct == null) {
        await productTaxDelete([obj.id]);
        await productPriceDelete(productId: obj.id);
        obj.productPriceList.map((e) => e.productId = obj.id).toList();
        obj.productPriceList.map((e) async => e.id = await productPriceInsert(e)).toList();
        obj.productTaxList.map((productTax) => productTax.productId = obj.id).toList();
        obj.productTaxList.map((productTax) async => productTax.id = await productTaxInsert(productTax)).toList();
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return _result;
    } catch (e) {
      print('Exception - productUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceDelete(int invoiceId) async //delete invoice from Invoices Table //invoiceDeleteInvoice
  {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM PurchaseInvoices WHERE id=$invoiceId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - purchaseInvoiceDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceDetailDelete({int invoiceDetailId, int invoiceId}) async //delete invoice Details from SaleInvoiceDetail Table //invoiceDetailDeleteInvoiceDetail
  {
    try {
      var dbClient = await db;

      if (invoiceDetailId != null || invoiceId != null) {
        String query = 'DELETE FROM PurchaseInvoiceDetails ';

        if (invoiceDetailId != null) {
          query += ' WHERE id = $invoiceDetailId ';
        } else if (invoiceId != null) {
          query += ' WHERE invoiceId = $invoiceId ';
        }

        int result = await dbClient.rawDelete(query);
        await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
        return result;
      }
    } catch (e) {
      print('Exception - purchaseInvoiceDetailDelete(): ' + e.toString());
    }
    return null;
  }

  Future purchaseInvoiceDetailGetCount(int invoiceId) async //get no.of active invoices from Invoices Table //invoiceGetCount
  {
    try {
      var dbClient = await db;
      var result = Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM PurchaseInvoiceDetails WHERE businessId=? AND invoiceId=?', [_business.id, invoiceId]));
      return result;
    } catch (e) {
      print('Exception - purchaseInvoiceDetailGetCount(): ' + e.toString());
      return null;
    }
  }

  Future<List<PurchaseInvoiceDetail>> purchaseInvoiceDetailGetList({int invoiceDettailId, int invoiceId, int productId}) async //display list of invoice detail from SaleInvoiceDetail Table //invoiceDetailDisplayInvoiceDetail
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM PurchaseInvoiceDetails ';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (invoiceDettailId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' id = $invoiceDettailId ';
      }

      if (invoiceId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' invoiceId = $invoiceId ';
      }

      if (productId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' productId = $productId ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => PurchaseInvoiceDetail.fromMap(f)).toList();
    } catch (e) {
      print('Exception - purchaseInvoiceDetailGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceDetailInsert(PurchaseInvoiceDetail obj) async //insertion in SaleInvoiceDetail Table //invoiceDetailCreateInvoiceDetail
  {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('PurchaseInvoiceDetails', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - purchaseInvoiceDetailInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceDetailTaxDelete({List<int> invoiceDetailIdList, List<int> invoiceDetailTaxIdList}) async {
    try {
      var dbClient = await db;
      String query;
      if (invoiceDetailIdList != null) {
        query = 'DELETE FROM PurchaseInvoiceDetailTaxes WHERE invoiceDetailId IN (${invoiceDetailIdList.join(',')})';
      } else if (invoiceDetailTaxIdList != null) {
        query = 'DELETE FROM PurchaseInvoiceDetailTaxes WHERE id IN (${invoiceDetailTaxIdList.join(',')})';
      }
      int result = await dbClient.rawDelete(query);
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - purchaseInvoiceDetailTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<PurchaseInvoiceDetailTax>> purchaseInvoiceDetailTaxGetList({List<int> invoiceDetailIdList}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM PurchaseInvoiceDetailTaxes WHERE businessId=${_business.id} AND invoiceDetailId IN (${invoiceDetailIdList.toString().substring(1, (invoiceDetailIdList.toString().length - 1))})';
      var result = await dbClient.rawQuery(query);
      return result.map((f) => PurchaseInvoiceDetailTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - purchaseInvoiceDetailTaxGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceDetailTaxInsert(PurchaseInvoiceDetailTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('PurchaseInvoiceDetailTaxes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - purchaseInvoiceDetailTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future purchaseInvoiceGetCount() async //get no.of active invoices from SaleInvoices Table //invoiceGetCount
  {
    try {
      var dbClient = await db;
      var result = Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM PurchaseInvoices WHERE businessId=? AND status!=?', [_business.id, 'CANCELLED']));
      return result;
    } catch (e) {
      print('Exception - purchaseInvoiceGetCount(): ' + e.toString());
      return null;
    }
  }

  Future<List<PurchaseInvoice>> purchaseInvoiceGetList({int startIndex, int fetchRecords, List<int> invoiceIdList, String invoiceNumber, int accountId, DateTime startDate, DateTime endDate, bool fetchTaxInvoices, String status, bool isComplete, bool isDelete, bool isCancelled, double amountFrom, double amountTo, int lastDays, String orderBy, bool isWithTax}) async //display list of invoices from SaleInvoices Table //invoiceDisplayInvoice
  {
    try {
      //  SaleInvoice();
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.accountCode, t2.namePrefix, t2.firstName, t2.middleName, t2.lastName, t2.nameSuffix FROM PurchaseInvoices t1 INNER JOIN Accounts t2 ON t1.accountId = t2.id ';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (invoiceIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.id IN (${invoiceIdList.toString().substring(1, (invoiceIdList.toString().length - 1))})';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.accountId = $accountId ';
      }

      if (invoiceNumber != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.invoiceNumber = \'$invoiceNumber\' ';
      }

      if (fetchTaxInvoices != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += (fetchTaxInvoices) ? ' t1.finalTax > 0 ' : ' t1.finalTax = 0 ';
      }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate >= \'$startDate\' AND t1.invoiceDate <= \'$endDate\') ';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate >= \'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate <= \'$endDate\') ';
      }

      if (lastDays != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.invoiceDate > (SELECT DATETIME (\'now\', \'-$lastDays day\')) ';
      }

      if (isWithTax != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += (isWithTax) ? ' t1.finalTax > 0 ' : ' t1.finalTax = 0 ';
      }

      //
      if (amountFrom != null && amountTo != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.grossAmount >= $amountFrom AND t1.grossAmount <= $amountTo) ';
      }

      if (amountFrom != null && amountTo == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.grossAmount >= $amountFrom) ';
      }

      if (amountFrom == null && amountTo != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.grossAmount <= $amountTo) ';
      }

      if (isComplete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isComplete = \'$isComplete\' ';
      }

      if (status != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.status = \'$status\' ';
      } else if (isCancelled != null && !isCancelled) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.status != \'CANCELLED\' ';
      }

      if (isDelete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isDelete = \'$isDelete\' ';
      } else {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isDelete = \'false\' ';
      }

      if (orderBy != null) {
        query += ' ORDER BY t1.id $orderBy';
      }else
      {
        query += ' ORDER BY t1.id desc';
      }

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => PurchaseInvoice.fromMap(f)).toList();
    } catch (e) {
      print('Exception - purchaseInvoiceGetList(): ' + e.toString());
      return null;
    }
  }

  Future<double> purchaseInvoiceGetSumOfGrossAmount({int accountId, String invoiceStatus}) async //get no.of active invoices from SaleInvoices Table //invoiceGetCount
  {
    try {
      double _result;
      String _value;
      var dbClient = await db;
      String query = 'SELECT SUM(grossAmount) FROM PurchaseInvoices WHERE businessId=${_business.id} AND status != \'CANCELLED\'';

      if (accountId != null) {
        query += ' AND accountId = $accountId';
      }
      var result = await dbClient.rawQuery(query);
      _value = result[0].values.toString().substring(1, result[0].values.toString().length - 1);
      if (_value != 'null') {
        _result = double.parse(result[0].values.toString().substring(1, result[0].values.toString().length - 1));
      }
      return (_value != 'null') ? _result : 0;
    } catch (e) {
      print('Exception - purchaseInvoiceGetSumOfGrossAmount(): ' + e.toString());
      return null;
    }
  }

  Future<PurchaseInvoice> purchaseInvoiceInsert(PurchaseInvoice obj, bool isTaxApplied) async //insertion in SaleInvoices Table //invoiceCreateInvoice
  {
    try {
      var dbClient = await db;
      obj.isDelete = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('PurchaseInvoices', obj.toMap(true));
      obj.invoiceDetailList.map((invoiceDetail) => invoiceDetail.invoiceId = obj.id).toList();

      for (int i = 0; i < obj.invoiceDetailList.length; i++) {
        await purchaseInvoiceDetailInsert(obj.invoiceDetailList[i]);
      }

      if (obj.invoiceDetailTaxList.length != 0 && isTaxApplied) {
        int _counter = 0;
        //  obj.invoiceDetailList.forEach((invoiceDetail)
        for (int k = 0; k < obj.invoiceDetailList.length; k++) {
          List<ProductTax> _productTaxList = await productTaxGetList(productIdList: [obj.invoiceDetailList[k].productId]);
          if (_productTaxList.length > 0) {
            for (int i = 0; i < obj.invoiceTaxList.length; i++) {
              obj.invoiceDetailTaxList[_counter].invoiceDetailId = obj.invoiceDetailList[k].id;
              _counter++;
            }
          }
        }
      }

      if (isTaxApplied == true) {
        obj.invoiceTaxList.map((invoiceTax) => invoiceTax.invoiceId = obj.id).toList();
        obj.invoiceTaxList.map((invoiceTax) async => invoiceTax.id = await purchaseInvoiceTaxInsert(invoiceTax)).toList();
        obj.invoiceDetailTaxList.map((invoiceDetailTax) async => await purchaseInvoiceDetailTaxInsert(invoiceDetailTax)).toList();
      }

      if (obj.payment.paymentDetailList.length != 0) {
        obj.payment.accountId = obj.accountId;
        obj.payment.amount = obj.payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount);
        obj.payment.transactionDate = obj.invoiceDate;
        obj.payment.paymentType = 'GIVEN';
        obj.payment.remark = obj.remark;
        obj.payment = await paymentInsert(obj.payment);
        obj.paymentInvoice.paymentId = obj.payment.id;
        obj.paymentInvoice.invoiceId = obj.id;
        obj.paymentInvoice.amount = obj.payment.amount;
        obj.paymentInvoice = await paymentPurchaseInvoiceInsert(obj.paymentInvoice);
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj;
    } catch (e) {
      print('Exception - purchaseInvoiceInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceReturnDelete(int purchaseInvoiceReturnId) async //delete invoice from Invoices Table //invoiceDeleteInvoice
  {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM PurchaseInvoiceReturns WHERE id=$purchaseInvoiceReturnId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - purchaseInvoiceReturnDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceReturnDetailDelete({int purchaseInvoiceReturnDetailId, int purchaseInvoiceReturnId}) async //delete invoice Details from SaleInvoiceDetail Table //invoiceDetailDeleteInvoiceDetail
  {
    try {
      var dbClient = await db;

      if (purchaseInvoiceReturnDetailId != null || purchaseInvoiceReturnId != null) {
        String query = 'DELETE FROM PurchaseInvoiceReturnDetails ';

        if (purchaseInvoiceReturnDetailId != null) {
          query += ' WHERE id = $purchaseInvoiceReturnDetailId ';
        } else if (purchaseInvoiceReturnId != null) {
          query += ' WHERE purchaseInvoiceReturnId = $purchaseInvoiceReturnId ';
        }
        await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
        return await dbClient.rawDelete(query);
      }
    } catch (e) {
      print('Exception - purchaseInvoiceReturnDetailDelete(): ' + e.toString());
    }
    return null;
  }

  Future purchaseInvoiceReturnDetailGetCount({int purchaseInvoiceReturnId, int purchaseInvoiceId}) async //get no.of active invoices from Invoices Table //invoiceGetCount
  {
    try {
      var dbClient = await db;
      String query = 'SELECT COUNT(DISTINCT productId) FROM PurchaseInvoiceReturnDetails WHERE businessId=${_business.id}';

      if (purchaseInvoiceReturnId != null) {
        query += ' AND purchaseInvoiceReturnId= $purchaseInvoiceReturnId';
      }

      if (purchaseInvoiceId != null) {
        query += ' AND purchaseInvoiceId= $purchaseInvoiceId';
      }

      var result = Sqflite.firstIntValue(await dbClient.rawQuery(query));
      return result;
    } catch (e) {
      print('Exception - purchaseInvoiceReturnDetailGetCount(): ' + e.toString());
      return null;
    }
  }

  Future<List<PurchaseInvoiceReturnDetail>> purchaseInvoiceReturnDetailGetList({int purchaseInvoiceReturnDetailId, int purchaseInvoiceReturnId, int productId, int purchaseInvoiceId}) async //display list of invoice detail from SaleInvoiceDetail Table //invoiceDetailDisplayInvoiceDetail
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM PurchaseInvoiceReturnDetails ';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (purchaseInvoiceReturnDetailId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' id = $purchaseInvoiceReturnDetailId ';
      }

      if (purchaseInvoiceReturnId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' purchaseInvoiceReturnId = $purchaseInvoiceReturnId ';
      }

      if (productId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' productId = $productId ';
      }

      if (purchaseInvoiceId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' purchaseInvoiceId = $purchaseInvoiceId ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => PurchaseInvoiceReturnDetail.fromMap(f)).toList();
    } catch (e) {
      print('Exception - purchaseInvoiceReturnDetailGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceReturnDetailInsert(PurchaseInvoiceReturnDetail obj, bool isRefundTax) async //insertion in SaleInvoiceDetail Table //invoiceDetailCreateInvoiceDetail
  {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.quantity = obj.returnQuantity;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('PurchaseInvoiceReturnDetails', obj.toMap(true));
      if (isRefundTax) {
        obj.invoiceReturnDetailTaxList.map((f) => f.purchaseInvoiceReturnDetailId = obj.id).toList();
        obj.invoiceReturnDetailTaxList.map((f) async => await purchaseInvoiceReturnDetailTaxInsert(f)).toList();
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - purchaseInvoiceReturnDetailInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceReturnDetailTaxDelete(List<int> purchaseInvoiceReturnDetailIdList) async {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM PurchaseInvoiceReturnDetailTaxes WHERE purchaseInvoiceReturnDetailId IN (${purchaseInvoiceReturnDetailIdList.toString().substring(1, (purchaseInvoiceReturnDetailIdList.toString().length - 1))})');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - purchaseInvoiceReturnDetailTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<PurchaseInvoiceReturnDetailTax>> purchaseInvoiceReturnDetailTaxGetList({List<int> purchaseInvoiceReturnDetailIdList}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM PurchaseInvoiceReturnDetailTaxes WHERE businessId=${_business.id} AND purchaseInvoiceReturnDetailId IN (${purchaseInvoiceReturnDetailIdList.toString().substring(1, (purchaseInvoiceReturnDetailIdList.toString().length - 1))})';
      var result = await dbClient.rawQuery(query);
      return result.map((f) => PurchaseInvoiceReturnDetailTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - purchaseInvoiceReturnDetailTaxGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceReturnDetailTaxInsert(PurchaseInvoiceReturnDetailTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('PurchaseInvoiceReturnDetailTaxes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - purchaseInvoiceReturnDetailTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future<List<PurchaseInvoiceReturn>> purchaseInvoiceReturnGetList({List<String> transactionGroupIdList, List<int> purchaseInvoiceReturnIdList, String purchaseInvoiceNumber, int accountId, DateTime startDate, DateTime endDate, String status, bool isComplete, bool isDelete, double amountFrom, double amountTo, String orderBy}) async //display list of invoices from SaleInvoices Table //invoiceDisplayInvoice
  {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*, t2.accountCode, t2.namePrefix, t2.firstName, t2.middleName, t2.lastName, t2.nameSuffix FROM PurchaseInvoiceReturns t1 INNER JOIN Accounts t2 ON t1.accountId = t2.id ';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (purchaseInvoiceReturnIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.id IN (${purchaseInvoiceReturnIdList.toString().substring(1, (purchaseInvoiceReturnIdList.toString().length - 1))}) ';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.accountId = $accountId ';
      }

      if (transactionGroupIdList != null && transactionGroupIdList.length > 0) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.transactionGroupId IN (\'${transactionGroupIdList.join('\',\'')}\') ';
      }

      if (purchaseInvoiceNumber != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.purchaseInvoiceNumber = \'$purchaseInvoiceNumber\' ';
      }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate >= \'$startDate\' AND t1.invoiceDate <= \'$endDate\') ';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate >= \'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate <= \'$endDate\') ';
      }

      if (amountFrom != null && amountTo != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.grossAmount >= $amountFrom AND t1.grossAmount <= $amountTo) ';
      }

      if (amountFrom != null && amountTo == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.grossAmount >= $amountFrom) ';
      }

      if (amountFrom == null && amountTo != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.grossAmount <= $amountTo) ';
      }

      if (isComplete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isComplete = \'$isComplete\' ';
      }

      if (status != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.status = \'$status\' ';
      }

      if (isDelete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isDelete = \'$isDelete\' ';
      } else {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isDelete = \'false\' ';
      }

      if (orderBy != null) {
        query += ' ORDER BY t1.id $orderBy';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => PurchaseInvoiceReturn.fromMap(f)).toList();
    } catch (e) {
      print('Exception - purchaseInvoiceReturnGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<PurchaseInvoiceReturn>> purchaseInvoiceReturnInsert(List<PurchaseInvoiceReturn> objList, bool isRefundTax, Payment payment) async //insertion in SaleInvoices Table //invoiceCreateInvoice
  {
    try {
      var dbClient = await db;
      for (int i = 0; i < objList.length; i++) {
        int count = 0;
        objList[i].invoiceReturnDetailList.forEach((f) {
          if (f.isSelect) {
            count++;
          }
        });

        if (count > 0) {
          objList[i].isDelete = false;
          objList[i].isRefundTax = isRefundTax;
          objList[i].businessId = _business.id;
          objList[i].createdAt = DateTime.now();
          objList[i].modifiedAt = DateTime.now();
          objList[i].id = await dbClient.insert('PurchaseInvoiceReturns', objList[i].toMap(true));
          if (isRefundTax) {
            objList[i].invoiceReturnTaxList.map((f) => f.purchaseInvoiceReturnId = objList[i].id).toList();
            objList[i].invoiceReturnTaxList.map((f) async => await purchaseInvoiceReturnTaxInsert(f)).toList();
          }
          objList[i].invoiceReturnDetailList.map((invoiceDetailReturn) => invoiceDetailReturn.purchaseInvoiceReturnId = objList[i].id).toList();

          for (int j = 0; j < objList[i].invoiceReturnDetailList.length; j++) {
            if (objList[i].invoiceReturnDetailList[j].isSelect) {
              await purchaseInvoiceReturnDetailInsert(objList[i].invoiceReturnDetailList[j], isRefundTax);
            }
          }
        }
      }

      if (payment.paymentDetailList.length > 0) {
        payment.accountId = objList[0].accountId;
        payment.amount = payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount);
        payment.transactionDate = objList[0].invoiceDate;
        payment.paymentType = 'RECEIVED';
        payment = await paymentInsert(payment);

        payment.paymentPurchaseInvoiceReturn.paymentId = payment.id;
        payment.paymentPurchaseInvoiceReturn.transactionGroupId = objList[0].transactionGroupId;
        payment.paymentPurchaseInvoiceReturn.amount = payment.amount;
        payment.paymentPurchaseInvoiceReturn = await paymentPurchaseInvoiceReturnInsert(payment.paymentPurchaseInvoiceReturn);
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return objList;
    } catch (e) {
      print('Exception - purchaseInvoiceReturnInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceReturnTaxDelete(int purchaseInvoiceReturnId) async {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM PurchaseInvoiceReturnTaxes WHERE purchaseInvoiceReturnId = $purchaseInvoiceReturnId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - purchaseInvoiceReturnTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<PurchaseInvoiceReturnTax>> purchaseInvoiceReturnTaxGetList({int purchaseInvoiceReturnId}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.taxName FROM PurchaseInvoiceReturnTaxes t1 INNER JOIN TaxMasters t2 ON t1.taxId = t2.id WHERE t1.businessId=${_business.id} AND t1.purchaseInvoiceReturnId = $purchaseInvoiceReturnId';
      var result = await dbClient.rawQuery(query);
      return result.map((f) => PurchaseInvoiceReturnTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - purchaseInvoiceReturnTaxGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceReturnTaxInsert(PurchaseInvoiceReturnTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.insert('PurchaseInvoiceReturnTaxes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - purchaseInvoiceReturnTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future<List<PurchaseInvoiceReturn>> purchaseInvoiceReturnTransactionGroupGetList({
    int startIndex,
    int fetchRecords,
    String orderBy,
    int accountId,
    DateTime startDate,
    DateTime endDate,
  }) async {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,SUM(t1.netAmount) as totalSpent, t2.accountCode, t2.namePrefix, t2.firstName, t2.middleName, t2.lastName, t2.nameSuffix FROM PurchaseInvoiceReturns t1 INNER JOIN Accounts t2 ON t1.accountId = t2.id WHERE t1.businessId=${_business.id}';

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.accountId = $accountId ';
      }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate >= \'$startDate\' AND t1.invoiceDate <= \'$endDate\') ';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate >= \'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate <= \'$endDate\') ';
      }

      query += ' GROUP By t1.transactionGroupId';

      if (orderBy != null && orderBy.isNotEmpty) {
        query += ' ORDER BY t1.id $orderBy';
      }else
      { 
         query += ' ORDER BY t1.id desc';
      }

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => PurchaseInvoiceReturn.fromMap(f)).toList();
    } catch (e) {
      print('Exception - purchaseInvoiceReturnTransactionGroupGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<PurchaseInvoiceReturn>> purchaseInvoiceReturnUpdate({List<PurchaseInvoiceReturn> purchaseInvoiceReturnList, bool isRefundTax, int updateFrom, Payment payment}) async {
    try {
      var dbClient = await db;
      for (int i = 0; i < purchaseInvoiceReturnList.length; i++) {
        int count = 0;
        purchaseInvoiceReturnList[i].invoiceReturnDetailList.forEach((f) {
          if (f.isSelect) {
            count++;
          }
        });

        if (count > 0 || updateFrom == 0) {
          purchaseInvoiceReturnList[i].modifiedAt = DateTime.now();
          int _result = await dbClient.update('PurchaseInvoiceReturns', purchaseInvoiceReturnList[i].toMap(false), where: 'id=${purchaseInvoiceReturnList[i].id}');
          if (_result == 1 && updateFrom == 1) {
            if (isRefundTax) {
              await purchaseInvoiceReturnTaxDelete(purchaseInvoiceReturnList[i].id);
              for (int j = 0; j < purchaseInvoiceReturnList[i].invoiceReturnTaxList.length; j++) {
                purchaseInvoiceReturnList[i].invoiceReturnTaxList[j].id = null;
                purchaseInvoiceReturnList[i].invoiceReturnTaxList[j].purchaseInvoiceReturnId = purchaseInvoiceReturnList[i].id;
                await purchaseInvoiceReturnTaxInsert(purchaseInvoiceReturnList[i].invoiceReturnTaxList[j]);
              }
            }
            List<PurchaseInvoiceReturnDetail> _tempInvoiceReturnDetailList = await purchaseInvoiceReturnDetailGetList(purchaseInvoiceReturnId: purchaseInvoiceReturnList[i].id);
            await purchaseInvoiceReturnDetailTaxDelete(_tempInvoiceReturnDetailList.map((f) => f.id).toList());
            await purchaseInvoiceReturnDetailDelete(purchaseInvoiceReturnId: purchaseInvoiceReturnList[i].id);
            purchaseInvoiceReturnList[i].invoiceReturnDetailList.map((invoiceDetail) => invoiceDetail.purchaseInvoiceReturnId = purchaseInvoiceReturnList[i].id).toList();

            for (int j = 0; j < purchaseInvoiceReturnList[i].invoiceReturnDetailList.length; j++) {
              if (purchaseInvoiceReturnList[i].invoiceReturnDetailList[j].isSelect) {
                purchaseInvoiceReturnList[i].invoiceReturnDetailList[j].id = null;
                await purchaseInvoiceReturnDetailInsert(purchaseInvoiceReturnList[i].invoiceReturnDetailList[j], isRefundTax);
              }
            }
          }
        } else {
          List<PurchaseInvoiceReturnDetail> _tempInvoiceReturnDetailList = await purchaseInvoiceReturnDetailGetList(purchaseInvoiceReturnId: purchaseInvoiceReturnList[i].id);
          await purchaseInvoiceReturnDetailTaxDelete(_tempInvoiceReturnDetailList.map((f) => f.id).toList());
          await purchaseInvoiceReturnDetailDelete(purchaseInvoiceReturnId: purchaseInvoiceReturnList[i].id);
          await purchaseInvoiceReturnTaxDelete(purchaseInvoiceReturnList[i].id);
          await purchaseInvoiceReturnDelete(purchaseInvoiceReturnList[i].id);
        }
      }

      if (updateFrom == 1) {
        if (payment.paymentDetailList.length != 0) {
          List<PaymentDetail> _paymentDetailList = [];

          payment.paymentDetailList.forEach((item) {
            if (item.isRecentlyAdded == true) {
              _paymentDetailList.add(item);
            }
          });

          if (_paymentDetailList.length != 0) {
            payment.accountId = purchaseInvoiceReturnList[0].accountId;
            payment.amount = _paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount);
            payment.transactionDate = purchaseInvoiceReturnList[0].invoiceDate;
            payment.paymentType = 'RECEIVED';
            //   invoice.payment.remark = invoice.remark;
            payment.paymentDetailList = _paymentDetailList;
            payment = await paymentInsert(payment);

            payment.paymentPurchaseInvoiceReturn.paymentId = payment.id;
            payment.paymentPurchaseInvoiceReturn.transactionGroupId = purchaseInvoiceReturnList[0].transactionGroupId;
            payment.paymentPurchaseInvoiceReturn.amount = payment.amount;
            payment.paymentPurchaseInvoiceReturn = await paymentPurchaseInvoiceReturnInsert(payment.paymentPurchaseInvoiceReturn);
          }
        }
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return purchaseInvoiceReturnList;
    } catch (e) {
      print('Exception - purchaseInvoiceReturnUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceTaxDelete(int invoiceId) async {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM PurchaseInvoiceTaxes WHERE invoiceId = $invoiceId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - purchaseInvoiceTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<PurchaseInvoiceTax>> purchaseInvoiceTaxGetList({int invoiceId}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.taxName FROM PurchaseInvoiceTaxes t1 INNER JOIN TaxMasters t2 ON t1.taxId = t2.id WHERE t1.businessId=${_business.id} AND t1.invoiceId = $invoiceId';
      var result = await dbClient.rawQuery(query);
      return result.map((f) => PurchaseInvoiceTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - purchaseInvoiceTaxGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceTaxInsert(PurchaseInvoiceTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.insert('PurchaseInvoiceTaxes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - purchaseInvoiceTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future<PurchaseInvoice> purchaseInvoiceUpdate({PurchaseInvoice invoice, int updateFrom, bool isTaxApplied, bool isAccountChanged}) async {
    try {
      var dbClient = await db;
      invoice.modifiedAt = DateTime.now();
      int _result = await dbClient.update('PurchaseInvoices', invoice.toMap(false), where: 'id=${invoice.id}');
      if (_result == 1 && updateFrom == 1) {
        await purchaseInvoiceDetailDelete(invoiceId: invoice.id);
        invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.invoiceId = invoice.id).toList();

        for (int i = 0; i < invoice.invoiceDetailList.length; i++) {
          await purchaseInvoiceDetailInsert(invoice.invoiceDetailList[i]);
        }

        if (invoice.invoiceDetailTaxList.length != 0 && isTaxApplied) {
          int _counter = 0;
          //  obj.invoiceDetailList.forEach((invoiceDetail)
          for (int k = 0; k < invoice.invoiceDetailList.length; k++) {
            List<ProductTax> _productTaxList = await productTaxGetList(productIdList: [invoice.invoiceDetailList[k].productId]);
            if (_productTaxList.length > 0) {
              for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                invoice.invoiceDetailTaxList[_counter].invoiceDetailId = invoice.invoiceDetailList[k].id;
                _counter++;
              }
            }
          }
        }

        if (isTaxApplied) {
          invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.invoiceId = invoice.id).toList();
          invoice.invoiceTaxList.map((invoiceTax) async => invoiceTax.id = await purchaseInvoiceTaxInsert(invoiceTax)).toList();
          invoice.invoiceDetailTaxList.map((invoiceDetailTax) async => await purchaseInvoiceDetailTaxInsert(invoiceDetailTax)).toList();
        }

        if (invoice.payment.paymentDetailList.length != 0) {
          // if account was changed
          if (isAccountChanged) {
            List<int> paymentIdList = [];
            invoice.payment.paymentDetailList.forEach((element) {
              if (element.paymentId != null) {
                paymentIdList.add(element.paymentId);
              }
            });
            List<Payment> _paymentList = await paymentGetList(paymentIdList: paymentIdList.toSet().toList());
            if (_paymentList.length > 0) {
              for (int i = 0; i < _paymentList.length; i++) {
                _paymentList[i].accountId = invoice.accountId;
                await paymentUpdate(_paymentList[i]);
              }
            }
          }
          // if user delete payment
          for (int i = 0; i < invoice.payment.paymentDetailList.length; i++) {
            if (invoice.payment.paymentDetailList[i].deletedFromScreen && invoice.payment.paymentDetailList[i].id != null) {
              List<Payment> _paymentList = await paymentGetList(paymentIdList: [invoice.payment.paymentDetailList[i].paymentId]);
              if (_paymentList.length > 0) {
                List<PaymentPurchaseInvoice> _paymentPurchaseInvoiceList = await paymentPurchaseInvoiceGetList(paymentId: _paymentList[0].id);
                _paymentList[0].amount -= invoice.payment.paymentDetailList[i].amount;
                if (_paymentList[0].amount > 0) {
                  await paymentUpdate(_paymentList[0]);
                } else {
                  await paymentDelete(paymentIdList: [_paymentList[0].id]);
                }

                if (_paymentPurchaseInvoiceList.length > 0) {
                  _paymentPurchaseInvoiceList[0].amount = _paymentList[0].amount;
                  if (_paymentPurchaseInvoiceList[0].amount > 0) {
                    await paymentPurchaseInvoiceUpdate(_paymentPurchaseInvoiceList[0]);
                  } else {
                    await paymentPurchaseInvoiceDelete(paymentIdList: [_paymentList[0].id]);
                  }
                }
              }
              await paymentDetailDelete(paymentDetailId: invoice.payment.paymentDetailList[i].id);
              invoice.payment.paymentDetailList.removeAt(i);
            }
          }
          // if user edit payment
          for (int i = 0; i < invoice.payment.paymentDetailList.length; i++) {
            if (!invoice.payment.paymentDetailList[i].deletedFromScreen && invoice.payment.paymentDetailList[i].isEdited && invoice.payment.paymentDetailList[i].id != null) {
              await paymentDetailUpdate(invoice.payment.paymentDetailList[i]);
              List<PaymentDetail> _paymentDetailList = await paymentDetailGetList(paymentIdList: [invoice.payment.paymentDetailList[i].paymentId]);
              if (_paymentDetailList.length > 0) {
                double _amount = _paymentDetailList.map((e) => e.amount).reduce((value, element) => value + element);
                List<Payment> _paymentList = await paymentGetList(paymentIdList: [invoice.payment.paymentDetailList[i].paymentId]);
                if (_paymentList.length > 0) {
                  _paymentList[0].amount = _amount;
                  await paymentUpdate(_paymentList[0]);
                  List<PaymentPurchaseInvoice> _paymentPurchaseInvoiceList = await paymentPurchaseInvoiceGetList(paymentId: _paymentList[0].id);
                  if (_paymentPurchaseInvoiceList.length > 0) {
                    _paymentPurchaseInvoiceList[0].amount = _amount;
                    await paymentPurchaseInvoiceUpdate(_paymentPurchaseInvoiceList[0]);
                  }
                }
              }
            }
          }
          // if user add  payment
          List<PaymentDetail> _paymentDetailList = [];
          invoice.payment.paymentDetailList.forEach((item) {
            if (item.isRecentlyAdded && !item.deletedFromScreen) {
              _paymentDetailList.add(item);
            }
          });
          if (_paymentDetailList.length != 0) {
            invoice.payment.accountId = invoice.accountId;
            invoice.payment.amount = _paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount);
            invoice.payment.transactionDate = invoice.invoiceDate;
            invoice.payment.paymentType = 'GIVEN';
            invoice.payment.remark = invoice.remark;
            invoice.payment.paymentDetailList = _paymentDetailList;
            invoice.payment = await paymentInsert(invoice.payment);
            invoice.paymentInvoice.paymentId = invoice.payment.id;
            invoice.paymentInvoice.invoiceId = invoice.id;
            invoice.paymentInvoice.amount = invoice.payment.amount;
            invoice.paymentInvoice = await paymentPurchaseInvoiceInsert(invoice.paymentInvoice);
          }
        }
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return invoice;
    } catch (e) {
      print('Exception - purchaseInvoiceUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceDelete(int invoiceId) async //delete invoice from Invoices Table //invoiceDeleteInvoice
  {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM SaleInvoices WHERE id=$invoiceId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleInvoiceDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleOrderDelete(int orderId) async {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM SaleOrders WHERE id=$orderId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleOrderDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleQuoteDelete(int quoteId) async {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM SaleQuotes WHERE id=$quoteId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleQuoteDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceDetailDelete({int invoiceDetailId, int invoiceId}) async //delete invoice Details from SaleInvoiceDetail Table //invoiceDetailDeleteInvoiceDetail
  {
    try {
      var dbClient = await db;

      if (invoiceDetailId != null || invoiceId != null) {
        String query = 'DELETE FROM SaleInvoiceDetails ';

        if (invoiceDetailId != null) {
          query += ' WHERE id = $invoiceDetailId ';
        } else if (invoiceId != null) {
          query += ' WHERE invoiceId = $invoiceId ';
        }
        await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
        return await dbClient.rawDelete(query);
      }
    } catch (e) {
      print('Exception - saleInvoiceDetailDelete(): ' + e.toString());
    }
    return null;
  }

  Future<int> saleOrderInvoiceDelete(int invoiceId) async {
    try {
      var dbClient = await db;
      String query = 'DELETE FROM SaleOrdersInvoices WHERE saleInvoiceId = $invoiceId';
      int result = await dbClient.rawDelete(query);
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleOrderInvoiceDelete(): ' + e.toString());
    }
    return null;
  }

  Future<int> saleOrderDetailDelete({int saleOrderDetailId, int orderId}) async //delete invoice Details from SaleInvoiceDetail Table //invoiceDetailDeleteInvoiceDetail
  {
    try {
      var dbClient = await db;

      if (saleOrderDetailId != null || orderId != null) {
        String query = 'DELETE FROM SaleOrderDetails ';

        if (saleOrderDetailId != null) {
          query += ' WHERE id = $saleOrderDetailId ';
        } else if (orderId != null) {
          query += ' WHERE saleOrderId = $orderId ';
        }

        int result = await dbClient.rawDelete(query);
        await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
        return result;
      }
    } catch (e) {
      print('Exception - saleOrderDetailDelete(): ' + e.toString());
    }
    return null;
  }

  Future<int> saleQuoteDetailDelete({int saleQuoteDetailId, int quoteId}) async //delete invoice Details from SaleInvoiceDetail Table //invoiceDetailDeleteInvoiceDetail
  {
    try {
      var dbClient = await db;

      if (saleQuoteDetailId != null || quoteId != null) {
        String query = 'DELETE FROM SaleQuoteDetails ';

        if (saleQuoteDetailId != null) {
          query += ' WHERE id = $saleQuoteDetailId ';
        } else if (quoteId != null) {
          query += ' WHERE saleQuoteId = $quoteId ';
        }

        int result = await dbClient.rawDelete(query);
        await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
        return result;
      }
    } catch (e) {
      print('Exception - saleQuoteDetailDelete(): ' + e.toString());
    }
    return null;
  }

  Future saleInvoiceDetailGetCount(int invoiceId) async //get no.of active invoices from Invoices Table //invoiceGetCount
  {
    try {
      var dbClient = await db;
      var result = Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM SaleInvoiceDetails WHERE businessId=? AND invoiceId=?', [_business.id, invoiceId]));
      return result;
    } catch (e) {
      print('Exception - saleInvoiceDetailGetCount(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleInvoiceDetail>> saleInvoiceDetailGetList({int invoiceDettailId, List<int> invoiceIdList, int productId}) async //display list of invoice detail from SaleInvoiceDetail Table //invoiceDetailDisplayInvoiceDetail
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM SaleInvoiceDetails ';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (invoiceDettailId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' id = $invoiceDettailId ';
      }

      if (invoiceIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' invoiceId IN (${invoiceIdList.join(',')}) ';
      }

      if (productId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' productId = $productId ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleInvoiceDetail.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleInvoiceDetailGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleOrderDetail>> saleOrderDetailGetList({int orderDettailId, List<int> orderIdList, int productId}) async //display list of invoice detail from SaleInvoiceDetail Table //invoiceDetailDisplayInvoiceDetail
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM SaleOrderDetails ';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (orderDettailId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' id = $orderDettailId ';
      }

      if (orderIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' saleOrderId IN (${orderIdList.join(',')}) ';
      }

      if (productId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' productId = $productId ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleOrderDetail.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleOrderDetailGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleQuoteDetail>> saleQuoteDetailGetList({int orderDettailId, List<int> orderIdList, int productId}) async //display list of invoice detail from SaleInvoiceDetail Table //invoiceDetailDisplayInvoiceDetail
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM SaleQuoteDetails ';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (orderDettailId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' id = $orderDettailId ';
      }

      if (orderIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' saleQuoteId IN (${orderIdList.join(',')}) ';
      }

      if (productId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' productId = $productId ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleQuoteDetail.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleQuoteDetailGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleOrderInvoice>> saleOrderInvoiceGetList({List<int> saleOrderIdList, int saleInvoiceId}) async //display list of invoice detail from SaleInvoiceDetail Table //invoiceDetailDisplayInvoiceDetail
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM SaleOrdersInvoices ';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (saleOrderIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' saleOrderId IN (${saleOrderIdList.join(',')})';
      }

      if (saleInvoiceId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' saleInvoiceId = $saleInvoiceId ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleOrderInvoice.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleOrderInvoiceGetList(): ' + e.toString());
      return null;
    }
  }

  // Future<List<SaleQuoteInvoice>> saleQuoteInvoiceGetList({List<int> saleQuoteIdList, int saleInvoiceId}) async //display list of invoice detail from SaleInvoiceDetail Table //invoiceDetailDisplayInvoiceDetail
  // {
  //   try {
  //     var dbClient = await db;
  //     String query = 'SELECT * FROM SaleQuotesInvoices ';

  //     if (_business != null) {
  //       if (!query.contains('WHERE')) {
  //         query += ' WHERE';
  //       } else {
  //         query += ' AND';
  //       }
  //       query += ' businessId = ${_business.id}';
  //     }

  //     if (saleQuoteIdList != null) {
  //       if (!query.contains('WHERE')) {
  //         query += ' WHERE ';
  //       } else {
  //         query += ' AND ';
  //       }
  //       query += ' saleQuoteId IN (${saleQuoteIdList.join(',')})';
  //     }

  //     if (saleInvoiceId != null) {
  //       if (!query.contains('WHERE')) {
  //         query += ' WHERE ';
  //       } else {
  //         query += ' AND ';
  //       }
  //       query += ' saleInvoiceId = $saleInvoiceId ';
  //     }

  //     var result = await dbClient.rawQuery(query);
  //     return result.map((f) => SaleQuoteInvoice.fromMap(f)).toList();
  //   } catch (e) {
  //     print('Exception - saleQuoteInvoiceGetList(): ' + e.toString());
  //     return null;
  //   }
  // }

  Future<int> saleInvoiceDetailInsert(SaleInvoiceDetail obj) async //insertion in SaleInvoiceDetail Table //invoiceDetailCreateInvoiceDetail
  {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('SaleInvoiceDetails', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - saleInvoiceDetailInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleQuoteDetailInsert(SaleQuoteDetail obj) async //insertion in SaleInvoiceDetail Table //invoiceDetailCreateInvoiceDetail
  {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('SaleQuoteDetails', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - saleQuoteDetailInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleOrderDetailInsert(SaleOrderDetail obj) async //insertion in SaleInvoiceDetail Table //invoiceDetailCreateInvoiceDetail
  {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('SaleOrderDetails', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - saleOrderDetailInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceDetailTaxDelete({List<int> invoiceDetailIdList, List<int> invoiceDetailTaxIdList}) async {
    try {
      var dbClient = await db;
      String query;
      if (invoiceDetailIdList != null) {
        query = "DELETE FROM SaleInvoiceDetailTaxes WHERE invoiceDetailId IN (${invoiceDetailIdList.join(',')})";
      } else if (invoiceDetailTaxIdList != null) {
        query = "DELETE FROM SaleInvoiceDetailTaxes WHERE id IN (${invoiceDetailTaxIdList.join(',')})";
      }
      int result = await dbClient.rawDelete(query);
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleInvoiceDetailTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleOrderDetailTaxDelete({List<int> orderDetailIdList, List<int> orderDetailTaxIdList}) async {
    try {
      var dbClient = await db;
      String query;
      if (orderDetailIdList != null) {
        query = "DELETE FROM SaleOrderDetailTaxes WHERE saleOrderDetailId IN (${orderDetailIdList.join(',')})";
      } else if (orderDetailTaxIdList != null) {
        query = "DELETE FROM SaleOrderDetailTaxes WHERE id IN (${orderDetailTaxIdList.join(',')})";
      }
      int result = await dbClient.rawDelete(query);
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleOrderDetailTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleQuoteDetailTaxDelete({List<int> quoteDetailIdList, List<int> quoteDetailTaxIdList}) async {
    try {
      var dbClient = await db;
      String query;
      if (quoteDetailIdList != null) {
        query = "DELETE FROM SaleQuoteDetailTaxes WHERE saleQuoteDetailId IN (${quoteDetailIdList.join(',')})";
      } else if (quoteDetailTaxIdList != null) {
        query = "DELETE FROM SaleQuoteDetailTaxes WHERE id IN (${quoteDetailTaxIdList.join(',')})";
      }
      int result = await dbClient.rawDelete(query);
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleQuoteDetailTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleInvoiceDetailTax>> saleInvoiceDetailTaxGetList({List<int> invoiceDetailIdList}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM SaleInvoiceDetailTaxes WHERE businessId=${_business.id} AND invoiceDetailId IN (${invoiceDetailIdList.toString().substring(1, (invoiceDetailIdList.toString().length - 1))})';
      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleInvoiceDetailTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleInvoiceDetailTaxGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleOrderDetailTax>> saleOrderDetailTaxGetList({List<int> orderDetailIdList}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM SaleOrderDetailTaxes WHERE businessId=${_business.id} AND saleOrderDetailId IN (${orderDetailIdList.join(',')})';
      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleOrderDetailTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleOrderDetailTaxGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleQuoteDetailTax>> saleQuoteDetailTaxGetList({List<int> quoteDetailIdList}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM SaleQuoteDetailTaxes WHERE businessId=${_business.id} AND saleQuoteDetailId IN (${quoteDetailIdList.join(',')})';
      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleQuoteDetailTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleQuoteDetailTaxGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceDetailTaxInsert(SaleInvoiceDetailTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('SaleInvoiceDetailTaxes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - saleInvoiceDetailTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleOrderDetailTaxInsert(SaleOrderDetailTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('SaleOrderDetailTaxes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - saleOrderDetailTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleQuoteDetailTaxInsert(SaleQuoteDetailTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('SaleQuoteDetailTaxes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - saleQuoteDetailTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future saleInvoiceGetCount() async //get no.of active invoices from SaleInvoices Table //invoiceGetCount
  {
    try {
      var dbClient = await db;
      var result = Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM SaleInvoices WHERE businessId=? AND status!=?', [_business.id, 'CANCELLED']));
      return result;
    } catch (e) {
      print('Exception - saleInvoiceGetCount(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleInvoice>> saleInvoiceGetList({int startIndex, int fetchRecords, List<int> invoiceIdList, int invoiceNumber, int accountId, DateTime startDate, bool fetchTaxInvoices, DateTime endDate, String status, bool isComplete, bool isDelete, bool isCancelled, double amountFrom, double amountTo, int lastDays, String orderBy, String orderByInvoiceDate}) async //display list of invoices from SaleInvoices Table //invoiceDisplayInvoice
  {
    try {
      //  SaleInvoice();
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.accountCode, t2.namePrefix, t2.firstName, t2.middleName, t2.lastName, t2.nameSuffix, t3.saleQuoteNumber as salesQuoteNumber, t3.versionNumber as salesQuoteVersion, t4.id as salesOrderId, t4.saleOrderNumber as salesOrderNumber FROM SaleInvoices t1 INNER JOIN Accounts t2 ON t1.accountId = t2.id LEFT JOIN SaleQuotes t3 on t3.id = t1.salesQuoteId LEFT JOIN SaleOrders t4 on t4.id = t1.salesOrderId';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (invoiceIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.id IN (${invoiceIdList.toString().substring(1, (invoiceIdList.toString().length - 1))}) ';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.accountId = $accountId ';
      }

      if (invoiceNumber != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.invoiceNumber = $invoiceNumber ';
      }

      if (fetchTaxInvoices != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += (fetchTaxInvoices) ? ' t1.finalTax > 0 ' : ' t1.finalTax = 0 ';
      }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate >= \'$startDate\' AND t1.invoiceDate <= \'$endDate\') ';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate >= \'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate <= \'$endDate\') ';
      }

      if (lastDays != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.invoiceDate > (SELECT DATETIME (\'now\', \'-$lastDays day\')) ';
      }

      //
      if (amountFrom != null && amountTo != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.netAmount >= $amountFrom AND t1.netAmount <= $amountTo) ';
      }

      if (amountFrom != null && amountTo == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.netAmount >= $amountFrom) ';
      }

      if (amountFrom == null && amountTo != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.netAmount <= $amountTo) ';
      }

      if (isComplete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isComplete = \'$isComplete\' ';
      }

      if (status != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.status = \'$status\' ';
      } else if (isCancelled != null && !isCancelled) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.status != \'CANCELLED\' ';
      }

      if (isDelete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isDelete = \'$isDelete\' ';
      } else {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isDelete = \'false\' ';
      }

      if (orderBy != null && orderBy.isNotEmpty) {
        query += ' ORDER BY t1.id $orderBy';
      } else if (orderByInvoiceDate != null && orderByInvoiceDate.isNotEmpty) {
        query += ' ORDER BY t1.invoiceDate $orderByInvoiceDate';
      }

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleInvoice.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleInvoiceGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<SalesGeneralReportModel>> getSalesGeneralReportData(SalesGeneralReportFilterModel _obj) async {
    try {
      var dbClient = await db;

      String paymentDeleted = (_obj.invoiceStatus != null && _obj.invoiceStatus.isNotEmpty && _obj.invoiceStatus == 'CANCELLED') ? 'true' : 'false';

      String query = """ 
      select sv.invoiceNumber, sv.grossAmount, sv.finalTax, sv.discount, sv.netAmount, sv.invoiceDate, sv.deliveryDate, sv.status,
      sq.saleQuoteNumber as saleQuoteNumber, sq.versionNumber as saleQuoteVersion, ac.namePrefix as accountNamePrefix, ac.firstName as accountFirstName ,
      ac.middleName as accountMiddleName, ac.lastName as accountLastName, ac.nameSuffix as accountNameSuffix, ifnull(ac.mobileCountryCode, '') as accountMobileCountryCode, ifnull(ac.mobile, '') as accountMobile, ifnull(ac.email, '') as accountEmail,
      ifnull((select sum(psi.amount) from PaymentSaleInvoices psi
      inner join Payments p on p.id = psi.paymentId
       where psi.invoiceId = sv.id and p.isCancel = \'$paymentDeleted\' and p.isDelete = \'$paymentDeleted\' and p.paymentType= 'RECEIVED'),0) as paymentDone
      from SaleInvoices sv
      Left join SaleQuotes sq on sq.id = sv.salesQuoteId
      Left join Accounts ac on ac.id = sv.accountId
      """;

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' sv.businessId = ${_business.id}';
      }

      if (_obj.account != null && _obj.account.id != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' sv.accountId =  ${_obj.account.id}';
      }

      if (_obj.invoiceDateFrom != null || _obj.invoiceDateTo != null) {
        if (_obj.invoiceDateFrom == null) {
          _obj.invoiceDateFrom = DateTime(2000);
        }

        if (_obj.invoiceDateTo == null) {
          _obj.invoiceDateTo = DateTime.now();
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(sv.invoiceDate) >=  \'${_dateInString(_obj.invoiceDateFrom)}\' AND date(sv.invoiceDate) <=  \'${_dateInString(_obj.invoiceDateTo)}\'';
      }

      if (_obj.deliveryDateFrom != null || _obj.deliveryDateTo != null) {
        if (_obj.deliveryDateFrom == null) {
          _obj.deliveryDateFrom = DateTime(2000);
        }

        if (_obj.deliveryDateTo == null) {
          _obj.deliveryDateTo = DateTime.now();
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(sv.deliveryDate) >=  \'${_dateInString(_obj.deliveryDateFrom)}\' AND date(sv.deliveryDate) <=  \'${_dateInString(_obj.deliveryDateTo)}\'';
      }

      if (_obj.netAmountFrom != null || _obj.netAmountTo != null) {
        if (_obj.netAmountFrom == null) {
          _obj.netAmountFrom = 0;
        }

        if (_obj.netAmountTo == null) {
          _obj.netAmountTo = 999999;
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' sv.netAmount >=  ${_obj.netAmountFrom} AND sv.netAmount <=  ${_obj.netAmountTo}';
      }

      if (_obj.invoiceStatus != null && _obj.invoiceStatus.isNotEmpty) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' sv.status = \'${_obj.invoiceStatus}\'';
      } else {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' sv.status != \'CANCELLED\'';
      }

      if (_obj.taxAmountFrom != null || _obj.taxAmountTo != null) {
        if (_obj.taxAmountFrom == null) {
          _obj.taxAmountFrom = 0;
        }

        if (_obj.taxAmountTo == null) {
          _obj.taxAmountTo = 999999;
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' sv.finalTax >=  ${_obj.taxAmountFrom} AND sv.finalTax <=  ${_obj.taxAmountTo}';
      }

      if (_obj.discountAmountFrom != null || _obj.discountAmountTo != null) {
        if (_obj.discountAmountFrom == null) {
          _obj.discountAmountFrom = 0;
        }

        if (_obj.discountAmountTo == null) {
          _obj.discountAmountTo = 999999;
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' sv.discount >=  ${_obj.discountAmountFrom} AND sv.discount <=  ${_obj.discountAmountTo}';
      }

      if (_obj.paymentDoneAmountFrom != null || _obj.paymentDoneAmountTo != null) {
        if (_obj.paymentDoneAmountFrom == null) {
          _obj.paymentDoneAmountFrom = 0;
        }

        if (_obj.paymentDoneAmountTo == null) {
          _obj.paymentDoneAmountTo = 999999;
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' paymentDone >=  ${_obj.paymentDoneAmountFrom} AND paymentDone <=  ${_obj.paymentDoneAmountTo}';
      }

      if (_obj.paymentPendingAmountFrom != null || _obj.paymentPendingAmountTo != null) {
        if (_obj.paymentPendingAmountFrom == null) {
          _obj.paymentPendingAmountFrom = 0;
        }

        if (_obj.paymentPendingAmountTo == null) {
          _obj.paymentPendingAmountTo = 999999;
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' sv.netAmount - paymentDone >=  ${_obj.paymentPendingAmountFrom} AND sv.netAmount - paymentDone <=  ${_obj.paymentPendingAmountTo}';
      }
      query += ' order by sv.invoiceDate desc';

      var result = await dbClient.rawQuery(query);
      return result.map((f) => SalesGeneralReportModel.fromMap(f)).toList();
    } catch (e) {
      print('Exception - getSalesGeneralReportData(): ' + e.toString());
      return null;
    }
  }

  Future<List<QuotesGeneralReportModel>> getQuotesGeneralReportData(QuotesGeneralReportFilterModel _obj) async {
    try {
      var dbClient = await db;
      String query = """ 
      select sq.saleQuoteNumber as saleQuoteNumber, sq.versionNumber as saleQuoteVersion, sq.grossAmount, sq.finalTax, sq.discount, sq.netAmount, sq.orderDate as quoteDate, sq.status,
      sv.invoiceNumber, ac.namePrefix as accountNamePrefix, ac.firstName as accountFirstName ,
      ac.middleName as accountMiddleName, ac.lastName as accountLastName, ac.nameSuffix as accountNameSuffix, ifnull(ac.mobileCountryCode, '')
      as accountMobileCountryCode, ifnull(ac.mobile, '') as accountMobile, ifnull(ac.email, '') as accountEmail
      from SaleQuotes sq
      Left join SaleInvoices sv on sq.id = sv.salesQuoteId
      Left join Accounts ac on ac.id = sq.accountId
      """;

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' sq.businessId = ${_business.id}';
      }

      if (_obj.account != null && _obj.account.id != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' sq.accountId =  ${_obj.account.id}';
      }

      if (_obj.quoteDateFrom != null || _obj.quoteDateTo != null) {
        if (_obj.quoteDateFrom == null) {
          _obj.quoteDateFrom = DateTime(2000);
        }

        if (_obj.quoteDateTo == null) {
          _obj.quoteDateTo = DateTime.now();
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(sq.orderDate) >=  \'${_dateInString(_obj.quoteDateFrom)}\' AND date(sq.orderDate) <=  \'${_dateInString(_obj.quoteDateTo)}\'';
      }

      if (_obj.netAmountFrom != null || _obj.netAmountTo != null) {
        if (_obj.netAmountFrom == null) {
          _obj.netAmountFrom = 0;
        }

        if (_obj.netAmountTo == null) {
          _obj.netAmountTo = 999999;
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' sq.netAmount >=  ${_obj.netAmountFrom} AND sq.netAmount <=  ${_obj.netAmountTo}';
      }

      if (_obj.quoteStatus != null && _obj.quoteStatus.isNotEmpty) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' sq.status = \'${_obj.quoteStatus}\'';
      } else {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' sq.status != \'CANCELLED\'';
      }

      if (_obj.taxAmountFrom != null || _obj.taxAmountTo != null) {
        if (_obj.taxAmountFrom == null) {
          _obj.taxAmountFrom = 0;
        }

        if (_obj.taxAmountTo == null) {
          _obj.taxAmountTo = 999999;
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' sq.finalTax >=  ${_obj.taxAmountFrom} AND sq.finalTax <=  ${_obj.taxAmountTo}';
      }

      if (_obj.discountAmountFrom != null || _obj.discountAmountTo != null) {
        if (_obj.discountAmountFrom == null) {
          _obj.discountAmountFrom = 0;
        }

        if (_obj.discountAmountTo == null) {
          _obj.discountAmountTo = 999999;
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' sq.discount >=  ${_obj.discountAmountFrom} AND sq.discount <=  ${_obj.discountAmountTo}';
      }
      query += ' order by sq.orderDate desc';

      var result = await dbClient.rawQuery(query);
      return result.map((f) => QuotesGeneralReportModel.fromMap(f)).toList();
    } catch (e) {
      print('Exception - getQuotesGeneralReportData(): ' + e.toString());
      return null;
    }
  }

  Future<List<Account>> getExportAccountReportData(ExportAccountFilterModel _obj) async {
    try {
      var dbClient = await db;
      String query = """ 
     select * from Accounts WHERE accountType like "%Customer%"  AND isActive = 'true' AND isDelete = 'false'
      """;

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (_obj.pincode != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' pincode like \'%${_obj.pincode}%\'';
      }

      if (_obj.registrationDateFrom != null || _obj.registrationDateTo != null) {
        if (_obj.registrationDateFrom == null) {
          _obj.registrationDateFrom = DateTime(2000);
        }

        if (_obj.registrationDateTo == null) {
          _obj.registrationDateTo = DateTime.now();
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(createdAt) >=  \'${_dateInString(_obj.registrationDateFrom)}\' AND date(createdAt) <=  \'${_dateInString(_obj.registrationDateFrom)}\'';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => Account.fromMap(f)).toList();
    } catch (e) {
      print('Exception - getExportAccountReportData(): ' + e.toString());
      return null;
    }
  }

  Future<List<PaymentGeneralReportModel>> getPaymentGeneralReportData(PaymentGeneralReportFilterModel _obj) async {
    try {
      var dbClient = await db;
      String query = """ 
    select p.id, ifnull(p.amount,0) as paymentAmount, p.transactionDate, p.paymentType,ac.namePrefix as accountNamePrefix, ac.firstName as accountFirstName ,ac.middleName as accountMiddleName, 
    ac.lastName as accountLastName, ac.nameSuffix as accountNameSuffix, ifnull(ac.mobileCountryCode, '') as accountMobileCountryCode, ifnull(ac.mobile, '') as accountMobile, 
    ifnull(ac.email, '') as accountEmail, si.invoiceNumber, e.expenseName from Payments p 
    left join Accounts ac on ac.id = p.accountId
    left join PaymentSaleInvoices psi on psi.paymentId = p.id
    left join SaleInvoices si on si.id = psi.invoiceId 
    left join ExpensePayments ep on ep.paymentId = p.id
    left join Expenses e on e.id = ep.expenseId
      """;

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' p.businessId = ${_business.id}';
      }

      if (_obj.paymentType != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' p.paymentType = \'${_obj.paymentType}\'';
      }

      if (_obj.account != null && _obj.account.id != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' p.accountId = ${_obj.account.id}';
      }

      // if (_obj.invoice != null && _obj.invoice.id != null) {
      //   if (!query.contains('WHERE')) {
      //     query += ' WHERE';
      //   } else {
      //     query += ' AND';
      //   }
      //   query += ' si.id = ${_obj.invoice.id}';
      // }

      // if (_obj.expense != null && _obj.expense.id != null) {
      //   if (!query.contains('WHERE')) {
      //     query += ' WHERE';
      //   } else {
      //     query += ' AND';
      //   }
      //   query += ' e.id = ${_obj.expense.id}';
      // }

      if (_obj.dateFrom != null || _obj.dateTo != null) {
        if (_obj.dateFrom == null) {
          _obj.dateFrom = DateTime(2000);
        }

        if (_obj.dateTo == null) {
          _obj.dateTo = DateTime.now();
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(p.transactionDate) >=  \'${_dateInString(_obj.dateFrom)}\' AND date(p.transactionDate) <=  \'${_dateInString(_obj.dateTo)}\'';
      }

      if (_obj.amountFrom != null || _obj.amountTo != null) {
        if (_obj.amountFrom == null) {
          _obj.amountFrom = 0;
        }

        if (_obj.amountTo == null) {
          _obj.amountTo = 999999;
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' p.amount >=  ${_obj.amountFrom} AND p.amount <=  ${_obj.amountTo}';
      }

      if (_obj.isCancel != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' p.isCancel = \'${_obj.isCancel}\'';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => PaymentGeneralReportModel.fromMap(f)).toList();
    } catch (e) {
      print('Exception - getPaymentGeneralReportData(): ' + e.toString());
      return null;
    }
  }

  Future<List<ProductGeneralReportModel>> getProductGeneralReportData(ProductGeneralReportFilterModel _obj) async {
    try {
      var dbClient = await db;
      String query = """ 
     select p.*,pt.typeName, pp.price from Products p 
     left join ProductTypes pt on pt.id = p.productTypeId
     left join ProductPrices pp on pp.productId = p.id
      """;

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' p.businessId = ${_business.id}';
      }

      if (_obj.isActive != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' p.isActive = \'${_obj.isActive}\'';
      }

      if (_obj.productType != null && _obj.productType.id != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' p.productTypeId = ${_obj.productType.id}';
      }

      if (_obj.priceFrom != null || _obj.priceTo != null) {
        if (_obj.priceFrom == null) {
          _obj.priceFrom = 0;
        }

        if (_obj.priceTo == null) {
          _obj.priceTo = 999999;
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' pp.price >=  ${_obj.priceFrom} AND pp.price <=  ${_obj.priceTo}';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => ProductGeneralReportModel.fromMap(f)).toList();
    } catch (e) {
      print('Exception - getProductGeneralReportData(): ' + e.toString());
      return null;
    }
  }

  Future<List<ExpenseGeneralReportModel>> getExpenseGeneralReportData(ExpenseGeneralReportFilterModel _obj) async {
    try {
      var dbClient = await db;
      String query = """ 
    select e.expenseName, ifnull(e.amount, 0) as expenseAmount, e.transactionDate, e.isSplitPayment, e.billNumber, e.billerName, ec.name as categoryName, 
    ifnull((select sum(p.amount) from payments p inner join ExpensePayments ep on ep.paymentId = p.id where p.isCancel = 'false' and ep.expenseId = e.id),0) as paidAmount from Expenses e
    left join ExpenseCategories ec on ec.id = e.expenseCategoryId
      """;

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' e.businessId = ${_business.id}';
      }

      if (_obj.category != null && _obj.category.id != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' e.expenseCategoryId = ${_obj.category.id}';
      }

      if (_obj.amountFrom != null || _obj.amountTo != null) {
        if (_obj.amountFrom == null) {
          _obj.amountFrom = 0;
        }

        if (_obj.amountTo == null) {
          _obj.amountTo = 999999;
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' e.amount >=  ${_obj.amountFrom} AND e.amount <=  ${_obj.amountTo}';
      }

      if (_obj.paidAmountFrom != null || _obj.paidAmountTo != null) {
        if (_obj.paidAmountFrom == null) {
          _obj.paidAmountFrom = 0;
        }

        if (_obj.paidAmountTo == null) {
          _obj.paidAmountTo = 999999;
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' paidAmount >=  ${_obj.paidAmountFrom} AND paidAmount <=  ${_obj.paidAmountTo}';
      }

      if (_obj.pendingAmountFrom != null || _obj.pendingAmountTo != null) {
        if (_obj.pendingAmountFrom == null) {
          _obj.pendingAmountFrom = 0;
        }

        if (_obj.pendingAmountTo == null) {
          _obj.pendingAmountTo = 999999;
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' e.amount - paidAmount >=  ${_obj.pendingAmountFrom} AND e.amount - paidAmount <=  ${_obj.pendingAmountTo}';
      }

      if (_obj.transactionDateFrom != null || _obj.transactionDateTo != null) {
        if (_obj.transactionDateFrom == null) {
          _obj.transactionDateFrom = DateTime(2000);
        }

        if (_obj.transactionDateTo == null) {
          _obj.transactionDateTo = DateTime.now();
        }

        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(e.transactionDate) >=  \'${_dateInString(_obj.transactionDateFrom)}\' AND date(e.transactionDate) <=  \'${_dateInString(_obj.transactionDateTo)}\'';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => ExpenseGeneralReportModel.fromMap(f)).toList();
    } catch (e) {
      print('Exception - getExpenseGeneralReportData(): ' + e.toString());
      return null;
    }
  }

  Future<List<TopSellingProductReportModel>> getTopSellingProductReportData(TopSellingProductReportFilterModel _obj) async {
    try {
      List<ProductGeneralReportModel> _productData = [];
      List<TopSellingProductReportModel> _topSellingProductReportList = [];
      var dbClient = await db;

      String getProductSql = """ 
     select p.*,pt.typeName, pp.price from Products p 
     left join ProductTypes pt on pt.id = p.productTypeId
     left join ProductPrices pp on pp.productId = p.id
      """;

      if (_business != null) {
        if (!getProductSql.contains('WHERE')) {
          getProductSql += ' WHERE';
        } else {
          getProductSql += ' AND';
        }
        getProductSql += ' p.businessId = ${_business.id}';
      }

      if (_obj.isActive != null) {
        if (!getProductSql.contains('WHERE')) {
          getProductSql += ' WHERE';
        } else {
          getProductSql += ' AND';
        }
        getProductSql += ' p.isActive = \'${_obj.isActive}\'';
      }

      if (_obj.productType != null && _obj.productType.id != null) {
        if (!getProductSql.contains('WHERE')) {
          getProductSql += ' WHERE';
        } else {
          getProductSql += ' AND';
        }
        getProductSql += ' p.productTypeId = ${_obj.productType.id}';
      }

      if (_obj.productPriceFrom != null || _obj.productPriceTo != null) {
        if (_obj.productPriceFrom == null) {
          _obj.productPriceFrom = 0;
        }

        if (_obj.productPriceTo == null) {
          _obj.productPriceTo = 999999;
        }

        if (!getProductSql.contains('WHERE')) {
          getProductSql += ' WHERE ';
        } else {
          getProductSql += ' AND ';
        }
        getProductSql += ' pp.price >=  ${_obj.productPriceFrom} AND pp.price <=  ${_obj.productPriceTo}';
      }

      var result = await dbClient.rawQuery(getProductSql);
      _productData = result.map((f) => ProductGeneralReportModel.fromMap(f)).toList();

      if (_productData != null && _productData.length > 0) {
        for (int i = 0; i < _productData.length; i++) {
          String query = """
          select (select sum(sid.quantity) from SaleInvoiceDetails sid inner join SaleInvoices si on si.id = sid.invoiceId where 
          sid.productId = ${_productData[i].productId} and si.status != 'CANCELLED'
           """;

          if (_obj.dateFrom != null || _obj.dateTo != null) {
            if (_obj.dateFrom == null) {
              _obj.dateFrom = DateTime(2000);
            }

            if (_obj.dateTo == null) {
              _obj.dateTo = DateTime.now();
            }
            query += ' and date(si.invoiceDate) >= \'${_dateInString(_obj.dateFrom)}\' and date(si.invoiceDate) <=  \'${_dateInString(_obj.dateTo)}\'';
          }

          query += """ ) as totalSoldQty, 
          (select sum(sid.amount) from SaleInvoiceDetails sid inner join SaleInvoices si on si.id = sid.invoiceId where sid.productId = ${_productData[i].productId}
          and si.status != 'CANCELLED'
          """;

          if (_obj.dateFrom != null || _obj.dateTo != null) {
            if (_obj.dateFrom == null) {
              _obj.dateFrom = DateTime(2000);
            }

            if (_obj.dateTo == null) {
              _obj.dateTo = DateTime.now();
            }
            query += ' and date(si.invoiceDate) >= \'${_dateInString(_obj.dateFrom)}\' and date(si.invoiceDate) <=  \'${_dateInString(_obj.dateTo)}\'';
          }

          query += """ ) as totalSoldAmount
           """;

          if (_obj.totalSoldQtyFrom != null || _obj.totalSoldQtyTo != null) {
            if (_obj.totalSoldQtyFrom == null) {
              _obj.totalSoldQtyFrom = 0;
            }

            if (_obj.totalSoldQtyTo == null) {
              _obj.totalSoldQtyTo = 999999;
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += ' totalSoldQty >=  ${_obj.totalSoldQtyFrom} AND totalSoldQty <=  ${_obj.totalSoldQtyTo}';
          }

          if (_obj.totalSoldAmountFrom != null || _obj.totalSoldAmountTo != null) {
            if (_obj.totalSoldAmountFrom == null) {
              _obj.totalSoldAmountFrom = 0;
            }

            if (_obj.totalSoldAmountTo == null) {
              _obj.totalSoldAmountTo = 999999;
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += ' totalSoldAmount >=  ${_obj.totalSoldAmountFrom} AND totalSoldAmount <=  ${_obj.totalSoldAmountTo}';
          }

          var result = await dbClient.rawQuery(query);
          List<TopSellingProductReportModel> _temp = result.map((f) => TopSellingProductReportModel.fromMap(f)).toList();
          if (_temp != null && _temp.length > 0) {
            _temp.map((e) => e.productName = _productData[i].productName).toList();
            _temp.map((e) => e.productCode = _productData[i].productCode.toString()).toList();
            _temp.map((e) => e.productHsnCode = _productData[i].productHsnCode).toList();
            _temp.map((e) => e.productTypeName = _productData[i].productTypeName).toList();
            _topSellingProductReportList.addAll(_temp);
          }
        }
      }
      return _topSellingProductReportList;
    } catch (e) {
      print('Exception - getTopSellingProductReportData(): ' + e.toString());
      return null;
    }
  }

  Future<List<AccountSellerReportModel>> getAccountSellerReportData(AccountSellerReportFilterModel _obj) async {
    try {
      List<Account> _accountData = [];
      List<AccountSellerReportModel> _accountSellerReportList = [];
      var dbClient = await db;
      String getAccountSql = 'select * from accounts WHERE accountType like "%Customer%" AND isActive = \'true\' AND isDelete = \'false\'';

      if (_obj.accountRegistrationFrom != null || _obj.accountRegistrationTo != null) {
        if (_obj.accountRegistrationFrom == null) {
          _obj.accountRegistrationFrom = DateTime(2000);
        }

        if (_obj.accountRegistrationTo == null) {
          _obj.accountRegistrationTo = DateTime.now();
        }

        if (!getAccountSql.contains('WHERE')) {
          getAccountSql += ' WHERE ';
        } else {
          getAccountSql += ' AND ';
        }
        getAccountSql += ' date(createdAt) >=  \'${_dateInString(_obj.accountRegistrationFrom)}\' AND date(createdAt) <=  \'${_dateInString(_obj.accountRegistrationTo)}\'';
      }

      if (_obj.pincode != null && _obj.pincode.isNotEmpty) {
        if (!getAccountSql.contains('WHERE')) {
          getAccountSql += ' WHERE ';
        } else {
          getAccountSql += ' AND ';
        }
        getAccountSql += ' pincode like \'%${_obj.pincode}%\'';
      }
      var accountData = await dbClient.rawQuery(getAccountSql);
      _accountData = accountData.map((f) => Account.fromMap(f)).toList();

      if (_accountData != null && _accountData.length > 0) {
        for (int i = 0; i < _accountData.length; i++) {
          String query = """ select (select min(invoiceDate) from SaleInvoices where accountId = ${_accountData[i].id} and status != 'CANCELLED' and businessId = 1)as
           firstOrderDate, 
          (select max(invoiceDate) from SaleInvoices where accountId = ${_accountData[i].id} and status != 'CANCELLED' and businessId = 1)as lastOrderDate,
          (select min(netAmount) from SaleInvoices where accountId = ${_accountData[i].id} and status != 'CANCELLED' and businessId = 1 order by invoiceDate asc 
          limit 1)as firstOrderAmount,
          (select max(netAmount) from SaleInvoices where accountId = ${_accountData[i].id} and status != 'CANCELLED' and businessId = 1 order by invoiceDate 
          desc limit 1)as lastOrderAmount,
          (select min(netAmount) from SaleInvoices where accountId = ${_accountData[i].id} and status != 'CANCELLED' and businessId = 1)as minOrderAmount,
          (select max(netAmount) from SaleInvoices where accountId = ${_accountData[i].id} and status != 'CANCELLED' and businessId = 1)as maxOrderAmount,
          (select avg(netAmount) from SaleInvoices where accountId = ${_accountData[i].id} and status != 'CANCELLED' and businessId = 1)as avgOrderAmount,
          (select count(netAmount) from SaleInvoices where accountId = ${_accountData[i].id} and status != 'CANCELLED' and businessId = 1)as totalOrders,
          (select sum(netAmount) from SaleInvoices where accountId = ${_accountData[i].id} and status != 'CANCELLED' and businessId = 1)as totalSpend,
          (select sum(psi.amount) from PaymentSaleInvoices psi inner join Payments p on p.id = psi.id where psi.invoiceId in (select id from SaleInvoices 
           where  accountId = ${_accountData[i].id}) and p.isCancel = 'false' and p.isDelete = 'false' and p.paymentType= 'RECEIVED') as totalPaid
          """;

          if (_obj.firstOrderDateFrom != null || _obj.firstOrderDateTo != null) {
            if (_obj.firstOrderDateFrom == null) {
              _obj.firstOrderDateFrom = DateTime(2000);
            }

            if (_obj.firstOrderDateTo == null) {
              _obj.firstOrderDateTo = DateTime.now();
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += ' date(firstOrderDate) >=  \'${_dateInString(_obj.firstOrderDateFrom)}\' AND date(firstOrderDate) <=  \'${_dateInString(_obj.firstOrderDateTo)}\'';
          }

          if (_obj.lastOrderDateFrom != null || _obj.lastOrderDateTo != null) {
            if (_obj.lastOrderDateFrom == null) {
              _obj.lastOrderDateFrom = DateTime(2000);
            }

            if (_obj.lastOrderDateTo == null) {
              _obj.lastOrderDateTo = DateTime.now();
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += ' date(lastOrderDate) >=  \'${_dateInString(_obj.lastOrderDateFrom)}\' AND date(lastOrderDate) <=  \'${_dateInString(_obj.lastOrderDateTo)}\'';
          }

          if (_obj.firstOrderAmountFrom != null || _obj.firstOrderAmountTo != null) {
            if (_obj.firstOrderAmountFrom == null) {
              _obj.firstOrderAmountFrom = 0;
            }

            if (_obj.firstOrderAmountTo == null) {
              _obj.firstOrderAmountTo = 999999;
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += ' firstOrderAmount >=  ${_obj.firstOrderAmountFrom} AND firstOrderAmount <=  ${_obj.firstOrderAmountTo}';
          }

          if (_obj.lastOrderAmountFrom != null || _obj.lastOrderAmountTo != null) {
            if (_obj.lastOrderAmountFrom == null) {
              _obj.lastOrderAmountFrom = 0;
            }

            if (_obj.lastOrderAmountTo == null) {
              _obj.lastOrderAmountTo = 999999;
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += ' lastOrderAmount >=  ${_obj.lastOrderAmountFrom} AND lastOrderAmount <=  ${_obj.lastOrderAmountTo}';
          }

          if (_obj.minOrderAmountFrom != null || _obj.minOrderAmountTo != null) {
            if (_obj.minOrderAmountFrom == null) {
              _obj.minOrderAmountFrom = 0;
            }

            if (_obj.minOrderAmountTo == null) {
              _obj.minOrderAmountTo = 999999;
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += ' minOrderAmount >=  ${_obj.minOrderAmountFrom} AND minOrderAmount <=  ${_obj.minOrderAmountTo}';
          }

          if (_obj.maxOrderAmountFrom != null || _obj.maxOrderAmountTo != null) {
            if (_obj.maxOrderAmountFrom == null) {
              _obj.maxOrderAmountFrom = 0;
            }

            if (_obj.maxOrderAmountTo == null) {
              _obj.maxOrderAmountTo = 999999;
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += ' maxOrderAmount >=  ${_obj.maxOrderAmountFrom} AND maxOrderAmount <=  ${_obj.maxOrderAmountTo}';
          }

          if (_obj.avgOrderAmountFrom != null || _obj.avgOrderAmountTo != null) {
            if (_obj.avgOrderAmountFrom == null) {
              _obj.avgOrderAmountFrom = 0;
            }

            if (_obj.avgOrderAmountTo == null) {
              _obj.avgOrderAmountTo = 999999;
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += ' avgOrderAmount >=  ${_obj.avgOrderAmountFrom} AND avgOrderAmount <=  ${_obj.avgOrderAmountTo}';
          }

          if (_obj.totalOrderFrom != null || _obj.totalOrderTo != null) {
            if (_obj.totalOrderFrom == null) {
              _obj.totalOrderFrom = 0;
            }

            if (_obj.totalOrderTo == null) {
              _obj.totalOrderTo = 999999;
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += ' totalOrders >=  ${_obj.totalOrderFrom} AND totalOrders <=  ${_obj.totalOrderTo}';
          }

          if (_obj.totalSpendFrom != null || _obj.totalSpendTo != null) {
            if (_obj.totalSpendFrom == null) {
              _obj.totalSpendFrom = 0;
            }

            if (_obj.totalSpendTo == null) {
              _obj.totalSpendTo = 999999;
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += ' totalSpend >=  ${_obj.totalSpendFrom} AND totalSpend <=  ${_obj.totalSpendTo}';
          }

          if (_obj.totalPaidFrom != null || _obj.totalPaidTo != null) {
            if (_obj.totalPaidFrom == null) {
              _obj.totalPaidFrom = 0;
            }

            if (_obj.totalPaidTo == null) {
              _obj.totalPaidTo = 999999;
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += ' totalPaid >=  ${_obj.totalPaidFrom} AND totalPaid <=  ${_obj.totalPaidTo}';
          }

          if (_obj.totalPendingFrom != null || _obj.totalPendingTo != null) {
            if (_obj.totalPendingFrom == null) {
              _obj.totalPendingFrom = 0;
            }

            if (_obj.totalPendingTo == null) {
              _obj.totalPendingTo = 999999;
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += 'totalSpend - totalPaid >=  ${_obj.totalPendingFrom} AND totalSpend - totalPaid <=  ${_obj.totalPendingTo}';
          }

          var result = await dbClient.rawQuery(query);
          List<AccountSellerReportModel> _temp = result.map((f) => AccountSellerReportModel.fromMap(f)).toList();
          if (_temp != null && _temp.length > 0) {
            _temp.map((e) => e.accountNamePrefix = _accountData[i].namePrefix).toList();
            _temp.map((e) => e.accountFirstName = _accountData[i].firstName).toList();
            _temp.map((e) => e.accountMiddleName = _accountData[i].middleName).toList();
            _temp.map((e) => e.accountLastName = _accountData[i].lastName).toList();
            _temp.map((e) => e.accountNameSuffix = _accountData[i].nameSuffix).toList();
            _temp.map((e) => e.accountMobileCountryCode = _accountData[i].mobileCountryCode).toList();
            _temp.map((e) => e.accountMobile = _accountData[i].mobile).toList();
            _temp.map((e) => e.accountEmail = _accountData[i].email).toList();
            _temp.map((e) => e.accountRegistrationDate = _accountData[i].createdAt).toList();
            _accountSellerReportList.addAll(_temp);
          }
        }
      }
      return _accountSellerReportList;
    } catch (e) {
      print('Exception - getAccountSellerReportData(): ' + e.toString());
      return null;
    }
  }

  Future<List<SalesTaxAndDiscountReportModel>> getSalesTaxAndDiscountReportData(SalesTaxAndDiscountReportFilterModel _obj) async {
    try {
      List<Account> _accountData = [];
      List<SalesTaxAndDiscountReportModel> _salesTaxAndDiscountReportList = [];
      var dbClient = await db;
      String getAccountSql = 'select * from accounts WHERE accountType like "%Customer%"';

      if (_obj.accountRegistrationDateFrom != null || _obj.accountRegistrationDateTo != null) {
        if (_obj.accountRegistrationDateFrom == null) {
          _obj.accountRegistrationDateFrom = DateTime(2000);
        }

        if (_obj.accountRegistrationDateTo == null) {
          _obj.accountRegistrationDateTo = DateTime.now();
        }

        if (!getAccountSql.contains('WHERE')) {
          getAccountSql += ' WHERE ';
        } else {
          getAccountSql += ' AND ';
        }
        getAccountSql += ' date(createdAt) >=  \'${_dateInString(_obj.accountRegistrationDateFrom)}\' AND date(createdAt) <=  \'${_dateInString(_obj.accountRegistrationDateTo)}\'';
      }

      if (_obj.accountPincode != null && _obj.accountPincode != '') {
        if (!getAccountSql.contains('WHERE')) {
          getAccountSql += ' WHERE ';
        } else {
          getAccountSql += ' AND ';
        }
        getAccountSql += ' pincode like \'%${_obj.accountPincode}%\'';
      }
      var accountData = await dbClient.rawQuery(getAccountSql);
      _accountData = accountData.map((f) => Account.fromMap(f)).toList();

      if (_accountData != null && _accountData.length > 0) {
        for (int i = 0; i < _accountData.length; i++) {
          String query = """ 
          select ifnull((select sum(discount) from SaleInvoices where accountId = ${_accountData[i].id} and status != 'CANCELLED'
          """;

          if (_obj.salesInvoiceDateFrom != null || _obj.salesInvoiceDateTo != null) {
            if (_obj.salesInvoiceDateFrom == null) {
              _obj.salesInvoiceDateFrom = DateTime(2000);
            }

            if (_obj.salesInvoiceDateTo == null) {
              _obj.salesInvoiceDateTo = DateTime.now();
            }

            query += ' and date(invoiceDate) >=  \'${_dateInString(_obj.salesInvoiceDateFrom)}\' AND date(invoiceDate) <=  \'${_dateInString(_obj.salesInvoiceDateTo)}\'';
          }

          query += """ ),0) as totalDiscount, ifnull((select sum(finalTax) from SaleInvoices where accountId = ${_accountData[i].id} and status != 'CANCELLED'""";

          if (_obj.salesInvoiceDateFrom != null || _obj.salesInvoiceDateTo != null) {
            if (_obj.salesInvoiceDateFrom == null) {
              _obj.salesInvoiceDateFrom = DateTime(2000);
            }

            if (_obj.salesInvoiceDateTo == null) {
              _obj.salesInvoiceDateTo = DateTime.now();
            }

            query += ' and date(invoiceDate) >=  \'${_dateInString(_obj.salesInvoiceDateFrom)}\' AND date(invoiceDate) <=  \'${_dateInString(_obj.salesInvoiceDateTo)}\'';
          }

          query += """ ),0) as totaltax """;

          if (_obj.totalDiscountAmountFrom != null || _obj.totalDiscountAmountTo != null) {
            if (_obj.totalDiscountAmountFrom == null) {
              _obj.totalDiscountAmountFrom = 0;
            }

            if (_obj.totalDiscountAmountTo == null) {
              _obj.totalDiscountAmountTo = 999999;
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += 'totalDiscount >=  ${_obj.totalDiscountAmountFrom} AND totalDiscount <=  ${_obj.totalDiscountAmountTo}';
          }

          if (_obj.totalTaxAmountFrom != null || _obj.totalTaxAmountTo != null) {
            if (_obj.totalTaxAmountFrom == null) {
              _obj.totalTaxAmountFrom = 0;
            }

            if (_obj.totalTaxAmountTo == null) {
              _obj.totalTaxAmountTo = 999999;
            }

            if (!query.contains('WHERE')) {
              query += ' WHERE ';
            } else {
              query += ' AND ';
            }
            query += 'totaltax >=  ${_obj.totalTaxAmountFrom} AND totaltax <=  ${_obj.totalTaxAmountTo}';
          }

          var result = await dbClient.rawQuery(query);
          List<SalesTaxAndDiscountReportModel> _temp = result.map((f) => SalesTaxAndDiscountReportModel.fromMap(f)).toList();
          if (_temp != null && _temp.length > 0) {
            _temp.map((e) => e.accountNamePrefix = _accountData[i].namePrefix).toList();
            _temp.map((e) => e.accountFirstName = _accountData[i].firstName).toList();
            _temp.map((e) => e.accountMiddleName = _accountData[i].middleName).toList();
            _temp.map((e) => e.accountLastName = _accountData[i].lastName).toList();
            _temp.map((e) => e.accountNameSuffix = _accountData[i].nameSuffix).toList();
            _temp.map((e) => e.accountMobileCountryCode = _accountData[i].mobileCountryCode).toList();
            _temp.map((e) => e.accountMobile = _accountData[i].mobile).toList();
            _temp.map((e) => e.accountEmail = _accountData[i].email).toList();
            _temp.map((e) => e.accountRegistrationDate = _accountData[i].createdAt).toList();
            _salesTaxAndDiscountReportList.addAll(_temp);
          }
        }
      }
      return _salesTaxAndDiscountReportList;
    } catch (e) {
      print('Exception - getSalesTaxAndDiscountReportData(): ' + e.toString());
      return null;
    }
  }

  Future<List<BusinessChart>> saleInvoiceBusinessMapData({int totalMonths, String orderBy, bool isMonthWise}) async //display list of payment from Payments Table //paymentDisplayPayment
  {
    try {
      var dbClient = await db;
      DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month - 2, 1);
      DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

      if (totalMonths != null) {
        if (totalMonths == 1) {
          startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
          endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
        } else if (totalMonths == 2) {
          startDate = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
          endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
        } else if (totalMonths == 3) {
          startDate = DateTime(DateTime.now().year, DateTime.now().month - 2, 1);
          endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
        } else if (totalMonths == 6) {
          startDate = DateTime(DateTime.now().year, DateTime.now().month - 5, 1);
          endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
        }
      }
      String query = 'WITH RECURSIVE dates(date) AS ( ' + ' VALUES(date(\'$startDate\'))' + ' UNION ALL' + ' SELECT date(date, \'+1 day\')' + ' FROM dates' + ' WHERE date < date(\'$endDate\'))' + ' SELECT date AS invoiceDate, SUM(IFNULL(t1.grossAmount, 0)) AS totalAmount FROM dates LEFT JOIN SaleInvoices t1 ON date(t1.invoiceDate) = date AND t1.status != \'CANCELLED\' ';

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' (date(t1.invoiceDate) >= date(\'$startDate\') AND date(t1.invoiceDate) <= date(\'$endDate\'))';
      }

      if (isMonthWise) {
        query += ' GROUP BY strftime("%m - %Y",date) ORDER BY date ';
      } else {
        query += ' GROUP BY strftime("%W",date) ORDER BY date ';
      }
      var result = await dbClient.rawQuery(query);
      return result.map((f) => BusinessChart.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleInvoiceBusinessMapData(): ' + e.toString());
      return null;
    }
  }

  Future<List<BusinessChart>> purchaseInvoiceBusinessMapData({int totalMonths, String orderBy, bool isMonthWise}) async //display list of payment from Payments Table //paymentDisplayPayment
  {
    try {
      var dbClient = await db;
      DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month - 2, 1);
      DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

      if (totalMonths != null) {
        if (totalMonths == 1) {
          startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
          endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
        } else if (totalMonths == 2) {
          startDate = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
          endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
        } else if (totalMonths == 3) {
          startDate = DateTime(DateTime.now().year, DateTime.now().month - 2, 1);
          endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
        } else if (totalMonths == 6) {
          startDate = DateTime(DateTime.now().year, DateTime.now().month - 5, 1);
          endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
        }
      }
      String query = 'WITH RECURSIVE dates(date) AS ( ' + ' VALUES(date(\'$startDate\'))' + ' UNION ALL' + ' SELECT date(date, \'+1 day\')' + ' FROM dates' + ' WHERE date < date(\'$endDate\'))' + ' SELECT date AS invoiceDate, SUM(IFNULL(t1.grossAmount, 0)) AS totalAmount FROM dates LEFT JOIN PurchaseInvoices t1 ON date(t1.invoiceDate) = date AND t1.status != \'CANCELLED\' ';

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' (date(t1.invoiceDate) >= date(\'$startDate\') AND date(t1.invoiceDate) <= date(\'$endDate\'))';
      }

      if (isMonthWise) {
        query += ' GROUP BY strftime("%m - %Y",date) ORDER BY date ';
      } else {
        query += ' GROUP BY strftime("%W",date) ORDER BY date ';
      }
      var result = await dbClient.rawQuery(query);
      //   print(result);
      return result.map((f) => BusinessChart.fromMap(f)).toList();
    } catch (e) {
      print('Exception - purchaseInvoiceBusinessMapData(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleOrder>> saleOrderGetList({int startIndex, int fetchRecords, List<int> orderIdList, int orderNumber, int accountId, DateTime startDate, bool fetchTaxOrders, DateTime endDate, String status, bool isComplete, bool isDelete, bool isCancelled, double amountFrom, double amountTo, int lastDays, String orderBy, bool isWithTax}) async //display list of invoices from SaleInvoices Table //invoiceDisplayInvoice
  {
    try {
      //  SaleInvoice();
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.accountCode, t2.namePrefix, t2.firstName, t2.middleName, t2.lastName, t2.nameSuffix, t3.saleQuoteNumber as salesQuoteNumber, t3.versionNumber as salesQuoteVersion, t4.id as salesInvoiceId, t4.InvoiceNumber as salesInvoiceNumber FROM SaleOrders t1 INNER JOIN Accounts t2 ON t1.accountId = t2.id LEFT JOIN SaleQuotes t3 on t3.id = t1.salesQuoteId LEFT JOIN SaleInvoices t4 on t1.id = t4.salesOrderId';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (orderIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.id IN (${orderIdList.join(',')}) ';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.accountId = $accountId ';
      }

      if (orderNumber != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.saleOrderNumber = $orderNumber ';
      }

      if (isWithTax != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += (isWithTax) ? ' t1.finalTax > 0 ' : ' t1.finalTax = 0 ';
      }

      // if (fetchTaxOrders != null) {
      //   if (!query.contains('WHERE')) {
      //     query += ' WHERE ';
      //   } else {
      //     query += ' AND ';
      //   }
      //   query += (fetchTaxOrders) ? ' t1.finalTax > 0 ' : ' t1.finalTax = 0 ';
      // }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.orderDate >= \'$startDate\' AND t1.orderDate <= \'$endDate\') ';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.orderDate >= \'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.orderDate <= \'$endDate\') ';
      }

      if (lastDays != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.orderDate > (SELECT DATETIME (\'now\', \'-$lastDays day\')) ';
      }

      //
      if (amountFrom != null && amountTo != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.netAmount >= $amountFrom AND t1.netAmount <= $amountTo) ';
      }

      if (amountFrom != null && amountTo == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.netAmount >= $amountFrom) ';
      }

      if (amountFrom == null && amountTo != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.netAmount <= $amountTo) ';
      }

      if (isComplete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isComplete = \'$isComplete\' ';
      }

      if (status != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.status = \'$status\' ';
      } else if (isCancelled != null && !isCancelled) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.status != \'CANCELLED\' ';
      }

      if (isDelete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isDelete = \'$isDelete\' ';
      } else {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isDelete = \'false\' ';
      }

      if (orderBy != null && orderBy.isNotEmpty) {
        query += ' ORDER BY t1.id $orderBy';
      } else {
        query += ' ORDER BY t1.orderDate desc';
      }

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleOrder.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleOrderGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleQuote>> saleQuoteGetList({int startIndex, int fetchRecords, List<int> orderIdList, int orderNumber, int accountId, DateTime startDate, DateTime endDate, String status, bool isComplete, bool isDelete, bool isCancelled, double amountFrom, double amountTo, int lastDays, String orderBy, bool isWithTax, String orderByQuoteDate}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.accountCode, t2.namePrefix, t2.firstName, t2.middleName, t2.lastName, t2.nameSuffix, t3.id invoiceId, t3.invoiceNumber,t4.id orderId, t4.saleOrderNumber FROM SaleQuotes t1 INNER JOIN Accounts t2 ON t1.accountId = t2.id LEFT JOIN SaleInvoices t3 ON t1.id = t3.salesQuoteId LEFT JOIN SaleOrders t4 ON t1.id = t4.salesQuoteId';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (orderIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.id IN (${orderIdList.join(',')}) ';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.accountId = $accountId ';
      }

      if (orderNumber != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.saleQuoteNumber = $orderNumber ';
      }

      if (isWithTax != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += (isWithTax) ? ' t1.finalTax > 0 ' : ' t1.finalTax = 0 ';
      }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.orderDate >= \'$startDate\' AND t1.orderDate <= \'$endDate\') ';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.orderDate >= \'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.orderDate <= \'$endDate\') ';
      }

      if (lastDays != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.orderDate > (SELECT DATETIME (\'now\', \'-$lastDays day\')) ';
      }

      //
      if (amountFrom != null && amountTo != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.netAmount >= $amountFrom AND t1.netAmount <= $amountTo) ';
      }

      if (amountFrom != null && amountTo == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.netAmount >= $amountFrom) ';
      }

      if (amountFrom == null && amountTo != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.netAmount <= $amountTo) ';
      }

      if (isComplete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isComplete = \'$isComplete\' ';
      }

      if (status != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.status = \'$status\' ';
      } else if (isCancelled != null && !isCancelled) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.status != \'CANCELLED\' ';
      }

      if (isDelete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isDelete = \'$isDelete\' ';
      } else {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isDelete = \'false\' ';
      }

      if (orderBy != null && orderBy.isNotEmpty) {
        query += ' ORDER BY t1.id $orderBy';
      } else if (orderByQuoteDate != null && orderByQuoteDate.isNotEmpty) {
        //, CAST(t1.saleQuoteNumber || t1.versionNumber AS INTEGER)
        query += ' ORDER BY t1.orderDate $orderByQuoteDate';
      }

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleQuote.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleQuoteGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceGetNewInvoiceNumber() async //fetch all accounts for generate account code from Account Table //accountFetchAccounts
  {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery('SELECT MAX(CAST(invoiceNumber AS INT)) FROM SaleInvoices WHERE businessId=?', [_business.id]);
      if (result[0].values.first == null) {
        print('invoiceInitialNo :' + global.systemFlagNameList.invoiceInitialNo);
        var value = br.getSystemFlagValue(global.systemFlagNameList.invoiceInitialNo);
        return int.parse(value);
      } else {
        int res = result[0].values.first;
        return (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceInitialNo)) > (res + 1)) ? int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceInitialNo)) : (res + 1);
      }
    } catch (e) {
      print('Exception - saleInvoiceGetNewInvoiceNumber(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleOrderGetNewOrderNumber() async //fetch all accounts for generate account code from Account Table //accountFetchAccounts
  {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery('SELECT MAX(CAST(saleOrderNumber AS INT)) FROM SaleOrders WHERE businessId=?', [_business.id]);
      if (result[0].values.first == null) {
        var value = br.getSystemFlagValue(global.systemFlagNameList.saleOrderInitialNo);
        return int.parse(value);
      } else {
        int res = result[0].values.first;
        return (int.parse(br.getSystemFlagValue(global.systemFlagNameList.saleOrderInitialNo)) > (res + 1)) ? int.parse(br.getSystemFlagValue(global.systemFlagNameList.saleOrderInitialNo)) : (res + 1);
      }
    } catch (e) {
      print('Exception - saleOrderGetNewOrderNumber(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleQuoteGetNewOrderNumber() async {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery('SELECT MAX(CAST(saleQuoteNumber AS INT)) FROM SaleQuotes WHERE businessId=?', [_business.id]);
      if (result[0].values.first == null) {
        var value = br.getSystemFlagValue(global.systemFlagNameList.saleQuoteInitialNo);
        return int.parse(value);
      } else {
        int res = result[0].values.first;
       return (int.parse(br.getSystemFlagValue(global.systemFlagNameList.saleQuoteInitialNo)) > (res + 1)) ? int.parse(br.getSystemFlagValue(global.systemFlagNameList.saleQuoteInitialNo)) : (res + 1);
      }
    } catch (e) {
      print('Exception - saleQuoteGetNewOrderNumber(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleQuoteGetNewVersionNumber() async {
    try {
      var dbClient = await db;
      var result = await dbClient.rawQuery('SELECT MAX(CAST(versionNumber AS INT)) FROM SaleQuotes WHERE businessId=?', [_business.id]);
      if (result[0].values.first == null) {
        return 1;
      } else {
        int res = result[0].values.first;
        return res + 1;
      }
    } catch (e) {
      print('Exception - saleQuoteGetNewVersionNumber(): ' + e.toString());
      return null;
    }
  }

  Future<double> saleInvoiceGetSumOfGrossAmount({int accountId, String invoiceStatus}) async //get no.of active invoices from SaleInvoices Table //invoiceGetCount
  {
    try {
      double _result;
      String _value;
      var dbClient = await db;
      String query = 'SELECT SUM(netAmount) FROM SaleInvoices WHERE businessId=${_business.id} AND status != \'CANCELLED\'';

      if (accountId != null) {
        query += ' AND accountId = $accountId';
      }
      var result = await dbClient.rawQuery(query);
      _value = result[0].values.toString().substring(1, result[0].values.toString().length - 1);
      if (_value != 'null') {
        _result = double.parse(result[0].values.toString().substring(1, result[0].values.toString().length - 1));
      }
      return (_value != 'null') ? _result : 0;
    } catch (e) {
      print('Exception - saleInvoiceGetSumOfGrossAmount(): ' + e.toString());
      return null;
    }
  }

  Future<SaleInvoice> saleInvoiceInsert(SaleInvoice obj, bool isTaxApplied) async //insertion in SaleInvoices Table //invoiceCreateInvoice
  {
    try {
      var dbClient = await db;
      obj.isDelete = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('SaleInvoices', obj.toMap(true));
      obj.invoiceDetailList.map((invoiceDetail) => invoiceDetail.invoiceId = obj.id).toList();

      for (int i = 0; i < obj.invoiceDetailList.length; i++) {
        await saleInvoiceDetailInsert(obj.invoiceDetailList[i]);
      }

      if (obj.invoiceDetailTaxList.length != 0 && isTaxApplied == true) {
        int _counter = 0;
        //  obj.invoiceDetailList.forEach((invoiceDetail)
        for (int k = 0; k < obj.invoiceDetailList.length; k++) {
          List<ProductTax> _productTaxList = await productTaxGetList(productIdList: [obj.invoiceDetailList[k].productId]);
          if (_productTaxList.length > 0) {
            for (int i = 0; i < obj.invoiceTaxList.length; i++) {
              obj.invoiceDetailTaxList[_counter].invoiceDetailId = obj.invoiceDetailList[k].id;
              _counter++;
            }
          }
        }
      }

      if (isTaxApplied == true) {
        obj.invoiceTaxList.map((invoiceTax) => invoiceTax.invoiceId = obj.id).toList();
        obj.invoiceTaxList.map((invoiceTax) async => invoiceTax.id = await saleInvoiceTaxInsert(invoiceTax)).toList();
        obj.invoiceDetailTaxList.map((invoiceDetailTax) async => await saleInvoiceDetailTaxInsert(invoiceDetailTax)).toList();
      }

      if (obj.payment.paymentDetailList.length != 0) {
        obj.payment.accountId = obj.accountId;

        for (int pd = 0; pd < obj.payment.paymentDetailList.length; pd++) {
          if (obj.payment.paymentDetailList[pd].id != null) {
            obj.payment.paymentDetailList.removeAt(pd);
          }
        }
        if (obj.payment.paymentDetailList.length > 0) {
          obj.payment.amount = obj.payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount);
          obj.payment.transactionDate = obj.invoiceDate;
          obj.payment.paymentType = 'RECEIVED';
          obj.payment.remark = obj.remark;
          obj.payment = await paymentInsert(obj.payment);
          obj.paymentInvoice.paymentId = obj.payment.id;
          obj.paymentInvoice.invoiceId = obj.id;
          obj.paymentInvoice.amount = obj.payment.amount;
          obj.paymentInvoice = await paymentSaleInvoiceInsert(obj.paymentInvoice);
        }

        for (int i = 0; i < obj.saleQuoteList.length; i++) {
          if (obj.saleQuoteList[i].id != null) {
            bool _isFirstInv = true;
            obj.saleQuoteList[i].quoteDetailList.forEach((element) {
              if (element.invoicedQuantity > 0) {
                _isFirstInv = false;
              }
            });
            if (_isFirstInv) {
              List<PaymentSaleQuotes> _paymentSaleQuoteList = await paymentSaleQuoteGetList(orderIdList: [obj.saleQuoteList[i].id]);
              for (int i = 0; i < _paymentSaleQuoteList.length; i++) {
                PaymentSaleInvoice _obj = PaymentSaleInvoice();
                _obj.paymentId = _paymentSaleQuoteList[i].paymentId;
                _obj.invoiceId = obj.id;
                _obj.amount = _paymentSaleQuoteList[i].amount;
                await paymentSaleInvoiceInsert(_obj);
              }
            }
          }
        }
      }
      if (obj.saleQuoteList.length > 0) {
        SaleOrderInvoice _saleOrderInvoice = SaleOrderInvoice(null, obj.id, obj.saleQuoteList[0].id);
        await saleOrderInvoiceInsert(_saleOrderInvoice);
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj;
    } catch (e) {
      print('Exception - saleInvoiceInsert(): ' + e.toString());
      return null;
    }
  }

  Future<SaleOrder> saleOrderInsert(SaleOrder obj, bool isTaxApplied) async {
    try {
      var dbClient = await db;
      obj.isDelete = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('SaleOrders', obj.toMap(true));
      obj.orderDetailList.map((orderDetail) => orderDetail.saleOrderId = obj.id).toList();

      for (int i = 0; i < obj.orderDetailList.length; i++) {
        await saleOrderDetailInsert(obj.orderDetailList[i]);
      }

      if (obj.orderDetailTaxList.length != 0 && isTaxApplied == true) {
        int _counter = 0;
        for (int k = 0; k < obj.orderDetailList.length; k++) {
          List<ProductTax> _productTaxList = await productTaxGetList(productIdList: [obj.orderDetailList[k].productId]);
          if (_productTaxList.length > 0) {
            for (int i = 0; i < obj.orderTaxList.length; i++) {
              obj.orderDetailTaxList[_counter].saleOrderDetailId = obj.orderDetailList[k].id;
              _counter++;
            }
          }
        }
      }

      if (isTaxApplied == true) {
        obj.orderTaxList.map((orderTax) => orderTax.saleOrderId = obj.id).toList();
        obj.orderTaxList.map((orderTax) async => orderTax.id = await saleOrderTaxInsert(orderTax)).toList();
        obj.orderDetailTaxList.map((orderDetailTax) async => await saleOrderDetailTaxInsert(orderDetailTax)).toList();
      }

      if (obj.payment.paymentDetailList.length != 0) {
        obj.payment.accountId = obj.accountId;
        obj.payment.amount = obj.payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount);
        obj.payment.transactionDate = obj.orderDate;
        obj.payment.paymentType = 'RECEIVED';
        obj.payment.remark = obj.remark;
        obj.payment = await paymentInsert(obj.payment);
        obj.paymentSaleOrder.paymentId = obj.payment.id;
        obj.paymentSaleOrder.saleOrderId = obj.id;
        obj.paymentSaleOrder.amount = obj.payment.amount;
        obj.paymentSaleOrder = await paymentSaleOrderInsert(obj.paymentSaleOrder);
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj;
    } catch (e) {
      print('Exception - saleOrderInsert(): ' + e.toString());
      return null;
    }
  }

  Future<SaleQuote> saleQuoteInsert(SaleQuote obj, bool isTaxApplied) async {
    try {
      var dbClient = await db;
      obj.isDelete = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();

      obj.id = await dbClient.insert('SaleQuotes', obj.toMap(true));
      obj.quoteDetailList.map((quoteDetail) => quoteDetail.saleQuoteId = obj.id).toList();

      for (int i = 0; i < obj.quoteDetailList.length; i++) {
        obj.quoteDetailList[i].id = null;
        await saleQuoteDetailInsert(obj.quoteDetailList[i]);
      }

      if (obj.quoteDetailTaxList.length != 0) {
        int _counter = 0;
        for (int k = 0; k < obj.quoteDetailList.length; k++) {
          List<ProductTax> _productTaxList = await productTaxGetList(productIdList: [obj.quoteDetailList[k].productId]);
          if (_productTaxList.length > 0) {
            for (int i = 0; i < obj.quoteTaxList.length; i++) {
              obj.quoteDetailTaxList[_counter].saleQuoteDetailId = obj.quoteDetailList[k].id;
              _counter++;
            }
          }
        }
      }

      if (isTaxApplied == true) {
        obj.quoteTaxList.map((quoteTax) => quoteTax.saleQuoteId = obj.id).toList();
        obj.quoteTaxList.map((quoteTax) async => quoteTax.id = await saleQuoteTaxInsert(quoteTax)).toList();
        obj.quoteDetailTaxList.map((quoteDetailTax) async => await saleQuoteDetailTaxInsert(quoteDetailTax)).toList();
      }

      // if (obj.payment.paymentDetailList.length != 0) {
      //   for (int i = 0; i < obj.payment.paymentDetailList.length; i++) {
      //     obj.payment.paymentDetailList[i].id = null;
      //   }

      //   obj.payment.accountId = obj.accountId;
      //   obj.payment.amount = obj.payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount);
      //   obj.payment.transactionDate = obj.orderDate;
      //   obj.payment.paymentType = 'RECEIVED';
      //   obj.payment.remark = obj.remark;
      //   obj.payment = await paymentInsert(obj.payment);
      //   obj.paymentSaleQuote.paymentId = obj.payment.id;
      //   obj.paymentSaleQuote.saleQuoteId = obj.id;
      //   obj.paymentSaleQuote.amount = obj.payment.amount;
      //   obj.paymentSaleQuote = await paymentSaleQuoteInsert(obj.paymentSaleQuote);
      // }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj;
    } catch (e) {
      print('Exception - saleQuoteInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> getLatestQuoteVersionNumber({int saleQuoteNumber}) async {
    try {
      var dbClient = await db;
      dynamic data = await dbClient.rawQuery('select ifnull(max(versionNumber + 1),1) as newVersion from SaleQuotes where saleQuoteNumber = ?', [saleQuoteNumber]);
      int result = Sqflite.firstIntValue(data);
      return result;
    } catch (e) {
      print('Exception - getLatestQuoteVersionNumber(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceReturnDelete(int invoiceReturnId) async //delete invoice from Invoices Table //invoiceDeleteInvoice
  {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM SaleInvoiceReturns WHERE id=$invoiceReturnId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleInvoiceReturnDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceReturnDetailDelete({int invoiceReturnDetailId, int invoiceReturnId}) async //delete invoice Details from SaleInvoiceDetail Table //invoiceDetailDeleteInvoiceDetail
  {
    try {
      var dbClient = await db;

      if (invoiceReturnDetailId != null || invoiceReturnId != null) {
        String query = 'DELETE FROM SaleInvoiceReturnDetails ';

        if (invoiceReturnDetailId != null) {
          query += ' WHERE id = $invoiceReturnDetailId ';
        } else if (invoiceReturnId != null) {
          query += ' WHERE saleInvoiceReturnId = $invoiceReturnId ';
        }

        int result = await dbClient.rawDelete(query);
        await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
        return result;
      }
    } catch (e) {
      print('Exception - saleInvoiceReturnDetailDelete(): ' + e.toString());
    }
    return null;
  }

  Future saleInvoiceReturnDetailGetCount({int invoiceReturnId, int invoiceId}) async //get no.of active invoices from Invoices Table //invoiceGetCount
  {
    try {
      var dbClient = await db;
      String query = 'SELECT COUNT(DISTINCT productId) FROM SaleInvoiceReturnDetails WHERE businessId=${_business.id}';

      if (invoiceReturnId != null) {
        query += ' AND saleInvoiceReturnId= $invoiceReturnId';
      }

      if (invoiceId != null) {
        query += ' AND invoiceId= $invoiceId';
      }

      var result = Sqflite.firstIntValue(await dbClient.rawQuery(query));
      return result;
    } catch (e) {
      print('Exception - saleInvoiceReturnDetailGetCount(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleInvoiceReturnDetail>> saleInvoiceReturnDetailGetList({int invoiceReturnDetailId, int invoiceReturnId, int productId, List<int> saleInvoiceIdList}) async //display list of invoice detail from SaleInvoiceDetail Table //invoiceDetailDisplayInvoiceDetail
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM SaleInvoiceReturnDetails ';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (invoiceReturnDetailId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' id = $invoiceReturnDetailId ';
      }

      if (invoiceReturnId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' saleInvoiceReturnId = $invoiceReturnId ';
      }

      if (productId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' productId = $productId ';
      }

      if (saleInvoiceIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' invoiceId IN (${saleInvoiceIdList.join(',')}) ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleInvoiceReturnDetail.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleInvoiceReturnDetailGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceReturnDetailInsert(SaleInvoiceReturnDetail obj, bool isRefundTax) async //insertion in SaleInvoiceDetail Table //invoiceDetailCreateInvoiceDetail
  {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.quantity = obj.returnQuantity;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('SaleInvoiceReturnDetails', obj.toMap(true));
      if (isRefundTax) {
        obj.invoiceReturnDetailTaxList.map((f) => f.invoiceReturnDetailId = obj.id).toList();
        obj.invoiceReturnDetailTaxList.map((f) async => await saleInvoiceReturnDetailTaxInsert(f)).toList();
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - saleInvoiceReturnDetailInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceReturnDetailTaxDelete(List<int> invoiceReturnDetailIdList) async {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM SaleInvoiceReturnDetailTaxes WHERE invoiceReturnDetailId IN (${invoiceReturnDetailIdList.toString().substring(1, (invoiceReturnDetailIdList.toString().length - 1))})');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleInvoiceReturnDetailTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleInvoiceReturnDetailTax>> saleInvoiceReturnDetailTaxGetList({List<int> invoiceReturnDetailIdList}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM SaleInvoiceReturnDetailTaxes WHERE businessId=${_business.id} AND invoiceReturnDetailId IN (${invoiceReturnDetailIdList.toString().substring(1, (invoiceReturnDetailIdList.toString().length - 1))})';
      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleInvoiceReturnDetailTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleInvoiceReturnDetailTaxGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceReturnDetailTaxInsert(SaleInvoiceReturnDetailTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('SaleInvoiceReturnDetailTaxes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - saleInvoiceReturnDetailTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleInvoiceReturn>> saleInvoiceReturnGetList({List<String> transactionGroupIdList, List<int> invoiceReturnIdList, int invoiceNumber, int accountId, DateTime startDate, DateTime endDate, String status, bool isComplete, bool isDelete, double amountFrom, double amountTo, String orderBy}) async //display list of invoices from SaleInvoices Table //invoiceDisplayInvoice
  {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*, t2.accountCode, t2.namePrefix, t2.firstName, t2.middleName, t2.lastName, t2.nameSuffix FROM SaleInvoiceReturns t1 INNER JOIN Accounts t2 ON t1.accountId = t2.id ';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (invoiceReturnIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.id IN (${invoiceReturnIdList.toString().substring(1, (invoiceReturnIdList.toString().length - 1))}) ';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.accountId = $accountId ';
      }

      if (transactionGroupIdList != null && transactionGroupIdList.length > 0) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.transactionGroupId IN (\'${transactionGroupIdList.join('\',\'')}\') ';
      }

      if (invoiceNumber != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.invoiceNumber = $invoiceNumber ';
      }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate >= \'$startDate\' AND t1.invoiceDate <= \'$endDate\') ';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate >= \'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate <= \'$endDate\') ';
      }

      if (amountFrom != null && amountTo != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.grossAmount >= $amountFrom AND t1.grossAmount <= $amountTo) ';
      }

      if (amountFrom != null && amountTo == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.grossAmount >= $amountFrom) ';
      }

      if (amountFrom == null && amountTo != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.grossAmount <= $amountTo) ';
      }

      if (isComplete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isComplete = \'$isComplete\' ';
      }

      if (status != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.status = \'$status\' ';
      }

      if (isDelete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isDelete = \'$isDelete\' ';
      } else {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.isDelete = \'false\' ';
      }

      if (orderBy != null) {
        query += ' ORDER BY t1.id $orderBy';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleInvoiceReturn.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleInvoiceReturnGetList(): ' + e.toString());
      return null;
    }
  }

  Future<double> saleInvoiceReturnGetSumOfGrossAmount({int accountId}) async //get no.of active invoices from SaleInvoices Table //invoiceGetCount
  {
    try {
      double _result;
      String _value;
      var dbClient = await db;
      String query = 'SELECT SUM(grossAmount) FROM SaleInvoiceReturns WHERE businessId=${_business.id} AND status != \'CANCELLED\'';

      if (accountId != null) {
        query += ' AND accountId = $accountId';
      }
      var result = await dbClient.rawQuery(query);
      _value = result[0].values.toString().substring(1, result[0].values.toString().length - 1);
      if (_value != 'null') {
        _result = double.parse(result[0].values.toString().substring(1, result[0].values.toString().length - 1));
      }
      return (_value != 'null') ? _result : 0;
    } catch (e) {
      print('Exception - saleInvoiceReturnGetSumOfGrossAmount(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleInvoiceReturn>> saleInvoiceReturnInsert(List<SaleInvoiceReturn> objList, bool isRefundTax, Payment payment) async //insertion in SaleInvoices Table //invoiceCreateInvoice
  {
    try {
      var dbClient = await db;
      for (int i = 0; i < objList.length; i++) {
        int count = 0;
        objList[i].invoiceReturnDetailList.forEach((f) {
          if (f.isSelect) {
            count++;
          }
        });

        if (count > 0) {
          objList[i].isDelete = false;
          objList[i].isRefundTax = isRefundTax;
          objList[i].businessId = _business.id;
          objList[i].createdAt = DateTime.now();
          objList[i].modifiedAt = DateTime.now();
          objList[i].id = await dbClient.insert('SaleInvoiceReturns', objList[i].toMap(true));
          if (isRefundTax) {
            objList[i].invoiceReturnTaxList.map((f) => f.invoiceReturnId = objList[i].id).toList();
            objList[i].invoiceReturnTaxList.map((f) async => await saleInvoiceReturnTaxInsert(f)).toList();
          }
          objList[i].invoiceReturnDetailList.map((invoiceDetailReturn) => invoiceDetailReturn.saleInvoiceReturnId = objList[i].id).toList();

          for (int j = 0; j < objList[i].invoiceReturnDetailList.length; j++) {
            if (objList[i].invoiceReturnDetailList[j].isSelect) {
              await saleInvoiceReturnDetailInsert(objList[i].invoiceReturnDetailList[j], isRefundTax);
            }
          }
        }
      }

      if (payment.paymentDetailList.length > 0) {
        payment.accountId = objList[0].accountId;
        payment.amount = payment.paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount);
        payment.transactionDate = objList[0].invoiceDate;
        payment.paymentType = 'GIVEN';
        payment = await paymentInsert(payment);

        payment.paymentSaleInvoiceReturn.paymentId = payment.id;
        payment.paymentSaleInvoiceReturn.transactionGroupId = objList[0].transactionGroupId;
        payment.paymentSaleInvoiceReturn.amount = payment.amount;
        payment.paymentSaleInvoiceReturn = await paymentSaleInvoiceReturnInsert(payment.paymentSaleInvoiceReturn);
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return objList;
    } catch (e) {
      print('Exception - saleInvoiceReturnInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceReturnTaxDelete(int invoiceReturnId) async {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM SaleInvoiceReturnTaxes WHERE invoiceReturnId = $invoiceReturnId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleInvoiceReturnTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleInvoiceReturnTax>> saleInvoiceReturnTaxGetList({int invoiceReturnId}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.taxName FROM SaleInvoiceReturnTaxes t1 INNER JOIN TaxMasters t2 ON t1.taxId = t2.id WHERE t1.businessId=${_business.id} AND t1.invoiceReturnId = $invoiceReturnId';
      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleInvoiceReturnTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleInvoiceReturnTaxGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceReturnTaxInsert(SaleInvoiceReturnTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.insert('SaleInvoiceReturnTaxes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleInvoiceReturnTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleInvoiceReturn>> saleInvoiceReturnTransactionGroupGetList({
    int startIndex,
    int fetchRecords,
    String orderBy,
    int accountId,
    DateTime startDate,
    DateTime endDate,
  }) async {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,SUM(t1.grossAmount) as totalSpent, t2.accountCode, t2.namePrefix, t2.firstName, t2.middleName, t2.lastName, t2.nameSuffix FROM SaleInvoiceReturns t1 INNER JOIN Accounts t2 ON t1.accountId = t2.id WHERE t1.businessId=${_business.id}';

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.accountId = $accountId ';
      }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate >= \'$startDate\' AND t1.invoiceDate <= \'$endDate\') ';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate >= \'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (t1.invoiceDate <= \'$endDate\') ';
      }

      query += ' GROUP By t1.transactionGroupId';

      if (orderBy != null && orderBy.isNotEmpty) {
        query += ' ORDER BY t1.id $orderBy';
      } else {
        query += ' ORDER BY t1.invoiceDate desc';
      }
      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleInvoiceReturn.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleInvoiceReturnTransactionGroupGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleInvoiceReturn>> saleInvoiceReturnUpdate({List<SaleInvoiceReturn> saleInvoiceReturnList, bool isRefundTax, int updateFrom, Payment payment}) async {
    try {
      var dbClient = await db;
      for (int i = 0; i < saleInvoiceReturnList.length; i++) {
        int count = 0;
        saleInvoiceReturnList[i].invoiceReturnDetailList.forEach((f) {
          if (f.isSelect) {
            count++;
          }
        });

        if (count > 0 || updateFrom == 0) {
          saleInvoiceReturnList[i].modifiedAt = DateTime.now();
          int _result = await dbClient.update('SaleInvoiceReturns', saleInvoiceReturnList[i].toMap(false), where: 'id=${saleInvoiceReturnList[i].id}');
          if (_result == 1 && updateFrom == 1) {
            if (isRefundTax) {
              await saleInvoiceReturnTaxDelete(saleInvoiceReturnList[i].id);
              for (int j = 0; j < saleInvoiceReturnList[i].invoiceReturnTaxList.length; j++) {
                saleInvoiceReturnList[i].invoiceReturnTaxList[j].id = null;
                saleInvoiceReturnList[i].invoiceReturnTaxList[j].invoiceReturnId = saleInvoiceReturnList[i].id;
                await saleInvoiceReturnTaxInsert(saleInvoiceReturnList[i].invoiceReturnTaxList[j]);
              }
            }
            List<SaleInvoiceReturnDetail> _tempInvoiceReturnDetailList = await saleInvoiceReturnDetailGetList(invoiceReturnId: saleInvoiceReturnList[i].id);
            await saleInvoiceReturnDetailTaxDelete(_tempInvoiceReturnDetailList.map((f) => f.id).toList());
            await saleInvoiceReturnDetailDelete(invoiceReturnId: saleInvoiceReturnList[i].id);
            saleInvoiceReturnList[i].invoiceReturnDetailList.map((invoiceDetail) => invoiceDetail.saleInvoiceReturnId = saleInvoiceReturnList[i].id).toList();

            for (int j = 0; j < saleInvoiceReturnList[i].invoiceReturnDetailList.length; j++) {
              if (saleInvoiceReturnList[i].invoiceReturnDetailList[j].isSelect) {
                saleInvoiceReturnList[i].invoiceReturnDetailList[j].id = null;
                await saleInvoiceReturnDetailInsert(saleInvoiceReturnList[i].invoiceReturnDetailList[j], isRefundTax);
              }
            }
          }
        } else {
          List<SaleInvoiceReturnDetail> _tempInvoiceReturnDetailList = await saleInvoiceReturnDetailGetList(invoiceReturnId: saleInvoiceReturnList[i].id);
          await saleInvoiceReturnDetailTaxDelete(_tempInvoiceReturnDetailList.map((f) => f.id).toList());
          await saleInvoiceReturnDetailDelete(invoiceReturnId: saleInvoiceReturnList[i].id);
          await saleInvoiceReturnTaxDelete(saleInvoiceReturnList[i].id);
          await saleInvoiceReturnDelete(saleInvoiceReturnList[i].id);
        }
      }

      if (updateFrom == 1) {
        if (payment.paymentDetailList.length != 0) {
          List<PaymentDetail> _paymentDetailList = [];

          payment.paymentDetailList.forEach((item) {
            if (item.isRecentlyAdded == true) {
              _paymentDetailList.add(item);
            }
          });

          if (_paymentDetailList.length != 0) {
            payment.accountId = saleInvoiceReturnList[0].accountId;
            payment.amount = _paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount);
            payment.transactionDate = saleInvoiceReturnList[0].invoiceDate;
            payment.paymentType = 'GIVEN';
            //   invoice.payment.remark = invoice.remark;
            payment.paymentDetailList = _paymentDetailList;
            payment = await paymentInsert(payment);

            payment.paymentSaleInvoiceReturn.paymentId = payment.id;
            payment.paymentSaleInvoiceReturn.transactionGroupId = saleInvoiceReturnList[0].transactionGroupId;
            payment.paymentSaleInvoiceReturn.amount = payment.amount;
            payment.paymentSaleInvoiceReturn = await paymentSaleInvoiceReturnInsert(payment.paymentSaleInvoiceReturn);
          }
        }
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return saleInvoiceReturnList;
    } catch (e) {
      print('Exception - saleInvoiceReturnUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceTaxDelete(int invoiceId) async {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM SaleInvoiceTaxes WHERE invoiceId = $invoiceId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleInvoiceTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleOrderTaxDelete(int orderId) async {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM SaleOrderTaxes WHERE saleOrderId = $orderId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleOrderTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleQuoteTaxDelete(int quoteId) async {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM SaleQuoteTaxes WHERE saleQuoteId = $quoteId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleQuoteTaxDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleInvoiceTax>> saleInvoiceTaxGetList({int invoiceId}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.taxName FROM SaleInvoiceTaxes t1 INNER JOIN TaxMasters t2 ON t1.taxId = t2.id WHERE t1.businessId=${_business.id} AND t1.invoiceId = $invoiceId';
      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleInvoiceTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleInvoiceTaxGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleOrderTax>> saleOrderTaxGetList({int saleOrderId}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.taxName FROM SaleOrderTaxes t1 INNER JOIN TaxMasters t2 ON t1.taxId = t2.id WHERE t1.businessId=${_business.id} AND t1.saleOrderId = $saleOrderId';
      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleOrderTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleOrderTaxGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<SaleQuoteTax>> saleQuoteTaxGetList({int saleQuoteId}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.taxName FROM SaleQuoteTaxes t1 INNER JOIN TaxMasters t2 ON t1.taxId = t2.id WHERE t1.businessId=${_business.id} AND t1.saleQuoteId = $saleQuoteId';
      var result = await dbClient.rawQuery(query);
      return result.map((f) => SaleQuoteTax.fromMap(f)).toList();
    } catch (e) {
      print('Exception - saleQuoteTaxGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceTaxInsert(SaleInvoiceTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.insert('SaleInvoiceTaxes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleInvoiceTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleOrderTaxInsert(SaleOrderTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.insert('SaleOrderTaxes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleOrderTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleQuoteTaxInsert(SaleQuoteTax obj) async {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.insert('SaleQuoteTaxes', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleQuoteTaxInsert(): ' + e.toString());
      return null;
    }
  }

  Future<SaleInvoice> saleInvoiceUpdate({SaleInvoice invoice, int updateFrom, bool isTaxApplied, bool isAccountChanged}) async {
    try {
      var dbClient = await db;
      invoice.modifiedAt = DateTime.now();
      int _result = await dbClient.update('SaleInvoices', invoice.toMap(false), where: 'id=${invoice.id}');
      if (_result == 1 && updateFrom == 1) {
        await saleInvoiceDetailDelete(invoiceId: invoice.id);
        invoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.invoiceId = invoice.id).toList();

        for (int i = 0; i < invoice.invoiceDetailList.length; i++) {
          await saleInvoiceDetailInsert(invoice.invoiceDetailList[i]);
        }

        if (invoice.invoiceDetailTaxList.length != 0 && isTaxApplied) {
          int _counter = 0;
          for (int k = 0; k < invoice.invoiceDetailList.length; k++) {
            List<ProductTax> _productTaxList = await productTaxGetList(productIdList: [invoice.invoiceDetailList[k].productId]);
            if (_productTaxList.length > 0) {
              for (int i = 0; i < invoice.invoiceTaxList.length; i++) {
                invoice.invoiceDetailTaxList[_counter].invoiceDetailId = invoice.invoiceDetailList[k].id;
                _counter++;
              }
            }
          }
        }

        if (isTaxApplied) {
          invoice.invoiceTaxList.map((invoiceTax) => invoiceTax.invoiceId = invoice.id).toList();
          invoice.invoiceTaxList.map((invoiceTax) async => invoiceTax.id = await saleInvoiceTaxInsert(invoiceTax)).toList();
          invoice.invoiceDetailTaxList.map((invoiceDetailTax) async => await saleInvoiceDetailTaxInsert(invoiceDetailTax)).toList();
        }

        if (invoice.payment.paymentDetailList.length != 0) {
          // if account was changed
          if (isAccountChanged) {
            List<int> paymentIdList = [];
            invoice.payment.paymentDetailList.forEach((element) {
              if (element.paymentId != null) {
                paymentIdList.add(element.paymentId);
              }
            });
            List<Payment> _paymentList = await paymentGetList(paymentIdList: paymentIdList.toSet().toList());
            if (_paymentList.length > 0) {
              for (int i = 0; i < _paymentList.length; i++) {
                _paymentList[i].accountId = invoice.accountId;
                await paymentUpdate(_paymentList[i]);
              }
            }
          }
          // if user delete payment
          for (int i = 0; i < invoice.payment.paymentDetailList.length; i++) {
            if (invoice.payment.paymentDetailList[i].deletedFromScreen && invoice.payment.paymentDetailList[i].id != null) {
              List<Payment> _paymentList = await paymentGetList(paymentIdList: [invoice.payment.paymentDetailList[i].paymentId]);
              if (_paymentList.length > 0) {
                List<PaymentSaleInvoice> _paymentSaleInvoiceList = await paymentSaleInvoiceGetList(paymentId: _paymentList[0].id);
                _paymentList[0].amount -= invoice.payment.paymentDetailList[i].amount;
                if (_paymentList[0].amount > 0) {
                  await paymentUpdate(_paymentList[0]);
                } else {
                  await paymentDelete(paymentIdList: [_paymentList[0].id]);
                }

                if (_paymentSaleInvoiceList.length > 0) {
                  _paymentSaleInvoiceList[0].amount = _paymentList[0].amount;
                  if (_paymentSaleInvoiceList[0].amount > 0) {
                    await paymentSaleInvoiceUpdate(_paymentSaleInvoiceList[0]);
                  } else {
                    await paymentSaleInvoiceDelete(paymentIdList: [_paymentList[0].id]);
                  }
                }
              }
              await paymentDetailDelete(paymentDetailId: invoice.payment.paymentDetailList[i].id);
              invoice.payment.paymentDetailList.removeAt(i);
            }
          }
          // if user edit payment
          for (int i = 0; i < invoice.payment.paymentDetailList.length; i++) {
            if (!invoice.payment.paymentDetailList[i].deletedFromScreen && invoice.payment.paymentDetailList[i].isEdited && invoice.payment.paymentDetailList[i].id != null) {
              await paymentDetailUpdate(invoice.payment.paymentDetailList[i]);
              List<PaymentDetail> _paymentDetailList = await paymentDetailGetList(paymentIdList: [invoice.payment.paymentDetailList[i].paymentId]);
              if (_paymentDetailList.length > 0) {
                double _amount = _paymentDetailList.map((e) => e.amount).reduce((value, element) => value + element);
                List<Payment> _paymentList = await paymentGetList(paymentIdList: [invoice.payment.paymentDetailList[i].paymentId]);
                if (_paymentList.length > 0) {
                  _paymentList[0].amount = _amount;
                  await paymentUpdate(_paymentList[0]);
                  List<PaymentSaleInvoice> _paymentSaleInvoiceList = await paymentSaleInvoiceGetList(paymentId: _paymentList[0].id);
                  if (_paymentSaleInvoiceList.length > 0) {
                    _paymentSaleInvoiceList[0].amount = _amount;
                    await paymentSaleInvoiceUpdate(_paymentSaleInvoiceList[0]);
                  }
                }
              }
            }
          }
          // if user add  payment
          List<PaymentDetail> _paymentDetailList = [];
          invoice.payment.paymentDetailList.forEach((item) {
            if (item.isRecentlyAdded && !item.deletedFromScreen) {
              _paymentDetailList.add(item);
            }
          });
          if (_paymentDetailList.length != 0) {
            invoice.payment.accountId = invoice.accountId;
            invoice.payment.amount = _paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount);
            invoice.payment.transactionDate = invoice.invoiceDate;
            invoice.payment.paymentType = 'RECEIVED';
            invoice.payment.remark = invoice.remark;
            invoice.payment.paymentDetailList = _paymentDetailList;
            invoice.payment = await paymentInsert(invoice.payment);
            invoice.paymentInvoice.paymentId = invoice.payment.id;
            invoice.paymentInvoice.invoiceId = invoice.id;
            invoice.paymentInvoice.amount = invoice.payment.amount;
            invoice.paymentInvoice = await paymentSaleInvoiceInsert(invoice.paymentInvoice);
          }
        }
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return invoice;
    } catch (e) {
      print('Exception - saleInvoiceUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<SaleOrder> saleOrderUpdate({SaleOrder order, int updateFrom, bool isTaxApplied, bool isAccountChanged}) async {
    try {
      var dbClient = await db;
      order.modifiedAt = DateTime.now();
      int _result = await dbClient.update('SaleOrders', order.toMap(false), where: 'id=${order.id}');
      if (_result == 1 && updateFrom == 1) {
        await saleOrderDetailDelete(orderId: order.id);
        order.orderDetailList.map((orderDetail) => orderDetail.saleOrderId = order.id).toList();

        for (int i = 0; i < order.orderDetailList.length; i++) {
          await saleOrderDetailInsert(order.orderDetailList[i]);
        }

        if (order.orderDetailTaxList.length != 0 && isTaxApplied) {
          int _counter = 0;
          //  obj.invoiceDetailList.forEach((invoiceDetail)
          for (int k = 0; k < order.orderDetailList.length; k++) {
            List<ProductTax> _productTaxList = await productTaxGetList(productIdList: [order.orderDetailList[k].productId]);
            if (_productTaxList.length > 0) {
              for (int i = 0; i < order.orderTaxList.length; i++) {
                order.orderDetailTaxList[_counter].saleOrderDetailId = order.orderDetailList[k].id;
                _counter++;
              }
            }
          }
        }

        if (isTaxApplied) {
          order.orderTaxList.map((orderTax) => orderTax.saleOrderId = order.id).toList();
          order.orderTaxList.map((orderTax) async => orderTax.id = await saleOrderTaxInsert(orderTax)).toList();
          order.orderDetailTaxList.map((orderDetailTax) async => await saleOrderDetailTaxInsert(orderDetailTax)).toList();
        }

        if (order.payment.paymentDetailList.length != 0) {
          // if account was changed
          if (isAccountChanged) {
            List<int> paymentIdList = [];
            order.payment.paymentDetailList.forEach((element) {
              if (element.paymentId != null) {
                paymentIdList.add(element.paymentId);
              }
            });
            List<Payment> _paymentList = await paymentGetList(paymentIdList: paymentIdList.toSet().toList());
            if (_paymentList.length > 0) {
              for (int i = 0; i < _paymentList.length; i++) {
                _paymentList[i].accountId = order.accountId;
                await paymentUpdate(_paymentList[i]);
              }
            }
          }
          // if user delete payment
          for (int i = 0; i < order.payment.paymentDetailList.length; i++) {
            if (order.payment.paymentDetailList[i].deletedFromScreen && order.payment.paymentDetailList[i].id != null) {
              List<Payment> _paymentList = await paymentGetList(paymentIdList: [order.payment.paymentDetailList[i].paymentId]);
              if (_paymentList.length > 0) {
                List<PaymentSaleOrder> _paymentSaleOrderList = await paymentSaleOrderGetList(paymentIdList: [_paymentList[0].id]);
                _paymentList[0].amount -= order.payment.paymentDetailList[i].amount;
                if (_paymentList[0].amount > 0) {
                  await paymentUpdate(_paymentList[0]);
                } else {
                  await paymentDelete(paymentIdList: [_paymentList[0].id]);
                }

                if (_paymentSaleOrderList.length > 0) {
                  _paymentSaleOrderList[0].amount = _paymentList[0].amount;
                  if (_paymentSaleOrderList[0].amount > 0) {
                    await paymentSaleOrderUpdate(_paymentSaleOrderList[0]);
                  } else {
                    await paymentSaleOrderDelete(paymentIdList: [_paymentList[0].id]);
                  }
                }
              }
              await paymentDetailDelete(paymentDetailId: order.payment.paymentDetailList[i].id);
              order.payment.paymentDetailList.removeAt(i);
            }
          }
          // if user edit payment
          for (int i = 0; i < order.payment.paymentDetailList.length; i++) {
            if (!order.payment.paymentDetailList[i].deletedFromScreen && order.payment.paymentDetailList[i].isEdited && order.payment.paymentDetailList[i].id != null) {
              await paymentDetailUpdate(order.payment.paymentDetailList[i]);
              List<PaymentDetail> _paymentDetailList = await paymentDetailGetList(paymentIdList: [order.payment.paymentDetailList[i].paymentId]);
              if (_paymentDetailList.length > 0) {
                double _amount = _paymentDetailList.map((e) => e.amount).reduce((value, element) => value + element);
                List<Payment> _paymentList = await paymentGetList(paymentIdList: [order.payment.paymentDetailList[i].paymentId]);
                if (_paymentList.length > 0) {
                  _paymentList[0].amount = _amount;
                  await paymentUpdate(_paymentList[0]);
                  List<PaymentSaleOrder> _paymentSaleOrderList = await paymentSaleOrderGetList(paymentIdList: [_paymentList[0].id]);
                  if (_paymentSaleOrderList.length > 0) {
                    _paymentSaleOrderList[0].amount = _amount;
                    await paymentSaleOrderUpdate(_paymentSaleOrderList[0]);
                  }
                }
              }
            }
          }
          // if user add  payment
          List<PaymentDetail> _paymentDetailList = [];
          order.payment.paymentDetailList.forEach((item) {
            if (item.isRecentlyAdded && !item.deletedFromScreen) {
              _paymentDetailList.add(item);
            }
          });
          if (_paymentDetailList.length != 0) {
            order.payment.accountId = order.accountId;
            order.payment.amount = _paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount);
            order.payment.transactionDate = order.orderDate;
            order.payment.paymentType = 'RECEIVED';
            order.payment.remark = order.remark;
            order.payment.paymentDetailList = _paymentDetailList;
            order.payment = await paymentInsert(order.payment);
            order.paymentSaleOrder.paymentId = order.payment.id;
            order.paymentSaleOrder.saleOrderId = order.id;
            order.paymentSaleOrder.amount = order.payment.amount;
            order.paymentSaleOrder = await paymentSaleOrderInsert(order.paymentSaleOrder);
          }
        }
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return order;
    } catch (e) {
      print('Exception - saleOrderUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<SaleQuote> saleQuoteUpdate({SaleQuote quote, int updateFrom, bool isTaxApplied, bool isAccountChanged}) async {
    try {
      var dbClient = await db;
      quote.modifiedAt = DateTime.now();
      int _result = await dbClient.update('SaleQuotes', quote.toMap(false), where: 'id=${quote.id}');
      if (_result == 1 && updateFrom == 1) {
        await saleQuoteDetailDelete(quoteId: quote.id);
        quote.quoteDetailList.map((quoteDetail) => quoteDetail.saleQuoteId = quote.id).toList();

        for (int i = 0; i < quote.quoteDetailList.length; i++) {
          await saleQuoteDetailInsert(quote.quoteDetailList[i]);
        }

        if (quote.quoteDetailTaxList.length != 0) {
          int _counter = 0;
          //  obj.invoiceDetailList.forEach((invoiceDetail)
          for (int k = 0; k < quote.quoteDetailList.length; k++) {
            List<ProductTax> _productTaxList = await productTaxGetList(productIdList: [quote.quoteDetailList[k].productId]);
            if (_productTaxList.length > 0) {
              for (int i = 0; i < quote.quoteTaxList.length; i++) {
                quote.quoteDetailTaxList[_counter].saleQuoteDetailId = quote.quoteDetailList[k].id;
                _counter++;
              }
            }
          }
        }

        if (isTaxApplied) {
          quote.quoteTaxList.map((quoteTax) => quoteTax.saleQuoteId = quote.id).toList();
          quote.quoteTaxList.map((quoteTax) async => quoteTax.id = await saleQuoteTaxInsert(quoteTax)).toList();
          quote.quoteDetailTaxList.map((quoteDetailTax) async => await saleQuoteDetailTaxInsert(quoteDetailTax)).toList();
        }

        // if (order.payment.paymentDetailList.length != 0) {
        //   // if account was changed
        //   if (isAccountChanged) {
        //     List<int> paymentIdList = [];
        //     order.payment.paymentDetailList.forEach((element) {
        //       if (element.paymentId != null) {
        //         paymentIdList.add(element.paymentId);
        //       }
        //     });
        //     List<Payment> _paymentList = await paymentGetList(paymentIdList: paymentIdList.toSet().toList());
        //     if (_paymentList.length > 0) {
        //       for (int i = 0; i < _paymentList.length; i++) {
        //         _paymentList[i].accountId = order.accountId;
        //         await paymentUpdate(_paymentList[i]);
        //       }
        //     }
        //   }
        //   // if user delete payment
        //   for (int i = 0; i < order.payment.paymentDetailList.length; i++) {
        //     if (order.payment.paymentDetailList[i].deletedFromScreen && order.payment.paymentDetailList[i].id != null) {
        //       List<Payment> _paymentList = await paymentGetList(paymentIdList: [order.payment.paymentDetailList[i].paymentId]);
        //       if (_paymentList.length > 0) {
        //         List<PaymentSaleQuotes> _paymentSaleQuoteList = await paymentSaleQuoteGetList(paymentIdList: [_paymentList[0].id]);
        //         _paymentList[0].amount -= order.payment.paymentDetailList[i].amount;
        //         if (_paymentList[0].amount > 0) {
        //           await paymentUpdate(_paymentList[0]);
        //         } else {
        //           await paymentDelete(paymentIdList: [_paymentList[0].id]);
        //         }

        //         if (_paymentSaleQuoteList.length > 0) {
        //           _paymentSaleQuoteList[0].amount = _paymentList[0].amount;
        //           if (_paymentSaleQuoteList[0].amount > 0) {
        //             await paymentSaleQuoteUpdate(_paymentSaleQuoteList[0]);
        //           } else {
        //             await paymentSaleQuoteDelete(paymentIdList: [_paymentList[0].id]);
        //           }
        //         }
        //       }
        //       await paymentDetailDelete(paymentDetailId: order.payment.paymentDetailList[i].id);
        //       order.payment.paymentDetailList.removeAt(i);
        //     }
        //   }
        //   // if user edit payment
        //   for (int i = 0; i < order.payment.paymentDetailList.length; i++) {
        //     if (!order.payment.paymentDetailList[i].deletedFromScreen && order.payment.paymentDetailList[i].isEdited && order.payment.paymentDetailList[i].id != null) {
        //       await paymentDetailUpdate(order.payment.paymentDetailList[i]);
        //       List<PaymentDetail> _paymentDetailList = await paymentDetailGetList(paymentIdList: [order.payment.paymentDetailList[i].paymentId]);
        //       if (_paymentDetailList.length > 0) {
        //         double _amount = _paymentDetailList.map((e) => e.amount).reduce((value, element) => value + element);
        //         List<Payment> _paymentList = await paymentGetList(paymentIdList: [order.payment.paymentDetailList[i].paymentId]);
        //         if (_paymentList.length > 0) {
        //           _paymentList[0].amount = _amount;
        //           await paymentUpdate(_paymentList[0]);
        //           List<PaymentSaleQuotes> _paymentSaleQuoteList = await paymentSaleQuoteGetList(paymentIdList: [_paymentList[0].id]);
        //           if (_paymentSaleQuoteList.length > 0) {
        //             _paymentSaleQuoteList[0].amount = _amount;
        //             await paymentSaleQuoteUpdate(_paymentSaleQuoteList[0]);
        //           }
        //         }
        //       }
        //     }
        //   }
        //   // if user add  payment
        //   List<PaymentDetail> _paymentDetailList = [];
        //   order.payment.paymentDetailList.forEach((item) {
        //     if (item.isRecentlyAdded && !item.deletedFromScreen) {
        //       _paymentDetailList.add(item);
        //     }
        //   });
        //   if (_paymentDetailList.length != 0) {
        //     order.payment.accountId = order.accountId;
        //     order.payment.amount = _paymentDetailList.map((paymentDetail) => paymentDetail.amount).reduce((sum, amount) => sum + amount);
        //     order.payment.transactionDate = order.orderDate;
        //     order.payment.paymentType = 'RECEIVED';
        //     order.payment.remark = order.remark;
        //     order.payment.paymentDetailList = _paymentDetailList;
        //     order.payment = await paymentInsert(order.payment);
        //     order.paymentSaleQuote.paymentId = order.payment.id;
        //     order.paymentSaleQuote.saleQuoteId = order.id;
        //     order.paymentSaleQuote.amount = order.payment.amount;
        //     order.paymentSaleQuote = await paymentSaleQuoteInsert(order.paymentSaleQuote);
        //   }
        // }
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return quote;
    } catch (e) {
      print('Exception - saleOrderUpdate(): ' + e.toString());
      return null;
    }
  }

  Future sqlScriptInit(int _businessId) async {
    try {
      ProductType _productType = ProductType();
      _productType.name = 'General';
      _productType.businessId = _businessId;
      _productType.id = await productTypeInsert(_productType); // general product category insert
    } catch (e) {
      print('Exception - sqlScriptInit(): ' + e.toString());
    }
  }

  Future<List<SystemFlag>> systemFlagGetList() async {
    try {
      var dbClient = await db;
      var select = ("SELECT * FROM SystemFlags");
      var result = await dbClient.rawQuery(select);
      List<SystemFlag> systemFlagList = result.map((f) => SystemFlag.fromMap(f)).toList();
      return systemFlagList;
    } catch (e) {
      print('Exception - systemFlagGetList(): ' + e.toString());
      return null;
    }
  }

  Future<String> systemFlagGetValue(String name, {openDB}) async {
    try {
      var dbClient;
      if (openDB != null) {
        dbClient = openDB;
      } else {
        dbClient = await db;
      }
      var result = await dbClient.rawQuery('SELECT value FROM SystemFlags WHERE name = ?', [name]);
      if (result.isNotEmpty) {
        return result.first['value'];
      } else {
        return null;
      }
    } catch (e) {
      print('Exception - systemFlagGetValue(): ' + e.toString());
      return null;
    }
  }

  Future<int> systemFlagUpdateName(String name, String updatedName, {openDb}) async {
    try {
      var dbClient;
      if (openDb != null) {
        dbClient = openDb;
      } else {
        dbClient = await db;
      }
      var result = await dbClient.rawUpdate('update SystemFlags set name=?,modifiedAt=? WHERE name = ?', [updatedName, DateTime.now().toString(), name]);
      print(result);
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - systemFlagUpdateName(): ' + e.toString());
      return null;
    }
  }

  Future<int> systemFlagUpdateValue(String name, String value, {openDb}) async {
    try {
      int result = 0;
      var dbClient;
      if (openDb != null) {
        dbClient = openDb;
      } else {
        dbClient = await db;
      }
      if (global.systemFlagList.where((e) => e.name == name).length > 0) {
        result = await dbClient.rawUpdate('update SystemFlags set value=?,modifiedAt=? WHERE name = ?', [value, DateTime.now().toString(), name]);
        if (result == 1) {
          global.systemFlagList.where((e) => e.name == name).map((e) => e.value = value).toList();
        }
      } else {
        SystemFlag systemFlag = SystemFlag(null, name, value, null, null, name, true, false, DateTime.now().toString(), null);

        result = await dbClient.insert('SystemFlags', systemFlag.toMap());
        if (result > 1) {
          systemFlag.id = result;
          global.systemFlagList.add(systemFlag);
        }
      }

      if (name != global.systemFlagNameList.dbChanged) {
        await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      }

      return result;
    } catch (e) {
      print('Exception - systemFlagValueUpdate(): ' + e.toString());
      return null;
    }
  }

  // Future<int> systemFlagUpdateValue(String name, String value, {openDb}) async {
  //   try {
  //     var dbClient;
  //     if (openDb != null) {
  //       dbClient = openDb;
  //     } else {
  //       dbClient = await db;
  //     }
  //     var result = await dbClient.rawUpdate('update SystemFlags set value=?,modifiedAt=? WHERE name = ?', [value, DateTime.now().toString(), name]);
  //     if (name != global.systemFlagNameList.dbChanged) {
  //       await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
  //     }
  //     print(result);
  //     return result;
  //   } catch (e) {
  //     print('Exception - systemFlagValueUpdate(): ' + e.toString());
  //     return null;
  //   }
  // }

  Future<bool> taxMasterCheckNameExist({String taxName, int taxId}) async //check product name already exist or not in Products Table //productCheckName
  {
    try {
      var dbClient = await db;
      String sql = 'SELECT COUNT(*) FROM TaxMasters WHERE businessId=${_business.id}';

      if (taxId != null) {
        sql += ' AND id!=\'$taxId\'';
      }
      if (taxName != null) {
        sql += ' AND (lower(taxName)=\'$taxName\' OR upper(taxName)=\'$taxName\' OR taxName = \'$taxName\')';
      }
      int result = Sqflite.firstIntValue(await dbClient.rawQuery(sql));
      return result == 1 ? true : false;
    } catch (e) {
      print('Exception - productCheckNameExist(): ' + e.toString());
      return null;
    }
  }

  Future<bool> saleOrderisUsed(int saleOrderId) async {
    try {
      var dbClient = await db;
      String sql = 'SELECT COUNT(*) FROM SaleOrdersInvoices WHERE businessId=${_business.id}';

      if (saleOrderId != null) {
        sql += ' AND saleOrderId ==\'$saleOrderId\'';
      }
      int result = Sqflite.firstIntValue(await dbClient.rawQuery(sql));
      return result > 0 ? true : false;
    } catch (e) {
      print('Exception - saleOrderisUsed(): ' + e.toString());
      return null;
    }
  }

  // Future<bool> saleQuoteisUsed(int saleQuoteId) async {
  //   try {
  //     var dbClient = await db;
  //     String sql = 'SELECT COUNT(*) FROM SaleQuotesInvoices WHERE businessId=${_business.id}';

  //     if (saleQuoteId != null) {
  //       sql += ' AND saleQuoteId ==\'$saleQuoteId\'';
  //     }
  //     int result = Sqflite.firstIntValue(await dbClient.rawQuery(sql));
  //     return result > 0 ? true : false;
  //   } catch (e) {
  //     print('Exception - saleQuoteisUsed(): ' + e.toString());
  //     return null;
  //   }
  // }

  Future<int> taxMasterDelete({int taxMasterId}) async {
    try {
      var dbClient = await db;
      int result;
      if (taxMasterId != null) {
        result = await dbClient.rawDelete('DELETE FROM TaxMasters WHERE businessId = ${_business.id} AND id=$taxMasterId');
      } else {
        result = await dbClient.rawDelete('DELETE FROM TaxMasters');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - (taxMasterDelete): ' + e.toString());
      return null;
    }
  }

  Future<List<TaxMaster>> taxMasterGetList({List<int> taxMasterIdList, String groupName, bool isApplyPerProduct, String searchString, bool isActive}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM TaxMasters';

      if (_business != null && _business.id != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (taxMasterIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' id IN (${taxMasterIdList.toString().substring(1, (taxMasterIdList.toString().length - 1))}) ';
      }

      if (groupName != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 'groupName = \'$groupName\'';
      }

      if (isActive != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' isActive = \'$isActive\' ';
      }

      if (isApplyPerProduct != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' isApplyOnProduct = \'$isApplyPerProduct\' ';
      }

      if (searchString != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (name LIKE \'%$searchString%\') ';
      }

      query += ' ORDER BY applyOrder ';

      var result = await dbClient.rawQuery(query);
      return result.map((f) => TaxMaster.fromMap(f)).toList();
    } catch (e) {
      print('Exception - taxMasterGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<TaxMasterPercentage>> taxMasterPercentageGetList({bool isActive}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM TaxMastersPercentage';

      // if (_business != null) {
      //   if (!query.contains('WHERE')) {
      //     query += ' WHERE';
      //   } else {
      //     query += ' AND';
      //   }
      //   query += ' businessId = ${_business.id}';
      // }

      if (isActive != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' isActive = \'$isActive\' ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => TaxMasterPercentage.fromMap(f)).toList();
    } catch (e) {
      print('Exception - taxMasterPercentageGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> taxMasterInsert(TaxMaster obj) async {
    try {
      var dbClient = await db;
      obj.isDelete = false;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.insert('TaxMasters', obj.toMap());
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - taxMasterInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> taxMasterIsUsed({int taxId, int flagValue}) async //check tax is used in other tables
  {
    try {
      var dbClient = await db;
      String query;
      if (flagValue == 0) {
        query = 'SELECT COUNT(*) FROM SaleInvoiceDetailTaxes WHERE businessId=${_business.id} AND taxId=$taxId';
      } else if (flagValue == 1) {
        query = 'SELECT COUNT(*) FROM SaleInvoiceTaxes WHERE businessId=${_business.id} AND taxId=$taxId';
      } else if (flagValue == 2) {
        query = 'SELECT COUNT(*) FROM ProductTypeTaxes WHERE businessId=${_business.id} AND taxMasterId=$taxId';
      } else if (flagValue == 3) {
        query = 'SELECT COUNT(*) FROM ProductTaxes WHERE businessId=${_business.id} AND taxMasterId=$taxId';
      } else if (flagValue == 4) {
        query = 'SELECT COUNT(*) FROM PurchaseInvoiceDetailTaxes WHERE businessId=${_business.id} AND taxId=$taxId';
      } else if (flagValue == 5) {
        query = 'SELECT COUNT(*) FROM PurchaseInvoiceTaxes WHERE businessId=${_business.id} AND taxId=$taxId';
      }
      return Sqflite.firstIntValue(await dbClient.rawQuery(query));
    } catch (e) {
      print('Exception - productTypeDelete(): ' + e.toString());
      return null;
    }
  }

  Future<int> taxMasterUpdate(TaxMaster obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('TaxMasters', obj.toMap(), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - TaxMasterUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> taxMasterPercentageUpdate(int taxMasterId) async {
    try {
      var dbClient = await db;
      int result = await dbClient.update('TaxMastersPercentage', {"modifiedAt": DateTime.now().toString(), "businessId": global.business.id}, where: 'taxId=$taxMasterId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - taxMasterPercentageUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> unitCombinationDelete({int primaryUnitId, int combinationId}) async {
    try {
      var dbClient = await db;
      String query = 'DELETE FROM UnitCombinations WHERE';
      if (primaryUnitId != null) {
        query += ' primaryUnitId = $primaryUnitId';
      } else if (combinationId != null) {
        query += ' id = $combinationId';
      }
      int result = await dbClient.rawDelete(query);
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - unitCombinationDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<UnitCombination>> unitCombinationGetList({List<int> unitIdList, String searchString, bool isActive}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM UnitCombinations';

      if (unitIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' primaryUnitId IN (${unitIdList.toString().substring(1, (unitIdList.toString().length - 1))}) ';
      }

      if (isActive != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' isActive = \'$isActive\' ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => UnitCombination.fromMap(f)).toList();
    } catch (e) {
      print('Exception - unitCombinationGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> unitCombinationInsert(UnitCombination obj) async {
    try {
      var dbClient = await db;
      obj.isActive = true;
      obj.isDelete = false;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('UnitCombinations', obj.toMap());
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - unitCombinationInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> unitCombinationIsUsed(int unitCombinationId) async {
    try {
      var dbClient = await db;
      String query = 'SELECT COUNT(*) FROM Products WHERE unitCombinationId=$unitCombinationId';
      int _result = Sqflite.firstIntValue(await dbClient.rawQuery(query));
      if (_result == 0) {
        BusinessRule _br = BusinessRule();
        if (unitCombinationId == int.parse(_br.getSystemFlagValue(global.systemFlagNameList.defaultUnitCombination))) {
          _result++;
        }
      }
      return _result;
    } catch (e) {
      print('Exception - unitCombinationisUsed(): ' + e.toString());
      return null;
    }
  }

  Future<int> unitCombinationUpdate(UnitCombination obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('UnitCombinations', obj.toMap(), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - unitCombinationUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> unitDelete(int unitId) async {
    try {
      var dbClient = await db;
      int result = await dbClient.rawDelete('DELETE FROM Units WHERE id = $unitId');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - unitDelete(): ' + e.toString());
      return null;
    }
  }

  Future<List<Unit>> unitGetList({List<int> unitIdList, String searchString, bool isActive}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM Units';

      if (unitIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' id IN (${unitIdList.toString().substring(1, (unitIdList.toString().length - 1))}) ';
      }

      if (isActive != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' isActive = \'$isActive\' ';
      }

      if (searchString != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (name LIKE \'%$searchString%\' OR code LIKE \'%$searchString%\')';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => Unit.fromMap(f)).toList();
    } catch (e) {
      print('Exception - unitGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> unitInsert(Unit obj) async {
    try {
      var dbClient = await db;
      obj.isActive = true;
      obj.isDelete = false;
      obj.isMaster = true;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('Units', obj.toMap());
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - unitInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> unitIsUsed(int unitId) async {
    try {
      var dbClient = await db;
      String query = 'SELECT COUNT(*) FROM UnitCombinations WHERE primaryUnitId=$unitId OR secondaryUnitId=$unitId';
      return Sqflite.firstIntValue(await dbClient.rawQuery(query));
    } catch (e) {
      print('Exception - unitIsUsed(): ' + e.toString());
      return null;
    }
  }

  Future<bool> unitNameExist({String unitName, int unitId}) async {
    try {
      var dbClient = await db;
      String query = 'SELECT COUNT(*) FROM Units';

      if (unitId != null) {
        query += ' WHERE id!=\'$unitId\'';
      }

      if (unitName != null) {
        if (query.contains('WHERE')) {
          query += ' AND';
        } else {
          query += ' WHERE';
        }
        query += ' (lower(name)=\'$unitName\' OR upper(name)=\'$unitName\' OR name= \'$unitName\')';
      }

      var result = Sqflite.firstIntValue(await dbClient.rawQuery(query));
      return result == 1 ? true : false;
    } catch (e) {
      print('Exception - unitNameExist(): ' + e.toString());
      return null;
    }
  }

  Future<int> unitUpdate(Unit obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('Units', obj.toMap(), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - unitUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleOrderDetailUpdate(SaleOrderDetail obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('SaleOrderDetails', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleOrderDetailUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleQuoteDetailUpdate(SaleQuoteDetail obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('SaleQuoteDetails', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleQuoteDetailUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceDetailUpdate(SaleInvoiceDetail obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('SaleInvoiceDetails', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleInvoiceDetailUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> saleInvoiceReturnDetailUpdate(SaleInvoiceReturnDetail obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('SaleInvoiceReturnDetails', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - saleInvoiceReturnDetailUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceDetailUpdate(PurchaseInvoiceDetail obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('PurchaseInvoiceDetails', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - purchaseInvoiceDetailUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> purchaseInvoiceReturnDetailUpdate(PurchaseInvoiceReturnDetail obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('PurchaseInvoiceReturnDetails', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - purchaseInvoiceReturnDetailUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> userDelete() async {
    try {
      var dbClient = await db;
      return await dbClient.rawDelete('DELETE FROM Users');
    } catch (e) {
      print('Exception - userDelete(): ' + e.toString());
      return null;
    }
  }

  Future<User> userGetList() async //get no.of records from AppUsers Table //appUserGetCount
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM Users';
      if (_business != null) {
        query += ' WHERE businessId=${_business.id}';
      }
      var result = await dbClient.rawQuery(query);
      if (result.isNotEmpty) {
        List<User> users = result.map((f) => User.fromMap(f)).toList();
        return (users.length > 0) ? users[0] : null;
      }
    } catch (e) {
      print('Exception - userGetList(): ' + e.toString());
    }
    return null;
  }

  Future<int> userInsert(User obj) async // insertion in AppUsers Table //appUsersCreateUser
  {
    try {
      var dbClient = await db;
      obj.isActive = true;
      obj.isDelete = false;
      obj.isTermAgreed = true;
      obj.isLogin = true;
      obj.businessId = null;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('Users', obj.toMap(true));
      return obj.id;
    } catch (e) {
      print('Exception - userInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> userUpdate(User obj) async {
    //update in AppUsers Table //appUsersUpdate
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('Users', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - userUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<List<EmployeeSalaryStructures>> employeeSalaryStructuresGetLastRecord({List<int> accountId, int startIndex, int fetchRecords, String orderBy}) async //display list of product type from ProductTypes Table //productTypeDisplayProductType
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM EmployeeSalaryStructures';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 'accountId IN (${accountId.toString().substring(1, (accountId.toString().length - 1))})';
      }
      if (orderBy != null) {
        query += '  ORDER BY id $orderBy';
      }

      query += ' LIMIT 1 ';

      var result = await dbClient.rawQuery(query);
      return result.map((f) => EmployeeSalaryStructures.fromMap(f)).toList();
    } catch (e) {
      print('Exception - employeeSalaryStructuresGetLastRecord(): ' + e.toString());
      return null;
    }
  }

  Future<int> attendanceInsert(Attendance obj) async //insertion in SaleInvoiceDetail Table //invoiceDetailCreateInvoiceDetail
  {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.isDelete = false;
      obj.id = await dbClient.insert('Attendance', obj.toMap(true));
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - attendanceInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> attendanceUpdate(Attendance obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('Attendance', obj.toMap(false), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - attendanceUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> attendanceExist(String attendanceDate) async //get no.of customers from Account Table //accountGetCount
  {
    try {
      var dbClient = await db;
      String query = 'SELECT COUNT(*) FROM Attendance WHERE businessId=${_business.id} AND attendanceDate = \'$attendanceDate\'';
      int value = Sqflite.firstIntValue(await dbClient.rawQuery(query));
      return value;
    } catch (e) {
      print('Exception - attendanceExist(): ' + e.toString());
      return null;
    }
  }

  Future<List<Attendance>> attendanceGetList({List<int> accountId, int startIndex, int fetchRecords, DateTime attendanceDate, DateTime atdDate, String orderBy}) async //display list of product type from ProductTypes Table //productTypeDisplayProductType
  {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.namePrefix,t2.firstName,t2.middleName,t2.lastName,t2.nameSuffix,t2.accountType FROM Attendance t1 INNER JOIN Accounts t2 ON t1.accountId = t2.id';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (atdDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 't1.attendanceDate IN ($atdDate)';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 't1.accountId IN (${accountId.toString().substring(1, (accountId.toString().length - 1))})';
      }
      if (attendanceDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.attendanceDate LIKE \'%${attendanceDate.toString().substring(0, 10)}%\'';
      }

      query += ' GROUP By t1.attendanceDate';

      if (orderBy != null) {
        query += '  ORDER BY t1.attendanceDate $orderBy';
      }

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => Attendance.fromMap(f)).toList();
    } catch (e) {
      print('Exception - attendanceGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<Attendance>> attendanceWithoutGrpBtGetList({List<int> accountId, int startIndex, int fetchRecords, String atdDate, String orderBy}) async //display list of product type from ProductTypes Table //productTypeDisplayProductType
  {
    try {
      var dbClient = await db;
      String query = 'SELECT t1.*,t2.namePrefix,t2.firstName,t2.middleName,t2.lastName,t2.nameSuffix,t2.accountType FROM Attendance t1 INNER JOIN Accounts t2 ON t1.accountId = t2.id';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' t1.businessId = ${_business.id}';
      }

      if (atdDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 't1.attendanceDate LIKE \'%$atdDate%\'';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 't1.accountId IN (${accountId.toString().substring(1, (accountId.toString().length - 1))})';
      }

      if (orderBy != null) {
        query += '  ORDER BY t1.attendanceDate $orderBy';
      }

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => Attendance.fromMap(f)).toList();
    } catch (e) {
      print('Exception - attendanceWithoutGrpBtGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> attendDanceDelete({int aid, String atdDate}) async //delete payment invoice from PaymentSaleSaleInvoices Table //paymentInvoiceDeletePaymentSaleInvoices
  {
    try {
      var dbClient = await db;
      int result;
      if (atdDate != null) {
        result = await dbClient.delete('Attendance', where: 'attendanceDate LIKE \'%$atdDate%\'');
      } else if (aid != null) {
        result = await dbClient.delete('Attendance', where: 'id=$aid');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - attendDanceDelete(): ' + e.toString());
    }
    return null;
  }

  Future<int> employeeSalaryInsert(EmployeeSalary obj) async //insertion in SaleInvoiceDetail Table //invoiceDetailCreateInvoiceDetail
  {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.isDelete = false;
      obj.id = await dbClient.insert('EmployeeSalaries', obj.toMap());
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - employeeSalaryInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> employeeSalaryUpdate(EmployeeSalary obj) async {
    try {
      var dbClient = await db;
      obj.modifiedAt = DateTime.now();
      int result = await dbClient.update('EmployeeSalaries', obj.toMap(), where: 'id=${obj.id}');
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - employeeSalaryUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<int> employeeSalaryDelete({int id, String atdDate, List<int> accountIdList}) async //delete payment invoice from PaymentSaleSaleInvoices Table //paymentInvoiceDeletePaymentSaleInvoices
  {
    try {
      var dbClient = await db;
      int result;
      if (atdDate != null) {
        result = await dbClient.delete('EmployeeSalaries', where: 'createdAt LIKE \'%$atdDate%\'');
      } else if (id != null) {
        result = await dbClient.delete('EmployeeSalaries', where: 'id=$id');
      } else if (accountIdList != null) {
        result = await dbClient.delete('EmployeeSalaries', where: 'accountId IN (${accountIdList.toString().substring(1, (accountIdList.toString().length - 1))})');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - employeeSalaryDelete(): ' + e.toString());
    }
    return null;
  }

  Future<int> employeeSalaryStatusUpdate({int empSalId}) async {
    try {
      var dbClient = await db;
      int result;
      if (empSalId != null) {
        result = await dbClient.rawUpdate('update EmployeeSalaries set status = "Paid" where id =$empSalId');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - employeeSalaryStatusUpdate(): ' + e.toString());
      return null;
    }
  }

  Future<List<EmployeeSalary>> employeeSalaryGetList({List<int> accountId, int startIndex, String withoutPaid, String isAdvance, int fetchRecords, String status, String orderBy}) async //display list of product type from ProductTypes Table //productTypeDisplayProductType
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM EmployeeSalaries';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 'accountId IN (${accountId.toString().substring(1, (accountId.toString().length - 1))})';
      }

      if (withoutPaid != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' status != \'$withoutPaid\' ';
      }

      if (status != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' status = \'$status\' ';
      }
      query += ' GROUP By id';
      if (orderBy != null) {
        query += '  ORDER BY modifiedAt $orderBy';
      }

      query += ' LIMIT 1 ';
      // if (startIndex != null && fetchRecords != null) {
      //   query += ' LIMIT $startIndex, $fetchRecords ';
      // }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => EmployeeSalary.fromMap(f)).toList();
    } catch (e) {
      print('Exception - employeeSalaryGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<EmployeeSalary>> employeeSalaryAmountGetList({List<int> accountId, int startIndex, String withoutPaid, int fetchRecords, String status, String orderBy}) async //display list of product type from ProductTypes Table //productTypeDisplayProductType
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM EmployeeSalaries';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 'accountId IN (${accountId.toString().substring(1, (accountId.toString().length - 1))})';
      }

      if (withoutPaid != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' status != \'$withoutPaid\' ';
      }

      if (status != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' status = \'$status\' ';
      }
      if (orderBy != null) {
        query += '  ORDER BY modifiedAt $orderBy';
      }

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => EmployeeSalary.fromMap(f)).toList();
    } catch (e) {
      print('Exception - employeeSalaryAmountGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<EmployeeSalaryPayment>> employeeSalaryPaymentGetList({List<int> accountId, int startIndex, String isAdvance, int fetchRecords, DateTime startDate, DateTime endDate, String status, String orderBy}) async //display list of product type from ProductTypes Table //productTypeDisplayProductType
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM EmployeeSalaryPayments';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 'accountId IN (${accountId.toString().substring(1, (accountId.toString().length - 1))})';
      }

      if (isAdvance != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' isAdvanced = \'$isAdvance\' ';
      }
      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (transactionDate >= \'$startDate\' AND transactionDate <= \'$endDate\') ';
      }

      if (orderBy != null) {
        query += '  ORDER BY id $orderBy';
      }

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => EmployeeSalaryPayment.fromMap(f)).toList();
    } catch (e) {
      print('Exception - employeeSalaryPaymentGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> employeeSalaryPaymentsInsert(EmployeeSalaryPayment obj) async //insertion in SaleInvoiceDetail Table //invoiceDetailCreateInvoiceDetail
  {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.isDelete = false;
      obj.id = await dbClient.insert('EmployeeSalaryPayments', obj.toMap());
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - employeeSalaryPaymentsInsert(): ' + e.toString());
      return null;
    }
  }

  Future<List<EmployeeSalaryStructures>> employeeSalaryStructuresGetList({List<int> accountId, int startIndex, int fetchRecords, String orderBy}) async //display list of product type from ProductTypes Table //productTypeDisplayProductType
  {
    try {
      var dbClient = await db;
      String query = 'SELECT * FROM EmployeeSalaryStructures';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 'accountId IN (${accountId.toString().substring(1, (accountId.toString().length - 1))})';
      }
      if (orderBy != null) {
        query += '  ORDER BY startDate $orderBy';
      }

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords ';
      }

      var result = await dbClient.rawQuery(query);
      return result.map((f) => EmployeeSalaryStructures.fromMap(f)).toList();
    } catch (e) {
      print('Exception - employeeSalaryStructuresGetList(): ' + e.toString());
      return null;
    }
  }

  Future<int> employeeSalaryStructuresInsert(EmployeeSalaryStructures obj) async //insertion in SaleInvoiceDetail Table //invoiceDetailCreateInvoiceDetail
  {
    try {
      var dbClient = await db;
      obj.businessId = _business.id;
      obj.createdAt = DateTime.now();
      obj.modifiedAt = DateTime.now();
      obj.id = await dbClient.insert('EmployeeSalaryStructures', obj.toMap());
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return obj.id;
    } catch (e) {
      print('Exception - employeeSalaryStructuresInsert(): ' + e.toString());
      return null;
    }
  }

  Future<int> employeeSalaryStructuresDelete({List<int> accountIdList, int empStId}) async //delete payment invoice from PaymentSaleSaleInvoices Table //paymentInvoiceDeletePaymentSaleInvoices
  {
    try {
      var dbClient = await db;
      int result;
      if (empStId != null) {
        result = await dbClient.delete('EmployeeSalaryStructures', where: 'id=$empStId');
      } else if (accountIdList != null) {
        result = await dbClient.delete('EmployeeSalaryStructures', where: 'accountId IN (${accountIdList.toString().substring(1, (accountIdList.toString().length - 1))})');
      }
      await systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'true');
      return result;
    } catch (e) {
      print('Exception - employeeSalaryStructuresDelete(): ' + e.toString());
    }
    return null;
  }

  Future<List<Payment>> paymentGetLastList({int startIndex, int fetchRecords, List<int> paymentIdList, int accountId, DateTime startDate, DateTime endDate, bool isCancel, bool isDelete, String accountCode, String invoiceno, String paymentType, String orderBy}) async //display list of payment from Payments Table //paymentDisplayPayment
  {
    try {
      var dbClient = await db;

      String query = 'SELECT * FROM Payments';

      if (_business != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE';
        } else {
          query += ' AND';
        }
        query += ' businessId = ${_business.id}';
      }
      if (paymentIdList != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' id IN (${paymentIdList.toString().substring(1, (paymentIdList.toString().length - 1))})';
      }

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' accountId = $accountId ';
      }

      if (paymentType != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' paymentType = \'$paymentType\'';
      }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' (transactionDate >= \'$startDate\' AND transactionDate <= \'$endDate\') ';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' transactionDate >= \'$startDate\' ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' transactionDate <= \'$endDate\' ';
      }

      if (isCancel != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' isCancel = \'$isCancel\' ';
      }

      if (isDelete != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' isDelete = \'$isDelete\' ';
      } else {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' isDelete = \'false\' ';
      }

      if (orderBy != null) {
        query += ' ORDER BY transactionDate $orderBy';
      }

      if (startIndex != null && fetchRecords != null) {
        query += ' LIMIT $startIndex, $fetchRecords ';
      }
      //  print(query);
      var result = await dbClient.rawQuery(query);
      //   print(result);
      return result.map((f) => Payment.fromMap(f)).toList();
    } catch (e) {
      print('Exception - paymentGetList(): ' + e.toString());
      return null;
    }
  }

  Future<List<BuisnessStatementGraph>> buissnesGraphGetWeekDataDebit({DateTime startDate, DateTime endDate, bool isCancel, String paymentType, String orderBy, int accountId}) async //display list of payment from Payments Table //paymentDisplayPayment
  {
    try {
      var dbClient = await db;
      String query = 'WITH RECURSIVE dates(date) AS ( ' + ' VALUES(date(\'$startDate\'))' + ' UNION ALL' + ' SELECT date(date, \'+1 day\')' + ' FROM dates' + ' WHERE date < date(\'$endDate\'))' + ' SELECT date AS transactionDate, SUM(IFNULL(t1.amount, 0)) AS totalDebit FROM dates LEFT JOIN payments t1 ON date(t1.transactionDate) = date';

      //  String query = "select  sum(amount) as totalCredit, transactionDate from payments  WHERE paymentType = 'RECEIVED'  ";
      query += ' AND t1.paymentType = \'GIVEN\'';

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += '(date(t1.transactionDate) >= date(\'$startDate\') AND date(t1.transactionDate) <= date(\'$endDate\'))';
      }
      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.accountId = $accountId ';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 'date(t1.transactionDate) >= date(\'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(t1.transactionDate) >= date(\'$endDate\')';
      }

      query += ' GROUP BY strftime("%W",date) ORDER BY date ';
      // query += ' GROUP BY date';

      // if (orderBy != null) {
      //   query += ' ORDER BY  date $orderBy';
      // }
      //  print(query);
      var result = await dbClient.rawQuery(query);
      //   print(result);
      return result.map((f) => BuisnessStatementGraph.fromMap(f)).toList();
    } catch (e) {
      print('Exception - BuisnessStatementGraph(): ' + e.toString());
      return null;
    }
  }

  Future<List<BuisnessStatementGraph>> buissnesGraphGetWeekDataCredit({DateTime startDate, DateTime endDate, bool isCancel, String paymentType, String orderBy, int accountId}) async //display list of payment from Payments Table //paymentDisplayPayment
  {
    try {
      var dbClient = await db;
      String query = 'WITH RECURSIVE dates(date) AS ( ' + ' VALUES(date(\'$startDate\'))' + ' UNION ALL' + ' SELECT date(date, \'+1 day\')' + ' FROM dates' + ' WHERE date < date(\'$endDate\'))' + ' SELECT date AS transactionDate, SUM(IFNULL(t1.amount, 0)) AS totalCredit FROM dates LEFT JOIN payments t1 ON date(t1.transactionDate) = date';

      //  String query = "select  sum(amount) as totalCredit, transactionDate from payments  WHERE paymentType = 'RECEIVED'  ";
      query += ' AND t1.paymentType = \'RECEIVED\'';

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' t1.accountId = $accountId ';
      }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += '(date(t1.transactionDate) >= date(\'$startDate\') AND date(t1.transactionDate) <= date(\'$endDate\'))';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 'date(t1.transactionDate) >= date(\'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(t1.transactionDate) >= date(\'$endDate\')';
      }

      query += ' GROUP BY strftime("%W",date) ORDER BY date ';
      // query += ' GROUP BY date';

      // if (orderBy != null) {
      //   query += ' ORDER BY  date $orderBy';
      // }
      //  print(query);
      var result = await dbClient.rawQuery(query);
      //   print(result);
      return result.map((f) => BuisnessStatementGraph.fromMap(f)).toList();
    } catch (e) {
      print('Exception - BuisnessStatementGraph(): ' + e.toString());
      return null;
    }
  }

  Future<List<BuisnessStatementGraph>> buissnesGraphGetMonthDataDebit({DateTime startDate, DateTime endDate, bool isCancel, String paymentType, String orderBy, int accountId}) async //display list of payment from Payments Table //paymentDisplayPayment
  {
    try {
      var dbClient = await db;
      String query = 'WITH RECURSIVE dates(date) AS ( ' + ' VALUES(date(\'$startDate\'))' + ' UNION ALL' + ' SELECT date(date, \'+1 day\')' + ' FROM dates' + ' WHERE date < date(\'$endDate\'))' + ' SELECT date AS transactionDate, SUM(IFNULL(t1.amount, 0)) AS totalDebit FROM dates LEFT JOIN payments t1 ON date(t1.transactionDate) = date';

      //  String query = "select  sum(amount) as totalCredit, transactionDate from payments  WHERE paymentType = 'RECEIVED'  ";
      query += ' AND t1.paymentType = \'GIVEN\'';

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += '(date(t1.transactionDate) >= date(\'$startDate\') AND date(t1.transactionDate) <= date(\'$endDate\'))';
      }
      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' accountId = $accountId ';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 'date(t1.transactionDate) >= date(\'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(t1.transactionDate) >= date(\'$endDate\')';
      }

      query += ' GROUP BY strftime("%m - %Y",date) ORDER BY date ';
      // query += ' GROUP BY date';

      // if (orderBy != null) {
      //   query += ' ORDER BY  date $orderBy';
      // }
      //  print(query);
      var result = await dbClient.rawQuery(query);
      //   print(result);
      return result.map((f) => BuisnessStatementGraph.fromMap(f)).toList();
    } catch (e) {
      print('Exception - BuisnessStatementGraph(): ' + e.toString());
      return null;
    }
  }

  Future<List<BuisnessStatementGraph>> buissnesGraphGetMonthDataCredit({DateTime startDate, DateTime endDate, bool isCancel, String paymentType, String orderBy, int accountId}) async //display list of payment from Payments Table //paymentDisplayPayment
  {
    try {
      var dbClient = await db;
      String query = 'WITH RECURSIVE dates(date) AS ( ' + ' VALUES(date(\'$startDate\'))' + ' UNION ALL' + ' SELECT date(date, \'+1 day\')' + ' FROM dates' + ' WHERE date < date(\'$endDate\'))' + ' SELECT date AS transactionDate, SUM(IFNULL(t1.amount, 0)) AS totalCredit FROM dates LEFT JOIN payments t1 ON date(t1.transactionDate) = date';

      //  String query = "select  sum(amount) as totalCredit, transactionDate from payments  WHERE paymentType = 'RECEIVED'  ";
      query += ' AND t1.paymentType = \'RECEIVED\'';

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' accountId = $accountId ';
      }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += '(date(t1.transactionDate) >= date(\'$startDate\') AND date(t1.transactionDate) <= date(\'$endDate\'))';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 'date(t1.transactionDate) >= date(\'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(t1.transactionDate) >= date(\'$endDate\')';
      }

      query += ' GROUP BY strftime("%m - %Y",date) ORDER BY date ';
      // query += ' GROUP BY date';

      // if (orderBy != null) {
      //   query += ' ORDER BY  date $orderBy';
      // }
      //  print(query);
      var result = await dbClient.rawQuery(query);
      //   print(result);
      return result.map((f) => BuisnessStatementGraph.fromMap(f)).toList();
    } catch (e) {
      print('Exception - BuisnessStatementGraph(): ' + e.toString());
      return null;
    }
  }

  Future<List<BuisnessStatementGraph>> buissnesGraphGetDataDebit({DateTime startDate, DateTime endDate, bool isCancel, String paymentType, String orderBy, int accountId}) async //display list of payment from Payments Table //paymentDisplayPayment
  {
    try {
      var dbClient = await db;
      String query = 'WITH RECURSIVE dates(date) AS ( ' + ' VALUES(date(\'$startDate\'))' + ' UNION ALL' + ' SELECT date(date, \'+1 day\')' + ' FROM dates' + ' WHERE date < date(\'$endDate\'))' + ' SELECT date AS transactionDate, SUM(IFNULL(t1.amount, 0)) AS totalDebit FROM dates LEFT JOIN payments t1 ON date(t1.transactionDate) = date';

      //  String query = "select  sum(amount) as totalCredit, transactionDate from payments  WHERE paymentType = 'RECEIVED'  ";
      query += ' AND  t1.paymentType = \'GIVEN\' ';

      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' accountId = $accountId ';
      }

      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += '(date(t1.transactionDate) >= date(\'$startDate\') AND date(t1.transactionDate) <= date(\'$endDate\'))';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(t1.transactionDate) >= date(\'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(t1.transactionDate) <= date(\'$endDate\') ';
      }

      query += ' GROUP BY strftime("%w" ,date)';

      if (orderBy != null) {
        query += ' ORDER BY  date $orderBy';
      }
      //  print(query);
      var result = await dbClient.rawQuery(query);
      //   print(result);
      return result.map((f) => BuisnessStatementGraph.fromMap(f)).toList();
    } catch (e) {
      print('Exception - BuisnessStatementGraph(): ' + e.toString());
      return null;
    }
  }

  Future<List<BuisnessStatementGraph>> buissnesGraphGetDataCredit({DateTime startDate, DateTime endDate, bool isCancel, String paymentType, String orderBy, int accountId}) async //display list of payment from Payments Table //paymentDisplayPayment
  {
    try {
      var dbClient = await db;
      String query = 'WITH RECURSIVE dates(date) AS ( ' + ' VALUES(date(\'$startDate\'))' + ' UNION ALL' + ' SELECT date(date, \'+1 day\')' + ' FROM dates' + ' WHERE date < date(\'$endDate\'))' + ' SELECT date AS transactionDate, SUM(IFNULL(t1.amount, 0)) AS totalCredit FROM dates LEFT JOIN payments t1 ON date(t1.transactionDate) = date';

      //  String query = "select  sum(amount) as totalCredit, transactionDate from payments  WHERE paymentType = 'RECEIVED'  ";

      query += ' AND t1.paymentType = \'RECEIVED\'';
      // if (paymentType != null) {
      //   if (!query.contains('WHERE')) {
      //     query += ' WHERE ';
      //   } else {
      //     query += ' AND ';
      //   }
      //   query += ' t1.paymentType = \'$paymentType\'';
      // }
      if (accountId != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' accountId = $accountId ';
      }
      if (startDate != null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }

        query += '(date(t1.transactionDate) >= date(\'$startDate\') AND date(t1.transactionDate) <= date(\'$endDate\'))';
      }

      if (startDate != null && endDate == null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += 'date(t1.transactionDate) >= date(\'$startDate\') ';
      }

      if (startDate == null && endDate != null) {
        if (!query.contains('WHERE')) {
          query += ' WHERE ';
        } else {
          query += ' AND ';
        }
        query += ' date(t1.transactionDate) >= date(\'$endDate\')';
      }

      query += 'GROUP BY strftime("%w" ,date)';

      if (orderBy != null) {
        query += ' ORDER BY  date $orderBy';
      }
      //  print(query);
      var result = await dbClient.rawQuery(query);
      //   print(result);
      return result.map((f) => BuisnessStatementGraph.fromMap(f)).toList();
    } catch (e) {
      print('Exception - BuisnessStatementGraph(): ' + e.toString());
      return null;
    }
  }

  String _dateInString(DateTime _date) // it will return in yyyy-MM-dd
  {
    try {
      return DateFormat('yyyy-MM-dd').format(_date);
    } catch (e) {
      print('Exception - _dateInString(): ' + e.toString());
      return '';
    }
  }
}
