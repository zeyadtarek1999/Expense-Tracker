import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SqlDatabase {
  static final SqlDatabase _i = SqlDatabase._();
  factory SqlDatabase() => _i;
  SqlDatabase._();

  static Database? _database;

  static const int _dbVersion = 3;

  static const String tableExpenses = 'expenses';
  static const String colId = 'id';
  static const String colCategory = 'category';
  static const String colAmount = 'amount';
  static const String colDate = 'date';
  static const String colReceipt = 'receipt';
  static const String colType = 'type';

  static const String typeIncome = 'income';
  static const String typeExpense = 'expense';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _init();
    return _database!;
  }

  Future<Database> _init() async {
    return openDatabase(
      'Database.db',
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE TableName (id INTEGER PRIMARY KEY, name TEXT, phone TEXT, score INTEGER, date TEXT)',
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableExpenses (
        $colId       INTEGER PRIMARY KEY AUTOINCREMENT,
        $colCategory TEXT    NOT NULL,
        $colAmount   REAL    NOT NULL,
        $colDate     TEXT    NOT NULL,
        $colReceipt  TEXT,
        $colType     TEXT    NOT NULL CHECK($colType IN ('$typeIncome', '$typeExpense')) DEFAULT '$typeExpense'
      )
    ''');

    await db.execute('CREATE INDEX IF NOT EXISTS idx_${tableExpenses}_date ON $tableExpenses ($colDate DESC, $colId DESC)');

    debugPrint('DB created with tables: TableName, $tableExpenses (v$version)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableExpenses (
          $colId       INTEGER PRIMARY KEY AUTOINCREMENT,
          $colCategory TEXT    NOT NULL,
          $colAmount   REAL    NOT NULL,
          $colDate     TEXT    NOT NULL,
          $colReceipt  TEXT
        )
      ''');
    }

    if (oldVersion < 3) {
      try {
        await db.execute("ALTER TABLE $tableExpenses ADD COLUMN $colType TEXT NOT NULL DEFAULT '$typeExpense'");
      } catch (_) {}

      try {
        await db.execute('''
          UPDATE $tableExpenses
          SET $colType = CASE
            WHEN $colAmount >= 0 THEN '$typeIncome'
            ELSE '$typeExpense'
          END
        ''');
      } catch (_) {}

      await db.execute('CREATE INDEX IF NOT EXISTS idx_${tableExpenses}_date ON $tableExpenses ($colDate DESC, $colId DESC)');
    }

    debugPrint('DB upgraded from v$oldVersion to v$newVersion');
  }

  Future<List<Map<String, Object?>>> read(String sql, [List<Object?>? args]) async {
    final db = await database;
    return db.rawQuery(sql, args);
  }

  Future<int> insert(String table, Map<String, Object?> values) async {
    final db = await database;
    return db.insert(table, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(
      String table,
      Map<String, Object?> values, {
        String? where,
        List<Object?>? whereArgs,
      }) async {
    final db = await database;
    return db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(
      String table, {
        String? where,
        List<Object?>? whereArgs,
      }) async {
    final db = await database;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<int> insertExpense({
    required String category,
    required double amount,
    required DateTime date,
    String? receipt,
    required bool isIncome,
  }) async {
    final db = await database;
    final signed = isIncome ? amount.abs() : -amount.abs();
    final map = <String, Object?>{
      colCategory: category,
      colAmount: signed,
      colDate: date.toIso8601String(),
      colReceipt: receipt,
      colType: isIncome ? typeIncome : typeExpense,
    };
    return db.insert(tableExpenses, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertExpenseMap(Map<String, Object?> values) async {
    final db = await database;
    return db.insert(tableExpenses, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, Object?>>> getRecentExpenses({int limit = 50}) async {
    final db = await database;
    return db.query(
      tableExpenses,
      orderBy: '$colDate DESC, $colId DESC',
      limit: limit,
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return db.delete(tableExpenses, where: '$colId = ?', whereArgs: [id]);
  }

  Future<double> totalIncome() async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT COALESCE(SUM(CASE WHEN $colType = '$typeIncome' THEN $colAmount ELSE 0 END), 0.0) AS total
      FROM $tableExpenses
    ''');
    return (res.first['total'] as num).toDouble();
  }

  Future<double> totalExpensesAbs() async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT COALESCE(SUM(CASE WHEN $colType = '$typeExpense' THEN ABS($colAmount) ELSE 0 END), 0.0) AS total
      FROM $tableExpenses
    ''');
    return (res.first['total'] as num).toDouble();
  }

  Future<List<Map<String, Object?>>> getByType({
    required bool isIncome,
    int limit = 50,
  }) async {
    final db = await database;
    return db.query(
      tableExpenses,
      where: '$colType = ?',
      whereArgs: [isIncome ? typeIncome : typeExpense],
      orderBy: '$colDate DESC, $colId DESC',
      limit: limit,
    );
  }
}
