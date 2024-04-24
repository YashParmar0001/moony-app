import 'dart:developer' as dev;

import 'package:moony_app/core/data/initial_data.dart';
import 'package:moony_app/model/category.dart';
import 'package:moony_app/model/category_icon.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:moony_app/model/transaction.dart' as t;

class SqliteService {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'moony_database.db'),
      onCreate: (database, version) async {
        dev.log('Initializing the database', name: 'Database');
        await database.execute(
          "CREATE TABLE transactions ("
          "tran_id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "money INTEGER, "
          "category_id INTEGER, "
          "note TEXT, "
          "date INTEGER"
          ")",
        );
        await database.execute(
          "CREATE TABLE category ("
          "category_id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "is_income INTEGER, "
          "name TEXT, "
          "icon_id INTEGER"
          ")",
        );
        await database.execute(
          "CREATE TABLE category_icon ("
          "icon_id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "icon_category TEXT, "
          "icon TEXT"
          ")",
        );
        await populateCategories(database);
      },
      version: 1,
    );
  }

  Future<int> addTransaction(t.Transaction transaction) async {
    final Database db = await initializeDB();
    final id = await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    dev.log('Inserted transaction: $id', name: 'Transaction');
    return id;
  }

  Future<int> deleteTransaction(int id) async {
    final Database db = await initializeDB();
    final response = db.delete(
      'transactions',
      where: 'tran_id == ?',
      whereArgs: [id],
    );
    return response;
  }

  Future<int> updateTransaction(t.Transaction transaction) async {
    dev.log('Update transaction: $transaction', name: 'Transaction');
    final Database db = await initializeDB();
    final id = await db.update(
      'transactions',
      transaction.toMap(),
      where: 'tran_id = ?',
      whereArgs: [transaction.id],
    );
    dev.log('Updated transaction: $id', name: 'Transaction');
    return id;
  }

  Future<int> addCategory(Category category) async {
    final Database db = await initializeDB();
    final id = await db.insert(
      'category',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    dev.log('Inserted category: $id', name: 'Category');
    return id;
  }

  Future<int> addIcon(CategoryIcon icon) async {
    final Database db = await initializeDB();
    final id = await db.insert(
      'category_icon',
      icon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    dev.log('Inserted icon: $id', name: 'Icon');
    return id;
  }

  Future<List<t.Transaction>> getTransactions(DateTime date) async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from transactions '
      'join category on transactions.category_id = category.category_id '
      'join category_icon on category.icon_id = category_icon.icon_id '
      'where strftime("%m", datetime(date / 1000, "unixepoch")) = "${date.month.toString().padLeft(2, '0')}" '
      'and strftime("%Y", datetime(date / 1000, "unixepoch")) = "${date.year}"',
    );
    // dev.log('Result: $queryResult', name: 'Transaction');
    final list = queryResult.map((e) {
      final map = {
        'tran_id': e['tran_id'],
        'money': e['money'],
        'category': {
          'category_id': e['category_id'],
          'is_income': e['is_income'],
          'name': e['name'],
          'icon': {
            'icon_id': e['icon_id'],
            'icon_category': e['icon_category'],
            'icon': e['icon'],
          },
        },
        'note': e['note'],
        'date': e['date'],
      };
      // dev.log('Map: $map', name: 'Transaction');
      return t.Transaction.fromMap(map);
    }).toList();
    // dev.log('Final result: $list', name: 'Transaction');
    return list;
  }

  Future<List<Category>> getCategories() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from category '
      'join category_icon on category.icon_id = category_icon.icon_id',
    );
    dev.log('Result: $queryResult', name: 'Category');
    final list = queryResult.map((e) {
      final map = {
        'category_id': e['category_id'],
        'is_income': e['is_income'],
        'name': e['name'],
        'icon': {
          'icon_id': e['icon_id'],
          'icon_category': e['icon_category'],
          'icon': e['icon'],
        },
      };
      return Category.fromMap(map);
    }).toList();
    return list;
  }

  Future<List<CategoryIcon>> getIcons() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'category_icon',
    );
    dev.log('Result: $queryResult', name: 'Icons');
    final list = queryResult.map((e) {
      final map = {
        'icon_id': e['icon_id'],
        'icon_category': e['icon_category'],
        'icon': e['icon'],
      };
      return CategoryIcon.fromMap(map);
    }).toList();
    dev.log('Final result: $list', name: 'Icons');
    return list;
  }

  Future<void> populateCategories(Database db) async {
    dev.log('Populating the categories', name: 'Database');
    for (Category category in InitialData.categories) {
      // Insert the icon first and get id
      final iconId = await db.insert(
        'category_icon',
        category.icon.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (iconId == 0) continue;
      category = category.copyWith(
        icon: category.icon.copyWith(
          id: iconId,
        ),
      );
      // Insert the category
      final categoryId = await db.insert(
        'category',
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}