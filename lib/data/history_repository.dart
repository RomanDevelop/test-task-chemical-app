import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/calculation_record.dart';
import '../models/lsi_parameters.dart';
import '../models/lsi_result.dart';

class HistoryRepository {
  static const _dbName = 'history.db';
  static const _table = 'calculations';
  Database? _db;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final file = p.join(dbPath, _dbName);
    _db = await openDatabase(
      file,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            createdAt INTEGER NOT NULL,
            params TEXT NOT NULL,
            resultCurrent REAL NOT NULL,
            resultDesired REAL NOT NULL,
            phCeilingCurrent REAL,
            phCeilingDesired REAL
          )
        ''');
      },
    );
  }

  Future<List<CalculationRecord>> loadAll({int limit = 100}) async {
    final db = _ensureDb();
    final rows = await db.query(_table, orderBy: 'createdAt DESC', limit: limit);
    return rows.map(_fromRow).toList();
  }

  Future<void> insert(CalculationRecord record) async {
    final db = _ensureDb();
    await db.insert(_table, _toRow(record));
  }

  Future<void> clear() async {
    final db = _ensureDb();
    await db.delete(_table);
  }

  Map<String, Object?> _toRow(CalculationRecord r) {
    return {
      'createdAt': r.createdAt.millisecondsSinceEpoch,
      'params': jsonEncode(r.parameters.toJson()),
      'resultCurrent': r.result.current,
      'resultDesired': r.result.desired,
      'phCeilingCurrent': r.result.phCeilingCurrent,
      'phCeilingDesired': r.result.phCeilingDesired,
    };
  }

  CalculationRecord _fromRow(Map<String, Object?> row) {
    final params = LSIParameters.fromJson(jsonDecode(row['params'] as String) as Map<String, dynamic>);
    final result = LSIResult(
      current: (row['resultCurrent'] as num).toDouble(),
      desired: (row['resultDesired'] as num).toDouble(),
      phCeilingCurrent: row['phCeilingCurrent'] == null ? null : (row['phCeilingCurrent'] as num).toDouble(),
      phCeilingDesired: row['phCeilingDesired'] == null ? null : (row['phCeilingDesired'] as num).toDouble(),
    );
    return CalculationRecord(
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int),
      parameters: params,
      result: result,
    );
  }

  Database _ensureDb() {
    final db = _db;
    if (db == null) {
      throw StateError('HistoryRepository not initialized');
    }
    return db;
  }
}
