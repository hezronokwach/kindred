/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:kindred_butler_server/src/generated/protocol.dart' as _i2;

abstract class Shortcut
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Shortcut._({
    this.id,
    required this.triggerPhrase,
    required this.actions,
    this.description,
    required this.createdAt,
  });

  factory Shortcut({
    int? id,
    required String triggerPhrase,
    required List<String> actions,
    String? description,
    required DateTime createdAt,
  }) = _ShortcutImpl;

  factory Shortcut.fromJson(Map<String, dynamic> jsonSerialization) {
    return Shortcut(
      id: jsonSerialization['id'] as int?,
      triggerPhrase: jsonSerialization['triggerPhrase'] as String,
      actions: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['actions'],
      ),
      description: jsonSerialization['description'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = ShortcutTable();

  static const db = ShortcutRepository._();

  @override
  int? id;

  String triggerPhrase;

  List<String> actions;

  String? description;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Shortcut]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Shortcut copyWith({
    int? id,
    String? triggerPhrase,
    List<String>? actions,
    String? description,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Shortcut',
      if (id != null) 'id': id,
      'triggerPhrase': triggerPhrase,
      'actions': actions.toJson(),
      if (description != null) 'description': description,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Shortcut',
      if (id != null) 'id': id,
      'triggerPhrase': triggerPhrase,
      'actions': actions.toJson(),
      if (description != null) 'description': description,
      'createdAt': createdAt.toJson(),
    };
  }

  static ShortcutInclude include() {
    return ShortcutInclude._();
  }

  static ShortcutIncludeList includeList({
    _i1.WhereExpressionBuilder<ShortcutTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShortcutTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShortcutTable>? orderByList,
    ShortcutInclude? include,
  }) {
    return ShortcutIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Shortcut.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Shortcut.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShortcutImpl extends Shortcut {
  _ShortcutImpl({
    int? id,
    required String triggerPhrase,
    required List<String> actions,
    String? description,
    required DateTime createdAt,
  }) : super._(
         id: id,
         triggerPhrase: triggerPhrase,
         actions: actions,
         description: description,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Shortcut]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Shortcut copyWith({
    Object? id = _Undefined,
    String? triggerPhrase,
    List<String>? actions,
    Object? description = _Undefined,
    DateTime? createdAt,
  }) {
    return Shortcut(
      id: id is int? ? id : this.id,
      triggerPhrase: triggerPhrase ?? this.triggerPhrase,
      actions: actions ?? this.actions.map((e0) => e0).toList(),
      description: description is String? ? description : this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ShortcutUpdateTable extends _i1.UpdateTable<ShortcutTable> {
  ShortcutUpdateTable(super.table);

  _i1.ColumnValue<String, String> triggerPhrase(String value) =>
      _i1.ColumnValue(
        table.triggerPhrase,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> actions(List<String> value) =>
      _i1.ColumnValue(
        table.actions,
        value,
      );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class ShortcutTable extends _i1.Table<int?> {
  ShortcutTable({super.tableRelation}) : super(tableName: 'shortcut') {
    updateTable = ShortcutUpdateTable(this);
    triggerPhrase = _i1.ColumnString(
      'triggerPhrase',
      this,
    );
    actions = _i1.ColumnSerializable<List<String>>(
      'actions',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final ShortcutUpdateTable updateTable;

  late final _i1.ColumnString triggerPhrase;

  late final _i1.ColumnSerializable<List<String>> actions;

  late final _i1.ColumnString description;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    triggerPhrase,
    actions,
    description,
    createdAt,
  ];
}

class ShortcutInclude extends _i1.IncludeObject {
  ShortcutInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Shortcut.t;
}

class ShortcutIncludeList extends _i1.IncludeList {
  ShortcutIncludeList._({
    _i1.WhereExpressionBuilder<ShortcutTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Shortcut.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Shortcut.t;
}

class ShortcutRepository {
  const ShortcutRepository._();

  /// Returns a list of [Shortcut]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Shortcut>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShortcutTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShortcutTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShortcutTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Shortcut>(
      where: where?.call(Shortcut.t),
      orderBy: orderBy?.call(Shortcut.t),
      orderByList: orderByList?.call(Shortcut.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Shortcut] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Shortcut?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShortcutTable>? where,
    int? offset,
    _i1.OrderByBuilder<ShortcutTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShortcutTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Shortcut>(
      where: where?.call(Shortcut.t),
      orderBy: orderBy?.call(Shortcut.t),
      orderByList: orderByList?.call(Shortcut.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Shortcut] by its [id] or null if no such row exists.
  Future<Shortcut?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Shortcut>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Shortcut]s in the list and returns the inserted rows.
  ///
  /// The returned [Shortcut]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Shortcut>> insert(
    _i1.Session session,
    List<Shortcut> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Shortcut>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Shortcut] and returns the inserted row.
  ///
  /// The returned [Shortcut] will have its `id` field set.
  Future<Shortcut> insertRow(
    _i1.Session session,
    Shortcut row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Shortcut>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Shortcut]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Shortcut>> update(
    _i1.Session session,
    List<Shortcut> rows, {
    _i1.ColumnSelections<ShortcutTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Shortcut>(
      rows,
      columns: columns?.call(Shortcut.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Shortcut]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Shortcut> updateRow(
    _i1.Session session,
    Shortcut row, {
    _i1.ColumnSelections<ShortcutTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Shortcut>(
      row,
      columns: columns?.call(Shortcut.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Shortcut] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Shortcut?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ShortcutUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Shortcut>(
      id,
      columnValues: columnValues(Shortcut.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Shortcut]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Shortcut>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ShortcutUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ShortcutTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShortcutTable>? orderBy,
    _i1.OrderByListBuilder<ShortcutTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Shortcut>(
      columnValues: columnValues(Shortcut.t.updateTable),
      where: where(Shortcut.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Shortcut.t),
      orderByList: orderByList?.call(Shortcut.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Shortcut]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Shortcut>> delete(
    _i1.Session session,
    List<Shortcut> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Shortcut>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Shortcut].
  Future<Shortcut> deleteRow(
    _i1.Session session,
    Shortcut row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Shortcut>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Shortcut>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ShortcutTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Shortcut>(
      where: where(Shortcut.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShortcutTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Shortcut>(
      where: where?.call(Shortcut.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
